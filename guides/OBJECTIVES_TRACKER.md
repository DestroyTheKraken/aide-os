# LFCS Exam Objectives Tracker

Mark each sub-objective as you complete the mapped project. Target: every row at :bi-check-circle-fill: before scheduling the exam.

## 1. Baseline System Interaction (~20%)

| Objective | Project | Node | Status |
|-----------|---------|------|--------|
| Log in locally and remotely | 01, 06 | node1 | :bi-square: |
| Create/move/copy/delete files | 01 | node1 | :bi-square: |
| Hard and soft links | 01 | node1 | :bi-square: |

## 2. Text Manipulation & Data Filtering

| Objective | Project | Node | Status |
|-----------|---------|------|--------|
| grep, sed, awk, cut, regex | 02 | node1 | :bi-square: |
| tar, gzip, bzip2 archives | 02 | node1 | :bi-square: |
| Analyze system logs | 02 | node1 | :bi-square: |

## 3. Permissions & Identity Management (~10%)

| Objective | Project | Node | Status |
|-----------|---------|------|--------|
| User/group management | 03 | node3 | :bi-square: |
| Environment profiles | 03 | node3 | :bi-square: |
| sudo configuration | 03, 09 | node3 | :bi-square: |
| ACLs, SUID/SGID | 03 | node3 | :bi-square: |

## 4. Core System Operations (~25%)

| Objective | Project | Node | Status |
|-----------|---------|------|--------|
| systemd start/stop/enable | 04, 09 | node1/node3 | :bi-square: |
| ps, top, kill, nice | 04 | node1 | :bi-square: |
| limits.conf | 04 | node1 | :bi-square: |
| sysctl persistent tuning | 04, 07, 09 | node1/node2 | :bi-square: |

## 5. Local Storage Management (~20%)

| Objective | Project | Node | Status |
|-----------|---------|------|--------|
| GPT/MBR partitioning | 05 | node3 | :bi-square: |
| ext4/XFS formatting | 05 | node3 | :bi-square: |
| fstab persistent mounts | 05 | node3 | :bi-square: |
| Swap management | 05 | node3 | :bi-square: |

## 6. Basic Networking & Remote Storage (~25%)

| Objective | Project | Node | Status |
|-----------|---------|------|--------|
| Static IPv4/IPv6 | 06 | node2 | :bi-square: |
| /etc/hosts and DNS | 06 | node2 | :bi-square: |
| SSH server hardening | 06, 09 | node2/node3 | :bi-square: |
| NFS / SSHFS mounts | 06 | node1 | :bi-square: |

## 7. Advanced Infrastructure & Traffic Control

| Objective | Project | Node | Status |
|-----------|---------|------|--------|
| Bonding/teaming | 07 | node2 | :bi-square: |
| Firewall rules | 07, 09 | node2/node3 | :bi-square: |
| NAT / masquerade | 07 | node2 | :bi-square: |
| Port redirection | 07 | node2 | :bi-square: |
| NTP/Chrony sync | 07 | node2 | :bi-square: |

## 8. Automation & Scheduling

| Objective | Project | Node | Status |
|-----------|---------|------|--------|
| Bash scripting | 08, 09 | um690 | :bi-square: |
| cron scheduling | 08, 09 | um690 | :bi-square: |
| at daemon | 08 | um690 | :bi-square: |

## 9. Capstone Integration

| Objective | Project | Node | Status |
|-----------|---------|------|--------|
| Containerized service | 09 | node3 | :bi-square: |
| Tailnet-only access | 09 | node3 | :bi-square: |
| Reboot survivability | 09 | node3 | :bi-square: |
| Automated validation | 09 | um690 | :bi-square: |

---

**Update legend:** :bi-square: not started | :bi-arrow-repeat: in progress | :bi-check-circle-fill: confident (passed reboot test)

Copy a row to study-journal when complete:
```
OBJECTIVE DONE: SSH hardening — Project 06 node2 — reboot verified 2026-06-20
```