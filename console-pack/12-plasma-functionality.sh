#!/usr/bin/env bash
# Improve Plasma functionality WITHOUT changing layout/theme.
# Fixes: Get New Stuff / widget store QML breakage, missing stock widgets,
# Discover store, emoji fonts, Firefox portal bits, Krohnkite reinstall if missing.
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/lib/common.sh"
need_root

log "Plasma functionality repair (layout/theme untouched)"

export DEBIAN_FRONTEND=noninteractive
apt-get update -y

# Core stock widgets + Discover (KDE store UI) + missing QML used by NewStuff dialogs
apt-get install -y --no-install-recommends \
  plasma-widgets-addons \
  plasma-dataengines-addons \
  plasma-wallpapers-addons \
  plasma-pa \
  plasma-systemmonitor \
  plasma-browser-integration \
  plasma-discover \
  plasma-discover-backend-flatpak \
  plasma-discover-backend-snap \
  plasma-discover-common \
  qml6-module-org-kde-kirigamiaddons-formcard \
  qml6-module-org-kde-kirigamiaddons-settings \
  qml6-module-org-kde-kirigamiaddons-labs-components \
  qml6-module-org-kde-desktop \
  qml6-module-org-kde-breeze \
  qml6-module-org-kde-newstuff \
  qml6-module-qtquick-controls \
  qml6-module-qtquick-layouts \
  qml6-module-qtquick-templates \
  qml6-module-qtquick-dialogs \
  qml6-module-qtquick-shapes \
  qml6-module-qt5compat-graphicaleffects \
  fonts-noto-color-emoji \
  xdg-utils \
  libmtp-runtime \
  mtp-tools \
  kpackagetool6 \
  curl \
  ca-certificates

# Reinstall desktop data in case of partial/corrupt plasmoid metadata trees
apt-get install -y --reinstall plasma-desktop plasma-desktop-data plasma-workspace plasma-workspace-data

# Prefer KDE portal for this user session (do not remove GNOME portal packages if present)
mkdir -p /etc/xdg-desktop-portal
cat > /etc/xdg-desktop-portal/portals.conf << 'EOF'
[preferred]
default=kde
org.freedesktop.impl.portal.Settings=kde;gtk;
org.freedesktop.impl.portal.Secret=kwallet
EOF

# Krohnkite if still missing for console user
user="$AIDE_USER"
home=$(getent passwd "$user" | cut -d: -f6)
if [[ -n "$home" && -d "$home" ]]; then
  if ! sudo -u "$user" kpackagetool6 -t KWin/Script --list 2>/dev/null | grep -qi krohn; then
    log "Krohnkite not listed — installing"
    KROHN_URL="${KROHN_URL:-https://github.com/anametologin/krohnkite/releases/download/0.9.9.2/krohnkite.kwinscript}"
    dl_dir="$home/.cache/aide-os"
    krohn_file="$dl_dir/krohnkite.kwinscript"
    mkdir -p "$dl_dir"
    chown "$user:$user" "$dl_dir"
    curl -fsSL -o "$krohn_file" "$KROHN_URL"
    chown "$user:$user" "$krohn_file"
    chmod 644 "$krohn_file"
    sudo -u "$user" kpackagetool6 -t KWin/Script -r krohnkite 2>/dev/null || true
    sudo -u "$user" kpackagetool6 -t KWin/Script -i "$krohn_file" \
      || sudo -u "$user" kpackagetool6 -t KWin/Script -u "$krohn_file" || true
    if command -v kwriteconfig6 >/dev/null; then
      sudo -u "$user" kwriteconfig6 --file kwinrc --group Plugins --key krohnkiteEnabled true || true
    fi
  else
    log "Krohnkite already installed for $user"
  fi
fi

log "Done. Log out/in (or reboot) so plasmashell reloads QML modules."
log "Then test: right-click panel → Add Widgets → Get New… / open Discover."
log "Optional (reduces background load if you do not need local k8s on this PC):"
log "  sudo snap stop microk8s"
log "If a 3rd-party widget still misbehaves, remove it from:"
log "  ~/.local/share/plasma/plasmoids/  (AndromedaLauncher, KdeControlStation, wunderground)"
