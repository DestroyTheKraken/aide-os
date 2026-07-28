---
tags: [lfcs, lesson, beginner, D01]
status: draft
---

# L03 — Inspect without breaking

> [!summary] TL;DR
> Prefer read-only tools: `file`, `stat`, `head`, `less`, bounded `find`.

> [!todo] Next
> - [ ] Run the inspect block on `/etc/os-release`

## Commands

```bash
stat /etc/os-release
file /etc/os-release
head -20 /etc/os-release
find /etc -maxdepth 2 -type f -name '*release*' 2>/dev/null
```

## Why ops care

Broken production boxes are fixed by **looking first**, changing second.

## Common mistakes

- Unbounded `find /` hammering disks
- Using `rm` while exploring

## Host / risk

um690 · **read-only**

---

#lfcs
