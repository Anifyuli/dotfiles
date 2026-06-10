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

      vim.keymap.set("n", "<leader>dd", function()
        require("pickers.task-picker").pick_and_run()
      end, { desc = "Debug: pick and run" })
      local wk = require("which-key")
      wk.add({ { "<leader>dd", desc = "Debug: pick and run" } })
    end,
  },
}
