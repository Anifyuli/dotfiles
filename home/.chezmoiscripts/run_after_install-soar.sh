#!/usr/bin/env bash
set -e

# Install Soar if not already present.
# run_after_*: runs on every `chezmoi apply` (idempotent, cheap).
# Existence check covers PATH plus known install locations, so it works
# on a fresh host before the shell config has put ~/.local/bin in PATH.
if command -v soar >/dev/null 2>&1; then
  echo "Soar already installed: $(command -v soar)"
  exit 0
fi

for p in "$HOME/.local/bin/soar" "/usr/local/bin/soar" "$HOME/.local/share/soar/bin/soar"; do
  if [ -x "$p" ]; then
    echo "Soar already installed: $p"
    exit 0
  fi
done

echo "Installing Soar..."
curl -fsSL https://soar.qaidvoid.dev/install.sh | SOAR_INSTALL_DIR="$HOME/.local/bin" sh

if ! command -v soar >/dev/null 2>&1; then
  echo "ERROR: Soar install failed; soar not found in PATH after install" >&2
  exit 1
fi

echo "Soar installed: $(command -v soar)"