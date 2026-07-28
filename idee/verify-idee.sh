#!/usr/bin/env bash
# Verify GrokAide IDEE foundations.
set -euo pipefail
FAIL=0
ok() { echo "  OK  $*"; }
bad() { echo "  FAIL $*"; FAIL=1; }

echo "==> GrokAide IDEE verify"

# Vault
if [ -f "$HOME/AIDE_OS/brain/00-Home.md" ]; then
  ok "vault Home note"
else
  bad "missing ~/AIDE_OS/brain/00-Home.md"
fi

if [ -f "$HOME/AIDE_OS/brain/bootcamp/lfcs/00-MOC.md" ]; then
  ok "LFCS MOC"
else
  bad "missing LFCS MOC"
fi

# Labs
for lab in LAB-01-filesystem-tree LAB-02-users-groups LAB-03-systemd-journal; do
  if [ -f "$HOME/AIDE_OS/brain/bootcamp/lfcs/labs/${lab}.md" ]; then
    ok "lab $lab"
  else
    bad "missing lab $lab"
  fi
done

# Grok
if command -v grok >/dev/null 2>&1; then
  ok "grok on PATH: $(command -v grok)"
else
  bad "grok not on PATH"
fi

# Spark config for vault
if [ -f "$HOME/AIDE_OS/brain/.spark/config.yaml" ]; then
  if grep -q 'defaultProvider: grok-http' "$HOME/AIDE_OS/brain/.spark/config.yaml"; then
    ok "vault spark config grok-http"
  else
    bad "vault spark config missing grok-http default"
  fi
  if grep -q 'grok-cli:' "$HOME/AIDE_OS/brain/.spark/config.yaml"; then
    ok "vault spark config has grok-cli provider"
  else
    bad "vault spark config missing grok-cli"
  fi
else
  bad "missing vault .spark/config.yaml"
fi

if [ -f "$HOME/.spark/engine/dist/providers/grok/GrokCliProvider.js" ]; then
  ok "GrokCliProvider.js present"
else
  bad "GrokCliProvider.js missing"
fi

if [ -d "$HOME/AIDE_OS/brain/.obsidian/plugins/surfing" ]; then
  ok "Surfing plugin in brain vault"
else
  bad "Surfing plugin missing from brain"
fi

if [ -f "$HOME/AIDE_OS/brain/bootcamp/lfcs/domains/D01-essential-commands/00-domain.md" ]; then
  ok "LFCS D01 pack present"
else
  bad "LFCS D01 pack missing"
fi

if [ -f "$HOME/AIDE_OS/brain/bootcamp/canonical/00-MOC.md" ]; then
  ok "Canonical track MOC present"
else
  bad "Canonical track MOC missing"
fi

if command -v spark >/dev/null 2>&1; then
  if spark status 2>/dev/null | grep -q "$HOME/AIDE_OS/brain"; then
    ok "spark engine running for brain vault"
  else
    echo "  WARN spark engine not registered for brain (run: spark start $HOME/AIDE_OS/brain)"
  fi
else
  echo "  WARN spark CLI not on PATH"
fi

# Buildian safety in vault
BUILD="$HOME/AIDE_OS/brain/.obsidian/plugins/buildian/data.json"
if [ -f "$BUILD" ]; then
  if grep -q '"permissionMode": "yolo"' "$BUILD"; then
    bad "Buildian still yolo in brain vault"
  else
    ok "Buildian not yolo in brain vault"
  fi
else
  echo "  WARN no buildian data.json yet"
fi

# Launchers
for desk in aide-obsidian-brain.desktop aide-grok-tui.desktop aide-lab-term.desktop; do
  if [ -f "$HOME/.local/share/applications/$desk" ] || [ -f "$HOME/AIDE_OS/idee/$desk" ]; then
    ok "launcher present: $desk"
  else
    bad "missing launcher $desk"
  fi
done

# GNOME workspaces
if command -v gsettings >/dev/null 2>&1; then
  n=$(gsettings get org.gnome.desktop.wm.preferences num-workspaces 2>/dev/null || echo "?")
  echo "  INFO num-workspaces=$n"
fi

echo "==> Result"
if [ "$FAIL" -eq 0 ]; then
  echo "PASS"
  exit 0
else
  echo "FAIL ($FAIL checks)"
  exit 1
fi
