local M = {}

local exclude_labels = { "install", "deploy" }

local function should_include(label)
  if type(label) ~= "string" or label == "" then return false end
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

local function run_in_term(cmd, cwd, task_id)
  local shell = vim.o.shell or "sh"
  local opts = {
    win = { position = "bottom", height = 0.3 },
  }
  if cwd and cwd ~= "" and cwd ~= "." then
    opts.cwd = cwd
  end

  local term, created
  if task_id then
    -- persistent terminal per task: reuse & reset
    local task_opts = vim.deepcopy(opts)
    task_opts.count = task_id
    term, created = Snacks.terminal.get(shell, task_opts)
  else
    -- one-shot terminal for unnamed tasks
    local tagged = cmd .. " #" .. (vim.uv or vim.loop).hrtime()
    term, created = Snacks.terminal.get({ "sh", "-c", tagged }, opts)
  end

  if not term then return end
  term:show():focus()

  local buf = term.buf
  if buf and vim.api.nvim_buf_is_valid(buf) then
    local job_id = vim.b[buf].terminal_job_id
    if job_id and task_id then
      -- reset previous run and send command fresh
      if not created then
        vim.fn.chansend(job_id, "\x03")
        vim.wait(50, function() return false end)
      end
      local prefix = ""
      if cwd and cwd ~= "" and cwd ~= "." then
        prefix = "cd " .. vim.fn.shellescape(cwd) .. " && "
      end
      vim.fn.chansend(job_id, prefix .. cmd .. "\n")
    end
  end
end

local function collect_package_scripts()
  local data = read_json("package.json")
  if not data or not data.scripts then return {} end
  local results = {}
  for name, script in pairs(data.scripts) do
    local label = type(name) == "string" and name or ""
    if should_include(label) then
      table.insert(results, { source = "npm", label = label, text = label, description = type(script) == "string" and script or "" })
    end
  end
  table.sort(results, function(a, b) return a.label < b.label end)
  return results
end

local function collect_mise_tasks()
  local results = {}
  local seen = {}

  local dirs = vim.fn.systemlist(
    "find . -name 'mise.toml' -not -path '*/node_modules/*' -not -path '*/.git/*' -printf '%h\\n' 2>/dev/null"
  )

  if not dirs or #dirs == 0 then
    dirs = { "." }
  else
    table.sort(dirs)
  end

  for _, dir in ipairs(dirs) do
    if dir and dir ~= "" then
      local cmd = "cd " .. vim.fn.shellescape(dir) .. " && mise tasks ls --json 2>/dev/null"
      local handle = io.popen(cmd)
      if handle then
        local output = handle:read("*a")
        handle:close()
        if output ~= "" then
          local ok, tasks = pcall(vim.json.decode, output)
          if ok and tasks then
          for _, t in ipairs(tasks) do
            local label = type(t.name) == "string" and t.name or ""
            if should_include(label) and not seen[label] then
              seen[label] = true
              table.insert(results, {
                source = "mise",
                label = label,
                text = label,
                description = type(t.description) == "string" and t.description or "",
                dir = dir,
              })
            end
          end
          end
        end
      end
    end
  end

  return results
end

local function collect_vscode_tasks()
  local data = read_json(".vscode/tasks.json")
  if not data or not data.tasks then return {} end
  local results = {}
  for _, t in ipairs(data.tasks) do
    local label = type(t.label) == "string" and t.label or ""
    if should_include(label) then
      table.insert(results, { source = "vscode", label = label, text = label, description = type(t.detail) == "string" and t.detail or type(t.command) == "string" and t.command or "" })
    end
  end
  return results
end

local function collect_launch_configs()
  local data = read_json(".vscode/launch.json")
  if data and data.configurations then
    local results = {}
    for _, c in ipairs(data.configurations) do
      local label = type(c.name) == "string" and c.name or ""
      if should_include(label) then
        table.insert(results, { source = "launch", label = label, text = label, description = type(c.type) == "string" and c.type or "" })
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
      local label = type(c.label) == "string" and c.label or ""
      if should_include(label) then
        table.insert(results, { source = "zed", label = label, text = label, description = type(c.type) == "string" and c.type or "" })
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
          local label = type(t.label) == "string" and t.label or type(t.name) == "string" and t.name or f
          table.insert(entries, { source = "taskfile", label = label, text = label, description = type(t.description) == "string" and t.description or type(t.detail) == "string" and t.detail or "" })
        end
      elseif content.command or content.run then
        local label = type(content.label) == "string" and content.label or type(content.name) == "string" and content.name or f
        table.insert(entries, { source = "taskfile", label = label, text = label, description = type(content.description) == "string" and content.description or type(content.detail) == "string" and content.detail or "" })
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
  local dap_ok = dap.adapters and dap.adapters["pwa-node"] ~= nil

  local results = {}

  if dap_ok then
    table.insert(results, { source = "dap", label = "Launch file", text = "Launch file", run = dap_run("Launch file") })
    table.insert(results, {
      source = "dap", label = "Attach to process", text = "Attach to process",
      run = function()
        dap.run({
          type = "pwa-node", request = "attach", name = "Attach to process",
          processId = require("dap.utils").pick_process, cwd = vim.fn.getcwd(),
          skipFiles = { "<node_internals>/**", "node_modules/**" },
        })
      end,
    })
  end

  for _, s in ipairs(collect_package_scripts()) do
    s.run = function()
      run_in_term("npm run " .. s.label, nil, s.label)
    end
    table.insert(results, s)
  end

  for _, task in ipairs(collect_mise_tasks()) do
    local task_dir = task.dir
    task.run = function()
      local cwd = task_dir ~= "." and (vim.fn.getcwd() .. "/" .. task_dir) or nil
      run_in_term("mise run " .. task.label, cwd, task.label)
    end
    table.insert(results, task)
  end

  for _, task in ipairs(collect_vscode_tasks()) do
    task.run = function()
      run_in_term("npm run " .. task.label, nil, task.label)
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
      local cmd = c and c.command or ""
      if cmd ~= "" then
        local program = c and c.program or "."
        local file = vim.fn.expand("%:p") or "."
        cmd = cmd:gsub("%${file}", file):gsub("%${workspaceFolder}", vim.fn.getcwd())
        run_in_term(cmd .. (c.args and " " .. c.args or ""), nil, entry.label)
      end
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
      if c then
        local cmd = type(c.command) == "string" and c.command or c.program or ""
        if cmd ~= "" then
          local file = vim.fn.expand("%:p") or "."
          cmd = cmd:gsub("%$ZED_FILE", file):gsub("%$ZED_WORKTREE_ROOT", vim.fn.getcwd())
          run_in_term(cmd .. (c.args and " " .. c.args or ""), nil, entry.label)
        end
      end
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
      if cmd ~= "" then
        run_in_term(cmd, nil, entry.label)
      end
    end
    table.insert(results, entry)
  end

  local icons = {
    mise = "⚡", npm = "", dap = "▸",
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
    preview = function(ctx)
      local item = ctx.item
      if not item then return end
      local lines = {}
      table.insert(lines, "Source: " .. (item.source or "?"))
      table.insert(lines, "Task:   " .. (item.label or "?"))
      if item.dir and item.dir ~= "" and item.dir ~= "." then
        table.insert(lines, "Dir:    " .. item.dir)
      end
      if item.description and item.description ~= "" then
        table.insert(lines, "")
        table.insert(lines, item.description)
      end
      ctx.preview:reset()
      ctx.preview:set_lines(lines)
    end,
  })
end

return M
