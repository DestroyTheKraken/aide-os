#!/usr/bin/env bash
# Install LFCS daily guidance cron on um690 (control plane).
# Uses user crontab (no sudo required) or system cron if run as root.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LFCS_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SCAN="${SCRIPT_DIR}/lfcs-cluster-scan.sh"
GUIDANCE="${SCRIPT_DIR}/lfcs-daily-guidance.sh"
PORTAL_BUILD="${SCRIPT_DIR}/lfcs-portal-build.sh"

chmod +x "${SCAN}" "${GUIDANCE}" "${PORTAL_BUILD}"

NOTIFY_TIME="$(python3 -c "import json; print(json.load(open('${LFCS_ROOT}/schedule/daily-schedule.json'))['notification_time'])" 2>/dev/null || echo '07:00')"
CRON_HOUR="${NOTIFY_TIME%%:*}"
CRON_MIN="${NOTIFY_TIME##*:}"

CRON_USER="${USER:-kraken}"
MARKER="# LFCS-daily-guidance"

# Build cron lines
CRON_SCAN="30 6 * * 0 ${SCAN} >> ${LFCS_ROOT}/notifications/scan.log 2>&1"
CRON_DAILY="${CRON_MIN} ${CRON_HOUR} * * * ${GUIDANCE} >> ${LFCS_ROOT}/notifications/cron.log 2>&1"

if [[ "${EUID}" -eq 0 ]]; then
    CRON_FILE="/etc/cron.d/lfcs-daily-guidance"
    cat > "${CRON_FILE}" <<EOF
${MARKER}
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=""
${CRON_SCAN//${SCAN}/${SCAN}}
EOF
    # Fix user for system cron
    sed -i "s|^30 6|30 6|" "${CRON_FILE}"
    cat > "${CRON_FILE}" <<EOF
${MARKER}
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=""
30 6 * * 0 ${CRON_USER} ${SCAN} >> ${LFCS_ROOT}/notifications/scan.log 2>&1
${CRON_MIN} ${CRON_HOUR} * * * ${CRON_USER} ${GUIDANCE} >> ${LFCS_ROOT}/notifications/cron.log 2>&1
EOF
    chmod 644 "${CRON_FILE}"
    echo "Installed system cron: ${CRON_FILE}"
else
    # User crontab — idempotent merge
    TEMP="$(mktemp)"
    crontab -l 2>/dev/null | grep -v "${MARKER}" | grep -v "${SCAN}" | grep -v "${GUIDANCE}" > "${TEMP}" || true
    {
        cat "${TEMP}"
        echo "${MARKER}"
        echo "${CRON_SCAN}"
        echo "${CRON_DAILY}"
    } | crontab -
    rm -f "${TEMP}"
    echo "Installed user crontab for ${CRON_USER}"
fi

echo "  Daily guidance: ${NOTIFY_TIME} every day (chains portal-build + ara-sync)"
echo "  Cluster scan:   Sundays 06:30"
echo "  Note: ara-sync has NO separate cron line (PR 9)"
echo ""
echo "Verify: crontab -l | grep LFCS"
echo "Test now: ${GUIDANCE}"