# Grok-it + Brave Leo (xAI) — AIDE_OS integration checklist

**Keys:** You already entered xAI keys in Grok-it (Brave + Firefox) and Leo BYOM.  
**Never** store keys in this repo or chat. Bitwarden remains SoT.

## Grok-it (Brave + Firefox)

| Setting | Recommended |
|---------|-------------|
| API key | *(yours — already in extension)* |
| Model | Match console.x.ai (prefer current Grok coding/chat model you use) |
| Theme | System / Dark |
| System prompt | See WORKSPACES-APPS-URLS.md (LFCS tutor short prompt) |
| Context: page URL/title | **ON** for man7.org / LF portal |
| Test Connection | Must be green before relying on it |

**Brave extension id:** `dhbfcbdhkcdpincgknfflkghjedoicnh`  
Options: extension toolbar → Grok-it → options (or `chrome-extension://…/options.html`)

## Brave Leo — Bring your own model

1. Leo panel → **…** / settings → **Bring your own model** (wording varies by Brave version)  
2. Endpoint: `https://api.x.ai/v1`  
3. Model: e.g. `grok-4` (confirm in console)  
4. API key: already entered  
5. Save · send a one-line test: `Reply with: leo-xai-ok`

CLI cannot safely rewrite Leo’s encrypted storage; **UI verification is required.**

## Split of duties (AIDE_OS)

| Tool | Best for |
|------|----------|
| **Grok Build** (Ghostty) | Labs, files, VirtualBox, cluster, scripts |
| **Grok-it** | Highlight text on man pages / LF portal → quick explain |
| **Leo + xAI** | In-browser Q&A without leaving Brave |
| **Grok Web / X Grok** | Tutoring chat (watch rate limits on free X) |
| **Obsidian DAY-START** | Focus UI · LFCS Day One |

## Local URLs to keep handy

| URL | App |
|-----|-----|
| http://127.0.0.1:8101/ | `aide-day` |
| http://127.0.0.1:8099/aide/home/joshua/ | portfolio `serve.sh` |
| https://man7.org/linux/man-pages/ | man |
| LFS207 FHS notes | trainingportal.linuxfoundation.org (see workspaces doc) |
