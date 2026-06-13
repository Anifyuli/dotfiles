local M = {}

M.task_mode = "neovim" -- "neovim" | "tmux"; toggle via <leader>dt

local exclude_labels = { "install", "deploy" }
local task_terms = {} -- task_id -> Snacks terminal object (neovim mode)
local last_tmux_task = nil -- last task tag for <leader>dD in tmux mode

-- cache
local picker_cache = {}
local PICKER_CACHE_TTL_MS = 30000
local mise_cache = nil
local mise_cache_time = 0
local MISE_CACHE_TTL_MS = 300000

local function cache_key()
  return vim.fn.getcwd()
end

local function cache_get(key)
  local entry = picker_cache[key]
  if not entry then
    return nil
  end
  if vim.uv.now() - entry.time > PICKER_CACHE_TTL_MS then
    picker_cache[key] = nil
    return nil
  end
  return entry.results
end

local function cache_set(key, results)
  picker_cache[key] = { results = results, time = vim.uv.now() }
end

local function invalidate_task_caches()
  picker_cache = {}
  mise_cache = nil
end

local cache_augroup = vim.api.nvim_create_augroup("TaskPickerCache", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  group = cache_augroup,
  pattern = {
    "package.json",
    "mise.toml",
    ".vscode/tasks.json",
    ".vscode/launch.json",
    ".zed/debug.json",
  },
  callback = invalidate_task_caches,
})
vim.api.nvim_create_autocmd("DirChanged", {
  group = cache_augroup,
  callback = invalidate_task_caches,
})

local function should_include(label)
  if type(label) ~= "string" or label == "" then
    return false
  end
  for _, pattern in ipairs(exclude_labels) do
    if label:lower():find(pattern, 1, true) then
      return false
    end
  end
  return true
end

local function read_json(path)
  local f = io.open(path, "r")
  if not f then
    return nil
  end
  local ok, data = pcall(vim.json.decode, f:read("*a"))
  f:close()
  return ok and data or nil
end

local TASKS_SESSION = "nvim-tasks"

local function is_in_tmux()
  return vim.env.TMUX ~= nil
end

local function ensure_tmux_session()
  local ok = pcall(vim.fn.system, { "tmux", "has-session", "-t", TASKS_SESSION })
  if not ok then
    vim.fn.system({ "tmux", "new-session", "-d", "-s", TASKS_SESSION })
  end
end

local function stop_tmux_task(tag)
  if not tag then
    return
  end
  pcall(vim.fn.system, { "tmux", "kill-window", "-t", TASKS_SESSION .. ":" .. tag })
end

---Stop and delete a task terminal cleanly, without triggering exit notifications.
local function stop_task_term(term)
  local buf = (type(term) == "table" and term.buf) or (type(term) == "number" and term)
  if not (buf and vim.api.nvim_buf_is_valid(buf)) then
    return
  end
  local ok, chan = pcall(function()
    return vim.bo[buf].channel
  end)
  if ok and type(chan) == "number" and chan > 0 then
    pcall(vim.fn.jobstop, chan)
  end
  pcall(vim.api.nvim_buf_delete, buf, { force = true })
end

local function run_in_term(cmd, cwd, task_id)
  local tag = task_id or tostring((vim.uv or vim.loop).hrtime())

  if M.task_mode == "tmux" then
    ensure_tmux_session()
    stop_tmux_task(tag)

    local args = { "tmux", "new-window", "-t", TASKS_SESSION, "-n", tag }
    if cwd and cwd ~= "" and cwd ~= "." then
      table.insert(args, "-c")
      table.insert(args, cwd)
    end
    local shell = vim.o.shell or "sh"
    table.insert(args, shell)
    table.insert(args, "-c")
    table.insert(args, cmd)
    vim.fn.system(args)

    if is_in_tmux() then
      vim.fn.system({ "tmux", "select-window", "-t", TASKS_SESSION .. ":" .. tag })
    end

    if task_id then
      last_tmux_task = tag
      task_terms[task_id] = nil
    end
    return
  end

  -- Neovim mode (Snacks terminal)
  local buf = nil
  if task_id and task_terms[task_id] then
    buf = (type(task_terms[task_id]) == "table" and task_terms[task_id].buf) or task_terms[task_id]
  end

  if buf and vim.api.nvim_buf_is_valid(buf) then
    -- always kill and recreate, regardless of window visibility
    stop_task_term(task_terms[task_id])
    task_terms[task_id] = nil
  end

  local shell = vim.o.shell or "sh"

  local opts = {
    -- `interactive = false`:
    --   • Opens in normal mode (scroll/copy without <C-\><C-n>)
    --   • Suppresses Snacks' "Terminal exited with code -1" notification on kill
    --     (the job exit is visible in the terminal buffer output instead)
    interactive = false,
    win = { position = "bottom", height = 0.3 },
  }
  if cwd and cwd ~= "" and cwd ~= "." then
    opts.cwd = cwd -- Snacks sets initial directory via termopen; no "cd &&" prefix needed
  end

  -- The `#tag` suffix is a shell comment: it makes each run's command string
  -- unique so Snacks.terminal.get() always creates a fresh terminal instance
  -- instead of returning a cached one from a previous run.
  local term = Snacks.terminal.get({ shell, "-c", cmd .. " #" .. tag }, opts)
  if term then
    term:show():focus()
    if task_id then
      task_terms[task_id] = term
    end
  end
