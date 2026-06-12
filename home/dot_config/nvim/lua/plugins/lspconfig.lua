return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "williamboman/mason.nvim",
        config = true,
      },
      "williamboman/mason-lspconfig.nvim",
      {
        "j-hui/fidget.nvim",
        opts = {},
      },
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
          map("K", vim.lsp.buf.hover, "Hover Documentation")
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )

      require("which-key").add({
        { "<leader>", group = "VISUAL <leader>", mode = "v" },
        { "<leader>h", group = "Git [H]unk", mode = "v" },
        { "<leader>rn", desc = "LSP: Rename" },
        { "<leader>ca", desc = "LSP: Code Action" },
        { "K", desc = "LSP: Hover" },
        { "gD", desc = "LSP: Declaration" },
      })

      -- LSP configs with custom settings
      vim.lsp.config.cssls = {
        capabilities = capabilities,
        filetypes = { "css", "scss", "html", "less" },
        settings = {},
      }

      vim.lsp.config.eslint = {
        capabilities = capabilities,
        filetypes = {
          "html",
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
          "vue",
          "svelte",
          "astro",
        },
        settings = {},
      }

      vim.lsp.config.html = {
        capabilities = capabilities,
        filetypes = { "html", "twig", "hbs", "php" },
        settings = {},
      }

      vim.lsp.config.lua_ls = {
        capabilities = capabilities,
        settings = {
          Lua = {
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = { enable = false },
          },
        },
      }

      vim.lsp.config.rpmspec = {
        capabilities = capabilities,
        filetypes = { "rpm_spec", "spec" },
      }

      vim.lsp.config.ts_ls = {
        capabilities = capabilities,
        settings = {
          completions = {
            completeFunctionCalls = true,
          },
        },
      }

      -- Filetype detection for RPM spec files
      vim.filetype.add({
        extension = {
          spec = "rpm_spec",
        },
      })

      -- Register rpmspec treesitter parser for spec files
      vim.treesitter.language.register("rpmspec", { "rpm_spec" })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "rpm_spec" },
        callback = function(args)
          vim.treesitter.start(args.buf, "rpmspec")
          vim.bo[args.buf].commentstring = "# %s"
          vim.bo[args.buf].comments = "b:#"
        end,
      })

      -- Mason
      require("mason").setup()

      require("mason-lspconfig").setup({
        ensure_installed = {
          "cssls",
          "eslint",
          "html",
          "lua_ls",
          "marksman",
          "rpmspec",
          "tailwindcss",
          "ts_ls",
        },
      })
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-null-ls").setup({
        automatic_installation = true,
        ensure_installed = {
          "eslint_d",
          "markdownlint",
          "prettier",
          "stylua",
        },
      })
      local nls = require("null-ls")
      nls.setup({
        sources = {
          nls.builtins.formatting.prettier.with({
            filetypes = {
              "html", "css", "scss", "less",
              "javascript", "javascriptreact", "typescript", "typescriptreact",
              "json", "jsonc", "yaml", "markdown", "graphql",
            },
          }),
          nls.builtins.diagnostics.markdownlint,
        },
      })
    end,
  },
}
