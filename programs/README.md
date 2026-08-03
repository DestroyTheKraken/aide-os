# AIDE_OS Programs — install packs from lived GrokBuild practice

**Brand:** Destroy The Kraken · **Platform:** AIDE_OS  
**Thesis:** Grok Build session history → refined modules for **sovereign home platform** + **AI/IoT augmentation** on **modest hardware** (Ubuntu / Ubuntu Core + optional GrokBuild/xAI hybrid).

| Track | Code | Focus |
|-------|------|--------|
| **Sovereign Home Platform** | `shp/` | Mesh, control plane, workers, storage, observe |
| **AI IoT Augmentation** | `aia/` | Hybrid AI budget, Core appliance, thin IoT workers, displays, voice lab |

**Design SoT:** `docs/design/2026-08-02-session-history-program-pack.md`

## Module layout

```text
programs/<track>/<module-id>/
  README.md     # outcome, time, SuperGrok budget, hardware
  INSTALL.md    # ordered steps
  verify.sh     # exit 0 = pass
  prompts/      # GrokBuild seed prompts (no secrets)
  scripts/      # helpers
```

## First modules

| ID | Path | Status |
|----|------|--------|
| **B2** | `aia/B2-core-appliance/` | Seeded from live AIDE_OS Core VM work |
| A0 | (next) hygiene + USAGE-LOG + `grokAide-start` | Planned |
| A1 | (next) Tailscale mesh | Planned |

## Harvest sessions (private)

```bash
grok sessions list | tee ~/AIDE_OS/private/session-exports/sessions-$(date +%F).txt
grok export <SESSION_ID> ~/AIDE_OS/private/session-exports/<id>.md
# redact before any public copy
```

`private/` is gitignored.

## Framing

- **Canonical:** Ubuntu classic + Core practice  
- **xAI:** GrokBuild as agent seat; API reserve policy  
- **Modest HW:** UM690-class brain · M93p workers · no heavy LLM on tinies  
- **Not:** official vendor certification · school SKU  
