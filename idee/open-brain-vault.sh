#!/usr/bin/env bash
# Open the GrokAide Obsidian vault.
set -euo pipefail
VAULT="${AIDE_BRAIN_VAULT:-$HOME/AIDE_OS/brain}"
export PATH="$HOME/.local/bin:$PATH"

if command -v obsidian >/dev/null 2>&1; then
  # Obsidian URI open by path
  obsidian "obsidian://open?path=${VAULT}" &
  exit 0
fi

# AppImage / flatpak fallbacks
if [ -x "$HOME/.local/bin/Obsidian.AppImage" ]; then
  "$HOME/.local/bin/Obsidian.AppImage" "obsidian://open?path=${VAULT}" &
  exit 0
fi

echo "Obsidian not found. Open manually: $VAULT" >&2
exit 1
