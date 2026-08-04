# Grok Web refinement pass — AIDE_OS as game-station monitoring cockpit

| Field | Value |
|-------|--------|
| **Date** | 2026-08-04 |
| **Source** | Grok Web research (integrated from `~/.grok/docs/GROK_WEB_RESEARCH.md`) |
| **Status** | **Canon product + design north star** for fam-media AIDE_OS Home |
| **Implements into** | `HickMedia/docs/AIDE-OS-COCKPIT.md`, `STATION-CSS.md`, `RUNBOOKS.md`, `STATION-LAYOUT.md`, `BUTTON-MAP.md` |
| **Prior** | Lag mitigations validation · performance shell (static sky, no always-on blur, idle+flyouts) |
| **Not** | School SKU · FPS claims without measurement |

---

## 1. Executive summary

Refined **AIDE_OS** is a **game-station monitoring cockpit**: a living-room TV + gamepad hybrid between Steam Deck / console HUD and a calm ops wallboard.

It is an adult “coffee-break” station (focus timer, jobs/pipeline board, station health, Bridge overlay) with an explicit **Media workspace flip**—not a school product, not a dense multi-column dashboard, and not a permanent glassmorphic animation surface.

On **Haswell + WPE** the north star is **one primary focus surface + progressive disclosure + static/low-motion ambient**. Hierarchy comes from solid layers, type scale, borders, and elevation rather than always-on blur.

Idle collapses to **header + dock**; Timer / Work / Status appear as **one flyout at a time**; Board+ is an **overlay**. Media ↔ AIDE_OS are explicit workspaces.

The codebase stays a small static (or lightly built) multi-surface shell with clear ownership so a solo operator + AI can deploy, smoke-test, rebind the 8BitDo Pro 2 via uinput, and recover after power loss without clever one-offs.

Performance rules are hard: no continuous full-screen particles or `backdrop-filter` as default; **measure before claiming wins**.

### North-star sentence

> **AIDE_OS is the couch-reachable command surface for a private home lab—gamepad-first, glanceable when idle, deep only on demand, and deliberately frugal on the compositor.**

---

## 2. Validated patterns

| Pattern | Source (primary / strong) | Why it fits TV + gamepad + monitoring | Risk on WPE / Haswell |
|---------|---------------------------|---------------------------------------|-----------------------|
| 10-foot UI: large type, high contrast, large focus targets, safe zone | Microsoft Designing for TV / Xbox; Amazon Fire TV; console guidelines | Living-room distance + D-pad | Low if density controlled; high if multi-column |
| Single focused element + clear focus ring / scale | TV / Fire TV / Xbox focus rules | Sequential gamepad nav | Low |
| A = Accept, B = Cancel, D-pad directional | Xbox / Fire TV / Steam Input | Matches 8BitDo Pro 2 via key-bridge | Low (current model) |
| Progressive disclosure + one expensive surface | NN/g Progressive Disclosure; lab validation | Timer / jobs / status / Bridge on demand | Low–med |
| Explicit workspaces (Media ↔ AIDE_OS) | macOS Spaces; FancyZones / niri; Steam sections | Clear model without dual chrome | Low |
| Solid surfaces + elevation / borders; acrylic only transient; smoke dim | Fluent 2 Material | Hierarchy without continuous blur | Low when solid default |
| Calm status hierarchy (overall → component) | Status-page / Uptime Kuma clarity | Glanceable health | Low |
| Glanceable cards / sections (HA-style) | Home Assistant wall panels | Coffee-break “what’s next” | Med if too many live cards |
| Prefer `transform` / `opacity` for motion | Web animation + WebKit/WPE guidance | Avoid software-path thrash | High if filters/starfields remain |
| Roving tabindex / spatial nav via key events | a11y + spatial-nav patterns | Reliable without Gamepad API | Low if simple |

No FPS numbers invented. Lab application of some rows is **inferred** until measured on fam-media.

---

## 3. Target UX blueprint

**Idle (default)**
Thin header (clock / connection / overall health) · bottom dock · static ambient · no open flyouts.

**Active — one flyout at a time**
Timer · Work/jobs · Status/health. B closes. Only one open.

**Overlay**
Bridge / Board+ with smoke dim. Clear exit (B / F1).

