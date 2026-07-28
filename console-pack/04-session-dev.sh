#!/usr/bin/env bash
# D4 — Dev session: autostart Nextcloud; user can still use full Settings
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/lib/common.sh"
need_root

[[ -n "$AIDE_HOME" && -d "$AIDE_HOME" ]] || die "home for $AIDE_USER not found"

log "D4: Dev session autostart for $AIDE_USER"

AUTO_DIR="$AIDE_HOME/.config/autostart"
mkdir -p "$AUTO_DIR"
install -m 644 -o "$AIDE_USER" -g "$AIDE_USER" \
  "$PACK_ROOT/plasma/autostart-nextcloud.desktop" \
  "$AUTO_DIR/aide-nextcloud.desktop"

# Ensure config tree owned by user
chown -R "$AIDE_USER:$AIDE_USER" "$AIDE_HOME/.config"

log "D4 done. On login, Firefox kiosk → Nextcloud. Full Settings remain for iteration."
log "Add UI packages anytime: sudo apt install <plasma-widget-or-theme>"
