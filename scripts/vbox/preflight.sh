#!/usr/bin/env bash
# Host preflight before starting aide-lab (design K5/K12).
# Usage: preflight.sh [demo|hybrid-llm]
set -euo pipefail

PROFILE="${1:-demo}"
WORKERS_MB="${WORKERS_MB:-0}"

case "$PROFILE" in
  demo) FLOOR_KB=$((22 * 1024 * 1024)); GUEST_MB=10240 ;;
  hybrid-llm) FLOOR_KB=$((28 * 1024 * 1024)); GUEST_MB=12288 ;;
  *) echo "usage: $0 [demo|hybrid-llm]" >&2; exit 2 ;;
esac

# Add workers to floor
FLOOR_KB=$((FLOOR_KB + WORKERS_MB * 1024))

fail=0
log() { printf 'preflight: %s\n' "$*"; }
bad() { log "FAIL: $*"; fail=1; }

AVAIL_KB=$(awk '/MemAvailable:/{print $2}' /proc/meminfo)
log "MemAvailable=${AVAIL_KB} kB  floor=${FLOOR_KB} kB  profile=$PROFILE guest=${GUEST_MB}MB"
if (( AVAIL_KB < FLOOR_KB )); then
  bad "MemAvailable below $PROFILE floor"
else
  log "mem OK"
fi

if command -v kubectl >/dev/null 2>&1; then
  if ! kubectl get nodes --no-headers 2>/dev/null | awk '$2!="Ready"{bad=1} END{exit bad+0}'; then
    bad "k3s node not Ready — refuse start (fail-hard)"
  else
    log "k3s nodes Ready"
  fi
else
  log "WARN: kubectl missing — skip node check"
fi

# Heavy desktop already running?
if VBoxManage list runningvms 2>/dev/null | grep -qiE 'aide-lab|"AIDE_OS Lab"'; then
  bad "aide-lab already running"
fi

# Core console VM is OK (not heavy desktop) but note it
if VBoxManage list runningvms 2>/dev/null | grep -q 'AIDE_OS'; then
  log "NOTE: AIDE_OS Core VM is running (console track) — not blocking"
fi

if (( fail )); then
  log "preflight FAILED"
  exit 1
fi
log "preflight OK"
exit 0
