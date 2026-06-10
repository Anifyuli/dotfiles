local M = {}

local exclude_labels = { "install", "deploy" }

local function should_include(label)
  for _, pattern in ipairs(exclude_labels) do
    if label:lower():find(pattern, 1, true) then
      return false
    end
  end
  return true
end

local function read_json(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local ok, data = pcall(vim.json.decode, f:read("*a"))
  f:close()
  return ok and data or nil
end

local function collect_package_scripts()
  local data = read_json("package.json")
  if not data or not data.scripts then return {} end
  local results = {}
  for name, script in pairs(data.scripts) do
    if should_include(name) then
      table.insert(results, { source = "npm", label = name, description = script })
    end
  end
  table.sort(results, function(a, b) return a.label < b.label end)
  return results
end

local function collect_mise_tasks()
  local handle = io.popen("mise tasks ls --json 2>/dev/null")
  if not handle then return {} end
  local output = handle:read("*a")
  handle:close()
  if output == "" then return {} end
  local ok, tasks = pcall(vim.json.decode, output)
  if not ok or not tasks then return {} end
  local results = {}
  for _, t in ipairs(tasks) do
    if should_include(t.name) then
      table.insert(results, { source = "mise", label = t.name, description = t.description or "" })
    end
  end
  return results
end

local function collect_vscode_tasks()
  local data = read_json(".vscode/tasks.json")
  if not data or not data.tasks then return {} end
  local results = {}
  for _, t in ipairs(data.tasks) do
    if should_include(t.label or "") then
      table.insert(results, { source = "vscode", label = t.label, description = t.detail or t.command or "" })
    end
  end
  return results
end

local function collect_launch_configs()
  local data = read_json(".vscode/launch.json")
  if data and data.configurations then
    local results = {}
    for _, c in ipairs(data.configurations) do
      if should_include(c.name or "") then
        table.insert(results, { source = "launch", label = c.name, description = c.type or "" })
      end
    end
    return results
  end
  return {}
end

local function collect_zed_debug()
  local data = read_json(".zed/debug.json")
  if not data or type(data) ~= "table" then return {} end
  local results = {}
  if data[1] then
    for _, c in ipairs(data) do
      if should_include(c.label or "") then
        table.insert(results, { source = "zed", label = c.label, description = c.type or "" })
      end
    end
  end
  return results
end

local function collect_taskfiles()
  local taskdir = vim.fn.stdpath("config") .. "/tasks"
  local ok, files = pcall(vim.fn.readdir, taskdir)
  if not ok then return {} end
  local entries = {}
  for _, f in ipairs(files) do
    local path = taskdir .. "/" .. f
    local content = read_json(path)
    if content then
      if type(content) == "table" and content[1] then
        for _, t in ipairs(content) do
          table.insert(entries, { source = "taskfile", label = t.label or t.name or f, description = t.description or t.detail or "" })
        end
      elseif content.command or content.run then
        table.insert(entries, { source = "taskfile", label = content.label or content.name or f, description = content.description or content.detail or "" })
      end
    end
  end
  return entries
end

local dap_run = function(label)
  local dap = require("dap")
  return function()
    dap.run({
      type = "pwa-node", request = "launch", name = label,
      program = "${file}", cwd = vim.fn.getcwd(),
      skipFiles = { "<node_internals>/**", "node_modules/**" },
    })
  end
end

function M.pick_and_run()
  local dap = require("dap")
  if not dap.adapters["pwa-node"] then
    vim.notify("DAP pwa-node adapter not available", vim.log.levels.ERROR)
    return
  end

  local results = {}

  table.insert(results, { source = "dap", label = "Launch file", run = dap_run("Launch file") })
  table.insert(results, {
    source = "dap", label = "Attach to process",
    run = function()
      dap.run({
        type = "pwa-node", request = "attach", name = "Attach to process",
        processId = require("dap.utils").pick_process, cwd = vim.fn.getcwd(),
        skipFiles = { "<node_internals>/**", "node_modules/**" },
      })
    end,
  })

  for _, s in ipairs(collect_package_scripts()) do
    s.run = function()
      dap.run({
        type = "pwa-node", request = "launch", name = s.label,
        runtimeExecutable = "npm", runtimeArgs = { "run", s.label },
        cwd = vim.fn.getcwd(),
        skipFiles = { "<node_internals>/**", "node_modules/**" },
      })
    end
    table.insert(results, s)
  end

  for _, task in ipairs(collect_mise_tasks()) do
    task.run = function()
      dap.run({
        type = "pwa-node", request = "launch", name = task.label,
        runtimeExecutable = "mise", runtimeArgs = { "run", task.label },
        cwd = vim.fn.getcwd(),
        skipFiles = { "<node_internals>/**", "node_modules/**" },
      })
    end
    table.insert(results, task)
  end

  for _, task in ipairs(collect_vscode_tasks()) do
    task.run = function()
      dap.run({
        type = "pwa-node", request = "launch", name = task.label,
        runtimeExecutable = "npm", runtimeArgs = { "run", task.label },
        cwd = vim.fn.getcwd(),
        skipFiles = { "<node_internals>/**", "node_modules/**" },
      })
    end
    table.insert(results, task)
  end

  for _, entry in ipairs(collect_launch_configs()) do
    entry.run = function()
      local data = read_json(".vscode/launch.json")
      local c
      if data and data.configurations then
        for _, cfg in ipairs(data.configurations) do
          if cfg.name == entry.label then c = cfg; break end
        end
      end
      dap.run({
        type = "pwa-node", request = (c and c.request) or "launch", name = entry.label,
        program = (c and c.program) or "${file}",
        runtimeExecutable = c and c.runtimeExecutable or nil,
        runtimeArgs = c and c.runtimeArgs or nil,
        cwd = vim.fn.getcwd(),
        skipFiles = { "<node_internals>/**", "node_modules/**" },
      })
    end
    table.insert(results, entry)
  end

  for _, entry in ipairs(collect_zed_debug()) do
    entry.run = function()
      local data = read_json(".zed/debug.json")
      local c
      if data and data[1] then
        for _, cfg in ipairs(data) do
          if cfg.label == entry.label then c = cfg; break end
        end
      end
      local prog = c and (c.program or ""):gsub("%$ZED_FILE", vim.fn.expand("%:p")):gsub("%$ZED_WORKTREE_ROOT", vim.fn.getcwd()) or "${file}"
      local adapter = (c and c.adapter == "JavaScript") and "pwa-node" or (c and c.adapter) or "pwa-node"
      dap.run({
        type = adapter, request = (c and c.request) or "launch", name = entry.label,
        program = prog, cwd = vim.fn.getcwd(),
        skipFiles = (c and c.skipFiles) or { "<node_internals>/**", "node_modules/**" },
      })
    end
    table.insert(results, entry)
  end

  for _, entry in ipairs(collect_taskfiles()) do
    entry.run = function()
      local taskdir = vim.fn.stdpath("config") .. "/tasks"
      local files = vim.fn.readdir(taskdir) or {}
      local c
      for _, f in ipairs(files) do
        local content = read_json(taskdir .. "/" .. f)
        if content then
          local items = type(content) == "table" and content[1] and content or { content }
          for _, t in ipairs(items) do
            local label = t.label or t.name or f
            if label == entry.label then c = t; break end
          end
        end
        if c then break end
      end
      local cmd = (c and (c.command or c.run)) or ""
      local parts = vim.split(cmd, " ")
      local exe = table.remove(parts, 1)
      dap.run({
        type = "pwa-node", request = "launch", name = entry.label,
        runtimeExecutable = exe, runtimeArgs = parts, cwd = vim.fn.getcwd(),
        skipFiles = { "<node_internals>/**", "node_modules/**" },
      })
    end
    table.insert(results, entry)
  end

  local icons = {
    dap = "▸", npm = "", mise = "⚡",
    vscode = "", launch = "", zed = "", taskfile = "",
  }

  Snacks.picker.pick({
    items = results,
    format = function(item)
      local icon = icons[item.source] or "▸"
      local text = icon .. " " .. item.label
      if item.description and item.description ~= "" then
        text = text .. "  " .. item.description
      end
      return { { text, "Normal" } }
    end,
    confirm = function(picker, item)
      picker:close()
      if item and item.run then item.run() end
    end,
    prompt = " ",
    title = "Debug",
  })
end

return M
