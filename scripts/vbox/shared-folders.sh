#!/usr/bin/env bash
# Attach shared folders to aide-lab (ro by default). VM must exist; prefer poweroff for first attach.
# Usage: shared-folders.sh [VM_NAME] [--i-know-rw]
set -euo pipefail

VM="${1:-aide-lab}"
RW=0
for a in "$@"; do
  [[ "$a" == "--i-know-rw" ]] && RW=1
done

AIDE_OS_HOST="${AIDE_OS_HOST:-$HOME/AIDE_OS}"
SHOTS_HOST="${SHOTS_HOST:-$HOME/Pictures/Screenshots}"

if ! VBoxManage showvminfo "$VM" &>/dev/null; then
  echo "shared-folders: VM not found: $VM" >&2
  exit 1
fi

# Remove + re-add for idempotency
remove_share() {
  VBoxManage sharedfolder remove "$VM" --name "$1" 2>/dev/null || true
}

add_ro() {
  local name="$1" path="$2"
  [[ -d "$path" ]] || { echo "skip missing path $path"; return 0; }
  remove_share "$name"
  VBoxManage sharedfolder add "$VM" --name "$name" --hostpath "$path" --readonly --automount
  echo "shared-folders: $name → $path (ro)"
}

add_rw() {
  local name="$1" path="$2"
  [[ -d "$path" ]] || { echo "skip missing path $path"; return 0; }
  remove_share "$name"
  VBoxManage sharedfolder add "$VM" --name "$name" --hostpath "$path" --automount
  echo "shared-folders: $name → $path (rw)"
}

add_ro AIDE_OS_ref "$AIDE_OS_HOST"
add_ro screenshots "$SHOTS_HOST"

if (( RW == 1 )); then
  WORK="${AIDE_OS_WORK:-$HOME/AIDE_OS-lab}"
  if [[ -d "$WORK" ]]; then
    add_rw AIDE_OS_work "$WORK"
  else
    echo "shared-folders: --i-know-rw but $WORK missing — skipped"
  fi
fi

echo "shared-folders: done (guest: /media/sf_* after Guest Additions + vboxsf group)"