end

local function collect_package_scripts()
  local data = read_json("package.json")
  if not data or not data.scripts then
    return {}
  end
  local results = {}
  for name, script in pairs(data.scripts) do
    local label = type(name) == "string" and name or ""
    if should_include(label) then
      table.insert(results, {
        source = "npm",
        label = label,
        text = label,
        description = type(script) == "string" and script or "",
      })
    end
  end
  table.sort(results, function(a, b)
    return a.label < b.label
  end)
  return results
end

local function collect_mise_tasks()
  if mise_cache_time > 0 and vim.uv.now() - mise_cache_time < MISE_CACHE_TTL_MS then
    return mise_cache
  end

  local results = {}
  local seen = {}

  local dirs = {}
  local handle =
    io.popen("find . -name 'mise.toml' -not -path '*/node_modules/*' -not -path '*/.git/*' -printf '%h\\n' 2>/dev/null")
  if handle then
    for line in handle:lines() do
      if line ~= "" then
        table.insert(dirs, line)
      end
    end
    handle:close()
  end

  if #dirs == 0 then
    dirs = { "." }
  else
    table.sort(dirs)
  end

  for _, dir in ipairs(dirs) do
    if dir ~= "" then
      local h = io.popen("cd " .. vim.fn.shellescape(dir) .. " && mise tasks ls --json 2>/dev/null")
      if h then
        local output = h:read("*a")
        h:close()
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

  mise_cache = results
  mise_cache_time = vim.uv.now()
  return results
end

local function collect_vscode_tasks()
  local data = read_json(".vscode/tasks.json")
  if not data or not data.tasks then
    return {}
  end
  local results = {}
  for _, t in ipairs(data.tasks) do
    local label = type(t.label) == "string" and t.label or ""
    if should_include(label) then
      table.insert(results, {
        source = "vscode",
        label = label,
        text = label,
        description = (type(t.detail) == "string" and t.detail) or (type(t.command) == "string" and t.command) or "",
      })
    end
  end
  return results
end

local function collect_launch_configs()
  local data = read_json(".vscode/launch.json")
  if not (data and data.configurations) then
    return {}
  end
  local results = {}
  for _, c in ipairs(data.configurations) do
    local label = type(c.name) == "string" and c.name or ""
    if should_include(label) then
      table.insert(results, {
        source = "launch",
        label = label,
        text = label,
        description = type(c.type) == "string" and c.type or "",
      })
    end
  end
  return results
end

local function collect_zed_debug()
  local data = read_json(".zed/debug.json")
  if not (data and type(data) == "table" and data[1]) then
    return {}
  end
  local results = {}
  for _, c in ipairs(data) do
    local label = type(c.label) == "string" and c.label or ""
    if should_include(label) then
      table.insert(results, {
        source = "zed",
        label = label,
        text = label,
        description = type(c.type) == "string" and c.type or "",
      })
    end
  end
  return results
end

local function collect_taskfiles()
  local taskdir = vim.fn.stdpath("config") .. "/tasks"
  local ok, files = pcall(vim.fn.readdir, taskdir)
  if not ok then
    return {}
  end
  local entries = {}
  for _, f in ipairs(files) do
    local content = read_json(taskdir .. "/" .. f)
    if content then
      local items = (type(content) == "table" and content[1]) and content or { content }
      for _, t in ipairs(items) do
        -- Only include entries that actually have a runnable command
        if t.command or t.run then
          local label = (type(t.label) == "string" and t.label) or (type(t.name) == "string" and t.name) or f
          table.insert(entries, {
            source = "taskfile",
            label = label,
            text = label,
            description = (type(t.description) == "string" and t.description)
              or (type(t.detail) == "string" and t.detail)
              or "",
          })
        end
      end
    end
  end
  return entries
end

