# Research package — Station lag mitigations via design (validate in Grok)

| Field | Value |
|-------|--------|
| **Created** | 2026-08-04 |
| **Purpose** | Upload to Grok (or other model) to **validate, challenge, and extend** this research |
| **Workflow** | Grok Build deep-research (status: **partial**) |
| **Lab context** | AIDE_OS Home on **fam-media** · Samsung TV · 8BitDo · WPE kiosk |
| **Hardware** | **Bare metal** Lenovo ThinkCentre M93p · Intel i5-4570T · Ubuntu Core 26 |

**Canonical path on this machine:**

```text
/home/kraken/AIDE_OS/docs/design/2026-08-04-research-station-lag-design-mitigations.md
```

**Raw workflow scratch (same research body):**

```text
~/.grok/sessions/.../workflows/wf_019fcbabb0ba79f3a8deaf34902ae348/scratch/report.md
```

Prefer **this file** for upload (includes lab facts + validation prompt).

---

## Suggested prompt when uploading to Grok

```text
Validate this research package. For each major claim:
1) Confirm or refute with stronger primary sources if available
2) Flag anything that overclaims (especially vs VR / productivity ROI)
3) Rank design mitigations for a bare-metal 2014-era small PC
   (i5-4570T, Ubuntu Core, WPE WebKit kiosk, continuous CSS starfield,
   glass blur, gamepad-driven TV UI) by expected FPS/CPU benefit vs UX cost
4) Propose a minimal performance shell that still feels modern
   (game + productivity trends: focus-first, progressive disclosure, pad nav)
Do not invent product measurements. Cite sources.
```

---

## Research question (as run)

Ways to mitigate station UI lag / limited “dimensional” display through **design change**.
Trending styles in gaming, cloud computing, productivity, and gadgetry (gamepads for work/TV, IoT for productive work, alternative keyboards).
How to approximate multi-dimensional / multi-workspace information on ordinary flat screens without VR.

---

## Lab facts to keep fixed (not research claims)

These were measured on LabNET, not inferred from the web study:

| Fact | Value |
|------|--------|
| fam-media virt | `systemd-detect-virt` → **none** (bare metal) |
| Machine | Lenovo ThinkCentre M93p (`10AB0016US`) |
| CPU | Intel Core i5-4570T @ 2.90 GHz · 4 threads |
| Stack | Ubuntu Core 26 · ubuntu-frame · wpe-webkit-mir-kiosk 2.38 · HTML UI |
| Observed cost | WPEWebProcess often **~90%+ CPU** with animated starfield/nebula + glass |
| Control seat | um690 bare metal Ryzen 9 6900HX (not the TV renderer) |

**Conclusion for validation:** lag is **software paint budget on old iGPU-class hardware**, not “running in a VM.”

---

## Research synthesis (from deep-research report)

**Status: Partial** — see uncertainties section; do not treat as exhaustive.

You can approximate multi-dimensional information and workspace separation on ordinary flat screens—without VR hardware—by combining progressive disclosure, zoom/focus+context views, multivariate 2D encodings, and multi-workspace window management. Parallel trends in productivity, cloud, and game tooling favor focus-first UIs, denser high-contrast dashboards, layered materials, embedded AI assistants, and web-like retained UI trees. Controllers, programmable decks, ergonomic/split keyboards, and IoT automations further offload complexity from the visual surface so more of the screen stays for content rather than chrome.

### Flat-screen substitutes for multi-dimensional display

Progressive disclosure keeps ordinary screens usable by showing only core options first and revealing specialized features on request, which improves learnability and efficiency while lowering error rates.[S1] Large information spaces that cannot fit a single viewport benefit from overviews such as minimaps and page thumbnails, with animated zoom between overview and detail to build spatial memory.[S2]

Zoomable user interfaces treat the canvas as a pannable multiscale surface: detail appears as you zoom, and semantic zoom can change an object’s representation by scale rather than merely resizing it—useful for nested or multivariate content on a flat display.[S3] Fisheye and degree-of-interest focus+context views keep a focus region at full detail while compressing or filtering the surroundings, combining overview and detail in one 2D view without VR.[S4]

When the missing dimension is *data* rather than *space*, small multiples put comparable same-scale 2D panels in a grid so multivariate patterns can be compared without volumetric hardware.[S5] Parallel coordinates map n-dimensional points to polylines across n parallel axes on a plane, so high-dimensional structure can be inspected with no multi-dimensional display.[S6]

### Multi-workspace layouts on ordinary monitors

