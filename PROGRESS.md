# Historical progress report (June 2026)

This file describes an older tablet-and-Docker layout and outdated addresses. **It is not how you start today.** Use [START.md](./START.md) and `aide-day`.

# AIOS Education IDE — Progress Report

**Repo:** `aios-ed` (local) → [DestroyTheKraken/aios-os](https://github.com/DestroyTheKraken/aios-os.git)  
**Updated:** June 16, 2026  
**Exam target:** LFCS Dec 2026 / Jan 2027  
**Control plane:** um690 `REDACTED`

---

## Repository consolidation

This repo unifies what was previously split across:

| Former path | Now in `aios-ed` |
|-------------|------------------|
| `/home/kraken/Projects/aios-ed` | Runnable stack (root: `portal/`, `docker/`, `automation/`, …) |
| `/home/kraken/Projects/AIOS` | Product/design: `AGENTS.md`, `.grok/rules/`, `.grok/docs/user-attachments/` |

**Runtime on um690** still uses `DEPLOY_DIR=/opt/lfcs/secure-browser-forge`. After clone, set:

```bash
export LFCS_ROOT=/home/kraken/Projects/aios-ed   # or your clone path
```

---

## Phase status (design doc PR 1–19)

| Stage | PRs | Status | Notes |
|-------|-----|--------|-------|
| **1 — Knowledge corpus** | 1–4 | **Done** | `ara_tutor/` scaffold + weak-area + linux/networking refs |
| **2 — Schedule + context** | 6, 6b | **Done** | `program_day.py`, `lesson-tasks.json`, `context.md`, no password in `daily.json` |
| **3 — RAG automation** | 5, 7–9, 12 | **Code done** | Scripts + compose env; **OWUI spike S0–S4 not run on um690** |
| **4 — Dashboard polish** | 10a, 10c, 11 | **Mostly done** | RAG badge, code toggle, PWA shell; PNG icons + offline banner remain |
| **5 — Ops hardening** | 13, 16–19 | **Partial** | Backup + Chrony scripts; auth spike + monitoring PR 13 open |

### PR checklist (implementation)

- [x] PR 1 — `ara_tutor/` directories
- [x] PR 2 — `grep-awk-sed.md`
- [x] PR 3 — `docker-compose.md`, `git-lfcs.md`
- [x] PR 4 — 7 core `knowledge/linux|networking/` refs
- [x] PR 5 — `lfcs-profile-summarize.sh`, `profile-summary.md`
- [x] PR 6 — shared schedule, `session_context.py`, `weak_area` days
- [x] PR 6b — workspace creds UX (username only in dashboard)
- [x] PR 12 — RAG env vars in compose + `.env.example`
- [x] PR 7–8 — `lfcs-ara-sync.sh`, eval harness, `ARA_SYNC_API.md`
- [x] PR 9 — guidance → portal-build → ara-sync chain
- [x] PR 10a — Ara RAG status badge
- [x] PR 10c — Code/tutor model toggle
- [x] PR 11 — `manifest.webmanifest`, `sw.js` (SVG icon; 192/512 PNG pending)
- [x] PR 17 — `lfcs-backup-volumes.sh`
- [x] PR 18 — Git/deploy docs in `GETTING_STARTED.md`
- [x] PR 19 — `lfcs-chrony-setup.sh`
- [ ] PR 10b — iframe URL params (gated on OQ1 spike)
- [ ] PR 13 — Ara latency metrics in sidebar
- [ ] PR 16 — Open WebUI auth spike + implementation

---

## UI/UX (June 2026 session)

| Area | Status |
|------|--------|
| **5 terminal themes** | Kanagawa, Rosé Pine, Gotham, Panda, Posterpole — `portal/static/themes.css` |
| **Theme picker** | Sidebar footer, `localStorage` `lfcs-ui-theme` |
| **Lesson markdown** | Theme-aware `lesson-md.css`; `:bi-*:` shortcodes in docs |
| **Workspace IDE** | `ide-theme-sync.js` + `aios-themes` VS Code extension |
| **Bootstrap Icons** | Replaced UI emojis in dashboard (`portal/static/vendor/bootstrap-icons/`) |
| **PWA cache** | `aios-v5` |

---

## Stack (live on um690)

| Service | Port | URL |
|---------|------|-----|
| Dashboard | 3080 | http://REDACTED:3080/ |
| Ara (Open WebUI) | 3082 | http://REDACTED:3082/ |
| Workspace (code-server) | 3080/ide/ | via portal |
| Lab browser (Mullvad) | 3001 | https://REDACTED:3001/ |
| Ollama | 11434 | http://REDACTED:11434 |

**Models:** `Ara` (llama3.2:3b), `qwen2.5-coder:7b`

---

## LFCS program

- **Cycle 1:** Day 3 of 45 (portal build 2026-06-16 — Project 01, node1)
- **Schedule:** `schedule/daily-schedule.json` — manual `start_date` for Cycle 2 (no auto-loop)
- **Weak-area days:** 5, 6, 24, 26, 40, 41
- **Tests:** `validation/test_program_day.py`, `test_lesson_tasks.py`, `test_ara_eval.py` — pass

---

## Manual / runtime steps (not in git)

1. **RAG spike** — `guides/ARA_SYNC_API.md` S0–S4 on live Open WebUI; attach `ara_tutor` collection to Ara
2. **Profile PDFs** — `sudo apt install poppler-utils`; run `lfcs-profile-summarize.sh`; edit `profile-summary.md`
3. **Deploy** — `sudo ./automation/lfcs-backend-deploy.sh` after compose changes
4. **Daily sync** — `./automation/lfcs-ara-sync.sh` (or wait for 07:00 cron via `lfcs-daily-guidance.sh`)
5. **Mullvad UX** — bookmark/homepage inside streamed Firefox; persist to compose volume (deferred)
6. **PWA install test** — operator-tablet “Add to Home Screen” after PNG icons added

---

## Milestones vs design timeline

| Milestone | Target | Status |
|-----------|--------|--------|
| Weak-area KB | Jun 18, 2026 | **Met** (content written; RAG index pending) |
| RAG live ≥80% eval | Jul 1, 2026 | **Blocked** on OWUI spike + first sync |
| Context injection | Jul 15, 2026 | **Code ready**; needs RAG + deploy |
| PWA on tablet | Jul 15, 2026 | **Partial** (shell works; polish open) |
| Cycle 1 complete | ~Jul 28, 2026 | In progress (Day 3) |
| LFCS exam | Dec 2026 / Jan 2027 | Planned |

---

## Screenshot validation (2026-06-15 session)

Evidence in `.grok/docs/user-attachments/screenshots/`:

| File | Confirms |
|------|----------|
| `Screenshot_20260615_221632_Firefox Nightly.png` | Dashboard Home — Day 2 UI, themes, cluster 4/4, Ara sidebar, Tailscale 6/8 |
| `Screenshot_20260615_221849_Firefox Nightly.png` | Workspace tab — `lfcs` user, creds hint, Launch IDE |
| `Screenshot_20260615_221308_Chrome.png` | GitHub `aios` → `AIOSed` rename; target remote `aios-os` |

Out-of-scope captures (Jellyfin, chown lab, Fileset) remain in Grok attachments only.

---

## Next actions (priority)

1. Push `aios-ed` → `github.com/DestroyTheKraken/aios-os.git` (**force** — remote is placeholder README only)
2. On um690: `git pull` (or fresh clone), set `LFCS_ROOT`, run `lfcs-portal-build.sh` + redeploy if needed
3. Complete Open WebUI RAG spike + first `lfcs-ara-sync.sh`
4. PR 11 finish: PNG PWA icons + offline banner
5. Mullvad Firefox profile persistence (bookmarks/homepage volume)

---

## Key documents

| Doc | Path |
|-----|------|
| System design (rev 4) | `guides/AIOS_SYSTEM_DESIGN.md` |
| Getting started | `guides/GETTING_STARTED.md` |
| Tablet quick start | `guides/TABLET_QUICKSTART.md` |
| Objectives tracker | `guides/OBJECTIVES_TRACKER.md` |
| Grok mentor rules | `AGENTS.md`, `.grok/rules/` |
| Theme sources | `.grok/docs/user-attachments/*.toml` |
| UI screenshots | `.grok/docs/user-attachments/screenshots/` |