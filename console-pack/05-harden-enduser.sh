#!/usr/bin/env bash
# H — End-user harden (run ONLY when UI is “what you want”)
# Iterative: start soft; tighten hide-kcms.list and polkit over time.
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/lib/common.sh"
need_root

log "H: Harden end-user (mobile-like defaults)"

# 1) Hold core packages so casual remove fails
HOLD_PKGS=(firefox plasma-desktop plasma-workspace kwin-wayland sddm)
for p in "${HOLD_PKGS[@]}"; do
  if dpkg -l "$p" 2>/dev/null | grep -q '^ii'; then
    apt-mark hold "$p" || true
    log "held $p"
  fi
done

# 2) Protect system app directory
chown -R root:root /usr/share/aide-os
chmod -R a+rX /usr/share/aide-os
# user cannot delete these:
chmod 755 /usr/share/aide-os/applications
find /usr/share/aide-os/applications -name '*.desktop' -exec chmod 644 {} \;

# 3) Remove debug launchers from user menu
rm -f /usr/share/applications/aide-nextcloud-windowed.desktop

# 4) Soft KCM hide via plasma-applications.menu is complex; document iterative approach
HIDE_LIST="$PACK_ROOT/plasma/hide-kcms.list"
if [[ -f "$HIDE_LIST" ]]; then
  log "KCM hide list present — apply manually / future automation:"
  grep -v '^#' "$HIDE_LIST" | grep -v '^$' || true
  warn "Full KCM lockdown is iterative — edit hide-kcms.list and re-run harden as needed"
fi

# 5) Minimal polkit stub: deny packagekit remove of firefox (if packagekit present)
mkdir -p /etc/polkit-1/rules.d
cat > /etc/polkit-1/rules.d/50-aide-os-protect-system-apps.rules << 'EOF'
// AIDE_OS: deny removing critical packages via PackageKit (iterative)
polkit.addRule(function(action, subject) {
    if (action.id == "org.freedesktop.packagekit.package-remove") {
        // Still allow admins in wheel/sudo if you want — tighten later
        if (!subject.local) return polkit.Result.NO;
    }
});
EOF

log "H done (baseline). Iterate: Settings modules, polkit, favorites lock."
