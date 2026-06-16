#!/usr/bin/env python3
"""Unit tests for schedule/lesson_tasks.py"""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "schedule"))

from lesson_tasks import get_tasks  # noqa: E402


def test_project_02():
    tasks = get_tasks("02", "1-2", 60)
    assert any("grep" in t for t in tasks)


def test_mix_duration():
    tasks = get_tasks("mix", "drill", 45)
    assert tasks[0] == "Set timer for 45 minutes"


def test_fallback():
    tasks = get_tasks("99", "x", 30)
    assert "Study_Projects/99.md" in tasks[0]


if __name__ == "__main__":
    test_project_02()
    test_mix_duration()
    test_fallback()
    print("OK: test_lesson_tasks")