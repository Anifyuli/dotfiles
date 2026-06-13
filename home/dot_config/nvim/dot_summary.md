# Neovim Config @ Chezmoi

Managed via Chezmoi. Source: `~/.local/share/chezmoi/home/dot_config/nvim/`

## Sesi Ini

- **KEYMAPS.md konsisten Inggris** — semua kolom, deskripsi, dan note full English.
- **`<leader>Tt`** — Terminal picker: daftar semua buffer terminal hidup untuk reopen setelah edgy hide.
- **Auto-diagnostic popup** pada CursorHold (float, auto-close saat cursor pindah).
- **Visual mode `<leader>ca`** — code action pada selection.

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
