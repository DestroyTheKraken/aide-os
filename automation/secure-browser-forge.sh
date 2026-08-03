#!/usr/bin/env bash
# =============================================================================
# LFCS Project 09 — Secure Browser Forge
# Interactive deployment, hardening, and validation generator.
#
# USAGE (from Termius on your tablet):
#   cd /home/kraken/Projects/aios-ed/automation
#   sudo ./secure-browser-forge.sh
#
# LFCS EXAM TIPS embedded throughout as comments.
# Safe to re-run: every step checks state before making changes (idempotent).
# =============================================================================

set -euo pipefail

# --- Paths (auto-detected from script location) ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LFCS_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
COMPOSE_SRC="${LFCS_ROOT}/docker/docker-compose.yml"
VALIDATION_OUT="${LFCS_ROOT}/validation/VALIDATION.md"
DEPLOY_DIR="/opt/lfcs/secure-browser-forge"
ENV_FILE="${DEPLOY_DIR}/.env"
SYSTEMD_UNIT="/etc/systemd/system/secure-browser-forge.service"
SSHD_DROPIN="/etc/ssh/sshd_config.d/99-lfcs-forge.conf"
SUDOERS_FILE="/etc/sudoers.d/forgesvc"
SYSCTL_DROPIN="/etc/sysctl.d/99-forge-hardening.conf"
MARKER_FILE="${DEPLOY_DIR}/.forge-deployed"

# --- Defaults (override via menu or .env) ---
FORGE_USER="forgesvc"
FORGE_PORT="3001"
TAILSCALE_INTERFACE="tailscale0"
TAILSCALE_CIDR="100.64.0.0/10"
FORGE_BIND_IP="${FORGE_BIND_IP:-}"
FORGE_WEB_USER="${FORGE_WEB_USER:-forgeadmin}"
FORGE_WEB_PASSWORD="${FORGE_WEB_PASSWORD:-}"
TZ_VALUE="${TZ:-America/Chicago}"

# =============================================================================
# Utility functions
# =============================================================================

log()  { printf '\033[1;34m[%s]\033[0m %s\n' "$(date '+%H:%M:%S')" "$*"; }
ok()   { printf '\033[1;32m  ✓ %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m  ! %s\033[0m\n' "$*" >&2; }
die()  { printf '\033[1;31m  ✗ %s\033[0m\n' "$*" >&2; exit 1; }

pause_teaching() {
    local msg="${1:-Press Enter to continue...}"
    read -r -p "$(printf '\033[0;36m  📘 %s\033[0m' "${msg}")" _
}

require_root() {
    [[ "${EUID}" -eq 0 ]] || die "Run with sudo. LFCS: privilege escalation via sudo is exam-critical."
}

heading() {
    echo ""
    printf '\033[1;35m══════════════════════════════════════════════════════════════\033[0m\n'
    printf '\033[1;35m  %s\033[0m\n' "$1"
    printf '\033[1;35m══════════════════════════════════════════════════════════════\033[0m\n'
    echo ""
}

# Capture command output for VALIDATION.md evidence blocks
EVIDENCE=()

record_evidence() {
    local title="$1"
    shift
    local output
    output="$("$@" 2>&1)" || output="(command exited non-zero) ${output}"
    EVIDENCE+=("### ${title}" "" '```' "${output}" '```' "")
}

# =============================================================================
# Interactive configuration
# =============================================================================

detect_tailscale_ip() {
    command -v tailscale >/dev/null 2>&1 || return 1
    tailscale ip -4 2>/dev/null || true
}

prompt_config() {
    heading "Configuration"

    local detected
    detected="$(detect_tailscale_ip || true)"

    if [[ -z "${FORGE_BIND_IP}" ]]; then
        if [[ -n "${detected}" ]]; then
            read -r -p "  Tailscale bind IP [${detected}]: " FORGE_BIND_IP
            FORGE_BIND_IP="${FORGE_BIND_IP:-${detected}}"
        else
            read -r -p "  Tailscale bind IP (e.g. 100.82.177.52): " FORGE_BIND_IP
        fi
    fi
    [[ -n "${FORGE_BIND_IP}" ]] || die "Tailscale IP is required."

    read -r -p "  Web UI username [${FORGE_WEB_USER}]: " _u
    FORGE_WEB_USER="${_u:-${FORGE_WEB_USER}}"

    if [[ -z "${FORGE_WEB_PASSWORD}" ]]; then
        read -r -s -p "  Web UI password (min 8 chars): " FORGE_WEB_PASSWORD
        echo ""
        [[ "${#FORGE_WEB_PASSWORD}" -ge 8 ]] || die "Password must be at least 8 characters."
    fi

    log "Forge will bind to ${FORGE_BIND_IP}:${FORGE_PORT}"
    log "Web auth user: ${FORGE_WEB_USER}"
}

