# Design: Flip UIs — Lab X + Grok applet

| Field | Value |
|-------|--------|
| **Date** | 2026-08-04 |
| **Status** | Direction + scaffold |
| **Station** | AIDE_OS Home (fam-media → Samsung) · gamepad-driven |
| **Not** | School SKU · full X client replacement |

---

## Flip stack (same glass, same pad)

| UI | Role | Status |
|----|------|--------|
| **Media** | Watch / Play / Listen / Apps | Live |
| **AIDE_OS** | Coffee-break cockpit · Work | Live |
| **Bridge** | Command Center overlay (inventory) | In progress |
| **Lab X** | Industry social + video search (X.com) | Planned |
| **Grok** | Grok Web + Grokpedia applet | Planned |

**UI Switch** (physical button TBD after clean bind) = Media ↔ AIDE_OS only.
**Bridge** = call/recall overlay (separate button).
**Lab X / Grok** = additional flip targets (dock tiles + optional pad chords).

---

## Lab X (gamepad X app)

### Intent

Couch-readable **Lab Industry** surface:

1. Curated X lists / topics (`cache/official-docs/x-lab-industry/ACCOUNTS.md`)
2. Keyword search for rural IT / home lab / mesh / media
3. Video-oriented results (X media first; link-out later)
4. One-button handoff: “Ask Grok about this”

### Constraints

- No tokens in public git
- Prefer read-only public endpoints / embedded web with allowlist
- Gamepad nav: D-pad rows · A open · B back · UI Switch leaves to Media/AIDE_OS

### MVP path

1. Static kiosk page `lab-x.html` loading curated links + search form
2. Optional WebView to `x.com/search` allowlisted
3. Later: API-backed cards if Bitwarden-held app keys exist

---

## Grok applet

### Intent

Station tool that uses:

| Tool | Use |
|------|-----|
| **Grok Web** | Chat / research while waiting on rsync / cluster |
| **Grokpedia** | Structured knowledge lookup when available in product |
| **Official docs cache** | Local `~/AIDE_OS/cache/official-docs` for grounded answers |

### MVP path

1. Tile **Grok** on AIDE_OS + Media → opens allowlisted Grok Web URL in kiosk
2. Bridge/Command Center “Ask about status” deep-link later
3. Optional local brief from `INDEX.md` of official docs

---

## Official docs self-heal (related)

Weekly timer refreshes `cache/official-docs` so flip UIs and Grok always have **current** manuals (8BitDo, Core, Frame, GitHub, X API hub, xAI docs).

```bash
~/AIDE_OS/scripts/ops/sync-official-docs.sh
systemctl --user status aide-official-docs.timer
```
