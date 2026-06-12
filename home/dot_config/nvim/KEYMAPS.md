# Neovim Keymap Reference

**Leader key** = `Space`

**Notasi modifier:** `Ctrl` = tombol Control, `Alt` = tombol Alt, `Shift` = tombol Shift, `Space` = spasi

---

## General

| Tombol | Mode | Fungsi |
|--------|------|--------|
| `Ctrl+S` | Normal | Simpan file |
| `Ctrl+Q` | Normal | Tutup paksa semua |
| `Space+N` | Normal | File baru |
| `Space+Q` | Normal | Tutup semua (konfirmasi) |
| `Del` | Visual | Hapus tanpa yank |
| `J` / `K` | Normal, Visual | Gerak cerdas (respek word wrap) |

## Window Navigation

| Tombol | Fungsi |
|--------|--------|
| `Ctrl+H/J/K/L` | Pindah ke kiri/bawah/atas/kanan |
| `Ctrl+↑/↓/←/→` | Resize window |

## LSP & Diagnostics

| Tombol | Fungsi |
|--------|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `gD` | Go to declaration |
| `Space+D` | Type definition |
| `K` | Hover dokumentasi |
| `Space+R N` | Rename symbol |
| `Space+C A` | Code action |
| `Space+D S` | Document symbols |
| `Space+W S` | Workspace symbols |
| `Space+C F` | Format buffer |
| `Space+C D` | Line diagnostics (float) |
| `[d` / `]d` | Diagnostic sebelumnya/selanjutnya |

## Picker (Snacks)

| Tombol | Fungsi |
|--------|--------|
| `Space+ff` | Cari file |
| `Space+fg` | Cari file git |
| `Space+fr` | File terbaru |
| `Space+fc` | File config Neovim |
| `Space+sg` atau `Space+/` | Live grep |
| `Space+sw` | Cari kata sekarang (N/X) |
| `Space+sh` | Cari help |
| `Space+sk` | Cari keymap |
| `Space+ss` | LSP Symbols |
| `Space+sd` | Cari diagnostic |
| `Space+sr` | Resume |
| `Space+s.` | File terbaru |
| `Space+sn` | File config Neovim |
| `Space+s/` | Cari di file terbuka |
| `Space+sm` | Icons |
| `Space+sM` | Man pages |
| `Space+,` | Buffer |
| `Space+<space>` | Smart find |
| `Space+:` | Command history |

## Trouble (Error/Warning Dialog)

| Tombol | Fungsi |
|--------|--------|
| `Space+X X` | Toggle panel diagnostic |
| `Space+X W` | Toggle diagnostic buffer |
| `Space+X T` | Toggle TODO/FIXME |
| `Space+C X` | Toggle quickfix list |

## Debugger (DAP)

| Tombol | Fungsi |
|--------|--------|
| `F5` | Start / Continue |
| `F1` | Step Into |
| `F2` | Step Over |
| `F3` | Step Out |
| `F4` | Run to Cursor |
| `F12` | Toggle panel DAP UI |
| `Space+B` | Toggle breakpoint |
| `Space+Shift+B` | Conditional breakpoint |
| `Space+D R` | Restart |
| `Space+D D` | Run DAP configuration |

## Git (Gitsigns)

| Tombol | Fungsi |
|--------|--------|
| `]c` / `[c` | Hunk berikutnya/sebelumnya |
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

| Tombol | Fungsi |
|--------|--------|
| `aa` / `ia` | Parameter outer/inner |
| `af` / `if` | Function outer/inner |
| `ac` / `ic` | Class outer/inner |
| `]m` / `[m` | Function start berikutnya/sebelumnya |
| `]]` / `[[` | Class start berikutnya/sebelumnya |
| `Space+A` / `Space+Shift+A` | Swap parameter berikutnya/sebelumnya |
| `Ctrl+Space` | Incremental selection (expand) |
| `Alt+Space` | Incremental selection (shrink) |

## Buffer Management

| Tombol | Fungsi |
|--------|--------|
| `Tab` / `Shift+Tab` | Buffer berikutnya/sebelumnya |
| `Space+B N` / `Space+B P` | Switch next/prev buffer |
| `Space+B 1`–`9` | Switch ke buffer by index |
| `Space+B D` | Hapus buffer |
| `Space+Shift+D` | Hapus buffer (paksa) |

## Test (Neotest)

| Tombol | Fungsi |
|--------|--------|
| `Space+z T` | Run all tests |
| `Space+z t` | Run file |
| `Space+z r` | Run nearest test |
| `Space+z s` | Toggle summary |
| `Space+z o` | Show output |

## Quick Jump (Flash)

| Tombol | Mode | Fungsi |
|--------|------|--------|
| `s` | Normal | Jump ke label |
| `S` | Normal, Visual | Jump ke kata (treesitter) |
| `R` | Normal | Remote jump |
| `Ctrl+S` | Insert | Jump ke label |
| `r` | Op-pending | Remote operator |

## Terminal (Snacks/Tmux)

| Tombol | Mode | Fungsi |
|--------|------|--------|
| `F7` | Normal, Terminal | Toggle terminal |
| `Space+T H` | Normal | Terminal horizontal |
| `Space+T V` | Normal | Terminal vertikal |
| `Space+T F` | Normal | Terminal floating |
| `jk` / `Alt+Q` | Terminal | Keluar terminal mode → normal |
| `Ctrl+H/J/K/L` | Terminal | Pindah ke kiri/bawah/atas/kanan |
| `Ctrl+W` | Terminal | Window commands (dilanjut h/j/k/l...) |
| `Alt+.` | Normal, Terminal | Tutup semua terminal |
| `Alt+,` | Normal, Terminal | Tutup terminal aktif |

## API Client (Kulala)

| Tombol | Fungsi |
|--------|--------|
| `Space+R S` | Kirim request di bawah kursor |
| `Space+R A` | Kirim semua request di file |
| `Space+R D` | Kirim request (debug mode) |
| `Space+R B` | Buka scratchpad |

## Other

| Tombol | Fungsi |
|--------|--------|
| `Space+e` | Toggle file explorer (Neo-tree) |
| `Space+gl` | LazyGit (floating) |
| `gc` | Toggle comment (Normal/Visual) |
| `Space+C P` | Toggle markdown render |
| `Space+Q S` / `Space+Q D` / `Space+Q L` | Session save/restore |

## Commands

| Command | Fungsi |
|---------|--------|
| `:Format` | Format buffer via LSP |
| `:ToggleQuickfix` | Toggle quickfix window |
| `:LineDiagnostics` | Show line diagnostics |
