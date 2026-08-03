---
tags: [usage, bridge, tracker, grokaide]
cssclasses: [dashboard]
---

# 📡 Usage Bridge · SuperGrok bar tracker

> [!summary] What you are measuring
> **Weekly SuperGrok % bar** (Grok Build line) — not TUI context tokens, not API $.

## Refresh numbers

```bash
usage-tracker
# after next Usage screenshot:
usage-tracker --append 28 --activity strategic --notes "reason"
```

## Live state (edit after tracker run, or open JSON)

<!-- LIVE-START -->
## Live snapshot (auto)

| Sensor | Reading |
|--------|---------|
| **Weekly bar** | **26%** used |
| **Reset** | `2026-08-07T23:58:00` |
| **Plan ≤ heavy/day** | **0.75 h** (~45 min) |
| **Plan more this week** | 4.32 h (after 20% reserve) |
| **Weekly $ scaffold** | $6.92 · used ~$1.80 |
| **Updated (UTC)** | 2026-08-02T12:18:36 |

*Refresh: `usage-tracker` then `aide-bridge-sync`.*
<!-- LIVE-END -->

Path: `../docs/ops/usage-state.json` (outside vault root — open in terminal)

| Field | Meaning |
|-------|---------|
| `latest_pct` | Last screenshot % |
| `planned_per_day_h` | Max heavy Build hours/day with reserve |
| `reset` | Weekly reset time |
| `weekly_sub_usd` | ~$6.92 for SuperGrok $30/mo |

## Three meters (don’t mix)

| Meter | UI | Role |
|-------|-----|------|
| **A Weekly pool** | Settings → Usage **%** | Shared Chat/Build/… — **screenshot this** |
| **B API $** | console.x.ai | Separate prepaid |
| **C Context** | TUI `321K/500K` | This session only |

## Where to spend time

| When | What | Bar |
|------|------|-----|
| Morning | [[DAY-START]] LFCS | ~0% |
| Midday | Build only if stuck | ≤45 min/day |
| Afternoon | Labs / TV site | ~0% |
| Late multi-agent nights | Avoid as default | Burns fast |

## Samples log

Machine log: `~/AIDE_OS/docs/ops/usage-samples.csv`  
Markdown log: open via terminal `usage-tracker`

## Starship rule

**Local first. Build when stuck. Log every bar screenshot.**

---

#usage #grokaide
