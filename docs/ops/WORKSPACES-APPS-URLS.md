# Workspaces · apps · URLs inventory (um690)

| Field | Value |
|-------|--------|
| **Captured** | 2026-08-02 ~04:40–04:44 local |
| **Host** | um690 · GNOME Wayland · Ubuntu |
| **GNOME workspaces** | **4** (static; dynamic-workspaces = false) |
| **Usage (SuperGrok)** | **23%** Grok Build · reset **Aug 7, 2026 11:58 PM** (screenshot 04-40) |

**Privacy:** No API keys. Tailscale admin URLs redacted to hostnames only. Do not commit secrets.

---

## Running applications (snapshot)

| App | Role | Notes |
|-----|------|--------|
| **Brave** (snap 1.93 / Chromium 151) | Main web · Ask Brave · Grok-it · Leo | Primary study + tooling browser |
| **Firefox** (snap) | Secondary web · Grok.com · libraries | Grok Search ext inactive; Clipper + Bitwarden active |
| **Obsidian** | Vault `~/AIDE_OS/brain` | GrokAide DAY-START workspace |
| **Grok Build** (Ghostty/TUI) | Agent director | Session: AIDE_OS design / notes |
| **VirtualBox · AIDE_OS** | Ubuntu Core 26 guest | Running · snapshot `post-console-conf` · console SSH banner |

### GNOME dash favorites (configured)

- `aide-grok-tui.desktop`
- `aide-lab-term.desktop`
- Firefox
- Nautilus  

*(Brave/Obsidian often launched outside favorites — still primary apps.)*

---

## Recommended GNOME workspace map (morning focus)

Assign these on **Workspace 1–4** for AIDE_OS / LFCS days:

| WS | Purpose | Apps / URLs |
|----|---------|-------------|
| **1 · Study** | LFCS focus only | **Obsidian** → `DAY-START` · optional **Ghostty** · optional `aide-day` browser tab |
| **2 · Lab** | Systems / Core | **VirtualBox AIDE_OS** · **Grok Build** · man pages |
| **3 · Browser tools** | Research / accounts | **Brave** (LF portal, console.x.ai, Bitwarden, Brave Ask) |
| **4 · Comms / relax** | Non-exam | X/Telegram later · music · social |

**Tomorrow:** Start on **WS1** with Obsidian (you already planned this).

---

## Brave — notable URLs / tabs (from session extract)

### Learning / LFCS (keep)

| URL | Use |
|-----|-----|
| https://trainingportal.linuxfoundation.org/learn/dashboard | LF dashboard |
| https://trainingportal.linuxfoundation.org/learn/course/linux-system-administration-essentials-lfs207/notes/linux-filesystem-tree-layout | **LFS207 FHS notes** ← Day One aligned |
| https://trainingportal.linuxfoundation.org/learn/course/a-beginners-guide-to-open-source-software-development-lfc102/… | LFC102 |
| https://openprofile.dev/ | LF profile |
| https://man7.org/linux/man-pages/ | man reference (pin) |
| https://ubuntu.com/desktop/flavors · https://ubuntucinnamon.org/ | Cinnamon / flavors research |
| https://cdimage.ubuntu.com/ubuntucinnamon/releases/… | ISO research |

### xAI / Grok (keep)

| URL | Use |
|-----|-----|
| https://console.x.ai/ · /home · team… | API keys / usage (key already entered by you) |
| https://x.com/i/grok · https://x.com/home | X Grok (rate-limited free tier) |
| https://grok.com/ | Web Grok (Firefox also) |
| chrome-extension://…/Grok-it options | Extension settings |

### Lab / platform (keep)

| URL | Use |
|-----|-----|
| https://console.tailscale.com/admin/machines | Tailnet machines |
| https://um690.taile52ad9.ts.net/apps/file | Nextcloud-style file app (TS) |
| http://127.0.0.1:3000/ | Local dev (if running) |
| http://127.0.0.1:8099/aide/home/joshua/ | Portfolio (when `serve.sh`) |
| http://127.0.0.1:8101/ | Day Start timer GUI (`aide-day`) |

### Tooling research (park / later)

