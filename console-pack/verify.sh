#!/usr/bin/env bash
# Verify console-pack (base | dev | enduser)
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/lib/common.sh"

MODE="${1:-base}"
ok=true
pass() { echo "  PASS: $*"; }
fail() { echo "  FAIL: $*" >&2; ok=false; }
warn() { echo "  WARN: $*"; }

echo "=== AIDE_OS console-pack verify (mode=$MODE) on $(hostname) ==="

# Always: base GUI
for p in plasma-desktop kwin-wayland sddm; do
  if dpkg -l "$p" 2>/dev/null | grep -q '^ii'; then
    pass "package $p"
  else
    fail "package $p missing"
  fi
done

if systemctl is-enabled sddm &>/dev/null; then
  pass "sddm enabled"
else
  fail "sddm not enabled"
fi

tgt=$(systemctl get-default 2>/dev/null || true)
if [[ "$tgt" == "graphical.target" ]]; then
  pass "default target graphical.target (reboot → GUI)"
else
  fail "default target is $tgt (want graphical.target)"
fi

if snap list termius-app &>/dev/null || command -v termius-app &>/dev/null; then
  pass "Termius installed"
else
  fail "Termius (termius-app) missing"
fi

if dpkg -l konsole 2>/dev/null | grep -q '^ii'; then
  fail "konsole still installed (should be Termius-only)"
else
  pass "konsole not installed"
fi

if ls /usr/share/wayland-sessions/*plasma* &>/dev/null 2>&1 \
   || ls /usr/share/xsessions/*plasma* &>/dev/null 2>&1; then
  pass "Plasma session desktop present"
else
  warn "no plasma session desktop file found yet"
fi

if ss -lntp 2>/dev/null | grep -q ':22'; then
  pass "ssh still listening (um690 / remote OK)"
else
  warn "ssh not seen on :22"
fi

# Optional modules (only required in dev+)
if [[ "$MODE" == "dev" || "$MODE" == "enduser" ]]; then
  if dpkg -l firefox 2>/dev/null | grep -q '^ii'; then
    pass "package firefox"
  else
    fail "package firefox missing"
  fi
  if [[ -f "$POLICY_DIR/policies.json" ]]; then
    pass "firefox policies.json"
  else
    fail "missing firefox policies"
  fi
  for f in aide-nextcloud.desktop aide-x.desktop aide-tubi.desktop; do
    if [[ -f "$APP_DIR/$f" ]]; then
      pass "system app $f"
    else
      fail "missing $APP_DIR/$f"
    fi
  done
  AUTO="$AIDE_HOME/.config/autostart/aide-nextcloud.desktop"
  if [[ -f "$AUTO" ]]; then
    pass "autostart Nextcloud"
  else
    fail "missing autostart $AUTO"
  fi
fi

if [[ "$MODE" == "base" ]]; then
  if dpkg -l firefox 2>/dev/null | grep -q '^ii'; then
    warn "firefox is installed (optional — ok if you added it)"
  else
    pass "firefox not installed (base-only as expected)"
  fi
fi

if [[ "$MODE" == "enduser" ]]; then
  if apt-mark showhold 2>/dev/null | grep -q firefox; then
    pass "firefox held"
  else
    fail "firefox not held"
  fi
fi

echo ""
if $ok; then
  echo "=== VERIFY OK ($MODE) ==="
  exit 0
else
  echo "=== VERIFY FAILED ===" >&2
  exit 1
fi
