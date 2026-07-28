# Verification summary (Phase 0–3) + Phase 4 applied for kraken

**Date:** 2026-07-11

## Copy / consolidate verification

| Check | Result |
|-------|--------|
| External NAS `/mnt/systems_admin` (sda1 btrfs) | OK |
| Complete backup `um690/COMPLETE-BACKUP-*` (~272G) | OK |
| `kraken/reports` byte-match source | OK (2676) |
| `kraken/restic` byte-match source | OK |
| `kraken/platform/SovereignAid` byte-match | OK |
| `joshua/` size ~174G after Phase 3 | OK (script log) |
| `vtech/` ~651M VTS mirror | OK (script log) |
| `archive/AIDE_OS-precursors` (aios-ed, ARA, …) | OK (listable) |
| Nathon SHA256 all copies match `b5e46db9…` | OK |
| Home nathon removed after verify | OK |
| Legacy root HICKMAN/batocera still present | OK (by design) |
| Tenant owners joshua/vtech/kraken | OK |
| Base ACL joshua:rwx | OK |
| k8s NS platform/vtech/family | OK |
| Users 2001/2002 on um690 | OK |
| NFS node1/node2 | **Remounted** this session (was unmounted after reboot) |

### Permissions vs plan

| Plan | Actual |
|------|--------|
| joshua owns `joshua/` private | **Yes** (750) — kraken cannot cd without ACL break-glass |
| vtech owns `vtech/` | **Yes** |
| kraken platform tree | **Yes** |
| joshua full NAS walk (ACL) | **Yes** on base |

**Note:** kraken cannot browse `joshua/` until break-glass ACL is applied (script includes it when you run tenant install).

## Phase 4 (kraken) — applied this session

| Item | Path |
|------|------|
| Config security floor | `~/.grok/config.toml` (yolo=false, permission_mode=default, plugins=superpowers only, deny/ask lists) |
| YOLO hard-lock | `~/.grok/requirements.toml` |
| Global AGENTS | `~/.grok/AGENTS.md` |
| PreToolUse nuclear block | `~/.grok/hooks/dangerous-bash.json` + scripts/ |
| Skills | `smadp-ops`, `context-switch` |
| Project AGENTS | `~/SovereignAid/AGENTS.md`, `~/Documents/valley-tech-support/AGENTS.md` |
| Config backup | `/mnt/systems_admin/kraken/designs/grok-config-backup-*` |

### Still needs sudo once

```bash
sudo bash /mnt/systems_admin/um690/phase4-install-tenant-grok.sh
```

Installs `.grok` for **vtech** (YOLO locked) and **joshua** (freer), AGENTS.md, and `setfacl u:kraken:rx` on tenant NAS dirs so you can browse as kraken.
