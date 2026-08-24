# Bring-up: Multipass client `grokaide-edu`

| Field | Value |
|-------|--------|
| **Created** | 2026-08-10 |
| **Platform** | um690 · Ubuntu Studio · user `joshua` |
| **Client** | Multipass `grokaide-edu` · Ubuntu **26.04 LTS** (cloud/Server) |
| **Resources** | 2 vCPU · 4 GiB RAM · 32 GiB disk |
| **Curriculum mount** | host `~/AIDE_OS` → guest `/mnt/aide-os` |
| **Games mount** | host `~/AIDE_OS-games` → guest `/mnt/aide-os-games` (optional) |

## Quick commands (platform)

```bash
multipass list
multipass shell grokaide-edu
# recreate later:
# multipass delete grokaide-edu && multipass purge
# bash ~/AIDE_OS/scripts/multipass/launch-grokaide-edu.sh
```

## First lab session

```bash
multipass shell grokaide-edu
less /mnt/aide-os/Study_Projects/00.md
less /mnt/aide-os/guides/OBJECTIVES_TRACKER.md
```

Do **destructive** work only inside the client.

## Snapshot

| Name | Notes |
|------|--------|
| `grokaide-edu.golden-edu` | Taken 2026-08-10 after first boot + mounts |

```bash
# Restore clean lab (stops instance; remount if needed after)
multipass stop grokaide-edu
multipass restore grokaide-edu.golden-edu   # confirm syntax: multipass help restore
multipass start grokaide-edu
```

## Re-provision

```bash
bash ~/AIDE_OS/scripts/multipass/launch-grokaide-edu.sh
```

Cloud-init: `scripts/multipass/grokaide-edu-cloud-init.yaml`

## Architecture

See [EDUCATION-CLIENTS.md](../EDUCATION-CLIENTS.md) and [FLAVOR-BASES.md](../FLAVOR-BASES.md).

**Grok** stays on the platform (`cd ~/AIDE_OS && grok`). Client is for hands-on Ubuntu/LFCS practice.
