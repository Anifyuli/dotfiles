-- Autocommands
local function augroup(name)
  return vim.api.nvim_create_augroup('neovim_' .. name, { clear = true })
end

local autocmd = vim.api.nvim_create_autocmd

-- Close some filetypes with <q>
autocmd('FileType', {
  group = augroup('close_with_q'),
  pattern = {
    'PlenaryTestPopup',
    'help',
    'lspinfo',
    'man',
    'notify',
    'qf',
    'query',
    'spectre_panel',
    'startuptime',
    'tsplayground',
    'neotest-output',
    'checkhealth',
    'neotest-summary',
    'neotest-output-panel',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

-- Wrap and check for spell in text filetypes
autocmd('FileType', {
  group = augroup('wrap_spell'),
  pattern = { 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Fix conceallevel for json files
autocmd({ 'FileType' }, {
  group = augroup('json_conceal'),
  pattern = { 'json', 'jsonc', 'json5' },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
autocmd({ 'BufWritePre' }, {
  group = augroup('auto_create_dir'),
  callback = function(event)
    if event.match:match('^%w%w+://') then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- Changing components color using highlight
autocmd({ "ColorScheme", "VimEnter" }, {
  group = vim.api.nvim_create_augroup('Color', {}),
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "NeoTreeTabInactive", { fg = vim.g.terminal_color_7 })
    vim.api.nvim_set_hl(0, "NeoTreeTabSeparatorInactive", { fg = vim.g.terminal_color_7 })
    vim.api.nvim_set_hl(0, "NeoTreeTabSeparatorActive", { fg = vim.g.terminal_color_8 })
  end
})

-- Format on save via null-ls only (avoids LSP progress noise from tsserver)
autocmd("BufWritePre", {
  group = augroup("format_on_save"),
  callback = function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    for _, client in ipairs(clients) do
      if client.name == "null-ls" then
        vim.lsp.buf.format({ async = false, name = "null-ls" })
        return
      end
    end
  end
})

-- Clean up terminal buffers
autocmd("TermOpen", {
  group = augroup("terminal_cleanup"),
  callback = function()
    vim.b.snacks_indent = false
    vim.b.snacks_scroll = false
    vim.opt_local.list = false
    vim.opt_local.cursorline = false
  end,
})

-- JSX/TSX commentstring biar mini.comment pake {/**/}
autocmd("FileType", {
  group = augroup("jsx_comment"),
  pattern = { "typescriptreact", "javascriptreact" },
  callback = function()
    vim.bo.commentstring = "{/*%s*/}"
  end,
})

-- Suppress built-in LSP progress notifications (fidget.nvim handles them)
pcall(function() vim.lsp.handlers["$/progress"] = function() end end)

-- Fold sign on cursor line: shows ▾ (open) or ▸ (closed) in signcolumn
local fold_ns = vim.api.nvim_create_namespace("fold_sign")
local function update_fold_sign()
  if vim.wo.foldmethod ~= "expr" then return end
  local buf = vim.api.nvim_get_current_buf()
  pcall(vim.api.nvim_buf_del_extmark, buf, fold_ns, 0)
  local lnum = vim.fn.line(".")
  if vim.fn.foldlevel(lnum) > vim.fn.foldlevel(lnum - 1) then
    local closed = vim.fn.foldclosed(lnum)
    vim.api.nvim_buf_set_extmark(buf, fold_ns, lnum - 1, -1, {
      sign_text = (closed ~= -1) and "▸" or "▾",
      sign_hl_group = "Folded",
      priority = 200,
      id = 0,
    })
  end
end
autocmd({ "CursorMoved", "CursorMovedI" }, {
  group = augroup("fold_sign"),
  callback = update_fold_sign,
})

-- Auto-show diagnostic under cursor on hover (like VS Code error popup)
autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, {
      scope = "cursor",
      focusable = false,
      close_events = {
        "CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre",
        "BufLeave", "WinScrolled",
      },
    })
  end,
})
-- vim: ts=2 sts=2 sw=2 et
