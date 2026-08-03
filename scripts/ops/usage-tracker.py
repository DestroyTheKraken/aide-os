#!/usr/bin/env python3
"""Quantify SuperGrok weekly usage from screenshot-derived samples.

What you are measuring
----------------------
Pool A — SuperGrok weekly **percentage** (Settings → Usage). Opaque units.
         Grok Build is one product line on that shared pool.
Pool B — xAI API / Extra Credits in **dollars** (console.x.ai). Separate.
Context — TUI "321K/500K" is **session context window**, NOT weekly pool.

Pay tier scaffold (edit if your plan changes):
  SuperGrok ~$30/mo → weekly_sub = 30*12/52

Usage:
  python3 usage-tracker.py              # report
  python3 usage-tracker.py --append 27  # log 27% now (manual after screenshot)
"""
from __future__ import annotations

import argparse
import csv
import json
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path.home() / "AIDE_OS"
CSV_PATH = ROOT / "docs/ops/usage-samples.csv"
JSON_PATH = ROOT / "docs/ops/usage-state.json"

# Pay tier assumptions (planning dollars — not xAI published unit prices)
MONTHLY_SUB = 30.0
WEEKLY_SUB = MONTHLY_SUB * 12 / 52  # ≈ 6.923
DAILY_SUB = WEEKLY_SUB / 7
RESERVE_FRAC = 0.20  # keep 20% unspent
# Placeholder: hours of *heavy pure Build* that burn 100% (calibrate with pairs)
H_HEAVY_PLACEHOLDER = 8.0


def _parse_ts(ts: str) -> datetime:
    """Normalize to timezone-aware local times for sorting."""
    dt = datetime.fromisoformat(ts)
    if dt.tzinfo is None:
        # assume local
        dt = dt.astimezone()
    return dt


def load_rows(path: Path) -> list[dict]:
    rows = []
    if not path.exists():
        return rows
    with path.open() as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            parts = next(csv.reader([line]))
            if len(parts) < 6:
                continue
            ts, pct, product, reset, source, activity = parts[:6]
            notes = parts[6] if len(parts) > 6 else ""
            rows.append(
                {
                    "ts": _parse_ts(ts),
                    "pct": float(pct),
                    "product": product,
                    "reset": reset,
                    "source": source,
                    "activity": activity,
                    "notes": notes,
                }
            )
    rows.sort(key=lambda r: r["ts"])
    return rows


def append_row(pct: float, activity: str = "manual", notes: str = "") -> None:
    now = datetime.now().astimezone().replace(microsecond=0)
    # reuse last reset if known (naive compare-safe load)
    rows = load_rows(CSV_PATH)
    reset = rows[-1]["reset"] if rows else "unknown"
    # store without double-offset confusion: use local offset ISO
    line = (
        f"{now.isoformat(timespec='seconds')},{pct:.0f},Grok Build,{reset},"
        f"manual,{activity},{notes or 'cli append'}\n"
    )
    with CSV_PATH.open("a") as f:
        f.write(line)
    print("appended:", line.strip())


