# AIOS UI themes

Terminal-inspired palettes from user attachments (`.grok/docs/user-attachments`).

| Theme ID | TOML source | VS Code theme |
|----------|-------------|---------------|
| `kanagawa-wave` | `kanagawa-wave.toml` | AIOS Kanagawa Wave (default) |
| `rose-pine` | `rose-pine-default.toml` | AIOS Rosé Pine |
| `gotham` | `gotham-default.toml` | AIOS Gotham |
| `panda` | `panda-default.toml` | AIOS Panda |
| `posterpole` | `posterpole-default.toml` | AIOS Posterpole |

**Dashboard:** `portal/static/themes.css` + `theme.js`  
**Lessons:** `portal/static/lesson-md.css` (follows `data-theme`)  
**Workspace IDE:** `ide-themes.js` + `ide-theme-sync.js` (injected into `/ide/`); extension at `portal/code-server/extensions/aios-themes/`

Picker: sidebar footer · persisted in `localStorage` (`lfcs-ui-theme`)

**Docs/lessons:** `:bi-icon-name:` shortcodes in markdown (see `guides/GETTING_STARTED.md`)