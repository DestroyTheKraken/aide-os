#!/usr/bin/env python3
"""Print today's LFCS-style lesson from aios-ed schedule + YouTube resources."""
import json, os, sys
from datetime import date
from pathlib import Path

ROOT = Path(os.environ.get("AIDE_ROOT", Path.home() / "AIDE_OS"))
SCHED = ROOT / "brain/bootcamp/lfcs/schedule/daily-schedule.json"
RES = ROOT / "brain/bootcamp/lfcs/schedule/lesson-resources.json"

def main():
    if not SCHED.exists():
        print("Missing schedule:", SCHED, file=sys.stderr)
        return 1
    data = json.loads(SCHED.read_text())
    start = date.fromisoformat(data["start_date"])
    days = data["days"]
    notif = data.get("notification_time", "07:00")
    tz = data.get("timezone", "local")
    today = date.today()
    idx = (today - start).days
    if idx < 0:
        print(f"Program starts {start} (in {-idx} days). notification_time={notif}")
        day, n = days[0], 1
    elif idx >= len(days):
        print(f"Program window ended (start {start}, {len(days)} days). Showing last day.")
        day, n = days[-1], len(days)
    else:
        day, n = days[idx], idx + 1
    title = day.get("title") or day.get("name") or day
    domains = day.get("domains") or day.get("domain") or ""
    duration = day.get("duration") or day.get("minutes") or ""
    project = str(day.get("project") or day.get("project_id") or "default")
    print(f"=== AIDE_OS lesson wall — day {n}/{len(days)} ===")
    print(f"date: {today.isoformat()}  start: {start}  notify: {notif} ({tz})")
    print(f"title: {title}")
    print(f"domains: {domains}")
    print(f"duration: {duration}")
    print(f"project_key: {project}")
    if RES.exists():
        r = json.loads(RES.read_text())
        block = r.get(project) or r.get("default") or {}
        urls = []
        if isinstance(block, dict):
            for k, v in block.items():
                if k.startswith("_"):
                    continue
                if isinstance(v, str) and "youtu" in v:
                    urls.append(v)
                elif isinstance(v, list):
                    urls.extend([x for x in v if isinstance(x, str) and "youtu" in x])
                elif isinstance(v, dict):
                    for vv in v.values():
                        if isinstance(vv, str) and "youtu" in vv:
                            urls.append(vv)
        if urls:
            print("youtube:")
            for u in urls[:5]:
                print(f"  - {u}")
        else:
            print("youtube: (none keyed — see lesson-resources.json)")
    print()
    print("TV NAD: LabNET Samsung .103 — cast/kiosk only (no SSH).")
    print("Design: docs/design/2026-08-02-learning-wall-tv-nad.md")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
