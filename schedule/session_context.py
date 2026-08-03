"""Generate ara_tutor/session/context.md for Ara Modelfile overlay."""
from __future__ import annotations

from pathlib import Path
from typing import Any

from lesson_tasks import get_tasks
from program_day import weak_areas_active


def build_context_md(
    day_num: int,
    entry: dict[str, Any],
    cycle_num: int,
    program_total: int,
    tasks: list[str] | None = None,
) -> str:
    project = entry.get("project", "")
    phase = entry.get("phase", "")
    duration = entry.get("duration_min", 45)
    weak = weak_areas_active(entry)
    task_list = tasks if tasks is not None else get_tasks(project, phase, duration)

    lines = [
        "---",
        f"program_day: {day_num}",
        f"program_cycle: {cycle_num}",
        f"program_total: {program_total}",
        f"project: \"{project}\"",
        f"phase: \"{phase}\"",
        f"node: \"{entry.get('node', '')}\"",
        f"title: \"{entry.get('title', '')}\"",
        f"duration_min: {duration}",
        f"domains: {entry.get('domains', [])}",
    ]
    if weak:
        lines.append(f"weak_areas_active: {weak}")
    lines.append("tasks:")
    for t in task_list:
        lines.append(f"  - \"{t.replace(chr(34), chr(39))}\"")
    lines.append("---")
    lines.append("")
    lines.append(f"# Session context — Day {day_num} of {program_total} (cycle {cycle_num})")
    lines.append("")
    lines.append(f"**Project {project}** · Phase {phase} · Node **{entry.get('node', '')}**")
    lines.append(f"**{entry.get('title', '')}**")
    if weak:
        lines.append(f"**Weak-area focus:** {', '.join(weak)}")
    lines.append("")
    lines.append("## Today's tasks")
    for i, t in enumerate(task_list, 1):
        lines.append(f"{i}. {t}")
    return "\n".join(lines) + "\n"


def write_context(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content)