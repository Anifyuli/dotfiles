#!/usr/bin/env bash
set -e

# Keep a fresh clone of Plasma Groovbx (Gruvbox KDE Global Theme) around.
# run_after_*: runs on every `chezmoi apply` (idempotent, cheap: git pull
# is a no-op when there's nothing new).
#
# Deliberately does NOT run install.sh - applying the theme is a per-machine
# choice, not something chezmoi should force on every host it's used on.
# Deploys to its own clone under ~/.local/share/plasma-groovbx, separate
# from any working copy under ~/Projects used for actually developing the
# theme, so this script never touches a dev checkout's working tree.
#
# To actually apply it on a given machine: ~/.local/share/plasma-groovbx/install.sh

REPO_DIR="$HOME/.local/share/plasma-groovbx"
REPO_URL="git@github.com:Anifyuli/plasma-groovbx.git"

if [ -d "$REPO_DIR/.git" ]; then
  git -C "$REPO_DIR" pull --ff-only
else
  mkdir -p "$(dirname "$REPO_DIR")"
  git clone "$REPO_URL" "$REPO_DIR"
fi
