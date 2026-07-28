---
tags: [lfcs, lesson, beginner, D02]
status: draft
---

# L03 — Ownership

> [!summary] TL;DR
> `chown` changes user/group ownership. Prefer sandbox; avoid system paths.

## Concept

`ls -l` shows owner and group columns. Services often run as dedicated users.

## Try (safe)

```bash
ls -l ~/tmp-lfcs/lab02/note.txt
stat -c '%U %G %a %n' ~/tmp-lfcs/lab02/note.txt
```

## Risk

`chown` on system files needs root and can break services — practice on `~/tmp-lfcs` only.

---

#lfcs
