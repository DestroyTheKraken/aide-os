# LFCS 45-Day Project Roadmap

Structured cycle from first principles to capstone. One primary focus per day with weekly reviews.

## Phase 1: Foundations (Days 1–7)

| Day | Project | Node | Focus |
|-----|---------|------|-------|
| 1–2 | 00 Documentation | um690 | man, info, /usr/share/doc |
| 3–4 | 01 Directories | node1 | files, links, SSH |
| 5–6 | 02 Log Analysis | node1/um690 | grep, awk, tar |
| 7 | Review | any | Weakest 00–02 task |

## Phase 2: Identity, Services, Storage (Days 8–14)

| Day | Project | Node | Focus |
|-----|---------|------|-------|
| 8–9 | 03 Permissions | node3 | users, ACLs, sudoers |
| 10–11 | 04 systemd | node1 | units, limits, sysctl |
| 12–13 | 05 Storage | node3 | GPT, fstab, swap |
| 14 | Review | any | Reboot persistence drill |

## Phase 3: Networking & Automation (Days 15–21)

| Day | Project | Node | Focus |
|-----|---------|------|-------|
| 15–17 | 06 Networking | node2/node1 | IP, SSH, NFS |
| 18–19 | 07 Firewall | node2 | firewalld, NAT, forward |
| 20, 22 | 08 Automation | um690 | bash, cron, at |
| 21 | Review | any | Timed 30-min drill |

## Phase 4: Capstone (Days 23–28)

| Day | Project | Node | Focus |
|-----|---------|------|-------|
| 23–27 | 09 Forge | node3 | Docker, tailnet-only, validation |
| 28 | Review | any | Full capstone from memory |

## Phase 5: Exam Drills (Days 29–35)

| Day | Focus | Node |
|-----|-------|------|
| 29 | Essential Commands (45m) | node1 |
| 30 | Storage + Users (45m) | node3 |
| 31 | Networking (45m) | node2 |
| 32 | Operations (45m) | node1 |
| 33 | Full capstone (90m) | node3 |
| 34 | Rest | — |
| 35 | Remediation | any |

## Phase 6: Mastery Cycle (Days 36–45)

Speed runs, mock exam, final capstone, graduation.

---

## LFCS Domain Coverage Matrix

| Domain | ~Weight | Projects |
|--------|---------|----------|
| Essential Commands | 20% | 00, 01, 02 |
| Operations & Deployment | 25% | 04, 08, 09 |
| Users & Groups | 10% | 03 |
| Networking | 25% | 06, 07, 09 |
| Storage | 20% | 05, 06 |

## Customize the Schedule

Edit `schedule/daily-schedule.json`:
- `start_date` — when your program begins
- `notification_time` — daily notice hour (default 07:00)
- Individual `days[]` entries — swap nodes, extend phases

After edits, run:
```bash
./automation/lfcs-daily-guidance.sh
```