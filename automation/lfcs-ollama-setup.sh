#!/usr/bin/env bash
# Pull lightweight Ollama models: Ara (tutor) + qwen2.5-coder:7b (coder).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LFCS_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
ARA_MODELFILE="${LFCS_ROOT}/docker/ollama/Modelfile.ara"

ARA_BASE="${LFCS_ARA_BASE:-llama3.2:3b}"
CODER_MODEL="${LFCS_CODER_MODEL:-qwen2.5-coder:7b}"
ARA_MODEL="${LFCS_ARA_NAME:-Ara}"

TS_IP="$(tailscale ip -4 2>/dev/null || echo '100.81.13.95')"
OLLAMA_HOST="${OLLAMA_HOST:-http://${TS_IP}:11434}"

log()  { printf '\033[1;34m[%s]\033[0m %s\n' "$(date '+%H:%M:%S')" "$*"; }
ok()   { printf '\033[1;32m  ✓ %s\033[0m\n' "$*"; }
die()  { printf '\033[1;31m  ✗ %s\033[0m\n' "$*" >&2; exit 1; }

wait_ollama() {
  local i
  for i in $(seq 1 60); do
    if sg docker -c 'docker exec lfcs-ollama ollama list' >/dev/null 2>&1 \
      || curl -sf "${OLLAMA_HOST}/api/tags" >/dev/null 2>&1; then
      ok "Ollama ready (${OLLAMA_HOST})"
      return 0
    fi
    sleep 2
  done
  die "Ollama not reachable. Start: docker compose up -d lfcs-ollama"
}

pull_if_missing() {
  local model="$1"
  local label="$2"
  if sg docker -c "docker exec lfcs-ollama ollama list" 2>/dev/null | grep -qF "${model%%:*}"; then
    ok "Already present: ${model}"
    return 0
  fi
  log "Pulling ${label} (${model})..."
  sg docker -c "docker exec lfcs-ollama ollama pull '${model}'"
  ok "Pulled: ${model}"
}

create_ara() {
  local tmp="/tmp/Modelfile.Ara"
  local daily="${LFCS_ROOT}/ara_tutor/session/Modelfile.daily"
  local src="${ARA_MODELFILE}"
  [[ -f "${daily}" ]] && src="${daily}" && log "Using ephemeral Modelfile.daily overlay"
  [[ -f "${src}" ]] || die "Missing ${src}"
  sg docker -c "docker cp '${src}' lfcs-ollama:${tmp}"
  sg docker -c "docker exec lfcs-ollama ollama create '${ARA_MODEL}' -f ${tmp}"
  ok "Created tutor: ${ARA_MODEL}"
}

remove_legacy() {
  local legacy tag
  for legacy in lfcs-tutor coder ara; do
    if sg docker -c "docker exec lfcs-ollama ollama list" 2>/dev/null | grep -qF "${legacy%%:*}"; then
      log "Removing legacy/unused tag ${legacy}..."
      sg docker -c "docker exec lfcs-ollama ollama rm '${legacy}'" 2>/dev/null || true
      ok "Removed ${legacy}"
    fi
  done
  # Drop all qwen3.6 variants (too slow for chat tutor on CPU)
  while IFS= read -r tag; do
    [[ -n "${tag}" ]] || continue
    log "Removing qwen3.6 model ${tag}..."
    sg docker -c "docker exec lfcs-ollama ollama rm '${tag}'" 2>/dev/null || true
    ok "Removed ${tag}"
  done < <(sg docker -c "docker exec lfcs-ollama ollama list" 2>/dev/null | awk 'NR>1 && $1 ~ /^qwen3\.6/ {print $1}')
}

hide_tutor_base() {
  if sg docker -c "docker exec lfcs-ollama ollama list" 2>/dev/null | grep -qF "${ARA_BASE%%:*}"; then
    sg docker -c "docker exec lfcs-ollama ollama rm '${ARA_BASE}'" 2>/dev/null || true
    ok "Hidden ${ARA_BASE} — dropdown shows ${ARA_MODEL} only"
  fi
}

smoke_test() {
  log "Smoke test ${ARA_MODEL}..."
  sg docker -c "docker exec lfcs-ollama ollama run '${ARA_MODEL}' 'Reply with exactly: Ara online'" 2>/dev/null | head -8
  ok "Smoke test done"
}

main() {
  wait_ollama
  remove_legacy
  pull_if_missing "${ARA_BASE}" "Ara tutor base"
  pull_if_missing "${CODER_MODEL}" "Coder"
  create_ara
  hide_tutor_base
  smoke_test
  echo ""
  ok "Ollama ready for Open WebUI — pick ${ARA_MODEL} (tutor) or ${CODER_MODEL} (coder)"
  echo "  API: ${OLLAMA_HOST}"
  sg docker -c "docker exec lfcs-ollama ollama list" 2>/dev/null || true
}

main "$@"