return {
  {
    -- Add Wakatime to tracking coding activities in Neovim
    'wakatime/vim-wakatime',
    enabled = true,
    event = "VeryLazy",
  },
  -- Git related plugins
  { 'tpope/vim-fugitive', cmd = "G" },
  { 'tpope/vim-rhubarb', event = "VeryLazy" },

  -- Detect tabstop and shiftwidth automatically
  { 'tpope/vim-sleuth', event = { "BufReadPre", "BufNewFile" } },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    event = "VeryLazy",
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {
      indent = {
        char = '│',
        tab_char = '│',
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          'help',
          'dashboard',
          'Trouble',
          'trouble',
          'lazy',
          'mason',
          'toggleterm',
          'snacks_terminal',
          'neo-tree',
        },
      },
    },
  },
  {
    -- 'gc' to comment visual regions/lines
    'numToStr/Comment.nvim',
    event = { "BufReadPre", "BufNewFile" },
    opts = {}
  },
  {
    -- Seamless navigation between Neovim windows & tmux panes
    'christoomey/vim-tmux-navigator',
    event = "VeryLazy",
    cmd = { "TmuxNavigateLeft", "TmuxNavigateDown", "TmuxNavigateUp", "TmuxNavigateRight", "TmuxNavigatePrevious" },
    init = function()
      vim.g.tmux_navigator_no_wrap = 1
    end,
    config = function()
      local wk = require("which-key")
      wk.add({
        { "<C-h>", desc = "Window left (tmux-aware)" },
        { "<C-j>", desc = "Window down (tmux-aware)" },
        { "<C-k>", desc = "Window up (tmux-aware)" },
        { "<C-l>", desc = "Window right (tmux-aware)" },
      })
    end,
  },
  {
    -- Git signs
    'lewis6991/gitsigns.nvim',
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local gs = require('gitsigns')

      vim.keymap.set('n', '<leader>hs', gs.stage_hunk, { desc = 'Stage hunk' })
      vim.keymap.set('n', '<leader>hr', gs.reset_hunk, { desc = 'Reset hunk' })
      vim.keymap.set('n', '<leader>hS', gs.stage_buffer, { desc = 'Stage buffer' })
      vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'Undo stage hunk' })
      vim.keymap.set('n', '<leader>hR', gs.reset_buffer, { desc = 'Reset buffer' })
      vim.keymap.set('n', '<leader>hp', gs.preview_hunk, { desc = 'Preview hunk' })
      vim.keymap.set('n', '<leader>hb', function()
        gs.blame_line { full = false }
      end, { desc = 'Blame line' })
      vim.keymap.set('n', '<leader>hd', gs.diffthis, { desc = 'Diff against index' })
      vim.keymap.set('n', '<leader>hD', function()
        gs.diffthis '~'
      end, { desc = 'Diff against last commit' })
      vim.keymap.set('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'Toggle blame' })
      vim.keymap.set('n', '<leader>td', gs.toggle_deleted, { desc = 'Toggle deleted' })

      require('gitsigns').setup({
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation (buffer-local — diff detection)
          map({ 'n', 'v' }, ']c', function()
            if vim.wo.diff then
              return ']c'
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return '<Ignore>'
          end, { expr = true, desc = 'Jump to next hunk' })

          map({ 'n', 'v' }, '[c', function()
            if vim.wo.diff then
              return '[c'
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return '<Ignore>'
          end, { expr = true, desc = 'Jump to previous hunk' })

          -- Visual-mode actions (buffer-local — operate on visual selection)
          map('v', '<leader>hs', function()
            gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end, { desc = 'stage git hunk' })
          map('v', '<leader>hr', function()
            gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end, { desc = 'reset git hunk' })

          -- Text object
          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
        end,
      })
    end,
  },
  {
    -- Web server, like Live Server for VS Code
    "ray-x/web-tools.nvim",
    enabled = true,
    ft = { "http", "hurl" },
    opts = {
      keymaps = {
        rename = nil,         -- by default use same setup of lspconfig
        repeat_rename = ".",  -- . to repeat
      },
      hurl = {                -- hurl default
        show_headers = false, -- do not show http headers
        floating = false,     -- use floating windows (need guihua.lua)
        json5 = false,        -- use json5 parser require json5 treesitter
        formatters = {        -- format the result by filetype
          json = { "jq" },
          html = { "prettier", "--parser", "html" },
        },
      },
    },
  },
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { focus = true },
    keys = {
      { "<leader>xx", function() require("trouble").toggle("diagnostics") end, desc = "Diagnostics (Trouble)" },
      { "<leader>xw", function() require("trouble").toggle({ mode = "diagnostics", filter = { buf = 0 } }) end, desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>xt", function() require("trouble").toggle("todo") end, desc = "Todo (Trouble)" },
    },
  },
  {
    -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim',
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false }
  },
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets
          -- This step is not supported in many windows environments
          -- Remove the below condition to re-enable on windows
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',

      -- If you want to add a bunch of pre-configured snippets,
      --    you can use this plugin to help you. It even has snippets
      --    for various frameworks/libraries/etc. but you will have to
      --    set up the ones that are useful for you.
      'rafamadriz/friendly-snippets',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-y>'] = cmp.mapping.confirm { select = true },

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
          -- Autopairs mapping
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'buffer' }
        },
      }
    end,
  },
  {
    -- Autopairs
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)

      -- setup cmp for autopairs
      local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
  {
    -- Auto close HTML/JSX tags via treesitter
    'windwp/nvim-ts-autotag',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = "VeryLazy",
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = true,
        },
      })
    end,
  },
}
