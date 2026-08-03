# AIDE_OS Learning Track — videos, reading, notifications, links, auto-docs

| Field | Value |
|-------|--------|
| **Updated** | 2026-08-02 (night close) |
| **Audience** | Basic SuperGrok tier · personal lab · **not** school SKU |
| **VM** | `AIDE_OS` — Ubuntu Core 26 · snapshot `post-console-conf` |
| **Brand** | Destroy The Kraken · HickMedia neon visual language |
| **Usage SoT** | `docs/ops/USAGE-LOG.md` · screenshots / screencasts |

---

## Mission

Build and document AIDE_OS so a **basic Grok-tier user** can learn without thrashing their weekly pool: intentional Build sessions, local drills when empty, clear “what to do next.”

**Tonight’s close:** Core VM console-conf done · long screenshare logged · read-aloud video script ready · evenings/weekends-off is the calibration *goal*, not yet proven.

---

## Network & display options (integrated into track)

| Option | Role in learning track | When | Risk |
|--------|------------------------|------|------|
| **A. Host-only NIC** (`vboxnet0` · `192.168.56.0/24`) | Stable host↔guest lab link for SSH, dashboards, auto-docs push | **Session 2 (next)** after snapshot | Low — no public exposure |
| **B. Tailscale into guest** | Same mesh as LabNET phones/tablets; “learn from couch” | Session 3 — **confirm ACL tags** first | Medium — need guest install + auth |
| **C. Samsung TV as NAD** | Network-attached display: lesson video, notifications board, kiosk reading | Session 4+ — Chromium/kiosk or cast to `.103` lab map | Low–med — TV is display only on LabNET |

**Recommended order:** A → B → C.  
**Not tonight:** no Tailscale install on guest without your go-ahead on which account/tags; TV is design-only until a calm session.

### Lesson hooks per option
- **Host-only:** “SSH from um690 without fighting NAT port-forwards.”
- **Tailscale:** “Your phone is a lab terminal; tags separate student vs director later.”
- **TV NAD:** “Second screen for lessons while hands stay on Core console / keyboard.”

---

## Track modules (progressive)

| # | Module | Videos | Reading | Notifications | Links | Auto-docs |
|---|--------|--------|---------|---------------|-------|-----------|
| **0** | Lab hygiene & usage calibration | This night’s screenshare + read-aloud | `USAGE-LOG.md`, `USAGE-CALIBRATION.md` | Weekly reset reminder (Aug 7 23:58) | SuperGrok Settings → Usage | Log row after each heavy block |
| **1** | Ubuntu Core appliance literacy | First-boot stills / short cut of Core console-conf | `AIDE-OS-CORE-VM.md`, Canonical Core docs | “Press enter to configure” milestone | [Inside Ubuntu Core](https://documentation.ubuntu.com/core/explanation/core-elements/inside-ubuntu-core/) | Snapshot checklist |
| **2** | Host-only networking | Screen: attach NIC2, ping, SSH | This doc § network | “Host-only up” | VirtualBox host-only | `scripts/vbox/hostonly-net.sh` (planned) |
| **3** | Tailscale seat (optional) | Join guest, MagicDNS | LABNET redacted patterns | Device online | Tailscale admin (private) | Peer list redacted export |
| **4** | NAD / TV learning wall | Timed YouTube + guidance on Samsung **`.103`** (cast/kiosk, **no SSH**) | aios-ed schedule + `lesson-today.py` · [learning-wall design](../design/2026-08-02-learning-wall-tv-nad.md) | 07:00 lesson notify (cron later) | YouTube from `lesson-resources.json` | Session summary MD |
| **5** | Hybrid AI discipline | GrokBuild brief vs local | Design doc Key Decisions K23–K25 | Pool % threshold alerts (manual first) | xAI docs | Session brief template |
| **6** | Classic desktop lab-in-a-box | Parallel track (PR3 classic) | `2026-08-02-aide-lab-virtualbox.md` | golden-base ready | Portfolio projects | PR checklist |

---

## Automated documentation (minimal viable)

| Trigger | Artifact |
|---------|----------|
| After heavy GrokBuild | USAGE-LOG row + optional screenshot path |
| After VM milestone | Snapshot name + date in `AIDE-OS-CORE-VM.md` |
| After learning session | `docs/labs/sessions/YYYY-MM-DD-session.md` (template below) |
| Nightly (optional later) | `scripts/ops/session-close.sh` → append USAGE + git status (no secrets) |

### Session note template

```markdown
# Session YYYY-MM-DD
- Goal:
- Modules touched:
- Usage % before/after:
- VM / network changes:
- Learned:
- Next:
```

Path: `~/AIDE_OS/docs/labs/sessions/`

---

## Notifications (phase 1 = human + calendar)

| Event | Channel |
|-------|---------|
| Weekly SuperGrok reset | Calendar: **Fri Aug 7, 2026 23:58** (then recurring from UI) |
| “Stop Build — protect reserve” | Manual: if % > 80 mid-week |
| Lesson complete | Optional: desktop notify / phone later |
| TV NAD | Future: full-screen lesson end card |

Phase 2 (later): small host timer or GNOME notification script — not required for MVP.

---

## Video library (this lab)

| File | Role |
|------|------|
| `Videos/Screencasts/Screencast From 2026-08-02 01-40-45.webm` | **Night close master** — console-conf + build session |
| `…01-01-01.webm` | Usage UI calibration |
| Portfolio stills | Hero / skills pages |
| `docs/labs/VIDEO-SCRIPT-2026-08-02-night-close.md` | **Read-aloud script + outro** |

## Social / content pipeline

Screen while GrokBuild → edit + script with Grok → **morning prompt** for VO + post.

- Pipeline: `docs/ops/SOCIAL-CONTENT-PIPELINE.md`  
- Log: `docs/ops/CONTENT-LOG.md`  
- Morning paste: `docs/ops/MORNING-CONTENT-PROMPT.md`  

Formats: night log · lab podcast (webcam + field cam) · focus desk with credited DJ energy (e.g. LIKA sessions — rights/credit).

---

## Basic Grok-tier user promise

1. Open **session brief** before Build.  
2. Prefer **local** VM + docs when pool is tight.  
3. Log **%** so H_heavy becomes real.  
4. **Evenings/weekends off** when weekday plan holds — that is the product of calibration, not luck.  

---

## Next session (not tonight)

1. Attach **host-only** to `AIDE_OS` (VM off → NIC2 → start).  
2. SSH from um690; document IP.  
3. Optional: Tailscale (ask confirm).  
4. TV NAD spike (after 1–3):  
   - `python3 ~/AIDE_OS/scripts/learning/lesson-today.py`  
   - Cast or open listed YouTube on Samsung **192.168.20.103**  
   - Design: `docs/design/2026-08-02-learning-wall-tv-nad.md`  
   - Precursors: `/mnt/systems_admin/archive/AIDE_OS-precursors/aios-ed/`  

### Voice / headphones (research)

| Path | Platform |
|------|----------|
| Superwhisper | **Not Ubuntu** — phone/iOS/Mac/Win + Grok **Web** |
| Grok Build native voice | Host Ghostty (`/doctor` Voice) |
| Handy (open STT) | Ubuntu .deb — paste into focused field |
| Music (e.g. LIKA) | Phone BT · dual-connect Stealth |
