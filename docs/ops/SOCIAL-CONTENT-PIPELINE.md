# Social media & content pipeline — Destroy The Kraken / AIDE_OS

| Field | Value |
|-------|--------|
| **Updated** | 2026-08-02 |
| **Brand** | Destroy The Kraken (public) · AIDE_OS lab (technical) |
| **Owner** | Joshua Hickman |
| **Goal** | Hireable proof + authentic learning content · **cash path** (VTS) stays separate from school-SKU |

---

## Meta notes (documentation SoT — honest, not polished fiction)

These notes capture **how Josh actually works**, so Grok and future-you don’t invent a fake “productivity influencer” persona.

| Reality | How we design content around it |
|---------|----------------------------------|
| **ADD / multi-track brain** | One camera-facing *thread* per video (“tonight = Core VM” or “tonight = usage calibration”) even if the desk is busy. Side quests → B-roll or “also on the desk” 10s, not three thesis statements. |
| **Learning Linux + DevOps + SysAdmin together** | Frame as **progressive ladder** (LabNET → Core VM → automation), not “mastered all.” Say what broke. |
| **Needs money / hireable output** | Every weekly video ends with **one tangible artifact**: snapshot name, script path, portfolio URL, package, or demo. CTA = hire / contact DTK, not “smash like” only. |
| **High energy, music, living-room sessions** | **LIKA Morning Living Room Sessions** (and similar) as **licensed-or-fair-use careful** background bed *or* “DJ channel I build to” shout-out — never claim you own the track. Prefer original beds / cleared samples for monetized posts. |
| **GrokBuild as co-editor** | Screen record while Building → Grok edits cut list + script → morning audio + post. That’s the product loop. |
| **Multi-angle + buddy podcast** | Webcam + Zoom Field Recorder = A/B angles; buddy chat = “lab podcast” segments. Mark buddy consent on file. |

**Public brand line (safe):**  
*Destroy The Kraken — career-change Linux/DevOps lab, rural IT, AI-assisted systems. Real desk. Real mistakes. Real artifacts.*

**Do not post:** client PII, Tailscale IPs, student/school SKU, raw secrets, unredacted console-conf.

---

## Crazy-simple weekly loop

```text
WHILE working (GrokBuild / lab)
  → screen record (one long master or chaptered sessions)
  → optional: webcam + field cam multi-angle
  → optional: buddy mic / LIKA-style focus music (clear rights)

END OF BUILD BLOCK (or end of night)
  → dump paths into CONTENT-LOG.md
  → GrokBuild: edit plan + full VO script + short captions

MORNING (scheduled prompt)
  → read teleprompter / VO
  → export final cut
  → post (X / YT / IG / LinkedIn variants)
  → log post URLs
```

### Roles

| Who | Job |
|-----|-----|
| **You** | Capture reality · VO · face · decide “what shipped” |
| **GrokBuild** | Cut list, script, titles, thumbnails text, captions, weekly recap |
| **Morning prompt** | Nudge: record audio + post + one hireable sentence |

---

## Capture kit (as available)

| Source | Use |
|--------|-----|
| Screen | GNOME screencast / OBS → `~/Videos/Screencasts/` |
| Webcam | Talking head / reaction |
| Zoom Field Recorder | Second angle, depth, “podcast desk” |
| Buddy | Consent + first name or nickname only in public |
| LIKA / DJ channel | Energy bed · **credit** · rights check before monetize |

---

## Show formats (rotate)

| Format | Length | Hireable hook |
|--------|--------|----------------|
| **Night log** | 3–8 min | “What I shipped” + path to artifact |
| **Lab podcast** | 15–30 min | Buddy + systems talk · one takeaway card |
| **Focus stream** | live / VOD | Screen + music · chapters · pin portfolio |
| **Skills cut** | 60–90 s | One skill bar (Linux / DevOps / prompts) |
| **Offer cut** | 30–45 s | VTS package / free check-in → destroythekraken.com |

---

## Platforms (start narrow)

| Platform | Primary format | CTA |
|----------|----------------|-----|
| **X** | Clips + thread + night log | Portfolio / DTK |
| **YouTube** | Weekly long + Shorts | Subscribe + link in |
| **LinkedIn** | 1 polished weekly (hireable tone) | Open to SysAdmin/DevOps entry + lab proof |
| **IG / TikTok** later | Vertical cuts only | Same |

**LinkedIn voice:** cleaner, less slang, same honesty.  
**X / YT voice:** desk energy OK; still no client data.

---

## Rights & safety

1. **Music:** credit LIKA / channel; prefer original or cleared audio for ads.  
2. **People:** buddy on camera = explicit OK.  
3. **Screen:** blur passwords, emails, TS IPs, customer tickets.  
4. **Claims:** “lab / learning / entry-level proof” — not “production SRE at FAANG.”  
5. **School:** never pitch unfinished education SKU.

---

## Automated documentation (content side)

| Trigger | File |
|---------|------|
| After record | Append `docs/ops/CONTENT-LOG.md` |
| After Grok edit session | Script path under `docs/labs/VIDEO-SCRIPT-*.md` |
| After post | URLs + date in CONTENT-LOG |
| Morning | Scheduled prompt (below) |

Session lab notes still go to `docs/labs/sessions/`.

---

## Morning scheduled prompt (copy into Grok / cron later)

```text
Morning content run — Destroy The Kraken

1) Read latest CONTENT-LOG.md and last night’s screencast path.
2) Open the video script for this week (or draft one if missing).
3) Give me:
   - Teleprompter VO (60–180s) for the cut we planned
   - 3 post captions: X (punchy), LinkedIn (hireable), YT description
   - 5 hashtags max, no spam
   - One “hireable artifact” sentence (what exists on disk / portfolio)
4) Remind me: redact secrets; credit music; CTA destroythekraken.com
5) After I say “posted”, append CONTENT-LOG with platform + URL placeholders for me to fill.

Do not invent metrics. Do not claim school pilots.
```

**Later automation:** Grok scheduler / calendar 09:00 local · or `~/AIDE_OS` note in LIFE-SYSTEMS calendar.

---

## Link to AIDE_OS product

Content **is** product marketing for:

- LabNET / multi-node proof  
- AIDE_OS Core VM + classic lab-in-a-box  
- Prompt engineering + DevOps design discipline  
- Usage calibration (basic SuperGrok tier can follow)

Learning track: `docs/labs/LEARNING-TRACK-AIDE-OS.md`  
Usage: `docs/ops/USAGE-CALIBRATION.md`

---

## This week’s tangible hireable bar

| Artifact | Status |
|----------|--------|
| Core VM `AIDE_OS` + `post-console-conf` | Live |
| Portfolio site (DTK brand · neon theme) | Local `~/AIDE_OS/site` |
| Design doc lab-in-a-box | `docs/design/2026-08-02-aide-lab-virtualbox.md` |
| Night video script | `docs/labs/VIDEO-SCRIPT-2026-08-02-night-close.md` |
| Content pipeline (this file) | Live |

**One sentence for LinkedIn this week:**  
*I stood up an Ubuntu Core lab appliance in VirtualBox, finished console-conf, and documented a learning track and usage-calibration workflow for AI-assisted DevOps study.*
