# Design: GrokAide — Obsidian Second Brain + Local IDEE

| Field | Value |
|-------|--------|
| **Date** | 2026-07-27 |
| **Status** | Implemented MVP scaffold |
| **Vault** | `~/AIDE_OS/brain` |
| **Desktop** | um690 GNOME IDEE scripts in `~/AIDE_OS/idee/` |
| **Track** | LFCS scaffold → Canonical later |

## Summary

GrokAide integrates **Grok Build** with a dedicated **Obsidian Second Brain** and a **local GNOME educational desktop profile** for DevOps bootcamp study (LFCS first).

Deep Spark↔Grok engine design: `~/SovereignAid/docs/design/2026-07-26-spark-engine-grok-build.md` (largely already on host).

## Locked decisions

- Dedicated vault under `~/AIDE_OS/brain` (not `$HOME`)
- LFCS track scaffold only (not full course packs day 1)
- um690 GNOME profile only (not Edbuntu ISO)

## Architecture

- Spark `grok-http` for tutor chat in vault
- Grok CLI / Buildian (`permissionMode: default`) for execution
- `bootcamp/lfcs/` MOC + labs + domains
- `idee/` apply + verify + `.desktop` launchers

## Verify

```bash
bash ~/AIDE_OS/idee/verify-idee.sh
spark start ~/AIDE_OS/brain
```

## Non-goals

Nextcloud AI shell (abandoned), HickMedia merge, permanent YOLO, full Edbuntu image.
