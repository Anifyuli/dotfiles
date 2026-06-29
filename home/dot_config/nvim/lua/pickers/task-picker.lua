local M = {}

local STATE_FILE = vim.fn.stdpath("state") .. "/task_mode"
local function load_task_mode()
  local f = io.open(STATE_FILE, "r")
  if f then
    local mode = f:read("*l")
    f:close()
    if mode == "tmux" or mode == "neovim" then
      M.task_mode = mode
    end
  end
end
M.task_mode = "neovim" -- "neovim" | "tmux"; toggle via <leader>dt
load_task_mode()

local LAST_TASK_STATE_FILE = vim.fn.stdpath("state") .. "/last_tmux_task"
local function load_last_tmux_task()
  local f = io.open(LAST_TASK_STATE_FILE, "r")
  if f then
    local tag = f:read("*l")
    f:close()
    return (tag and tag ~= "") and tag or nil
  end
  return nil
end
local function save_last_tmux_task(tag)
  if not tag then return end
  local f = io.open(LAST_TASK_STATE_FILE, "w")
  if f then f:write(tag .. "\n"); f:close() end
end

local exclude_labels = { "install", "deploy" }
local task_terms = {} -- task_id -> buffer ID (neovim mode)
local last_tmux_task = nil -- last task tag for <leader>dD in tmux mode
local shared_tmux_term = nil -- single Snacks terminal for all tmux tasks
---@type {label: string, buf: number, id: string?}[]
local terminal_tabs = {} -- tab list for neovim mode (tabbed terminal panel)
local term_panel = { win = nil } -- single Neovim terminal window (neovim mode)
local _saved_tab_opts = {} -- original showtabline/tabline before we override

-- cache
local picker_cache = {}
local PICKER_CACHE_TTL_MS = 300000
local mise_cache = nil
local mise_cache_time = 0
local MISE_CACHE_TTL_MS = 600000

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
  mise_cache_time = 0
end

