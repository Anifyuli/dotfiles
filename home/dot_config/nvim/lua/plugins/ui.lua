return {
  {
    -- Which-key
    "folke/which-key.nvim",
    config = function()
      local wk = require("which-key")
      wk.setup({
        delay = 50,
        icons = {
          keys = {
            C = "Ctrl+",
            M = "Alt+",
            D = "Cmd+",
            S = "Shift+",
          },
        },
      })
      wk.add({
        { "<leader>T", group = "[T]oggleterm" },
        { "<leader>R", group = "[R]est Client" },
        { "<leader>b", group = "[B]uffers" },
        { "<leader>c", group = "[C]ode" },
        { "<leader>d", group = "[D]ocument" },
        { "<leader>r", group = "[R]ename" },
        { "<leader>s", group = "[S]earch" },
        { "<leader>w", group = "[W]orkspace" },
        { "<leader>x", group = "Diag[n]ostics" },
      })
    end,
  },
  {
    -- Dashboard screen
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function()
      local logo = [[
    ████████████████████████████████████████
    █▄─▀█▄─▄█▄─▄▄─█─▄▄─█▄─█─▄█▄─▄█▄─▀█▀─▄█
    ██─█▄▀─███─▄█▀█─██─██▄▀▄███─███─█▄█─██
    ▀▄▄▄▀▀▄▄▀▄▄▄▄▄▀▄▄▄▄▀▀▀▄▀▀▀▄▄▄▀▄▄▄▀▄▄▄▀
  ]]

      local stats = require("lazy").stats()
      local total_ms = math.floor(stats.times.LazyDone * 100 + 0.5) / 100
      local init_ms = math.floor(stats.times.LazyStart * 100 + 0.5) / 100
      local plugin_ms = math.floor((stats.times.LazyDone - stats.times.LazyStart) * 100 + 0.5) / 100
      local init_line = " 󱐋 "
        .. total_ms
        .. "ms total  |  "
        .. " "
        .. init_ms
        .. "ms nvim  |  "
        .. "󱩾 "
        .. plugin_ms
        .. "ms plugins ("
        .. stats.loaded
        .. "/"
        .. stats.count
        .. ")"

      logo = "\n\n" .. logo .. "\n" .. init_line .. "\n"

      local opts = {
        theme = "doom",
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
          tabline = true,
        },
        config = {
          header = vim.split(logo, "\n"),
          -- stylua: ignore
          center = {
            { action = 'Telescope find_files', desc = ' Find file', icon = ' ', key = 'f' },
            { action = 'ene | startinsert', desc = ' New file', icon = ' ', key = 'n' },
            { action = 'Telescope oldfiles', desc = ' Recent files', icon = ' ', key = 'r' },
            { action = 'Telescope live_grep', desc = ' Find text', icon = ' ', key = 'g' },
            {
              action = function()
                local dir = "~/.config/nvim/"
                require("telescope.builtin").find_files({
                  cwd = dir,
                })
                vim.cmd.cd(dir)
              end,
              desc = ' Config',
              icon = ' ',
              key = 'c'
            },
            { action = 'lua require("persistence").load()', desc = ' Restore Session', icon = ' ', key = 's' },
            { action = ' Lazy', desc = ' Lazy', icon = '󰒲 ', key = 'l' },
            { action = 'qa', desc = ' Quit', icon = ' ', key = 'q' },
          },
          footer = function()
            return {}
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  %s"
      end

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "DashboardLoaded",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      return opts
    end,
  },
  {
    -- Neo-tree, File manager
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    opts = {
      close_if_last_window = true,
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      source_selector = {
        winbar = true,
        content_layout = "center",
        tabs_layout = "equal",
        sources = {
          { source = "filesystem", display_name = " File" },
          { source = "buffers", display_name = "󰈙 Bufs" },
          { source = "git_status", display_name = " Git" },
        },
      },
      event_handlers = {
        {
          event = "neo_tree_window_after_open",
          handler = function()
            vim.cmd("horizontal wincmd =")
          end,
        },
        {
          event = "neo_tree_window_after_close",
          handler = function()
            vim.cmd("horizontal wincmd =")
          end,
        },
      },
      default_component_configs = {
        indent = { indent_size = 2, padding = 0 },
        icon = { folder_closed = "▸", folder_open = "▾" },
      },
      window = {
        width = 30,
      },
      filesystem = {
        bind_to_cwd = true,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          always_show = { ".config" },
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            -- '.DS_Store',
            -- 'thumbs.db',
            -- 'node_modules',
          },
          never_show = {},
        },
        hijack_netrw_behavior = "open_current",
      },
    },
  },
  {
    -- Cokeline, buffer list
    "willothy/nvim-cokeline",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for v0.4.0+
      "nvim-tree/nvim-web-devicons", -- If you want devicons
      "stevearc/resession.nvim", -- Optional, for persistent history
    },
    event = "BufEnter",
    config = function()
      -- This config using https://github.com/noib3/ configs
      local get_hex = require("cokeline.hlgroups").get_hl_attr
      local mappings = require("cokeline/mappings")
      local comments_fg = get_hex("Comment", "fg")
      local errors_fg = get_hex("DiagnosticError", "fg")
      local warnings_fg = get_hex("DiagnosticWarn", "fg")
      local red = vim.g.terminal_color_1
      local green = vim.g.terminal_color_2
      local yellow = vim.g.terminal_color_3
      local text_bold = function(buffer)
        return ((buffer.is_focused and buffer.diagnostics.errors ~= 0) and true)
          or (buffer.is_focused and true)
          or (buffer.diagnostics.errors ~= 0 and false)
          or false
      end
      local components = {
        space = {
          text = " ",
          truncation = { priority = 1 },
        },
        two_spaces = {
          text = "  ",
          truncation = { priority = 1 },
        },
        separator = {
          text = function(buffer)
            return buffer.index ~= 1 and " ▏" or ""
          end,
          truncation = { priority = 1 },
        },
        devicon = {
          text = function(buffer)
            return (mappings.is_picking_focus() or mappings.is_picking_close()) and buffer.pick_letter .. " "
              or buffer.devicon.icon
          end,
          fg = function(buffer)
            return (mappings.is_picking_focus() and yellow)
              or (mappings.is_picking_close() and red)
              or buffer.devicon.color
          end,
          bold = function(_)
            return (mappings.is_picking_focus() or mappings.is_picking_close()) and "true" or false
          end,
          italic = function(_)
            return (mappings.is_picking_focus() or mappings.is_picking_close()) and "true" or false
          end,
          truncation = { priority = 1 },
        },
        index = {
          text = function(buffer)
            return buffer.index .. ":"
          end,
          truncation = { priority = 1 },
          bold = text_bold,
          underline = function(buffer)
            return buffer.is_focused and true or false
          end,
        },
        unique_prefix = {
          text = function(buffer)
            return buffer.unique_prefix
          end,
          fg = comments_fg,
          italic = true,
          truncation = {
            priority = 3,
            direction = "left",
          },
        },
        filename = {
          text = function(buffer)
            return buffer.filename
          end,
          truncation = {
            priority = 2,
            direction = "left",
          },
          bold = text_bold,
          underline = function(buffer)
            return ((buffer.is_focused and buffer.diagnostics.errors ~= 0) and true)
              or (buffer.is_focused and false)
              or (buffer.diagnostics.errors ~= 0 and true)
              or false
          end,
        },
        diagnostics = {
          text = function(buffer)
            return (buffer.diagnostics.errors ~= 0 and "  " .. buffer.diagnostics.errors)
              or (buffer.diagnostics.warnings ~= 0 and "  " .. buffer.diagnostics.warnings)
              or ""
          end,
          fg = function(buffer)
            return (buffer.diagnostics.errors ~= 0 and errors_fg)
              or (buffer.diagnostics.warnings ~= 0 and warnings_fg)
              or nil
          end,
          truncation = { priority = 1 },
        },
        close_or_unsaved = {
          text = function(buffer)
            return buffer.is_modified and "●" or ""
          end,
          fg = function(buffer)
            return buffer.is_modified and green or nil
          end,
          delete_buffer_on_left_click = true,
          truncation = { priority = 1 },
        },
        icon_indicator = {
          text = function(buffer)
            return buffer.is_focused and " 󰋱" or " "
          end,
          truncation = { priority = 1 },
        },
      }

      require("cokeline").setup({
        buffers = {
          filter_valid = function(buffer)
            return buffer.type ~= "terminal"
          end,
          filter_visible = function(buffer)
            return buffer.type ~= "terminal"
          end,
          new_buffers_position = "next",
        },
        rendering = {
          max_buffer_width = 30,
        },
        default_hl = {
          fg = function(buffer)
            return buffer.is_focused and get_hex("ColorColumn", "fg")
          end,
        },
        sidebar = {
          filetype = { "neo-tree" },
          components = {
            {
              text = " 󰙅 File Explorer ",
              fg = function()
                return get_hex("NeoTreeNormal", "fg")
              end,
              bg = function()
                return get_hex("NeoTreeNormal", "bg")
              end,
              bold = text_bold,
              delete_buffer_on_left_click = false,
              on_click = nil,
            },
          },
        },
        components = {
          components.separator,
          components.space,
          components.devicon,
          components.space,
          components.index,
          components.space,
          components.unique_prefix,
          components.filename,
          components.diagnostics,
          components.two_spaces,
          components.icon_indicator,
          components.space,
          components.close_or_unsaved,
          components.space,
          components.separator,
        },
      })
    end,
  },
  {
    -- buffer remove
    "echasnovski/mini.bufremove",
  },
  {
    -- measure startuptime
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },
  {
    -- Session management. This saves your session in the background,
    -- keeping track of open buffers, window arrangement, and more.
    -- You can restore sessions when returning through the dashboard.
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = vim.opt.sessionoptions:get() },
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" },
    },
  },
  -- Library used by other plugins
  { "nvim-lua/plenary.nvim", lazy = true },
  {
    -- Icons
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    event = "ColorScheme",
    opts = function()
      local function get_fg_color()
        local synID = vim.fn.hlID("Normal")
        return vim.fn.synIDattr(synID, "fg", "guifg")
      end

      require("nvim-web-devicons").setup({
        override_by_filename = {
          [".gitattributes"] = {
            icon = "",
            color = get_fg_color(),
            name = "GitAttributes",
          },
          ["gitconfig"] = {
            icon = "",
            color = get_fg_color(),
            name = "GitConfig",
          },
          [".gitignore"] = {
            icon = "",
            color = get_fg_color(),
            name = "GitIgnore",
          },
          ["commit_editmsg"] = {
            icon = "",
            color = get_fg_color(),
            name = "GitCommit",
          },
        },
      })
    end,
  },
  {
    -- Statusline
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local sexy_location = function()
        return "Ln %l Col %c"
      end
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = "|",
          section_separators = "",
        },
        sections = {
          lualine_a = { { "mode", icon = "" } },
          lualine_c = { { "filename", icon = "󰈮" } },
          lualine_z = { sexy_location },
        },
        inactive_sections = {
          lualine_x = { sexy_location },
        },
        extensions = { "lazy", "mason", "nvim-tree", "neo-tree", "nvim-dap-ui", "toggleterm" },
      })
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec" },
    version = "*",
    config = function()
      local map = vim.keymap.set

      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        map("t", "<M-q>", [[<C-\><C-n>]], opts)
        map("t", "jk", [[<C-\><C-n>]], opts)
        map("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
        map("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
        map("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
        map("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
        map("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
      end

      -- if you only want these mappings for toggle term use term://*toggleterm#* instead
      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

      vim.api.nvim_set_hl(0, "TermWinBar", { bg = "#3c3836", fg = "#b8bb26" })
      vim.api.nvim_set_hl(0, "TermWinBarNC", { bg = "#2e2a28", fg = "#665c54" })

      require("toggleterm").setup({
        size = 10,
        highlights = {
          Normal = { link = "Normal" },
          NormalNC = { link = "NormalNC" },
          NormalFloat = { link = "NormalFloat" },
          FloatBorder = { link = "FloatBorder" },
          StatusLine = { link = "StatusLine" },
          StatusLineNC = { link = "StatusLineNC" },
          WinBar = { link = "TermWinBar" },
          WinBarNC = { link = "TermWinBarNC" },
        },
        on_create = function()
          vim.opt.foldcolumn = "0"
          vim.opt.signcolumn = "no"
          vim.wo.winbar = "   TERMINAL  "
        end,
        open_mapping = [[<F7>]],
        float_opts = {
          border = "curved",
        },
      })
    end,
  },
}
