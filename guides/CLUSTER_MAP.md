# LFCS Cluster Map — Node Roles & Project Assignments

## Control Plane: um690

**Tailscale:** 100.81.13.95 | **LAN:** 192.168.68.100

**Responsibilities:**
- Hosts `/home/kraken/Projects/aios-ed/` (all guides, scripts, schedules)
- Runs daily guidance cron (07:00 America/Chicago)
- Authoring environment for Project 08 bash scripts
- man/info practice for Project 00
- microk8s + lxd available (Course 2 — not LFCS exam scope)

**Do not:** Run heavy container workloads here during node labs — keep it as orchestration HQ.

**Time sync:** Run `sudo ./automation/lfcs-chrony-setup.sh` on each node (PR 19). Target skew &lt;100ms before exam drills.

---

## Primary Worker: node1

**Tailscale:** 100.75.124.36 | **LAN:** 192.168.68.101

| Spec | Value |
|------|-------|
| OS | Ubuntu 24.04 LTS |
| RAM | 15 GB |
| CPU | Intel i5-4570T (4 cores) |
| Disk | 238 GB SK hynix SSD |
| Docker | **Active** |

**Assigned projects:** 01, 04, 06 (partial), 09 cross-node validation

**Best for:** systemd units, directory labs, docker-compose until node3 is provisioned, process management.

---

## Edge Gateway: node2

**Tailscale:** 100.104.54.20 | **LAN:** 192.168.68.102

| Spec | Value |
|------|-------|
| OS | Ubuntu 26.04 LTS |
| RAM | 7 GB (lightweight only) |
| CPU | 4 cores |
| Docker | Inactive |

**Assigned projects:** 06 (networking), 07 (firewall, NAT, port forward)

**Best for:** firewalld/ufw rules, sysctl ip_forward, bonding simulations. Avoid memory-heavy containers.

---

## Storage & Forge: node3

**Tailscale:** 100.82.177.52 | **LAN:** 192.168.68.103

| Spec | Value |
|------|-------|
| OS | Ubuntu 26.04 LTS |
| RAM | 15 GB |
| CPU | 4 cores |
| Docker | Not yet active (install during Project 09) |

**Assigned projects:** 03 (users/groups), 05 (storage), 09 (capstone)

**Best for:** GPT partitioning, fstab, ACLs, Secure Browser Forge capstone.

---

## Admin Clients

| Device | Tailscale | Use |
|--------|-----------|-----|
| j-tab (Tab S10 Ultra) | 100.75.74.14 | **Primary** — Termius SSH (exam simulation) |
| j-phn (S23+) | 100.100.196.29 | Backup SSH |
| um690 desktop | local | Direct terminal when at desk |

---

## Network Topology

```
Internet (Starlink)
       │
  [Deco Router 192.168.68.1]
       │
  ┌────┴────────────────────────────┐
  │     192.168.68.0/22 LAN         │
  │  um690 (.100)                   │
  │  node1 (.101)  node2 (.102)     │
  │  node3 (.103)                   │
  └────┬────────────────────────────┘
       │ tailscale0 (100.x mesh)
       │
  j-tab, j-phn, remote access
```

**br-lfcs** on um690 (192.168.100.0/24): isolated bridge for advanced networking labs — bring up when Project 07 needs it.

---

## Ubuntu ↔ LFCS Exam Translation

| Rocky/RHEL (exam docs) | Your Ubuntu nodes |
|------------------------|-------------------|
| `dnf install` | `apt install` |
| `firewalld` | `ufw` or `apt install firewalld` |
| `/var/log/secure` | `/var/log/auth.log` |
| `chrony` | `systemd-timesyncd` or `chrony` |
| Podman | Docker (Project 09 — exam accepts either) |