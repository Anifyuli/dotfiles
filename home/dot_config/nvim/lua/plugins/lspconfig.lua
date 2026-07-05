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
          vim.keymap.set("x", "<leader>ca", vim.lsp.buf.code_action, { buffer = event.buf, desc = "LSP: [C]ode [A]ction (selection)" })
          -- Source actions: organize imports, add missing imports, remove unused, etc.
          map("<leader>cA", function()
            vim.lsp.buf.code_action({
              apply = true,
              context = { only = { "source" }, diagnostics = {} },
            })
          end, "[S]ource [A]ction")
          -- Direct organize imports
          map("<leader>co", function()
            vim.lsp.buf.code_action({
              apply = true,
              context = { only = { "source.organizeImports" }, diagnostics = {} },
            })
          end, "[O]rganize Imports")
          map("K", vim.lsp.buf.hover, "Hover Documentation")
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd("CursorHold", {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
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
        { "<leader>cA", desc = "LSP: Source Action (imports, etc.)" },
        { "<leader>co", desc = "LSP: Organize Imports" },
        { "K", desc = "LSP: Hover" },
        { "gD", desc = "LSP: Declaration" },
      })

      -- LSP configs with custom settings
      vim.lsp.config.cssls = {
        capabilities = capabilities,
        filetypes = { "css", "scss", "html", "less" },
        settings = {
          css = {
            lint = {
              unknownAtRules = "ignore",
            },
          },
        },
      }

      vim.lsp.config.tailwindcss = {
        capabilities = capabilities,
        filetypes = { "css", "scss", "html", "less", "javascript", "javascriptreact", "typescript", "typescriptreact" },
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

      -- Disable semantic tokens for ts_ls to prevent overriding treesitter highlights
      local ts_ls_attach = function(client, bufnr)
        if client.server_capabilities.semanticTokensProvider then
          client.server_capabilities.semanticTokensProvider = nil
        end
      end

      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
        on_attach = ts_ls_attach,
        cmd = {
          "node",
          "--max-old-space-size=4096",
          vim.fn.stdpath("data")
            .. "/mason/packages/typescript-language-server/node_modules/typescript-language-server/lib/cli.mjs",
          "--stdio",
        },
        init_options = {
          maxTsServerMemory = 4096,
        },
        settings = {
          typescript = {
            suggest = {
              autoImports = true,
              includeCompletionsForImportStatements = true,
              includeAutomaticOptionalChainCompletions = true,
              includeCompletionsWithSnippetText = true,
              completeFunctionCalls = true,
            },
            preferences = {
              includePackageJsonAutoImports = "off",
              autoImportFileExcludePatterns = {
                "**/node_modules/**",
                "**/dist/**",
                "**/.expo/**",
                "**/*.test.ts",
                "**/*.spec.ts",
              },
            },
          },
          javascript = {
            suggest = {
              autoImports = true,
              includeCompletionsForImportStatements = true,
              includeAutomaticOptionalChainCompletions = true,
              includeCompletionsWithSnippetText = true,
              completeFunctionCalls = true,
            },
            preferences = {
              includePackageJsonAutoImports = "off",
              autoImportFileExcludePatterns = {
                "**/node_modules/**",
                "**/dist/**",
                "**/.expo/**",
                "**/*.test.ts",
                "**/*.spec.ts",
              },
            },
          },
        },
      })
      vim.lsp.enable("ts_ls")

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
  {
    -- Auto update imports when renaming/moving files (works with Neo-tree)
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-neo-tree/neo-tree.nvim",
    },
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      -- Patch deprecated API (plugin not yet updated for Neovim 0.12)
      vim.lsp.get_active_clients = vim.lsp.get_clients
      require("lsp-file-operations").setup(opts)
    end,
  },
}
