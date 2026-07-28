#!/usr/bin/env bash
# Fix black screen after lean base GUI install on fam-media (Haswell + SDDM)
# Root causes seen:
#  - no plasma-session-wayland / plasma-session-x11 (no login sessions)
#  - DisplayServer=wayland greeter failed; X11 fallback missing xserver-xorg
#  - sddm theme breeze package missing
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/lib/common.sh"
need_root

log "Fix black screen: sessions + Xorg + SDDM theme + greeter config"

export DEBIAN_FRONTEND=noninteractive
apt-get update -y

apt-get install -y --no-install-recommends \
  plasma-session-wayland \
  plasma-session-x11 \
  sddm-theme-breeze \
  xserver-xorg \
  xserver-xorg-core \
  xserver-xorg-video-intel \
  xserver-xorg-video-modesetting \
  xserver-xorg-input-all \
  libgl1-mesa-dri \
  mesa-vulkan-drivers \
  layer-shell-qt \
  qt6-wayland

# Greeter: use classic X11 (reliable on Haswell iGPU). Plasma can still start as Wayland after login.
mkdir -p /etc/sddm.conf.d
cat > /etc/sddm.conf.d/aide-os.conf << 'EOF'
[General]
# Wayland greeter failed on this hardware; X11 greeter + Plasma Wayland session after login
DisplayServer=x11

[Theme]
Current=breeze

[X11]
ServerPath=/usr/bin/X
ServerArguments=-nolisten tcp

[Wayland]
# used when a Wayland session is selected at login
SessionCommand=/usr/bin/startplasma-wayland
EOF

# Ensure default display manager
echo /usr/bin/sddm > /etc/X11/default-display-manager

systemctl set-default graphical.target
systemctl enable sddm.service

# Restart display stack
systemctl restart sddm.service || true
sleep 2

log "Sessions now:"
ls -la /usr/share/wayland-sessions/ 2>/dev/null || true
ls -la /usr/share/xsessions/ 2>/dev/null || true

log "sddm status:"
systemctl is-active sddm || true
journalctl -b -u sddm --no-pager -n 15 || true

log "Done. You should see SDDM login (Breeze)."
log "At login pick: Plasma (Wayland) if listed, else Plasma (X11)."
log "If still black: Ctrl+Alt+F3 → login → journalctl -b -u sddm -e"
