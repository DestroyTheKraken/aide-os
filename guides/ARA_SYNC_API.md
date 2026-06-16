# Open WebUI RAG Sync API — Spike Checklist

**PR 7 gate:** Document live API behavior on um690 before relying on automation.

## S0 — Auth probe

```bash
OWUI=http://$(tailscale ip -4):3082
curl -s -o /dev/null -w '%{http_code}\n' "$OWUI/api/v1/knowledge/"
```

| Result | Action |
|--------|--------|
| 200 without key | `auth_mode=none` in ara-sync.log |
| 401/403 | Create API key in OWUI Admin → store in `${DEPLOY_DIR}/.env` as `OPENWEBUI_API_KEY` |

## S1 — Health

```bash
curl -sf "$OWUI/health"
```

## S2 — File upload

```bash
curl -sf -F "file=@ara_tutor/knowledge/linux/essential-commands.md" \
  -H "Authorization: Bearer $OPENWEBUI_API_KEY" \
  "$OWUI/api/v1/files/"
```

Poll: `GET /api/v1/files/{id}/process/status`

## S3 — Add to knowledge collection

```bash
POST /api/v1/knowledge/{collection_id}/file/add
```

Create collection `ara_tutor` in Admin → Workspace → Knowledge if missing.

## S4 — Model attach + native FC

- Attach `ara_tutor` collection to model **Ara**
- Verify native function calling is **disabled** so RAG auto-injects

## S5 — Chat eval

```bash
./automation/lfcs-ara-eval.sh
```

RAG suite must use `/api/chat/completions` — not `ollama run` alone.

## Manual fallback

Until spike complete:

```bash
./automation/lfcs-ara-knowledge.sh
```

Admin UI → attach collection to Ara model.