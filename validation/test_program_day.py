#!/usr/bin/env python3
"""Unit tests for schedule/program_day.py"""
import sys
from datetime import date
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "schedule"))

from program_day import compute_program_day  # noqa: E402


SCHEDULE = {
    "start_date": "2026-06-14",
    "cycle": 1,
    "days": [{"day": i, "project": "00", "title": f"d{i}"} for i in range(1, 46)],
}


def test_day_one():
    d, e, c = compute_program_day(SCHEDULE, date(2026, 6, 14))
    assert d == 1 and c == 1


def test_day_forty_five():
    d, e, c = compute_program_day(SCHEDULE, date(2026, 7, 28))
    assert d == 45 and c == 1


def test_cap_at_forty_five():
    d, e, c = compute_program_day(SCHEDULE, date(2026, 8, 1))
    assert d == 45 and c == 1


def test_before_start():
    d, e, c = compute_program_day(SCHEDULE, date(2026, 6, 1))
    assert d == 1


if __name__ == "__main__":
    test_day_one()
    test_day_forty_five()
    test_cap_at_forty_five()
    test_before_start()
    print("OK: test_program_day")