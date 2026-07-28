#!/usr/bin/env bash
# Add-on: KWin decoration / Aurorae / KDE Store theme support
# Fixes: Store window decorations install but cannot be selected or appear broken
# Cause: lean install had kwin-style-breeze only — no Aurorae engine
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/lib/common.sh"
need_root

log "Installing Aurorae + theme engines for KDE Store decorations"

export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y --no-install-recommends \
  kwin-style-aurorae \
  kwin-addons \
  kwin-decoration-oxygen \
  kde-config-gtk-style \
  kde-config-gtk-style-preview \
  qml6-module-qtquick-shapes \
  qt6-svg-plugins

# Ensure decoration plugins visible
log "Decoration plugins now:"
ls /usr/lib/*/qt6/plugins/org.kde.kdecoration3/ 2>/dev/null \
  || ls /usr/lib/*/qt6/plugins/org.kde.kdecoration2/ 2>/dev/null \
  || true

log "Done."
log "In Plasma: System Settings → Colors & Themes → Window Decorations"
log "  1) Theme dropdown → choose Aurorae (or 'Get New…' themes like Carl/Edna)"
log "  2) Or select the installed Aurorae theme by name"
log "  3) Apply → if no change: log out/in or: qdbus org.kde.KWin /KWin reconfigure"
log ""
log "Tokyo Night (colors / plasma theme) is separate from window decorations:"
log "  Settings → Colors & Themes → Colors → Tokyo Night / Storm"
log "  Settings → Colors & Themes → Plasma Style → Tokyo-Night"
