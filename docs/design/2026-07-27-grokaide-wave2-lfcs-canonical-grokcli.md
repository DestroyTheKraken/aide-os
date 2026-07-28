# Design: GrokAide Wave 2 — LFCS packs · Canonical · grok-cli

| Field | Value |
|-------|--------|
| **Date** | 2026-07-27 |
| **Status** | Implementing |
| **Vault** | `~/AIDE_OS/brain` |
| **Plan** | Session plan Wave 2 |

## Streams

1. **LFCS domain packs** — full beginner packs, exam-aligned; media collab before `status: final`.
2. **Canonical Academy track** — `bootcamp/canonical/` following https://canonical.com/academy.
3. **Spark `grok-cli`** — `GrokCliProvider` on dedicated vault; chat default remains `grok-http`.

## Media gate

- Drafts use `media/MEDIA-QUEUE.md` (`candidate` links allowed).
- `media/MEDIA.md` only after Josh collab.
- View links in **Obsidian Surfing**.

## grok-cli defaults

- Tools: `read_file,grep,list_dir`
- `yolo: false`
- Deny sensitive paths
- Agents: `lfcs-coach` (http), `lfcs-lab-agent` (cli)

## Key decisions

| Decision | Rationale |
|----------|-----------|
| Keep `grok-http` default chat | Low blast radius tutor |
| Read-only cli first | Headless-safe; no yolo |
| Media collab before final | User requirement |
| Surfing in brain vault | In-app YouTube/articles |

## Implementation notes

- Engine file: `~/.spark/engine/dist/providers/grok/GrokCliProvider.js`
- Registered as `grok-cli` in `main.js`
- Config: `~/AIDE_OS/brain/.spark/config.yaml`
