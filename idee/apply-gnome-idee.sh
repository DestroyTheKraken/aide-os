#!/usr/bin/env bash
# Apply um690 GNOME IDEE profile for GrokAide (user-level only).
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
BACKUP_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/aide-idee"
mkdir -p "$BACKUP_DIR"
STAMP=$(date +%Y%m%d%H%M%S)
BACKUP="$BACKUP_DIR/dconf-backup-$STAMP.txt"

echo "==> Backing up relevant dconf to $BACKUP"
{
  gsettings list-recursively org.gnome.desktop.wm.preferences 2>/dev/null || true
  gsettings list-recursively org.gnome.mutter 2>/dev/null || true
  gsettings list-recursively org.gnome.shell 2>/dev/null || true
} >"$BACKUP"

echo "==> Workspaces: 4"
gsettings set org.gnome.desktop.wm.preferences num-workspaces 4
gsettings set org.gnome.mutter dynamic-workspaces false 2>/dev/null || true

# Workspace names (GNOME 42+ may use different keys; best-effort)
if gsettings writable org.gnome.desktop.wm.preferences workspace-names 2>/dev/null; then
  gsettings set org.gnome.desktop.wm.preferences workspace-names \
    "['Control', 'Brain', 'Lab', 'Platform']"
fi

echo "==> Ghostty (GrokAide terminal themes)"
if [ -f "$SCRIPT_DIR/ghostty/apply-ghostty.sh" ]; then
  bash "$SCRIPT_DIR/ghostty/apply-ghostty.sh"
else
  echo "    WARN: idee/ghostty/apply-ghostty.sh missing; skip"
fi

echo "==> Favorites (dock)"
# Prefer our launchers when present. Ghostty first when installed (GrokAide).
EXISTING=()
for f in aide-obsidian-brain.desktop \
  com.mitchellh.ghostty.desktop ghostty_ghostty.desktop \
  org.gnome.Terminal.desktop org.gnome.Ptyxis.desktop \
  aide-grok-tui.desktop aide-lab-term.desktop \
  firefox_firefox.desktop firefox.desktop org.gnome.Nautilus.desktop; do
  if [ -f "$HOME/.local/share/applications/$f" ] || [ -f "/usr/share/applications/$f" ] \
    || [ -f "/var/lib/snapd/desktop/applications/$f" ]; then
    EXISTING+=("$f")
  fi
done
if [ ${#EXISTING[@]} -gt 0 ]; then
  # Build gsettings list
  list="["
  first=1
  for e in "${EXISTING[@]}"; do
    if [ $first -eq 1 ]; then first=0; else list+=", "; fi
    list+="'$e'"
  done
  list+="]"
  gsettings set org.gnome.shell favorite-apps "$list"
  echo "    set: $list"
else
  echo "    WARN: no favorite desktop files found; skipped"
fi

echo "==> Installing application launchers"
mkdir -p "$HOME/.local/share/applications"
for desk in aide-obsidian-brain.desktop aide-grok-tui.desktop aide-lab-term.desktop; do
  if [ -f "$SCRIPT_DIR/$desk" ]; then
    install -m 644 "$SCRIPT_DIR/$desk" "$HOME/.local/share/applications/$desk"
    echo "    installed $desk"
  fi
done
update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true

echo "==> Done. Backup: $BACKUP"
echo "    Open Obsidian vault: ~/AIDE_OS/brain"
echo "    Verify: bash $SCRIPT_DIR/verify-idee.sh"
