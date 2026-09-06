#!/usr/bin/env bash
set -euo pipefail

files=()
for f in "$@"; do
  if [[ "${f,,}" == *.appimage && -f "$f" ]]; then
    files+=("$f")
  fi
done

if [[ ${#files[@]} -eq 0 ]]; then
  kdialog --title "Soar" --error "No AppImage selected."
  exit 1
fi

total=${#files[@]}
failed=0
for f in "${files[@]}"; do
  if ! soar install "$f"; then
    ((++failed))
  fi
done

if (( failed == 0 )); then
  kdialog --title "Soar" --passivepopup "$total AppImage(s) installed." 4
else
  kdialog --title "Soar" --error "$failed of $total failed."
fi