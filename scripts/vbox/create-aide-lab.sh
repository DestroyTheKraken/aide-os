#!/usr/bin/env bash
# PR3 — Create/promote classic AIDE_OS lab VM (design 2026-08-02-aide-lab-virtualbox.md).
# Preferred: Option A — Learn Aide (Edubuntu 26.06). Fallback: Option C — Ubuntu Cinnamon.
#
# Usage:
#   bash create-aide-lab.sh              # auto: A if Learn Aide disk exists, else C
#   bash create-aide-lab.sh --start
#   bash create-aide-lab.sh --option a --start   # force Edubuntu Learn Aide
#   bash create-aide-lab.sh --option c --start   # force Cinnamon
#   bash create-aide-lab.sh --profile hybrid-llm
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VM_NAME="${VM_NAME:-aide-lab}"
DISPLAY_NAME="${DISPLAY_NAME:-AIDE_OS Lab}"
OPTION="auto"
PROFILE="demo"
START=0
BASE="${VBOX_BASE:-$HOME/VirtualBox VMs}"
SRC_CINNAMON="Ubuntu Cinnamon"
SRC_LEARN="Learn Aide (edubuntu 26.06)"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --start) START=1; shift ;;
    --option) OPTION="${2:-auto}"; shift 2 ;;
    --option=*) OPTION="${1#--option=}"; shift ;;
    --profile) PROFILE="${2:-demo}"; shift 2 ;;
    --profile=*) PROFILE="${1#--profile=}"; shift ;;
    --help|-h)
      sed -n '2,14p' "$0"
      exit 0
      ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
done

# Auto-prefer Edubuntu Learn Aide when disk present
if [[ "${OPTION,,}" == "auto" ]]; then
  if [[ -f "$BASE/$SRC_LEARN/$SRC_LEARN.vbox" ]] || VBoxManage showvminfo "$SRC_LEARN" &>/dev/null; then
    OPTION="a"
    log_pre="auto → Option A (Edubuntu Learn Aide)"
  else
    OPTION="c"
    log_pre="auto → Option C (Cinnamon fallback)"
  fi
fi

case "$PROFILE" in
  demo) MEM_MB=10240; CPUS=4 ;;
  hybrid-llm) MEM_MB=12288; CPUS=4 ;;
  *) echo "unknown profile: $PROFILE" >&2; exit 2 ;;
esac

log() { printf 'create-aide-lab: %s\n' "$*"; }
die() { echo "create-aide-lab: $*" >&2; exit 1; }
[[ -n "${log_pre:-}" ]] && log "$log_pre"

# --- already exists ---
if VBoxManage showvminfo "$VM_NAME" &>/dev/null; then
  log "VM already exists: $VM_NAME"
  VBoxManage showvminfo "$VM_NAME" | grep -E 'Name:|State:|Memory size|Number of CPUs|VRAM|NIC 1:|NIC 2:|Guest OS' | head -20
  bash "$ROOT/hostonly-net.sh"
  bash "$ROOT/shared-folders.sh" "$VM_NAME" || true
  if [[ "$START" -eq 1 ]]; then
    bash "$ROOT/preflight.sh" "$PROFILE"
    state=$(VBoxManage showvminfo "$VM_NAME" --machinereadable | sed -n 's/^VMState="\(.*\)"/\1/p')
    if [[ "$state" != "running" ]]; then
      log "starting GUI…"
      VBoxManage startvm "$VM_NAME" --type gui
    else
      log "already running"
    fi
  fi
  exit 0
fi

# --- host-only first ---
bash "$ROOT/hostonly-net.sh"
IFNAME=$(VBoxManage list hostonlyifs 2>/dev/null | awk '/^Name:/{print $2; exit}')
[[ -n "$IFNAME" ]] || die "no host-only interface after hostonly-net.sh"

apply_hw() {
  local vm="$1"
  log "hardware: ${MEM_MB}MB RAM, ${CPUS} CPU, VRAM 128 VMSVGA, dual NIC on $IFNAME"
  VBoxManage modifyvm "$vm" \
    --memory "$MEM_MB" \
    --cpus "$CPUS" \
    --vram 128 \
    --graphicscontroller vmsvga \
    --firmware efi \
    --nic1 nat \
    --nic2 hostonly \
    --hostonlyadapter2 "$IFNAME" \
    --clipboard-mode bidirectional \
    --draganddrop bidirectional \
    --audio-enabled on \
    --rtcuseutc on \
    --description "AIDE_OS classic lab (PR3 Option ${OPTION}). Design: docs/design/2026-08-02-aide-lab-virtualbox.md. Intent display: $DISPLAY_NAME"
}

