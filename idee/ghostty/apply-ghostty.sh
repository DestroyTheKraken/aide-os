#!/usr/bin/env bash
# Install GrokAide Ghostty config + product themes into the user config dir.
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DEST="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"
THEMES_DEST="$DEST/themes"

mkdir -p "$THEMES_DEST"

install -m 644 "$SCRIPT_DIR/config" "$DEST/config"
install -m 644 "$SCRIPT_DIR/themes/grokaide-electric-dystopia" \
  "$THEMES_DEST/grokaide-electric-dystopia"
install -m 644 "$SCRIPT_DIR/themes/hickmedia-dracula-neon-obsidian" \
  "$THEMES_DEST/hickmedia-dracula-neon-obsidian"
install -m 644 "$SCRIPT_DIR/themes/nes-markdown-learn" \
  "$THEMES_DEST/nes-markdown-learn"

# Prefer standard config path; leave a pointer if an empty legacy file confuses people
if [ -f "$DEST/config.ghostty" ] && [ ! -s "$DEST/config.ghostty" ]; then
  # Ghostty 1.3 snap may still probe config.ghostty; point readers at the real file
  printf '# Deprecated empty stub — use ~/.config/ghostty/config\n' >"$DEST/config.ghostty"
fi

echo "==> Ghostty GrokAide config installed"
echo "    config:  $DEST/config"
echo "    themes:  grokaide-electric-dystopia (default — muted electric dystopia)"
echo "             hickmedia-dracula-neon-obsidian (bright neon)"
echo "             nes-markdown-learn (Markdown / UI-UX study)"
echo "    Reload: open a new Ghostty window (or Ghostty reload binding)"
echo "    Verify: ghostty +list-themes | grep -E 'grokaide|hickmedia|nes-markdown'"
echo "    Launchers: GrokAide Grok TUI / Lab Terminal → idee/run-in-terminal.sh (Ghostty first)"
echo "            then: ghostty -e grok  →  /doctor"
