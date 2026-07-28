#!/usr/bin/env bash
# D3 — Protected system web-app launchers
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/lib/common.sh"
need_root

log "D3: System apps → $APP_DIR"

mkdir -p "$APP_DIR" "$DEBUG_APP_DIR"
install -m 644 "$PACK_ROOT/desktop/aide-nextcloud.desktop" "$APP_DIR/"
install -m 644 "$PACK_ROOT/desktop/aide-x.desktop" "$APP_DIR/"
install -m 644 "$PACK_ROOT/desktop/aide-tubi.desktop" "$APP_DIR/"
install -m 644 "$PACK_ROOT/desktop/debug/aide-nextcloud-windowed.desktop" "$DEBUG_APP_DIR/"

# Desktop menu merge so Kickoff sees them
mkdir -p /usr/share/applications
for f in aide-nextcloud.desktop aide-x.desktop aide-tubi.desktop; do
  ln -sfn "$APP_DIR/$f" "/usr/share/applications/$f"
done
ln -sfn "$DEBUG_APP_DIR/aide-nextcloud-windowed.desktop" \
  /usr/share/applications/aide-nextcloud-windowed.desktop

# Update desktop DB if available
if command -v update-desktop-database >/dev/null; then
  update-desktop-database /usr/share/applications 2>/dev/null || true
fi

chown -R root:root /usr/share/aide-os
chmod 755 /usr/share/aide-os "$APP_DIR" "$DEBUG_APP_DIR"

log "D3 done. Launchers: Nextcloud, X, Tubi (+ windowed debug)."
