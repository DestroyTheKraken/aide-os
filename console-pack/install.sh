#!/usr/bin/env bash
# AIDE_OS console-pack — iterative installer
#
# Default: base GUI only. Optional modules when you ask for them.
#
#   sudo bash install.sh                  # same as --base
#   sudo bash install.sh --base
#   sudo bash install.sh --base --autologin
#   sudo bash install.sh --add=firefox
#   sudo bash install.sh --add=system-apps
#   sudo bash install.sh --add=nextcloud-autostart
#   sudo bash install.sh --phase=dev       # base + all modules (full console)
#   sudo bash install.sh --phase=harden
#   bash install.sh --verify [base|dev|enduser]
set -euo pipefail

PACK_ROOT="$(cd "$(dirname "$0")" && pwd)"
source "$PACK_ROOT/lib/common.sh"

MODE="base"
AUTOLOGIN=0
DO_VERIFY=0
VERIFY_MODE="base"
ADD_MODULES=()
STACK=""

usage() {
  cat << EOF
AIDE_OS console-pack — iterative (add only what you want)

Base (default):
  sudo bash install.sh
  sudo bash install.sh --base [--autologin]

  → Plasma + KWin Wayland + SDDM + Settings + Dolphin + Network
  → **Termius only** (Local Terminal / SSH) — no Konsole
  → Boots graphical.target + SDDM
  → No Firefox / web apps until you ask

Add-on modules (run anytime later):
  sudo bash install.sh --add=firefox              # Firefox + Nextcloud homepage policy
  sudo bash install.sh --add=system-apps          # Nextcloud / X / Tubi launchers
  sudo bash install.sh --add=nextcloud-autostart  # open Nextcloud on login
  sudo bash install.sh --add=theme-support        # Aurorae (Plasma only)
  sudo bash install.sh --add=functionality        # widgets/store/Discover fix (no theme change)
  sudo bash install.sh --stack=plasma-krohnkite   # Plasma Wayland + KWin + Krohnkite (current)
  sudo bash install.sh --stack=mutter-forge       # GNOME/Mutter + Forge (legacy alternate)

Full stack in one go (only if you want everything):
  sudo bash install.sh --phase=dev

Harden (later, when UI feels done):
  sudo bash install.sh --phase=harden

Verify:
  bash install.sh --verify base
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --base) MODE="base"; shift ;;
    --phase=*) MODE="${1#*=}"; shift ;;
    --phase) MODE="${2:?}"; shift 2 ;;
    --add=*) ADD_MODULES+=("${1#*=}"); MODE="add"; shift ;;
    --add) ADD_MODULES+=("${2:?}"); MODE="add"; shift 2 ;;
    --stack=*) STACK="${1#*=}"; MODE="stack"; shift ;;
    --stack) STACK="${2:?}"; MODE="stack"; shift 2 ;;
    --autologin) AUTOLOGIN=1; shift ;;
    --verify)
      DO_VERIFY=1
      if [[ "${2:-}" == "base" || "${2:-}" == "dev" || "${2:-}" == "enduser" ]]; then
        VERIFY_MODE="$2"; shift 2
      else
        VERIFY_MODE="base"; shift
      fi
      ;;
    -h|--help) usage; exit 0 ;;
    *) die "unknown arg: $1 (try --help)" ;;
  esac
done

if [[ "$DO_VERIFY" -eq 1 ]]; then
  bash "$PACK_ROOT/verify.sh" "$VERIFY_MODE"
  exit $?
fi

need_root
export AIDE_AUTOLOGIN="$AUTOLOGIN"

run_add() {
  local m=$1
  case "$m" in
    firefox)              bash "$PACK_ROOT/02-firefox.sh" ;;
    system-apps)          bash "$PACK_ROOT/03-system-apps.sh" ;;
    nextcloud-autostart)  bash "$PACK_ROOT/04-session-dev.sh" ;;
    theme-support)        bash "$PACK_ROOT/06-theme-support.sh" ;;
    functionality)        bash "$PACK_ROOT/12-plasma-functionality.sh" ;;
    *) die "unknown module: $m (firefox|system-apps|nextcloud-autostart|theme-support|functionality)" ;;
  esac
}

case "$MODE" in
  base)
    log "Installing BASE GUI only (iterative starting point)"
    bash "$PACK_ROOT/00-base-gui.sh"
    bash "$PACK_ROOT/verify.sh" base || warn "verify had warnings — check console"
    log "Base GUI ready. Ask Grok for the next piece when you want it."
    ;;
  add)
    [[ ${#ADD_MODULES[@]} -gt 0 ]] || die "no --add modules"
    for m in "${ADD_MODULES[@]}"; do
      log "Adding module: $m"
      run_add "$m"
    done
    log "Add-ons done."
    ;;
  dev)
    log "Full dev phase (base + firefox + system-apps + nextcloud-autostart)"
    bash "$PACK_ROOT/00-base-gui.sh"
    bash "$PACK_ROOT/02-firefox.sh"
    bash "$PACK_ROOT/03-system-apps.sh"
    bash "$PACK_ROOT/04-session-dev.sh"
    bash "$PACK_ROOT/verify.sh" dev || warn "verify reported issues"
    ;;
  harden)
    bash "$PACK_ROOT/05-harden-enduser.sh"
    bash "$PACK_ROOT/verify.sh" enduser || warn "enduser verify incomplete"
    ;;
  stack)
    case "$STACK" in
      plasma-krohnkite|plasma|kwin-krohnkite)
        bash "$PACK_ROOT/11-plasma-krohnkite.sh"
        ;;
      mutter-forge|gnome-forge|mutter)
        bash "$PACK_ROOT/10-mutter-forge.sh"
        ;;
      *)
        die "unknown stack: $STACK (plasma-krohnkite|mutter-forge)"
        ;;
    esac
    ;;
  *)
    die "unknown mode: $MODE"
    ;;
esac

log "Done (mode=$MODE)"
