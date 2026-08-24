# Portfolio Projects & Skills Map

| Field | Value |
|-------|--------|
| **Updated** | 2026-08-02 |
| **Owner** | Joshua Hickman |
| **Public technical site** | [github.com/DestroyTheKraken](https://github.com/DestroyTheKraken) |
| **Design SoT (lab-in-a-box)** | `docs/design/2026-08-02-aide-lab-virtualbox.md` |
| **Rules** | No school-SKU · no student PII · redact Tailscale IPs / secrets · Bitwarden for credentials |

---

## How to read this document

Three skill tracks employers and collaborators care about, mapped to **real lab projects** (not fluff). Each project lists:

- **What** · **Evidence on disk** · **Skills demonstrated** · **Honest status** · **Portfolio talk track**

Linux depth is scored in [LINUX-SKILLS-EVAL.md](./LINUX-SKILLS-EVAL.md).

---

## Skill tracks (public narrative)

### 1. AI Prompt Engineering & Knowledge Work

| Capability | What it means in practice | Lab evidence |
|------------|---------------------------|--------------|
| **Markdown** | Specs, vaults, design docs, runbooks in clean MD | `AIDE_OS/docs/**`, Obsidian `brain/`, design docs (incl. 1.3k+ line VBox design) |
| **Formatting & structure** | Headings, tables, PR plans, severity taxonomies, mermaid-ready architecture | `/design` writer→reviewer loop artifacts; review issue templates |
| **Research & content building** | Multi-source synthesis (web + lab + conversation) into actionable plans | `Documents/notes/grok-build-prompt.md`, DTK research notes, HickMedia Core retros |
| **File organization** | Tenant trees, dual working/durable storage, project seats | `STORAGE-MAP.md`, `/mnt/systems_admin` tenants, seat map kraken/joshua/vtech |
| **Desktop computing & app stacks** | Multi-app control plane: terminal + notes + browser + hypervisor | Ghostty + Obsidian (GrokAide) + SuperGrok + VirtualBox + GNOME stack screenshots |

### 2. DevOps — Design & Planning · Testing & Debugging

| Capability | What it means | Lab evidence |
|------------|---------------|--------------|
| **Design & planning** | Goals/non-goals, alternatives, PR DAG, risk/mitigation | `docs/design/*`, SMADP phases, VirtualBox lab-in-a-box PR1–PR11 |
| **Testing & debugging** | Preflight, doctor probes, retrospectives with stop-rules | HickMedia Core retrospective (PC `dd` path), k3s Ready triad, `aidectl doctor` direction |
| **Observability mindset** | Health = nodes Ready; fail-hard platform policy | LABNET + shared memory; post-outage Redis/AOF notes |
| **IaC / automation intent** | Scripts, modules, profiles (not one-off clicks) | `aidectl/`, `SovereignAid/scripts/phase*`, VBox script plan |

### 3. Linux Skills

See full evaluation: [LINUX-SKILLS-EVAL.md](./LINUX-SKILLS-EVAL.md).  
**Headline for resume:** *Intermediate self-taught lab operator — multi-node Ubuntu/k3s/Tailscale; LFCS in progress; production SRE not claimed.*

---

## Projects to document (ordered)

### P1 — LabNET / SMADP (um690 + k3s) — **primary**

| Field | Detail |
|-------|--------|
| **One-liner** | Private multi-node edge lab: control plane + workers, mesh access, durable storage, documented ops. |
| **Paths** | `~/SovereignAid`, `~/AIDE_OS/LABNET.md`, shared memory `/mnt/systems_admin/shared/memory/` |
| **Stack** | Ubuntu 26.04 · k3s triad · Tailscale · NAS btrfs · VyOS gateway (lab) |
| **Skills** | Linux ops, networking mental models, DevOps design/debug, documentation |
| **Status** | **Live** — triad Ready (verified 2026-08-02); continuous improvement |
| **Public claim** | Anonymized architecture only — no management IPs, no client data |
| **Demo** | Architecture diagram · `kubectl get nodes` (private) · bring-up notes · failure/recovery story |
| **Interview story** | “I operate a real three-node cluster daily; green means all three Ready.” |

### P2 — AIDE_OS / GrokAide lab-in-a-box (VirtualBox)

| Field | Detail |
|-------|--------|
| **One-liner** | Classic Ubuntu guest that mirrors um690 seat patterns: Obsidian + Ghostty + control dashboard + hybrid AI policy, exportable OVA. |
| **Paths** | `docs/design/2026-08-02-aide-lab-virtualbox.md`, `aidectl/`, `idee/`, existing VMs under `~/VirtualBox VMs/` |
| **Stack** | VirtualBox · classic desktop · aidectl classic-shim · Buildian · PWA dashboard (planned) |
| **Skills** | Prompt engineering at scale, design/planning, Linux desktop + server crossover, DevOps PR sequencing |
| **Status** | **Design approved** (2026-08-02f); implementation PR1–PR9 |
| **Public claim** | Personal learning / portfolio appliance — **not** school SKU |
| **Demo** | Design doc · USAGE-LOG discipline · golden snapshot path (when built) |

### P3 — Ubuntu Core practice (HickMedia lab lessons)

| Field | Detail |
|-------|--------|
| **One-liner** | Hands-on Ubuntu Core install/debug on constrained hardware; appliance boot patterns. |
| **Paths** | `~/HickMedia/docs/ops/RETROSPECTIVE-2026-07-27-ubuntu-core-fam-media.md`, `BOOT-SPLASH.md`, Core images under `dist/ubuntu-core/` |
| **Stack** | Ubuntu Core · Frame/WPE (console) · QEMU smoke · Ventoy/dd |
| **Skills** | Linux install/debug, immutable OS concepts, honest postmortems |
| **Status** | **Practice lab** — product is gaming console (HickMedia); portfolio uses **Core lessons only** for AIDE track |
| **Public claim** | Core appliance patterns; **no** RetroArch/school packaging |

### P4 — Valley Tech Support (cash business)

| Field | Detail |
|-------|--------|
| **One-liner** | Rural IT / private cloud packages for Okanogan County — documented service menu, field discipline. |
| **Paths** | `~/valley-tech-support`, `~/DTK/docs/SERVICE-MENU-2026-07.md` |
| **Skills** | Client scoping, documentation, practical Linux/network support |
| **Status** | **Active business** |
| **Public claim** | Public GitHub docs only — **no client PII** |

### P5 — Destroy The Kraken (public brand / web)

| Field | Detail |
|-------|--------|
| **One-liner** | Brand notes and GitHub portfolio. |
| **Paths** | `~/DTK/site/`, `~/DTK/brand/` |
| **Skills** | Content structure, documentation |
| **Status** | GitHub |

### P6 — LFCS / Canonical learning path

| Field | Detail |
|-------|--------|
| **One-liner** | Structured Linux Foundation LFCS study + bootcamp vault games. |
| **Paths** | `~/AIDE_OS/brain/bootcamp/lfcs/`, Canonical academy map |
| **Skills** | Linux fundamentals under exam discipline |
| **Status** | **In progress** (paid exam path) |

---

## Website update checklist

| Surface | Action | Status |
|---------|--------|--------|
| AIDE_OS portfolio home | Projects + Skills sections | This update |
| AIDE_OS `projects/` page | Project cards | This update |
| AIDE_OS `docs/` | Link portfolio MD pointers | This update |
| DTK `lab-notes.html` | Soft link to skills/process (no IPs) | This update |
| USAGE-LOG | Keep feeding weekly % for credibility | Ongoing |

---

## Redaction rules (always)

1. No Tailscale IPs, MACs, or home addresses on public pages  
2. No Bitwarden/API keys · no `auth.json` · no customer names  
3. No school-SKU / student data  
4. HickMedia gaming ≠ AIDE education product  
5. Prefer “lab patterns” language over “we host your data on my cluster”
