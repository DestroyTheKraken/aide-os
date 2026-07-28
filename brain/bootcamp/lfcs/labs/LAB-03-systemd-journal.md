---
tags: [lfcs, lab]
date: 2026-07-27
status: ready
host: um690
risk: read-only
---

# Lab 03 — systemd status & journald (read-only)

> [!summary] TL;DR
> Inspect units and logs **without** stopping services.

> [!todo] Next
> - [ ] Run the status/journal commands and note one finding

| Field | Value |
|-------|--------|
| **Host** | um690 |
| **Risk** | **Read-only** — do not `stop`/`disable` production services |
| **Domain** | [[bootcamp/lfcs/domains/03-systemd]] |
| **Time** | ~30 min |

---

## Steps

### 1) Overview

```bash
systemctl is-system-running || true
systemctl list-units --type=service --state=running | head -40
```

### 2) Inspect a common unit

```bash
systemctl status ssh.service --no-pager || systemctl status sshd.service --no-pager || true
systemctl cat ssh.service 2>/dev/null | head -40 || systemctl cat sshd.service 2>/dev/null | head -40 || true
```

Pick another user-facing unit if SSH naming differs:

```bash
systemctl list-unit-files --type=service | head -30
```

### 3) Journal (read)

```bash
journalctl -b -n 30 --no-pager
# unit-specific if you identified one:
# journalctl -u ssh.service -n 20 --no-pager
```

### 4) Concepts to capture

| Concept | Your note |
|---------|-----------|
| start vs enable | |
| unit file location (from `systemctl cat`) | |
| how to limit journal output | |

## Self-check

- [ ] I did **not** stop/restart critical services
- [ ] I can get status and last log lines for a unit
- [ ] I know where to look next when a service fails

## Debrief

1. 
2. 
3. 

---

#lfcs #lab
