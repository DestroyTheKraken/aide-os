# SuperGrok / GrokBuild USAGE-LOG

| Field | Value |
|-------|--------|
| **Plan scaffold** | SuperGrok ~$30/mo → ~$6.92/week · ~$0.99/day |
| **H_heavy placeholder** | 8 heavy GrokBuild hours ≈ 100% week (recalibrate mid-week after next heavy session) |
| **Reset (live)** | **August 7, 2026 at 11:58 PM** |
| **Pool B API** | Reserve until Pool A empty ($61.50 console earlier; Extra Credits $0.00 on Usage pane) |
| **Policy** | No Auto Top-Up for routine · local-first · ≥20% weekly reserve |

**Do not commit secret screenshots** — store paths only. Private stills may live under `~/Pictures/Screenshots/`.

---

## Log rows

| date (local) | pct_used | reset_eta | wall_heavy_hours | notes |
|--------------|----------|-----------|------------------|-------|
| 2026-08-02 ~01:01 | **9%** | 2026-08-07 23:58 | (session ongoing) | Row 0 — video `Videos/Screencasts/Screencast From 2026-08-02 01-01-01.webm`; Grok Build 9%; stills `/tmp/grok-1000/usage-stills/` |
| 2026-08-02 plan proposal | **10%** | 2026-08-07 23:58 | — | Row 1 — “2 minutes into 10%” = glance lag, **not** 2 min = 10% burn |
| 2026-08-02 01:27 | **12%** | 2026-08-07 23:58 | design/portfolio session | Row 2 — `Screenshot From 2026-08-02 01-27-03.png`; Grok Build 12% |
| 2026-08-02 01:33 | **13%** | 2026-08-07 23:58 | portfolio + strategy | Row 3 — `Screenshot From 2026-08-02 01-33-26.png`; Grok Build 13% |
| 2026-08-02 01:37 | **13%** | 2026-08-07 23:58 | start AIDE_OS Core VM | Row 4 — `01-37-00.png`; still 13% |
| 2026-08-02 01:38 | **13%** | 2026-08-07 23:58 | Core image download + VM create | Row 5 — `01-38-40.png`; 13% (local VBox/curl) |
| 2026-08-02 01:40–01:57 | ~13% (still 01:38) | 2026-08-07 23:58 | console-conf + night close | Row 6 — screencast `01-40-45.webm`; snapshot post-console-conf; vboxnet0 created |
| 2026-08-02 02:21 | **15%** | 2026-08-07 23:58 | night questions + Core SSH banner | Row 7 — `02-21-55.png`; 15% |
| 2026-08-02 02:25 | **16%** | 2026-08-07 23:58 | session history packaging talk | Row 8 — `02-25-19.png` |
| 2026-08-02 04:40 | **23%** | 2026-08-07 23:58 | measurement | Row 9 — `04-40-10.png`; 23% |
| 2026-08-02 05:11 | **26%** | 2026-08-07 23:58 | Obsidian theme + keep working | Row 10 — `05-11-53.png`; Grok Build 26% |
| 2026-08-02 ~05:57–06:08 | **29%→30%** | 2026-08-07 23:58 | interface fail + confirm | Rows 11–12 — `usage-samples.csv`; manual |
| **2026-08-02 14:03** | **35%** | **2026-08-07 23:58** | Controlled Chaos portfolio redesign (DTK) | **Row 13** — user report; session `~/.grok/sessions/…019fc40e…` · DESIGN.md + theme |

### Deltas
| Interval | Δ% | Approx heavy-eq @ H=8 |
|----------|-----|------------------------|
| 9% → 10% | +1 pp | ~0.08 h |
| 10% → 12% | +2 pp | ~0.16 h |
| 12% → **13%** | **+1 pp** | **~0.08 h** |
| 9% → 13% (~01:01–01:33 wall) | **+4 pp** | **~0.32 h** heavy-eq |
| 26% → **35%** (~05:11–14:03 wall) | **+9 pp** | **~0.72 h** heavy-eq |
| 9% → **35%** (~01:01–14:03 wall) | **+26 pp** | **~2.08 h** · ~13 h wall · ~2 pp/h avg |

**Calibration note:** Early night heavy multi-agent design burned fast (~4 pp/h). Day stretch 06:08→14:03 was only **+5 pp** over ~8 h wall (mixed / lower intensity). Placeholder **H_heavy = 8 h** for capacity tables until mid-week pairs.

See also: [USAGE-CALIBRATION.md](./USAGE-CALIBRATION.md) (burn-to-measure → optimize for weekend-off).

---

## Live capacity (latest **35%** @ 14:03 · H_heavy placeholder **8**)

| Metric | Value |
|--------|--------|
| **Used** | **35%** · ~**2.80 h** heavy-eq · **~$2.42** of weekly planning $6.92 |
| **Left** | **65%** · ~**5.20 h** · **~$4.50** |
| **Plan more (20% reserve)** | **≤ ~3.6 h** heavy before reset |
| **Per day (~5.4 d to Aug 7 23:58)** | **≤ ~0.67 h/day** heavy Build |

### Machine tracker (recreate the bar)

| File | Role |
|------|------|
| `docs/ops/usage-samples.csv` | Timestamped % samples from screenshots |
| `docs/ops/usage-state.json` | Last computed capacity |
| `scripts/ops/usage-tracker.py` | Report + append |

```bash
usage-tracker                 # full report
usage-tracker --append 28     # after next Usage screenshot shows 28%
```

### What is NOT the weekly bar
- TUI **context** e.g. `321K/500K` = this session’s context window  
- **xAI API $** = separate prepaid pool  
- **X free Grok** e.g. 15 questions / 20h = separate  

### Night-of sample (quantified)
- Window **01:01→05:11** · **9%→26%** · **+17 pp** in **~4.2 h** wall  
- Avg **~4.1 pp per wall-hour** when mixed; local VBox alone **0 pp**  
- Overnight multi-agent design is expensive; Obsidian/LFCS should be daytime local  

### Day sample (portfolio redesign)
- Window **05:11→14:03** · **26%→35%** · **+9 pp** in **~8.9 h** wall  
- Includes Controlled Chaos DTK redesign (DESIGN.md, plan, theme.css start)  
- Session context: `~/.grok/sessions/%2Fhome%2Fkraken/019fc40e-f032-7260-b6de-e04827cf1c86/`  
- Related notes: `~/Documents/notes/` (user said Desktop/notes — Desktop empty; notes live under Documents)

---

## Cadence reminder
1. **LFCS / Obsidian / TV site** = local (bar ~flat).  
2. **GrokBuild strategic** ≤ **~40 min/day** until reset (**0.67 h** @ 35%).  
3. After each Usage screenshot: `usage-tracker --append NN`.  
