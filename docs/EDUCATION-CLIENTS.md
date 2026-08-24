# GrokAide Education clients

**Platform:** um690 (`joshua`) + `~/AIDE_OS` / `~/Projects`  
**Track:** Learn Linux System Administration — LFCS objective-aligned + Canonical Ubuntu practice  

## Roles

| Role | Where | Notes |
|------|--------|------|
| Platform | um690 Ubuntu Studio | Author content, GrokBuild, Multipass host |
| Education client | Multipass VM `grokaide-edu` | Primary disposable lab seat |
| Hardware LFCS | node1 `.101` (`kraken@`) | Mesh worker; schedule labs so they do not fight cluster work |
| Console seat | **retired** | fam-media hardware is now **node3** `.103` |

## Multipass client (MVP)

```bash
# Status
multipass list

# Shell into education client
multipass shell grokaide-edu

# Curriculum (when mounted)
ls /mnt/aide-os/Study_Projects
ls /mnt/aide-os/guides/OBJECTIVES_TRACKER.md
```

### Provision summary (platform)

- Image: Ubuntu **26.04** cloud (Server-class) via Multipass  
- Name: `grokaide-edu`  
- Resources: 2 vCPU · 4 GiB RAM · 32 GiB disk (adjust as needed)  
- Mount: `~/AIDE_OS` → `/mnt/aide-os`  
- Grok CLI: **platform only** (not required inside client)

### Day-1 learner flow

1. On platform: `multipass shell grokaide-edu`  
2. Read `/mnt/aide-os/Study_Projects/00.md` (or `01.md`)  
3. Work only inside the client for destructive labs  
4. Reset: delete/recreate instance or restore snapshot when available  

## Curriculum map

| Asset | Path on platform | On client (mounted) |
|-------|------------------|---------------------|
| Study projects | `~/AIDE_OS/Study_Projects/` | `/mnt/aide-os/Study_Projects/` |
| Objectives | `~/AIDE_OS/guides/OBJECTIVES_TRACKER.md` | `/mnt/aide-os/guides/...` |
| LFCS vault | `~/AIDE_OS/brain/bootcamp/lfcs/` | `/mnt/aide-os/brain/bootcamp/lfcs/` |
| Games | `~/AIDE_OS-games/` | optional second mount |

## Canonical Ubuntu focus

Prefer distro-native tools in labs: Netplan, systemd, apt, OpenSSH, UFW, journalctl, cloud-init (client first boot).

## node1 / node2

**Approved path:** reimage **node1** with **Edubuntu 26.04** from PNY USB.

- Runbook: [labs/NODE1-EDUBUNTU-REIMAGE.md](./labs/NODE1-EDUBUNTU-REIMAGE.md)
- After first boot: `ssh node1` (user `kraken`, key `~/.ssh/id_ed25519`)
- Do **not** use the retired `id_ed25519_edu` key

## Console / display

| IP | Host | Role |
|----|------|------|
| **192.168.20.100:8765** | um690 | AIDE console (when `python3 -m http.server 8765` is running) |
| 192.168.20.109 | samsung | Display only |

fam-media `.111` is retired. Dashboard: `~/AIDE_OS/console/` — serve on um690.

## Non-goals

- Nested k3s in education VMs  
- HickMedia / RetroArch on clients  
- School district SKU packaging  
