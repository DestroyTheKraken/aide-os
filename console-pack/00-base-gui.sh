#!/usr/bin/env bash
# Base GUI — Plasma + KWin Wayland + SDDM + Termius (only terminal)
# No Konsole. No Firefox/web apps. Add other pieces later on request.
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/lib/common.sh"
need_root

log "Base GUI: Plasma Wayland/KWin + SDDM + Termius (sole terminal)"

export DEBIAN_FRONTEND=noninteractive
apt-get update -y

# Desktop shell — no konsole/xterm
# Note: PAM package is libpam-kwallet5 even on Plasma 6 (Ubuntu naming)
# Sessions + Xorg required: lean --no-install-recommends omits them otherwise → black screen
apt-get install -y --no-install-recommends \
  plasma-desktop \
  plasma-workspace \
  plasma-session-wayland \
  plasma-session-x11 \
  kwin-wayland \
  sddm \
  sddm-theme-breeze \
  systemsettings \
  dolphin \
  plasma-nm \
  qml6-module-qtquick-controls \
  qml6-module-qtquick-layouts \
  qml6-module-qtquick-templates \
  qml6-module-qtqml-workerscript \
  libpam-kwallet5 \
  libpam-kwallet-common \
  kwallet6 \
  xdg-desktop-portal-kde \
  fonts-noto-core \
  mesa-utils \
  libgl1-mesa-dri \
  mesa-vulkan-drivers \
  layer-shell-qt \
  qt6-wayland \
  xserver-xorg \
  xserver-xorg-core \
  xserver-xorg-video-intel \
  xserver-xorg-video-modesetting \
  xserver-xorg-input-all \
  snapd

# Ensure snapd ready
systemctl enable --now snapd.socket 2>/dev/null || true
systemctl enable --now snapd 2>/dev/null || true
# classic snap seed wait
sleep 2

# Termius — only terminal app we install
if ! snap list termius-app &>/dev/null; then
  log "Installing Termius (snap termius-app)"
  snap install termius-app
else
  log "Termius already installed"
fi

# Remove / purge other terminals if present (user: Termius only)
for p in konsole gnome-terminal xterm kitty alacritty tilix; do
  if dpkg -l "$p" 2>/dev/null | grep -q '^ii'; then
    log "Removing alternate terminal package: $p"
    apt-get remove -y "$p" || true
  fi
done

# Hide any leftover terminal .desktop entries (keep Termius visible)
hide_desktop() {
  local f=$1
  [[ -f "$f" ]] || return 0
  mkdir -p /usr/local/share/aide-os/hidden-desktops
  # Prefer NoDisplay overlay in applications
  local base
  base=$(basename "$f")
  cat > "/usr/local/share/applications/${base}" << EOF
[Desktop Entry]
Type=Application
NoDisplay=true
Hidden=true
Name=Hidden
EOF
  log "Hid desktop entry: $base"
}
for f in /usr/share/applications/org.kde.konsole.desktop \
         /usr/share/applications/konsole.desktop \
         /usr/share/applications/xterm.desktop \
         /usr/share/applications/debian-xterm.desktop \
         /usr/share/applications/gnome-terminal.desktop; do
  hide_desktop "$f" || true
done

# Ensure Termius shows in menus (snap usually provides .desktop)
if [[ -f /var/lib/snapd/desktop/applications/termius-app_termius.desktop ]] \
   || ls /var/lib/snapd/desktop/applications/*termius* &>/dev/null; then
  log "Termius desktop entry present via snap"
else
  # Fallback launcher
  cat > /usr/share/applications/termius.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Termius
Comment=SSH client and local terminal (AIDE_OS sole terminal)
Exec=termius-app
Icon=termius-app
Terminal=false
Categories=System;TerminalEmulator;Network;
StartupNotify=true
EOF
  log "Wrote fallback termius.desktop"
fi

# Reboot into GUI
systemctl enable sddm.service
systemctl set-default graphical.target

mkdir -p /etc/sddm.conf.d
# X11 greeter is reliable on Haswell iGPU; select Plasma (Wayland) at login for session
cat > /etc/sddm.conf.d/aide-os.conf << 'EOF'
[General]
DisplayServer=x11

[Theme]
Current=breeze

[X11]
ServerPath=/usr/bin/X
ServerArguments=-nolisten tcp
EOF
echo /usr/bin/sddm > /etc/X11/default-display-manager

if [[ "${AIDE_AUTOLOGIN:-0}" == "1" ]]; then
  log "Autologin for $AIDE_USER"
  cat >> /etc/sddm.conf.d/aide-os.conf << EOF

[Autologin]
User=$AIDE_USER
Session=plasma
EOF
fi

# Document policy
mkdir -p /usr/share/aide-os
cat > /usr/share/aide-os/TERMINAL-POLICY.md << 'EOF'
# AIDE_OS fam-media terminal policy

- **Only terminal app:** Termius (`termius-app` snap) — use **Local Terminal** for shell on this host.
- Do not install Konsole/xterm/etc. for daily work.
- Dev/SSH to lab from Termius; Grok assistance from **um690**.
- Machine boots to **graphical.target** + SDDM (Plasma Wayland).
- Emergency recovery TTY still exists at boot (Ctrl+Alt+F3) if GUI fails — not a work workflow.
EOF

log "Default target: $(systemctl get-default)"
log "SDDM enabled: $(systemctl is-enabled sddm)"
log ""
log "Base GUI + Termius ready."
log "Reboot to land in GUI:  sudo reboot"
log "At SDDM: Plasma (Wayland) → $AIDE_USER → open Termius → Local Terminal"
