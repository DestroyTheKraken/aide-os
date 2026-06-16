#!/usr/bin/env bash
# Build LFCS Daily Dashboard data + sync static shell + Ara session context.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LFCS_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
WWW="${LFCS_ROOT}/portal/www"
SHELL="${LFCS_ROOT}/portal/shell/index.html"
SCHEDULE="${LFCS_ROOT}/schedule/daily-schedule.json"
RESOURCES="${LFCS_ROOT}/schedule/lesson-resources.json"
GUIDANCE="${LFCS_ROOT}/notifications/latest-daily-guidance.txt"
GUIDANCE_MD="${LFCS_ROOT}/notifications/daily/$(date '+%Y-%m-%d').md"
INV="${LFCS_ROOT}/inventory/cluster.json"
CREDS="${LFCS_ROOT}/notifications/tablet-credentials.txt"
JOURNAL="${LFCS_ROOT}/notifications/study-journal.log"
ARA_SYNC_LOG="${LFCS_ROOT}/notifications/ara-sync.log"
CONTEXT_MD="${LFCS_ROOT}/ara_tutor/session/context.md"

mkdir -p "${WWW}/data" "${WWW}/study"
cp "${LFCS_ROOT}/Study_Projects/"*.md "${WWW}/study/" 2>/dev/null || true
cp "${SHELL}" "${WWW}/index.html"

[[ -f "${GUIDANCE}" ]] && cp "${GUIDANCE}" "${WWW}/daily.txt"
[[ -f "${GUIDANCE_MD}" ]] && cp "${GUIDANCE_MD}" "${WWW}/daily.md"

TS_IP="$(tailscale ip -4 2>/dev/null || echo '100.81.13.95')"
export TS_IP LFCS_ROOT SCHEDULE RESOURCES GUIDANCE INV CREDS JOURNAL ARA_SYNC_LOG CONTEXT_MD

python3 - <<'PY'
import json, datetime, os, re, sys
from pathlib import Path
from zoneinfo import ZoneInfo

sys.path.insert(0, str(Path(os.environ["LFCS_ROOT"]) / "schedule"))
from program_day import compute_program_day, load_schedule, weak_areas_active  # noqa: E402
from lesson_tasks import get_tasks  # noqa: E402
from session_context import build_context_md, write_context  # noqa: E402

lfcs = Path(os.environ["LFCS_ROOT"])
sched_path = Path(os.environ["SCHEDULE"])
resources_path = Path(os.environ["RESOURCES"])
guidance_path = Path(os.environ["GUIDANCE"])
inv_path = Path(os.environ["INV"])
creds_path = Path(os.environ["CREDS"])
journal_path = Path(os.environ["JOURNAL"])
ara_sync_log = Path(os.environ["ARA_SYNC_LOG"])
context_path = Path(os.environ["CONTEXT_MD"])
ts_ip = os.environ["TS_IP"]

sched = load_schedule(sched_path)
resources_db = json.loads(resources_path.read_text()) if resources_path.exists() else {}
start = datetime.date.fromisoformat(sched["start_date"])
tz_name = sched.get("timezone", "America/Chicago")
tz = ZoneInfo(tz_name)
now = datetime.datetime.now(tz)
today = now.date()
program_total = max(d["day"] for d in sched["days"])
day_num, entry, cycle_num = compute_program_day(sched, today)

guidance = guidance_path.read_text() if guidance_path.exists() else "Run: ./automation/lfcs-daily-guidance.sh"

tasks = get_tasks(entry.get("project", ""), entry.get("phase", ""), entry.get("duration_min", 45))
write_context(context_path, build_context_md(day_num, entry, cycle_num, program_total, tasks))

completed_days = set()
if journal_path.exists():
    for raw in journal_path.read_text().splitlines():
        line = raw.strip()
        if not line or line.startswith("#") or "DONE" not in line.upper():
            continue
        m = re.match(r"(\d{4}-\d{2}-\d{2})", line)
        if m:
            d = datetime.date.fromisoformat(m.group(1))
            prog_day = (d - start).days + 1
            if 1 <= prog_day <= program_total:
                completed_days.add(prog_day)

completed_count = len(completed_days)
progress_pct = round(100 * completed_count / program_total, 1)

cluster = []
peers_online = peers_total = 0
tailscale_self = ts_ip
try:
    inv = json.loads(inv_path.read_text())
    tailscale_self = inv.get("tailnet", {}).get("self", ts_ip)
    peers = inv.get("tailnet", {}).get("peers", [])
    peers_total = len(peers)
    peers_online = sum(1 for p in peers if p.get("online"))
    for h in inv.get("lfcs_cluster", []):
        cluster.append({
            "name": h["name"],
            "tailscale_ip": h["tailscale_ip"],
            "lfcs_role": h.get("lfcs_role", h.get("role", "")),
            "reachable": bool(h.get("reachable")),
        })
except Exception:
    pass

cluster_up = sum(1 for n in cluster if n["reachable"])
cluster_total = len(cluster) or 4

def day_meta(d):
    project = d.get("project", "")
    study_url = f"/study/{project}.md" if project not in ("—", "mix", "") else "/guides/GETTING_STARTED.md"
    return {
        "day": d["day"],
        "project": project,
        "phase": d.get("phase", ""),
        "node": d.get("node", ""),
        "title": d.get("title", ""),
        "duration_min": d.get("duration_min", 45),
        "domains": d.get("domains", []),
        "weak_area": d.get("weak_area"),
        "study_guide_url": study_url,
        "completed": d["day"] in completed_days,
        "is_today": d["day"] == day_num,
        "is_future": d["day"] > day_num,
    }

