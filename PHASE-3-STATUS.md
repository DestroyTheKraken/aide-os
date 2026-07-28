# Phase 3 status — COMPLETE

| Field | Value |
|-------|--------|
| **Finished** | 2026-07-11 07:50 (um690) |
| **Log** | `/mnt/systems_admin/um690/phase3-consolidate-20260711-073450.log` |
| **Nathon sums** | `/mnt/systems_admin/um690/phase3-nathon-checksums.txt` |

## Tenant tree sizes (from script)

| Path | Size | Owner |
|------|------|--------|
| `/mnt/systems_admin/kraken/` | 5.7M | kraken |
| `/mnt/systems_admin/joshua/` | **174G** | joshua |
| `/mnt/systems_admin/vtech/` | **651M** | vtech |
| `/mnt/systems_admin/archive/` | 18M | kraken |

Disk: **569G used / 1.4T free** on systems_admin (was ~394G before consolidate).

## What was copied

### kraken/
- reports, restic, designs, platform/SovereignAid (from prior partial + script)

### joshua/
- HICKMAN_ROOT (mnt + home merge, including Nathon content under HICKMAN during merge)
- Backups/Nathon/nathon-bak-2026.tar.gz (**canon**)
- batocera_management (mnt + home OS ISOs: Rocky, Win11, Mint)
- media/Pictures

### vtech/
- valley-tech-support/ (full mirror of `~/Documents/valley-tech-support`)

### archive/AIDE_OS-precursors/
- aios-ed (Projects + Documents)
- ARA
- Sovereign-Mesh-IDE.md, Sovereign FileManagement.md

## Nathon policy

| Location | Status | SHA256 |
|----------|--------|--------|
| **joshua/Backups/Nathon/** | **CANON — keep** | `b5e46db9…f3aaba` |
| mnt `Backups/Nathon/` | LEGACY duplicate (still present) | same |
| home `HICKMAN_ROOT/Nathon/` | **REMOVED** (verified dup) | matched before delete |

## LEGACY still on NAS root (sources kept on purpose)

These remain until you explicitly want a cleanup pass (Phase 3b):

- `/mnt/systems_admin/HICKMAN_ROOT`
- `/mnt/systems_admin/batocera_management`
- `/mnt/systems_admin/Backups/Nathon` (second nathon copy)
- `/mnt/systems_admin/reports`, `restic`, `Pictures`
- `~/systems_admin` (minus home nathon) — still legacy mirror of most content

**Do not bulk-delete legacy until:** dual-boot of apps, batocera, and family access confirmed from tenant paths.

## Working canons (home disk — unchanged)

| Path | Role |
|------|------|
| `~/SovereignAid` | Platform daily |
| `~/Documents/valley-tech-support` | Business daily (also mirrored under vtech/) |
| `~/AIDE_OS` | Brand + glossary |

## Optional Phase 3b (later)

1. Confirm family tools read `joshua/` paths  
2. Remove legacy mnt nathon only:  
   `sudo rm /mnt/systems_admin/Backups/Nathon/nathon-bak-2026.tar.gz`  
   (only after joshua copy re-checked)  
3. Retire or thin `~/systems_admin` and root-level HICKMAN/batocera  
4. Nextcloud map folders → tenant trees  

## Phase 4 (next major)

Grok multi-user: memory on, YOLO lock kraken+vtech, project packs, git init teaching.