---Build an argument string from a launch.json/zed `args` field.
---Handles both string ("--flag value") and array ({"--flag", "value"}) forms.
local function build_args_str(args)
  if type(args) == "string" and args ~= "" then
    return " " .. args
  elseif type(args) == "table" then
    local parts = {}
    for _, a in ipairs(args) do
      if type(a) == "string" then
        table.insert(parts, a)
      end
    end
    return #parts > 0 and (" " .. table.concat(parts, " ")) or ""
  end
  return ""
end

local icons = {
  mise = "\u{f013}", -- gear
  npm = "\u{e71e}", -- npm
  dap = "\u{f188}", -- bug
  vscode = "\u{f121}", -- code
  launch = "\u{f135}", -- rocket
  zed = "\u{f121}", -- code (same as vscode)
  taskfile = "\u{f15b}", -- file
}

local dap_run = function(label)
  local dap = require("dap")
  return function()
    dap.run({
      type = "pwa-node",
      request = "launch",
      name = label,
      program = "${file}",
      cwd = vim.fn.getcwd(),
      skipFiles = { "<node_internals>/**", "node_modules/**" },
    })
  end
end

local function mode_label()
  local icon = M.task_mode == "tmux" and "\u{ebc8}" or "\u{e6ae}" --  tmux /  neovim
  return icon .. "  " .. M.task_mode:sub(1, 1):upper() .. M.task_mode:sub(2)
end

local function show_picker(results)
  Snacks.picker.pick({
    items = results,
    format = function(item)
      local icon = icons[item.source] or "▸"
      local parts = {
        { icon .. " ", "String" },
        { item.label, "Normal" },
      }
      if item.description and item.description ~= "" then
        table.insert(parts, { "  " .. item.description, "Comment" })
      end
      return parts
    end,
    confirm = function(picker, item)
      picker:close()
      if item and item.run then
        item.run()
      end
    end,
    prompt = " ",
    title = "Tasks " .. mode_label(),
    preview = function(ctx)
      local item = ctx.item
      if not item then
        return
      end
      local lines = {
        "Source : " .. (item.source or "?"),
        "Task   : " .. (item.label or "?"),
      }
      if item.dir and item.dir ~= "" and item.dir ~= "." then
        table.insert(lines, "Dir    : " .. item.dir)
      end
      table.insert(lines, "")
      table.insert(lines, mode_label())
      if item.description and item.description ~= "" then
        table.insert(lines, "")
        table.insert(lines, item.description)
      end
      ctx.preview:reset()
      ctx.preview:set_lines(lines)
    end,
  })
end

