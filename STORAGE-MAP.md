<!-- Focus: /mnt/systems_admin/shared/memory/SYSTEM-FOCUS.md (2026-07-16) -->

# STORAGE-MAP — Phase 1 read-only inventory

| Field | Value |
|-------|--------|
| **Date** | 2026-07-10 |
| **Host** | um690 |
| **Status** | Inventory complete — **no files moved or deleted** |
| **Complete backup** | `/mnt/systems_admin/um690/COMPLETE-BACKUP-20260710-172254/` |
| **USB fitted** | `/run/media/kraken/Ventoy/AIDE-PRE-REORG-BACKUP-20260710-152918.tar.gz` (if still present) |

---

## 1. Executive summary

| Finding | Detail |
|---------|--------|
| Dual trees | `~/systems_admin` (nvme) and `/mnt/systems_admin` (sda1 btrfs “systems_admin”) are **nearly the same file set** |
| Path overlap | **22,409** paths in both; **11** home-only; **8** mnt-only |
| Content drift | Of shared files: **22,408 same size**, **1 size-diff** (DTK field-kit README) |
| Nathon | Same SHA256 on home HICKMAN path and mnt Backups path — **verified duplicates** |
| Batocera | Home has **extra OS ISOs** (~12G gap vs mnt); ROM trees largely shared paths |
| Canon intent | Working canons on **home disk**; durable NAS under **user roots** after Phase 2–3 |
| `~/systems_admin` | **Legacy / redundant mirror** — candidate to retire after consolidate (Phase 3) |

---

## 2. Volume map

| Mount / path | Device | FS | Role today | Role after reorg (planned) |
|--------------|--------|-----|------------|----------------------------|
| `/` home | nvme0n1p2 | ext4 | Active work: SovereignAid, VTS, `.grok`, local systems_admin | **Working canons** for platform + business projects |
| `/mnt/systems_admin` | sda1 | btrfs | Durable admin + media + nathon + **um690 backups** | **NAS-style durable store**; root → `kraken/` `joshua/` `vtech/` later |
| Nextcloud / Longhorn | cluster | — | Family/business cloud UX | Family + vtech data UX (TS + Nextcloud) |
| Ventoy 32GB USB | sde1 | exFAT | Fitted tarball only | Offline secondary (not full) |

**Free space (inventory time):** systems_admin disk ~1.5T free after complete backup (~394G used).

---

## 3. Dual `systems_admin` analysis

### 3.1 Top-level sizes

