-- Python development setup (UV-first)
return {
  -- Debug adapter (debugpy via Mason) + workflow Python
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "williamboman/mason.nvim",
    },
    keys = {
      { "<leader>pr", desc = "[P]ython [R]un file (uv)", ft = "python" },
    },
    config = function()
      -- Pastikan debugpy terinstall via Mason (venv terisolasi, bebas dari project)
      local ok, pkg = pcall(require("mason-registry").get_package, "debugpy")
      if ok and not pkg:is_installed() then
        pkg:install()
      end

      -- Interpreter untuk HOST debugger (bukan program yang didebug).
      -- Program yang di-launch otomatis pakai .venv project (resolve bawaan dap-python).
      local mason_debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      local debugger_python = vim.fn.executable(mason_debugpy) == 1 and mason_debugpy or "python3"
      require("dap-python").setup(debugger_python, { test_runner = "pytest" })

      -- PEP 8: indent 4 spasi untuk Python (global config pakai 2)
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("python_ftplugin", { clear = true }),
        pattern = "python",
        callback = function()
          vim.opt_local.shiftwidth = 4
          vim.opt_local.tabstop = 4
          vim.opt_local.softtabstop = 4
        end,
      })

      -- Run file saat ini dengan `uv run python` di terminal snacks
      vim.keymap.set("n", "<leader>pr", function()
        local f = vim.fn.expand("%:p")
        if Snacks then
          Snacks.terminal.toggle({ "uv", "run", "python", f })
        else
          vim.cmd("10split | terminal uv run python " .. vim.fn.fnameescape(f))
        end
      end, { desc = "[P]ython [R]un file (uv)" })
    end,
  },

  -- Adapter pytest untuk neotest (<leader>z*)
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = { "nvim-neotest/neotest-python" },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      table.insert(opts.adapters, require("neotest-python")({
        runner = "pytest",
        python = require("utils.python").get_python_path(),
      }))
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et
