# Phase 2 status — COMPLETE

| Field | Value |
|-------|--------|
| **Updated** | 2026-07-11 |
| **Status** | **Complete** on um690 + node1 + node2 |

## Linux users (all nodes)

| User | UID | GID | Groups |
|------|-----|-----|--------|
| joshua | 2001 | 2001 | joshua, aide-nas |
| vtech | 2002 | 2002 | vtech, aide-nas |
| kraken | 1000 | 1000 | … + aide-nas |

Passwords set on nodes (optional polish).

## NFS

| Host | Mount |
|------|--------|
| um690 | local btrfs `/dev/sda1` → `/mnt/systems_admin` |
| node1 | `192.168.20.100:/mnt/systems_admin` nfs4 → `/mnt/systems_admin` (+ fstab, daemon-reload) |
| node2 | same |

## k8s namespaces

`platform` / `vtech` / `family` with `aide-tenant-info` ConfigMaps.

## NAS tenant dirs

| Path | Owner |
|------|--------|
| `/mnt/systems_admin/joshua/` | joshua:joshua |
| `/mnt/systems_admin/vtech/` | vtech:vtech |
| `/mnt/systems_admin/kraken/` | kraken:kraken |

Server ACLs: joshua rwx on NAS root. Workers may have `acl` package installed for local tools; authoritative ACLs are on um690 btrfs.

## Still manual / later

- Nextcloud users/groups matching kraken, vtech, joshua
- Phase 3: consolidate data into tenant trees (nathon → joshua, etc.)

## Safety net

`/mnt/systems_admin/um690/COMPLETE-BACKUP-20260710-172254/`
