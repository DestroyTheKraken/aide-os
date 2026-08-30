# AIOS Education IDE — Project Overview

**Updated:** June 15, 2026 | **Repo:** `/home/kraken/Projects/aios-ed` | **MVP:** LFCS 45-day cycle

## Principle

Build the lab while practicing weak LFCS areas: text processing, containers, networking, monitoring.

**Stack:** Samsung Tab S10 Ultra (client) + um690 (control plane). Strong on basic commands; weak on `awk`/`sed`/`grep`, compose authoring, `git`.

## LFCS Domains (priority)

- **High:** Operations/Deployment, Networking, Essential Commands
- **Medium:** Storage, Users & Groups

## AIOS on um690 (`REDACTED`)

| Service | Port | Role |
|---------|------|------|
| Dashboard | 3080 | Home, Lesson, Workspace, monitoring |
| Ara (Open WebUI) | 3082 | Tutor in right sidebar |
| Ollama | 11434 | `Ara` (llama3.2:3b), `qwen2.5-coder:7b` |
| Workspace | 3080/ide/ | code-server |
| Lab Browser | 3001 | Mullvad isolated browser |

## Ara

- KB: `ara_tutor/` — `user-profile/` (assessments), `knowledge/linux|networking/` (RAG content)
- Personalizes explanations; reference lookup + reframing
- **Scope now:** LFCS education only. Corporate/music deferred.

## Dashboard UI

- Left sidebar: collapsible; cards always stacked
- Right sidebar: Ara; stacks Welcome+Overview when open
- Tabs: Home, Lesson (45 days), Workspace

## Tool Separation

| Layer | Tools |
|-------|-------|
| Daily driver | Dashboard, Ara, Lab Browser, code-server |
| Docs | Obsidian + Syncthing |
| Quick edit | Acode (tablet) |
| Deep edit | Termux+vim or code-server |
| Terminal | Tailscale SSH, Termius+tmux |

## Out of Scope

- External AI iframes (Grok/Claude/Gemini) — use Ara
- Heavy local LLMs (qwen3.6:27b removed)
- Corporate/music workspaces (deferred)

## Phases

| # | Status | Goal |
|---|--------|------|
| 1 | Active | Tailscale mesh, Chrony, cluster |
| 2 | Done | Portal, Ollama, WebUI, IDE, browser |
| 3 | Active | Dashboard + Ara + responsive UI |
| 4 | Next | RAG, lesson context, PWA shell |
| 5 | Planned | Rebuild docs, hardening |