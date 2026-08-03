# `aidectl` — AIDE_OS system commands

**Target:** Ubuntu Core appliance (snap-only, confined).  
**Today:** classic-shim on um690 (calls `idee/` modules).

## Install (user PATH)

```bash
mkdir -p ~/.local/bin
ln -sfn ~/AIDE_OS/aidectl/aidectl ~/.local/bin/aidectl
# ensure ~/.local/bin is on PATH
aidectl help
```

## Phase order

```bash
aidectl provision --profile grokaide-dev
aidectl config list
aidectl config set desktop.theme nes-markdown-learn
aidectl doctor
aidectl doctor --fix    # allowlisted only
```

## Docs

- Design: `docs/design/2026-07-27-aide-core-aidectl.md`
- Core lab: `docs/labs/platform/canonical/ubuntu-core/`

## Product boundary

Ships **education, family-safe automation, accessibility-oriented IoT hooks**.  
Does **not** ship adult/sextech modules under the AIDE_OS brand.
