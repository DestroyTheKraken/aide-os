"""Load canonical lesson tasks from schedule/lesson-tasks.json."""
from __future__ import annotations

import json
from pathlib import Path
from typing import Any

_TASKS_PATH = Path(__file__).with_name("lesson-tasks.json")
_CACHE: dict[str, Any] | None = None


def _load() -> dict[str, Any]:
    global _CACHE
    if _CACHE is None:
        _CACHE = json.loads(_TASKS_PATH.read_text())
    return _CACHE


def get_tasks(project: str, phase: str = "", duration_min: int = 45) -> list[str]:
    data = _load()
    templates = data.get("_templates", {})
    fallback = data.get("_fallback", [])

    if project in data and not project.startswith("_"):
        raw = data[project]
        out: list[str] = []
        for t in raw:
            if "{" in t:
                out.append(t.format(duration=duration_min, project=project, phase=phase))
            else:
                out.append(t)
        return out

    return [
        t.format(project=project, phase=phase, duration=duration_min)
        for t in fallback
    ]