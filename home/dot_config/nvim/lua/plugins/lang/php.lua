return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "php" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.phpactor = {
        init_options = {
          ["language_server_phpactor.enable_worse_refactoring_integration"] = true,
          ["language_server_phpactor.class_to_file.stubs"] = {},
          ["language_server_phpactor.completion.auto_import"] = true,
          ["language_server_phpactor.diagnostics.enabled"] = true,
        },
      }
      return opts
    end,
  },
}
