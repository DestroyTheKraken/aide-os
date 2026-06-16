#!/usr/bin/env bash
# RAG sync + Modelfile.daily generation for Ara (PR 7–8).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LFCS_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
DEPLOY_DIR="${DEPLOY_DIR:-/opt/lfcs/secure-browser-forge}"
ENV_FILE="${DEPLOY_DIR}/.env"
KB="${LFCS_ROOT}/ara_tutor"
CONTEXT="${KB}/session/context.md"
BASE_MODelfile="${LFCS_ROOT}/docker/ollama/Modelfile.ara"
DAILY_MODelfile="${KB}/session/Modelfile.daily"
META_DIR="${KB}/meta"
MANIFEST="${META_DIR}/indexing-manifest.json"
STATE="${META_DIR}/last-sync-state.json"
SYNC_LOG="${LFCS_ROOT}/notifications/ara-sync.log"
EVAL_LOG="${LFCS_ROOT}/notifications/ara-eval.log"
SKIP_RAG_UPLOAD="${SKIP_RAG_UPLOAD:-0}"

log()  { printf '\033[1;34m[%s]\033[0m %s\n' "$(date '+%H:%M:%S')" "$*"; }
ok()   { printf '\033[1;32m  ✓ %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m  ! %s\033[0m\n' "$*"; }

[[ -f "${ENV_FILE}" ]] && set -a && source "${ENV_FILE}" && set +a

TS_IP="$(tailscale ip -4 2>/dev/null || echo '100.81.13.95')"
OWUI_URL="${OWUI_URL:-http://${TS_IP}:3082}"

mkdir -p "${META_DIR}" "${KB}/session"

# Prerequisites
[[ -f "${CONTEXT}" ]] || { echo "Missing ${CONTEXT} — run lfcs-portal-build.sh first" >&2; exit 1; }
[[ -f "${KB}/user-profile/profile-summary.md" ]] || {
  echo "Missing profile-summary.md — run lfcs-profile-summarize.sh" >&2
  exit 1
}

if [[ -x "${SCRIPT_DIR}/lfcs-profile-summarize.sh" ]]; then
  "${SCRIPT_DIR}/lfcs-profile-summarize.sh" >/dev/null 2>&1 || true
fi

# Auth probe (S0)
AUTH_MODE="none"
AUTH_HEADER=()
if curl -sf "${OWUI_URL}/health" >/dev/null 2>&1; then
  code="$(curl -s -o /dev/null -w '%{http_code}' "${OWUI_URL}/api/v1/knowledge/" 2>/dev/null || echo 000)"
  if [[ "${code}" == "401" || "${code}" == "403" ]]; then
    if [[ -z "${OPENWEBUI_API_KEY:-}" ]]; then
      echo "Open WebUI requires API key. Set OPENWEBUI_API_KEY in ${ENV_FILE}" >&2
      exit 1
    fi
    AUTH_MODE="bearer"
    AUTH_HEADER=(-H "Authorization: Bearer ${OPENWEBUI_API_KEY}")
  fi
else
  warn "Open WebUI not reachable at ${OWUI_URL} — RAG upload skipped"
  SKIP_RAG_UPLOAD=1
fi

# Build manifest + content hash
read -r CONTENT_HASH PROGRAM_DAY PROGRAM_CYCLE < <(python3 - <<PY
import hashlib, json, os
from pathlib import Path

kb = Path("${KB}")
include = [
    kb / "user-profile/profile-summary.md",
]
for p in sorted(kb.glob("knowledge/**/*.md")):
    include.append(p)
if Path("${CONTEXT}").exists():
    include.append(Path("${CONTEXT}"))

h = hashlib.sha256()
files = []
for p in include:
    if p.is_file():
        data = p.read_bytes()
        h.update(p.as_posix().encode())
        h.update(data)
        files.append({"path": p.relative_to(kb).as_posix(), "sha256": hashlib.sha256(data).hexdigest()[:16]})

manifest = {"content_hash": h.hexdigest()[:16], "files": files}
Path("${MANIFEST}").write_text(json.dumps(manifest, indent=2) + "\n")

ctx = Path("${CONTEXT}").read_text()
import re
day = re.search(r"program_day:\s*(\d+)", ctx)
cycle = re.search(r"program_cycle:\s*(\d+)", ctx)
print(manifest["content_hash"], day.group(1) if day else "0", cycle.group(1) if cycle else "1")
PY
)

