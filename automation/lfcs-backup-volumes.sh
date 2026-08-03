#!/usr/bin/env bash
# Weekly backup of Open WebUI + Ollama Docker volumes (PR 17).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LFCS_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
BACKUP_DIR="${LFCS_BACKUP_DIR:-${LFCS_ROOT}/notifications/backups}"
STAMP="$(date +%Y%m%d-%H%M)"
ARCHIVE="${BACKUP_DIR}/lfcs-volumes-${STAMP}.tar.gz"

log()  { printf '\033[1;34m[%s]\033[0m %s\n' "$(date '+%H:%M:%S')" "$*"; }
ok()   { printf '\033[1;32m  ✓ %s\033[0m\n' "$*"; }

mkdir -p "${BACKUP_DIR}"
log "Backing up Docker volumes to ${ARCHIVE}..."

VOLS=(lfcs-openwebui-data lfcs-ollama-data secure-browser-forge-config)
TMPDIR="$(mktemp -d)"
trap 'rm -rf "${TMPDIR}"' EXIT

for vol in "${VOLS[@]}"; do
  if docker volume inspect "${vol}" >/dev/null 2>&1; then
    docker run --rm -v "${vol}:/data:ro" -v "${TMPDIR}:/backup" alpine \
      tar -czf "/backup/${vol}.tar.gz" -C /data . 2>/dev/null || true
    ok "Dumped ${vol}"
  else
    log "Volume ${vol} not found — skip"
  fi
done

tar -czf "${ARCHIVE}" -C "${TMPDIR}" .
ok "Archive: ${ARCHIVE}"
ls -lh "${ARCHIVE}"