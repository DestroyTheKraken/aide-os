# shellcheck shell=bash
# aidectl config — Phase 2 skeleton

_config_env_load() {
  if [ -f "$AIDE_CONFIG_DIR/config.env" ]; then
    # shellcheck disable=SC1090
    set -a
    # shellcheck source=/dev/null
    . "$AIDE_CONFIG_DIR/config.env"
    set +a
  fi
}

_config_key_to_env() {
  # desktop.theme -> AIDE_DESKTOP_THEME
  echo "$1" | tr '[:lower:].' '[:upper:]_' | sed 's/^/AIDE_/'
}

cmd_config() {
  local sub="${1:-list}"
  shift || true
  _config_env_load

  case "$sub" in
    list|ls)
      log "mode=$(detect_mode) schema=$SCHEMA_FILE"
      if [ -f "$SCHEMA_FILE" ]; then
        # Print node keys from schema
        grep -E '^\s{2}[a-z0-9_.]+:' "$SCHEMA_FILE" | sed 's/://g' | sed 's/^/  /' || true
      fi
      echo
      log "current values ($AIDE_CONFIG_DIR/config.env)"
      if [ -f "$AIDE_CONFIG_DIR/config.env" ]; then
        sed 's/^/  /' "$AIDE_CONFIG_DIR/config.env"
      else
        warn "no config.env — run: aidectl provision --profile grokaide-dev"
      fi
      next_action "Get a key: aidectl config get desktop.theme"
      ;;
    get)
      local key="${1:-}"
      if [ -z "$key" ]; then
        fail "usage: aidectl config get <node>"
        return 2
      fi
      local envk
      envk=$(_config_key_to_env "$key")
      # Map known short keys
      case "$key" in
        desktop.theme) envk=AIDE_DESKTOP_THEME ;;
        desktop.terminal) envk=AIDE_DESKTOP_TERMINAL ;;
        learning.track) envk=AIDE_LEARNING_TRACK ;;
        learning.vault) envk=AIDE_LEARNING_VAULT ;;
        ai.provider) envk=AIDE_AI_PROVIDER ;;
        ai.permission_mode) envk=AIDE_AI_PERMISSION_MODE ;;
        iot.hub) envk=AIDE_IOT_HUB ;;
        iot.family_safe_mode) envk=AIDE_IOT_FAMILY_SAFE ;;
        security.auto_heal) envk=AIDE_SECURITY_AUTO_HEAL ;;
        profile) envk=AIDE_PROFILE ;;
      esac
      local val="${!envk:-}"
      if [ -z "$val" ]; then
        fail "unset or unknown: $key"
        return 1
      fi
      printf '%s=%s\n' "$key" "$val"
      ;;
    set)
      local key="${1:-}"
      local val="${2:-}"
      if [ -z "$key" ] || [ -z "$val" ]; then
        fail "usage: aidectl config set <node> <value>"
        return 2
      fi
      if [ ! -f "$AIDE_CONFIG_DIR/config.env" ]; then
        fail "no config.env — run provision first"
        return 1
      fi
      local envk=""
      case "$key" in
        desktop.theme) envk=AIDE_DESKTOP_THEME ;;
        desktop.terminal) envk=AIDE_DESKTOP_TERMINAL ;;
        learning.track) envk=AIDE_LEARNING_TRACK ;;
        learning.vault) envk=AIDE_LEARNING_VAULT ;;
        ai.provider) envk=AIDE_AI_PROVIDER ;;
        ai.permission_mode)
          envk=AIDE_AI_PERMISSION_MODE
          if [ "$val" = "yolo" ] || [ "$val" = "always-approve" ]; then
            fail "permanent yolo / always-approve forbidden in product config"
            return 1
          fi
          ;;
        iot.hub) envk=AIDE_IOT_HUB ;;
        iot.family_safe_mode) envk=AIDE_IOT_FAMILY_SAFE ;;
        security.auto_heal) envk=AIDE_SECURITY_AUTO_HEAL ;;
        *)
          fail "unknown or not settable yet: $key (see aidectl config list)"
          return 1
          ;;
      esac
      if grep -q "^${envk}=" "$AIDE_CONFIG_DIR/config.env"; then
        sed -i "s|^${envk}=.*|${envk}=${val}|" "$AIDE_CONFIG_DIR/config.env"
      else
        echo "${envk}=${val}" >>"$AIDE_CONFIG_DIR/config.env"
      fi
      # Side-effect: theme switch updates Ghostty if applicable
      if [ "$key" = "desktop.theme" ] && [ -f "$HOME/.config/ghostty/config" ]; then
        if grep -q '^theme = ' "$HOME/.config/ghostty/config"; then
          sed -i "s|^theme = .*|theme = ${val}|" "$HOME/.config/ghostty/config"
        else
          echo "theme = ${val}" >>"$HOME/.config/ghostty/config"
        fi
        ok "Ghostty theme → $val (open new window to apply)"
      fi
      ok "set $key=$val"
      next_action "Verify: aidectl config get $key"
      ;;
    tree|palette)
      log "config palette (schema nodes)"
      if [ -f "$SCHEMA_FILE" ]; then
        awk '
          /^  [a-z0-9_.]+:$/ { key=$1; gsub(":","",key); desc="" }
          /description:/ { sub(/.*description:[[:space:]]*/,""); desc=$0 }
          /risk:/ { risk=$2; if (key!="") printf "  %-28s risk=%-6s %s\n", key, risk, desc; key="" }
        ' "$SCHEMA_FILE"
      fi
      next_action "Set: aidectl config set desktop.theme nes-markdown-learn"
      ;;
    -h|--help|help)
      cat <<'EOF'
Usage:
  aidectl config list
  aidectl config tree
  aidectl config get <node>
  aidectl config set <node> <value>
EOF
      ;;
    *)
      fail "unknown config subcommand: $sub"
      return 2
      ;;
  esac
}
