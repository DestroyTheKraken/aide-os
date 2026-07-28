#!/usr/bin/env bash
# Design change: GNOME/Mutter/Forge → Plasma 6 Wayland + KWin + Krohnkite tiling
# Restores SDDM; keeps Termius-only policy; optional Firefox left as-is
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/lib/common.sh"
need_root

log "Switching GUI stack to Plasma (Wayland) + KWin + Krohnkite"

export DEBIAN_FRONTEND=noninteractive
apt-get update -y

# Full enough Plasma stack (includes black-screen fix packages)
apt-get install -y --no-install-recommends \
  plasma-desktop \
  plasma-workspace \
  plasma-session-wayland \
  plasma-session-x11 \
  kwin-wayland \
  kwin-style-breeze \
  kwin-style-aurorae \
  kwin-addons \
  sddm \
  sddm-theme-breeze \
  systemsettings \
  dolphin \
  plasma-nm \
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
  qt6-svg-plugins \
  xserver-xorg \
  xserver-xorg-core \
  xserver-xorg-video-intel \
  xserver-xorg-video-modesetting \
  xserver-xorg-input-all \
  kpackagetool6 \
  curl \
  ca-certificates

# DM: SDDM on, GDM off
systemctl disable --now gdm.service gdm3.service 2>/dev/null || true
systemctl enable sddm.service
systemctl set-default graphical.target
echo /usr/bin/sddm > /etc/X11/default-display-manager

mkdir -p /etc/sddm.conf.d
# X11 greeter (reliable on Haswell); pick Plasma (Wayland) at login for KWin Wayland session
cat > /etc/sddm.conf.d/aide-os.conf << 'EOF'
[General]
DisplayServer=x11

[Theme]
Current=breeze

[X11]
ServerPath=/usr/bin/X
ServerArguments=-nolisten tcp
EOF

# Install Krohnkite (Plasma 6 fork) for console user
# NOTE: download into the user's home — root mktemp dirs are mode 700 and break sudo -u install
KROHN_URL="${KROHN_URL:-https://github.com/anametologin/krohnkite/releases/download/0.9.9.2/krohnkite.kwinscript}"

install_krohnkite_for_user() {
  local user=$1 home
  home=$(getent passwd "$user" | cut -d: -f6)
  [[ -d "$home" ]] || return 0

  local dl_dir="$home/.cache/aide-os"
  local krohn_file="$dl_dir/krohnkite.kwinscript"
  mkdir -p "$dl_dir"
  chown "$user:$user" "$dl_dir"

  log "Downloading Krohnkite: $KROHN_URL"
  curl -fsSL -o "$krohn_file" "$KROHN_URL"
  chown "$user:$user" "$krohn_file"
  chmod 644 "$krohn_file"
  [[ -s "$krohn_file" ]] || die "Krohnkite download empty or missing: $krohn_file"
  log "Downloaded $(wc -c < "$krohn_file") bytes → $krohn_file"

  log "Installing Krohnkite KWin script for $user"
  # remove old if present (ignore "not installed")
  sudo -u "$user" kpackagetool6 -t KWin/Script -r krohnkite 2>/dev/null || true

  if ! sudo -u "$user" kpackagetool6 -t KWin/Script -i "$krohn_file"; then
    log "Install failed, trying upgrade path..."
    sudo -u "$user" kpackagetool6 -t KWin/Script -u "$krohn_file" \
      || die "kpackagetool6 could not install Krohnkite"
  fi

  # Enable plugin in kwinrc (KWin6)
  if command -v kwriteconfig6 >/dev/null; then
    sudo -u "$user" kwriteconfig6 --file kwinrc --group Plugins --key krohnkiteEnabled true
  else
    local kwinrc="$home/.config/kwinrc"
    mkdir -p "$home/.config"
    touch "$kwinrc"
    if grep -q '^\[Plugins\]' "$kwinrc" 2>/dev/null; then
      if grep -q 'krohnkiteEnabled' "$kwinrc"; then
        sed -i 's/^krohnkiteEnabled=.*/krohnkiteEnabled=true/' "$kwinrc"
      else
        sed -i '/^\[Plugins\]/a krohnkiteEnabled=true' "$kwinrc"
      fi
    else
      printf '\n[Plugins]\nkrohnkiteEnabled=true\n' >> "$kwinrc"
    fi
    chown "$user:$user" "$kwinrc"
  fi
  chown -R "$user:$user" "$home/.local" 2>/dev/null || true
  chown -R "$user:$user" "$home/.config" 2>/dev/null || true

  log "Krohnkite listed for $user:"
  sudo -u "$user" kpackagetool6 -t KWin/Script --list 2>/dev/null | grep -i krohn || true
}

install_krohnkite_for_user "$AIDE_USER"

# Terminal policy: no konsole
if dpkg -l konsole 2>/dev/null | grep -q '^ii'; then
  apt-get remove -y konsole || true
fi

# Document stack
mkdir -p /usr/share/aide-os
cat > /usr/share/aide-os/GUI-STACK.md << 'EOF'
# AIDE_OS fam-media GUI stack (current)

| Layer | Component |
|-------|-----------|
| Display manager | **SDDM** (X11 greeter) |
| Session | **Plasma (Wayland)** — choose at login |
| Compositor / WM | **KWin** |
| Tiling | **Krohnkite** (KWin script, Plasma 6 fork) |
| Terminal | **Termius only** |
| Browser | Firefox (if installed) |

## Enable / configure Krohnkite
System Settings → Window Management → KWin Scripts → **Kröhnkite** ON  
Configure… for layouts/gaps/shortcuts.

Reload without logout (if session running):
```bash
qdbus org.kde.KWin /KWin reconfigure
# or
qdbus6 org.kde.KWin /Scripting org.kde.kwin.Scripting.loadScript ~/.local/share/kwin/scripts/krohnkite
```

## Former stacks
- GNOME/Mutter + Forge (GDM) — disabled, packages may remain
- Early Plasma lean install — kept/fixed

## Optional purge GNOME later
```bash
sudo apt purge gdm3 gnome-shell mutter
sudo apt autoremove
```
EOF

log "Restarting SDDM (GDM stopped)"
systemctl stop gdm.service gdm3.service 2>/dev/null || true
systemctl restart sddm.service || systemctl start sddm.service || true

log "Done. Reboot recommended: sudo reboot"
log "At SDDM: select **Plasma (Wayland)** → log in as $AIDE_USER"
log "Then: Settings → KWin Scripts → enable Kröhnkite if not already on"
