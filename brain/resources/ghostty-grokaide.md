# Ghostty for GrokAide

tags: [grok, terminal, theme, grokaide]

## Why Ghostty

Preferred **operator terminal** for Grok Build on AIDE_OS: GPU rendering, truecolor, modern keyboard protocols, easy themes — low rice tax.

## Themes (product)

| Theme | When |
|-------|------|
| `hickmedia-dracula-neon-obsidian` | Default work / labs (HickMedia neon + purple) |
| `nes-markdown-learn` | Markdown + UI/UX study (high contrast NES-inspired) |

Apply / reinstall:

```bash
bash ~/AIDE_OS/idee/ghostty/apply-ghostty.sh
```

Switch learning theme: edit `~/.config/ghostty/config` → `theme = nes-markdown-learn`, then open a new Ghostty window.

## Daily start

```bash
# Ghostty →
cd ~/AIDE_OS && grok
# /doctor  → expect truecolor, healthy keyboard
```

Launchers: **GrokAide Grok TUI** and **Lab Terminal** use `idee/run-in-terminal.sh` (Ghostty first).

## Stack reminder

- **Ghostty** = host for `grok` TUI  
- **Obsidian (Electron)** = Second Brain  
- **Future GrokAide Education UI** = Electron / Chromium over Tailnet (see `docs/design/2026-07-27-grokaide-electron-education-ui.md`)

#grokaide
