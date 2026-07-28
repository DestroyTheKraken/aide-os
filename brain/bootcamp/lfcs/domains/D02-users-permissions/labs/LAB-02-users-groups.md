---
tags: [lfcs, lab]
date: 2026-07-27
status: ready
host: um690
risk: reversible
---

# Lab 02 — Users, groups, permissions (local sandbox)

> [!summary] TL;DR
> Inspect identity; practice modes on files **only** under `~/tmp-lfcs/`.

> [!todo] Next
> - [ ] Create sandbox dir and complete mode exercises

| Field | Value |
|-------|--------|
| **Host** | um690 |
| **Risk** | **Reversible** — only touch `~/tmp-lfcs/` |
| **Domain** | [[bootcamp/lfcs/domains/D02-users-permissions/00-domain]] |
| **Time** | ~30–45 min |

---

## Steps

### 1) Identity

```bash
id
whoami
groups
getent passwd "$(whoami)"
```

### 2) Sandbox (safe)

```bash
mkdir -p ~/tmp-lfcs/lab02
cd ~/tmp-lfcs/lab02
echo "practice" > note.txt
ls -l note.txt
```

### 3) Modes

```bash
chmod 644 note.txt && ls -l note.txt
chmod 600 note.txt && ls -l note.txt
# restore something readable for your user
chmod 644 note.txt
stat -c '%a %n' note.txt
```

### 4) Explain in your words

| Mode | Meaning |
|------|---------|
| `644` | |
| `600` | |
| `755` (on a dir you create) | |

```bash
mkdir -p binish && chmod 755 binish && ls -ld binish
```

## Self-check

- [ ] I can read `ls -l` output (owner, group, mode)
- [ ] I only changed files under `~/tmp-lfcs/`
- [ ] I understand why secrets must not live in vault notes

## Debrief

1. 
2. 
3. 

## Cleanup (optional)

```bash
# only if you want a clean slate
rm -rf ~/tmp-lfcs/lab02
```

---

#lfcs #lab
