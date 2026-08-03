# Usage calibration strategy — SuperGrok → AIDE_OS

| Field | Value |
|-------|--------|
| **Updated** | 2026-08-02 |
| **Goal** | Measure real **time vs monthly $** so workflow can **maximize useful burn**, then **evenings/weekends off** without mid-sprint “usage wait” |
| **Product** | AIDE_OS documented for a **basic SuperGrok-tier** user (not heavy-only) |
| **Log** | [USAGE-LOG.md](./USAGE-LOG.md) |

---

## Intent (user lock)

1. **Calibrate accuracy** of wall-clock heavy GrokBuild vs weekly % vs **$30/mo**.  
2. **Burn on purpose** during measurement weeks so H_heavy is real, not a guess.  
3. **Then optimize** so capacity is used on high-value work Mon–Fri; resets enable rest.  
4. **Document AIDE_OS decisions + lessons** so a basic Grok tier user can follow without thrashing the pool.  
5. **Peace of mind** = optional evenings off / weekends off when the plan is working — not stuck waiting for reset mid-task.

---

## Two pools (never mix)

| Pool | Meter | Role |
|------|-------|------|
| **A SuperGrok weekly** | Settings → Usage **%** · Grok Build line | Primary interactive Build |
| **B API / Extra Credits** | $ balance | Hold until A empty (policy) |

---

## Formulas

```text
monthly_sub   = 30
weekly_sub    = 30 * 12 / 52 ≈ 6.92
daily_sub     = weekly_sub / 7 ≈ 0.99

# After enough log pairs (Δ% over known wall heavy hours S):
H_heavy ≈ S / (Δpct / 100)     # hours of heavy Build for 100% week
usd_per_heavy_hour = weekly_sub / H_heavy

# Live:
hours_used = H_heavy * pct_used / 100
hours_left = H_heavy * (100 - pct_used) / 100
```

**Placeholder until calibrated:** H_heavy = 8 h.

---

## Measurement protocol (this week)

| Step | Action |
|------|--------|
| 1 | Before heavy block: screenshot Usage (path in log) |
| 2 | Run **one intentional** strategic session (architecture, AIDE design, hard debug) — note wall start/end |
| 3 | After block: screenshot Usage again |
| 4 | Log: `date \| pct_before \| pct_after \| wall_minutes \| task_class \| notes` |
| 5 | Mid-week: recompute H_heavy from all Δ pairs |
| 6 | After Aug 7 reset: start fresh week with calibrated H_heavy |

**Task classes:** `strategic` · `implement` · `docs` · `thrash` (avoid thrash)

---

## Optimized workflow (post-calibration)

| Band | When | What |
|------|------|------|
| **Peak Build** | Early week / Reset+1 | Design decisions, multi-file agents, hard debug |
| **Implement** | Mid week | Scripts/UI with short Build bursts only |
| **Local-only** | Anytime | HTML, markdown, VMs, apt, LFCS drills |
| **Reserve 15–20%** | Always | Unplanned freezes / opportunities |
| **Empty / pre-reset** | Late week if burned | Pure local + document lessons; optional API only if blocked |

**Weekend off target:** If Mon–Fri uses planned heavy hours with reserve intact, weekend = reset recovery + local hobbies — not “waiting for usage.”

---

## AIDE_OS for basic Grok tier users

Document in designs and portfolio:

1. **When to open GrokBuild** vs local docs/scripts  
2. **Session brief template** (goal, state, done criteria) — one prepared session ≫ three thrash hours  
3. **USAGE-LOG habit** so learners see their own H_heavy  
4. **Lab-in-a-box** that works offline for drills when pool is empty  
5. **No permanent YOLO** — permission modes, allow-listed tools  

---

## Live snapshot (update from USAGE-LOG)

See [USAGE-LOG.md](./USAGE-LOG.md) for latest %. As of row 3 (01:33): **13%** Grok Build, reset **2026-08-07 23:58**.
