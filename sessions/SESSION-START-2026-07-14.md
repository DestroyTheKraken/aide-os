# Session start — AIDE_OS / Nextcloud (2026-07-14)

**Paste this into Grok Build** at session start (or open this file from Nextcloud → AIDE_OS → sessions).

---

## Where we are

| Area | Status |
|------|--------|
| **Nextcloud Hub** | **Operational** on cluster (um690). UI overview matches. Initial deploy/stability OK. |
| **fam-media** | Console MVP: Plasma Wayland + KWin, Termius, Firefox → Nextcloud. Krohnkite **off**. |
| **LabNET** | fam-media = `192.168.20.104` (static). um690 `.100`, node1 `.101`, node2 `.102`. |
| **microk8s on fam-media** | Not needed for console role — **stop if running** (wastes CPU). |
| **Talk / 2FA / Client Push / AppAPI** | **Future projects** — do not block current work. |
| **LinkBoard** | Replaces Dashboard + eventually `/ops`. Config ready to import (see below). |
| **Grok Web + Build design** | DESIGN + PLAN under `AIDE_OS/docs/grok-integration/` in Nextcloud Files. |

---

## Autonomy table (Nextcloud extras)

| Item | Grok can do? |
|------|----------------|
| Redis locking | **Yes — done** |
| Log hygiene | **Yes — done** |
| Multi-server ID | Cosmetic; not needed (1 PHP pod) |
| Client Push | Later / own project if desired |
| SMTP | Needs Bitwarden SMTP details from you |
| Talk HPB / Whiteboard WS | **Future project** (MVP = 1–2 person Talk only; ignore warning) |
| AppAPI daemon | Future; high risk if docker.sock |
| Enforced 2FA | **Future project** (Bitwarden ≠ NC 2FA by default) |

---

## Current focus (user decision)

1. Nextcloud **stable + initial GUI/UX** for AIDE_OS.  
2. **LinkBoard** as home “Desktop”.  
3. Grok Web + Build workflow via Nextcloud as shared memory (DESIGN/PLAN).  
4. **Not** deep Talk/2FA/push feature work unless it blocks basic NC.

---

## Your first tasks this session (if continuing LinkBoard)

1. Open LinkBoard in Nextcloud.  
2. Import `AIDE_OS/LinkBoard/aide-os-desktop.json` (Import JSON).  
3. Optionally enable **Global board** (admin) so all users see this desktop.  

Full click-path: see `AIDE_OS/LinkBoard/IMPORT-GUIDE.md`.

---

## Plain English: what Grok already did under the hood

You do **not** need to open `SovereignAid` files. Grok Build maintains them for automation.

| Name | What it is | Why it was done |
|------|------------|-----------------|
| **Secret** | A password stored **inside the cluster** (Kubernetes), not in chat or git | So services can log into Redis without putting passwords in documents |
| **Redis** | A tiny fast “sticky note” database for Nextcloud | Stops Nextcloud from using the big database for file locks → smoother, less lag under load |
| **OPcache** | PHP’s code cache | Makes Nextcloud pages load faster (admin warning about full buffer) |
| **HSTS** | Browser security header (“always use HTTPS”) | Admin security check; already applied |

---

## Hardware efficiency snapshot (2026-07-14)

| Machine | Role | Load | Memory | Verdict |
|---------|------|------|--------|---------|
| **um690** | Control + k3s + NC + Grok | Load ~0.6 / 16 threads | ~8 Gi used / 59 Gi (51 Gi available) | **Healthy / efficient** |
| **node1/node2** | Workers | ~3–4% CPU | ~1.3–1.5 Gi | **Light** |
| **fam-media** | Console | Load ~1 on 4 cores when microk8s active | ~1.3 Gi / 15 Gi if GUI light | **OK if microk8s stopped**; if kubelite still running, stop it |

**Thermals:** no `sensors` data returned on um690 this scan; Haswell M93p is fine under light desktop load.

---

## Future project parking lot

- Nextcloud Talk (HPB) for 2–6+ people  
- Enforced 2FA (+ Bitwarden TOTP enrollment guide)  
- Client Push  
- SMTP password reset  
- Phase 2–3 from PLAN (Ollama, Vector RAG, deep Grok Build scripts)
