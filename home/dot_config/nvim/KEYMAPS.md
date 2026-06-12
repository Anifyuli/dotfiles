# Referensi Keymap Neovim

**Tombol Leader** = `Space`

**Notasi modifier:** `Ctrl` = tombol Control, `Alt` = tombol Alt, `Shift` = tombol Shift, `Space` = spasi

---

## Umum

| Tombol | Mode | Fungsi |
|--------|------|--------|
| `Ctrl+S` | Normal | Simpan file |
| `Ctrl+Q` | Normal | Tutup paksa semua |
| `Space+N` | Normal | File baru |
| `Space+Q` | Normal | Tutup semua (konfirmasi) |
| `Del` | Visual | Hapus tanpa yank |
| `J` / `K` | Normal, Visual | Gerak cerdas (respek word wrap) |

## Navigasi Window

| Tombol | Fungsi |
|--------|--------|
| `Ctrl+H/J/K/L` | Pindah ke kiri/bawah/atas/kanan |
| `Ctrl+↑/↓/←/→` | Resize window |

## LSP & Diagnostik

| Tombol | Fungsi |
|--------|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `gD` | Go to declaration |
| `Space+D` | Type definition |
| `K` | Hover dokumentasi |
| `Space+R N` | Rename symbol |
| `Space+C A` | Code action (Normal & Visual) |
| `Space+D S` | Document symbols |
| `Space+W S` | Workspace symbols |
| `Space+C F` | Format buffer |
| `Space+C D` | Diagnostik baris (float) |
| `[d` / `]d` | Diagnostik sebelumnya/selanjutnya |
| (otomatis) | — | Popup diagnostik saat cursor diam di error |

> **Catatan:** Popup diagnostik muncul otomatis pas cursor berhenti bentar di baris error — mirip hover tooltip VS Code/Zed. Tutup otomatis pas cursor pindah. Code action (`<leader>ca`) di visual mode nerapin fix ke selection.

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
| `Space+sd` | Cari diagnostik |
| `Space+sr` | Resume |
| `Space+s.` | File terbaru |
| `Space+sn` | File config Neovim |
| `Space+s/` | Cari di file terbuka |
| `Space+sm` | Ikon |
| `Space+sM` | Man pages |
| `Space+,` | Buffer |
| `Space+<space>` | Smart find |
| `Space+:` | Riwayat command |

## Trouble (Dialog Error/Warning)

| Tombol | Fungsi |
|--------|--------|
| `Space+X X` | Toggle panel diagnostik |
| `Space+X W` | Toggle diagnostik buffer |
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
| `Space+D D` | Jalankan konfigurasi DAP |

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
| `Space+H D` | Diff terhadap index |
| `Space+Shift+D` | Diff terhadap commit terakhir |
| `Space+G B` | Toggle inline blame |
| `Space+G D` | Toggle deleted |
| `ih` | Text object: pilih hunk |

## Text Objects (Treesitter)

| Tombol | Fungsi |
|--------|--------|
| `aa` / `ia` | Parameter outer/inner |
| `af` / `if` | Fungsi outer/inner |
| `ac` / `ic` | Class outer/inner |
| `]m` / `[m` | Awal fungsi berikutnya/sebelumnya |
| `]]` / `[[` | Awal class berikutnya/sebelumnya |
| `Space+A` / `Space+Shift+A` | Swap parameter berikutnya/sebelumnya |
| `Ctrl+Space` | Seleksi incremental (expand) |
| `Alt+Space` | Seleksi incremental (shrink) |

## Manajemen Buffer

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
| `Space+z T` | Jalankan semua test |
| `Space+z t` | Jalankan file |
| `Space+z r` | Jalankan test terdekat |
| `Space+z s` | Toggle summary |
| `Space+z o` | Tampilkan output |

## Lompat Cepat (Flash)

| Tombol | Mode | Fungsi |
|--------|------|--------|
| `s` | Normal | Lompat ke label |
| `S` | Normal, Visual | Lompat ke kata (treesitter) |
| `R` | Normal | Remote jump |
| `Ctrl+S` | Insert | Lompat ke label |
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

## Lainnya

| Tombol | Fungsi |
|--------|--------|
| `Space+e` | Toggle file explorer (Neo-tree) |
| `Space+gl` | LazyGit (floating) |
| `gc` | Toggle komentar (Normal/Visual) |
| `Space+C P` | Toggle markdown render |
| `Space+Q S` / `Space+Q D` / `Space+Q L` | Session save/restore |

## Perintah

| Perintah | Fungsi |
|----------|--------|
| `:Format` | Format buffer via LSP |
| `:ToggleQuickfix` | Toggle quickfix window |
| `:LineDiagnostics` | Tampilkan diagnostik baris |