| Child | `~/systems_admin` | `/mnt/systems_admin` | Notes |
|-------|-------------------|----------------------|--------|
| batocera_management | **97G** | **85G** | Home has 3 extra OS ISOs (Rocky, Win11, Mint) |
| HICKMAN_ROOT | **40G** | **2.2G** | Home holds **Nathon/** (38G); mnt does not |
| Backups | 6.9M | **38G** | Mnt holds **Nathon/nathon-bak** (38G) |
| Pictures | 6.4M | 6.3M | Same paths |
| longhorn | empty | empty | Placeholder |
| restic | — | 5.2M | **Mnt-only** restic smadp repo |
| reports | — | 4K | **Mnt-only** health report |
| um690 | — | **272G** | Complete backup (exclude from “original content”) |

### 3.2 File path overlap (excluding `um690/`)

| Metric | Count |
|--------|------:|
| Files under home systems_admin | 22,420 |
| Files under mnt (no um690) | 22,417 |
| Same relative path on both | **22,409** |
| Home-only paths | **11** |
| Mnt-only paths | **8** |
| Shared files same size | **22,408** |
| Shared files different size | **1** |

### 3.3 Home-only paths (must merge into mnt/user trees before dropping home mirror)

| Path | Class |
|------|--------|
| `Backups/grok-config/designs/*` (5 design docs + script) | **Keep** → kraken durable + AIDE docs |
| `HICKMAN_ROOT/Nathon/nathon-bak-2026.tar.gz` | **Critical** — hash matches mnt Backups copy |
| `HICKMAN_ROOT/Joshua/Projects/nc-lin-cs/phase-docs/*` (2 md) | Joshua/family |
| `batocera_management/os-iso/{Rocky,Win11,Mint}.iso` | Media/ISOs — joshua or family |

### 3.4 Mnt-only paths (already durable)

| Path | Class |
|------|--------|
| `Backups/Nathon/nathon-bak-2026.tar.gz` | Critical brother backup (canonical NAS location candidate) |
| `reports/smadp-health-2026-07-08.md` | Platform ops → kraken |
| `restic/smadp/*` | Platform backup repo → kraken |

### 3.5 Nathon policy status

| Copy | Path | SHA256 |
|------|------|--------|
| Home live | `~/systems_admin/HICKMAN_ROOT/Nathon/nathon-bak-2026.tar.gz` | `b5e46db9bea409fb141c401a8be8edd83aed30b158aa308174e907b44ff3aaba` |
| Mnt live | `/mnt/systems_admin/Backups/Nathon/nathon-bak-2026.tar.gz` | **same** |
| Complete backup (×2) | under um690 COMPLETE-BACKUP… | **same** |

**Phase 3 action (when approved):** keep **one** under **joshua** NAS tree (e.g. `joshua/Backups/Nathon/`); remove home duplicate only after joshua placement confirmed. **Do not delete until then.**

### 3.6 Single content drift

```
SIZE_DIFF 3446 vs 3332
./HICKMAN_ROOT/Joshua/Projects/DTK/field-kit/README.md
```

**Phase 3:** keep newer/longer or diff-merge into joshua DTK notes; do not auto-delete either until reviewed.

---

## 4. Project / working canons (home disk)

| Path | Size | Owner (planned user) | Classification |
|------|------|----------------------|----------------|
| `~/SovereignAid/` | 1.9M | **kraken** | **Platform working tree** (path name kept; brand AIDE_OS) |
| `~/valley-tech-support` (= `~/Documents/valley-tech-support/`) | — | **kraken** | **VTS working canon (2026-07-16)** |
| `~/AIDE_OS/` | 16K | **kraken** (product) | **Brand canon** (glossary + future archive) |
| `~/.grok/` | ~623M | **kraken** (then per-user) | Agent control plane |
| `~/Documents/` | ~663M–11M* | split | Notes + VTS; review for family vs business |

\* du of Documents alone vs tree with VTS nested — treat VTS as primary business subtree.

### Field kit dual path (VTS)

- Project: `~/Documents/valley-tech-support/field-kit/`
- USB Ventoy field-kit (when mounted): often `/run/media/kraken/Ventoy/field-kit/`  
- Keep dual-update rule from `AGENT.md` in Phase 4 skills.

---

## 5. Family / HICKMAN

| Person dir | Home HICKMAN | Mnt HICKMAN | Notes |
|------------|--------------|-------------|--------|
| Joshua | **2.2G** | **2.2G** | Main content; portfolio projects aios-ed, DTK, DevOps, nc-lin-cs |
| Nathon | **38G** (tarball) | empty under HICKMAN | Tarball lives under Backups on mnt |
| Alyssa / kids | placeholders | placeholders | Reserved |

**Planned owner:** **joshua** user + full NAS ACL.  
**Precursor docs under Joshua:** `Documents/ARA`, `Documents/aios-ed`, `Projects/aios-ed`, Sovereign-Mesh notes → **AIDE_OS/archive/** (do not delete).

---

## 6. Precursor inventory (archive candidates)

| Name / path | Location | Disposition |
|-------------|----------|-------------|
| AIOS / aios-ed | HICKMAN Joshua Projects + Documents | Archive → AIDE_OS |
| ARA | HICKMAN Joshua Documents/ARA; old snapshot core/ara | Archive |
| SovereignAid / SMADP | Live platform path + scripts | **Keep live** (path); brand as AIDE_OS in docs |
| aide_installer_pkg | Inside SovereignAid | Keep (installer package) |
| AIDE_OS | `~/AIDE_OS` | **Canon brand** expand |
| NetAIDE / LinuxAIDE / NovaProSys / Retro House | Not found as top-level live trees this scan | If found later → archive |
| smadp-mesh | VTS field-kit | Keep under VTS (ops product) |
| `.config/sovereign` | home | Review → kraken secrets-adjacent; no dump to git |

**Rule:** precursors **archive or fold** into AIDE_OS; never delete unique content.

---

## 7. Recommended target layout (Phase 2–3 — not executed yet)

```text
/mnt/systems_admin/                    # durable root
  um690/                               # host backups (COMPLETE-BACKUP-*, keep)
  kraken/
    platform/        # optional mirror of SovereignAid export
    reports/
    restic/          # from mnt restic/smadp
    designs/         # grok-config designs
  joshua/
    HICKMAN_ROOT/    # family tree
    Backups/Nathon/  # nathon-bak (single copy)
    batocera_management/  # or family/media/
    media/
  vtech/
    valley-tech-support/  # optional durable mirror of business tree
  archive/
    AIDE_OS-precursors/   # aios-ed, ARA, old names
```

**Home disk working trees stay:**

```text
~/SovereignAid          # kraken daily
~/valley-tech-support             # VTS daily (kraken, one Grok)
~/AIDE_OS               # brand + archive index
```

After Phase 3, `~/systems_admin` becomes symlink or retired **only if** mnt+users hold all unique content and complete backup still exists.

---

## 8. Classification legend

| Label | Meaning |
|-------|---------|
| **CANON** | Authoritative living tree |
| **WORKING** | Active edit location (may equal canon) |
| **DURABLE** | NAS long-term copy |
| **LEGACY** | Redundant; merge then retire |
| **ARCHIVE** | Precursor/history; keep, don’t mix as equal brand |
| **BACKUP** | Point-in-time snapshot (um690, USB, restic) |

---

## 9. Per-area classification (today)

| Asset | Class | Owner later |
|-------|--------|-------------|
| `~/SovereignAid` | CANON+WORKING platform | kraken |
| `~/valley-tech-support` | CANON+WORKING business | **kraken** |
| `~/AIDE_OS` | CANON brand | kraken / product |
| `~/systems_admin` | LEGACY mirror (+ a few unique files) | — retire after merge |
| `/mnt/systems_admin` (excl um690) | DURABLE partial | split to users |
| `/mnt/systems_admin/um690/COMPLETE-BACKUP-*` | BACKUP | kraken ops |
| Nathon tarball | DURABLE critical | joshua |
| batocera | DURABLE family media | joshua |
| restic/smadp | DURABLE platform | kraken |
| Joshua aios-ed / ARA | ARCHIVE | joshua → AIDE archive |

---

## 10. Duplicate policy queue (for Phase 3)

| Item | Status | Action when consolidating |
|------|--------|---------------------------|
| nathon home vs mnt | **Hash equal** | Keep one under joshua; drop other only after confirm |
| batocera ROMs (shared paths) | Same size files | Prefer mnt as durable; home ISOs unique → copy ISOs first |
| DTK field-kit README | Size differ | Manual merge |
| 22k shared same-size files | Likely identical | Prefer single durable tree; home becomes thin or symlink |

---

## 11. Risks / do-not-touch

1. **Do not delete nathon** until joshua placement + second verification.  
2. **Do not rm -rf `~/systems_admin`** until home-only 11 paths merged.  
3. **Do not wipe batocera** — home has larger ISO set.  
4. **um690 COMPLETE-BACKUP** is the reorg safety net — keep until Phase 3 verified.  
5. Complete backup sits **on same disk** as live mnt content — not offsite; USB is only fitted; consider second media for nathon later if desired.

---

## 12. Phase 1 exit criteria — met

- [x] Dual systems_admin mapped  
- [x] Overlap / home-only / mnt-only listed  
- [x] Nathon hashes recorded (from complete backup + inventory)  
- [x] Precursor locations listed  
- [x] Target user layout sketched  
- [x] No mutations performed  

---

## 13. Next (Phase 2)

1. Create Linux users **vtech**, **joshua** (kraken exists).  
2. Create k8s NS `platform` / `vtech` / `family`.  
3. Create NAS user-root dirs + ACL (joshua full; others jailed).  
4. Align Nextcloud users/groups (plan then implement).  

**Do not start Phase 3 moves until Phase 2 buckets exist.**

---

## References

- Design: `AIDE-VTS-platform-readiness-design.md`  
- Decisions: `DECISION-LOG-2026-07-10.md`  
- Complete backup: `/mnt/systems_admin/um690/COMPLETE-BACKUP-20260710-172254/`  
- Inventory raw: `/tmp/phase1-inventory/` (ephemeral)

---
**Phase 2 (2026-07-10):** NS + NAS roots done; Linux users need `sudo bash /mnt/systems_admin/um690/phase2-create-users.sh`. See PHASE-2-STATUS.md.

---

## Phase 3 COMPLETE (2026-07-11)

Tenant trees populated under `/mnt/systems_admin/{kraken,joshua,vtech,archive}/`.  
Nathon **canon**: `joshua/Backups/Nathon/`. Home nathon **removed** (hash-verified).  
Legacy root paths retained. See `PHASE-3-STATUS.md`.
