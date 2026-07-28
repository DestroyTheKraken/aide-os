# System focus — cluster-wide (SoT)

| Field | Value |
|-------|--------|
| **Updated** | 2026-07-16 |
| **Applies to** | um690 seats, Grok, SovereignAid, VTS, AIDE_OS docs |
| **Copies** | Prefer this NAS path; also mirrored in SovereignAid `docs/ops/SYSTEM-FOCUS.md` |

## Decisions (current)

| Decision | Detail |
|----------|--------|
| **Primary work** | **Valley Tech Support** products & services |
| **Who runs Grok** | Linux user **`kraken` only** for daily work (one paid xAI/Grok account) |
| **VTS ops root** | **`~/valley-tech-support`** → `~/Documents/valley-tech-support` (git, writable) |
| **Desktop shortcut** | `~/Desktop/valley-tech-support` (same tree) |
| **NAS mirror** | `/mnt/systems_admin/vtech/valley-tech-support/` (durable mirror; not required for daily edit) |
| **Public site** | https://um690.taile52ad9.ts.net/vts/ · deploy from `~/SovereignAid/k8s/websites/valley-tech-support/` |
| **Platform tree** | `~/SovereignAid` — cluster/SMADP only when needed |
| **Linux user `vtech`** | **Optional** isolation later; **not** required daily; **no** second Grok install |
| **Linux user `joshua`** | Family / fam-media SSH only |
| **AIDE_OS / Edbuntu** | Education product under `~/AIDE_OS` — **not** gaming; see `docs/PRODUCT-SCOPE-AND-EDBUNTU.md` |
| **fam-media** | **HickMedia Console dev** (`100.119.236.78`) — not AIDE MVP |
| **HickMedia** | Gaming console product → `~/HickMedia` |
| **Desktop/cluster reorg** | **Paused** unless blocking VTS delivery |
| **Grok↔Nextcloud deep integration** | **Abandoned** → SovereignAid `docs/archive/abandoned/2026-07-14-grok-nextcloud-firefox/` |

## How to start work

```bash
# Valley Tech (default)
cd ~/valley-tech-support && grok

# Platform / cluster (only when needed)
cd ~/SovereignAid && grok
```

## Customer rule (VTS)

Any customer SSH or remote automation requires **site name + ticket/job ID** in the session.

## Related living docs

| Doc | Path |
|-----|------|
| LabNET map | [LABNET.md](./LABNET.md) |
| Memory index | [MEMORY.md](./MEMORY.md) |
| Seat ACL matrix | `~/SovereignAid/docs/ops/SEAT-ACCESS.md` |
| VTS README | `~/valley-tech-support/README.md` |
| UPS / outage | `~/SovereignAid/docs/ops/` |
