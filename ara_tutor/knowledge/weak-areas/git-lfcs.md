# Git for LFCS IaC — Weak-Area Drill

**LFCS domains:** Essential Commands (version control), Operations (reproducible deployment)  
**AIOS schedule:** Days 40, 41 (Project 08 automation) · `weak_area: git-lfcs`  
**Lab node:** Day 40 → `um690` (authoring control plane)  
**Study guide:** `Study_Projects/08.md` — Autonomous System Administrator  
**Goal:** Track compose, automation, and portal code so um690 can be **rebuilt from scratch** with confidence

Git is not a large LFCS exam weight, but it is how you keep the AIOS Education stack reproducible — the same discipline as exam "document your changes" requirements.

---

## Day 40 checklist (script from scratch + version control)

1. `git init` or clone the LFCS project repo
2. Track `docker/`, `automation/`, `portal/`, `schedule/` — not secrets
3. Meaningful commit after a working change
4. `git log` / `git diff` to audit what changed before deploy

## Day 41 checklist (cron + hands-free automation)

1. Commit cron-related scripts (`install-daily-cron.sh`, guidance pipeline)
2. Tag or document the commit hash used for a known-good deploy
3. Practice rollback: `git checkout -- <file>` or `git revert`

---

## Why git matters for AIOS

| Without git | With git |
|-------------|----------|
| "It worked yesterday" — unknown diff | `git diff` shows exact compose/script changes |
| Manual copy to `/opt/lfcs/` | Deploy script pulls known tree; git records source |
| Exam rebuild from memory | `git clone` + `lfcs-backend-deploy.sh` = reproducible stack |

**Two paths on um690:**

| Path | Role |
|------|------|
| `${LFCS_ROOT}` — `/home/kraken/Projects/aios-ed` | **Source of truth** — edit, commit, push |
| `${DEPLOY_DIR}` — `/opt/lfcs/secure-browser-forge` | **Runtime** — compose copy + `.env` (deploy script) |

Workflow: edit in `LFCS_ROOT` → commit → redeploy.

---

## First-time setup

```bash
cd /home/kraken/Projects/aios-ed

# New repo (if not already initialized)
git init
git branch -M main

# Identity (global or local)
git config user.name "Joshua Hickman"
git config user.email "you@example.com"

# See what would be tracked
git status
```

### `.gitignore` essentials (LFCS / AIOS)

Already in repo root — ensure these stay ignored:

```gitignore
# Secrets — never commit
docker/.env
**/tablet-credentials.txt

# Generated ara_tutor artifacts
ara_tutor/session/Modelfile.daily
ara_tutor/session/context.md
ara_tutor/meta/indexing-manifest.json
ara_tutor/meta/last-sync-state.json

# Runtime / local noise (add as needed)
notifications/cron.log
*.swp
```

**Rule:** If a file contains passwords, API keys, or Tailscale-specific secrets → **`.env` + gitignore**, not the repo.

---

## Daily workflow (edit → commit → deploy)

```bash
cd /home/kraken/Projects/aios-ed

# 1. See state
git status
git diff

# 2. Stage intentional changes
git add docker/docker-compose.yml
git add automation/lfcs-portal-build.sh
git add portal/static/app.js

# Or stage all tracked modifications
git add -u

# 3. Commit with message (LFCS audit style)
git commit -m "portal: add rag_status badge to Ara sidebar"

# 4. Deploy if compose/automation changed
sudo ./automation/lfcs-backend-deploy.sh --non-interactive
# Portal-only changes may only need:
./automation/lfcs-portal-build.sh
```

### Commit message pattern (recommended)

```
<area>: <what changed>

Examples:
docker: bind openwebui to FORGE_BIND_IP only
automation: chain lfcs-ara-sync after portal-build
ara_tutor: add grep-awk-sed weak-area reference
schedule: set weak_area on day 5
```

---

## Core commands (LFCS proficiency)

| Task | Command |
|------|---------|
| Status | `git status` |
| Short status | `git status -s` |
| Diff unstaged | `git diff` |
| Diff staged | `git diff --cached` |
| Stage file | `git add path/to/file` |
| Unstage | `git restore --staged file` |
| Discard working change | `git restore file` |
| Commit | `git commit -m "message"` |
| History | `git log --oneline -10` |
| One-line + graph | `git log --oneline --graph -15` |
| Show commit | `git show HEAD` |
| What changed in commit | `git show abc1234 --stat` |

---

## Inspecting history (exam-style audit)

```bash
# Who changed docker-compose last?
git log --oneline -- docker/docker-compose.yml

# What changed in the last commit?
git show HEAD

# Compare working tree to last commit
git diff HEAD -- automation/

# Find when a string was introduced
git log -S 'FORGE_BIND_IP' --oneline -- docker/
```

---

## Branches (lightweight — single learner)

