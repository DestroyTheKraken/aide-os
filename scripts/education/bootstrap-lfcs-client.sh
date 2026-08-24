#!/usr/bin/env bash
# Bootstrap a remote Ubuntu host as GrokAide LFCS education client.
# Usage: bootstrap-lfcs-client.sh [user@]host
set -euo pipefail

TARGET="${1:-edu@node1}"
AIDE_ROOT="${AIDE_ROOT:-$HOME/AIDE_OS}"
SSH_OPTS=(-o StrictHostKeyChecking=accept-new -o ConnectTimeout=10 -o BatchMode=yes)

if [[ -z "${1:-}" ]]; then
  echo "Usage: $0 [user@host]   (default: edu@node1)" >&2
fi

if [[ ! -d "$AIDE_ROOT/Study_Projects" ]]; then
  echo "Missing curriculum at $AIDE_ROOT/Study_Projects" >&2
  exit 1
fi

echo "==> Target: $TARGET"
echo "==> Sync curriculum from $AIDE_ROOT"

ssh "${SSH_OPTS[@]}" "$TARGET" 'mkdir -p ~/LFCS ~/LFCS/bin'

# Curriculum (no .git, no huge brain plugins if we can help it)
rsync -az --info=progress2 \
  --exclude '.git/' \
  --exclude 'brain/.obsidian/plugins/' \
  --exclude 'brain/.obsidian/themes/' \
  --exclude 'portal/static/vendor/' \
  --exclude 'node_modules/' \
  "$AIDE_ROOT/Study_Projects/" "$TARGET:~/LFCS/Study_Projects/"

rsync -az \
  "$AIDE_ROOT/guides/" "$TARGET:~/LFCS/guides/" 2>/dev/null || true

rsync -az \
  --exclude '.obsidian/plugins/' \
  --exclude '.obsidian/themes/' \
  "$AIDE_ROOT/brain/bootcamp/lfcs/" "$TARGET:~/LFCS/brain-lfcs/" 2>/dev/null || true

# Small docs
scp "${SSH_OPTS[@]}" \
  "$AIDE_ROOT/docs/EDUCATION-CLIENTS.md" \
  "$AIDE_ROOT/docs/FLAVOR-BASES.md" \
  "$TARGET:~/LFCS/" 2>/dev/null || true

ssh "${SSH_OPTS[@]}" "$TARGET" bash -s <<'REMOTE'
set -euo pipefail
cat > ~/LFCS/README.txt <<'EOF'
GrokAide LFCS education client
==============================
Study projects:  ~/LFCS/Study_Projects/
Objectives:      ~/LFCS/guides/OBJECTIVES_TRACKER.md
LFCS brain:      ~/LFCS/brain-lfcs/

Start:
  cd ~/LFCS/Study_Projects && less 00.md

Packages (once, needs sudo):
  bash ~/LFCS/install-lab-packages.sh

Platform (um690) authors content; do destructive labs here.
EOF

cat > ~/LFCS/install-lab-packages.sh <<'EOF'
#!/bin/bash
set -euo pipefail
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  git curl vim tmux tree jq man-db net-tools rsync openssh-server
echo "lab packages installed"
EOF
chmod +x ~/LFCS/install-lab-packages.sh

echo "LFCS tree:"
ls -la ~/LFCS
echo "OK — $(hostname) ready for Project 00"
REMOTE

echo
echo "Done. Connect:  ssh $TARGET"
echo "Then:           cd ~/LFCS/Study_Projects && less 00.md"
echo "Packages:       bash ~/LFCS/install-lab-packages.sh  # on node1, with sudo"
