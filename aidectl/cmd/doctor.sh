# shellcheck shell=bash
# aidectl doctor — Phase 3 v0 (allowlisted fix only)

cmd_doctor() {
  local do_fix=0
  local ask=""
  while [ $# -gt 0 ]; do
    case "$1" in
      --fix) do_fix=1; shift ;;
      ask)
        shift
        ask="${*:-}"
        break
        ;;
      -h|--help)
        cat <<'EOF'
Usage:
  aidectl doctor
  aidectl doctor --fix
  aidectl doctor ask "symptom text"

Allowlisted fixes only (v0): re-apply Ghostty themes; re-run verify report.
EOF
        return 0
        ;;
      *)
        fail "unknown doctor arg: $1"
        return 2
        ;;
    esac
  done

  local mode
  mode=$(detect_mode)
  local issues=0

  log "mode=$mode"
  log "state=$AIDE_STATE config=$AIDE_CONFIG_DIR"

  if [ -f "$AIDE_STATE/profile" ]; then
    ok "active profile: $(cat "$AIDE_STATE/profile")"
  else
    warn "no active profile stamp"
    issues=$((issues + 1))
  fi

  if command -v grok >/dev/null 2>&1; then
    ok "grok: $(command -v grok)"
  else
    fail "grok not on PATH"
    issues=$((issues + 1))
  fi

  if command -v ghostty >/dev/null 2>&1; then
    ok "ghostty: $(command -v ghostty)"
  else
    warn "ghostty not on PATH"
    issues=$((issues + 1))
  fi

  if [ -f "$HOME/.config/ghostty/config" ] && grep -q 'hickmedia-dracula-neon-obsidian\|nes-markdown-learn' "$HOME/.config/ghostty/config" 2>/dev/null; then
    ok "Ghostty theme config present"
  else
    warn "Ghostty GrokAide theme missing"
    issues=$((issues + 1))
  fi

  if [ -f "$HOME/AIDE_OS/brain/00-Home.md" ]; then
    ok "vault Home present"
  else
    fail "vault missing ~/AIDE_OS/brain/00-Home.md"
    issues=$((issues + 1))
  fi

  if command -v tailscale >/dev/null 2>&1; then
    ok "tailscale binary present"
  else
    warn "tailscale not installed (companions still possible later)"
  fi

  # IoT capability note (not a failure)
  if [ -f "$AIDE_CONFIG_DIR/config.env" ]; then
    # shellcheck disable=SC1090
    . "$AIDE_CONFIG_DIR/config.env" 2>/dev/null || true
    ok "iot.hub=${AIDE_IOT_HUB:-unset} family_safe=${AIDE_IOT_FAMILY_SAFE:-unset}"
  fi

  if [ -n "$ask" ]; then
    log "ask (local AI plug — v0 prints triage only; Grok not auto-invoked)"
    printf '  symptom: %s\n' "$ask"
    printf '  triage: run aidectl doctor; check network (ip a, journalctl -b -p err); then grok in Ghostty with facts pasted.\n'
    printf '  policy: no unbounded root; Director approves high-impact changes.\n'
  fi

  if [ "$do_fix" -eq 1 ]; then
    log "allowlisted fix: re-apply Ghostty themes"
    if [ -f "$AIDE_ROOT/idee/ghostty/apply-ghostty.sh" ]; then
      bash "$AIDE_ROOT/idee/ghostty/apply-ghostty.sh"
      ok "ghostty themes re-applied"
    else
      fail "cannot fix: apply-ghostty.sh missing"
      issues=$((issues + 1))
    fi
  fi

  echo
  if [ "$issues" -eq 0 ]; then
    ok "doctor summary: healthy ($issues issues)"
    next_action "Optional: aidectl config tree | aidectl provision --verify-only"
    return 0
  else
    warn "doctor summary: $issues issue(s)"
    next_action "aidectl doctor --fix   # allowlisted only, or aidectl provision --profile grokaide-dev"
    return 1
  fi
}
