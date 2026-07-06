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
        { "<leader>Tt", desc = "Picker terminal" },
        -- [T]est (<leader>z karena tb/td pindah ke <leader>g)
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
        { "<leader>gb", desc = "Toggle blame" },
        { "<leader>gd", desc = "Toggle deleted" },
        -- [B]uffers
        { "<leader>b", group = "󰈙 [B]uffers" },
        { "<leader>b<", desc = "Move buffer left" },
        { "<leader>b>", desc = "Move buffer right" },
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
        { "<leader>db", desc = "Toggle Breakpoint" },
        { "<leader>dB", desc = "Set Breakpoint" },
        { "<leader>dr", desc = "Restart" },
        { "<leader>dt", desc = "Toggle mode (neovim/tmux)" },
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
        -- Sessions
        { "<leader>q", group = " [S]ession" },
        { "<leader>qs", desc = "Restore" },
        { "<leader>ql", desc = "Restore last" },
        { "<leader>qd", desc = "Don't save" },
        -- [R]ename
        { "<leader>r", group = " [R]ename" },
        -- [S]earch
        { "<leader>s", group = " [S]earch" },
        { "<leader>sb", desc = "Buffers" },
        { "<leader>sh", desc = "Help" },
        { "<leader>sk", desc = "Keymaps" },
        { "<leader>sg", desc = "Grep" },
        { "<leader>sw", desc = "Grep word", mode = { "n", "x" } },
        { "<leader>ss", desc = "LSP Symbols" },
        { "<leader>sd", desc = "Diagnostics" },
        { "<leader>sr", desc = "Resume" },
        { "<leader>s/", desc = "Grep buffers" },
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
        { "K", desc = "Hover Documentation" },
        { "gd", desc = "Goto Definition" },
        { "gD", desc = "Goto Declaration" },
        { "gr", desc = "References", nowait = true },
        { "gI", desc = "Goto Implementation" },
        { "gy", desc = "Goto Type Definition" },
        -- Misc
        { "<leader><leader>", desc = "Find existing buffers" },
        { "<leader>D", desc = "Type Definition" },
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
              filetype = "NvimTree",
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
          close_command = function(id)
            local listed = vim.tbl_filter(function(b) return vim.bo[b].buflisted end, vim.api.nvim_list_bufs())
            local is_last = #listed <= 1
            pcall(require("mini.bufremove").delete, id, false)
            if is_last then
              vim.schedule(function()
                local cur_win = vim.api.nvim_get_current_win()
                if cur_win and vim.api.nvim_win_is_valid(cur_win) then
                  local opts = { win = cur_win }
                  if vim.api.nvim_buf_is_valid(1) and vim.fn.bufname(1) == "" and not vim.bo[1].modified then
                    opts.buf = 1
                  end
                  require("snacks.dashboard").open(opts)
                else
                  require("snacks").dashboard()
                end
              end)
            end
          end,
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
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      options = {
        custom_commentstring = function()
          local ft = vim.bo.filetype
          if ft == "typescriptreact" or ft == "javascriptreact" then
            return "{/*%s*/}"
          end
          return nil
        end,
      },
    },
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
            },
          },
        },
        sections = {
          lualine_a = { { "mode", icon = "" } },
          lualine_b = { lsp_status },
          lualine_c = { { "filename", icon = "󰈮" } },
          lualine_x = {
            {
              function() return '' end,
              __wakatime_statusline = true,
            },
            {
              function()
                local ok, text = pcall(function()
                  return require('wakatime').statusline()
                end)
                if ok and text and text ~= '' then return '󱑁 ' .. text end
                return ''
              end,
            },
            { "encoding" },
            { "fileformat" },
            { "filetype" },
          },
          lualine_z = {
            {
              sexy_location,
              cond = function()
                return vim.bo.filetype ~= "NvimTree"
              end,
            },
          },
        },
        inactive_sections = {
          lualine_x = { sexy_location },
        },
        extensions = {
          "lazy",
          "mason",
          "nvim-tree",
          "nvim-dap-ui",
          {
            filetypes = { "NvimTree" },
            sections = {
              lualine_a = {},
              lualine_b = {},
              lualine_c = { { "filename" } },
              lualine_x = {},
              lualine_y = {},
              lualine_z = {},
            },
          },
        },
      })
    end,
  },
  {
    -- nvim-tree: file explorer
    "nvim-tree/nvim-tree.lua",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require("nvim-tree").setup({
        disable_netrw = true,
        hijack_netrw = true,
        update_focused_file = { enable = true, update_cwd = false },
        git = { enable = true },
        diagnostics = { enable = true },
        filters = {
          dotfiles = false,
          git_ignored = false,
          custom = { "node_modules", ".git", ".next", ".nuxt", "dist", "target", "build" },
        },
        view = {
          width = 30,
          side = "left",
          signcolumn = "yes",
        },
        renderer = {
          group_empty = true,
          icons = { git_placement = "signcolumn" },
        },
        actions = {
          open_file = {
            quit_on_open = false,
            resize_window = false,
          },
        },
      })
    end,
  },
  {
    -- Edgy: predictable window layout
    "folke/edgy.nvim",
    event = "VeryLazy",
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
            ft = "NvimTree",
            filter = function(buf)
              return vim.b[buf].nvim_tree_explorer == 1
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
