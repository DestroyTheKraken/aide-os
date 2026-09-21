# AIDE_OS

**Status: in development (MVP) — not a finished product.**

AIDE_OS is an **embedded educational learning environment** under Destroy the Kraken (DTK) Studio. The long-term shape is a classroom mesh: each student PC is a node; the teacher operates the control plane. AI CLI integrations (Claude Desktop, Grok Build, Gemini CLI, and optionally fully local Ollama models) are meant to assist with grading, assignment turn-in, and progress tracking inside a more contained network — including region- or industry-aware compliance data when that layer exists.

## Near-term MVP

A **Grok/X-themed embedded desktop** aimed at a **Veteran SysAdmin & NetAdmin bootcamp**:

- CompTIA and Linux Foundation certification paths first  
- Later expansion toward other respected tracks (e.g. Red Hat, LPIC I & II)

This public tree still contains **study-bench material** used while the product is built (lessons, lab notes, installer helpers). Treat product claims as **roadmap**, not shipped SaaS.

Job search: [joshua.hickman1@gmail.com](mailto:joshua.hickman1@gmail.com) · Profile: [DestroyTheKraken](https://github.com/DestroyTheKraken) · Portfolio: [destroythekraken.com/work.html](https://www.destroythekraken.com/work.html)

## Reviewer map

| Open first | Why |
|------------|-----|
| [DESIGN.md](./DESIGN.md) | Architecture notes for the embedded environment |
| [PROGRESS.md](./PROGRESS.md) / phase status files | What has been proven vs planned |
| [Study_Projects/](./Study_Projects/) | Lesson / lab material (learning bench) |
| [brain/bootcamp/lfcs/](./brain/bootcamp/lfcs/) | LFCS domain notes and labs |
| [homelab](https://github.com/DestroyTheKraken/homelab) | Premises network that backs practice |

## What this is / is not

- **Is:** an unfinished LMS / classroom-mesh product in development, plus the practice trees used to build it.
- **Is not:** a finished school-district package, production PaaS, or a claim that every bootcamp feature is live today.
- Personal assessments, family media, and private vault data are **not** in this public repo.

## Related public repos

- [homelab](https://github.com/DestroyTheKraken/homelab) — VyOS / segmented LANs  
- [nc-lin-cs](https://github.com/DestroyTheKraken/nc-lin-cs) — Nextcloud installer  
- [ssh-ufw-ts-install](https://github.com/DestroyTheKraken/ssh-ufw-ts-install) — OpenSSH + UFW + Tailscale bootstrap  
- [icap-battery](https://github.com/DestroyTheKraken/icap-battery) — iCAP career battery UI  

## Quick start (lab workstation)

```bash
aide-day
```

Optional practice VM:

```bash
multipass start grokaide-edu
multipass shell grokaide-edu
```