Tiling window managers such as i3 arrange windows in non-overlapping hierarchical containers (horizontal/vertical splits, stacking, tabbed layouts) and numbered workspaces—including per-output workspaces on multi-monitor setups—so many concurrent visual contexts live on ordinary 2D screens.[S19] Microsoft PowerToys FancyZones defines custom multi-zone layouts (grid or freeform) and snaps windows into one or more zones by mouse or keyboard for multi-region workflows on flat monitors.[S20] Scrollable-tiling systems such as niri place windows in columns on an infinite horizontal strip per monitor so new windows do not resize existing ones; panning the strip approximates a spatial multi-column workspace.[S21] macOS Spaces (via Mission Control) add up to 16 full desktops so apps can be segregated into separate 2D workspaces switched by gestures or shortcuts.[S22]

Earlier non-VR experiments still useful as design references: Project Looking Glass rendered ordinary windows as thin 3D slates users could tilt, reverse, and pan while keeping a conventional desktop model rather than VR-style navigation.[S23] BumpTop treated documents as 3D boxes on a virtual desk with physics (bumping, tossing, stacking) for stylus or mouse on ordinary Windows/Mac displays.[S24]

### Trending styles: productivity, cloud, and game UI

Productivity and Windows platform UI treat reduced visual clutter and “focus” as a primary goal—fewer chrome elements and less noise so users stay in flow.[S7] A layered materials language (solid, mica, acrylic, smoke)—including frosted-glass acrylic and wallpaper-tinted mica—is used for hierarchy, personalization, and focus indication on modern desktop UI.[S8]

Cloud management consoles are moving toward denser, higher-contrast light/dark dashboards with stronger typography hierarchy and less decorative depth (thinner borders instead of heavy shadows).[S9] Those same systems are standardizing generative-AI patterns—chat, agents, progressive steps, labeled AI output, user-authorized actions—and embedding proactive assistants so operators stay in flow across console, mobile, and IDE surfaces.[S10] Account and workspace personalization (colors, theming, hiding unused services or regions) cuts cognitive load and speeds recognition in long operational UIs.[S12]

Game runtime and tooling UIs are converging with web/productivity architecture: retained-mode trees, HTML/CSS-like structure and styles, Flexbox layout, and designer–developer split workflows (e.g. Unity UI Toolkit for both Editor tooling and in-game menus/HUDs).[S11]

### Controllers, decks, alternative keyboards, and IoT

Steam Input’s Desktop Configuration binds a controller for navigating the computer desktop; legacy mode can remap any supported controller’s inputs to keyboard keys or mouse buttons for software without native Steam Input.[S13][S14] On Windows (UWP), gamepads act as standard UI navigation controllers (sticks/D-pad and face buttons map to Accept, Cancel, page, and scroll), so apps can support pad navigation without device-specific code.[S15]

Elgato Stream Deck is a programmable hardware/software control surface marketed to streamline productivity and other workflows beyond streaming, with plugins and profiles across apps and systems.[S16] ZSA’s Moonlander split keyboard and Navigator pointing modules target long-form desk work with full remapping, layers/macros, and keyboard-integrated pointing so hands stay on the board for browsing, email, spreadsheets, and coding.[S18] Home Assistant can fold IoT lights and sensors into workday-related automations—for example dimming lights the night before a workday—so the environment supports focus without adding visual UI load.[S17]

---

## Lab-specific design implications (for validation)

These are **engineering inferences** from lab facts + research patterns—not measured A/B results:

| Priority | Design change | Research pattern | Expected cost cut |
|----------|---------------|------------------|-------------------|
| P0 | Idle shell: dock + header only | Progressive disclosure [S1], focus-first [S7] | High (fewer live panels) |
| P0 | Static or reduced starfield/nebula | Less continuous paint | High on WPE/i5 |
| P0 | Glass without always-on full-screen blur; blur only on open flyout | Materials [S8] without full-screen cost | Medium–high |
| P1 | One flyout at a time (Timer / Work / Status / Board) | Focus+context [S4], Mac-dock metaphor | Medium |
| P1 | Dense status (dots/bars) vs heavy cards | Dense cloud dashboards [S9] | Medium |
| P1 | UI Switch as workspace flip only | Multi-workspace [S19]–[S22] | UX clarity |
| P2 | Stream Deck / pad macros later | Controllers [S13]–[S16] | Offload chrome |
| P2 | HA / SmartHome Aide automations | IoT [S17] | Offload monitoring UI |
| P2 | Grok applet when idle | Embedded AI [S10] | Value while waiting, not more FPS cost if idle |

**Do not claim** these yield specific FPS without measurement on fam-media.

---

## Sources