**Workspace flip**
Media ↔ AIDE_OS via pad Home/M. Media owns Watch/Play/Listen/Apps. AIDE_OS owns timer + jobs + status. Flip replaces primary surface.

**Focus**
One high-contrast ring · D-pad moves · A activates · B backs out · progressive disclosure inside a surface.

---

## 4. Visual performance ruleset

See **SoT checklist** in `~/HickMedia/docs/STATION-CSS.md` (Do / Don’t). Hard defaults match the performance shell already on fam-media.

---

## 5. Codebase target layout

See `~/HickMedia/docs/STATION-LAYOUT.md`. Pure static preferred; light Vite/esbuild only if multi-surface tokens become painful.

**Ownership**
Shell/chrome/tokens shared · surfaces content-only · gamepad bridge sole js0 owner · JSON snapshots + failure UI · deploy scripts versioned and reversible.

---

## 6. Runbooks

Executable outlines: `~/HickMedia/docs/RUNBOOKS.md` (RB-01 … RB-06).

---

## 7. Prioritized backlog (next ~2 weeks)

### P0 — Glitch-debug + baseline measurement
- Reproduce UI glitches on fam-media; capture WebProcess CPU (+ frame timing if available).
- Confirm single pad reader; finish rebind.
- **Test:** idle 5 min → each flyout → workspace flip → Bridge; record CPU before/after.

### P1 — Design polish inside performance envelope
- Tokens (type scale, focus ring, solid elevation); 10-ft readability.
- One-flyout discipline + progressive disclosure for long job lists.
- Static ambient only; motion opt-in behind measured flag.
- **Test:** D-pad path coverage for all primary actions at TV distance.

### P1 — Structure
- Move toward target layout; extract `focus.js` + `workspace.js`.
- Failure UI for missing JSON.
- **Test:** clean deploy; break JSON intentionally; graceful degrade.

### P2 — Ops
- Full runbooks as checklists; `deploy.sh` + `smoke.sh` + rollback.
- `BUTTON-MAP.md` locked after rebind.
- **Test:** power-cycle recovery; cache-bust; pad rebind under load.

---

## 8. Open questions (measure on fam-media — do not claim wins early)

1. WebProcess CPU: static shell vs prior animated glass (before/after numbers).
2. Accelerated compositing vs software path on HD 4600.
3. Input-to-focus latency through uinput key-bridge.
4. Real 10-ft legibility of type + focus ring on Samsung.
5. Cost of any remaining subtle motion / small-area glass.
6. Whether a light build step improves maintainability without hurting Core deploys.
7. Operator preference: pure dark vs static nebula once performance is settled.

---

## 9. Search terms (re-runnable)

`10-foot UI design guidelines TV gamepad` · `Steam Big Picture OR Steam Deck UI navigation` · `WPE WebKit CSS animation performance backdrop-filter` · `Ubuntu Frame wpe-webkit-mir-kiosk` · `Fluent 2 material solid mica acrylic` · `Home Assistant dashboard wall panel kiosk` · `status page design principles Uptime Kuma` · `roving tabindex spatial navigation gamepad` · `progressive disclosure Nielsen` · `Microsoft Designing for TV UWP Xbox`

### Key source classes
Microsoft Designing for TV / Xbox · Amazon Fire TV UX · Fluent 2 Material · NN/g Progressive Disclosure · Ubuntu Frame docs · WebKit/WPE animation guidance · Steam Input / Deck patterns · HA dashboard practice · status-page clarity · roving tabindex / spatial nav

---

## Related lab docs

| Path | Role |
|------|------|
| `HickMedia/docs/AIDE-OS-COCKPIT.md` | Cockpit SoT + UX blueprint |
| `HickMedia/docs/STATION-CSS.md` | Perf ruleset + CSS architecture |
| `HickMedia/docs/STATION-LAYOUT.md` | Target codebase layout |
| `HickMedia/docs/RUNBOOKS.md` | RB-01…06 |
| `HickMedia/docs/BUTTON-MAP.md` | Pad map SoT (provisional until rebind) |
| `HickMedia/docs/8BITDO-GAMEPAD.md` | Hardware + bridge service detail |
| Prior design | `2026-08-04-grok-web-validation-station-lag-mitigations.md` |
