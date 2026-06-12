local function read_file(path)
  local f = io.open(vim.fn.expand(path), "r")
  if not f then return nil end
  local content = f:read("*a"):gsub("%s+", "")
  f:close()
  return content
end

local token = read_file("~/.config/nvim/.github_token")

require('lazy').setup({
    {
      -- Gruvbox colorscheme
      'ellisonleao/gruvbox.nvim',
      lazy = false,
      priority = 1000,
      opts = {
        italic = {
          strings = true,
          comments = true,
          folds = true,
          operations = false,
        },
        contrast = 'soft',
      },
      config = function(_, opts)
        local function detect_background()
          local f = io.open(vim.fn.expand("~/.config/kdeglobals"), "r")
          if not f then return end
          local content = f:read("*a")
          f:close()
          local scheme = content:match("ColorScheme%s*=%s*([^\n]+)")
          if scheme then
            vim.o.background = scheme:lower():find("dark") and "dark" or "light"
          end
        end
        detect_background()
        require("gruvbox").setup(opts)
        vim.cmd.colorscheme("gruvbox")
      end,
      -- stylua: ignore
      keys = {
        { "<leader>uT", function()
          vim.o.background = vim.o.background == "dark" and "light" or "dark"
          vim.cmd.colorscheme("gruvbox")
        end, desc = "Toggle theme (dark/light)" },
      },
    },
    -- Import plugins configurations
    { import = '../plugins' },
    -- Import specific programming languages configurations
    { import = '../plugins/lang' },
  },
  {
    git = {
      url = token
        and ("https://x-access-token:" .. token .. "@github.com/")
        or "https://github.com/",
    },
    install = {
      colorscheme = { "gruvbox" },
    },
    ui = {
      -- If you have a Nerd Font, set icons to an empty table which will use the
      -- default lazy.nvim defined Nerd Font icons otherwise define a unicode icons table
      icons = vim.g.have_nerd_font and {} or {
        cmd = ' ',
        config = ' ',
        event = '󰃮 ',
        ft = ' ',
        init = ' ',
        keys = '󰌋 ',
        plugin = ' ',
        runtime = ' ',
        require = ' ',
        source = '󰈙 ',
        start = '󱓞 ',
        task = '󰐃 ',
        lazy = '󰒲 ',
      },
    },
  })

-- vim: ts=2 sts=2 sw=2 et
