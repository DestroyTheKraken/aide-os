#!/usr/bin/env bash
set -euo pipefail
cd "$HOME/AIDE_OS"
export PATH="$HOME/.grok/bin:$HOME/.local/bin:$PATH"
exec "$HOME/.grok/bin/grok"
