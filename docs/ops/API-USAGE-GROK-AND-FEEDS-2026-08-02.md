# Using APIs with AIDE_OS — Grok / xAI + second feed API

**Date:** 2026-08-02  
**Audience:** Josh (director) · Grok on `kraken`  
**Secrets:** Bitwarden SoT only — never put API keys in git, HTML, or public docs.

---

## 1. Two different “Grok” surfaces

| Surface | What it is | Best for AIDE_OS |
|---------|------------|------------------|
| **Grok Build (CLI / TUI)** | Agent on the machine: edits files, runs tools, plan mode, subagents | Day-to-day lab work, site edits, cluster scripts, Obsidian bridge |
| **xAI API (chat/completions)** | HTTP API billed separately (your “API reserve”) | Automation that must run without the TUI: hooks, n8n, learning-wall summarizer, ticket drafts |

**Rule of thumb**

- **Human in the loop, repo/cluster changes** → Grok Build on um690.  
- **Small, scripted, recurring jobs** → xAI API with a hard budget + log in `usage-tracker`.  
- **Sensitive / local-only** → Ollama / local tools first; do not send client PII to any cloud API.

SuperGrok Build usage bar ≠ API dollar spend. Track both (`USAGE-LOG` / calibration docs).

---

## 2. How to use the **xAI / Grok API** for AIDE_OS

### Safe patterns (platform)

1. **Lesson / wall summarizer** — paste or fetch a public LFCS/blog URL → short “today’s drill” card for TV / Obsidian `DAY-START` (no student PII).  
2. **Ops note rewriter** — raw shell notes → clean lab-notes markdown (you review before publish).  
3. **Client *draft* only** — after a VTS call, draft a non-PII checklist; you strip/edit before email.  
4. **aidectl-style dispatch** — small CLI that calls the API with a fixed system prompt + one task string; logs tokens/cost.  
5. **n8n / webhook** — Formspree (or future) webhook → summarize → write to a private Nextcloud folder (never auto-send to clients).

### Anti-patterns

- Auto-replying to website leads without human review  
- Putting `XAI_API_KEY` in k8s ConfigMaps, git, or browser JS  
- Streaming full cluster secrets / customer configs into prompts  
- Burning API budget on work the Build TUI already does better  

### Skeleton (local script — key from env)

```bash
# Key only via env or Bitwarden inject — never commit
export XAI_API_KEY="$(/* from secure store */)"

curl -sS https://api.x.ai/v1/chat/completions \
  -H "Authorization: Bearer $XAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "grok-4",
    "messages": [
      {"role": "system", "content": "You write short AIDE_OS lab notes. No PII. Markdown only."},
      {"role": "user", "content": "Summarize this LFCS topic for a 20-minute practice block: ..."}
    ]
  }'
```

Wire this into `~/AIDE_OS/scripts/` later as `aide-api-summarize.sh` once you confirm model id + spend limits. Log every call to the usage CSV.

### Grok Build CLI (not the HTTP API)

You already use this as the director seat:

- Interactive: `grok` / GrokAide launchers (Ghostty)  
- Scoped worktrees, plan mode, SMADP verify scripts  
- Prefer Build for anything that mutates LabNET or DTK site source  

---

## 3. “Tab Stacked MSN” — clarify, then wire

I did **not** find a product literally named “Tab Stacked MSN” in the AIDE_OS / DTK trees. Common meanings + how each fits:

| If you mean… | AIDE_OS use |
|--------------|-------------|
| **Browser tab stacks** (Edge/Firefox vertical tabs, tab groups) | Keep “AIDE day” stacks: LFCS · LabNET · DTK · VTS — launch via Ghostty/Obsidian, not an API |
| **MSN / Microsoft news feed** | Learning-wall **public news** carousel (headlines only); never client data |
| **Microsoft Graph** (Outlook/To Do/Calendar) | VTS calendar + “call this lead” tasks; keys in Bitwarden, Graph app registration |
| **A third-party “Tabstack” or MSN API key you bought** | Tell me the **exact product URL/dashboard** and we map endpoints → `aide` script + usage log |

**Until named:** treat the second key as a **feed or productivity API** and only:

1. Store in Bitwarden  
2. Call from **um690** (not browser JS on the public site)  
3. Write outputs to private Nextcloud / Obsidian, not destroythekraken.com  

If it is **Microsoft** (Graph / To Do / Outlook):

```text
AIDE_OS flow:
  Formspree lead (human approved)
    → Graph create To Do: "Call {name}" due today
    → optional calendar slot after you pick time
```

If it is **news/MSN-style feed** for the wall TV:

```text
cron on um690 → fetch headlines → filter → Grok API 3-bullet “why care for LFCS/ops”
  → static HTML or Nextcloud deck on NAD .103
```

Reply with the **service name / dashboard URL** (no keys) and we’ll bind a real script.

---

## 4. How this ties to the public DTK site

| Public site | Lab (AIDE_OS) |
|-------------|----------------|
| Message modal → Formspree → **Proton** | You read mail / Formspree dashboard |
| Spam: honeypot + timing + math (+ Formspree reCAPTCHA/Turnstile) | Optional: webhook → private queue only after approval |
| No API keys in HTML | Grok API + second API stay on um690 |

---

## 5. Formspree → Proton (one-time dashboard)

1. Formspree form `xwvjdqdj` → set **notification email** to your DTK Proton address.  
2. Enable **reCAPTCHA** or **Cloudflare Turnstile** in form settings.  
3. **Restrict to domain** `destroythekraken.com` (and www).  
4. Confirm a test message arrives in Proton (not spam).

Site never prints the Proton address (PII policy).

---

## 6. Next implementation tickets (when you say go)

1. `scripts/aide-api-summarize.sh` + usage-tracker append  
2. Named adapter for second API (after you identify it)  
3. Optional Formspree webhook → private Nextcloud `Leads/` (no auto-call)  