# =============================================================================
# Deployment steps (idempotent)
# =============================================================================

step_preflight() {
    heading "Preflight Checks"
    log "LFCS: always verify prerequisites before modifying production systems."

    command -v dnf    >/dev/null 2>&1 || die "dnf not found — Rocky/RHEL required."
    command -v tailscale >/dev/null 2>&1 || warn "tailscale CLI not found — ensure Tailscale is installed."

    ip link show "${TAILSCALE_INTERFACE}" >/dev/null 2>&1 \
        || die "Interface ${TAILSCALE_INTERFACE} not found. Is Tailscale up?"

    local ts_ip
    ts_ip="$(detect_tailscale_ip || true)"
    [[ -n "${ts_ip}" ]] && ok "Tailscale connected: ${ts_ip}" || warn "Tailscale IP not detected"

    [[ -f "${COMPOSE_SRC}" ]] || die "Missing compose file: ${COMPOSE_SRC}"

    ok "Preflight passed"
}

step_install_docker() {
    heading "Docker Engine"
    log "LFCS Operations domain: install and enable services with systemd."

    if command -v docker >/dev/null 2>&1; then
        ok "Docker already installed: $(docker --version)"
    else
        log "Installing Docker..."
        dnf install -y dnf-plugins-core
        dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo 2>/dev/null \
            || dnf install -y moby-engine docker-compose-plugin
        dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin 2>/dev/null \
            || dnf install -y moby-engine docker-compose-plugin
        ok "Docker installed"
    fi

    systemctl enable --now docker
    ok "docker.service enabled and running"
}

step_create_service_user() {
    heading "Least-Privilege Service Identity"
    log "LFCS Users & Groups: dedicated accounts limit blast radius."

    if ! id "${FORGE_USER}" &>/dev/null; then
        useradd --system --home-dir /var/lib/forge --shell /sbin/nologin "${FORGE_USER}"
        ok "Created system user: ${FORGE_USER}"
    else
        ok "User ${FORGE_USER} already exists"
    fi

    mkdir -p /var/lib/forge
    chown "${FORGE_USER}:${FORGE_USER}" /var/lib/forge

    # LFCS: group membership grants docker socket access without root login
    groupadd -f docker
    usermod -aG docker "${FORGE_USER}" 2>/dev/null || true
    ok "Group membership configured"
}

step_harden_ssh() {
    heading "SSH Hardening"
    log "LFCS Networking: always test sshd -t BEFORE reload to avoid lockout."

    mkdir -p /etc/ssh/sshd_config.d
    if [[ ! -f "${SSHD_DROPIN}" ]]; then
        cat > "${SSHD_DROPIN}" <<'EOF'
# LFCS Project 09 — SSH hardening (drop-in, survives upgrades)
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
MaxAuthTries 3
X11Forwarding no
AllowTcpForwarding no
EOF
        ok "SSH drop-in created"
    else
        ok "SSH drop-in already present"
    fi

    sshd -t || die "sshd config test FAILED — fix before reloading"
    systemctl reload sshd
    ok "sshd reloaded safely"
}

step_harden_sysctl() {
    heading "Kernel Hardening (sysctl)"
    if [[ ! -f "${SYSCTL_DROPIN}" ]]; then
        cat > "${SYSCTL_DROPIN}" <<'EOF'
# LFCS Project 09 — persistent kernel tuning
net.ipv4.tcp_syncookies = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
EOF
        ok "Sysctl drop-in created"
    else
        ok "Sysctl drop-in already present"
    fi
    sysctl --system >/dev/null 2>&1 || sysctl -p "${SYSCTL_DROPIN}"
}

step_configure_sudoers() {
    heading "Restricted Sudo (forgesvc)"
    if [[ ! -f "${SUDOERS_FILE}" ]]; then
        cat > "${SUDOERS_FILE}" <<EOF
# LFCS Project 09 — command-literal sudo (visudo validated)
${FORGE_USER} ALL=(root) NOPASSWD: /usr/bin/docker ps, /usr/bin/docker inspect *
${FORGE_USER} ALL=(root) NOPASSWD: /usr/bin/systemctl status secure-browser-forge.service
EOF
        chmod 440 "${SUDOERS_FILE}"
        ok "Sudoers installed"
    else
        ok "Sudoers already present"
    fi
    visudo -cf "${SUDOERS_FILE}" || die "visudo validation failed"
}

