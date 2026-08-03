# Design: Samsung TV as Grok-orchestrated learning wall (NAD)

| Field | Value |
|-------|--------|
| **Date** | 2026-08-02 |
| **Status** | Direction from deep-research + LabNET facts |
| **Display** | LabNET Samsung TV · **192.168.20.103** · MAC `20:15:de:c6:fe:f6` · **no SSH** |
| **SoT research** | deep-research workflow (systems_admin + AIDE_OS) |
| **Brand** | Destroy The Kraken / AIDE_OS · **not** school SKU |

---

## One-sentence product

A **network-attached display** (your Samsung TV) plays **timed lessons** (YouTube + local guidance) and shows **notifications** while Grok collaborates with you on um690 — orchestration is **hub-style** (host/automation → Cast/SmartThings/kiosk URL), never SSH into the TV.

---

## What already exists (reuse, don’t rebuild)

| Asset | Location | Role |
|-------|----------|------|
| **45-day LFCS schedule** | `/mnt/systems_admin/archive/AIDE_OS-precursors/aios-ed/schedule/daily-schedule.json` | Day · title · domains · duration · `notification_time` **07:00** |
| **YouTube lesson map** | `…/aios-ed/schedule/lesson-resources.json` | Project-keyed playlists / watch URLs (e.g. Learn Linux TV) |
| **Daily cron + guidance** | `…/aios-ed/automation/` · `install-daily-cron.sh` · `lfcs-daily-guidance.sh` | 07:00 notices · Sunday cluster scan · portal refresh |
| **Study protocol** | `…/aios-ed/guides/DAILY_STUDY_PROTOCOL.md` | 45–90 min sessions · journal · review weeks |
| **Learning track module 4** | `docs/labs/LEARNING-TRACK-AIDE-OS.md` | NAD / TV wall already listed |
| **UI direction** | Electron/Chromium education UI design | One PWA/kiosk web app |
| **Orchestration pattern** | `aidectl` design — trigger → condition → response | Display, notify, lesson mode |

**Caution:** Old aios-ed inventory used different subnets / node roles — **do not** treat historical `.103` storage roles as today’s TV. Current LabNET: **TV = `.103` display only.**

---

## Architecture (no SSH to TV)

```text
um690 (Grok director + cron/timer)
        │
        ├─ lesson schedule (aios-ed JSON → refreshed AIDE_OS copy)
        ├─ notify: desktop / phone / optional TV full-screen card
        └─ actuators (pick what TV supports):
              • Google Cast → YouTube / media on TV
              • SmartThings / HA media_player (if enrolled)
              • Chromium kiosk URL on a mini PC/stick → HDMI to TV
              • Manual Smart View second-screen (fallback)
```

**Grok’s job:** pick today’s module, confirm with you, start/stop lesson window, log session, update USAGE if Build was used.  
**Human’s job:** approve, sit the 45–90 min block, journal one line.

---

## Phased delivery

| Phase | Deliverable | Depends on |
|-------|-------------|------------|
| **0** | Copy/symlink aios-ed schedule + resources into `~/AIDE_OS/brain/bootcamp/lfcs/schedule/` (read-only import) | Disk only |
| **1** | `lesson-today` CLI: print day N title + YouTube URL + duration | Phase 0 |
| **2** | 07:00 notify (cron or GNOME) → `latest-daily-guidance.txt` | Phase 1 |
| **3** | Cast or open URL on TV (probe Cast/SmartThings once) | Phase 2 + TV capability check |
| **4** | Grok prompt pack: “start lesson / pause / log complete” | Phase 3 |
| **5** | Full kiosk PWA on wall | Education UI track |

**Order with network work:** host-only Core SSH → optional Tailscale → **then** TV spike (as already planned).

---

## Hands-free / headphones policy (research conclusion)

| Tool | Ubuntu host? | Use |
|------|--------------|-----|
| **Superwhisper** | **No** (macOS / Windows / iOS only) | Phone/tablet client + Grok **Web** |
| **Grok Build native voice** | Yes (mic / `/doctor` Voice) | Dictation into Build TUI |
| **Handy** (open STT) | Yes (.deb / AppImage) | System-wide paste into focused field |
| **Music (LIKA etc.)** | Phone BT profile | Dual-connect Stealth: music ≠ mic |
| **Grok audio** | PC BT profile | Podcast / collab path |

Do **not** leave noisy `/loop` monitors running if headphones-on focus must stay unbroken.

---

## Program pack mapping

| Programs module | Content |
|-----------------|---------|
| **AIA B4** Displays / NAD | This design |
| **AIA B5** Voice lab | Superwhisper phone + Handy/Grok voice on PC |
| **SHP A0** Hygiene | Daily schedule + journal + USAGE |
| **Session harvest** | aios-ed precursors as curriculum gold |

---

## Success criteria (first useful spike)

1. `lesson-today` prints correct day + one YouTube link from imported JSON  
2. 07:00 (or manual) notice appears on um690  
3. One lesson played on TV by **any** reliable path (even manual Cast after Grok tells you the URL)  
4. Session note written under `docs/labs/sessions/`  

---

## Explicit non-goals (now)

- SSH or root on Samsung TV  
- Auto-YouTube without confirming TV Cast/SmartThings capability  
- School-SKU packaging of aios-ed  
- Superwhisper install on Ubuntu  

---

## Next implementation PR (small)

1. Import aios-ed `schedule/*.json` → `~/AIDE_OS/brain/bootcamp/lfcs/schedule/` (with README pointer to archive)  
2. `scripts/learning/lesson-today.py`  
3. Update LEARNING-TRACK module 4 with this architecture  
4. Optional: probe `catt` / Cast discovery on LAN (ask before installing)  
