-- Options

local g = vim.g
local opt = vim.opt

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

opt.hlsearch = false
opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.breakindent = true
opt.undofile = true
opt.undolevels = 10000
opt.directory = "/tmp//"
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = "yes"
opt.updatetime = 200
opt.timeoutlen = 300
opt.completeopt = "menuone,noselect"
opt.termguicolors = true
opt.confirm = true
opt.cursorline = true
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.wrap = true

opt.fillchars:append({ eob = " " })

-- Code folding with tree-sitter (only for filetypes that benefit)
opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
vim.opt.fillchars:append({ foldopen = "▾", foldclose = "▸", fold = " ", foldsep = "│" })

-- Let edgy handle window sizing (equalalways conflicts with edgy proportions)
opt.equalalways = false
-- Must be set BEFORE any windows are created, otherwise window-local
-- statusline rows become dead space when switching from laststatus=2 to 3
opt.laststatus = 3
opt.splitkeep = "screen"
opt.winminheight = 1

-- vim: ts=2 sts=2 sw=2 et
