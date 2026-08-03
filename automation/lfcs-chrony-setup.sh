#!/usr/bin/env bash
# Install and verify Chrony NTP on LFCS cluster nodes (PR 19).
set -euo pipefail

log()  { printf '\033[1;34m[%s]\033[0m %s\n' "$(date '+%H:%M:%S')" "$*"; }
ok()   { printf '\033[1;32m  ✓ %s\033[0m\n' "$*"; }

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run with sudo on each node (um690, node1, node2, node3)" >&2
  exit 1
fi

if command -v apt-get >/dev/null 2>&1; then
  apt-get update -qq
  DEBIAN_FRONTEND=noninteractive apt-get install -y -qq chrony
elif command -v dnf >/dev/null 2>&1; then
  dnf install -y chrony
else
  echo "Unsupported package manager" >&2
  exit 1
fi

systemctl enable --now chronyd 2>/dev/null || systemctl enable --now chrony
ok "Chrony enabled"

chronyc tracking 2>/dev/null || chronyc sources -v
timedatectl status

ok "Acceptance: verify skew <100ms across nodes with chronyc tracking on each host"