local function collect_all_tasks(dap_ok)
  local results = {}

  if dap_ok then
    table.insert(results, {
      source = "dap",
      label = "Launch file",
      text = "Launch file",
      run = dap_run("Launch file"),
    })
    table.insert(results, {
      source = "dap",
      label = "Attach to process",
      text = "Attach to process",
      run = function()
        dap.run({
          type = "pwa-node",
          request = "attach",
          name = "Attach to process",
          processId = require("dap.utils").pick_process,
          cwd = vim.fn.getcwd(),
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
    local dir = task.dir
    task.run = function()
      local cwd = (dir and dir ~= ".") and (vim.fn.getcwd() .. "/" .. dir) or nil
      run_in_term("mise run " .. task.label, cwd, task.label)
    end
    table.insert(results, task)
  end

  for _, task in ipairs(collect_vscode_tasks()) do
    local task_label = task.label
    task.run = function()
      local data = read_json(".vscode/tasks.json")
      local c
      if data and data.tasks then
        for _, t in ipairs(data.tasks) do
          if t.label == task_label then
            c = t
            break
          end
        end
      end
      local cmd
      if c then
        if c.type == "npm" then
          cmd = "npm run " .. (type(c.script) == "string" and c.script or task_label)
        elseif type(c.command) == "string" and c.command ~= "" then
          cmd = c.command .. build_args_str(c.args)
        end
      end
      run_in_term(cmd or ("npm run " .. task_label), nil, task_label)
    end
    table.insert(results, task)
  end

  for _, entry in ipairs(collect_launch_configs()) do
    local entry_label = entry.label
    entry.run = function()
      local data = read_json(".vscode/launch.json")
      local c
      if data and data.configurations then
        for _, cfg in ipairs(data.configurations) do
          if cfg.name == entry_label then
            c = cfg
            break
          end
        end
      end
      if not c then
        return
      end
      local cmd = type(c.command) == "string" and c.command or ""
      if cmd ~= "" then
        local file = vim.fn.expand("%:p") or "."
        cmd = cmd:gsub("%${file}", file):gsub("%${workspaceFolder}", vim.fn.getcwd())
        cmd = cmd .. build_args_str(c.args)
        run_in_term(cmd, nil, entry_label)
      end
    end
    table.insert(results, entry)
  end

  for _, entry in ipairs(collect_zed_debug()) do
    local entry_label = entry.label
    entry.run = function()
      local data = read_json(".zed/debug.json")
      local c
      if data and data[1] then
        for _, cfg in ipairs(data) do
          if cfg.label == entry_label then
            c = cfg
            break
          end
        end
      end
      if not c then
        return
      end
      local cmd = (type(c.command) == "string" and c.command) or (type(c.program) == "string" and c.program) or ""
      if cmd ~= "" then
        local file = vim.fn.expand("%:p") or "."
        cmd = cmd:gsub("%$ZED_FILE", file):gsub("%$ZED_WORKTREE_ROOT", vim.fn.getcwd())
        cmd = cmd .. build_args_str(c.args)
        run_in_term(cmd, nil, entry_label)
      end
    end
    table.insert(results, entry)
  end

  for _, entry in ipairs(collect_taskfiles()) do
    local entry_label = entry.label
    entry.run = function()
      local taskdir = vim.fn.stdpath("config") .. "/tasks"
      local files = vim.fn.readdir(taskdir) or {}
      local c
      for _, f in ipairs(files) do
        local content = read_json(taskdir .. "/" .. f)
        if content then
          local items = (type(content) == "table" and content[1]) and content or { content }
          for _, t in ipairs(items) do
            if (t.label or t.name or f) == entry_label then
              c = t
              break
            end
          end
        end
        if c then
          break
        end
      end
      local cmd = (c and (c.command or c.run)) or ""
      if cmd ~= "" then
        run_in_term(cmd, nil, entry_label)
      end
    end
    table.insert(results, entry)
  end

  return results
end

-- Prewarm task cache after first buffer opens so <leader>dd feels instant
local prewarm_group = vim.api.nvim_create_augroup("TaskPrewarm", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
  group = prewarm_group,
  once = true,
  callback = function()
    vim.defer_fn(function()
      local key = cache_key()
      if not cache_get(key) then
        local dap_ok = false
        if package.loaded.dap then
          local dap = require("dap")
          dap_ok = dap.adapters and dap.adapters["pwa-node"] ~= nil
        end
        cache_set(key, collect_all_tasks(dap_ok))
      end
    end, 3000)
  end,
})

function M.pick_and_run()
  local dap_ok = false
  if package.loaded.dap then
    local dap = require("dap")
    dap_ok = dap.adapters and dap.adapters["pwa-node"] ~= nil
  end

  local key = cache_key()
  local cached = cache_get(key)
  if cached then
    local items = {}
    for _, item in ipairs(cached) do
      if item.source ~= "dap" or dap_ok then
        table.insert(items, item)
      end
    end
    show_picker(items)
    return
  end

  local results = collect_all_tasks(dap_ok)

  cache_set(key, results)
  show_picker(results)
end

--- Toggle between Neovim (Snacks terminal) and tmux execution mode.
function M.toggle_task_mode()
  if vim.fn.executable("tmux") ~= 1 then
    vim.notify("tmux binary not found", vim.log.levels.WARN)
    M.task_mode = "neovim"
    return
  end
  M.task_mode = M.task_mode == "neovim" and "tmux" or "neovim"
  local msg = M.task_mode == "tmux" and "tmux (persistent)" or "Neovim (Snacks terminal)"
  vim.notify("Task mode: " .. msg)
end

--- Reopen the last task terminal window without restarting the task.
--- Useful when the terminal was accidentally closed via edgy's close button.
function M.reopen_task_terminal()
  if M.task_mode == "tmux" then
    if last_tmux_task then
      if is_in_tmux() then
        pcall(vim.fn.system, { "tmux", "select-window", "-t", TASKS_SESSION .. ":" .. last_tmux_task })
      else
        vim.notify(
          "Task running in tmux session '" .. TASKS_SESSION .. "' — attach with: tmux attach -t " .. TASKS_SESSION,
          vim.log.levels.INFO
        )
      end
    else
      vim.notify("No tmux task window", vim.log.levels.INFO)
    end
    return
  end

  for _, term in pairs(task_terms) do
    local buf = (type(term) == "table" and term.buf) or term
    if buf and vim.api.nvim_buf_is_valid(buf) then
      if type(term) == "table" and term.show then
        term:show():focus()
      end
      return
    end
  end
  vim.notify("No running task terminal", vim.log.levels.INFO)
end

return M
