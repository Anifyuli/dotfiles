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
    config = function(_, opts)
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

          -- Ruff: biarkan hover ditangani pyright
          if client and client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
          end

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

      -- Terapkan config per-server dari opts.servers (diisi oleh fragment opts
      -- di file ini dan plugins/lang/*.lua; lazy.nvim men-chaining opts functions),
      -- lalu enable semuanya
      for server, server_opts in pairs(opts.servers or {}) do
        server_opts.capabilities = vim.tbl_deep_extend("force", capabilities, server_opts.capabilities or {})
        vim.lsp.config(server, server_opts)
        vim.lsp.enable(server)
      end

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
          "gopls",
          "html",
          "lua_ls",
          "marksman",
          "phpactor",
          "pyright",
          "ruff",
          "rpmspec",
          "tailwindcss",
          "taplo",
          "ts_ls",
        },
      })
    end,
    opts = function(_, opts)
      opts = opts or {}
      opts.servers = opts.servers or {}

      opts.servers.cssls = {
        filetypes = { "css", "scss", "html", "less" },
        settings = {
          css = {
            lint = {
              unknownAtRules = "ignore",
            },
          },
        },
      }

      opts.servers.eslint = {
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

      opts.servers.html = {
        filetypes = { "html", "twig", "hbs", "php" },
        settings = {},
      }

      opts.servers.lua_ls = {
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

      -- Python: pyright, interpreter di-resolve dari venv UV per project
      local python_utils = require("utils.python")
      opts.servers.pyright = {
        before_init = function(_, config)
          config.settings = config.settings or {}
          config.settings.python = config.settings.python or {}
          config.settings.python.pythonPath = python_utils.get_python_path(config.root_dir)
        end,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "openFilesOnly",
              typeCheckingMode = "basic",
            },
          },
        },
      }

      opts.servers.rpmspec = {
        filetypes = { "rpm_spec", "spec" },
      }

      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
      if vim.fn.filereadable(mason_bin .. "/taplo") == 1 then
        opts.servers.taplo = {
          cmd = { mason_bin .. "/taplo", "lsp", "stdio" },
          filetypes = { "toml" },
        }
      end

      -- Disable semantic tokens for ts_ls to prevent overriding treesitter highlights
      opts.servers.ts_ls = {
        on_attach = function(client, _bufnr)
          if client.server_capabilities.semanticTokensProvider then
            client.server_capabilities.semanticTokensProvider = nil
          end
        end,
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
      }

      return opts
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
          "goimports",
          "gofumpt",
          "markdownlint",
          "php-cs-fixer",
          "prettier",
          "stylua",
        },
      })
      local nls = require("null-ls")
      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
      local sources = {
        nls.builtins.formatting.prettier.with({
          filetypes = {
            "html", "css", "scss", "less",
            "javascript", "javascriptreact", "typescript", "typescriptreact",
            "json", "jsonc", "yaml", "markdown", "graphql",
          },
        }),
        nls.builtins.formatting.goimports,
        nls.builtins.formatting.gofumpt,
        nls.builtins.diagnostics.markdownlint,
      }
      -- php-cs-fixer: custom source with Mason full path
      local php_cs_fixer_bin = mason_bin .. "/php-cs-fixer"
      if vim.fn.filereadable(php_cs_fixer_bin) == 1 then
        table.insert(sources, nls.builtins.formatting.phpcsfixer.with({
          command = php_cs_fixer_bin,
        }))
      end
      nls.setup({
        timeout = 15000,
        sources = sources,
      })
    end,
  },
  {
    -- Auto update imports when renaming/moving files (works with Neo-tree)
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-tree/nvim-tree.lua",
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
