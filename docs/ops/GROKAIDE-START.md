# `grokAide-start` — how the morning session works

## Is `grok -p file && grok --resume` possible?

**Not the way you want.** On current Grok Build CLI:

| Flag | Behavior |
|------|----------|
| `-p` / `--single` | **One shot** → prints answer → **exits** |
| `--prompt-file` | Also **single-turn** → exits |
| `grok "initial prompt"` | **Interactive session** that **starts with** that prompt and **stays open** |
| `-c` / `--continue` | Continue **most recent** session for this **cwd** |
| `-r` / `--resume` | Resume by id/title or most recent |

So:

```bash
# BAD for “same chat”
grok -p @prompt.md && grok --resume   # first process ends; second is a new process

# GOOD for “same chat”
grok --cwd ~/AIDE_OS "$(cat ~/AIDE_OS/docs/ops/MORNING-CONTENT-PROMPT.txt)"
# or:
grokAide-start
```

**Best app to bind the command:** **Ghostty** (your Grok TUI host). Optional: GNOME launcher desktop entry later.

---

## Install / command

```bash
# already intended:
# ~/AIDE_OS/bin/grokAide-start → ~/.local/bin/grokAide-start
```

```bash
grokAide-start           # new morning session with prompt
grokAide-start --resume  # continue last AIDE_OS-cwd session
grokAide-start --lab     # lab ops seed prompt
```

---

## Podcast + dual-device audio

**Yes, as a format — not a single “Grok Podcast product.”**

| Piece | How |
|-------|-----|
| **You + GrokBuild** | TUI session; screen record Ghostty |
| **You + Grok Web + SuperWhisper** | Voice in browser; Stealth headset **PC** profile for mic + Grok audio |
| **Music (LIKA etc.)** | Phone (or second BT profile) so music **does not** enter the PC mic |
| **Record** | OBS on PC: Grok Web tab +/or GrokBuild + mic only (no phone music bus) |

Dual-connect headphones: music from phone, Grok from PC — good separation. Credit music; clear rights for monetized posts.

See `SOCIAL-CONTENT-PIPELINE.md`.
