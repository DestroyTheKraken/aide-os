# Browser UX — Mobile-First & Desktop

## How responsiveness works

| Layer | Behavior |
|-------|----------|
| **LFCS Portal** (`:3080`) | Mobile-first CSS, sticky bottom bar on phones/tablets, card layout for cluster |
| **Mullvad stream** (`:3001`) | Server renders fixed **1280×720**; **CSS scaling** stretches to your viewport (any size) |

This avoids the WebSocket crash from auto-resize while fitting both phone and monitor.

## Mobile / Tablet (j-tab)

1. Open Portal first — bottom dock: **Browser** / **Today**
2. Log into Mullvad Browser — accept cert warning
3. In **Selkies sidebar** (left edge):
   - Tap **Fullscreen** for max workspace
   - Enable **Trackpad** for touch pointer
   - Use **On-screen keyboard** button when SSH typing
4. **Do not** change resolution in Screen settings (stay 1280×720)
5. Landscape mode recommended for terminal sessions

## Desktop

1. Same URLs — layout uses two-column actions and table view
2. Stream upscales cleanly on large monitors via CSS scaling
3. Use mouse normally; browser cursors enabled for precision
4. Bookmark Portal inside Firefox as your homepage

## If stream disconnects

```bash
~/Projects/aios-ed/automation/lfcs-fix-browser-websocket.sh
```

Then hard-refresh the browser tab (clear site data).