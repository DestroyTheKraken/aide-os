#!/usr/bin/env bash
# =============================================================================
# LFCS Backend Deploy — one-shot build for tablet learning environment
#
# Provisions on um690 (control plane):
#   • Docker + Compose stack (LFCS Portal + Mullvad Browser)
#   • Tailnet-only firewall (ufw or firewalld)
#   • systemd boot persistence
#   • Daily guidance + portal integration
#
# USAGE:
#   sudo ./automation/lfcs-backend-deploy.sh
#   sudo ./automation/lfcs-backend-deploy.sh --non-interactive
#
# TABLET: open http://<tailscale-ip>:3080 (dashboard) or https://:3001 (browser)
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LFCS_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
DEPLOY_DIR="/opt/lfcs/secure-browser-forge"
ENV_FILE="${DEPLOY_DIR}/.env"
COMPOSE_SRC="${LFCS_ROOT}/docker/docker-compose.yml"
SYSTEMD_UNIT="/etc/systemd/system/lfcs-backend.service"
CREDS_FILE="${LFCS_ROOT}/notifications/tablet-credentials.txt"
NONINTERACTIVE=false

[[ "${1:-}" == "--non-interactive" ]] && NONINTERACTIVE=true

FORGE_BIND_IP="${FORGE_BIND_IP:-$(tailscale ip -4 2>/dev/null || true)}"
FORGE_WEB_USER="${FORGE_WEB_USER:-lfcs}"
TAILSCALE_INTERFACE="${TAILSCALE_INTERFACE:-tailscale0}"
TAILSCALE_CIDR="${TAILSCALE_CIDR:-100.64.0.0/10}"
FORGE_PORT=3001
PORTAL_PORT=3080
OPENWEBUI_PORT=3082
OLLAMA_PORT=11434
TZ_VALUE="${TZ:-America/Chicago}"

log()  { printf '\033[1;34m[%s]\033[0m %s\n' "$(date '+%H:%M:%S')" "$*"; }
ok()   { printf '\033[1;32m  ✓ %s\033[0m\n' "$*"; }
die()  { printf '\033[1;31m  ✗ %s\033[0m\n' "$*" >&2; exit 1; }

require_root() { [[ "${EUID}" -eq 0 ]] || die "Run with sudo."; }

detect_os() {
    if [[ -f /etc/os-release ]]; then
        # shellcheck source=/dev/null
        source /etc/os-release
        echo "${ID}"
    else
        echo "unknown"
    fi
}

install_docker() {
    local os="$1"
    log "Installing Docker..."
    if command -v docker &>/dev/null && docker info &>/dev/null 2>&1; then
        ok "Docker already running: $(docker --version)"
        return
    fi

    case "${os}" in
        ubuntu|debian)
            apt-get update -qq
            apt-get install -y -qq ca-certificates curl gnupg
            if ! command -v docker &>/dev/null; then
                apt-get install -y -qq docker.io docker-compose-v2 2>/dev/null \
                    || apt-get install -y -qq docker.io docker-compose-plugin
            fi
            ;;
        rocky|rhel|centos|almalinux)
            dnf install -y dnf-plugins-core
            dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo 2>/dev/null || true
            dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin 2>/dev/null \
                || dnf install -y moby-engine docker-compose-plugin
            ;;
        *)
            die "Unsupported OS: ${os}. Install Docker manually."
            ;;
    esac

    systemctl enable --now docker
    ok "Docker enabled"
}

configure_firewall() {
    local os="$1"
    log "Configuring tailnet-only firewall..."

    if command -v ufw &>/dev/null && [[ "${os}" == "ubuntu" || "${os}" == "debian" ]]; then
        ufw --force enable 2>/dev/null || true
        # Remove old rules if re-running
        ufw delete allow in on "${TAILSCALE_INTERFACE}" to any port "${FORGE_PORT}" 2>/dev/null || true
        ufw delete allow in on "${TAILSCALE_INTERFACE}" to any port "${PORTAL_PORT}" 2>/dev/null || true
        ufw delete allow in on "${TAILSCALE_INTERFACE}" to any port "${OPENWEBUI_PORT}" 2>/dev/null || true
        ufw delete allow in on "${TAILSCALE_INTERFACE}" to any port "${OLLAMA_PORT}" 2>/dev/null || true
        ufw allow in on "${TAILSCALE_INTERFACE}" from "${TAILSCALE_CIDR}" to any port "${FORGE_PORT}" proto tcp comment 'LFCS Mullvad Browser'
        ufw allow in on "${TAILSCALE_INTERFACE}" from "${TAILSCALE_CIDR}" to any port "${PORTAL_PORT}" proto tcp comment 'LFCS Portal'
        ufw allow in on "${TAILSCALE_INTERFACE}" from "${TAILSCALE_CIDR}" to any port "${OPENWEBUI_PORT}" proto tcp comment 'LFCS Open WebUI'
        ufw allow in on "${TAILSCALE_INTERFACE}" from "${TAILSCALE_CIDR}" to any port "${OLLAMA_PORT}" proto tcp comment 'LFCS Ollama'
        ok "ufw rules: ${FORGE_PORT}, ${PORTAL_PORT}, ${OPENWEBUI_PORT}, ${OLLAMA_PORT} on ${TAILSCALE_INTERFACE} from ${TAILSCALE_CIDR}"
    elif command -v firewall-cmd &>/dev/null; then
        systemctl enable --now firewalld
        local rule_browser="rule family=ipv4 source address=${TAILSCALE_CIDR} interface name=${TAILSCALE_INTERFACE} port port=${FORGE_PORT} protocol=tcp accept"
        local rule_portal="rule family=ipv4 source address=${TAILSCALE_CIDR} interface name=${TAILSCALE_INTERFACE} port port=${PORTAL_PORT} protocol=tcp accept"
        firewall-cmd --permanent --remove-rich-rule="${rule_browser}" 2>/dev/null || true
        firewall-cmd --permanent --remove-rich-rule="${rule_portal}" 2>/dev/null || true
        firewall-cmd --permanent --add-rich-rule="${rule_browser}"
        firewall-cmd --permanent --add-rich-rule="${rule_portal}"
        firewall-cmd --reload
        ok "firewalld rich rules applied"
    else
        log "No ufw/firewalld — relying on Docker bind to Tailscale IP only"
    fi
}

