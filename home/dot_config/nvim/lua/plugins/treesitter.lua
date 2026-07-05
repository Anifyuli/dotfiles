return {
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  event = { "BufReadPre", "BufNewFile" },
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter').setup {
      -- Add languages to be installed here that you want installed for treesitter
      ensure_installed = {
        'bash',
        'css',
        'html',
        'javascript',
        'json',
        'lua',
        'markdown',
        'markdown_inline',
        'php',
        'regex',
        'toml',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'vue',
        'yaml',
      },

      -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
      auto_install = true,
      -- Install languages synchronously (only applied to `ensure_installed`)
      sync_install = true,
      -- List of parsers to ignore installing
      ignore_install = {},
      -- You can specify additional Treesitter modules here: -- For example: -- playground = {--enable = true,-- },
      modules = {},
      highlight = { enable = true },
      indent = {
        enable = true,
        disable = { 'html' },
      },
  
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = '@class.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
              ['<leader>A'] = '@parameter.inner',
            },
          },
        },
      }
  end
}
