# Neovim Config @ Chezmoi

Managed via Chezmoi. Source: `~/.local/share/chezmoi/home/dot_config/nvim/`

## Perubahan Sesi Ini

1. **render-markdown.nvim H1 hitam fixed**: `heading.backgrounds = {}` — akar masalah `DiffText` punya `fg = #282828` (background-color gelap) yang override heading text via `hl_eol`.
2. **headlines.nvim di-remove**: redundant dengan render-markdown.
3. **README.md diperbarui**: instruksi clone git → Chezmoi init/apply + daily usage commands.
4. **Config pindah ke Chezmoi**: `chezmoi add ~/.config/nvim`, local `.git` dihapus.

## Commands

```bash
chezmoi edit ~/.config/nvim/init.lua  # edit via $EDITOR
chezmoi re-add ~/.config/nvim         # sync source setelah perubahan manual
chezmoi diff                           # lihat pending changes
chezmoi apply                          # apply ke home directory
chezmoi cd                             # masuk source repo
git add . && git commit -m "msg"       # commit
git push                               # push
```
