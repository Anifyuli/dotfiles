-- Keymaps
-- Keymaps for better default experience
-- Add mapping support with calling vim.keymap.set
local map = vim.keymap.set

-- Diagnostic keymaps
map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
map('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

local function tmux_cmd(tag)
  return { "sh", "-c", "tmux new-session -A -s nvimterm #" .. tag }
end

map("n", "<leader>Th", function()
  require("snacks").terminal.toggle(tmux_cmd("h"), { win = { position = "bottom" } })
end, { desc = " Terminal horizontal" })
map("n", "<leader>Tv", function()
  require("snacks").terminal.toggle(tmux_cmd("v"), { win = { position = "right" } })
end, { desc = " Terminal vertical" })
map("n", "<leader>Tf", function()
  require("snacks").terminal.toggle(tmux_cmd("f"), { win = { position = "float" } })
end, { desc = " Terminal float" })
map({ "n", "t" }, "<F7>", function()
  require("snacks").terminal.toggle()
end, { desc = "Toggle terminal" })

-- Terminal picker: reopen hidden terminals (e.g. after edgy close)
map("n", "<leader>Tt", function()
  local terminals = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == "terminal" then
      local name = vim.fn.bufname(buf)
      table.insert(terminals, { buf = buf, name = name ~= "" and name or "[No Name]" })
    end
  end
  if #terminals == 0 then
    vim.notify("No terminal buffers", vim.log.levels.INFO)
    return
  end
  vim.ui.select(terminals, {
    prompt = "Select terminal",
    format_item = function(item) return item.name end,
  }, function(choice)
    if choice then vim.api.nvim_win_set_buf(0, choice.buf) end
  end)
end, { desc = "Terminal picker" })

-- Remove terminal buffers
map({ "n", "t" }, "<M-.>", function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == "terminal" then
      vim.cmd.bdelete({ args = { buf }, bang = true })
    end
  end
end, { desc = "Exit from (all) Terminals" })
map({ "n", "t" }, "<M-,>", function()
  local current_buf = vim.api.nvim_get_current_buf()
  local filetype = vim.bo[current_buf].buftype
  if filetype == "terminal" then
    vim.cmd("bdelete! " .. current_buf)
  end
end, { noremap = true, desc = "Exit from (active) Terminal" })

-- Adjust delete keymaps
map("v", "<Del>", [["_d]], { desc = "Blackhole delete" })

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
-- Handled by vim-tmux-navigator (see coding.lua)

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Quit additional keymaps
map("n", "<leader>Q", "<cmd>confirm qall<cr>", { desc = "[Q]uit all" })
map("n", "<leader>n", "<cmd>enew<cr>", { desc = "[N]ew File" })
map("n", "<C-s>", "<cmd>w!<cr>", { desc = "Force write" })
map("n", "<C-q>", "<cmd>qa!<cr>", { desc = "Force quit" })

-- Bufferline keymaps (ganti dari cokeline)
map("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Cycle prev buffer" })
map("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Cycle next buffer" })
map("n", "<Leader>bp", "<Cmd>BufferLineMovePrev<CR>", { silent = true, desc = "Move buffer prev" })
map("n", "<Leader>bn", "<Cmd>BufferLineMoveNext<CR>", { silent = true, desc = "Move buffer next" })

for i = 1, 9 do
  map(
    "n",
    ("<leader>b<F%s>"):format(i),
    ("<Cmd>BufferLineGoToBuffer %s<CR>"):format(i),
    { silent = true, desc = "Buffer focus " .. i }
  )
  map(
    "n",
    ("<Leader>b%s"):format(i),
    ("<Cmd>BufferLineMoveTo %s<CR>"):format(i),
    { silent = true, desc = "Buffer move " .. i }
  )
end

-- Buffer managements
map(
  'n', '<leader>bd',
  function()
    local bd = require('mini.bufremove').delete
    if vim.bo.modified then
      local choice = vim.fn.confirm(('Save changes to %q?'):format(vim.fn.bufname()), '&Yes\n&No\n&Cancel')
      if choice == 1 then -- Yes
        vim.cmd.write()
        bd(0)
      elseif choice == 2 then -- No
        bd(0, true)
      end
    else
      bd(0)
    end
  end, { desc = 'Delete Buffer' })
map('n', '<leader>bD',
  function()
    require('mini.bufremove').delete(0, true)
  end,
  { desc = 'Delete Buffer (Force)' })

-- [[ Code Editing Keymaps ]]

-- Format buffer
map('n', '<leader>cf', vim.lsp.buf.format, { desc = '[F]ormat buffer' })

-- Toggle quickfix list
map('n', '<leader>cx', function()
  local qf_exists = false
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == 'qf' then
      qf_exists = true
      break
    end
  end
  if qf_exists then
    vim.cmd('cclose')
  else
    vim.cmd('copen')
  end
end, { desc = 'Toggle Quickfix li[x]' })

-- Show line diagnostics in floating window
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line [D]iagnostics' })

-- LSP info
map('n', '<leader>cl', function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    vim.notify('No LSP clients attached')
    return
  end
  local info = {}
  for _, c in ipairs(clients) do
    table.insert(info, c.name)
  end
  vim.notify(table.concat(info, ', '), 'info', { title = 'LSP Info' })
end, { desc = 'LSP [I]nfo' })

-- User commands
vim.api.nvim_create_user_command('Format', vim.lsp.buf.format, { desc = 'Format buffer using LSP' })
vim.api.nvim_create_user_command('ToggleQuickfix', function()
  local qf_open = false
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == 'qf' then
      qf_open = true
      break
    end
  end
  if qf_open then vim.cmd('cclose') else vim.cmd('copen') end
end, { desc = 'Toggle quickfix window' })
vim.api.nvim_create_user_command('LineDiagnostics', vim.diagnostic.open_float, { desc = 'Show diagnostics for current line' })
vim.api.nvim_create_user_command('LspRestart', function()
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    local config = vim.deepcopy(client.config)
    client:stop()
    vim.lsp.start(config)
  end
end, { desc = 'Restart LSP clients for current buffer' })

-- Task picker / debug runner
map('n', '<leader>dd', function()
  require('pickers.task-picker').pick_and_run()
end, { desc = 'Debug: pick and run' })
-- Reopen task terminal without restarting (e.g. after accidental edgy close)
map('n', '<leader>dD', function()
  require('pickers.task-picker').reopen_task_terminal()
end, { desc = 'Debug: reopen task terminal' })

-- vim: ts=2 sts=2 sw=2 et
