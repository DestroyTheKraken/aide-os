---
tags: [lfcs, fun, browser, d01]
date: 2026-08-02
status: active
---

# Relax · 15-minute browser LFCS (Terminus)

> [!summary] Fun that still trains the exam muscle
> Play **Terminus** (or **Bashcrawl Web**) in Brave for ~15 min. You practice real commands: `ls`, `cd`, `less`, `mv`, `grep` — D01-aligned, low stress.

## Setup (once, ~2 min)

### Brave profile for study (optional but clean)

1. Open **Brave**
2. `Menu → More tools → Add person` → name **LFCS Lab** (or use your main profile)
3. Pin bookmarks:
   - [man7.org](https://man7.org/linux/man-pages/)
   - Local Day Start: after `aide-day` → http://127.0.0.1:8101/
   - Portfolio: http://127.0.0.1:8099/aide/home/joshua/ (if `serve.sh` running)
4. **Grok-it** (what you were configuring for fun):
   - API key from [console.x.ai](https://console.x.ai) → **Test Connection**
   - Model: pick a cheap/fast one for sidebar help
   - Prompt tab: keep short, e.g.  
     `You are a patient LFCS tutor. Explain only the command I selected. Prefer man-page style. No spoilers for Terminus puzzles unless I ask.`
   - Leave **Include page URL and title** ON for man7.org pages
   - **Never** paste keys into git/notes

**Stay on Brave** for this project — Chromium-family, you already use it; no need to switch browsers tonight. Firefox is fine later for variety; Chromium/Brave match Canonical/docs sites well.

## Play (12–15 min)

```bash
# Best: local Terminus (browser game, real Linux command practice)
terminus
```

If that fails (path/port), use:

```bash
# Online Bashcrawl story mode in browser
bashcrawl-web
# or open in Brave:
# https://bamr87.github.io/bashcrawl/#/story
```

### Success criteria (pick any 3)

- [ ] Open a “room” / directory with `ls` and `cd`
- [ ] Read something with `less` or `cat` (quit less with `q`)
- [ ] Use `man` or `--help` once in a real terminal (Ghostty) for a command you just used in-game
- [ ] Write **2 lines** in [[sessions/2026-08-02-day-one]] or a new session note: *what I typed · what I learned*

## Why this counts for LFCS

| In game | Exam domain |
|---------|-------------|
| `ls` / `cd` / paths | Essential commands · FHS |
| `less` / reading files | Inspect without breaking |
| `mv` / `cp` / `rm` | File ops (careful) |
| `grep` | Text search |

Same muscle as Day-01 **man/info** — playful reps instead of pure memorization.

## Done?

Stop when the timer ends. Optional: mark progress in `aide-day` or check a box on [[bootcamp/lfcs/DAY-01-START]].

---

#lfcs #fun #d01
