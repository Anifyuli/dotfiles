 return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "markdown", "markdown_inline" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {},
      },
    },
  },

  -- Inline markdown rendering
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown", "norg", "rmd", "org" },
    opts = {
      heading = {
        backgrounds = {},
      },
    },
    keys = {
      { "<leader>cp", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown Render", ft = "markdown" },
    },
  },

}
