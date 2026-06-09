# Neovim Configuration

A modular Neovim configuration based on [kickstart-modular.nvim](https://github.com/dam9000/kickstart-modular.nvim), focused on TypeScript/JavaScript/React development with full IDE features.

Managed by [Chezmoi](https://chezmoi.io).

## Requirements

- Neovim **>= 0.12.x** (uses `vim.uv`, `vim.lsp.config`, and other recent APIs)
- **Nerd Font** (for icons in which-key, statusline, bufferline, etc.)
- `git`, `make`, `unzip`, C compiler (for Treesitter and native plugins)
- **Optional:** `lazygit`, `ripgrep`, `fd`, `jq` (for enhanced telescope search and Hurl)
- **Chezmoi** (for dotfile management)

## Quick Start

```bash
# Install Chezmoi
sudo dnf install chezmoi  # Fedora
# or: brew install chezmoi

# Apply dotfiles from the source repo
chezmoi init --apply https://github.com/Anifyuli/dotfiles.git

# Start Neovim — plugins will auto-install
nvim
```

### Day-to-day usage

```bash
# Edit a managed file (opens in $EDITOR)
chezmoi edit ~/.config/nvim/init.lua

# See pending changes
chezmoi diff

# Apply changes to home directory
chezmoi apply

# Commit and push all changes
chezmoi cd   # enter source directory
git add . && git commit -m "update nvim config"
git push
```

## Structure

```
~/.config/nvim/
├── init.lua              # Entry point
├── .editorconfig         # EditorConfig (2-space indent)
├── KEYMAPS.md            # Full keymap reference
├── lazy-lock.json        # Plugin lockfile
└── lua/
    ├── core/
    │   ├── lazy.lua          # Lazy.nvim bootstrap
    │   ├── lazy-plugins.lua  # Plugin spec loader
    │   ├── options.lua       # Neovim options
    │   ├── keymaps.lua       # Global keymaps
    │   └── autocmds.lua      # Autocommands
    └── plugins/
        ├── ui.lua          # Dashboard, which-key, neo-tree, lualine, toggleterm, bufferline
        ├── telescope.lua   # Fuzzy finder
        ├── treesitter.lua  # Treesitter + textobjects
        ├── lspconfig.lua   # LSP, Mason, formatters
        ├── coding.lua      # Git, comments, completion, indent, trouble
        ├── debugger.lua    # DAP + DAP UI
        └── lang/
            ├── typescript.lua  # TS/JS DAP configs
            ├── http.lua        # Kulala .http client
            ├── markdown.lua    # Marksman, markdownlint, preview
            ├── json.lua        # SchemaStore, jsonls
            └── tailwind.lua    # Tailwind LSP + color preview
```

## Features

### Editor
- Leader key mapped to `Space` with `which-key.nvim` popup (50ms delay)
- 2-space indentation, smart tabs via `vim-sleuth`
- Persistent undo (10k levels)
- Smart search (case-insensitive when all lowercase)
- Auto-create directories on save
- Word-wrap aware `j`/`k` movement

### Theme & UI
- **Colorscheme:** Gruvbox (soft contrast, italic comments)
- **Dashboard:** Doom-style with startup timing stats
- **Statusline:** Lualine with mode, filename, line/col
- **Bufferline:** Cokeline with devicons, diagnostics, sidebar support
- **File explorer:** Neo-tree v3 with filesystem, buffers, git status sources

### LSP & Completion
- **Mason** auto-installs LSP servers: `ts_ls`, `lua_ls`, `cssls`, `html`, `eslint`, `tailwindcss`, `marksman`
- **Formatters:** Prettier, ESLint, Stylua, markdownlint
- **nvim-cmp** with LSP, LuaSnip, path, and buffer sources
- Auto-pairing for brackets

### Coding Tools
- **Git:** Gitsigns (inline blame, hunk staging), Fugitive, Rhubarb
- **Comments:** `gc` to toggle, TODO/FIXME highlighting
- **Indent guides** with blankline characters
- **Trouble** panel for diagnostics and TODO/FIXME lists

### Debugging (DAP)
- JavaScript/TypeScript debug adapter via Mason
- DAP UI with scopes, breakpoints, stacks, watches, REPL
- Configurations for Node.js, NestJS, React Native, Expo

### Terminal
- ToggleTerm with horizontal/vertical/float layouts
- Winbar indicator, window navigation from terminal mode

### Language Support
| Language | LSP | Tools |
|----------|-----|-------|
| TypeScript/JavaScript | `ts_ls`, `eslint` | DAP, complete function calls |
| Lua | `lua_ls` | Neovim runtime library |
| CSS/HTML | `cssls`, `html` | Tailwind color preview |
| JSON | `jsonls` | SchemaStore validation |
| HTTP/REST | `kulala` (built-in) | .http file execution, scripting, auth |
| Markdown | `marksman` | markdownlint, inline render |
| Tailwind CSS | `tailwindcss` | Colorizer in completion menu |

### Text Objects (Treesitter)
| Object | Select | Move |
|--------|--------|------|
| Parameter | `aa` / `ia` | Swap: `<leader>a` / `<leader>A` |
| Function | `af` / `if` | `]m` / `[m` |
| Class | `ac` / `ic` | `]]` / `[[` |

## Keymaps

See [KEYMAPS.md](./KEYMAPS.md) for the complete reference.

**Quick highlights:**

| Key | Action |
|-----|--------|
| `Space+S F` | Find files |
| `Space+S G` | Live grep |
| `Space+E` | File explorer |
| `Space+T H/V/F` | Terminal (horiz/vert/float) |
| `F5` | Debug continue |
| `gd` | Go to definition |
| `K` | Hover documentation |

## Plugins (~50 total)

Managed by [lazy.nvim](https://github.com/folke/lazy.nvim). Press `Space+L` or run `:Lazy` to manage.

Key plugins: gruvbox, which-key, dashboard, neo-tree, cokeline, lualine, toggleterm, telescope, treesitter, nvim-cmp, lspconfig, mason, gitsigns, fugitive, trouble, nvim-dap, render-markdown, kulala.

## Notes

- Terminal buffers are filtered out from the bufferline and session management
- DAP UI opens automatically on debug start and closes on termination
- Format on save is enabled globally via `BufWritePre` autocmd
- The `q` key closes special buffers (help, LSP info, quickfix, etc.)
