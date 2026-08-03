# Design: AIDE_OS on Ubuntu Core — `aidectl` (provision → config → doctor)

| Field | Value |
|-------|--------|
| **Date** | 2026-07-27 |
| **Status** | Direction locked · classic shim scaffolding |
| **Product** | AIDE_OS education/work appliance (not HickMedia gaming) |
| **CLI** | `aidectl` under `~/AIDE_OS/aidectl/` |

## Summary

Shipped AIDE_OS targets a **true Ubuntu Core appliance**: immutable, snap-only, confined. Operators and learners touch the system through a **custom command language** (`aidectl`), not free-form host ricing.

| Phase | Command | Job |
|-------|---------|-----|
| 1 | `aidectl provision` | Idempotent apply known-good seat |
| 2 | `aidectl config` | Schema-backed config tree / palette |
| 3 | `aidectl doctor` | Detect → propose → allowlisted heal (+ optional local AI) |

**Personal lab** (um690 classic GNOME + Ghostty + Grok) may stay less isolated. **Public / enterprise** defaults to Core isolation.

## Signal-flow architecture

```
Director (human) ── policy / truth / approval
        │
   aidectl provision · config · doctor
        │
   aide-os snap(s) + config tree + probes
        │
   Local AI plug (Grok Build or any)     Companions (Termius, Termux, Obsidian, Tailscale)
```

### Config tree (product tree, not raw `/`)

```text
aide://
  profile/          open | google | microsoft | canonical | education-lfcs | …
  desktop/          theme, terminal (where UI allows)
  learning/         track, vault path
  network/          tailscale, ssh policy
  ai/               provider, permission mode, no permanent YOLO
  security/         interfaces, auto-heal allowlist
  iot/              hubs, automations, accessibility surfaces (Phase 2+)
```

On Core, durable state lives under snap common data (e.g. `/var/snap/aide-os/common/`), not ad-hoc `/etc` edits.

## Cross-platform claim (honest)

| Platform | Role |
|----------|------|
| Ubuntu Core appliance | System of record |
| Android / Termux | Client shell + vault sync |
| iOS / iPadOS | Obsidian + browser + Termius |
| macOS | Obsidian + Grok client + SSH |
| Classic um690 | Dev seat + **classic-shim** for `aidectl` until Core image is daily-driver |

Sell: **brain and projects follow you over Tailscale** wherever Obsidian / Termius / Termux / browser install.  
Do not sell: “Ubuntu Core boots on iPhone.”

## IoT, sensory, accessibility, VR (capability vs product)

### Capability (yes)

IoT and sensory objects **can** collaborate through **trigger → condition → response** automation:

| Layer | Examples |
|-------|----------|
| Edge OS | Ubuntu Core + confined snaps |
| Hub | Home Assistant (snap / companion), Matter/Thread, Zigbee/Z-Wave bridges |
| Triggers | motion, light, voice, button, calendar, location, biometric *with consent* |
| Responses | lights, haptics, TTS, display, notify, start lesson mode, accessibility aids |
| Scripting | HA automations, Node-RED, confined scripts invoked by `aidectl`/hooks |
| VR / AR | headset as another *client surface* (browser/WebXR or vendor runtime) over Tailnet |
| Accessibility | switch control, TTS/STT, high-contrast packs, timed prompts, reduced-motion profiles |

This is the same pattern as industrial and home automation: **sensors publish events; policies decide; actuators act** — with audit logs and human override.

### Professional product boundary (AIDE_OS ships this)

**Ethics and family-first features** are the professional product line:

- Education pathways (LFCS, web, UI/UX, credentials)
- Accessibility and inclusive IoT (reminders, safe home automation, sensory aids)
- Family profiles (content policy, time bounds, shared vault rules)
- Director approval for high-impact automation
- No permanent YOLO; heal allowlists; truth-oriented doctor

### Adult / intimate tech (capability exists; not AIDE_OS brand)

Adult consumer hardware and software (including intimate devices and “sextech”) **exist as a market** and can technically sit on the same *generic* IoT patterns (pairing, triggers, privacy-sensitive data).  

**AIDE_OS / Edbuntu professional scope does not productize sexual devices or adult content.**  

That domain is:

- legal/consent/privacy heavy,
- brand-incompatible with education + family packaging,
- appropriately left to personal life or separate adult-market products — **not** mixed into school/credential pathways.

**Rule:** discuss full technical capability when asked; **ship** ethics, family, education, accessibility. Personal interests outside product stay off the AIDE_OS SKU.

## Self-heal and self-learn

| Term | Meaning |
|------|---------|
| Self-heal | Re-run provision stages, restart confined services, reconnect declared interfaces |
| Self-learn | Append-only store of *successful* repair recipes; never silent policy rewrite |
| Truth | Prefer verify evidence + official docs; Director overrides Assistant |

## Classic shim (now)

Until a Core image is the daily driver:

```bash
aidectl provision --profile grokaide-dev   # applies Ghostty + reports mode=classic-shim
aidectl config list
aidectl doctor
aidectl doctor --fix                   # allowlisted only
```

Labels every run: `mode=classic-shim` or `mode=core`.

## Non-goals (near term)

- Full Core image build in this scaffold
- Unsupervised root AI
- HickMedia gaming merge
- Adult/sextech product modules under AIDE_OS brand

## Implementation map

| Path | Role |
|------|------|
| `aidectl/aidectl` | CLI entry |
| `aidectl/profiles/` | Provision profiles |
| `aidectl/schema/config-tree.yaml` | Config node schema |
| `idee/*` | Classic modules called by provision shim |
| `docs/labs/.../ubuntu-core/` | Core learning labs |

## Success criteria

1. `aidectl provision --profile grokaide-dev` exits 0 and leaves verify green on um690.  
2. `aidectl config list` prints schema tree.  
3. `aidectl doctor` reports mode, grok, ghostty, vault; `--fix` only allowlisted.  
4. Design doc states IoT capability + family/ethics product boundary clearly.
