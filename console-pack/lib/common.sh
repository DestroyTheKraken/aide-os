#!/usr/bin/env bash
# Shared constants and helpers for AIDE_OS console-pack
# shellcheck disable=SC2034

set -euo pipefail

PACK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AIDE_USER="${AIDE_USER:-joshua}"
AIDE_HOME="$(getent passwd "$AIDE_USER" | cut -d: -f6)"

# Service URLs (Tailscale MagicDNS)
URL_NEXTCLOUD="${URL_NEXTCLOUD:-https://um690.taile52ad9.ts.net/}"
URL_X="${URL_X:-https://x.com/}"
URL_TUBI="${URL_TUBI:-https://tubitv.com/}"
URL_OPS="${URL_OPS:-https://um690.taile52ad9.ts.net/ops/}"

APP_DIR="/usr/share/aide-os/applications"
DEBUG_APP_DIR="/usr/share/aide-os/applications/debug"
POLICY_DIR="/etc/firefox/policies"

log()  { printf '==> %s\n' "$*"; }
warn() { printf 'WARN: %s\n' "$*" >&2; }
die()  { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

need_root() {
  [[ "$(id -u)" -eq 0 ]] || die "run as root (sudo). Example: sudo bash $0"
}

as_user() {
  local cmd=$1
  if [[ "$(id -un)" == "$AIDE_USER" ]]; then
    bash -c "$cmd"
  else
    sudo -u "$AIDE_USER" bash -c "$cmd"
  fi
}
