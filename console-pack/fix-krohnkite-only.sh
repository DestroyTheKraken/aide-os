#!/usr/bin/env bash
# Re-run only Krohnkite install + ensure SDDM (after partial plasma-krohnkite failure)
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/lib/common.sh"
need_root

export DEBIAN_FRONTEND=noninteractive
apt-get install -y --no-install-recommends kpackagetool6 curl ca-certificates 2>/dev/null || true

# Ensure SDDM is the display manager (in case previous run did this already)
systemctl disable --now gdm.service gdm3.service 2>/dev/null || true
systemctl enable sddm.service 2>/dev/null || true
echo /usr/bin/sddm > /etc/X11/default-display-manager 2>/dev/null || true

# Source the install function by running the fixed section inline
KROHN_URL="${KROHN_URL:-https://github.com/anametologin/krohnkite/releases/download/0.9.9.2/krohnkite.kwinscript}"
user="$AIDE_USER"
home=$(getent passwd "$user" | cut -d: -f6)
dl_dir="$home/.cache/aide-os"
krohn_file="$dl_dir/krohnkite.kwinscript"
mkdir -p "$dl_dir"
chown "$user:$user" "$dl_dir"

log "Downloading Krohnkite → $krohn_file"
curl -fsSL -o "$krohn_file" "$KROHN_URL"
chown "$user:$user" "$krohn_file"
chmod 644 "$krohn_file"
[[ -s "$krohn_file" ]] || die "download failed"

log "Installing for $user"
sudo -u "$user" kpackagetool6 -t KWin/Script -r krohnkite 2>/dev/null || true
sudo -u "$user" kpackagetool6 -t KWin/Script -i "$krohn_file" \
  || sudo -u "$user" kpackagetool6 -t KWin/Script -u "$krohn_file" \
  || die "kpackagetool6 install failed"

if command -v kwriteconfig6 >/dev/null; then
  sudo -u "$user" kwriteconfig6 --file kwinrc --group Plugins --key krohnkiteEnabled true
fi

log "Installed scripts:"
sudo -u "$user" kpackagetool6 -t KWin/Script --list 2>/dev/null | grep -i krohn || \
  sudo -u "$user" kpackagetool6 -t KWin/Script --list 2>/dev/null || true

log "DM status: sddm=$(systemctl is-enabled sddm 2>/dev/null) gdm=$(systemctl is-enabled gdm3 2>/dev/null || true)"
log "Done. Reboot: sudo reboot — then Plasma (Wayland) → KWin Scripts → Kröhnkite ON"
