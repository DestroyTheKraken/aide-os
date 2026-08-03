# Design: GrokAide Education UI — Electron / Chromium stack

| Field | Value |
|-------|--------|
| **Date** | 2026-07-27 |
| **Status** | Direction locked (MVP shell not built) |
| **Seat** | `~/AIDE_OS` (education) · not HickMedia console merge |
| **Related** | `idee/ghostty/` · `brain/` · product scope Edbuntu |

## Summary

GrokAide’s **learning UI/UX** targets a **Chromium-family (Electron + web)** stack so the same surfaces can run on:

- um690 GNOME (desktop Electron / Chromium)
- touch tablets (Samsung browser / PWA / Android WebView)
- remote seats over **Tailscale** (HTTPS to local services)
- Starlink-backed travel / home WAN without redesigning the app

**Ghostty is not Electron.** It remains the **operator host for Grok Build TUI** (native GPU terminal). Product theming is shared so the terminal *feels* like the same brand as HickMedia neon + Obsidian purple, without merging gaming console product scope.

## Stack split (honest, non-phony)

| Surface | Runtime | Why |
|---------|---------|-----|
| **Grok Build CLI** (`grok`) | Native TUI in **Ghostty** | Full terminal protocols, speed, `/doctor` fidelity |
| **Obsidian Second Brain** | **Electron** (already) | Notes, Markdown, OT-style plans, vault graph |
| **GrokAide Education shell** (future) | **Electron** and/or **pure Chromium PWA** | Pathways, quizzes, labs UI, credential trackers |
| **Lab helpers / remote dashboards** | Chromium over **Tailnet** | Deploy once, open on any device with HTTPS |
| **Voice / speech** | Browser + OS APIs (Samsung + headset) | Chromium media capture is industry-standard |

**“Purely Electron” means:** learner-facing apps and education chrome are web tech (Electron when desktop packaging helps; Chromium/PWA when touch/IoT/remote wins). It does **not** mean rewriting Grok’s TUI in Electron.

## Theme packs (shared brand language)

| Pack | Role | Location |
|------|------|----------|
| **hickmedia-dracula-neon-obsidian** | Default operator / work | Ghostty + future Electron CSS tokens |
| **nes-markdown-learn** | Markdown + UI/UX learning contrast | Ghostty; map same tokens into Electron later |

HickMedia source tokens (`~/HickMedia/docs/THEME.md` + boot splash):

- Deep bg `#05030a` / `#0b0a10`
- Cyan `#00f0ff` · Mag `#ff2bd6` · Purple `#c77dff`
- Soft text `#c0caf5` · bright `#eef2ff`
- Tokyo Night secondary purple `#bb9af7`

**Product boundary:** visual kinship with HickMedia is OK; **gaming console / RetroArch / Frame** remain HickMedia-only.

## Education pathways (UI product scope)

Electron/Chromium shell should eventually host (not day-1 all at once):

1. Cloud infra basics  
2. Linux / LFCS scaffold  
3. Web development  
4. UI/UX craft (including Markdown as a design skill)  
5. Exam & credentialling pathways  
6. AI tutor surfaces (Spark + Grok Build handoff)  
7. X (Twitter) ecosystem literacy where relevant to public portfolio / DevRel  
8. Connectivity reality: **Starlink + Tailscale** as first-class deployment assumptions  

## Obsidian / OT workflow

- Plans and session notes stay in **`~/AIDE_OS/brain`** (Markdown, linkable, OT-friendly).  
- Education shell should **open or embed** vault paths / exports rather than replace the vault.  
- Touch: prefer large targets, short sessions, voice dictation where Grok already supports mic routes.

## Hardware / IoT notes (Chromium-dominated)

Industry reality: most “smart display” and kiosk UIs are **Chromium or WebView**.

Practical GrokAide targets:

| Class | Examples | Delivery |
|-------|----------|----------|
| Workstation | um690 + Ghostty + Electron Obsidian | Local |
| Tablet | Samsung Galaxy Tab / phone browser | HTTPS PWA over Tailnet |
| Audio | Turtle Beach + system mic | Browser permission + Grok voice when available |
| IoT / wall | Chromium kiosk or Android WebView panel | Same web app, reduced chrome |

Prefer **one web app**, three shells (desktop Electron, mobile PWA, kiosk Chromium) over three rewrites.

## Non-goals (this design)

- Merging AIDE_OS into HickMedia gaming product  
- Permanent YOLO / always-approve as product default  
- Replacing Grok TUI with a fake web terminal that drops keyboard protocols  
- Building the full Electron app before Ghostty + vault + LFCS stay green  

## Immediate implementation (done / next)

| Item | Status |
|------|--------|
| Ghostty + HickMedia neon theme | `idee/ghostty/` apply script |
| NES Markdown learn theme | same |
| IDEE prefers Ghostty | `run-in-terminal.sh` |
| Electron education shell MVP | **Not started** — design only |
| Samsung / voice tactile device prototype | Future spike |

## Success criteria (direction)

1. Open Ghostty → colors match brand (neon cyan/mag/purple on deep black).  
2. Switch to NES theme for Markdown study without reinstalling.  
3. `grok` `/doctor` reports healthy terminal in Ghostty.  
4. Future Electron app reuses the **same color tokens** file (single SoT).  
5. Any education view that matters on tablet is reachable via Chromium + Tailnet.

## Apply now

```bash
bash ~/AIDE_OS/idee/ghostty/apply-ghostty.sh
# optional full desktop profile:
bash ~/AIDE_OS/idee/apply-gnome-idee.sh
bash ~/AIDE_OS/idee/verify-idee.sh
```
