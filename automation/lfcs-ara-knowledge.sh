#!/usr/bin/env bash
# Register ara_tutor knowledge in Open WebUI (manual step helper).
# Open WebUI → Workspace → Knowledge → upload /app/backend/data/ara_tutor
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LFCS_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
KB="${LFCS_ROOT}/ara_tutor"

log()  { printf '\033[1;34m[%s]\033[0m %s\n' "$(date '+%H:%M:%S')" "$*"; }
ok()   { printf '\033[1;32m  ✓ %s\033[0m\n' "$*"; }

[[ -d "${KB}" ]] || { echo "Missing ${KB}" >&2; exit 1; }

log "ara_tutor layout:"
find "${KB}" -maxdepth 3 -type d | sort
echo ""
ok "Mounted in lfcs-openwebui at /app/backend/data/ara_tutor"
echo "  1. Open Ara chat UI → Admin → Workspace → Knowledge"
echo "  2. Create collection 'ara_tutor' from the mounted folder"
echo "  3. Attach collection to model Ara in Workspace → Models"
echo ""
echo "Contents:"
echo "  user-profile/          — learner assessments (Big Five, DISC, Enneagram, …)"
echo "  knowledge/linux/       — 4 LFCS domain refs (PR 4 done)"
echo "  knowledge/networking/  — 3 LFCS network refs (PR 4 done)"
echo "  knowledge/weak-areas/  — grep-awk-sed, docker-compose, git-lfcs (PR 2–3 done)"
echo "  session/               — context.md + Modelfile.daily (generated)"
echo "  meta/                  — sync manifests (generated, PR 7)"