#!/usr/bin/env bash
# Open the GrokAide Obsidian vault.
set -euo pipefail
VAULT="${AIDE_BRAIN_VAULT:-$HOME/AIDE_OS/brain}"
URI="obsidian://open?path=${VAULT}"
export PATH="$HOME/.local/bin:$PATH"

# Real Obsidian is a large Electron binary. A common footgun is
# ~/.local/bin/obsidian being the *CLI* stub (obsidian-cli, ~14KB), which
# only talks to an already-running app and fails silently from a panel click.
is_gui_obsidian() {
  local f real sz
  f="$1"
  [ -x "$f" ] || return 1
  real="$(readlink -f "$f" 2>/dev/null || echo "$f")"
  # Skip known CLI name
  case "$(basename "$real")" in
    obsidian-cli) return 1 ;;
  esac
  sz="$(stat -c%s "$real" 2>/dev/null || echo 0)"
  # GUI app is ~100MB+; CLI is ~14KB
  [ "$sz" -ge 1000000 ]
}

launch() {
  local bin="$1"
  # Detach fully so the panel/desktop entry does not wait on Electron
  nohup "$bin" "$URI" >/dev/null 2>&1 &
  disown 2>/dev/null || true
  exit 0
}

# Prefer known GUI install locations (Debian/AppImage package layout)
for bin in \
  /opt/Obsidian/obsidian \
  /usr/bin/obsidian \
  "$HOME/.local/bin/Obsidian.AppImage" \
  "$HOME/Applications/Obsidian.AppImage"
do
  if is_gui_obsidian "$bin"; then
    launch "$bin"
  fi
done

# PATH lookup — only if it resolves to the real GUI binary
if command -v obsidian >/dev/null 2>&1; then
  bin="$(command -v obsidian)"
  if is_gui_obsidian "$bin"; then
    launch "$bin"
  fi
fi

# Flatpak
if command -v flatpak >/dev/null 2>&1 && flatpak info md.obsidian.Obsidian >/dev/null 2>&1; then
  nohup flatpak run md.obsidian.Obsidian "$URI" >/dev/null 2>&1 &
  disown 2>/dev/null || true
  exit 0
fi

# Last resort: CLI if Obsidian is already running
if command -v obsidian >/dev/null 2>&1; then
  if obsidian "$URI" 2>/dev/null; then
    exit 0
  fi
fi
if [ -x /opt/Obsidian/obsidian-cli ]; then
  if /opt/Obsidian/obsidian-cli "$URI" 2>/dev/null; then
    exit 0
  fi
fi

echo "Obsidian GUI not found (or CLI-only on PATH). Open manually: $VAULT" >&2
echo "Expected binary: /opt/Obsidian/obsidian or /usr/bin/obsidian" >&2
exit 1
