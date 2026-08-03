# How GrokAide designs persist in Obsidian

Obsidian **overwrites** `workspace.json` when you close the app. Named **Workspaces** are how layouts survive.

## Save your bridge (do once after it looks right)

1. Open vault `~/AIDE_OS/brain`
2. Open: `DAY-START` · `BRIDGE-KANBAN` · `USAGE-BRIDGE` · `DAY-01-START` (arrange panes)
3. `Ctrl+P` → **Workspaces: Save layout**
4. Name: **`GrokAide Bridge`**
5. Optional: Settings → Core plugins → Workspaces **on** (already on)

## Load every morning

- `Ctrl+P` → **Workspaces: Load layout** → **GrokAide Bridge**  
- Or: `aide-obsidian-day`

## Files that store design

| File | What it holds |
|------|----------------|
| `.obsidian/workspaces.json` | Named layouts (persist) |
| `.obsidian/workspace.json` | Last session (changes on quit) |
| `.obsidian/appearance.json` | Theme + **enabled CSS snippets** |
| `.obsidian/snippets/*.css` | Starfield / neon overrides |
| `.obsidian/plugins/*/data.json` | Plugin settings (Style Settings, Kanban) |
| `.obsidian/community-plugins.json` | Which plugins load |
| `.obsidian/bookmarks.json` | Bookmark list |

**Tip:** After big theme tweaks, Save layout again + commit vault configs you care about (no secrets).

## Theme stack (cyberpunk starship)

| Layer | Setting |
|-------|---------|
| Theme | **Cyber Glow** |
| Mode | **Dark** (`theme: obsidian`) |
| Accent | `#00f0ff` |
| Snippet | **`grokaide-starfield`** (must be enabled) |
| Wallpaper | `assets/wallpapers/grok-starfield-nebula.jpg` |
| Style Settings | Cyber Glow → Workspace Background → Custom |

Reload: **Ctrl+R** if snippet was just added.
