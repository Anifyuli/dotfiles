# Neovim Keymap Reference

**Leader key** = `Space`

**Modifier notation:** `Ctrl` = Control key, `Alt` = Alt key, `Shift` = Shift key

---

## General

| Key | Mode | Action |
|-----|------|--------|
| `Ctrl+S` | Normal | Save file |
| `Ctrl+Q` | Normal | Force close all |
| `Space+N` | Normal | New file |
| `Space+Q` | Normal | Close all (confirm) |
| `Del` | Visual | Delete without yank |
| `J` / `K` | Normal, Visual | Smart movement (respects word wrap) |

## Window Navigation

| Key | Action |
|-----|--------|
| `Ctrl+H/J/K/L` | Move left/down/up/right |
| `Ctrl+↑/↓/←/→` | Resize window |

## LSP & Diagnostics

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `gD` | Go to declaration |
| `Space+D` | Type definition |
| `K` | Hover documentation |
| `Space+R N` | Rename symbol |
| `Space+ca` | Code action (Normal & Visual) |
| `Space+cA` | Source action (imports, remove unused, etc.) |
| `Space+co` | Organize imports |
| `Space+D S` | Document symbols |
| `Space+W S` | Workspace symbols |
| `Space+C F` | Format buffer |
| `Space+C D` | Line diagnostics (float) |
| `[d` / `]d` | Previous/next diagnostic |
| (auto) | Diagnostic popup on cursor hold |

> **Note:** Diagnostic popup appears automatically when cursor rests on an error (like VS Code hover tooltip). Auto-closes on cursor move. Code action (`<leader>ca`) in visual mode applies fixes to the selection.

## Picker (Snacks)

| Key | Action |
|-----|--------|
| `Space+ff` | Find files |
| `Space+fg` | Git files |
| `Space+fr` | Recent files |
| `Space+fc` | Neovim config files |
| `Space+sg` or `Space+/` | Live grep |
| `Space+sw` | Search current word (N/X) |
| `Space+sh` | Search help |
| `Space+sk` | Search keymaps |
| `Space+ss` | LSP symbols |
| `Space+sd` | Search diagnostics |
| `Space+sr` | Resume |
| `Space+s.` | Recent files |
| `Space+sn` | Neovim config files |
| `Space+s/` | Search in open files |
| `Space+sm` | Icons |
| `Space+sM` | Man pages |
| `Space+,` | Buffers |
| `Space+<space>` | Smart find |
| `Space+:` | Command history |

## Trouble (Error/Warning Panel)

| Key | Action |
|-----|--------|
| `Space+X X` | Toggle diagnostic panel |
| `Space+X W` | Toggle buffer diagnostics |
| `Space+X T` | Toggle TODO/FIXME |
| `Space+C X` | Toggle quickfix list |

## Debugger (DAP)

| Key | Action |
|-----|--------|
| `F5` | Start / Continue |
| `F1` | Step Into |
| `F2` | Step Over |
| `F3` | Step Out |
| `F4` | Run to Cursor |
| `F12` | Toggle DAP UI panel |
| `Space+B` | Toggle breakpoint |
| `Space+Shift+B` | Conditional breakpoint |
| `Space+D R` | Restart |
| `Space+D D` | Run DAP configuration |

## Git (Gitsigns)

| Key | Action |
|-----|--------|
| `]c` / `[c` | Next/previous hunk |
| `Space+H S` | Stage hunk |
| `Space+H R` | Reset hunk |
| `Space+Shift+S` | Stage buffer |
| `Space+H U` | Undo stage hunk |
| `Space+Shift+R` | Reset buffer |
| `Space+H P` | Preview hunk |
| `Space+H B` | Blame line |
| `Space+H D` | Diff against index |
| `Space+Shift+D` | Diff against last commit |
| `Space+G B` | Toggle inline blame |
| `Space+G D` | Toggle deleted |
| `ih` | Text object: select hunk |

## Treesitter Text Objects

| Key | Action |
|-----|--------|
| `aa` / `ia` | Parameter outer/inner |
| `af` / `if` | Function outer/inner |
| `ac` / `ic` | Class outer/inner |
| `]m` / `[m` | Function start next/prev |
| `]]` / `[[` | Class start next/prev |
| `Space+A` / `Space+Shift+A` | Swap parameter next/prev |
| `Ctrl+Space` | Incremental selection (expand) |
| `Alt+Space` | Incremental selection (shrink) |

## Buffer Management

| Key | Action |
|-----|--------|
| `Tab` / `Shift+Tab` | Next/previous buffer |
| `Space+B N` / `Space+B P` | Switch next/prev buffer |
| `Space+B 1`–`9` | Switch to buffer by index |
| `Space+B D` | Delete buffer |
| `Space+Shift+D` | Delete buffer (force) |

## Test (Neotest)

| Key | Action |
|-----|--------|
| `Space+z T` | Run all tests |
| `Space+z t` | Run file |
| `Space+z r` | Run nearest test |
| `Space+z s` | Toggle summary |
| `Space+z o` | Show output |

## Quick Jump (Flash)

| Key | Mode | Action |
|-----|------|--------|
| `s` | Normal | Jump to label |
| `S` | Normal, Visual | Jump to word (treesitter) |
| `R` | Normal | Remote jump |
| `Ctrl+S` | Insert | Jump to label |
| `r` | Op-pending | Remote operator |

## Terminal (Snacks/Tmux)

| Key | Mode | Action |
|-----|------|--------|
| `F7` | Normal, Terminal | Toggle terminal |
| `Space+T T` | Normal | Terminal picker (reopen hidden terminals) |
| `Space+T H` | Normal | Terminal horizontal |
| `Space+T V` | Normal | Terminal vertical |
| `Space+T F` | Normal | Terminal floating |
| `jk` / `Alt+Q` | Terminal | Exit terminal mode → normal |
| `Ctrl+H/J/K/L` | Terminal | Move left/down/up/right |
| `Ctrl+W` | Terminal | Window commands (followed by h/j/k/l...) |
| `Alt+.` | Normal, Terminal | Close all terminals |
| `Alt+,` | Normal, Terminal | Close active terminal |

## API Client (Kulala)

| Key | Action |
|-----|--------|
| `Space+R S` | Send request under cursor |
| `Space+R A` | Send all requests in file |
| `Space+R D` | Send request (debug mode) |
| `Space+R B` | Open scratchpad |

## Other

| Key | Action |
|-----|--------|
| `Space+e` | Toggle file explorer (Neo-tree) |
| `Space+gl` | LazyGit (floating) |
| `gc` | Toggle comment (Normal/Visual) |
| `Space+C P` | Toggle markdown render |
| `Space+Q S` / `Space+Q D` / `Space+Q L` | Session save/restore |

## Commands

| Command | Action |
|---------|--------|
| `:Format` | Format buffer via LSP |
| `:ToggleQuickfix` | Toggle quickfix window |
| `:LineDiagnostics` | Show line diagnostics |
