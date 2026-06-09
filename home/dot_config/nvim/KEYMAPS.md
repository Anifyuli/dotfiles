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

## Telescope (Search)

| Tombol | Fungsi |
|--------|--------|
| `Space+S F` | Cari file |
| `Space+S G` | Live grep |
| `Space+S W` | Cari kata sekarang |
| `Space+S H` | Cari help |
| `Space+S K` | Cari keymap |
| `Space+S D` | Cari diagnostic |
| `Space+S S` | Pilih Telescope |
| `Space+S R` | Resume |
| `Space+S .` | File terbaru |
| `Space+S N` | File config Neovim |
| `Space+S /` | Cari di file terbuka |
| `Space+Space` | Cari buffer |
| `Space+/` | Fuzzily cari di buffer aktif |

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
| `Space+T B` | Toggle inline blame |
| `Space+T D` | Toggle deleted |
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

## Terminal (Toggleterm)

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

## Other

| Tombol | Fungsi |
|--------|--------|
| `Space+E` | Toggle Neo-tree explorer |
| `gc` | Toggle comment (Normal/Visual) |
| `Space+C P` | Toggle markdown preview |
| `Space+Q S` / `Space+Q D` / `Space+Q L` | Session save/restore |

## Commands

| Command | Fungsi |
|---------|--------|
| `:Format` | Format buffer via LSP |
| `:ToggleQuickfix` | Toggle quickfix window |
| `:LineDiagnostics` | Show line diagnostics |
