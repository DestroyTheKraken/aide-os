#!/usr/bin/env bash
# Fix Mullvad Browser WebSocket reconnect loop (tablet resize / XShm crash).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LFCS_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
DEPLOY_ENV="/opt/lfcs/secure-browser-forge/.env"
LOCAL_ENV="${LFCS_ROOT}/docker/.env"

log() { printf '[%s] %s\n' "$(date '+%H:%M:%S')" "$*"; }

if [[ -r "${DEPLOY_ENV}" ]]; then
    cp "${DEPLOY_ENV}" "${LOCAL_ENV}"
elif [[ -f "${LFCS_ROOT}/notifications/tablet-credentials.txt" ]]; then
    FORGE_BIND_IP="$(tailscale ip -4 2>/dev/null || echo 100.81.13.95)"
    FORGE_WEB_PASSWORD="$(grep '^  Password:' "${LFCS_ROOT}/notifications/tablet-credentials.txt" | awk '{print $2}')"
    cat > "${LOCAL_ENV}" <<EOF
FORGE_BIND_IP=${FORGE_BIND_IP}
LFCS_ROOT=${LFCS_ROOT}
FORGE_PUID=$(id -u)
FORGE_PGID=$(id -g)
FORGE_WEB_USER=lfcs
FORGE_WEB_PASSWORD=${FORGE_WEB_PASSWORD}
TZ=America/Chicago
EOF
    chmod 600 "${LOCAL_ENV}"
else
    echo "ERROR: No .env found. Run lfcs-backend-deploy.sh first." >&2
    exit 1
fi

# shellcheck source=/dev/null
source "${LOCAL_ENV}"

log "Recreating Mullvad Browser with locked 1280x800 resolution..."
sg docker -c "docker compose -p secure-browser-forge \
  -f '${LFCS_ROOT}/docker/docker-compose.yml' \
  --env-file '${LOCAL_ENV}' \
  up -d --no-deps --force-recreate mullvad-browser"

log "Waiting for browser (up to 3 min)..."
for i in $(seq 1 36); do
    if curl -k -sf -u "${FORGE_WEB_USER}:${FORGE_WEB_PASSWORD}" \
        --connect-timeout 5 "https://${FORGE_BIND_IP}:3001/" >/dev/null 2>&1; then
        log "Browser HTTPS responding."
        break
    fi
    sleep 5
done

sg docker -c 'docker ps --filter name=secure-browser-forge --format "{{.Names}}: {{.Status}}"'
echo ""
log "Tablet steps:"
log "  1. Close the Mullvad browser tab completely"
log "  2. Clear site data for 100.81.13.95 (or use private/incognito tab)"
log "  3. Reopen https://${FORGE_BIND_IP}:3001/"
log "  4. In Selkies sidebar → Screen: use 1280x800 if asked"