def report(rows: list[dict]) -> dict:
    if not rows:
        print("No samples. Screenshot Usage bar → append with --append PCT")
        return {}

    first, last = rows[0], rows[-1]
    wall_h = (last["ts"] - first["ts"]).total_seconds() / 3600
    dpp = last["pct"] - first["pct"]
    pp_per_wall_h = dpp / wall_h if wall_h > 0 else 0

    # Pure-heavy segments: activity strategic/mixed only, skip pure local zero-burn
    heavy_pairs = []
    for a, b in zip(rows, rows[1:]):
        mins = (b["ts"] - a["ts"]).total_seconds() / 60
        dp = b["pct"] - a["pct"]
        if mins <= 0:
            continue
        if a["activity"] == "local" and dp == 0:
            continue
        heavy_pairs.append((mins, dp, a, b))

    # Estimate H_heavy from intervals with measurable burn
    # H_heavy ≈ 100 / (sum(dp)/sum(hours_during_burn_windows))
    burn_mins = sum(m for m, dp, *_ in heavy_pairs if dp > 0)
    burn_pp = sum(dp for m, dp, *_ in heavy_pairs if dp > 0)
    if burn_mins > 0 and burn_pp > 0:
        pp_per_h_burn = burn_pp / (burn_mins / 60)
        h_heavy_est = 100.0 / pp_per_h_burn
    else:
        pp_per_h_burn = None
        h_heavy_est = None

    h = H_HEAVY_PLACEHOLDER
    u = last["pct"]
    hours_used = h * u / 100
    hours_left = h * (100 - u) / 100
    planned_more = max(0, h * (1 - RESERVE_FRAC) - hours_used)
    usd_used = WEEKLY_SUB * u / 100
    usd_left = WEEKLY_SUB * (100 - u) / 100

    # Days to reset (parse if ISO-ish)
    try:
        reset_dt = datetime.fromisoformat(last["reset"])
        if reset_dt.tzinfo is None:
            days_left = (reset_dt - last["ts"].replace(tzinfo=None)).total_seconds() / 86400
        else:
            days_left = (reset_dt - last["ts"].astimezone(reset_dt.tzinfo)).total_seconds() / 86400
    except Exception:
        days_left = 5.5

    per_day = planned_more / days_left if days_left > 0 else planned_more

    print("=" * 60)
    print("WHAT YOU ARE USING")
    print("=" * 60)
    print(
        """
Meter A — SuperGrok weekly pool (screenshot bar)
  • Shared across Chat / Imagine / Voice / **Grok Build** / etc.
  • UI shows **% only** — xAI does not publish raw tokens for this pool.
  • Your samples show product line: **Grok Build** = essentially all visible burn.

Meter B — xAI API / Extra Credits ($)
  • Separate prepaid dollars (console.x.ai). Not the weekly bar.
  • Earlier snapshot: ~$61.50 remaining · Extra Credits $0.00 on Usage pane.

Meter C — Session context (TUI  e.g. 321K/500K)
  • Context window for **this chat**, not weekly quota.
  • High context ≠ high weekly % by itself (but long agent loops burn both).
"""
    )
    print("=" * 60)
    print("PAY TIER (planning math)")
    print("=" * 60)
    print(f"  Assumed plan: SuperGrok ~${MONTHLY_SUB:.0f}/mo")
    print(f"  weekly_sub  = ${WEEKLY_SUB:.2f}   (30×12/52)")
    print(f"  daily_sub   = ${DAILY_SUB:.2f}")
    print(f"  $/pp of week = ${WEEKLY_SUB/100:.4f} per 1% of bar")
    print()
    print("=" * 60)
    print("YOUR TRACKER (from screenshots)")
    print("=" * 60)
    print(f"  Samples     : {len(rows)}")
    print(f"  First       : {first['ts']} @ {first['pct']:.0f}%")
    print(f"  Latest      : {last['ts']} @ {last['pct']:.0f}%")
    print(f"  Reset ETA   : {last['reset']}")
    print(f"  Δ over window: +{dpp:.0f} pp in {wall_h:.2f} h wall clock")
    print(f"  Avg wall    : {pp_per_wall_h:.2f} pp per hour of clock-on-desk")
    if pp_per_h_burn:
        print(f"  Burn windows: {pp_per_h_burn:.2f} pp/h when % was moving")
        print(f"  H_heavy est : ~{h_heavy_est:.1f} h pure-Build for 100% (from burn windows)")
    print(f"  H_heavy use : {h:.1f} h placeholder for capacity tables")
    print()
    print("  Interval detail:")
    print(f"  {'from→to':14} {'Δ%':>4} {'min':>5} {'pp/h':>6}  activity")
    for mins, dp, a, b in heavy_pairs:
        pph = dp / (mins / 60) if mins else 0
        print(
            f"  {a['ts'].strftime('%H:%M')}→{b['ts'].strftime('%H:%M'):8} "
            f"{dp:+4.0f} {mins:5.0f} {pph:6.1f}  {a['activity']}→{b['activity']}"
        )
    print()
    print("=" * 60)
    print(f"CAPACITY NOW @ {u:.0f}%  (placeholder H_heavy={h})")
    print("=" * 60)
    print(f"  Used        : {hours_used:.2f} h heavy-eq · ${usd_used:.2f} of weekly planning $")
    print(f"  Left        : {hours_left:.2f} h · ${usd_left:.2f}")
    print(f"  Reserve 20% : hold {h*RESERVE_FRAC:.1f} h of full week")
    print(f"  Plan more   : ≤ {planned_more:.2f} h heavy before reset")
    print(f"  Days left   : ~{days_left:.1f} d → **≤ {per_day:.2f} h/day** planned heavy")
    print()
    print("=" * 60)
    print("WHERE / WHEN TO SPEND (recommendation)")
    print("=" * 60)
    print(
        f"""
  TIER MAP
  --------
  SuperGrok weekly bar  →  interactive Grok **Build** (design, debug, multi-agent)
  Local um690           →  Obsidian LFCS, VBox, docs, portfolio serve  (≈ 0% bar)
  xAI API $             →  only after bar empty or hard automation budget
  X free Grok limits    →  separate (e.g. 15 q / 20h) — not this bar

  CLOCK (ADHD-friendly)
  ---------------------
  Morning (best focus)  →  LFCS in Obsidian 25–45 min   [local · $0 bar]
  Midday short          →  ≤ 20–30 min Build if stuck   [strategic]
  Afternoon             →  labs / Core / site on TV      [local]
  Evening               →  optional content VO           [light Build]
  Night grind           →  avoid if % climbing fast      [you burned overnight]

  This sample night: ~01:00–05:11 desk time · 9%→26% = **+17 pp**
  → Overnight multi-agent design is **expensive** on the bar.
  → Pure VBox/download stretches showed **0 pp** (use those for config).

  WEEK TO RESET ({last['reset']})
  -------------------------------
  Target heavy Build: **≤ {per_day:.1f} h/day** (with reserve)
  Prefer:  Mon–Fri morning/midday for Build; LFCS any time local
  Protect: Fri night reserve so you don't hit 100% mid-weekend project
"""
    )

    state = {
        "updated": datetime.now(timezone.utc).isoformat(),
        "latest_pct": u,
        "reset": last["reset"],
        "weekly_sub_usd": round(WEEKLY_SUB, 2),
        "h_heavy_placeholder": h,
        "h_heavy_est_from_burn": round(h_heavy_est, 2) if h_heavy_est else None,
        "hours_used_eq": round(hours_used, 2),
        "hours_left_eq": round(hours_left, 2),
        "planned_more_h": round(planned_more, 2),
        "planned_per_day_h": round(per_day, 2),
        "pp_per_wall_hour": round(pp_per_wall_h, 2),
        "samples": len(rows),
    }
    JSON_PATH.write_text(json.dumps(state, indent=2) + "\n")
    print(f"State written: {JSON_PATH}")
    return state


def main():
    ap = argparse.ArgumentParser(description="SuperGrok usage tracker from bar screenshots")
    ap.add_argument("--append", type=float, metavar="PCT", help="Append a new sample percent")
    ap.add_argument("--activity", default="manual", help="activity_class for --append")
    ap.add_argument("--notes", default="", help="notes for --append")
    args = ap.parse_args()
    if args.append is not None:
        append_row(args.append, args.activity, args.notes)
    rows = load_rows(CSV_PATH)
    report(rows)


if __name__ == "__main__":
    main()
