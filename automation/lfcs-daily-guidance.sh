#!/usr/bin/env bash
# =============================================================================
# LFCS Daily Guidance — generates today's structured study notice.
# Chains: guidance → portal-build → ara-sync (single cron entry; PR 9).
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LFCS_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SCHEDULE="${LFCS_ROOT}/schedule/daily-schedule.json"
INV_JSON="${LFCS_ROOT}/inventory/cluster.json"
NOTIFY_DIR="${LFCS_ROOT}/notifications/daily"
LATEST="${LFCS_ROOT}/notifications/latest-daily-guidance.txt"
STUDY_LOG="${LFCS_ROOT}/notifications/study-journal.log"
TODAY="$(date '+%Y-%m-%d')"
OUT="${NOTIFY_DIR}/${TODAY}.md"

mkdir -p "${NOTIFY_DIR}"

if [[ ! -f "${INV_JSON}" ]] || [[ "$(find "${INV_JSON}" -mtime +1 2>/dev/null)" ]]; then
    "${SCRIPT_DIR}/lfcs-cluster-scan.sh" >/dev/null 2>&1 || true
fi

read -r PROGRAM_DAY TODAY_ENTRY < <(python3 - <<PY
import json, os, sys
from pathlib import Path
sys.path.insert(0, "${LFCS_ROOT}/schedule")
from program_day import compute_program_day, load_schedule

sched = load_schedule("${SCHEDULE}")
day_num, entry, cycle = compute_program_day(sched)
print(day_num, json.dumps(entry))
PY
)

export TODAY_ENTRY LFCS_ROOT TODAY PROGRAM_DAY INV_JSON OUT LATEST SCHEDULE
python3 - <<'PY'
import json, datetime, os, sys
from pathlib import Path

sys.path.insert(0, os.environ["LFCS_ROOT"] + "/schedule")
from lesson_tasks import get_tasks

entry = json.loads(os.environ["TODAY_ENTRY"])
lfcs_root = os.environ["LFCS_ROOT"]
today = os.environ["TODAY"]
program_day = int(os.environ["PROGRAM_DAY"])
inv_json = os.environ["INV_JSON"]
out_path = os.environ["OUT"]
latest_path = os.environ["LATEST"]
node = entry["node"]

fallback_ips = {"um690":"100.81.13.95","node1":"100.75.124.36","node2":"100.104.54.20","node3":"100.82.177.52","any":"any"}
node_ip = fallback_ips.get(node, node)
try:
    inv = json.loads(Path(inv_json).read_text())
    for h in inv["lfcs_cluster"]:
        if h["name"] == node:
            node_ip = h["tailscale_ip"]
            break
except Exception:
    pass

project = entry["project"]
phase = entry["phase"]
title = entry["title"]
domains = ", ".join(entry["domains"])
duration = entry["duration_min"]
weak = entry.get("weak_area")
tasks = get_tasks(project, phase, duration)

project_file = f"Study_Projects/{project}.md" if project not in ("—", "mix") else "guides/DAILY_STUDY_PROTOCOL.md"

lines = []
lines.append(f"# LFCS Daily Guidance — {today}")
lines.append("")
lines.append(f"**Program day {program_day} of 45** | **~{duration} min** | **Node: {node}** (`{node_ip}`)")
if weak:
    lines.append(f"**Weak-area focus:** `{weak}`")
lines.append("")
lines.append("---")
lines.append("")
lines.append(f"## Today's Focus: {title}")
lines.append("")
lines.append("| Field | Value |")
lines.append("|-------|-------|")
lines.append(f"| Project | {project} |")
lines.append(f"| Phase | {phase} |")
lines.append(f"| LFCS Domains | {domains} |")
lines.append(f"| Target node | **{node}** ({node_ip}) |")
lines.append(f"| Study guide | `{project_file}` |")
lines.append("")
lines.append("---")
lines.append("")
lines.append("## Step-by-Step (do in order)")
lines.append("")
for i, t in enumerate(tasks, 1):
    lines.append(f"{i}. {t}")
lines.append("")
lines.append("---")
lines.append("")
lines.append("## Connect via Termius")
lines.append("")
if node == "any":
    lines.append("```bash")
    lines.append("ssh kraken@100.75.124.36   # node1")
    lines.append("ssh kraken@100.82.177.52   # node3")
    lines.append("```")
elif node == "um690":
    lines.append("```bash")
    lines.append(f"cd {lfcs_root}")
    lines.append("cat notifications/latest-daily-guidance.txt")
    lines.append("```")
else:
    lines.append("```bash")
    lines.append(f"ssh kraken@{node_ip}")
    lines.append("```")
lines.append("")
lines.append("---")
lines.append("")
lines.append("## LFCS Exam Tip")
tips = [
    "Persistence = reboot test. If it breaks after reboot, it doesn't count.",
    "Always sshd -t before reloading sshd. Lockout costs you the exam.",
    "Use UUIDs in fstab, never /dev/sdX names.",
    "visudo -c after every sudoers.d edit.",
    "firewall-cmd --permanent then --reload.",
    "Scripts: set -euo pipefail is your safety net.",
    "man -k <keyword> when you forget the command name.",
    "Document commands as you go.",
]
lines.append(f"> {tips[program_day % len(tips)]}")
lines.append("")
lines.append("---")
lines.append("## End-of-Session Checklist")
lines.append("")
lines.append("- [ ] Completed all steps above")
lines.append("- [ ] Verified persistence (or scheduled reboot test)")
lines.append("- [ ] Logged blockers in study journal")
lines.append(f"- [ ] Append: `echo '{today} Project {project} phase {phase} DONE' >> notifications/study-journal.log`")
lines.append("")
lines.append("---")
lines.append(f"*Generated {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')} by lfcs-daily-guidance.sh*")

content = "\n".join(lines)
Path(out_path).write_text(content)
Path(latest_path).write_text(content)
print(content)
PY

if ! grep -q "^# Study Journal" "${STUDY_LOG}" 2>/dev/null; then
    echo "# Study Journal — append DONE lines as you complete sessions" > "${STUDY_LOG}"
fi

BANNER="$(head -6 "${LATEST}" | tail -3 | tr '\n' ' ')"
logger -t lfcs-daily "Day ${PROGRAM_DAY}: ${BANNER}" 2>/dev/null || true
if command -v wall &>/dev/null && [[ -n "${BANNER}" ]]; then
    echo "LFCS Daily Guidance (Day ${PROGRAM_DAY}): ${BANNER}" | wall 2>/dev/null || true
fi

if [[ -x "${SCRIPT_DIR}/lfcs-portal-build.sh" ]]; then
    "${SCRIPT_DIR}/lfcs-portal-build.sh" >/dev/null 2>&1 || true
    docker exec lfcs-portal nginx -s reload 2>/dev/null || true
fi

if [[ -x "${SCRIPT_DIR}/lfcs-ara-sync.sh" ]]; then
    "${SCRIPT_DIR}/lfcs-ara-sync.sh" >> "${LFCS_ROOT}/notifications/cron.log" 2>&1 || true
fi

echo ""
echo "─────────────────────────────────────────"
echo "  Guidance written: ${OUT}"
echo "  Portal updated:   ${LFCS_ROOT}/portal/www/data/daily.json"
echo "  Quick read:       cat ${LATEST}"
echo "─────────────────────────────────────────"