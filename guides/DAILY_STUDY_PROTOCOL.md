# Daily Study Protocol

Follow this every session. Consistency beats cramming for LFCS.

## Before You Start (5 min)

1. Read today's guidance:
   ```bash
   cat /home/kraken/Projects/aios-ed/notifications/latest-daily-guidance.txt
   ```
2. Confirm target node is reachable:
   ```bash
   tailscale ping node1   # or node2, node3
   ```
3. Set a timer for the session duration shown in guidance (~45–90 min).

## During the Session

### Rules (exam simulation)

- **No internet search** — only `man`, `info`, `--help`, and local docs
- **No copy-paste from AI** — type every command yourself
- **Document as you go** — append commands to a temp file: `~/today.sh`
- **Test persistence** before ending — if the project requires reboot survival, schedule it

### Session structure

| Block | Time | Activity |
|-------|------|----------|
| Warm-up | 5 min | `man -k` the topic; skim Study_Projects outline |
| Build | 60–70% | Execute phases hands-on on assigned node |
| Verify | 15% | Run verification commands from project outline |
| Log | 5 min | Journal entry + checklist |

## After the Session

```bash
# Log completion
echo "$(date -Iseconds) Project NN phase X DONE — notes: <any blockers>" \
  >> /home/kraken/Projects/aios-ed/notifications/study-journal.log

# Optional: rescan cluster if you changed services
/home/kraken/Projects/aios-ed/automation/lfcs-cluster-scan.sh
```

## Weekly Rhythm (built into 45-day schedule)

| Day type | What to do |
|----------|------------|
| Study days | New phases from Study_Projects |
| Review days (7, 14, 21, 28) | Re-test persistence, redo weakest task |
| Drill days (29–33) | Timed exam scenarios, no notes |
| Rest day (34) | man pages only |

## Persistence Test Protocol (LFCS critical)

Every project with "persistent deliverables" must pass:

```bash
# 1. Verify before reboot
<project verification commands>

# 2. Reboot
sudo reboot

# 3. Reconnect via Termius (SSH key only)

# 4. Re-verify — must pass with ZERO manual fixes
<same verification commands>
```

If it fails: fix, re-deploy, reboot again. Repeat until clean.

## Blocker Escalation

| Blocker | Action |
|---------|--------|
| Locked out of SSH | Physical/LAN access to node; fix sshd config |
| Node unreachable | `tailscale status`; check Deco LAN |
| Out of disk | `df -h`; extend volume or reset node |
| Script fails on Ubuntu | Check CLUSTER_MAP.md translation table |

## Exam Confidence Tracker

After each project, rate yourself 1–5 in `notifications/study-journal.log`:

```
CONFIDENCE Project 03 Users&Groups: 3/5 — ACLs slow me down
```

Target: all domains at 4/5 before scheduling the real exam.