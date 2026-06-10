-- Set leader key for use which-key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Add luarocks path for magick rock
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua"
package.cpath = package.cpath .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/lib/lua/5.1/?.so"

-- Lazy.nvim bootstraping
require("core/lazy")

-- Lazy.nvim starter plugins
require("core/lazy-plugins")

-- Options
require("core/options")

-- Keymaps
require("core/keymaps")

-- Autocommands
require("core/autocmds")

-- vim: ts=2 sts=2 sw=2 et
