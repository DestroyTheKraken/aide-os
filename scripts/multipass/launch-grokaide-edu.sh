#!/usr/bin/env bash
# Launch (or recreate) the GrokAide Education Multipass client.
set -euo pipefail

NAME="${GROKAIDE_EDU_NAME:-grokaide-edu}"
IMAGE="${GROKAIDE_EDU_IMAGE:-26.04}"
CPUS="${GROKAIDE_EDU_CPUS:-2}"
MEM="${GROKAIDE_EDU_MEM:-4G}"
DISK="${GROKAIDE_EDU_DISK:-32G}"
AIDE_ROOT="${AIDE_ROOT:-$HOME/AIDE_OS}"
GAMES_ROOT="${AIDE_OS_GAMES:-$HOME/AIDE_OS-games}"
CLOUD_INIT="${CLOUD_INIT:-$AIDE_ROOT/scripts/multipass/grokaide-edu-cloud-init.yaml}"

if multipass info "$NAME" &>/dev/null; then
  echo "Instance $NAME already exists:"
  multipass list
  echo "To recreate: multipass delete $NAME && multipass purge && $0"
  exit 0
fi

multipass launch "$IMAGE" \
  --name "$NAME" \
  --cpus "$CPUS" \
  --memory "$MEM" \
  --disk "$DISK" \
  --cloud-init "$CLOUD_INIT"

multipass mount "$AIDE_ROOT" "$NAME:/mnt/aide-os"
if [[ -d "$GAMES_ROOT" ]]; then
  multipass mount "$GAMES_ROOT" "$NAME:/mnt/aide-os-games" || true
fi

echo
multipass list
echo
echo "Enter lab:  multipass shell $NAME"
echo "Curriculum: /mnt/aide-os/Study_Projects"
