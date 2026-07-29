#!/usr/bin/env bash
set -e

TPM_DIR="$HOME/.tmux/plugins/tpm"

if [ ! -d "$TPM_DIR" ]; then
  echo "Installing Tmux Plugin Manager (TPM)..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# Install/update tmux plugins
"$TPM_DIR/bin/install_plugins" 2>/dev/null || true
