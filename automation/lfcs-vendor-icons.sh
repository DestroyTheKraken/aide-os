#!/usr/bin/env bash
# Vendor Bootstrap Icons into portal/static (npm preferred, CDN fallback).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PORTAL="$(cd "${SCRIPT_DIR}/../portal" && pwd)"
VENDOR="${PORTAL}/static/vendor/bootstrap-icons"
VER="1.11.3"

mkdir -p "${VENDOR}/fonts"

if command -v npm >/dev/null 2>&1 && [[ -f "${PORTAL}/package.json" ]]; then
  (cd "${PORTAL}" && npm install --no-save "bootstrap-icons@${VER}" && npm run vendor:icons)
  echo "Bootstrap Icons vendored via npm → ${VENDOR}"
  exit 0
fi

curl -fsSL "https://cdn.jsdelivr.net/npm/bootstrap-icons@${VER}/font/bootstrap-icons.css" \
  -o "${VENDOR}/bootstrap-icons.css"
curl -fsSL "https://cdn.jsdelivr.net/npm/bootstrap-icons@${VER}/font/fonts/bootstrap-icons.woff2" \
  -o "${VENDOR}/fonts/bootstrap-icons.woff2"
echo "Bootstrap Icons vendored via CDN → ${VENDOR}"