| URL | Topic |
|-----|--------|
| https://rustdesk.com/ | Remote desktop |
| https://etcher.balena.io/ | Flash media |
| https://coder.com/docs | Remote workspaces |
| Telegram / Signal / AI voice isolation searches | Comms stack experiments |

### Personal / non-lab (don’t mix into study WS)

- Facebook, NCW libraries, FinalForms, calendar.google.com, Bitwarden vault UI  

---

## Firefox — notable URLs

| URL | Use |
|-----|-----|
| https://grok.com/ (+ conversation ids) | Web Grok |
| https://um690.taile52ad9.ts.net/apps/file | Files on TS |
| https://calendar.google.com | Calendar |
| http://127.0.0.1:3000/ | Local |
| Libraries / FinalForms / Facebook | Personal |

**FF extensions (active):** Bitwarden · Obsidian Web Clipper · Super Split View · Open in Sidebar · Tokyo Night Storm · Wayback · Scholar  

**FF Grok Search:** installed but **inactive** — optional enable later.

---

## Extensions · AI integration status

| Surface | Status | AIDE_OS integration |
|---------|--------|---------------------|
| **Grok-it (Brave)** id `dhbfcbdhkcdpincgknfflkghjedoicnh` | Installed · key entered by you | System prompt template below · model: match console (e.g. grok-4 / grok-3-mini) · **Test Connection** tomorrow if not green |
| **Grok-it (Firefox)** | You reported key added | Same prompt · verify Test Connection tomorrow |
| **Brave Leo · BYOM** | Key entered · prefs show `brave.ai_chat` present | Confirm custom endpoint **`https://api.x.ai/v1`** + model name in Leo UI tomorrow (cannot safely rewrite encrypted storage from CLI) |
| **Bitwarden** | Active both browsers | Keep SoT for key copies — not git |

### Recommended Grok-it system prompt (paste if empty)

```
You are GrokAide study helper for Joshua (LFCS + Ubuntu lab on um690).
Explain selected text briefly, man-page style when technical.
Prefer practice over pure memorization. No spoilers for Terminus puzzles unless asked.
Never ask for or repeat API keys. No school-SKU product pitches.
```

### Recommended Leo custom model fields (verify in UI)

| Field | Value |
|-------|--------|
| API base / endpoint | `https://api.x.ai/v1` |
| Model | `grok-4` or current console default (check console.x.ai Models) |
| API key | *(already entered by you — Bitwarden backup)* |
| Label | `xAI Grok (AIDE)` |

---

## VirtualBox guest (part of lab workspace)

| Field | Value |
|-------|--------|
| VM | **AIDE_OS** |
| State | Running (as of capture) |
| OS | Ubuntu Core 26 |
| NAT SSH hint | `jhick1585@10.0.2.15` (guest-reported) |
| Snapshot | `post-console-conf` |

---

## Tomorrow: workspace restore (easy)

| WS | Open |
|----|------|
| **1** | `aide-obsidian-day` → DAY-START · 25 min D01 |
| **2** | VirtualBox AIDE_OS · optional `grokAide-start --lab` |
| **3** | Brave: LFS207 FHS tab + man7.org · Grok-it ready |
| **4** | Closed / music / non-exam |

```bash
aide-obsidian-day          # WS1
# optional:
aide-day                   # timer GUI
brave --new-window "https://trainingportal.linuxfoundation.org/learn/course/linux-system-administration-essentials-lfs207/notes/linux-filesystem-tree-layout"
```

---

## Saved for you (human UI only)

1. Grok-it **Test Connection** green on Brave + Firefox  
2. Leo BYOM: confirm endpoint/model label; one chat “ping”  
3. Drag windows onto WS1–4 per map above  
4. Pin LFCS tabs in Brave  
5. Do **not** paste keys into chat/notes  

---

## Related

- Day Start: `brain/DAY-START.md`  
- Browser fun LFCS: `brain/bootcamp/lfcs/study/RELAX-15-BROWSER-LFCS.md`  
- Grok-it start: `docs/ops/GROKAIDE-START.md`  
- USER-PROFILE: `docs/ops/USER-PROFILE.md`  
