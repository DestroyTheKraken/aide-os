---
tags: [lfcs, lesson, beginner, D02]
status: draft
---

# L02 — Mode bits (`rwx`)

> [!summary] TL;DR
> Three triples: user · group · other. `644` and `755` are muscle memory.

> [!todo] Next
> - [ ] Create sandbox file and toggle 644 ↔ 600

| Mode | Meaning (file) |
|------|----------------|
| `644` | owner rw, group/other r |
| `600` | owner only |
| `755` | owner rwx, others rx (common for dirs/scripts) |

```bash
mkdir -p ~/tmp-lfcs/lab02 && cd ~/tmp-lfcs/lab02
echo practice > note.txt
chmod 644 note.txt && ls -l note.txt
chmod 600 note.txt && ls -l note.txt
```

---

#lfcs
