# Design: Grok Build session history → Sovereign Home + AI/IoT install programs

| Field | Value |
|-------|--------|
| **Date** | 2026-08-02 |
| **Status** | Direction draft — packageable product track |
| **Brand** | Destroy The Kraken (public) · AIDE_OS (platform/lab) |
| **Audience** | Basic SuperGrok tier · modest hardware · Canonical Ubuntu + xAI/GrokBuild |
| **Not** | School SKU · district product · “official xAI/Canonical certified” unless licensed |

---

## Thesis

Your **Grok Build session history** is already a curriculum in raw form: sovereign mesh, LabNET/k3s, AIDE_OS Core VM, portfolio, usage calibration, content pipeline, HickMedia Core practice.

**Refine + package** that history into:

1. **Sovereign Home Platform Development** — installable lab programs for a house/edge mesh  
2. **AI IoT Augmentation** — install programs that add agents, sensors, displays, and hybrid Grok/local AI on **modest** hardware  

Target stack framing: **Canonical Ubuntu (classic + Core) + Tailscale + GrokBuild/xAI API (optional hybrid) + local models when pool is empty.**

---

## What “analyze session history” means (concrete)

### Sources on this machine

| Source | Path / tool | Use |
|--------|-------------|-----|
| Session index | `grok sessions list` / `grok sessions search` | Catalog by theme |
| Per-cwd history | `~/.grok/sessions/%2Fhome%2Fkraken%2F…` | Deep dives (AIDE_OS, SovereignAid, HickMedia, notes) |
| Export | `grok export` (session → Markdown) | Redacted curriculum seeds |
| Design/ops docs | `~/AIDE_OS/docs/**` | Already refined decisions |
| Screencasts | `~/Videos/Screencasts/` | Lesson B-roll |

### Example themes already visible in history

| Theme | Sample session titles (from `grok sessions list`) |
|-------|-----------------------------------------------------|
| Platform / SMADP | Kraken um690 Platform Seat; SMADP GrokOS Phase 0 |
| Sovereign mesh | Sovereign Aide Tailscale Ubuntu Mesh; Homelab health |
| AIDE_OS product | Design Grok AIDE_OS VirtualBox VM um690 Layout |
| Network field | Node4 Router Starlink WAN / AP mode |
| Portfolio / brand | Personal Portfolio Website |

### Refinement pipeline (repeatable)

```text
1. Inventory   grok sessions list → CSV theme tags
2. Export      grok export <id> → raw MD (private)
3. Redact      strip IPs, keys, customer, absolute secrets
4. Distill     Decision / Anti-pattern / Command block / Checkpoint
5. Package     Module under programs/<track>/<module>/
6. Verify      modest-hardware checklist (UM690-class + optional M93p)
7. Content     Optional weekly video + morning VO from module
```

**Script target (next implement):** `~/AIDE_OS/scripts/programs/session-harvest.sh`  
**SoT modules:** `~/AIDE_OS/programs/`

---

## Product packaging model

### Two installable program tracks

#### Track A — Sovereign Home Platform (SHP)

| Module | Outcome | Hardware bias |
|--------|---------|----------------|
| A0 Lab hygiene | USAGE-LOG, seats, Bitwarden policy | Any |
| A1 Mesh | Tailscale tags, SSH mesh, gateway boundary | Router + 1 node |
| A2 Control plane | um690-class Ubuntu + Grok seat | 16+ thr, 32+ GB ideal |
| A3 Workers | k3s or compose workers on M93p-class | Old tinies OK |
| A4 Durable storage | NAS/tenant map, backup story | Disk-heavy |
| A5 Observe | Health = nodes Ready; simple dashboards | Light |
| A6 Portfolio proof | Redacted diagram + 5-min demo | Host |

#### Track B — AI IoT Augmentation (AIA)

| Module | Outcome | Hardware bias |
|--------|---------|----------------|
| B0 Hybrid AI budget | SuperGrok % + API reserve + local Ollama | UM690 iGPU/CPU |
| B1 Agent seat | `grokAide-start`, session briefs, no YOLO | Host |
| B2 Core appliance | Ubuntu Core VM or mini PC appliance | Core 26 path |
| B3 Thin workers | MQTT/IoT gateway, not LLM, on tinies | M93p |
| B4 Displays | NAD / TV kiosk lessons (Samsung later) | Display + LAN |
| B5 Voice/podcast lab | SuperWhisper + dual-BT audio + OBS | Headset + PC |
| B6 Install program | One script/profile: `aidectl provision` style | Classic or Core |

### Deliverable shape of an “install program”

```text
programs/
  shp/
    A2-control-plane/
      README.md          # goals, non-goals, time, SuperGrok budget
      INSTALL.md         # ordered steps
      prompts/           # GrokBuild seed prompts (refined from history)
      scripts/           # idempotent helpers
      verify.sh          # success criteria
      REDACT.md          # what never ships public
  aia/
    B2-core-appliance/
      ...
```

**Installer UX (aspirational):**

