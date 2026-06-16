# AIOS Education IDE (`aios-ed`)

**LFCS exam prep daily-driver** — dashboard, Ara tutor, workspace IDE, Mullvad lab browser.  
**GitHub:** [DestroyTheKraken/aios-os](https://github.com/DestroyTheKraken/aios-os.git)  
**Progress:** see [PROGRESS.md](./PROGRESS.md)  
**Design:** [guides/AIOS_SYSTEM_DESIGN.md](./guides/AIOS_SYSTEM_DESIGN.md)

---

# LFCS Learning Objectives & Study Guide

**Last Update:** June 16, 2026  
**Created By:** Joshua Hickman

---

## Directory Structure

```
aios-ed/                               # unified repo (was LFCS + AIOS)
├── PROGRESS.md                        # implementation status
├── AGENTS.md                          # Grok mentor scope
├── .grok/                             # product rules + theme attachments
├── README.md                          # This file
├── guides/                            # Learning environment docs
│   ├── GETTING_STARTED.md             # Start here
│   ├── CLUSTER_MAP.md                 # Node roles (um690 + 3 nodes)
│   ├── CLUSTER_INVENTORY.md           # Auto-scanned asset list
│   ├── DAILY_STUDY_PROTOCOL.md        # Session rules
│   ├── PROJECT_ROADMAP.md             # 45-day schedule overview
│   └── OBJECTIVES_TRACKER.md          # Exam objective checklist
├── Study_Projects/                    # Project outlines 00–09
├── portal/                            # Learning dashboard (nginx www)
├── automation/
│   ├── lfcs-backend-deploy.sh         # ONE-SHOT (primary): deploy full tablet backend
│   ├── lfcs-portal-build.sh           # Rebuild portal HTML from schedule
│   ├── lfcs-cluster-scan.sh           # Discover live tailnet assets
│   ├── lfcs-daily-guidance.sh         # Daily notice + portal refresh
│   ├── install-daily-cron.sh          # Schedule 07:00 notifications
│   └── secure-browser-forge.sh        # Project 09 interactive deploy
├── schedule/daily-schedule.json       # 45-day structured program
├── inventory/cluster.json             # Live scan output (JSON)
├── notifications/
│   ├── latest-daily-guidance.txt      # Today's study notice
│   ├── daily/YYYY-MM-DD.md            # Archived daily notices
│   └── study-journal.log              # Your completion log
├── docker/docker-compose.yml
└── validation/VALIDATION.md
```

**Tablet backend (deploy once):** `sudo automation/lfcs-backend-deploy.sh`

**Daily workflow:** Portal `http://100.81.13.95:3080` → Mullvad Browser `https://100.81.13.95:3001` → SSH lab node → log to `study-journal.log`.

See `guides/TABLET_QUICKSTART.md`.

---

## Learning Environment (live inventory — June 2026)

| Host | Tailscale IP | LAN IP | OS | RAM | LFCS Role |
|------|-------------|--------|----|-----|-----------|
| **um690** | 100.81.13.95 | 192.168.68.100 | Ubuntu 24.04 | 60 GB | Control plane — docs, cron, scripts |
| **node1** | 100.75.124.36 | 192.168.68.101 | Ubuntu 24.04 | 15 GB | Primary worker — Docker active |
| **node2** | 100.104.54.20 | 192.168.68.102 | Ubuntu 26.04 | 7 GB | Edge gateway — firewall/NAT |
| **node3** | 100.82.177.52 | 192.168.68.103 | Ubuntu 26.04 | 15 GB | Storage + Project 09 capstone |
| **j-tab** | 100.75.74.14 | — | Android | — | Termius admin console (tablet) |

Re-scan anytime: `./automation/lfcs-cluster-scan.sh` → updates `guides/CLUSTER_INVENTORY.md`

**Network:** Starlink + Deco (`192.168.68.0/22`). **NAS:** `/mnt/XstorA` (symlink `/home/kraken/XDrive`).

**Note:** Nodes run Ubuntu; LFCS skills transfer — use `apt` not `dnf`. See `guides/CLUSTER_MAP.md`.

---

## Exam Objectives & Sub Objectives

### 1. Baseline System Interaction

* Log into Linux systems both locally and over secure networks.
* Manipulate files and directories effectively (creating, deleting, copying, moving, and searching).
* Utilize hard and soft links to structure files and optimize storage access.

### 2. Text Manipulation & Data Filtering

* Process text streams using commands like grep, sed, awk, cut, and regular expressions.
* Manage archive and compression files using tar, gzip, and bzip2.
* Analyze system logs and configure logging infrastructure to troubleshoot system anomalies.

### 3. Permissions & Identity Management

* Manage user accounts and local groups (creation, modification, deletion).
* Configure system-wide environment profiles and variables globally or per user.
* Control root access securely using the sudo configuration matrix.
* Implement advanced permissions including Access Control Lists (ACLs) and special attributes like SUID/SGID.

### 4. Core System Operations

* Manage startup processes and services using systemd (starting, stopping, enabling, and disabling).
* Diagnose and manage processes using utilities like ps, top, kill, and nice.
* Enforce resource limits to restrict user processes and storage allocation.
* Adjust kernel runtime parameters dynamically using sysctl.

### 5. Local Storage Management

* Manage physical storage devices, layout partition tables (GPT/MBR), and swap spaces.
* Create and format filesystems (e.g., ext4, XFS) and maintain persistent mount configurations in /etc/fstab.

### 6. Basic Networking & Remote Storage

* Configure IPv4 and IPv6 network interfaces and static routing.
* Manage hostname resolution by configuring local hosts files and DNS settings.
* Secure remote access by managing SSH servers and client configurations.
* Mount remote filesystems securely using protocols such as NFS and SSHFS.

### 7. Advanced Infrastructure & Traffic Control

* Implement bridge and bonding network devices for redundancy and performance.
* Configure Network Block Devices (NBD) and handle storage performance monitoring.
* Apply packet filtering and firewall rules to control traffic (e.g., using iptables or nftables).
* Configure port redirection, Network Address Translation (NAT), and reverse proxies.
* Deploy load balancers and maintain system time synchronization using NTP or Chrony.

### 8. Automation & Scheduling

* Automate system maintenance tasks by writing and executing shell scripts.
* Schedule recurring tasks utilizing cron and at daemons.

---

## Study Guide Projects

This breakdown verifies and validates all 9 proposed learning path projects. Each project explicitly maps to real LFCS Exam Scenarios, provides Exact Expected Deliverables (proving persistence across reboots, which is critical for the actual test), and references the official Linux Foundation Objectives.

### Project 00 - The Internal Documentation Matrix

[**Project Outline:**](Study_Projects/00.md)
Before writing any configuration files or partitioning disks, you must build the skills to pull down exact command syntax under pressure. This foundational project ensures you can find any flag, configuration file template, or system path using only the local tools allowed in the live LFCS exam sandbox.

### Project 1: Baseline System Interaction

[**Project Outline:**](Study_Projects/01.md)
* LFCS Domain / Objective: Essential Commands (20%) — Log into systems, manipulate files/directories, use hard/soft links.
* LFCS Exam-Style Scenario: You are asked to log into a remote worker node, build a standardized deployment workspace directory structure, and map absolute configuration files locally using links to prevent redundancy.
* Validation & Persistent Deliverables:
* Create folder structure /projects/archive/2026/ using a single command string (mkdir -p).
   * Establish a symbolic link at /home/admin/shortcut_conf pointing to a file tucked deep in the directory tree.
   * Verify that a hard link created in /tmp/ maintains file content accuracy even if the original target is moved.

### Project 2: Text Manipulation & Data Filtering

[**Project Outline:**](Study_Projects/02.md)
* LFCS Domain / Objective: Essential Commands (20%) & Operations & Deployment (25%) — Process text streams, use regex, isolate/analyze system log files.
* LFCS Exam-Style Scenario: A security incident occurred on a node. Without using a GUI, extract all failed SSH login attempts from the log streams, isolate unique perpetrator IP addresses, and compress the evidence.
* Validation & Persistent Deliverables:
* Extract rows containing "Failed password" from /var/log/auth.log or /var/log/secure.
   * Use grep, awk, or sed to strip text, outputting only raw IP addresses to a file named /tmp/threat_actors.txt.
   * Package the filtered result using tar -czvf /backup/incident.tar.gz.

### Project 3: Permissions & Identity Management

[**Project Outline:**](Study_Projects/03.md)
* LFCS Domain / Objective: Users and Groups (10%) — Create/manage users/groups, manage environment profiles, configure ACLs and sudo.
* LFCS Exam-Style Scenario: Configure a shared directory for a new engineering team. Members must have collaborative read/write permissions, non-members must have no access, and newly created files must automatically lock to the team's group ID.
* Validation & Persistent Deliverables:
* New group dev_dept and user accounts created with specified home directories.
   * Directory /shared/dev/ configured with chmod 2770 (SGID bit active), giving group ownership persistence.
   * Specialized permissions verified via getfacl to ensure an explicit user audit account can inspect files without joining the group.
   * Sudo configurations placed in /etc/sudoers.d/dev_admin passing strict visudo compilation checks.

### Project 4: Core System Operations

[**Project Outline:**](Study_Projects/04.md)
* LFCS Domain / Objective: Operations & Deployment (25%) — Manage systemd services, runtime/persistent kernel parameters, diagnose processes.
* LFCS Exam-Style Scenario: Deploy a custom system application daemon, ensure it launches cleanly on system boot, throttle resource limits, and optimize kernel network responsiveness.
* Validation & Persistent Deliverables:
* A custom service unit file compiled successfully at /etc/systemd/system/myapp.service.
   * Service active, running, and validated via systemctl is-enabled showing enabled across system reboots.
   * Configured system-wide execution thresholds in /etc/security/limits.conf to cap max user processes.
   * Persistent kernel tweaks appended to /etc/sysctl.d/99-sysadmin.conf and verified alive post-reboot via sysctl -a.

### Project 5: Local Storage Management

[**Project Outline:**](Study_Projects/05.md)
* LFCS Domain / Objective: Storage (20%) — Configure filesystems, manage swap spaces, implement persistent mounts.
* LFCS Exam-Style Scenario: A new raw secondary disk block has been assigned to your instance. Partition it via GPT, format it with an optimized filesystem, allocate dynamic swap space, and mount it ensuring it survives system crashes.
* Validation & Persistent Deliverables:
* A valid GPT partition table created on the secondary block device (/dev/vdb or /dev/sdb).
   * Drive space partition formatted with an XFS or Ext4 filesystem.
   * Partition entry declared inside /etc/fstab using its permanent hardware UUID format (validated risk-free via mount -a before rebooting).
   * Active auxiliary swap partition added and validated via swapon --show.

### Project 6: Basic Networking & Remote Storage

[**Project Outline:**](Study_Projects/06.md)
* LFCS Domain / Objective: Networking (25%) & Storage (20%) — Configure static network addresses, hostname resolution, OpenSSH configurations, use remote filesystems.
* LFCS Exam-Style Scenario: Onboard a pristine server instance by assigning static IP infrastructure coordinates, mapping internal host naming paths, locking down SSH remote administration rules, and attaching an NFS storage block.
* Validation & Persistent Deliverables:
* Interface adapter persistent profiles written (via nmcli or netplan) validating active status and static IP routes.
   * Local lookups resolved permanently by updating /etc/hosts configurations.
   * Root remote access blocked by executing PermitRootLogin no modifications inside /etc/ssh/sshd_config.
   * External network export attached cleanly under /mnt/remote_share/ matching system startup boot targets.

### Project 7: Advanced Infrastructure & Traffic Control

[**Project Outline:**](Study_Projects/07.md)
* LFCS Domain / Objective: Networking (25%) — Configure packet filtering, port redirection, NAT, interface bonding, load balancing.
* LFCS Exam-Style Scenario: Turn an edge server instance into a secure perimeter firewall gateway that aggregates network interfaces for high availability, redirects ports to background tiers, and masks internal networks.
* Validation & Persistent Deliverables:
* A combined network bond master (bond0) created with secondary physical slave devices operating in high-availability mode.
   * Kernel forwarding set to persistent via /etc/sysctl.conf (net.ipv4.ip_forward = 1).
   * Native stateful firewall rule tables (nftables or firewalld) active, dropping all ingress traffic while masquerading internal outbound packets (NAT).
   * Port redirection forward rule deployed shifting external network packets directed at port 8080 safely inside to localized port variables.

### Project 8: Automation & Scheduling

[**Project Outline:**](Study_Projects/08.md)
* LFCS Domain / Objective: Operations & Deployment (25%) — Use scripting to automate system maintenance, schedule cron/at tasks.
* LFCS Exam-Style Scenario: Write an automated, error-tolerant bash script that dynamically monitors server disk availability, packages logs, and schedules it to run automatically every night at midnight.
* Validation & Persistent Deliverables:
* A modular, executable script placed at /usr/local/bin/sysmaintenance.sh starting with #!/bin/bash.
   * Script uses validation syntax constraints (set -e, set -u) to catch runtime configuration drops.
   * Custom configurations established in /etc/crontab or crontab -e running exactly at 0 0 * * *.
   * Operational cron output validated via testing pathways by examining logs or script output.

### Project 9: Secure Remote Access & Containerized Service Platform (Secure Browser Forge)

[**Project Outline:**](Study_Projects/09.md)
* LFCS Domain / Objective: Capstone — Networking (25%), Operations & Deployment (25%), Users & Groups (10%), Storage (20%), Essential Commands (20%).
* LFCS Exam-Style Scenario: Deploy `linuxserver/mullvad-browser` via Docker Compose on a Rocky Linux node. Restrict access to the Tailscale tailnet using firewalld rich rules, harden SSH, enforce web authentication, and produce auditable validation evidence that survives reboot.
* Validation & Persistent Deliverables:
* Interactive deploy script at `automation/secure-browser-forge.sh` (idempotent, teaching comments).
   * Docker Compose stack at `docker/docker-compose.yml` with tailnet-only port binding and `restart: unless-stopped`.
   * `forgesvc` service account with validated `/etc/sudoers.d/` and PUID/PGID volume mapping.
   * SSH drop-in at `/etc/ssh/sshd_config.d/99-lfcs-forge.conf` with `PermitRootLogin no`.
   * firewalld rich rule: TCP 3001 from `100.64.0.0/10` on `tailscale0` only.
   * systemd unit `secure-browser-forge.service` enabled for boot persistence.
   * Auto-generated `validation/VALIDATION.md` with timestamped command evidence.
   * Post-reboot: all checks pass via script option 4 without re-deploying.

**Quick start (Termius):**
```bash
cd /home/kraken/Projects/aios-ed/automation
sudo ./secure-browser-forge.sh
```