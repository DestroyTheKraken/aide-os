# AIDE_OS — Grok seat instructions

**Platform host:** `um690` · **User:** `joshua` · **Desktop:** Ubuntu **Studio** (Plasma)  
**CWD for education/platform work:** `~/AIDE_OS` → `~/Projects/aide-os`  
**Second Brain vault:** `~/AIDE_OS/brain`

## Architecture (2026-08-13)

Mesh SoT: `~/SovereignAid/ARCHITECTURE.md` · Lab map: `LABNET.md`.

| Role | Machine / path | Purpose |
|------|----------------|---------|
| **Platform** | um690 (`joshua@192.168.20.100`) + `~/Projects` | Author curriculum, GrokBuild, Multipass, mesh control |
| **Mesh workers** | node1 `.101` · node2 `.102` · node3 `.103` (`kraken@`) | Shared Sovereign Mesh (not k3s yet) |
| **Education clients** | Multipass VMs (`grokaide-edu`); hardware labs on workers when scheduled | LFCS + Canonical Ubuntu practice seats |
| **Games pack** | `~/AIDE_OS-games` → `~/Projects/aide-os-games` | bashcrawl / clmystery (linked learning) |
| **Field installers** | `~/Projects/installers` | Document only on platform; not auto-run |
| **fam-media** | **Retired** | That M93p is now **node3** |

**Flavor rule:** GrokAIDE Education runs on **official Ubuntu flavors** (Server / Edubuntu / Studio). AIDE is a thin layer (labs, vault, tools)—not a custom DE.

## What this product is

**AIDE_OS / GrokAide / Edbuntu track** — AI-assisted desktop environment for **learning and work**.  
**Not** HickMedia (gaming console). **Not** Valley Tech customer ops (`~/DTK/vts` / field kits).

## Current wave

1. **Platform seat** on Ubuntu Studio (this machine).  
2. **Education clients** via Multipass for *Learn Linux System Administration* (LFCS objectives + Canonical Ubuntu projects).  
3. Sovereign Mesh (SSH + Tailscale) is **up**. k3s is optional later—not required for LFCS client labs.

## Start (platform)

```bash
cd ~/AIDE_OS && grok
# or: grokAide-start
# Vault: GrokAide Brain launcher or open-brain-vault.sh
```

## Education client

```bash
multipass list
multipass shell grokaide-edu   # after provision
# Curriculum: /mnt/aide-os/Study_Projects  (if mounted)
```

See `docs/EDUCATION-CLIENTS.md` and `docs/FLAVOR-BASES.md`.

## Safety

- No permanent YOLO  
- Bitwarden for secrets  
- Destructive LFCS work: **client VM/node**, not platform  
- Cluster mutations: SovereignAid verify scripts only  
- Do not reimage node1/node2 without explicit approval  

## Key paths

| Path | Role |
|------|------|
| `brain/` | Obsidian vault (LFCS scaffold under `bootcamp/lfcs/`) |
| `Study_Projects/` | LFCS projects 00–09 |
| `guides/OBJECTIVES_TRACKER.md` | Exam objective checklist |
| `aidectl/` | Provision profiles |
| `idee/` | Desktop helpers (adapt for Plasma) |
| `docs/PRODUCT-SCOPE-AND-EDBUNTU.md` | Product canon |
| `~/SovereignAid` | SMADP mesh platform scripts |
| `~/AIDE_OS-games` | Terminal learning games |
| `~/Projects/installers` | nc-lin-cs, ssh-ufw-ts (field) |