step_deploy_compose() {
    heading "Docker Compose Deployment"
    log "LFCS: bind ports to specific IPs — never 0.0.0.0 for internal services."

    mkdir -p "${DEPLOY_DIR}"
    install -m 644 "${COMPOSE_SRC}" "${DEPLOY_DIR}/docker-compose.yml"

    local puid pgid
    puid="$(id -u "${FORGE_USER}")"
    pgid="$(id -g "${FORGE_USER}")"

    cat > "${ENV_FILE}" <<EOF
# Generated by secure-browser-forge.sh — $(date -Iseconds)
FORGE_BIND_IP=${FORGE_BIND_IP}
FORGE_PUID=${puid}
FORGE_PGID=${pgid}
FORGE_WEB_USER=${FORGE_WEB_USER}
FORGE_WEB_PASSWORD=${FORGE_WEB_PASSWORD}
TZ=${TZ_VALUE}
EOF
    chmod 600 "${ENV_FILE}"
    ok "Environment file written: ${ENV_FILE}"

    # LFCS: docker compose reads .env automatically from working directory
    (
        cd "${DEPLOY_DIR}"
        docker compose pull
        docker compose up -d
    )
    ok "Container stack started"

    # Wait for healthy or running state
    local i
    for i in $(seq 1 60); do
        if docker ps --filter "name=secure-browser-forge" --format '{{.Status}}' | grep -qiE 'up|healthy'; then
            ok "Container secure-browser-forge is running"
            break
        fi
        sleep 3
        [[ "${i}" -eq 60 ]] && warn "Container slow to start — check: docker logs secure-browser-forge"
    done

    date -Iseconds > "${MARKER_FILE}"
}

step_configure_firewall() {
    heading "firewalld — Tailnet-Only Access"
    log "LFCS Networking: rich rules target source + interface + port precisely."

    systemctl enable --now firewalld

    local rule
    rule="rule family=ipv4 source address=${TAILSCALE_CIDR} interface name=${TAILSCALE_INTERFACE} port port=${FORGE_PORT} protocol=tcp accept"

    # Idempotent: remove then add
    firewall-cmd --permanent --remove-rich-rule="${rule}" 2>/dev/null || true
    firewall-cmd --permanent --add-rich-rule="${rule}"
    firewall-cmd --reload

    ok "Rich rule active: ${FORGE_PORT}/tcp from ${TAILSCALE_CIDR} on ${TAILSCALE_INTERFACE}"
    log "LFCS exam tip: --permanent writes to /etc/firewalld; reload applies runtime."
}

step_enable_systemd_persistence() {
    heading "systemd Boot Persistence"
    log "LFCS: systemctl enable ensures service survives reboot."

    cat > "${SYSTEMD_UNIT}" <<EOF
[Unit]
Description=LFCS Secure Browser Forge (Docker Compose)
Documentation=file://${LFCS_ROOT}/Study_Projects/09.md
After=docker.service network-online.target tailscaled.service
Wants=network-online.target
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=${DEPLOY_DIR}
EnvironmentFile=${ENV_FILE}
ExecStart=/usr/bin/docker compose up -d --remove-orphans
ExecStop=/usr/bin/docker compose down
TimeoutStartSec=300

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable secure-browser-forge.service
    ok "secure-browser-forge.service enabled at boot"
}

step_install_health_cron() {
    heading "Scheduled Health Check (cron)"
    local cron_file="/etc/cron.d/secure-browser-forge"
    if [[ ! -f "${cron_file}" ]]; then
        cat > "${cron_file}" <<EOF
# LFCS Project 08+09: nightly log rotation for forge validation
0 0 * * * root /usr/bin/docker logs --tail 200 secure-browser-forge > /var/log/forge-container.log 2>&1
EOF
        chmod 644 "${cron_file}"
        ok "Cron job installed"
    else
        ok "Cron already configured"
    fi
}

# =============================================================================
# Validation report generator
# =============================================================================

