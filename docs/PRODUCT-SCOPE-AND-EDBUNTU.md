# Product scope: AIDE_OS / Edbuntu vs HickMedia Console

**Updated:** 2026-07-26  
**SoT for coordination:** this file · `~/AIDE_OS` · `~/Documents/GrokPrompts.md` · HickMedia `docs/PRODUCT-BOUNDARIES.md`

---

## Separation (non-negotiable)

| Product | Role | Stack direction | Hosts (lab) |
|---------|------|-----------------|-------------|
| **HickMedia Console** | Living-room **gaming / media console** | Ubuntu Core · Frame · Qt · RetroArch · on-box Jellyfin · remote gamepad · Cyberpunk neon | **fam-media** (dev) · **hickmedia** (reference) |
| **AIDE_OS** | Sovereign **AI Desktop Environment** for learning & work | **Edbuntu** (education-first Ubuntu flavor) · browser-centric · installers · knowledgebase · SuperGrok API · industry pathways | **Not** the gaming console; future dedicated seats / VMs |

**AIDE_OS is not a gaming console.** Console pack work that mixed “TV kiosk + RetroArch” into AIDE is **legacy**. Gaming belongs only under **HickMedia**.

---

## AIDE_OS / Edbuntu vision (document for later development)

Target brand for education distro work: **Edbuntu** (Custom Ubuntu 26.04+ education stack), consolidated under **`~/AIDE_OS`**.

### Pillars

1. **SuperGrok API** — guided learning assistant integration (browser + optional desktop clients); session design lives with AIDE installers, not HickMedia.
2. **Educational application stack** — packages and defaults targeted at:
   - industries (e.g. healthcare IT, cloud ops, creative)
   - careers / roles (e.g. Linux admin, cloud architect, support engineer)
3. **Documentation knowledgebase layout** (install-time skeleton):

   ```
   /knw/
     industry/
       <industry>/
         course/
         labs/
         refs/
     platform/          # Google, AWS, Oracle, Canonical, Windows, …
     ecosystem/         # Android, Apple, Linux desktop, …
     role/
       <role>/
   ```

   User home or system root as decided by installer (`User@aide-os:/knw/...` in docs means the AIDE/Edbuntu identity + path convention).

4. **Automation + self-hosted services** — out-of-the-box via **AIDE installers** (Nextcloud, Obsidian-centric workflow, browser policies, etc.) that **augment learning and productivity**, not couch gaming.
5. **Minimal user themes** (selectable packs):
   - Gruvbox · Tokyo Night Storm Dark · Panda · Everforest Dark · …
6. **Platform customization** profiles:
   - Google · Windows · AWS · Oracle · Canonical · …
7. **Ecosystem customization** profiles:
   - Google · Amazon · Android · Apple · Windows · Linux · …

### What stays out of AIDE_OS

- RetroArch / ROM libraries as product defaults  
- Ubuntu Frame gaming kiosk as AIDE core  
- HickMedia Cyberpunk neon console UI as AIDE brand  

Those are **HickMedia** only.

### Legacy note (fam-media)

| Was | Now |
|-----|-----|
| fam-media = AIDE_OS MVP satellite | fam-media = **HickMedia Console dev** (full OS replace toward Core) |
| `~/AIDE_OS/console-pack` on fam-media | **Do not expand** as gaming product; keep code as historical / GUI experiments under AIDE only if educational |

**No AIDE backup required** for fam-media console reimage (Josh 2026-07-26). Documented here for **later Edbuntu** development, not for restoring a game box.

---

## Coordination with HickMedia stages

| HickMedia stage | AIDE_OS / Edbuntu coordination |
|-----------------|--------------------------------|
| Console freeze on hickmedia | AIDE docs stay separate; no shared installer profiles |
| fam-media → Core console | Update LABNET + GLOSSARY (fam-media role = HickMedia dev) |
| Qt shell / Frame spikes | Reuse **only** generic patterns (Wayland kiosk, theme tokens) if useful for Edbuntu kiosk *labs* — not product merge |
| Customer media hub installer | HickMedia product; AIDE installers never ship ROMs |
| SuperGrok / knw/ work | Pure AIDE_OS tree + GrokPrompts |

Always open **both** when product lines touch networking or seats:

```bash
# Gaming console
cd ~/HickMedia && grok

# Education / Edbuntu
cd ~/AIDE_OS && grok
# prompts / lesson orchestration
# ~/Documents/GrokPrompts.md
```

---

## Development stages (AIDE_OS / Edbuntu) — backlog

| Stage | Focus | Gate |
|-------|--------|------|
| **E0** | Canon docs (this file) · GLOSSARY · GrokPrompts link | Done when linked from README |
| **E1** | Edbuntu installer skeleton (profiles: role + industry + platform) | Does not depend on fam-media |
| **E2** | `/knw` tree layout + sample course packs | Content, not console |
| **E3** | SuperGrok API client/config for guided learning | Browser-first |
| **E4** | Self-hosted service packs (learning-augmenting only) | Installer modules |
| **E5** | Theme packs (gruvbox, TN storm, panda, everforest…) | Minimal chrome |
| **E6** | Platform + ecosystem presets | Orthogonal to HickMedia |

**Status:** Product wave remains loosely **on hold for daily priority**, but **scope is clarified**: education/Edbuntu only. Resume when VTS/console work allows.

---

## Related paths

| Path | Role |
|------|------|
| `~/AIDE_OS` | AIDE / Edbuntu product canon |
| `~/HickMedia` | Gaming / media console |
| `~/Documents/GrokPrompts.md` | Prompt / lesson orchestration SoT |
| `~/SovereignAid` | Cluster / SMADP (not education UI) |
| `~/valley-tech-support` | Business ops (current daily priority when active) |