grow_disk() {
  local vm="$1"
  local line uuid path
  # Prefer ImageUUID from SATA port 0
  line=$(VBoxManage showvminfo "$vm" --machinereadable | grep -E '^"SATA-ImageUUID-0-0"=' | head -1 || true)
  if [[ -z "$line" ]]; then
    line=$(VBoxManage showvminfo "$vm" --machinereadable | grep -E 'ImageUUID-0-0' | head -1 || true)
  fi
  uuid=$(sed -n 's/.*="\([^"]*\)"/\1/p' <<<"$line")
  if [[ -z "$uuid" || "$uuid" == "none" ]]; then
    log "WARN: no disk UUID for resize — skip"
    return 0
  fi
  log "growing disk toward 50 GiB (UUID $uuid)"
  VBoxManage modifymedium disk "$uuid" --resize $((50 * 1024)) \
    || log "WARN: resize failed (may already be ≥50G or medium locked)"
}

option_c() {
  log "Option C — clone registered '$SRC_CINNAMON' → $VM_NAME"
  VBoxManage showvminfo "$SRC_CINNAMON" &>/dev/null || die "source VM missing: $SRC_CINNAMON"

  local src_state
  src_state=$(VBoxManage showvminfo "$SRC_CINNAMON" --machinereadable | sed -n 's/^VMState="\(.*\)"/\1/p')
  [[ "$src_state" == "poweroff" || "$src_state" == "aborted" ]] \
    || die "source $SRC_CINNAMON must be powered off (state=$src_state)"

  if ! VBoxManage snapshot "$SRC_CINNAMON" list 2>/dev/null | grep -q 'cinnamon-archive'; then
    log "snapshot cinnamon-archive on source"
    VBoxManage snapshot "$SRC_CINNAMON" take cinnamon-archive \
      --description "pre-clone archive for AIDE_OS PR3 Option C $(date -Iseconds)"
  else
    log "cinnamon-archive already exists"
  fi

  log "clonevm (full) — may take a few minutes…"
  VBoxManage clonevm "$SRC_CINNAMON" \
    --name "$VM_NAME" \
    --register \
    --basefolder "$BASE" \
    --mode all

  apply_hw "$VM_NAME"
  grow_disk "$VM_NAME"
  bash "$ROOT/shared-folders.sh" "$VM_NAME"

  if ! VBoxManage snapshot "$VM_NAME" list 2>/dev/null | grep -q 'cinnamon-clone-base'; then
    VBoxManage snapshot "$VM_NAME" take cinnamon-clone-base \
      --description "Option C clone before guest provision $(date -Iseconds)"
  fi
  log "Option C complete"
}

option_a() {
  log "Option A — register + promote Learn Aide (fallback C on failure)"
  local vbox="$BASE/$SRC_LEARN/$SRC_LEARN.vbox"
  [[ -f "$vbox" ]] || { log "Learn Aide .vbox missing — fallback C"; option_c; return; }

  if ! VBoxManage showvminfo "$SRC_LEARN" &>/dev/null; then
    log "registervm"
    VBoxManage registervm "$vbox" || { log "register failed — fallback C"; option_c; return; }
  fi

  if VBoxManage showvminfo "$SRC_LEARN" --machinereadable | grep -q 'VMState="saved"'; then
    log "discarding saved state"
    VBoxManage discardstate "$SRC_LEARN" || true
  fi

  local vdi="$BASE/$SRC_LEARN/$SRC_LEARN.vdi"
  [[ -f "$vdi" ]] || { log "no VDI — fallback C"; option_c; return; }

  log "cloning Learn Aide → $VM_NAME"
  if ! VBoxManage clonevm "$SRC_LEARN" --name "$VM_NAME" --register --basefolder "$BASE" --mode all; then
    log "clone Learn Aide failed — fallback C"
    option_c
    return
  fi

  apply_hw "$VM_NAME"
  grow_disk "$VM_NAME"
  bash "$ROOT/shared-folders.sh" "$VM_NAME"
  VBoxManage snapshot "$VM_NAME" take learn-aide-promoted \
    --description "Option A clone $(date -Iseconds)" || true
  log "Option A clone complete — guest health still requires human GUI check"
}

case "${OPTION,,}" in
  a) option_a ;;
  c) option_c ;;
  *) die "unknown --option $OPTION (use a or c)" ;;
esac

log "=== summary ==="
VBoxManage showvminfo "$VM_NAME" | grep -E 'Name:|State:|Memory size|Number of CPUs|VRAM|Graphics Controller|NIC 1:|NIC 2:|Guest OS' | head -25
VBoxManage showvminfo "$VM_NAME" | grep -i 'Name:.*AIDE\|shared folder' || true
VBoxManage showvminfo "$VM_NAME" --machinereadable | grep -i SharedFolder || true

if [[ "$START" -eq 1 ]]; then
  bash "$ROOT/preflight.sh" "$PROFILE"
  log "starting $VM_NAME (GUI) — expect Edubuntu/classic desktop (NOT Core black TTY, NOT Cinnamon spare)"
  VBoxManage startvm "$VM_NAME" --type gui
  log "started. Guest next: Guest Additions if needed, user 'aide', shared folders /media/sf_*"
fi

log "done"
