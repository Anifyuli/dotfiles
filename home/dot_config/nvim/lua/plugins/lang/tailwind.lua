return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config("tailwindcss", {
        filetypes = {
          "html", "css", "scss", "less",
          "javascript", "javascriptreact", "typescript", "typescriptreact",
        },
        settings = {
          tailwindcss = {
            lint = {
              cssConflict = "warning",
              invalidApply = "error",
              invalidConfigPath = "error",
              invalidTailwindDirective = "error",
              recommendedVariantOrder = "warning",
              unusedClasses = "warning",
            },
          },
        },
      })
      vim.lsp.enable("tailwindcss")
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
    },
    opts = function()
      require("cmp").config.formatting = {
        format = require("tailwindcss-colorizer-cmp").formatter,
      }
    end,
  },
}
