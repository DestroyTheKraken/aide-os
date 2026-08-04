# Product evolution log — AIDE_OS Home / Work · HickMedia archive · SmartHome Aide Hub

| Field | Value |
|-------|--------|
| **Date** | 2026-08-04 |
| **Director** | Josh |
| **Logged by** | Grok (kraken / um690) |
| **Status** | **Canon naming direction** — code trees may lag; names lead docs |
| **Not** | School / district SKU · unfinished Edbuntu sales pitch |

---

## Decision (one paragraph)

**AIDE_OS Work** and **AIDE_OS Home** are the adult product names for the station and ops surfaces. **AIDE_OS Home is HickMedia** (living-room media + couch console + coffee-break cockpit on fam-media / Samsung). **HickMedia** as a brand may be **archived and annotated** so corporate and lab documents remember how the idea evolved while new work continues under AIDE_OS. The goal is not perfect code — it is a **fluid framework** for micro-sprints: develop, deploy, test, and debug in real time, pivot without “failure,” and creatively repurpose hardware and software. Longer arc: **SmartHome Aide Hub** — aide you in configuring an entire smart home, tested on LabNET first.

---

## Naming map (current)

| Name | Role | Lab surface |
|------|------|-------------|
| **AIDE_OS (platform)** | LabNET + Grok + cluster + NAS — life/work ops substrate | um690, k3s, shared memory |
| **AIDE_OS Work** | Work cockpit: pipeline, jobs, servers, Pomodoro, Command Center, VTS/build focus | um690 Command Center · fam-media Work mode / board |
| **AIDE_OS Home** | Home station: media, play, stream, coffee-break aide — **was / is HickMedia** | fam-media · Samsung display · Bridge / aide-os.html |
| **HickMedia** | Historical product name + repo path `~/HickMedia` — **archive-annotate**, do not erase history | Same hosts; docs point here for lineage |
| **SmartHome Aide Hub** | Future / parallel product frame: configure whole smart home with GrokAIDE | Built on platform + Home station patterns |
| **AIDE education (Edbuntu)** | **Still gated** school-style packaging | Not Home/Work station product |

**Kid install rename (optional):** “Cockpit” / “Control Center” — never school branding.

**Tagline (Home coffee break):** *Enjoy your coffee break with GrokAIDE*

### Game-station monitoring cockpit (2026-08-04 refinement)

Grok Web refinement pass locked the **Home station UX category**:

> AIDE_OS is the couch-reachable command surface for a private home lab—gamepad-first, glanceable when idle, deep only on demand, and deliberately frugal on the compositor.

- Idle: header + dock; one flyout at a time; Board+ overlay; Media via workspace flip only
- Performance shell on fam-media (static sky, no always-on blur)
- Canon design: `docs/design/2026-08-04-grok-web-refinement-pass-game-station-cockpit.md`
- Station SoT: `~/HickMedia/docs/AIDE-OS-COCKPIT.md` · runbooks `RUNBOOKS.md`

---

## Why archive HickMedia (not delete)

| Keep | Why |
|------|-----|
| Repo `~/HickMedia` | Real code, installers, Core lessons, audio, Frame/WPE |
| Docs under `docs/` | Evolution trail for corporate memory |
| Product name in old commits / push schedule | Honest history |
| Annotation layer (this file + `HickMedia/docs/ARCHIVE-AND-LINEAGE.md`) | New readers see: HickMedia → AIDE_OS Home |

Archiving means: **annotate, stop expanding the brand**, expand **AIDE_OS Home/Work** language in new design docs. Code may still live in `~/HickMedia` until a deliberate tree move.

---

## Operating philosophy (anti-waste)

1. **Fluid, not fragile** — if a surface is wrong, pivot; repurpose the box (TV station, media hub, work board).
2. **Micro-sprints** — ship a slice (timer, status, pad bridge, dashboard tile), test on real glass, log, next slice.
3. **Framework over perfection** — imperfect code that runs on LabNET is a scaffold for deeper work.
4. **Same station, many modes** — Working · Learning · Gaming · Streaming · Relaxing (Command Center modes).
5. **Obsidian = depth; Command Center / cockpit = locked ops board** — do not duplicate novels on the wall.
6. **No school-SKU bleed** — Home/Work and SmartHome Aide Hub are personal/sovereign/home products, not district Edbuntu.

Failing is only freezing on a dead name or a dead path. **Repurpose is success.**

---

## SmartHome Aide Hub (north star, not launch checklist)

| Idea | Notes |
|------|--------|
| Aide for **whole-home** config | Networks, media, displays, later lights/HA-style edges — on gear you own |
| Real-time loop | Deploy on fam-media / um690 → see on Samsung → fix in micro sprint |
| Reuse | AIDE_OS Home station + Command Center + dual-channel backup habits |
| Monetization later | VTS / DTK language only when ready; no school pitch |

---

## Corporate document trail (where this is logged)

| Document | Purpose |
|----------|---------|
| **This file** | Evolution SoT entry for 2026-08-04 |
| `AIDE_OS/docs/PLATFORM.md` | Platform layer names updated |
| `AIDE_OS/docs/PRODUCT-SCOPE-AND-EDBUNTU.md` | Scope table updated |
| `HickMedia/docs/ARCHIVE-AND-LINEAGE.md` | Repo-level archive annotation |
| `HickMedia/docs/PRODUCT-BOUNDARIES.md` | Boundaries → Home/Work language |
| `HickMedia/docs/AIDE-OS-COCKPIT.md` | Station implementation (already) |
| `www/destroythekraken/docs/COMMAND-CENTER.md` | Public/portfolio ops board format |
| Shared memory (if mirrored) | Short pointer for orchestrator |

---

## Immediate lab truth (do not rewrite history as “already renamed”)

| Reality | Note |
|---------|------|
| Path still `~/HickMedia` | Expected until explicit migrate |
| Kiosk still WPE + `aide-os.html` | AIDE_OS Home surface live |
| Website Console = Command Center | AIDE_OS Work-adjacent board |
| School SKU | Still gated |

---

## Success criteria for this log

- [x] Home = HickMedia lineage named AIDE_OS Home
- [x] Work named AIDE_OS Work
- [x] HickMedia archive-annotate policy recorded
- [x] SmartHome Aide Hub recorded as direction
- [x] Micro-sprint / framework philosophy recorded
- [x] No school-SKU confusion introduced

**Next when ready (not automatic):** rename public copy only after portfolio language is deliberate; optional repo rename; HA/smart-home first vertical in a later design doc.
