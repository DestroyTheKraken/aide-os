# LFCS Learning Environment — Getting Started

Your cluster is now a structured LFCS lab. This guide explains how to use it daily from your Termius tablet.

## Your Actual Hardware (scanned June 2026)

| Machine | Role | Tailscale IP | Notes |
|---------|------|-------------|-------|
| **um690** | Control plane | 100.81.13.95 | 60 GB RAM, 16 cores — docs, cron, automation |
| **node1** | Primary worker | 100.75.124.36 | Ubuntu 24.04, Docker active, i5 M93p |
| **node2** | Edge gateway | 100.104.54.20 | Ubuntu 26.04, 7 GB RAM — firewall/NAT labs |
| **node3** | Storage + forge | 100.82.177.52 | Ubuntu 26.04, 15 GB RAM — capstone host |
| **j-tab** | Admin console | 100.75.74.14 | Termius tablet (exam-style workflow) |

**Important:** Guides reference Rocky Linux patterns from LFCS materials. Your nodes run **Ubuntu** — use `apt` not `dnf`, and `ufw` where guides mention firewalld (skills are identical on the exam).

## First-Time Setup (one-time, on um690)

```bash
cd /home/kraken/Projects/aios-ed/automation
sudo ./lfcs-backend-deploy.sh
```

This deploys everything: **LFCS Portal** + **Mullvad Browser** + firewall + boot persistence + daily cron.

## Daily Workflow (tablet — j-tab)

```
1. Open http://100.81.13.95:3080/     (LFCS Portal — today's plan)
2. Tap "Open Mullvad Browser"         (https://100.81.13.95:3001/)
3. Log in with credentials from notifications/tablet-credentials.txt
4. SSH to assigned node via Termius for hands-on labs
5. Log completion in study-journal.log
```

See **[TABLET_QUICKSTART.md](./TABLET_QUICKSTART.md)** for full tablet setup.

## Directory Map

```
LFCS/
├── guides/           ← you are here
├── Study_Projects/   ← project outlines (00–09)
├── automation/       ← deploy + scan + daily guidance scripts
├── schedule/         ← daily-schedule.json, program_day.py, lesson-tasks.json
├── inventory/        ← live cluster.json from scans
├── notifications/    ← daily guidance + study journal
├── docker/           ← compose stack + Modelfile.ara
├── ara_tutor/        ← Ara knowledge base + session context
└── validation/       ← tests + ara-eval prompts
```

## Markdown icons (dashboard + lessons)

In `Study_Projects/`, `guides/`, and daily guidance rendered on the portal, use **Bootstrap Icons shortcodes** instead of emojis:

```markdown
## :bi-wrench: LFCS Exam-Style Scenario
| Status | :bi-square: not started |
```

Shortcodes render as icons in the dashboard lesson viewer (`portal/static/markdown.js`). In plain-text viewers (Termius, raw `/guides/` download), you will see `:bi-name:` — the [Bootstrap Icons catalog](https://icons.getbootstrap.com/) lists valid names (`wrench`, `journal-check`, `check-circle-fill`, etc.).

## Git → deploy workflow (PR 18)

```bash
cd /home/kraken/Projects/aios-ed
git add -u && git commit -m "describe change"
./automation/lfcs-portal-build.sh          # daily.json + context.md
sudo ./automation/lfcs-backend-deploy.sh  # only if docker-compose changed
./automation/lfcs-ara-sync.sh             # RAG + Modelfile.daily (after PR 7)
```

- **Source:** `/home/kraken/Projects/aios-ed` (`LFCS_ROOT`)
- **Runtime compose:** `/opt/lfcs/secure-browser-forge` (`DEPLOY_DIR`)
- **Secrets:** `docker/.env` and `${DEPLOY_DIR}/.env` — never commit

## Ara automation

| Script | Purpose |
|--------|---------|
| `lfcs-profile-summarize.sh` | Draft `profile-summary.md` from PDFs |
| `lfcs-ara-sync.sh` | Index knowledge + regen Modelfile.daily |
| `lfcs-ara-eval.sh` | Canonical prompt eval harness |
| `lfcs-daily-guidance.sh` | Daily notice → portal-build → ara-sync chain |

See `guides/ARA_SYNC_API.md` for Open WebUI API spike checklist.

## Next Steps

1. Read [CLUSTER_MAP.md](./CLUSTER_MAP.md) — which node for which project
2. Read [DAILY_STUDY_PROTOCOL.md](./DAILY_STUDY_PROTOCOL.md) — session rules
3. Read [PROJECT_ROADMAP.md](./PROJECT_ROADMAP.md) — 45-day schedule overview
4. Start **Program Day 1** — Project 00 on um690