```bash
# Host (classic Ubuntu)
aide-program list
aide-program install shp/A2-control-plane
aide-program verify shp/A2-control-plane

# Or Core-oriented
aidectl provision --profile education-home   # future
```

Not claiming Canonical/xAI official certification — **compatible with** Ubuntu + GrokBuild practice.

---

## Modest hardware contract (honest)

| Class | Role | Do | Don’t |
|-------|------|-----|--------|
| **UM690-class** | Brain | GrokBuild, local 7B–14B, control plane | Promise cloud-scale |
| **M93p / tinies** | Muscle | k3s workers, MQTT, reverse proxy, practice | Run heavy LLMs |
| **Core appliance** | Edge UI | Snap-confined seat, kiosk, IoT hub | Full desktop IDE |
| **Phone / tablet** | Client | Tailscale PWA, SuperWhisper | Host cluster |
| **TV NAD** | Display | Lessons, status board | Control plane |

Aligns with grok-build-prompt architecture: **brain vs workers**.

---

## Canonical × xAI framing (market-safe)

| Layer | Vendor-aligned practice | Your packaging |
|-------|-------------------------|----------------|
| OS | Ubuntu classic / Core | Install modules, Core VM lessons |
| Edge | Ubuntu Core, snaps | Appliance track (AIDE_OS Core) |
| AI agent | GrokBuild + xAI API | Hybrid budget, session packs |
| Mesh | Tailscale (common lab) | SHP A1 |
| Hire signal | LFCS + lab demo | Portfolio + programs verify.sh |

**Public language:**  
*“Programs for building a sovereign home platform with Ubuntu and AI-assisted ops on modest hardware — using GrokBuild as the agent seat, not as a magic black box.”*

**Avoid:** trademark misuse (“official Grok OS”), school district SKU, “Canonical certified” without agreement.

---

## Privacy & redaction (hard)

Before any public package or paid install program:

1. No Tailscale IPs, MACs, home address  
2. No auth.json / API keys / Bitwarden secrets  
3. No customer VTS tickets  
4. Session exports scrubbed → only **decisions + commands + checkpoints**  
5. Music/podcast content: credit + rights (LIKA etc.)

Private full exports stay under `~/AIDE_OS/private/session-exports/` (gitignored).

---

## Relationship to existing AIDE_OS work

| Existing | Role in programs |
|----------|------------------|
| Design lab-in-a-box | Classic desktop track modules |
| Core VM + post-console-conf | AIA B2 seed |
| LEARNING-TRACK | Module order + notifications |
| USAGE-CALIBRATION | SuperGrok-tier budget modules |
| SOCIAL-CONTENT-PIPELINE | Weekly packaging of modules into video |
| grokAide-start | Entrypoint for program “class sessions” |
| PORTFOLIO-PROJECTS | Public proof ladder |

---

## MVP to ship first (2–3 weeks, budget-aware)

1. **Session harvest v0** — list + tag last 20 sessions; export 5 AIDE/mesh ones; redact  
2. **One SHP module** — A1 Mesh or A2 Control plane install pack  
3. **One AIA module** — B2 Core appliance (what you already did) as `programs/aia/B2-core-appliance/`  
4. **verify.sh** that checks VM snapshot / Core markers / docs present  
5. **LinkedIn + YT** one video: “Install program: Ubuntu Core lab on modest PC”  

Cash path: VTS packages remain DTK service menu; programs are **lab/productized learning + optional paid “bring-up assist.”**

---

## PR / implementation sketch

| PR | Work |
|----|------|
| P1 | `programs/` tree + README + gitignore private exports |
| P2 | `session-harvest.sh` + theme tags CSV |
| P3 | Package B2-core-appliance from current Core VM docs |
| P4 | Package A0 hygiene (USAGE-LOG + grokAide-start) |
| P5 | Portfolio page “Programs” linking verify artifacts |

---

## Success criteria

| Metric | Target |
|--------|--------|
| Stranger on SuperGrok basic | Completes one module in &lt; 2 h with prompt pack |
| Modest HW | Works on 1 mid PC + optional 1 tiny |
| Hireable | Demo + verify.sh + redacted writeup |
| Usage | Module lists GrokBuild vs local steps |

---

## Open questions

1. Paid product vs free portfolio-only for v1?  
2. Name: “Sovereign Home Programs” vs “AIDE_OS Programs” vs DTK “Private Hub Labs”?  
3. First paid offer: remote bring-up assist using these packs?  

---

## Immediate next (when you resume)

```bash
# Inventory gold
grok sessions list | tee ~/AIDE_OS/private/session-exports/sessions-$(date +%F).txt

# Seed first package from what you already shipped
mkdir -p ~/AIDE_OS/programs/aia/B2-core-appliance/{prompts,scripts}
# copy/link AIDE-OS-CORE-VM.md + LEARNING-TRACK snippets → INSTALL.md
```

This turns **prompt history** from scrollback into a **sovereign home + AI/IoT install curriculum** aimed at Canonical-class Ubuntu ops and GrokBuild-on-modest-hardware — without waiting for a mythical perfect monorepo.
