return {
  {
    -- Which-key
    "folke/which-key.nvim",
    event = "VeryLazy",
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
        { "<leader>T", group = " [T]erminal" },
        { "<leader>Th", desc = "Horizontal" },
        { "<leader>Tv", desc = "Vertical" },
        { "<leader>Tf", desc = "Float" },
        { "<leader>R", group = " [R]est Client" },
        { "<leader>b", group = "󰈙 [B]uffers" },
        { "<leader>c", group = " [C]ode" },
        { "<leader>d", group = "󰈬 [D]ocument" },
        { "<leader>h", group = " [H]unk" },
        { "<leader>r", group = " [R]ename" },
        { "<leader>s", group = " [S]earch" },
        { "<leader>u", group = "󰖔 [U]I" },
        { "<leader>w", group = "󰱶 [W]orkspace" },
        { "<leader>x", group = "󰒡 Dia[n]ostics" },
      })
    end,
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
            return buffer.type ~= "terminal" and buffer.filetype ~= "neo-tree"
          end,
          filter_visible = function(buffer)
            return buffer.type ~= "terminal" and buffer.filetype ~= "neo-tree"
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
  { "echasnovski/mini.icons", lazy = true, event = "VeryLazy", opts = {} },
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
    event = "UIEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local sexy_location = function()
        return "Ln %l Col %c"
      end
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          globalstatus = true,
          component_separators = "|",
          section_separators = "",
          disabled_filetypes = {
            statusline = {
              "snacks_picker_input",
              "snacks_picker_list",
              "snacks_picker_preview",
              "neo-tree",
            },
          },
        },
        sections = {
          lualine_a = { { "mode", icon = "" } },
          lualine_c = { { "filename", icon = "󰈮" } },
          lualine_z = { sexy_location },
        },
        inactive_sections = {
          lualine_x = { sexy_location },
        },
        extensions = { "lazy", "mason", "nvim-tree", "nvim-dap-ui" },
      })
    end,
  },
  {
    -- Neo-tree: persistent file explorer
    "nvim-neo-tree/neo-tree.nvim",
    event = "VeryLazy",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    config = function()
      vim.fn.sign_define("NeotreeGitAdded", { text = " ", texthl = "NeotreeGitAdded" })
      vim.fn.sign_define("NeotreeGitModified", { text = " ", texthl = "NeotreeGitModified" })
      vim.fn.sign_define("NeotreeGitDeleted", { text = " ", texthl = "NeotreeGitDeleted" })
      vim.fn.sign_define("NeotreeGitUntracked", { text = " ", texthl = "NeotreeGitUntracked" })
      vim.fn.sign_define("NeotreeGitIgnored", { text = " ", texthl = "NeotreeGitIgnored" })
      vim.fn.sign_define("NeotreeGitConflict", { text = " ", texthl = "NeotreeGitConflict" })

      require("neo-tree").setup({
        close_if_last_window = true,
        enable_git_status = true,
        enable_diagnostics = true,
        default_source = "filesystem",
        sources = { "filesystem", "buffers", "git_status" },
        filesystem = {
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = false,
          },
          follow_current_file = { enabled = true, leave_dirs_open = false },
          use_libuv_file_watcher = true,
        },
        window = {
          position = "left",
          width = 30,
          mappings = {
            ["<space>"] = "none",
            ["l"] = "open",
            ["h"] = "close_node",
            ["<cr>"] = "open",
            ["o"] = "open",
            ["-"] = "navigate_up",
            ["."] = "set_root",
            ["z"] = "close_all_nodes",
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            ["t"] = "open_tabnew",
            ["w"] = "open_with_window_picker",
            ["P"] = "toggle_preview",
            ["q"] = "close_window",
          },
        },
      })
    end,
  },
  {
    -- Edgy: predictable window layout
    "folke/edgy.nvim",
    event = "VeryLazy",
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
    end,
    opts = function()
      local function term_item(pos, size)
        return {
          ft = "snacks_terminal",
          size = size,
          title = "%{b:snacks_terminal.id}: %{b:term_title}",
          filter = function(_buf, win)
            return vim.w[win].snacks_win
              and vim.w[win].snacks_win.position == pos
              and vim.w[win].snacks_win.relative == "editor"
              and not vim.w[win].trouble_preview
          end,
        }
      end
      return {
        bottom = {
          term_item("bottom", { height = 0.4 }),
          "Trouble",
          { ft = "qf", title = "QuickFix" },
        },
        right = {
          term_item("right", { width = 0.4 }),
          { ft = "dapui_breakpoints", title = "Breakpoints" },
          { ft = "dapui_stacks", title = "Stacks" },
          { ft = "dapui_watches", title = "Watches" },
          { ft = "dapui_scopes", title = "Scopes" },
          { ft = "dapui_console", title = "Console" },
        },
        left = {
          {
            title = "File Explorer",
            ft = "neo-tree",
            filter = function(buf)
              return vim.b[buf].neo_tree_source == "filesystem"
            end,
            size = { width = 30 },
          },
        },
        top = {},
        keys = {
          ["]w"] = false, ["[w"] = false,
          ["]W"] = false, ["[W"] = false,
        },
      }
    end,
  },
}
