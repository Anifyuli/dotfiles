#!/usr/bin/env bash
set -e

# Keep Plasma Groovbx (Gruvbox KDE Global Theme) cloned and installed.
# run_after_*: runs on every `chezmoi apply` (idempotent, cheap: git pull
# is a no-op when there's nothing new, and install.sh just re-copies files).
#
# Deploys to its own clone under ~/.local/share/plasma-groovbx, separate
# from any working copy under ~/Projects used for actually developing the
# theme, so this script never touches a dev checkout's working tree.

REPO_DIR="$HOME/.local/share/plasma-groovbx"
REPO_URL="git@github.com:Anifyuli/plasma-groovbx.git"

if [ -d "$REPO_DIR/.git" ]; then
  git -C "$REPO_DIR" pull --ff-only
else
  mkdir -p "$(dirname "$REPO_DIR")"
  git clone "$REPO_URL" "$REPO_DIR"
fi

bash "$REPO_DIR/install.sh" -g