- [S1] Progressive Disclosure - Nielsen Norman Group — https://www.nngroup.com/articles/progressive-disclosure/
- [S2] Spatial Memory: Why It Matters for UX Design - Nielsen Norman Group — https://www.nngroup.com/articles/spatial-memory/
- [S3] Zooming user interface - Wikipedia — https://en.wikipedia.org/wiki/Zooming_user_interface
- [S4] Zooming user interface / focus+context (Wikipedia overview) — https://en.wikipedia.org/wiki/Zooming_user_interface
- [S5] Small multiple - Wikipedia — https://en.wikipedia.org/wiki/Small_multiple
- [S6] Parallel coordinates - Wikipedia — https://en.wikipedia.org/wiki/Parallel_coordinates
- [S7] Design principles - Fluent 2 Design System — https://fluent2.microsoft.design/design-principles
- [S8] Material - Fluent 2 Design System — https://fluent2.microsoft.design/material
- [S9] Announcing a visual update to the AWS Management Console (preview) — https://aws.amazon.com/blogs/aws/announcing-a-visual-update-to-the-aws-management-console-preview/
- [S10] Patterns - Cloudscape Design System (Generative AI) — https://cloudscape.design/gen-ai/patterns/
- [S11] Introduction to UI Toolkit - Unity Manual — https://docs.unity3d.com/Manual/ui-systems/introduction-ui-toolkit.html
- [S12] Customize your AWS Management Console experience… — https://aws.amazon.com/blogs/aws/customize-your-aws-management-console-experience-with-visual-settings-including-account-color-region-and-service-visibility/
- [S13] Steamworks: Getting Started for Players (Steam Input) — https://partner.steamgames.com/doc/features/steam_controller/getting_started_for_players
- [S14] Steamworks: Steam Input General Concepts — https://partner.steamgames.com/doc/features/steam_controller/concepts
- [S15] Microsoft Learn: UI navigation controller (UWP) — https://learn.microsoft.com/en-us/windows/uwp/gaming/ui-navigation-controller
- [S16] Elgato Stream Deck — https://www.elgato.com/us/en/s/welcome-to-stream-deck
- [S17] Home Assistant: Automating Home Assistant — https://www.home-assistant.io/getting-started/automation/
- [S18] ZSA Moonlander — https://www.zsa.io/moonlander
- [S19] i3 User's Guide — https://i3wm.org/docs/userguide.html
- [S20] FancyZones - PowerToys | Microsoft Learn — https://learn.microsoft.com/en-us/windows/powertoys/fancyzones
- [S21] niri scrollable-tiling Wayland compositor — https://github.com/niri-wm/niri
- [S22] Work in multiple spaces on Mac - Apple Support — https://support.apple.com/guide/mac-help/work-in-multiple-spaces-mh14112/mac
- [S23] Project Looking Glass - Wikipedia — https://en.wikipedia.org/wiki/Project_Looking_Glass
- [S24] BumpTop - Wikipedia — https://en.wikipedia.org/wiki/BumpTop

---

## Coverage and uncertainty (must not be washed out in validation)

1. No inspected source framed results explicitly as “mitigating lack of volumetric multi-dimensional display hardware”; claims are established 2D HCI / info-vis patterns.
2. Material Design elevation docs were not fully retrieved; shadow-as-depth efficacy is not strongly evidenced here.
3. No claim of equivalence or superiority to VR for true volumetric tasks.
4. Wikipedia and secondary summaries used for some classic HCI topics; primary academic PDFs not fully retrieved.
5. Intersection of gaming + cloud + productivity trends is **inferred** from parallel sources, not one survey paper.
6. Marketing trend labels (e.g. glassmorphism, neubrutalism) were intentionally **not** used as primary claims.
7. No quantified productivity ROI for gamepad-desktop, Stream Deck, or ergonomic keyboards in inspected sources—only capabilities.
8. Looking Glass / BumpTop modern runnability not verified (historical references).
9. No controlled study comparing these 2D approximations to VR spatial memory was inspected.

---

## Related lab docs (not part of the web study)

| Path | Role |
|------|------|
| `~/HickMedia/docs/STATION-CSS.md` | Station CSS architecture |
| `~/HickMedia/docs/AIDE-OS-COCKPIT.md` | Cockpit surfaces |
| `~/HickMedia/docs/8BITDO-GAMEPAD.md` | Pad + WPE key-bridge |
| `~/HickMedia/docs/CLEAN-START-2026-08-05.md` | Morning ground truth |
| `~/AIDE_OS/docs/PRODUCT-EVOLUTION-2026-08-04-AIDE-OS-HOME-WORK.md` | Home / Work naming |

---

## End of package
