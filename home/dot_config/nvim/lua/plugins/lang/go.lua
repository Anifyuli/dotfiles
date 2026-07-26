return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "go", "gomod", "gowork", "gosum" })
      end
    end,
  },
  {
    "ray-x/go.nvim",
    dependencies = { "ray-x/guihua.lua" },
    ft = { "go", "gomod" },
    build = ":lua require('go.install').update_all()",
    opts = {
      goimport = "gopls",
      gofumpt = true,
      lsp_cfg = {
        settings = {
          gopls = {
            usePlaceholders = true,
            completeUnimported = true,
            analyses = {
              unusedparams = true,
              shadow = true,
            },
          },
        },
      },
    },
    keys = {
      { "<leader>gR", function() require("go.run").redo() end, desc = "Run" },
      { "<leader>gT", function() require("go.test").test_file() end, desc = "Test File" },
      { "<leader>gt", function() require("go.test").test_case() end, desc = "Test Nearest" },
      { "<leader>ga", function() require("go.install").update_all() end, desc = "Install All" },
    },
  },
  {
    "leoluz/nvim-dap-go",
    ft = { "go", "gomod" },
    config = function()
      require("dap-go").setup()
    end,
  },
}
