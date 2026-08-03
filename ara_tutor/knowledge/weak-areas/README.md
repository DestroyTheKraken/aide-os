# Weak-area knowledge (MVP)

Static drill content for self-reported gaps. Ara uses these on schedule days tagged `weak_area` in `schedule/daily-schedule.json`.

| File | Domain | Schedule days |
|------|--------|---------------|
| `grep-awk-sed.md` | Text processing | 5, 6 — **PR 2 complete** |
| `docker-compose.md` | Operations | 24, 26 — **PR 3 complete** |
| `git-lfcs.md` | Essential commands | 40, 41 — **PR 3 complete** |

## Post-MVP (planned)

Weak areas will be scored against **all LFCS exam objectives** via **LFCS-style performance scenarios** in the ~1-year AIOS course:

1. Student completes tasks on a lab target (cluster node → later LXD container).
2. `scenario-runner` + `checks.sh` assert state on the host (authoritative grade).
3. **Check my work** or Ara prompt sends evidence for coaching (not grading).
4. Percentage per objective/domain updates `objective-scores.json` and regenerates targeted KB here.

See `guides/AIOS_SYSTEM_DESIGN.md` → LFCS-style scenario assessment.