# GrokAide learning alarms / reminders (phone-alarm model)

Like a phone alarm: **set once · fires · you act**. Fits ADHD + structured days.

| Reminder | When | What you do |
|----------|------|-------------|
| **Sign-in / Day Start** | Morning | `aide-obsidian-day` · open DAY-START · 25 min D01 |
| **Next Sprint (station)** | **Tue 2026-08-04 10:00 AM PDT** | Open `~/SovereignAid/Weekday/Tuesday/01-Session-Start.md` · P0 glitch-debug |
| **Focus block** | On open of `aide-day` | Timer in GUI · no Grok thrash |
| **Mid-block stretch** | +15 min (manual phone alarm) | Stand · water · back to same note |
| **Sign-out / debrief** | End of block | 3 lines in session note · stop |
| **Usage check** | 2–3× / week | Screenshot SuperGrok Usage → USAGE-LOG |
| **Weekly reset** | **Fri Aug 7, 2026 11:58 PM** | Plan next week · optional rest |

## Next Sprint — Tue 4 Aug 2026 · 10:00 AM (this cycle)

| Channel | What |
|---------|------|
| **Calendar** | “AIDE_OS Next Sprint — glitch-debug + pad” 10:00–11:00 America/Los_Angeles |
| **Host notify** | `notify-send` at 10:00 (scheduled on um690) |
| **Docs** | Session Start · EOD · journal `docs/journal/2026-08-04-eod-next-sprint-10am.md` |
| **Phone (recommended)** | Alarm **10:00** — “AIDE_OS Next Sprint · Session Start” |

First actions at 10:00: smoke fam-media (RB-02) → TV glitch list → CPU sample (RB-06).

## Set on your phone (recommended)

1. **Tue 10:00** — “AIDE_OS Next Sprint” (today only; then resume daily 09:00)
2. **Daily 09:00** — “Into the Sequence — Obsidian DAY-START”
3. **Daily after focus** — “Debrief 3 lines · stop”
4. **Fri 23:50** — “SuperGrok weekly reset soon”

## Optional host notify (um690)

```bash
# one-shot test
notify-send "GrokAide" "Into the Sequence — open DAY-START (25 min)"

# cron example (edit with crontab -e) — 9:00 weekdays
# 0 9 * * 1-5 DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus notify-send "GrokAide" "Day Start — D01 only"
```

## Grok collaboration style (you asked for this)

| Event | Behavior |
|-------|----------|
| Visual site/TV change | Patch · **minimal/no chatter** |
| Traceback / break | Short Q/A or plan · next command |
| Study block | One domain · direct language |

Music stays entrancing; **structure stays boring-on-purpose** so attention has a rail.
