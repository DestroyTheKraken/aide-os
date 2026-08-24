# How you start AIDE_OS (you are the student)

You sit at **um690**. You do not wait for an ISO, `hickles`, or `node3`.

## Student seat (learning)

```bash
aide-day
```

That opens http://127.0.0.1:8101/ — today’s lesson, a 25-minute timer, mark complete / skip. Progress is `brain/bootcamp/lfcs/progress/focus-progress.json`. You are on **day 1**.

Then do the work:

1. Read `Study_Projects/00.md` (matches day 1: man/info fluency).
2. Do the exercises in a terminal on this machine, **or** `multipass start grokaide-edu && multipass shell grokaide-edu`.
3. In the Day Start window: **Start focus block** → when the timer ends, **Mark day complete**.
4. Tomorrow, run `aide-day` again. It resumes the next unfinished day.

Same command: `into-the-sequence`.

## Author seat (building AIDE)

```bash
cd ~/AIDE_OS && grokAide-start
```

That is Grok in this tree, not the student lesson UI. Use it to change lessons, the Day Start app, or Ara. Refresh the browser tab after you edit.

## What is *not* a start button yet

| Thing | Why it fails today |
|-------|--------------------|
| Plasma/GNOME “GrokAide Brain” icon | Desktop file still points at `/home/kraken/…` |
| `aide-obsidian-day` | Obsidian GUI is not installed on um690 |
| `aide-menu` | Mostly emergency/backup, not class |
| Custom Edubuntu ISO | Not built. Do not block on it. |

## Files that drive the student UI

| Path | Role |
|------|------|
| `schedule/daily-schedule.json` | Lesson titles and order |
| `schedule/lesson-resources.json` | Optional YouTube links |
| `Study_Projects/00.md` … `09.md` | The actual labs |
| `brain/DAY-START.md` | Obsidian copy of the same idea |
| `scripts/learning/day-start-app.py` | The window `aide-day` serves |

Edit the JSON or a `Study_Projects` file, then reload `aide-day`. That is the development loop.