generate_password() {
    openssl rand -base64 18 | tr -d '/+=' | head -c 16
}

main() {
    require_root
    [[ -n "${FORGE_BIND_IP}" ]] || die "Tailscale not connected. Run: tailscale up"

    local os
    os="$(detect_os)"
    log "LFCS Backend Deploy on $(hostname) (${os})"
    log "Tailscale bind: ${FORGE_BIND_IP}"

    # Generate or reuse credentials
    local password
    if [[ -f "${ENV_FILE}" ]] && grep -q FORGE_WEB_PASSWORD "${ENV_FILE}" 2>/dev/null; then
        password="$(grep FORGE_WEB_PASSWORD "${ENV_FILE}" | cut -d= -f2-)"
        ok "Reusing existing browser credentials"
    else
        password="$(generate_password)"
    fi

    if [[ "${NONINTERACTIVE}" != "true" ]]; then
        echo ""
        echo "  Browser URL:  https://${FORGE_BIND_IP}:${FORGE_PORT}/"
        echo "  Portal URL:   http://${FORGE_BIND_IP}:${PORTAL_PORT}/"
        echo "  Username:     ${FORGE_WEB_USER}"
        echo "  Password:     ${password}"
        echo ""
        read -r -p "  Deploy LFCS backend? [Y/n] " confirm
        [[ "${confirm}" =~ ^[Nn]$ ]] && { log "Aborted."; exit 0; }
    fi

    install_docker "${os}"

    # Add deploying user to docker group
    local deploy_user="${SUDO_USER:-kraken}"
    usermod -aG docker "${deploy_user}" 2>/dev/null || true

    # Build portal before compose up
    sudo -u "${deploy_user}" "${SCRIPT_DIR}/lfcs-portal-build.sh" 2>/dev/null \
        || "${SCRIPT_DIR}/lfcs-portal-build.sh"

    # Ensure daily guidance is fresh
    sudo -u "${deploy_user}" "${SCRIPT_DIR}/lfcs-daily-guidance.sh" >/dev/null 2>&1 \
        || "${SCRIPT_DIR}/lfcs-daily-guidance.sh" >/dev/null 2>&1 || true
    "${SCRIPT_DIR}/lfcs-portal-build.sh"

    mkdir -p "${DEPLOY_DIR}"
    install -m 644 "${COMPOSE_SRC}" "${DEPLOY_DIR}/docker-compose.yml"

    cat > "${ENV_FILE}" <<EOF
# LFCS Backend — generated $(date -Iseconds)
FORGE_BIND_IP=${FORGE_BIND_IP}
LFCS_ROOT=${LFCS_ROOT}
FORGE_PUID=$(id -u "${deploy_user}")
FORGE_PGID=$(id -g "${deploy_user}")
FORGE_WEB_USER=${FORGE_WEB_USER}
FORGE_WEB_PASSWORD=${password}
TZ=${TZ_VALUE}
RAG_TOP_K=5
ENABLE_RAG_WEB_SEARCH=false
# Create in Open WebUI Admin if sync requires auth (see guides/ARA_SYNC_API.md):
OPENWEBUI_API_KEY=
EOF
    chmod 600 "${ENV_FILE}"

    # Save tablet credentials
    cat > "${CREDS_FILE}" <<EOF
# LFCS Tablet Access — $(date -Iseconds)
# Add these as bookmarks on j-tab (Termius/Browser)

Portal (daily dashboard):
  http://${FORGE_BIND_IP}:${PORTAL_PORT}/

Mullvad Browser (secure Firefox lab):
  https://${FORGE_BIND_IP}:${FORGE_PORT}/
  Username: ${FORGE_WEB_USER}
  Password: ${password}
  (Accept self-signed certificate warning)

SSH nodes:
  node1: ssh kraken@100.75.124.36
  node2: ssh kraken@100.104.54.20
  node3: ssh kraken@100.82.177.52
EOF
    chmod 600 "${CREDS_FILE}"
    chown "${deploy_user}:${deploy_user}" "${CREDS_FILE}" 2>/dev/null || true

    # Dynamic bookmarks for Mullvad Browser seed
    cat > "${LFCS_ROOT}/portal/bookmarks.html" <<EOF
<!DOCTYPE NETSCAPE-Bookmark-file-1>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>LFCS Bookmarks</title>
<h1>Bookmarks</h1>
<dl><dt><h3>LFCS Learning</h3></dt><dl>
<dt><a href="http://${FORGE_BIND_IP}:${PORTAL_PORT}/">LFCS Portal</a></dt>
<dt><a href="http://${FORGE_BIND_IP}:${PORTAL_PORT}/daily.txt">Today's Guidance</a></dt>
<dt><a href="https://linuxfoundation.org/certifications/linux-foundation-certified-sysadmin-lfcs">LFCS Certification</a></dt>
</dl></dl>
EOF

    log "Pulling images (may take several minutes)..."
    (
        cd "${DEPLOY_DIR}"
        docker compose --env-file "${ENV_FILE}" pull
        docker compose --env-file "${ENV_FILE}" up -d
    )

    # Wait for services
    local i
    for i in $(seq 1 90); do
        if docker ps --filter name=lfcs-portal --format '{{.Status}}' | grep -qi healthy; then
            ok "lfcs-portal healthy"
            break
        fi
        sleep 2
    done

    for i in $(seq 1 120); do
        if docker ps --filter name=secure-browser-forge --format '{{.Status}}' | grep -qiE 'up|healthy'; then
            ok "secure-browser-forge running"
            break
        fi
        sleep 3
        [[ "${i}" -eq 120 ]] && warn "Browser container still starting — first boot can take 3-5 min"
    done

    configure_firewall "${os}"

    # systemd persistence
    cat > "${SYSTEMD_UNIT}" <<EOF
[Unit]
Description=LFCS Learning Backend (Portal + Mullvad Browser)
Documentation=file://${LFCS_ROOT}/guides/TABLET_QUICKSTART.md
After=docker.service network-online.target tailscaled.service
Wants=network-online.target
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=${DEPLOY_DIR}
EnvironmentFile=${ENV_FILE}
ExecStart=/usr/bin/docker compose --env-file ${ENV_FILE} up -d --remove-orphans
ExecStop=/usr/bin/docker compose --env-file ${ENV_FILE} down
TimeoutStartSec=600

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable lfcs-backend.service
    ok "lfcs-backend.service enabled at boot"

    # Refresh portal with live cluster data
    "${SCRIPT_DIR}/lfcs-cluster-scan.sh" >/dev/null 2>&1 || true
    "${SCRIPT_DIR}/lfcs-portal-build.sh"

    # Install user cron if not present
    if ! crontab -u "${deploy_user}" -l 2>/dev/null | grep -q lfcs-daily-guidance; then
        sudo -u "${deploy_user}" "${SCRIPT_DIR}/install-daily-cron.sh" 2>/dev/null || true
    fi

    echo ""
    printf '\033[1;32m══════════════════════════════════════════════════════════════\033[0m\n'
    printf '\033[1;32m  LFCS BACKEND READY — open on your tablet (j-tab)\033[0m\n'
    printf '\033[1;32m══════════════════════════════════════════════════════════════\033[0m\n'
    echo ""
    echo "  Dashboard:    http://${FORGE_BIND_IP}:${PORTAL_PORT}/"
    echo "  Workspace:    http://${FORGE_BIND_IP}:${PORTAL_PORT}/ide/  (same password)"
    echo "  Ara (AIOS):   http://${FORGE_BIND_IP}:${PORTAL_PORT}/  → Ara button"
    echo "  Ara chat UI:  http://${FORGE_BIND_IP}:${OPENWEBUI_PORT}/  (um690)"
    echo "  Tutor model:  ollama model Ara @ http://${FORGE_BIND_IP}:${OLLAMA_PORT}"
    echo "  Coder model:  ollama model qwen2.5-coder:7b"
    echo "  Lab browser:  https://${FORGE_BIND_IP}:${FORGE_PORT}/"
    echo "  Login:        ${FORGE_WEB_USER} / ${password}"
    echo ""
    echo "  Credentials saved: ${CREDS_FILE}"
    echo "  Quick start:       ${LFCS_ROOT}/guides/TABLET_QUICKSTART.md"
    echo ""
    echo "  Inside Mullvad Browser, bookmark the Portal URL and begin Day 1."
    echo ""
}

warn() { printf '\033[1;33m  ! %s\033[0m\n' "$*" >&2; }

main "$@"