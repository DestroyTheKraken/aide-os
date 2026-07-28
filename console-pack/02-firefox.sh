#!/usr/bin/env bash
# Add-on: Firefox + Nextcloud homepage policies
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/lib/common.sh"
need_root

log "Installing Firefox + Nextcloud homepage policy"

export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y firefox

# System policies (deb transitional + many snap builds honor /etc/firefox/policies)
mkdir -p "$POLICY_DIR"
cp -f "$PACK_ROOT/policies/firefox/policies.json" "$POLICY_DIR/policies.json"
chmod 644 "$POLICY_DIR/policies.json"

# Snap Firefox also checks this path when confined appropriately
if [[ -d /var/snap/firefox ]]; then
  mkdir -p /etc/firefox/policies
  cp -f "$PACK_ROOT/policies/firefox/policies.json" /etc/firefox/policies/policies.json
fi

log "Firefox: $(command -v firefox || true)"
firefox --version 2>/dev/null || snap list firefox 2>/dev/null || true
log "Policies: $POLICY_DIR/policies.json (homepage → $URL_NEXTCLOUD)"
log "Done. Open Firefox from the app menu in Plasma."
