---
tags: [lfcs, lab]
date: 2026-07-27
status: ready
host: um690
risk: read-only
---

# Lab 01 — Linux filesystem tree

> [!summary] TL;DR
> Walk the FHS on um690 with **read-only** commands. Map directories to purpose.

> [!todo] Next
> - [ ] Run the command block below and fill the table

| Field | Value |
|-------|--------|
| **Host** | um690 (`kraken`) |
| **Risk** | **Read-only** — no `rm`, no writes outside notes |
| **Domain** | [[bootcamp/01_lfcs/domains/D01-essential-commands/00-domain]] |
| **Time** | ~25–40 min |

---

## Prerequisites

- Terminal on um690
- Optional: Spark **LFCS Coach** open for “what is this path for?” questions

## Steps

### 1) Where am I?

```bash
pwd
whoami
uname -a
```

### 2) Top-level map

```bash
ls -la /
```

Fill in (your words):

| Path | Purpose on this host | Notes |
|------|----------------------|-------|
| `/etc` | | |
| `/var` | | |
| `/home` | | |
| `/usr` | | |
| `/tmp` | | |
| `/proc` | | |
| `/sys` | | |
| `/mnt` | | |

### 3) hier(7)

```bash
man 7 hier
# or: man -P 'less -p FILES' 7 hier
```

### 4) Inspect without mutating

```bash
stat /etc/os-release
file /etc/os-release
head -20 /etc/os-release
ls -ld /var/log /var/lib
```

### 5) Find (bounded)

```bash
# limit depth — avoid hammering the whole disk
find /etc -maxdepth 2 -type f -name '*release*' 2>/dev/null
```

## Self-check

- [ ] I can explain `/` vs `/home` vs `/usr` without looking
- [ ] I know why `/proc` and `/sys` are special
- [ ] I did **not** run destructive commands

## Debrief (3 bullets)

1. 
2. 
3. 

> [!success] Done when
> Table filled + self-check complete + debrief written.

---

#lfcs #lab
