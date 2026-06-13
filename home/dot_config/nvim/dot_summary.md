# Neovim Config @ Chezmoi

Managed via Chezmoi. Source: `~/.local/share/chezmoi/home/dot_config/nvim/`

## Sesi Ini

- **Toggle task mode** (`<leader>dt`): neovim (Snacks terminal) ↔ tmux (persistent session `nvim-tasks`).
  - Tmux mode bikin headless session otomatis — gak perlu ada di dalam tmux.
  - Task persist walau Neovim ditutup. Cek via `tmux attach -t nvim-tasks`.
- **Prewarm cache** — task picker cache di-populate 3 detik setelah buffer pertama dibuka, `<leader>dd` jadi instan.
- **Startup 76ms → 54ms** — defer `vim.lsp`/`vim.diagnostic` load (keymap wrapper), cache `detect_background()` dibatalkan (risiko bug > benefit).
- **Task picker header** — `Task:  Neovim` / `Task:  Tmux`.
- **Silent toggle** — nggak ada WARN notification kalo di luar tmux.

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
