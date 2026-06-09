return {
  -- add typescript to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "typescript", "tsx" })
      end
    end,
  },

  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          table.insert(opts.ensure_installed, "js-debug-adapter")
        end,
      },
    },
    opts = function()
      local dap = require("dap")

      -- pwa-node adapter for debugging Node.js/TypeScript
      if not dap.adapters["pwa-node"] then
        local ok, pkg = pcall(require("mason-registry").get_package, "js-debug-adapter")
        if ok then
          dap.adapters["pwa-node"] = {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = {
              command = "node",
              args = {
                pkg:get_install_path() .. "/js-debug/src/dapDebugServer.js",
                "${port}",
              },
            },
          }
        end
      end

      local common = {
        cwd = "${workspaceFolder}",
        skipFiles = { "<node_internals>/**", "node_modules/**" },
        console = "integratedTerminal",
      }

      local configs = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach to process",
          processId = require("dap.utils").pick_process,
        },
        -- npm script runner (prompts for script name)
        {
          type = "pwa-node",
          request = "launch",
          name = "Run npm script...",
          runtimeExecutable = "npm",
          runtimeArgs = function()
            local input = vim.fn.input("npm run ")
            if input == "" then return {} end
            return vim.split(input, " ")
          end,
        },
        -- NestJS Dev
        {
          type = "pwa-node",
          request = "launch",
          name = "NestJS: Start Dev",
          runtimeExecutable = "npm",
          runtimeArgs = { "run", "start:dev" },
        },
        -- NestJS Debug
        {
          type = "pwa-node",
          request = "launch",
          name = "NestJS: Start Debug",
          runtimeExecutable = "npm",
          runtimeArgs = { "run", "start:debug" },
        },
        -- React Native
        {
          type = "pwa-node",
          request = "launch",
          name = "RN: Start Metro",
          runtimeExecutable = "npx",
          runtimeArgs = { "@react-native/metro", "start" },
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "RN: Run Android",
          runtimeExecutable = "npx",
          runtimeArgs = { "react-native", "run-android" },
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "RN: Run iOS",
          runtimeExecutable = "npx",
          runtimeArgs = { "react-native", "run-ios" },
        },
        -- Expo
        {
          type = "pwa-node",
          request = "launch",
          name = "Expo: Start",
          runtimeExecutable = "npx",
          runtimeArgs = { "expo", "start" },
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Expo: Start (Web)",
          runtimeExecutable = "npx",
          runtimeArgs = { "expo", "start", "--web" },
        },
      }

      for _, lang in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        dap.configurations[lang] = vim.deepcopy(configs)
        for _, cfg in ipairs(dap.configurations[lang]) do
          cfg.cwd = "${workspaceFolder}"
          if not cfg.skipFiles then
            cfg.skipFiles = common.skipFiles
          end
          if not cfg.console then
            cfg.console = common.console
          end
        end
      end

      -- Keymap to show DAP configurations list
      vim.keymap.set("n", "<leader>dd", function()
        dap.run()
      end, { desc = "DAP: Run configuration" })
    end,
  },
}