days = [day_meta(d) for d in sched["days"]]
project = entry.get("project", "00")
study_guide = f"Study_Projects/{project}.md" if project not in ("—", "mix", "") else "guides/GETTING_STARTED.md"
study_guide_url = f"/study/{project}.md" if project not in ("—", "mix", "") else "/guides/GETTING_STARTED.md"

def merge_resources(key):
    base = resources_db.get("default", {})
    specific = resources_db.get(key, {})
    out = {}
    for kind in ("youtube", "docs", "articles"):
        seen, items = set(), []
        for src in (base.get(kind, []), specific.get(kind, [])):
            for item in src:
                url = item.get("url", "")
                if url and url not in seen:
                    seen.add(url)
                    items.append(item)
        out[kind] = items
    return out

lesson_resources = merge_resources(project if project not in ("—", "mix", "") else "default")

workspace_user = "lfcs"
if creds_path.exists():
    for line in creds_path.read_text().splitlines():
        if line.strip().startswith("Username:"):
            workspace_user = line.split(":", 1)[1].strip()

weak = weak_areas_active(entry)
session_preamble = (
    f"LFCS Day {day_num}/{program_total} (cycle {cycle_num}): Project {project}, "
    f"phase {entry.get('phase', '')}, node {entry.get('node', '')}. "
    f"{entry.get('title', '')}"
)

# Parse ara-sync.log for monitoring
ara_mon = {
    "rag_status": "unknown",
    "rag_synced_at": None,
    "last_rag_ms": None,
    "last_inference_ms": None,
    "last_rag_eval_pass_rate": None,
}
if ara_sync_log.exists():
    for line in reversed(ara_sync_log.read_text().splitlines()):
        if "sync=" not in line:
            continue
        if "sync=ok" in line:
            ara_mon["rag_status"] = "ok"
        elif "sync=fail" in line:
            ara_mon["rag_status"] = "fail"
        m = re.search(r"rag_ms=(\d+)", line)
        if m:
            ara_mon["last_rag_ms"] = int(m.group(1))
        m = re.search(r"inference_smoke_ms=(\d+)", line)
        if m:
            ara_mon["last_inference_ms"] = int(m.group(1))
        m = re.search(r"rag_pass=([\d.]+)", line)
        if m:
            ara_mon["last_rag_eval_pass_rate"] = float(m.group(1))
        ts_part = line.split()[0] if line else None
        ara_mon["rag_synced_at"] = ts_part
        break

payload = {
    "generated_at": now.isoformat(timespec="seconds"),
    "datetime": {
        "date": now.strftime("%A, %B %-d, %Y"),
        "time": now.strftime("%-I:%M %p"),
        "timezone": tz_name,
    },
    "program_day": day_num,
    "program_cycle": cycle_num,
    "program_total": program_total,
    "schedule": {
        "project": project,
        "phase": entry.get("phase", ""),
        "node": entry.get("node", ""),
        "title": entry.get("title", ""),
        "duration_min": entry.get("duration_min", 45),
        "domains": entry.get("domains", []),
        "weak_area": entry.get("weak_area"),
        "weak_areas_active": weak,
        "study_guide": study_guide,
        "study_guide_url": study_guide_url,
    },
    "progress": {
        "completed_days": sorted(completed_days),
        "completed_count": completed_count,
        "total_days": program_total,
        "percent": progress_pct,
    },
    "monitoring": {
        "tailscale": {
            "self_ip": tailscale_self,
            "peers_online": peers_online,
            "peers_total": peers_total,
        },
        "cluster": {
            "nodes_up": cluster_up,
            "nodes_total": cluster_total,
        },
        "ara": ara_mon,
    },
    "days": days,
    "guidance": guidance,
    "resources": lesson_resources,
    "urls": {
        "portal": f"http://{ts_ip}:3080/",
        "browser": f"https://{ts_ip}:3001/",
        "ide": "/ide/",
        "ara": f"http://{ts_ip}:3082/",
    },
    "ara": {
        "name": "Ara",
        "tagline": "AIOS Education IDE",
        "subtitle": "Your personal Linux study assistant",
        "model": "Ara",
        "coder_model": "qwen2.5-coder:7b",
        "mvp": "LFCS Linux System Administration",
        "knowledge_base": "ara_tutor",
        "host": "um690",
        "session_preamble": session_preamble,
        "rag_status": ara_mon["rag_status"],
        "rag_synced_at": ara_mon["rag_synced_at"],
    },
    "workspace": {
        "username": workspace_user,
        "url": "/ide/",
        "hint": "Password: see notifications/tablet-credentials.txt on um690 (SSH via Termius). Same as Mullvad Lab Browser.",
        "password_source": "tablet-credentials.txt",
    },
    "cluster": cluster,
}

out = lfcs / "portal" / "www" / "data" / "daily.json"
out.write_text(json.dumps(payload, indent=2) + "\n")
print(f"Daily data: {out}")
print(f"Session context: {context_path}")
PY

echo "Portal built: ${WWW}/index.html + data/daily.json"