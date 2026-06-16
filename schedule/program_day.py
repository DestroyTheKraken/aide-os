"""Shared program day resolution for LFCS / AIOS automation."""
from __future__ import annotations

import json
from datetime import date
from pathlib import Path
from typing import Any


def load_schedule(path: str | Path) -> dict[str, Any]:
    return json.loads(Path(path).read_text())


def compute_program_day(schedule: dict[str, Any], today: date | None = None) -> tuple[int, dict[str, Any], int]:
    """
    Single source of truth for program day resolution.
    Policy: cap at max_day until learner sets a new start_date (OQ4).
    Cycle from schedule metadata field ``cycle`` (default 1).
    """
    today = today or date.today()
    start = date.fromisoformat(schedule["start_date"])
    max_day = max(d["day"] for d in schedule["days"])
    raw = (today - start).days + 1
    cycle_num = int(schedule.get("cycle", 1))

    if raw < 1:
        day_num = 1
    elif raw > max_day:
        day_num = max_day
    else:
        day_num = raw

    entry = next(d for d in schedule["days"] if d["day"] == day_num)
    return day_num, entry, cycle_num


def weak_areas_active(entry: dict[str, Any]) -> list[str]:
    wa = entry.get("weak_area")
    if not wa:
        return []
    if isinstance(wa, list):
        return wa
    return [str(wa)]