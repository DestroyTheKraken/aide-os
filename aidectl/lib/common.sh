# shellcheck shell=bash
# Shared helpers for aidectl
set -euo pipefail

AIDE_ROOT="${AIDE_ROOT:-$HOME/AIDE_OS}"
AIDECTL_HOME="${AIDECTL_HOME:-$AIDE_ROOT/aidectl}"
AIDE_STATE="${XDG_STATE_HOME:-$HOME/.local/state}/aide-os"
AIDE_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/aide-os"
SCHEMA_FILE="$AIDECTL_HOME/schema/config-tree.yaml"

mkdir -p "$AIDE_STATE" "$AIDE_CONFIG_DIR"

detect_mode() {
  if [ -f /etc/os-release ] && grep -qi 'ID=ubuntu-core\|VARIANT_ID=core' /etc/os-release 2>/dev/null; then
    echo "core"
  elif command -v snap >/dev/null 2>&1 && [ -d /snap/core ] && ! command -v apt-get >/dev/null 2>&1; then
    echo "core"
  else
    echo "classic-shim"
  fi
}

log() { printf 'aidectl: %s\n' "$*"; }
ok() { printf '  OK  %s\n' "$*"; }
warn() { printf '  WARN %s\n' "$*"; }
fail() { printf '  FAIL %s\n' "$*"; }

next_action() {
  printf '\n==> Next action\n    %s\n' "$*"
}