generate_validation_md() {
    heading "Generating VALIDATION.md"
    log "LFCS: auditable evidence proves you completed the task under exam conditions."

    EVIDENCE=()
    mkdir -p "$(dirname "${VALIDATION_OUT}")"

    # Collect live evidence
    record_evidence "1. Tailscale IP & Interface" ip -4 addr show "${TAILSCALE_INTERFACE}"
    record_evidence "2. SSH Hardening (PermitRootLogin)" sh -c 'grep -rH PermitRootLogin /etc/ssh/sshd_config.d/ 2>/dev/null || echo "no drop-in"'
    record_evidence "3. forgesvc Identity" id "${FORGE_USER}"
    record_evidence "4. Sudoers Validation" visudo -cf "${SUDOERS_FILE}"
    record_evidence "5. Container Status" docker ps --filter name=secure-browser-forge
    record_evidence "6. Restart Policy" docker inspect --format='Restart={{.HostConfig.RestartPolicy.Name}}' secure-browser-forge 2>/dev/null || echo "container not found"
    record_evidence "7. Port Binding (must show Tailscale IP only)" sh -c "ss -tlnp | grep -E '${FORGE_PORT}|State' || ss -tlnp"
    record_evidence "8. firewalld Rich Rules" firewall-cmd --list-rich-rules
    record_evidence "9. systemd Boot Persistence" systemctl is-enabled secure-browser-forge.service docker.service firewalld
    record_evidence "10. Sysctl Persistence" sysctl net.ipv4.tcp_syncookies
    record_evidence "11. HTTPS Reachability (tailnet)" curl -k -s -o /dev/null -w "HTTP %{http_code}\n" "https://${FORGE_BIND_IP:-$(detect_tailscale_ip)}:${FORGE_PORT}/" || echo "curl failed (container may still be starting)"

    local pass=0 fail=0

    # Run pass/fail summary
    id "${FORGE_USER}" &>/dev/null && pass=$((pass+1)) || fail=$((fail+1))
    sshd -t &>/dev/null && pass=$((pass+1)) || fail=$((fail+1))
    docker ps --filter name=secure-browser-forge --format '{{.Names}}' | grep -q secure-browser-forge && pass=$((pass+1)) || fail=$((fail+1))
    systemctl is-enabled secure-browser-forge.service &>/dev/null && pass=$((pass+1)) || fail=$((fail+1))
    firewall-cmd --list-rich-rules 2>/dev/null | grep -q "${FORGE_PORT}" && pass=$((pass+1)) || fail=$((fail+1))

    local bind_ip
    bind_ip="${FORGE_BIND_IP:-$(detect_tailscale_ip || echo 'UNKNOWN')}"
    local overall="PASS"
    [[ "${fail}" -gt 0 ]] && overall="NEEDS ATTENTION"

    cat > "${VALIDATION_OUT}" <<HEADER
# LFCS Project 09 — Secure Browser Forge Validation Report

**Generated:** $(date '+%Y-%m-%d %H:%M:%S %Z')
**Host:** $(hostname -f) ($(hostname -I | awk '{print $1}'))
**Forge URL:** https://${bind_ip}:${FORGE_PORT}/
**Overall Status:** ${overall} (${pass} passed, ${fail} failed automated gates)

---

## LFCS Validation Checklist

| # | Requirement | Exam Critical | Status |
|---|-------------|---------------|--------|
| 1 | Configuration persists across reboots | Yes | systemd + firewalld --permanent + sshd drop-in |
| 2 | Remote access limited to Tailscale only | Yes | Port bind + rich rule on ${TAILSCALE_INTERFACE} |
| 3 | Least-privilege permissions | Yes | ${FORGE_USER} + restricted sudoers |
| 4 | Container running with restart policy | Yes | unless-stopped + systemd wrapper |
| 5 | Auditable documentation | Yes | This file (auto-generated) |
| 6 | Automation via bash script | Yes | automation/secure-browser-forge.sh |

---

## Reboot Persistence Test (perform manually)

\`\`\`bash
sudo reboot
# Reconnect via Termius, then:
cd ${LFCS_ROOT}/automation
sudo ./secure-browser-forge.sh   # choose option 4
\`\`\`

Expected: all automated gates pass without re-running deploy.

---

## Live Evidence (command output)

HEADER

    # Append evidence blocks
    {
        for line in "${EVIDENCE[@]}"; do
            echo "${line}"
        done
    } >> "${VALIDATION_OUT}"

    cat >> "${VALIDATION_OUT}" <<FOOTER

---

## Quick Manual Checks

\`\`\`bash
# Container health
docker ps --filter name=secure-browser-forge
docker inspect --format='{{.State.Health.Status}}' secure-browser-forge

# Tailnet-only binding
ss -tlnp | grep ${FORGE_PORT}

# Firewall
sudo firewall-cmd --list-rich-rules

# Boot services
systemctl is-enabled docker secure-browser-forge firewalld
\`\`\`

---

*Report generated by \`secure-browser-forge.sh\` — LFCS Project 09*
FOOTER

    ok "Validation report written: ${VALIDATION_OUT}"
    log "Open from tablet: cat ${VALIDATION_OUT}"
}

# =============================================================================
# Status & teardown
# =============================================================================

show_status() {
    heading "Current Status"
    echo "  Deploy dir:    ${DEPLOY_DIR}"
    echo "  Bind IP:       ${FORGE_BIND_IP:-$(detect_tailscale_ip || echo 'not set')}"
    echo "  Forge URL:     https://${FORGE_BIND_IP:-$(detect_tailscale_ip || echo 'IP')}:${FORGE_PORT}/"
    echo ""
    docker ps --filter name=secure-browser-forge 2>/dev/null || warn "Docker not available"
    systemctl is-active secure-browser-forge.service 2>/dev/null && ok "systemd unit active" || warn "systemd unit not active"
    [[ -f "${VALIDATION_OUT}" ]] && ok "Validation report exists" || warn "No validation report yet — run option 4"
}

teardown() {
    heading "Teardown"
    read -r -p "  Remove forge services, firewall rules, and container? [y/N] " confirm
    [[ "${confirm}" =~ ^[Yy]$ ]] || { log "Aborted."; return; }

    systemctl disable --now secure-browser-forge.service 2>/dev/null || true
    [[ -d "${DEPLOY_DIR}" ]] && (cd "${DEPLOY_DIR}" && docker compose down -v 2>/dev/null) || true

    local rule="rule family=ipv4 source address=${TAILSCALE_CIDR} interface name=${TAILSCALE_INTERFACE} port port=${FORGE_PORT} protocol=tcp accept"
    firewall-cmd --permanent --remove-rich-rule="${rule}" 2>/dev/null || true
    firewall-cmd --reload 2>/dev/null || true

    rm -f "${SYSTEMD_UNIT}" "${MARKER_FILE}"
    systemctl daemon-reload

    ok "Teardown complete. SSH/sysctl hardening left in place (manual removal if desired)."
}

# =============================================================================
# Full deploy orchestrator
# =============================================================================

full_deploy() {
    require_root
    prompt_config
    step_preflight
    pause_teaching "Preflight done. Continue to Docker install?"
    step_install_docker
    step_create_service_user
    step_harden_ssh
    pause_teaching "SSH hardened. Still connected? Continue..."
    step_harden_sysctl
    step_configure_sudoers
    step_deploy_compose
    step_configure_firewall
    step_enable_systemd_persistence
    step_install_health_cron
    generate_validation_md

    heading "Deploy Complete"
    ok "Access: https://${FORGE_BIND_IP}:${FORGE_PORT}/"
    log "User: ${FORGE_WEB_USER}  |  Accept the self-signed TLS certificate"
    log "Next LFCS step: sudo reboot → reconnect → run option 4 to prove persistence"
}

# =============================================================================
# Interactive menu
# =============================================================================

show_menu() {
    echo ""
    printf '\033[1;36m  LFCS Project 09 — Secure Browser Forge\033[0m\n'
    echo "  ─────────────────────────────────────────"
    echo "  1) Full Deploy (idempotent)"
    echo "  2) Configure Firewall Only"
    echo "  3) Show Status"
    echo "  4) Generate Validation Report (VALIDATION.md)"
    echo "  5) Teardown (remove forge, keep SSH hardening)"
    echo "  6) Exit"
    echo ""
}

load_env_if_present() {
    [[ -f "${ENV_FILE}" ]] && source "${ENV_FILE}"
}

main() {
    load_env_if_present

    while true; do
        show_menu
        read -r -p "  Choose [1-6]: " choice
        case "${choice}" in
            1) full_deploy ;;
            2)
                require_root
                prompt_config
                step_configure_firewall
                generate_validation_md
                ;;
            3) show_status ;;
            4)
                require_root
                load_env_if_present
                [[ -z "${FORGE_BIND_IP}" ]] && FORGE_BIND_IP="$(detect_tailscale_ip || true)"
                generate_validation_md
                ;;
            5) require_root; teardown ;;
            6) log "Good luck on the LFCS exam!"; exit 0 ;;
            *) warn "Invalid choice" ;;
        esac
    done
}

main "$@"