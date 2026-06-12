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
        { "<leader><space>", desc = "Smart Find" },
        { "<leader>,",       desc = "Buffers" },
        { "<leader>/",       desc = "Grep" },
        { "<leader>:",       desc = "Command History" },
        { "<leader>e",       desc = "File Explorer" },
        { "<leader>n",       desc = "New File" },
        -- [T]erminal
        { "<leader>T", group = " [T]erminal" },
        { "<leader>Th", desc = "Horizontal" },
        { "<leader>Tv", desc = "Vertical" },
        { "<leader>Tf", desc = "Float" },
        -- [T]est (<leader>z to avoid conflict with tb/td)
        { "<leader>z", group = "󰙨 [T]est" },
        { "<leader>zt", desc = "Run file" },
        { "<leader>zT", desc = "Run all" },
        { "<leader>zr", desc = "Run nearest" },
        { "<leader>zs", desc = "Summary" },
        { "<leader>zo", desc = "Output" },
        -- [R]est
        { "<leader>R", group = " [R]est Client" },
        -- [F]ind
        { "<leader>f", group = "󰈞 [F]ind" },
        { "<leader>ff", desc = "Files" },
        { "<leader>fg", desc = "Git Files" },
        { "<leader>fr", desc = "Recent" },
        { "<leader>fc", desc = "Config" },
        -- [G]it
        { "<leader>g", group = " [G]it" },
        { "<leader>gl", desc = "LazyGit" },
        -- [B]uffers
        { "<leader>b", group = "󰈙 [B]uffers" },
        { "<leader>bd", desc = "Delete" },
        { "<leader>bD", desc = "Delete (force)" },
        -- [C]ode
        { "<leader>c", group = " [C]ode" },
        { "<leader>cf", desc = "Format" },
        { "<leader>cx", desc = "Toggle Quickfix" },
        { "<leader>cd", desc = "Line Diagnostics" },
        { "<leader>cl", desc = "LSP Info" },
        -- [D]ebug
        { "<leader>d", group = "󰃤 [D]ebug" },
        { "<leader>dd", desc = "Pick & run" },
        { "<leader>dr", desc = "Restart" },
        { "<leader>ds", desc = "Document Symbols" },
        -- [H]unk
        { "<leader>h", group = " [H]unk" },
        { "<leader>hs", desc = "Stage hunk", mode = { "n", "v" } },
        { "<leader>hr", desc = "Reset hunk", mode = { "n", "v" } },
        { "<leader>hS", desc = "Stage buffer" },
        { "<leader>hu", desc = "Undo stage" },
        { "<leader>hR", desc = "Reset buffer" },
        { "<leader>hp", desc = "Preview hunk" },
        { "<leader>hb", desc = "Blame line" },
        { "<leader>hd", desc = "Diff index" },
        { "<leader>hD", desc = "Diff last commit" },
        { "<leader>tb", desc = "Toggle blame" },
        { "<leader>td", desc = "Toggle deleted" },
        -- Sessions
        { "<leader>q", group = " [S]ession" },
        { "<leader>qs", desc = "Restore" },
        { "<leader>ql", desc = "Restore last" },
        { "<leader>qd", desc = "Don't save" },
        -- [R]ename
        { "<leader>r", group = " [R]ename" },
        -- [S]earch
        { "<leader>s", group = " [S]earch" },
        { "<leader>sh", desc = "Help" },
        { "<leader>sk", desc = "Keymaps" },
        { "<leader>sg", desc = "Grep" },
        { "<leader>sw", desc = "Grep word", mode = { "n", "x" } },
        { "<leader>ss", desc = "LSP Symbols" },
        { "<leader>sd", desc = "Diagnostics" },
        { "<leader>sr", desc = "Resume" },
        { "<leader>s.", desc = "Recent Files" },
        { "<leader>s/", desc = "Grep buffers" },
        { "<leader>sn", desc = "Config Files" },
        { "<leader>sm", desc = "Icons" },
        { "<leader>sM", desc = "Man Pages" },
        -- [U]I
        { "<leader>u", group = "󰖔 [U]I" },
        { "<leader>uT", desc = "Toggle theme" },
        { "<leader>un", desc = "Notification History" },
        -- [W]orkspace
        { "<leader>w", group = "󰱶 [W]orkspace" },
        { "<leader>ws", desc = "Workspace Symbols" },
        -- Dia[n]ostics
        { "<leader>x", group = "󰒡 Dia[n]ostics" },
        { "<leader>xx", desc = "Trouble diagnostics" },
        { "<leader>xw", desc = "Buffer diagnostics" },
        { "<leader>xt", desc = "Todo" },
        -- LSP (no prefix)
        { "gd", desc = "Goto Definition" },
        { "gD", desc = "Goto Declaration" },
        { "gr", desc = "References", nowait = true },
        { "gI", desc = "Goto Implementation" },
        { "gy", desc = "Goto Type Definition" },
      })
    end,
  },


  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "UIEnter",
    config = function()
      vim.api.nvim_set_hl(0, "TabLineFill", { bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg })

      local _offset_info = { text = "", cwd = "" }
      local function get_offset_text()
        local cwd = vim.fn.getcwd()
        if _offset_info.text ~= "" and _offset_info.cwd == cwd then
          return _offset_info.text
        end
        _offset_info.cwd = cwd
        local ok, result = pcall(function()
          local root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null")
          if vim.v.shell_error ~= 0 then
            local dir = vim.fn.fnamemodify(cwd, ":t")
            local parent = vim.fn.fnamemodify(cwd, ":h:t")
            return " " .. parent .. "/" .. dir
          end
          root = root:gsub("\n", "")
          local name = vim.fn.fnamemodify(root, ":t")
          local branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
          if branch == "" then
            return " " .. name
          end
          return " " .. name .. " (" .. branch .. ")"
        end)
        _offset_info.text = ok and result or ""
        return _offset_info.text
      end

      vim.api.nvim_create_autocmd("DirChanged", {
        callback = function()
          _offset_info.text = ""
        end,
      })

      require("bufferline").setup({
        options = {
          mode = "buffers",
          offsets = {
            {
              filetype = "neo-tree",
              text = get_offset_text,
              text_align = "left",
              highlight = "Directory",
              separator = false,
            },
          },
          buffer_close_icon = "",
          modified_icon = "●",
          close_icon = "",
          show_buffer_close_icons = true,
          show_close_icon = false,
          separator_style = "thin",
          always_show_bufferline = true,
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local s = ""
            for e, n in pairs(diagnostics_dict) do
              local sym = e == "error" and "  " or (e == "warning" and "  " or "  ")
              s = s .. n .. sym
            end
            return s
          end,
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
    -- Statusline
    "nvim-lualine/lualine.nvim",
    event = "UIEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local sexy_location = function()
        return "Ln %l Col %c"
      end
      local lsp_status = function()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if #clients == 0 then
          return ""
        end
        local names = {}
        for _, c in ipairs(clients) do
          table.insert(names, c.name)
        end
        return " " .. table.concat(names, " ")
      end
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto",
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
          lualine_b = { lsp_status },
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
            title = "󰙅 File Explorer",
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