```bash
# Feature branch for risky change
git checkout -b pr-7-ara-sync
# ... edit, test ...
git add automation/lfcs-ara-sync.sh
git commit -m "automation: add lfcs-ara-sync.sh with RAG idempotency"

# Back to main and merge
git checkout main
git merge pr-7-ara-sync

# Delete branch after merge
git branch -d pr-7-ara-sync
```

For solo LFCS prep, `main` + short-lived branches mirrors the AIOS PR plan without requiring GitHub.

---

## Remote backup (optional but recommended)

```bash
# Add remote (GitHub/GitLab) once
git remote add origin git@github.com:you/lfcs-lab.git
git push -u origin main

# Daily backup
git push

# Clone on fresh um690 rebuild
git clone git@github.com:you/lfcs-lab.git /home/kraken/Projects/aios-ed
cd /home/kraken/Projects/aios-ed
cp docker/.env.example docker/.env   # fill secrets locally
sudo ./automation/lfcs-backend-deploy.sh
```

---

## Rebuild-from-scratch drill (LFCS + AIOS)

Simulates "new control plane, same stack":

```bash
# 1. Record known-good state
cd /home/kraken/Projects/aios-ed
git rev-parse HEAD > /tmp/lfcs-known-good.sha

# 2. Clone fresh (or new directory)
git clone <remote> /tmp/lfcs-rebuild-test
cd /tmp/lfcs-rebuild-test
git checkout "$(cat /tmp/lfcs-known-good.sha)"

# 3. Restore secrets outside git
cp /home/kraken/Projects/aios-ed/docker/.env docker/.env

# 4. Deploy
sudo ./automation/lfcs-backend-deploy.sh --non-interactive

# 5. Verify
curl -s -o /dev/null -w "%{http_code}" http://$(tailscale ip -4):3080/
docker compose -f docker/docker-compose.yml ps
```

Pass criteria: dashboard returns `200`, five AIOS services healthy.

---

## Tie-in to Project 08 (bash automation)

Project 08 scripts should be **git-tracked** the same day they work:

```bash
#!/usr/bin/env bash
# automation/my-maintenance.sh
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LFCS_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
# use absolute paths — cron has no $HOME context
```

```bash
git add automation/my-maintenance.sh
git commit -m "automation: nightly log rotation for node1 SSH evidence"
```

Cron installs via `install-daily-cron.sh` — commit that script too when you change schedules.

---

## Files to track vs ignore (AIOS map)

| Track | Ignore |
|-------|--------|
| `docker/docker-compose.yml` | `docker/.env` |
| `docker/ollama/Modelfile.ara` | `notifications/tablet-credentials.txt` |
| `automation/*.sh` | `ara_tutor/session/*.md` (generated) |
| `portal/www/`, `portal/static/` | `ara_tutor/meta/*.json` (generated) |
| `schedule/daily-schedule.json` | Large binaries, PDFs in `user-profile/` (optional track) |
| `ara_tutor/knowledge/**/*.md` | `notifications/cron.log` |
| `guides/`, `Study_Projects/` | |

Learner profile PDFs: track if repo is private; otherwise keep local-only.

---

## Rollback scenarios

```bash
# Undo uncommitted edits to one file
git restore portal/static/app.js

# Undo last commit, keep changes staged
git reset --soft HEAD~1

# Undo last commit, discard changes (destructive)
git reset --hard HEAD~1

# Revert a commit on main (safe for shared history)
git revert abc1234 --no-edit
```

After rollback of compose:

```bash
sudo ./automation/lfcs-backend-deploy.sh --non-interactive
```

---

## Common mistakes

1. **Committing `.env`** — rotate secrets if accidentally pushed.
2. **`git add .` blind** — stages secrets and logs; use `git status` first.
3. **No commit before deploy** — cannot reconstruct working stack later.
4. **Editing only `/opt/lfcs/`** — runtime dir overwritten on redeploy; edit `LFCS_ROOT`.
5. **Vague messages** — `"fix stuff"` fails audit; describe area + change.
6. **Binary noise in repo** — large Ollama volumes stay in Docker named volumes, not git.

---

## Verification commands

```bash
git status                    # clean working tree before exam drill
git log --oneline -5
git check-ignore -v docker/.env   # confirms .env ignored
git ls-files docker/ automation/ portal/ | wc -l
```

---

## man / help references

```bash
git help
git help commit
git help restore
man gitglossary
```

---

## Ara tutoring prompts (examples)

- "What should I gitignore in the LFCS repo?"
- "Walk me through commit → deploy after editing docker-compose.yml."
- "How do I find what changed in lfcs-portal-build.sh last week?"
- "Rebuild um690 AIOS stack from git — step by step."
- "Difference between `git restore` and `git revert`?"

**Related:** `Study_Projects/08.md` · `automation/lfcs-backend-deploy.sh` · `guides/GETTING_STARTED.md` · Days 40, 41 in `schedule/daily-schedule.json` · PR 18 (git IaC docs)