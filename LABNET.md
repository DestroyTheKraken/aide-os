# LabNET inventory — `192.168.20.0/24`

| Field | Value |
|-------|--------|
| **Updated** | 2026-07-16 |
| **Scanned from** | um690 (`192.168.20.100`) |
| **Gateway** | `192.168.20.1` (VyOS on M93p Tiny) |
| **Scope** | Physical switch: um690, node1, node2, router, USB hub, TV, MVP |

---

## System focus (2026-07-16)

See **`/mnt/systems_admin/shared/memory/SYSTEM-FOCUS.md`**.

| Item | Current |
|------|---------|
| Daily Grok | **kraken** only (one paid account) |
| VTS ops | `~/valley-tech-support` |
| AIDE_OS / Edbuntu | Education product under `~/AIDE_OS` — not gaming |
| fam-media | **HickMedia Console dev** (reimage Core); not AIDE MVP |
| Linux `vtech` | Optional; not required for daily VTS |

---

## Live hosts (this scan)

| IP | Hostname / label | MAC | Role | OS / notes | SSH | Tailscale |
|----|------------------|-----|------|------------|-----|-----------|
| **`.1`** | **router** (VyOS) | `9c:69:d3:81:3b:e2` (ASIX USB NIC facing lab) | L3 gateway · home/lab split | VyOS on **M93p Tiny** | port 22 open; lab mgmt historically restricted | — |
| **`.100`** | **um690** | `58:47:ca:70:aa:02` | k3s **control plane** · Grok director | Ubuntu 26.04 · Minisforum UM690 | `kraken@` mesh | `100.120.232.39` · `um690.taile52ad9.ts.net` |
| **`.101`** | **node1** | `d8:cb:8a:01:7a:89` | k3s **worker** | Ubuntu 26.04 · M93p | `kraken@` mesh | `100.69.243.112` · `node1…` |
| **`.102`** | **node2** | `44:8a:5b:dd:a0:c5` | k3s **worker** | Ubuntu 26.04 · M93p | `kraken@` mesh | `100.82.68.92` · `node2…` |
| **`.103`** | **Samsung TV** | `20:15:de:c6:fe:f6` | Display / media | Samsung | no SSH | — |
| **`.104`** | **fam-media** | `d8:cb:8a:86:c8:02` | **HickMedia Console dev** (Path C / Core) | Ubuntu 26.04 → Core · **M93p** · `joshua` then console admin | `ssh fam-media` / `fam-media-ts` | `100.119.236.78` · `fam-media` |
| **`.105`–`.120`** | — | — | empty this scan | — | — | — |

**Note:** `.106` was an early intended IP; MVP is pinned at **`.104`**.  
**VyOS DHCP static-mapping `fam-media`:** `192.168.20.104` ↔ MAC `d8:cb:8a:86:c8:02` (applied 2026-07-12). Host still uses DHCP client; router always offers `.104`.

---

## fam-media (HickMedia Console **dev** — 2026-07-26)

| Field | Value |
|-------|--------|
| **Role** | **HickMedia** gaming/media console development (Ubuntu Core + Frame + Qt target) |
| **Not** | AIDE_OS education MVP · not k3s worker |
| **AIDE work** | Continues under `~/AIDE_OS` + Edbuntu docs — **not** on this box as product host |
| **Hostname** | `fam-media` |
| **Hardware** | Lenovo ThinkCentre M93p · i5-4570T (4t) · 16 GiB RAM · 238 G disk (100 G LV root) |
| **LAN** | `eno1` `192.168.20.104/24` · MAC `d8:cb:8a:86:c8:02` (may be offline; use TS) |
| **Tailscale** | `100.119.236.78` · `ssh fam-media-ts` |
| **Primary user** | `joshua` until Core reimage |
| **Console guide** | `~/HickMedia/docs/CONSOLE-V2-INSTALL-FAM-MEDIA.md` |
| **AIDE scope** | `~/AIDE_OS/docs/PRODUCT-SCOPE-AND-EDBUNTU.md` |

### Access from um690

```bash
ssh fam-media          # LAN .104
ssh fam-media-ts       # Tailscale
ssh mvp                # alias
```

---

## Switch map (physical)

```text
switch
├── router (VyOS M93p)     .1
├── um690                  .100
├── node1                  .101
├── node2                  .102
├── Samsung TV             .103
├── fam-media              .104   ← HickMedia Console dev
└── USB hub (+ j-tab)      no dedicated LabNET IP this scan
```


**Tailscale-only peers** (not necessarily on this switch): `a-lap`, `a-phn`, `aios-field-kit`, `hickles`, `j-phn`, `j-tab`, `n-dsk`, …

---

## Recommended DHCP statics (VyOS — apply when ready)

| Mapping | IP | MAC |
|---------|-----|-----|
| um690 | `.100` | `58:47:ca:70:aa:02` |
| node1 | `.101` | `d8:cb:8a:01:7a:89` |
| node2 | `.102` | `44:8a:5b:dd:a0:c5` |
| **fam-media** | **`.104`** | **`d8:cb:8a:86:c8:02`** |

Optional: leave `.106` free or use for a future second console.

---

## Configure checklist (MVP ↔ platform)

| Step | Status |
|------|--------|
| Rescan LabNET | done 2026-07-12 |
| Identify fam-media | done — M93p Ubuntu 26.04 |
| SSH um690 ↔ fam-media | done (user `joshua`) |
| `~/.ssh/config` Host `fam-media` / `mvp` | done on um690 |
| Template `scripts/phase0/ssh-config-template` | updated |
| Tailscale joined | done (`fam-media`) |
| UFW on MVP | present (rules dump pending sudo) |
| VyOS DHCP static for `.104` | **done** 2026-07-12 (`static-mapping fam-media`) |
| Shared memory all seats | **`/mnt/systems_admin/shared/memory/`** (LABNET.md + MEMORY.md) |
| kraken `~/.grok/memory` + AGENTS/skills | **done** |
| joshua/vtech homes | seat script done (`install-seat-labnet.sh`) |
| Console pack | `~/AIDE_OS/console-pack/` — **base GUI + Termius only**; boot `graphical.target`; add-ons on request |
| Push SSH keys fam-media → node1/node2 | **pending** (optional) |
| Join k3s as agent | **out of scope** (test host) |
| AIDE_OS console pack (Firefox kiosk) | **next product work** |

---

## Related

- Brand: [README.md](./README.md) · [GLOSSARY.md](./GLOSSARY.md)
- Platform: `~/SovereignAid/specs/cluster.md` · `specs/network.md`
- Console product notes: [DESIGN.md.md](./DESIGN.md.md)
