# Konfigurasi Neovim

Konfigurasi Neovim modular berbasis [kickstart-modular.nvim](https://github.com/dam9000/kickstart-modular.nvim), fokus pada pengembangan TypeScript/JavaScript/React dengan fitur IDE lengkap.

Config ini ada di dalam repo dotfiles [Chezmoi](https://chezmoi.io) di [github.com/Anifyuli/dotfiles](https://github.com/Anifyuli/dotfiles).

## Persyaratan

- Neovim **>= 0.12.x** (menggunakan `vim.uv`, `vim.lsp.config`, dan API terbaru lainnya)
- **Nerd Font** (untuk ikon di which-key, statusline, bufferline, dll.)
- `git`, `make`, `unzip`, C compiler (untuk Treesitter dan plugin native)
- **Opsional:** `lazygit`, `ripgrep`, `fd`, `jq` (untuk pencarian dan Hurl)

## Clone tanpa Chezmoi

```bash
git clone --depth 1 --filter=blob:none --sparse \
  https://github.com/Anifyuli/dotfiles.git /tmp/dotfiles
cd /tmp/dotfiles
git sparse-checkout set home/dot_config/nvim
mkdir -p ~/.config/
cp -r home/dot_config/nvim ~/.config/nvim/
rm -rf /tmp/dotfiles
nvim
```

## Mulai Cepat (dengan Chezmoi)

```bash
# Install Chezmoi
sudo dnf install chezmoi  # Fedora
# atau: brew install chezmoi

# Terapkan dotfiles dari repo sumber
chezmoi init --apply https://github.com/Anifyuli/dotfiles.git

# Jalankan Neovim — plugin akan terinstall otomatis
nvim
```

### Penggunaan sehari-hari

```bash
# Edit file yang dikelola (buka di $EDITOR)
chezmoi edit ~/.config/nvim/init.lua

# Lihat perubahan tertunda
chezmoi diff

# Terapkan perubahan ke home directory
chezmoi apply

# Commit dan push semua perubahan
chezmoi cd   # masuk ke direktori sumber
git add . && git commit -m "update nvim config"
git push
```

## Struktur

```
~/.config/nvim/
├── init.lua              # Entry point
├── .editorconfig         # EditorConfig (indent 2-spasi)
├── KEYMAPS.md            # Referensi keymap lengkap
├── lazy-lock.json        # Plugin lockfile
└── lua/
    ├── core/
    │   ├── lazy.lua          # Bootstrap lazy.nvim
    │   ├── lazy-plugins.lua  # Loader spesifikasi plugin
    │   ├── options.lua       # Opsi Neovim
    │   ├── keymaps.lua       # Keymap global
    │   └── autocmds.lua      # Autocommands
    └── plugins/
        ├── ui.lua          # Which-key, bufferline, edgy, neo-tree, lualine
        ├── snacks.lua      # Picker, image, dashboard, terminal, scroll
        ├── treesitter.lua  # Treesitter + textobjects
        ├── lspconfig.lua   # LSP, Mason, formatter
        ├── coding.lua      # Git, komentar, flash, neotest, completion, indent, trouble
        ├── debugger.lua    # DAP + DAP UI
        └── lang/
            ├── typescript.lua  # Konfigurasi DAP TS/JS
            ├── http.lua        # Klien Kulala .http
            ├── markdown.lua    # Marksman, markdownlint, preview
            ├── json.lua        # SchemaStore, jsonls
            └── tailwind.lua    # LSP Tailwind + pratinjau warna
```

## Fitur

### Editor
- Tombol Leader dipetakan ke `Space` dengan `which-key.nvim` (delay 50ms)
- Indentasi 2-spasi, smart tabs via `vim-sleuth`
- Undo persisten (10k level)
- Pencarian cerdas (case-insensitive saat semua huruf kecil)
- Buat direktori otomatis saat menyimpan
- Pergerakan `j`/`k` sadar word-wrap

### Tema & UI
- **Skema warna:** Gruvbox (soft contrast, italic comments)
- **Dashboard:** Gaya Doom dengan statistik startup
- **Statusline:** Lualine dengan mode, nama file, baris/kolom
- **Bufferline:** Bufferline.nvim dengan devicon, diagnostik, dukungan sidebar
- **File explorer:** Neo-tree v3 dengan filesystem, buffer, status git

### LSP & Completion
- **Mason** auto-install server LSP: `ts_ls`, `lua_ls`, `cssls`, `html`, `eslint`, `tailwindcss`, `marksman`
- **Formatter:** Prettier, ESLint, Stylua, markdownlint
- **nvim-cmp** dengan sumber LSP, LuaSnip, path, dan buffer
- Auto-pairing bracket

### Tools Coding
- **Git:** Gitsigns (inline blame, hunk staging), Fugitive, Rhubarb
- **Komentar:** `gc` untuk toggle, highlighting TODO/FIXME
- **Panduan indent** dengan karakter blankline
- **Trouble** panel untuk diagnostik dan daftar TODO/FIXME

### Debugging (DAP)
- Debug adapter JavaScript/TypeScript via Mason
- DAP UI dengan scopes, breakpoints, stacks, watches, REPL
- Konfigurasi untuk Node.js, NestJS, React Native, Expo

### Terminal
- Snacks Terminal dengan tmux (tata letak horizontal/vertikal/float)
- Sesi tmux baru setiap toggle (tidak ada re-attach basi)
- Indikator Winbar, navigasi window dari mode terminal

### Dukungan Bahasa
| Bahasa | LSP | Tools |
|--------|-----|-------|
| TypeScript/JavaScript | `ts_ls`, `eslint` | DAP, complete function calls |
| Lua | `lua_ls` | Neovim runtime library |
| CSS/HTML | `cssls`, `html` | Pratinjau warna Tailwind |
| JSON | `jsonls` | Validasi SchemaStore |
| HTTP/REST | `kulala` (built-in) | Eksekusi file .http, scripting, auth |
| Markdown | `marksman` | markdownlint, render inline |
| Tailwind CSS | `tailwindcss` | Colorizer di menu completion |

### Text Objects (Treesitter)
| Objek | Pilih | Pindah |
|-------|-------|--------|
| Parameter | `aa` / `ia` | Swap: `<leader>a` / `<leader>A` |
| Fungsi | `af` / `if` | `]m` / `[m` |
| Class | `ac` / `ic` | `]]` / `[[` |

## Keymap

Lihat [KEYMAPS.md](./KEYMAPS.md) untuk referensi lengkap.

**Sorotan cepat:**

| Tombol | Aksi |
|--------|------|
| `Space+ff` | Cari file |
| `Space+/` atau `Space+sg` | Live grep |
| `Space+e` | File explorer |
| `Space+gl` | LazyGit |
| `Space+T h/v/f` | Terminal (horiz/vert/float) |
| `F5` | Debug continue |
| `gd` | Go to definition |
| `K` | Hover dokumentasi |

## Plugin (~50 total)

Dikelola oleh [lazy.nvim](https://github.com/folke/lazy.nvim). Tekan `Space+L` atau jalankan `:Lazy` untuk mengelola.

Plugin utama: gruvbox, which-key, snacks.nvim, neo-tree, bufferline, lualine, treesitter, nvim-cmp, lspconfig, mason, gitsigns, fugitive, trouble, nvim-dap, flash.nvim, neotest, render-markdown, kulala.

## Catatan

- Buffer terminal difilter dari bufferline dan manajemen sesi
- DAP UI terbuka otomatis saat debug mulai dan tertutup saat selesai
- Format on save diaktifkan global via autocmd `BufWritePre`
- Tombol `q` menutup buffer khusus (help, LSP info, quickfix, dll.)
