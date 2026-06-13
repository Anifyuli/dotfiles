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
        do
          local f = io.open(vim.fn.expand("~/.config/kdeglobals"), "r")
          if f then
            local content = f:read("*a")
            f:close()
            local scheme = content:match("ColorScheme%s*=%s*([^\n]+)")
            if scheme then
              vim.o.background = scheme:lower():find("dark") and "dark" or "light"
            end
          end
        end
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