local cache_augroup = vim.api.nvim_create_augroup("TaskPickerCache", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  group = cache_augroup,
  pattern = {
    "package.json",
    "mise.toml",
    "mise.lock",
    ".vscode/tasks.json",
    ".vscode/launch.json",
    ".zed/debug.json",
    "~/.config/nvim/tasks/*.json",
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

local function ensure_tmux_session()
  vim.fn.system({ "tmux", "has-session", "-t", TASKS_SESSION })
  if vim.v.shell_error ~= 0 then
    vim.fn.system({ "tmux", "new-session", "-d", "-s", TASKS_SESSION })
    -- Rename default window so it can be reused later
    vim.fn.system({ "tmux", "rename-window", "-t", TASKS_SESSION .. ":0", "_" })
  end
end

local function stop_tmux_task(tag)
  if not tag then
    return
  end
  pcall(vim.fn.system, { "tmux", "kill-window", "-t", TASKS_SESSION .. ":" .. tag })
end

---Stop and delete a task terminal cleanly, without triggering exit notifications.
local function stop_task_term(buf)
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

---█ Shared terminal panel (Neovim mode) ──────────────────────────────

vim.api.nvim_set_hl(0, "TermTabActive", { link = "Title" })
vim.api.nvim_set_hl(0, "TermTabNew", { link = "String" })

local function __ensure_term_panel()
  if term_panel.win and vim.api.nvim_win_is_valid(term_panel.win) then
    return term_panel.win
  end
  vim.api.nvim_command("botright 12split")
  term_panel.win = vim.api.nvim_get_current_win()
  vim.wo[term_panel.win].winhighlight = "Normal:Terminal"
  __set_tabline()
  return term_panel.win
end

local function __open_term_buf_in_shared(cmd_list, label, task_id, cwd)
  local win = __ensure_term_panel()
  vim.api.nvim_set_current_win(win)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(win, buf)
  vim.bo[buf].filetype = "terminal"
  vim.bo[buf].scrollback = 50000

  if cmd_list then
    local opts = {}
    if cwd then opts.cwd = cwd end
    vim.fn.termopen(cmd_list, opts)
    vim.schedule(function()
      pcall(vim.api.nvim_buf_call, buf, function()
        vim.cmd("stopinsert")
      end)
    end)
  end

  table.insert(terminal_tabs, { label = label, buf = buf, id = task_id })
  __refresh_winbar()
  return buf
end

local function __build_tab_label(idx, tab)
  local icon = "    "
  local label = tab.label:len() > 18 and tab.label:sub(1, 15) .. "…" or tab.label
  local close = "%" .. (1000 + idx) .. "@TerminalTabHandler@ × %X"
  local tab_sw = "%" .. idx .. "@TerminalTabHandler@ " .. icon .. " " .. label .. " %X"
  return "%*TermTabActive*" .. close .. tab_sw .. "%*"
end

local function __set_tabline()
  if #terminal_tabs == 0 then
    if next(_saved_tab_opts) then
      vim.o.showtabline = _saved_tab_opts.showtabline
      vim.o.tabline = _saved_tab_opts.tabline
      _saved_tab_opts = {}
    end
    return
  end
  if not _saved_tab_opts.showtabline then
    _saved_tab_opts = { showtabline = vim.o.showtabline, tabline = vim.o.tabline }
  end
  vim.o.showtabline = 2
  local parts = {}
  for i, tab in ipairs(terminal_tabs) do
    table.insert(parts, __build_tab_label(i, tab))
  end
  table.insert(parts, " %*TermTabNew*%2000@TerminalTabHandler@ + %X%*")
  vim.o.tabline = table.concat(parts, "  ")
end

local function __refresh_winbar()
  __set_tabline()
end

local function __open_blank_term()
  __open_term_buf_in_shared({ vim.o.shell or "sh" }, "term", nil, vim.fn.getcwd())
end

local function __close_term_tab(idx)
  local tab = terminal_tabs[idx]
  if not tab then return end
  if tab.id and task_terms[tab.id] then
    stop_task_term(task_terms[tab.id])
    task_terms[tab.id] = nil
  else
    stop_task_term(tab.buf)
  end
  table.remove(terminal_tabs, idx)

  -- Show another tab or clear the shared window
  local win = term_panel.win
  if win and vim.api.nvim_win_is_valid(win) then
    local next_tab = terminal_tabs[math.min(idx, #terminal_tabs)]
    if next_tab and vim.api.nvim_buf_is_valid(next_tab.buf) then
      vim.api.nvim_win_set_buf(win, next_tab.buf)
    else
      vim.api.nvim_win_close(win, true)
      term_panel.win = nil
    end
  end
  __refresh_winbar()
end

local function __switch_term_tab(idx)
  local tab = terminal_tabs[idx]
  if not tab then return end
  local win = term_panel.win
  if not (win and vim.api.nvim_win_is_valid(win)) then
    win = __ensure_term_panel()
  end
  if vim.api.nvim_buf_is_valid(tab.buf) then
    vim.api.nvim_win_set_buf(win, tab.buf)
    vim.api.nvim_set_current_win(win)
  end
end

local function __create_or_show_tmux_term()
  local shell = vim.o.shell or "sh"
  local attach_cmd = "tmux attach-session -t " .. TASKS_SESSION .. "; true"
  local term = Snacks.terminal.get({ shell, "-c", attach_cmd }, {
    interactive = true,
    win = { position = "bottom", height = 0.3 },
  })
  if term then
    term:show():focus()
    vim.schedule(function()
      if term.win and vim.api.nvim_win_is_valid(term.win) then
        vim.wo[term.win].statusline = " tmux mode %= scroll: Ctrl+b [ "
      end
    end)
  end
  return term
end

function _G.TerminalTabHandler(minwid, clicks, button, mods)
  if button ~= 1 then return end
  vim.schedule(function()
    if minwid >= 2000 then
      __open_blank_term()
    elseif minwid >= 1000 then
      __close_term_tab(minwid - 1000)
    else
      __switch_term_tab(minwid)
    end
  end)
end

---█ ────────────────────────────────────────────────────────────────────

local function run_in_term(cmd, cwd, task_id)
  local tag = task_id or tostring((vim.uv or vim.loop).hrtime())

  if M.task_mode == "tmux" then
    ensure_tmux_session()
    stop_tmux_task(tag)

    local shell = vim.o.shell or "sh"

    -- Always use project root as cwd, so mise/npm tasks work regardless of tmux default dir
    local task_cwd = (cwd and cwd ~= "" and cwd ~= ".") and cwd or vim.fn.getcwd()

    -- Always use new-window so the command runs silently (no send-keys echo)
    local tmux_args = { "tmux", "new-window", "-c", task_cwd, "-t", TASKS_SESSION, "-n", tag }
    table.insert(tmux_args, shell)
    table.insert(tmux_args, "-c")
    -- keep shell alive after command so tmux window stays open
    table.insert(tmux_args, cmd .. "; exec " .. shell)
    vim.fn.system(tmux_args)

    -- Clean up placeholder window `_` if it was the initial window
    local windows = vim.fn.system({ "tmux", "list-windows", "-t", TASKS_SESSION, "-F", "#{window_name}" })
    if vim.tbl_contains(vim.split(vim.trim(windows), "\n"), "_") then
      vim.fn.system({ "tmux", "kill-window", "-t", TASKS_SESSION .. ":_" })
    end

    -- Switch the shared Snacks terminal window to the task's window
    vim.fn.system({ "tmux", "select-window", "-t", TASKS_SESSION .. ":" .. tag })

    -- Single shared Snacks terminal for all tmux tasks
    local attach_cmd = "tmux attach-session -t " .. TASKS_SESSION .. "; true"
    local ok, existing = pcall(function()
      return shared_tmux_term and shared_tmux_term.buf and vim.api.nvim_buf_is_valid(shared_tmux_term.buf) and vim.bo[shared_tmux_term.buf].channel > 0
    end)
    if ok and existing then
      local win = shared_tmux_term.win
      if win and vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_set_current_win(win)
      else
        shared_tmux_term:show():focus()
      end
    else
      -- Kill dead terminal reference, create fresh one
      if shared_tmux_term then
        pcall(shared_tmux_term.close, shared_tmux_term)
        shared_tmux_term = nil
      end
      shared_tmux_term = __create_or_show_tmux_term()
      if shared_tmux_term then
        shared_tmux_term:show():focus()
      end
    end

    if task_id then
      last_tmux_task = tag
      save_last_tmux_task(tag)
    end
    return
  end

  -- Neovim mode (shared terminal panel)
  if task_id and task_terms[task_id] then
    local old_buf = task_terms[task_id]
    if old_buf and vim.api.nvim_buf_is_valid(old_buf) then
      stop_task_term(old_buf)
    end
    task_terms[task_id] = nil
  end

  local shell = vim.o.shell or "sh"
  local tab_label = task_id or "task"
  local buf = __open_term_buf_in_shared({ shell, "-c", cmd .. " #" .. tag }, tab_label, task_id)
  if buf and task_id then
    task_terms[task_id] = buf
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
        -- Strip leading ./ so paths are clean (apps/admin not ./apps/admin)
        if line:sub(1, 2) == "./" then line = line:sub(3) end
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
      local h = io.popen("mise -C " .. vim.fn.shellescape(dir) .. " tasks ls --json 2>/dev/null")
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
  local icon = M.task_mode == "tmux" and "\u{ebc8}" or "\u{e6ae}"
  return icon .. " " .. M.task_mode:sub(1, 1):upper() .. M.task_mode:sub(2)
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
    title = "Task: " .. mode_label(),
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
      local cmd = "mise run " .. task.label
      if dir and dir ~= "." then
        cmd = "mise -C " .. vim.fn.shellescape(dir) .. " run " .. task.label
      end
      run_in_term(cmd, nil, task.label)
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

-- Prewarm task cache immediately so <leader>dd feels instant
local prewarm_done = false
local function dap_available()
  if not package.loaded.dap then return false end
  local dap = require("dap")
  return dap.adapters and dap.adapters["pwa-node"] ~= nil
end
vim.schedule(function()
  local key = cache_key()
  if not cache_get(key) then
    cache_set(key, collect_all_tasks(dap_available()))
  end
  prewarm_done = true
end)

-- Restore tmux session + shared terminal if Neovim was restarted
-- while tasks were still running in the nvim-tasks tmux session.
-- This ensures tasks survive Neovim crashes/OOM and can be reattached.
local function restore_tmux_session()
  if vim.fn.executable("tmux") ~= 1 then return end
  if M.task_mode ~= "tmux" then return end
  vim.fn.system({ "tmux", "has-session", "-t", TASKS_SESSION })
  if vim.v.shell_error ~= 0 then return end

  last_tmux_task = load_last_tmux_task()
  if not last_tmux_task then
    last_tmux_task = last_tmux_window()
  end

  local shell = vim.o.shell or "sh"
  local attach_cmd = "tmux attach-session -t " .. TASKS_SESSION .. "; true"
      shared_tmux_term = __create_or_show_tmux_term()
end
vim.schedule(restore_tmux_session)

function M.pick_and_run()
  local dap_ok = dap_available()
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

  -- Cache not ready yet: wait for prewarm
  if not prewarm_done then
    vim.notify("Loading tasks...", vim.log.levels.INFO, { timeout = 2000 })
    vim.defer_fn(function()
      local r = cache_get(cache_key())
      if r then
        M.pick_and_run()
      else
        -- Fallback: collect synchronously
        local results = collect_all_tasks(dap_ok)
        cache_set(key, results)
        show_picker(results)
      end
    end, 100)
    return
  end

  -- Cache expired, collect fresh
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
  local f = io.open(STATE_FILE, "w")
  if f then f:write(M.task_mode .. "\n"); f:close() end
  local msg = M.task_mode == "tmux" and "tmux (persistent)" or "Neovim (Snacks terminal)"
  vim.notify("Task mode: " .. msg)
end

--- Find the most recent window name in the tmux tasks session.
local function last_tmux_window()
  local output = vim.fn.system({ "tmux", "list-windows", "-t", TASKS_SESSION, "-F", "#{window_name}" })
  if vim.v.shell_error ~= 0 then return nil end
  local windows = vim.split(vim.trim(output), "\n")
  return windows[#windows]
end

--- Reopen the last task terminal window without restarting the task.
--- Useful when the terminal was accidentally closed via edgy's close button.
--- In tmux mode, re-creates the attached Snacks terminal if needed.
function M.reopen_task_terminal()
  if M.task_mode == "tmux" then
    -- Check if session exists
    vim.fn.system({ "tmux", "has-session", "-t", TASKS_SESSION })
    if vim.v.shell_error ~= 0 then
      vim.notify("No tmux task session", vim.log.levels.INFO)
      return
    end

    -- Resolve window tag: use last_tmux_task, or find latest window in session
    local tag = last_tmux_task
    if not tag then
      tag = last_tmux_window()
      if not tag then
        vim.notify("No windows in tmux session", vim.log.levels.INFO)
        return
      end
      last_tmux_task = tag
      save_last_tmux_task(tag)
    end

    -- Switch tmux to the target window
    vim.fn.system({ "tmux", "select-window", "-t", TASKS_SESSION .. ":" .. tag })

    -- Reuse shared Snacks terminal or create one
    local ok, existing = pcall(function()
      return shared_tmux_term and shared_tmux_term.buf and vim.api.nvim_buf_is_valid(shared_tmux_term.buf) and vim.bo[shared_tmux_term.buf].channel > 0
    end)
    if ok and existing then
      local win = shared_tmux_term.win
      if win and vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_set_current_win(win)
      else
        shared_tmux_term:show():focus()
      end
    else
      if shared_tmux_term then
        pcall(shared_tmux_term.close, shared_tmux_term)
        shared_tmux_term = nil
      end
      local shell = vim.o.shell or "sh"
      local attach_cmd = "tmux attach-session -t " .. TASKS_SESSION .. "; true"
      shared_tmux_term = __create_or_show_tmux_term()
      if shared_tmux_term then
        shared_tmux_term:show():focus()
      end
    end
    return
  end

  for i, tab in ipairs(terminal_tabs) do
    if tab.buf and vim.api.nvim_buf_is_valid(tab.buf) then
      __switch_term_tab(i)
      return
    end
  end
  vim.notify("No running task terminal", vim.log.levels.INFO)
end

M.term_panel = term_panel
M.terminal_tabs = terminal_tabs
M.new_terminal_tab = __open_blank_term

return M
