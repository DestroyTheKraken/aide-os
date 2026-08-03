#!/usr/bin/env bash
# Usage: run-in-terminal.sh /path/to/script
# Preference: Ghostty (GrokAide) → Ptyxis → GNOME Terminal → Console → xterm
set -euo pipefail
SCRIPT="$1"

if command -v ghostty >/dev/null 2>&1; then
  # -e sets initial-command; keep window after short commands via wait only if needed
  exec ghostty -e "$SCRIPT"
elif command -v ptyxis >/dev/null 2>&1; then
  # Ubuntu 24+ default terminal
  exec ptyxis -- "$SCRIPT"
elif command -v gnome-terminal >/dev/null 2>&1; then
  exec gnome-terminal -- "$SCRIPT"
elif command -v kgx >/dev/null 2>&1; then
  exec kgx -- "$SCRIPT"
elif command -v xterm >/dev/null 2>&1; then
  exec xterm -e "$SCRIPT"
else
  exec x-terminal-emulator -e "$SCRIPT"
fi
