# shellcheck shell=bash
# aidectl provision — Phase 1

cmd_provision() {
  local profile="grokaide-dev"
  local dry_run=0
  local verify_only=0

  while [ $# -gt 0 ]; do
    case "$1" in
      --profile) profile="${2:-}"; shift 2 ;;
      --dry-run) dry_run=1; shift ;;
      --verify-only) verify_only=1; shift ;;
      -h|--help)
        cat <<'EOF'
Usage: aidectl provision [--profile NAME] [--dry-run] [--verify-only]

Idempotent apply of a known-good AIDE_OS seat profile.
Profiles: grokaide-dev, education-default
EOF
        return 0
        ;;
      *)
        log "unknown provision arg: $1"
        return 2
        ;;
    esac
  done

  local mode
  mode=$(detect_mode)
  local profile_file="$AIDECTL_HOME/profiles/${profile}.yaml"
  if [ ! -f "$profile_file" ]; then
    fail "profile not found: $profile_file"
    next_action "List profiles: ls $AIDECTL_HOME/profiles/"
    return 1
  fi

  log "mode=$mode profile=$profile"
  if [ "$dry_run" -eq 1 ]; then
    log "dry-run: would apply modules from $profile_file"
    grep -E '^\s+-\s+' "$profile_file" || true
    next_action "Re-run without --dry-run to apply"
    return 0
  fi

  if [ "$verify_only" -eq 0 ]; then
    # Write active profile stamp
    cp "$profile_file" "$AIDE_CONFIG_DIR/active-profile.yaml"
    printf '%s\n' "$mode" >"$AIDE_STATE/mode"
    printf '%s\n' "$profile" >"$AIDE_STATE/profile"

    # Seed classic-shim config defaults from schema-ish keys
    cat >"$AIDE_CONFIG_DIR/config.env" <<EOF
AIDE_PROFILE=$profile
AIDE_MODE=$mode
AIDE_DESKTOP_THEME=hickmedia-dracula-neon-obsidian
AIDE_DESKTOP_TERMINAL=ghostty
AIDE_LEARNING_TRACK=lfcs
AIDE_LEARNING_VAULT=$HOME/AIDE_OS/brain
AIDE_AI_PROVIDER=grok
AIDE_AI_PERMISSION_MODE=default
AIDE_IOT_HUB=none
AIDE_IOT_FAMILY_SAFE=true
AIDE_SECURITY_AUTO_HEAL=false
EOF

    if grep -q 'ghostty' "$profile_file" 2>/dev/null; then
      if [ -f "$AIDE_ROOT/idee/ghostty/apply-ghostty.sh" ]; then
        log "module ghostty"
        bash "$AIDE_ROOT/idee/ghostty/apply-ghostty.sh"
      else
        warn "ghostty module script missing"
      fi
    fi
  fi

  if grep -q 'verify_idee' "$profile_file" 2>/dev/null || [ "$verify_only" -eq 1 ]; then
    log "module verify_idee"
    if [ -f "$AIDE_ROOT/idee/verify-idee.sh" ]; then
      if bash "$AIDE_ROOT/idee/verify-idee.sh"; then
        ok "verify-idee PASS"
      else
        fail "verify-idee failed"
        next_action "Fix reported FAIL lines, then: aidectl provision --verify-only"
        return 1
      fi
    else
      fail "verify-idee.sh missing"
      return 1
    fi
  fi

  ok "provision complete mode=$mode profile=$profile"
  next_action "Open Ghostty → cd ~/AIDE_OS && grok → /doctor"
  return 0
}
