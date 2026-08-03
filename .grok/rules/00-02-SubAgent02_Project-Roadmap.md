# Roadmap 2026

**Project:** AIOS Education IDE + LFCS Preparation  
**Last Updated:** June 15, 2026

---

## Q2 2026 (June – August) – Foundation & Core Stack

### Completed / In Flight (June 2026)

- [x] LFCS Docker stack on um690 (portal, Ollama, Open WebUI, code-server, Mullvad browser)
- [x] AIOS Education Dashboard — Home / Lesson / Workspace tabs
- [x] Ara tutor — `llama3.2:3b` custom model; coder `qwen2.5-coder:7b`
- [x] Collapsible left sidebar + Ara right sidebar with responsive card layout
- [x] `ara_tutor/` knowledge base scaffold (user-profile PDFs + knowledge dirs)
- [x] 45-day LFCS schedule + daily guidance pipeline
- [ ] Index `ara_tutor` in Open WebUI Knowledge (RAG)
- [ ] Populate `knowledge/linux/` and `knowledge/networking/` with LFCS reference content

### Remaining Q2

- Complete Phase 1 (network hardening, Chrony, clusterops consistency)
- Daily logging habit (`notifications/study-journal.log`)
- Close gaps: `grep`/`awk`/`sed`, `docker-compose`, `git`

## Q3 2026 (September – November) – Workflow & Polish

- Lesson-aware Ara prompts (program day + study guide context)
- Learner profile summaries from `ara_tutor/user-profile/` PDFs
- Shell automation scripts; git IaC for LFCS compose
- LFCS weak-area drills (Projects 02, 04, 06, 07)

## Q4 2026 (December) – Hardening & LFCS Exam Prep

- Obsidian documentation; full rebuild practice
- Mock exams; **LFCS exam target:** Dec 2026 / Jan 2027

## Stretch (education only)

- Prometheus + Grafana; backup Open WebUI/Ollama volumes
- More LFCS content in `ara_tutor/knowledge/`

> **Deferred:** corporate, music, multi-subject beyond education.

## Review Cadence

Weekly: `study-journal.log` | Monthly: roadmap + checklist | Quarterly: full review

## URLs (um690)

```
Dashboard:   http://100.81.13.95:3080/
Ara:         http://100.81.13.95:3082/
Workspace:   http://100.81.13.95:3080/ide/
Lab browser: https://100.81.13.95:3001/
Ollama:      http://100.81.13.95:11434
```