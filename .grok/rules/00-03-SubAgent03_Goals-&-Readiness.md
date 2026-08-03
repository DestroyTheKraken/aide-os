# Goals & Readiness — AIOS Education IDE

**Updated:** June 15, 2026 | **Focus:** LFCS MVP (education only)

## Primary Objectives

1. Tab S10 Ultra daily-driver via AIOS Dashboard + LFCS 45-day cycle
2. **Ara** as sole tutor — personalized via `ara_tutor/`
3. Deliberate LFCS weak-area practice
4. Clean tool separation; reproducible Docker Compose on um690

## Success = 

Dashboard → today's lesson + cluster + workspace + Ara. Tailnet-secure. ≥70% LFCS checklist closed by Dec 2026. RAG-backed Ara. Education proven before any other vertical.

## Non-Goals

Custom native IDE, external cloud AI in dashboard, public service exposure, corporate/music (deferred).

## June 2026 Milestones

- Dashboard + 45-day nav live
- Ara on CPU (~5s replies); sidebars responsive
- `ara_tutor/` scaffold with learner profiles

## LFCS Checklist

**Operations 25%**
- [x] Packages/repos
- [~] Containers (compose daily; deepen drills)
- [ ] Kernel params, processes, jobs, VM, SELinux, recovery

**Networking 25%**
- [x] OpenSSH
- [ ] IP/DNS, chrony, monitor, firewall, NAT, routing, bridge/bond, reverse proxy

**Storage 20%**
- [x] Create filesystems
- [ ] LVM, VFS, troubleshoot, remote FS, swap, automount, perf

**Essential Commands 20%**
- [x] Services, app constraints
- [ ] Git, perf monitor, diskspace, SSL

**Users 10%**
- [x] Accounts, profiles
- [ ] Limits, ACLs, LDAP

## Command Levels

- **Strong:** ls, cd, mkdir, rm, sudo, apt, ssh, pipes, redirects, nano, vim
- **Basic:** scp, systemctl, ufw, chmod, useradd, man, top, ip, curl, docker compose
- **Weak:** awk, sed, find, grep, compose files, git

## Next Actions

1. RAG: index `ara_tutor` → attach to Ara
2. Populate `knowledge/linux|networking/`
3. Summarize user-profile PDFs for Ara
4. Inject program-day from `daily.json`
5. PWA install shell on tablet/Chromebook