# Load last state
PREV_HASH="" PREV_DAY="" PREV_CYCLE=""
if [[ -f "${STATE}" ]]; then
  read -r PREV_HASH PREV_DAY PREV_CYCLE < <(python3 -c "
import json; d=json.load(open('${STATE}'));
print(d.get('content_hash',''), d.get('program_day',''), d.get('program_cycle',''))
" 2>/dev/null || echo "  ")
fi

RAG_MS=0
NEED_RAG=0
if [[ "${CONTENT_HASH}" != "${PREV_HASH}" ]]; then
  NEED_RAG=1
fi

if [[ "${NEED_RAG}" == "1" && "${SKIP_RAG_UPLOAD}" != "1" ]]; then
  log "RAG upload (hash changed ${PREV_HASH} → ${CONTENT_HASH})..."
  START=$(date +%s%3N)
  UPLOADED=0
  while IFS= read -r relpath; do
    [[ -n "${relpath}" ]] || continue
    fpath="${KB}/${relpath}"
    [[ -f "${fpath}" ]] || continue
    if curl -sf "${AUTH_HEADER[@]}" -F "file=@${fpath}" "${OWUI_URL}/api/v1/files/" >/dev/null 2>&1; then
      UPLOADED=$((UPLOADED + 1))
    fi
  done < <(python3 -c "
import json
for f in json.load(open('${MANIFEST}'))['files']:
    print(f['path'])
")
  END=$(date +%s%3N)
  RAG_MS=$((END - START))
  ok "Uploaded ${UPLOADED} files to Open WebUI (manual collection attach may still be required — see guides/ARA_SYNC_API.md)"
else
  log "RAG upload skipped (hash unchanged or SKIP_RAG_UPLOAD)"
fi

# Modelfile.daily (separate idempotency)
NEED_MODEL=0
if [[ "${PROGRAM_DAY}" != "${PREV_DAY}" || "${PROGRAM_CYCLE}" != "${PREV_CYCLE}" || "${CONTENT_HASH}" != "${PREV_HASH}" ]]; then
  NEED_MODEL=1
fi

MODELFILE_MS=0
INFERENCE_MS=0
if [[ "${NEED_MODEL}" == "1" ]]; then
  log "Generating Modelfile.daily..."
  MSTART=$(date +%s%3N)
  python3 - <<PY
from pathlib import Path
base = Path("${BASE_MODelfile}").read_text()
ctx = Path("${CONTEXT}").read_text()
profile = ""
ps = Path("${KB}/user-profile/profile-summary.md")
if ps.exists():
    profile = ps.read_text()[:2000]
overlay = f'''

# TODAY SESSION OVERLAY (generated — do not edit)
PARAMETER num_ctx 4096

SYSTEM """
SESSION CONTEXT:
{ctx[:1500]}

LEARNER PROFILE EXCERPT:
{profile[:800]}
"""
'''
out = base + overlay
Path("${DAILY_MODelfile}").write_text(out)
PY
  if docker ps --format '{{.Names}}' 2>/dev/null | grep -q '^lfcs-ollama$'; then
    docker cp "${DAILY_MODelfile}" lfcs-ollama:/tmp/Modelfile.daily
    docker exec lfcs-ollama ollama create Ara -f /tmp/Modelfile.daily >/dev/null 2>&1 || warn "ollama create failed"
    ISTART=$(date +%s%3N)
    docker exec lfcs-ollama ollama run Ara 'Reply: Ara online' 2>/dev/null | head -3 >/dev/null || true
    IEND=$(date +%s%3N)
    INFERENCE_MS=$((IEND - ISTART))
  else
    warn "lfcs-ollama not running — Modelfile written only"
  fi
  MEND=$(date +%s%3N)
  MODELFILE_MS=$((MEND - MSTART))
  ok "Modelfile.daily regenerated (day ${PROGRAM_DAY}, cycle ${PROGRAM_CYCLE})"
fi

# Eval harness
RAG_PASS="0.00"
if [[ -x "${SCRIPT_DIR}/lfcs-ara-eval.sh" ]]; then
  EVAL_OUT="$("${SCRIPT_DIR}/lfcs-ara-eval.sh" 2>/dev/null | tail -1)" || EVAL_OUT=""
  if [[ "${EVAL_OUT}" == *rag_pass=* ]]; then
    RAG_PASS="$(echo "${EVAL_OUT}" | sed -n 's/.*rag_pass=\([0-9.]*\).*/\1/p')"
  fi
fi

python3 - <<PY
import json, datetime
from pathlib import Path
state = {
    "content_hash": "${CONTENT_HASH}",
    "program_day": int("${PROGRAM_DAY}"),
    "program_cycle": int("${PROGRAM_CYCLE}"),
    "updated_at": datetime.datetime.now().isoformat(),
    "model_config_ok": True,
}
Path("${STATE}").write_text(json.dumps(state, indent=2) + "\n")
PY

TS="$(date -Iseconds)"
echo "${TS} sync=ok auth_mode=${AUTH_MODE} rag_ms=${RAG_MS} modelfile_ms=${MODELFILE_MS} inference_smoke_ms=${INFERENCE_MS} rag_pass=${RAG_PASS} day=${PROGRAM_DAY} cycle=${PROGRAM_CYCLE}" >> "${SYNC_LOG}"
ok "ara-sync complete — logged to notifications/ara-sync.log"