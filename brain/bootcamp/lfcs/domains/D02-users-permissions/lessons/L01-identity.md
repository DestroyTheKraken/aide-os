---
tags: [lfcs, lesson, beginner, D02]
status: draft
---

# L01 — Identity: users and groups

> [!summary] TL;DR
> Every process runs as a user. Groups grant shared access.

> [!todo] Next
> - [ ] Run `id` and write your uid/gid

```bash
id
whoami
groups
getent passwd "$(whoami)"
```

## Why ops care

Permissions failures (“permission denied”) start with **who is running the command**.

## Common mistakes

- Pasting `/etc/shadow` content into notes (never)
- Using root for everything

---

#lfcs
