#!/usr/bin/env python3
"""Smoke test overlay expectation resolver (PR 7)."""
import json
import re
import sys
from pathlib import Path

LFCS = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(LFCS / "schedule"))

CONTEXT_SAMPLE = """---
program_day: 5
program_cycle: 1
project: "02"
node: "node1"
---
"""


def resolve_overlay_expectations(item, context_text):
    if not item.get("dynamic"):
        return item.get("expect_substrings", [])
    ctx = {}
    for line in context_text.splitlines():
        m = re.match(r"^(\w+):\s*(.+)$", line.strip())
        if m:
            ctx[m.group(1)] = m.group(2).strip().strip('"')
    return [str(ctx[f]) for f in item.get("expect_from_context", []) if f in ctx]


def test_day_five_project():
    prompts = json.loads((LFCS / "validation/ara-eval-prompts.json").read_text())
    item = next(p for p in prompts["overlay_suite"] if p["id"] == "day-context")
    expects = resolve_overlay_expectations(item, CONTEXT_SAMPLE)
    assert "02" in expects
    assert "node1" in expects


if __name__ == "__main__":
    test_day_five_project()
    print("OK: test_ara_eval")