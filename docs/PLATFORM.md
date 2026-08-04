# AIDE_OS platform (LabNET) — definition

**Updated:** 2026-08-04
**SoT:** this file · shared memory `ORCHESTRATOR.md` · `PRODUCT-SCOPE-AND-EDBUNTU.md`
**Evolution log:** `PRODUCT-EVOLUTION-2026-08-04-AIDE-OS-HOME-WORK.md`
**Director:** Josh · **Daily Grok seat:** `kraken` on um690

---

## One sentence

**AIDE_OS (platform)** = the LabNET environment (um690 + k3s + NAS + VyOS + Grok) that runs your life, business, learning, and portfolio — **not** a single unfinished education distro SKU.

---

## Layers (do not collapse)

| Layer | What it is | Status |
|-------|------------|--------|
| **AIDE_OS platform** | Machine/cluster/subnet: LabNET `192.168.20.0/24`, um690 control, Grok Build, shared memory, project trees | **Active** — daily ops + orchestration |
| **AIDE_OS Work** | Work / ops board: Command Center, pipeline, jobs, servers, learning + Pomodoro, micro-sprints | **Active** — um690 + cockpit Work surfaces |
| **AIDE_OS Home** | Home station: media + **game-station monitoring cockpit** (coffee-break aide) — **lineage: HickMedia** | **Active** — fam-media → Samsung · refinement `docs/design/2026-08-04-grok-web-refinement-pass-game-station-cockpit.md` |
| **SmartHome Aide Hub** | Whole-home configuration aide (framework direction) | **Direction** — build on Home + platform |
| **AIDE education product (Edbuntu)** | Education-first Ubuntu flavor, `/knw` curricula, SuperGrok learning product packaging | **Gated** — do not sell as ready SKU |

Mess historically came from treating “education product on hold” as “the whole lab is frozen.”

**HickMedia** = archived brand name + `~/HickMedia` code lineage for **AIDE_OS Home**. Annotate; do not erase. See `HickMedia/docs/ARCHIVE-AND-LINEAGE.md`.

---

## What is *not* AIDE education product

| Product | Role | Lab host |
|---------|------|----------|
| **AIDE_OS Home** (HickMedia lineage) | Living-room **media + game-station monitoring cockpit** | fam-media (Core), hickmedia (reference) · SoT `HickMedia/docs/AIDE-OS-COCKPIT.md` |
| **AIDE_OS Work** | Ops / pipeline / Command Center | um690 · station Work mode |
| **Valley Tech Support (VTS)** | Cash business: rural IT, networks, private cloud **teach+build on client gear** | ops on um690 as kraken |

**Do not** rebrand Home/HickMedia as a school mascot product or district education OS.

---

## “No school-SKU” rules (hard)

1. **No public offer** of “AIDE_OS for Omak High / Pioneers” or any unfinished education distro as a product package.
2. **No mixing** HickMedia installers/themes/channels into school education packaging.
3. **No student PII** on Facebook, destroythekraken.com, portfolio, or Tailscale demo URLs.
4. **No free school pilot** without written scope + privacy/security terms (free still needs district-grade process).
5. **Informal board conversation** = soft VTS rural IT / Chromebook **support within published service menu** only — not a free pilot + high retainership pitch.
6. **Portfolio** may show **anonymized** Core/kiosk **lab** architecture (HickMedia appliance, um690 platform) — not “live school deployment” with student or district systems.
7. School-facing **cash** work, if any, is **VTS systems/ops** under SERVICE-MENU pricing language, or future gated AIDE education — never “HickMedia school edition.”

See also: deep-research board findings (2026-07); ED PTAC free-services guidance; FERPA redisclosure limits; DTK `PII-POLICY.md` / `SERVICE-MENU-2026-07.md`.

---

## Lab map (platform)

| Host | Role |
|------|------|
| um690 `.100` | Grok director, k3s control, orchestrator seat |
| node1/2 `.101`/`.102` | k3s workers |
| VyOS `.1` | LabNET gateway |
| fam-media `.111` | **HickMedia Console** Core lab (not AIDE education MVP) |
| NAS `/mnt/systems_admin/` | Tenants joshua / vtech / kraken / shared |

---

## Education *practice* (allowed now, not a school SKU)

On **um690** personal learning (LFCS-style bootcamp), quick commands:

| Command | Game |
|---------|------|
| `clh` | Command Line Heroes |
| `bashcrawl` | Bashcrawl |
| `bashcrawl-web` | Bashcrawl web |
| `terminus` | Terminus |

These support **your** education bucket — not district product packaging.

---

## Related

- Orchestrator: `/mnt/systems_admin/shared/memory/ORCHESTRATOR.md`
- Product scope: `docs/PRODUCT-SCOPE-AND-EDBUNTU.md`
- HickMedia boundaries: `~/HickMedia/docs/PRODUCT-BOUNDARIES.md`
- Core flash lessons: `~/HickMedia/docs/ops/RETROSPECTIVE-2026-07-27-ubuntu-core-fam-media.md`
