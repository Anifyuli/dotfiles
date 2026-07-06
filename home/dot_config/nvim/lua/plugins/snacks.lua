return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = {
      enabled = true,
      filesize = 2,        -- MB, jangan nonaktifkan sebelum 2MB
      lines = 15000,       -- atau 15k baris
    },
    dashboard = {
      enabled = true,
      preset = {
        header = [[
    ████████████████████████████████████████
    █▄─▀█▄─▄█▄─▄▄─█─▄▄─█▄─█─▄█▄─▄█▄─▀█▀─▄█
    ██─█▄▀─███─▄█▀█─██─██▄▀▄███─███─█▄█─██
    ▀▄▄▄▀▀▄▄▀▄▄▄▄▄▀▄▄▄▄▀▀▀▄▀▀▀▄▄▄▀▄▄▄▀▄▄▄▀
    ]],
        keys = {
          { icon = " ", key = "f", desc = "Find file", action = ":lua Snacks.picker.files()" },
          { icon = " ", key = "n", desc = "New file", action = ":ene | startinsert" },
          { icon = " ", key = "r", desc = "Recent files", action = ":lua Snacks.picker.recent()" },
          { icon = " ", key = "g", desc = "Find text", action = ":lua Snacks.picker.grep()" },
          {
            icon = " ", key = "c", desc = "Config",
            action = function()
              Snacks.picker.files({ cwd = vim.fn.expand("~/.config/nvim/") })
              vim.cmd.cd("~/.config/nvim/")
            end,
          },
          { icon = " ", key = "s", desc = "Restore Session", action = ":lua require('persistence').load()" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        function()
          local stats = require("lazy").stats()
          local total = math.floor(stats.times.LazyDone * 100 + 0.5) / 100
          local init = math.floor(stats.times.LazyStart * 100 + 0.5) / 100
          local plugins = math.floor((stats.times.LazyDone - stats.times.LazyStart) * 100 + 0.5) / 100
          return {
            align = "center",
            text = {
              { " 󱐋  ", hl = "header" },
              { total .. "ms total  |  ", hl = "footer" },
              { "  ", hl = "header" },
              { init .. "ms  |  ", hl = "footer" },
              { "󱩾  ", hl = "header" },
              { plugins .. "ms plugins (" .. stats.loaded .. "/" .. stats.count .. ")", hl = "footer" },
            },
          }
        end,
      },
    },
    image = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    scope = { enabled = true },
    terminal = {
      enabled = true,
      win = { position = "bottom" },
    },
    explorer = { enabled = false },
    picker = {
      enabled = true,
      ui_select = true,
      sources = {
        files = {
          hidden = true,
          ignored = false,
          exclude = {
            "node_modules",
            "target",
            "build",
            "dist",
            ".next",
            ".nuxt",
            "__pycache__",
            ".venv",
            "venv",
            "vendor",
            ".bundle",
            ".gradle",
            "Pods",
            ".terraform",
            "bin",
            "obj",
            "coverage",
            ".pytest_cache",
          },
        },
        grep = { hidden = true },
        explorer = {
          hidden = true,
          ignored = true,
          git_status_open = true,
          diagnostics_open = true,
          exclude = {
            "node_modules",
            "target",
            "build",
            "dist",
            ".next",
            ".nuxt",
            "__pycache__",
            ".venv",
            "venv",
            "vendor",
            ".bundle",
            ".gradle",
            "Pods",
            ".terraform",
            "bin",
            "obj",
            "coverage",
            ".pytest_cache",
          },
        },
      },
      icons = {
        files = {
          enabled = true,
          dir = " ",
          dir_open = " ",
          file = " ",
        },
        tree = {
          vertical = "┊ ",
          middle   = "├──",
          last     = "└──",
        },
      },
      layout = {
        preset = function()
          return vim.o.columns >= 120 and "default" or "vertical"
        end,
      },
    },
    notifier = { enabled = true, timeout = 3000 },
    quickfile = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
  config = function(_, opts)
    require("snacks").setup(opts)
    vim.api.nvim_set_hl(0, "SnacksPickerDirectory", { link = "String" })
    vim.api.nvim_set_hl(0, "SnacksDashboardDesc", { link = "Normal" })
    vim.api.nvim_set_hl(0, "SnacksDashboardKey", { link = "Keyword" })
    vim.api.nvim_set_hl(0, "SnacksDashboardIcon", { link = "String" })
    vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { link = "String" })
    vim.api.nvim_set_hl(0, "SnacksDashboardFooter", { link = "Normal" })
  end,
  keys = {
    { "<leader>gl",      function() Snacks.lazygit({ win = { position = "float" } }) end, desc = "LazyGit" },
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader>,",       function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>/",       function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>:",       function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>e",       "<cmd>Neotree toggle<cr>", desc = "File Explorer (Neo-tree)" },
    { "<leader>ff",      function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fg",      function() Snacks.picker.git_files() end, desc = "Find Git Files" },
    { "<leader>fr",      function() Snacks.picker.recent() end, desc = "Recent" },
    { "<leader>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Config Files" },
    { "<leader>sb",      function() Snacks.picker.buffers() end, desc = "Search Buffers" },
    { "<leader>sh",      function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>sk",      function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>ss",      function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>sw",      function() Snacks.picker.grep_word() end, desc = "Grep word", mode = { "n", "x" } },
    { "<leader>sg",      function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>sd",      function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sr",      function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>s/",      function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>sm",      function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sM",      function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader><leader>", function() Snacks.picker.buffers() end, desc = "Find existing buffers" },
    { "gd",       function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD",       function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr",       function() Snacks.picker.lsp_references() end, desc = "References" },
    { "gI",       function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy",       function() Snacks.picker.lsp_type_definitions() end, desc = "Goto Type Definition" },
    { "K",        vim.lsp.buf.hover, desc = "Hover Documentation" },
    { "<leader>D", function() Snacks.picker.lsp_type_definitions() end, desc = "Type Definition" },
    { "<leader>ds", function() Snacks.picker.lsp_symbols() end, desc = "Document Symbols" },
    { "<leader>ws", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace Symbols" },
    { "<leader>un", function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<c-/>",      function() Snacks.terminal.toggle({ "sh", "-c", "tmux kill-session -t nvimterm 2>/dev/null; exec tmux new-session -s nvimterm" }) end, desc = "Toggle  Terminal" },
    { "<c-_>",      function() Snacks.terminal.toggle({ "sh", "-c", "tmux kill-session -t nvimterm 2>/dev/null; exec tmux new-session -s nvimterm" }) end, desc = "which_key_ignore" },
  },
}
