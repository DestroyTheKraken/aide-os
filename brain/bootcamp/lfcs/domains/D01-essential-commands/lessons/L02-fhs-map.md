---
tags: [lfcs, lesson, beginner, D01]
status: draft
---

# L02 — Filesystem Hierarchy (FHS) map

> [!summary] TL;DR
> `/` is the root. Every file hangs under it. Learn the purpose of top-level dirs.

> [!todo] Next
> - [ ] `ls -la /` and fill the table in Lab 01

## Mental model

```
/  (root)
├── etc   system config
├── var   variable data (logs, caches)
├── home  user homes
├── usr   userland programs/libs
├── tmp   temporary
├── proc  kernel/process info (virtual)
└── sys   devices/kernel (virtual)
```

## Why ops care

Troubleshooting starts with “which directory tells the truth?” Logs → `/var/log`. Config → `/etc`.

## Try it

```bash
ls -la /
man 7 hier
```

## Common mistakes

- Treating `/proc` like a normal disk folder you should edit
- Confusing `/usr` with “user home”

---

#lfcs
