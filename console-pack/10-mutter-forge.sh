#!/usr/bin/env bash
# Design change: Plasma/KWin → Mutter (via GNOME Shell) + Forge tiling
# Keeps: Termius-only terminal policy, Firefox if present, graphical boot
# Leaves Plasma packages installed (disk) but stops using SDDM/Plasma session
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/lib/common.sh"
need_root

log "Switching GUI stack to Mutter (GNOME Shell) + Forge tiling"

export DEBIAN_FRONTEND=noninteractive
apt-get update -y

# Core GNOME session (Mutter is the compositor/WM under gnome-shell)
apt-get install -y --no-install-recommends \
  gnome-shell \
  mutter \
  gnome-session \
  gnome-session-bin \
  gdm3 \
  gnome-control-center \
  gnome-settings-daemon \
  gnome-shell-extension-prefs \
  gnome-shell-extension-manager \
  gnome-tweaks \
  dconf-cli \
  git \
  make \
  gettext \
  libglib2.0-bin \
  xdg-desktop-portal-gnome \
  xdg-desktop-portal \
  fonts-noto-core \
  network-manager-gnome

# Do NOT pull ubuntu-desktop metapackage (huge). Minimal shell is enough.

# Display manager: GDM not SDDM
systemctl disable sddm.service 2>/dev/null || true
systemctl stop sddm.service 2>/dev/null || true
systemctl enable gdm.service
systemctl set-default graphical.target
echo /usr/sbin/gdm3 > /etc/X11/default-display-manager 2>/dev/null \
  || echo /usr/bin/gdm3 > /etc/X11/default-display-manager

# Prefer Wayland for GNOME (default on modern GDM)
mkdir -p /etc/gdm3
if [[ -f /etc/gdm3/custom.conf ]]; then
  # ensure Wayland not disabled
  sed -i 's/^WaylandEnable=false/#WaylandEnable=false/' /etc/gdm3/custom.conf || true
fi

# Install Forge extension system-wide for all users
FORGE_UUID="forge@jmmaranan.com"
FORGE_TMP=$(mktemp -d)
log "Installing Forge from upstream ($FORGE_UUID)"
git clone --depth 1 https://github.com/forge-ext/forge.git "$FORGE_TMP/forge"
(
  cd "$FORGE_TMP/forge"
  # make install typically → /usr/share/gnome-shell/extensions or ~/.local
  if make install PREFIX=/usr 2>/dev/null; then
    log "Forge make install PREFIX=/usr OK"
  elif make install 2>/dev/null; then
    log "Forge make install OK"
  else
    # Manual install to system extensions dir
    EXT_DIR="/usr/share/gnome-shell/extensions/${FORGE_UUID}"
    mkdir -p "$EXT_DIR"
    # Prefer built dist if present
    if [[ -d dist ]]; then
      cp -a dist/. "$EXT_DIR/"
    else
      cp -a . "$EXT_DIR/" 2>/dev/null || true
      rm -rf "$EXT_DIR/.git" || true
    fi
    # Compile schemas if present
    if [[ -d "$EXT_DIR/schemas" ]]; then
      glib-compile-schemas "$EXT_DIR/schemas" 2>/dev/null || true
    fi
    log "Forge copied to $EXT_DIR"
  fi
)
rm -rf "$FORGE_TMP"

# Enable Forge for the console user (dconf / gnome-extensions)
as_user_enable_forge() {
  local user=$1 home
  home=$(getent passwd "$user" | cut -d: -f6)
  [[ -d "$home" ]] || return 0

  # Enable extension (works after first login; safe to set now)
  sudo -u "$user" DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-}" \
    gnome-extensions enable "$FORGE_UUID" 2>/dev/null || true

  # Persist via dconf user profile using gsettings when session exists;
  # also write a one-shot autostart helper
  mkdir -p "$home/.config/autostart"
  cat > "$home/.config/autostart/aide-enable-forge.desktop" << EOF
[Desktop Entry]
Type=Application
Name=AIDE enable Forge
Exec=sh -c 'gnome-extensions enable ${FORGE_UUID} 2>/dev/null; true'
X-GNOME-Autostart-enabled=true
NoDisplay=true
EOF
  chown -R "$user:$user" "$home/.config/autostart"

  # Prepend Forge to enabled-extensions list if we can use dconf as user later
  cat > "$home/.config/aide-os-enable-forge.sh" << EOF
#!/bin/bash
# Run once after first GNOME login if Forge is not active
gnome-extensions enable ${FORGE_UUID} || true
gsettings set org.gnome.shell disable-user-extensions false || true
EOF
  chown "$user:$user" "$home/.config/aide-os-enable-forge.sh"
  chmod +x "$home/.config/aide-os-enable-forge.sh"
}

as_user_enable_forge "$AIDE_USER"

# Terminal policy reminder: Termius only (do not install gnome-terminal)
for p in gnome-terminal konsole; do
  if dpkg -l "$p" 2>/dev/null | grep -q '^ii'; then
    log "Removing $p (Termius-only policy)"
    apt-get remove -y "$p" || true
  fi
done

# Document stack
mkdir -p /usr/share/aide-os
cat > /usr/share/aide-os/GUI-STACK.md << 'EOF'
# AIDE_OS fam-media GUI stack (current)

| Layer | Component |
|-------|-----------|
| Display manager | **GDM** |
| Session | **GNOME** (Wayland preferred) |
| Compositor / WM | **Mutter** (via GNOME Shell) |
| Tiling | **Forge** (`forge@jmmaranan.com`) |
| Terminal | **Termius only** (Local Terminal) |
| Browser | Firefox (if installed) |

## Former stack
Plasma 6 + KWin + SDDM — packages may still be installed; session no longer default.

## Enable Forge after login
Extension Manager → Forge ON  
or: `gnome-extensions enable forge@jmmaranan.com`

## Optional: remove Plasma later
```bash
sudo apt purge plasma-desktop sddm kwin-wayland
sudo apt autoremove
```
EOF

log "Restarting display manager → GDM"
systemctl restart gdm.service || systemctl start gdm.service || true

log "Done. Reboot recommended: sudo reboot"
log "At GDM: choose GNOME (Wayland) → log in as $AIDE_USER"
log "Then: Extension Manager → enable Forge (or wait for autostart helper)"
log "Note: Forge needs a maintainer upstream; works GNOME 45–50.1"
