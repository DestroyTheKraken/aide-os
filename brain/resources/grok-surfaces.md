---
tags: [grok, meta]
status: active
---

# Grok surfaces (what to use when)

> [!summary] TL;DR
> **Spark** = tutor chat. **Grok CLI / Buildian** = do work. **No permanent YOLO.**

| Surface | Best for | Default safety |
|---------|----------|----------------|
| **Spark** (`grok-http`) | Explain, quiz, rewrite notes, plan steps | No host file tools |
| **Grok CLI** (`grok` TUI) | Labs, scripts, multi-step automation | Plan mode; approve tools |
| **Buildian** | ACP chat inside Obsidian | **`permissionMode: default`** (not yolo) |

## Commands

```bash
# Product seat
cd ~/AIDE_OS && grok

# Headless one-shot (example — prefer interactive for labs)
# grok -p "Explain FHS /etc vs /var" --cwd "$HOME/AIDE_OS/brain"
```

## Auth recovery

If Spark chat fails with 401 / auth errors:

```bash
grok   # interactive; session refresh via CLI
# or: grok login   # if CLI documents re-auth
```

Never paste tokens into vault notes.

---

#grokaide
