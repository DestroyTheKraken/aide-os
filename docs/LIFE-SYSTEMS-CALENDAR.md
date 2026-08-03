# Life systems — Family Google Calendar + reminders

**Updated:** 2026-07-31  
**SoT for events:** **Google Calendar (Family)** — not Grok, not Nextcloud  
**Timezone:** America/Los_Angeles  
**Goal:** Mobile + desktop reminders; protect reasonable hours

---

## Architecture

```text
Google Calendar (Family)  ←── SoT
        │
        ├── Mobile: Google Calendar app (notifications ON)
        └── Desktop: Browser PWA or GNOME Calendar (CalDAV if available)
        └── Optional later: Grok MCP google_calendar (read agenda only)
```

Grok does **not** replace Google as calendar SoT.

---

## Mobile (required)

1. Install **Google Calendar** (Play Store / App Store).  
2. Sign in with the Family calendar Google account.  
3. Settings → **Notifications** → enable event notifications + default reminder (e.g. 10–30 min).  
4. Phone Settings → Apps → Calendar → **allow notifications**; disable battery kill for Calendar.  
5. Create three recurring **time-block** calendars or colors (optional):  
   - **Cash / VTS**  
   - **Portfolio / Core**  
   - **Off / family**  

---

## Desktop (um690 — pick one)

### Option A — Browser PWA (fastest)

1. Open https://calendar.google.com in Chrome/Chromium/Brave.  
2. Install as app / “Create shortcut” / PWA.  
3. Enable desktop notifications for the site.  
4. Keep PWA in autostart if you want morning glance.

### Option B — GNOME Calendar + online account

1. Settings → Online Accounts → Google → enable Calendar.  
2. Open GNOME Calendar → enable Family calendars.  
3. Notifications via GNOME notification daemon.  
4. Do not disturb: schedule evening DND for reasonable hours.

### Option C — `gcalcli` (optional CLI, advanced)

Only if you want terminal agenda:

```bash
# Install when ready (example)
# pipx install gcalcli
# gcalcli --help
```

Requires Google OAuth in browser once; store tokens outside git. Prefer PWA if you do not want OAuth maintenance.

---

## Reminder hygiene (recommended defaults)

| Setting | Value |
|---------|--------|
| Default reminder | 15–30 minutes |
| All-day events | Morning notification day-of |
| Focus hours | Block on calendar; Grok/VTS respect “Off” blocks |
| Timezone | America/Los_Angeles everywhere |

---

## Orchestrator link

Domain **Life systems** (~10% of week):  
`/mnt/systems_admin/shared/memory/ORCHESTRATOR.md`

When Josh says “life systems / calendar / hours,” open this file and AdGuard README.

---

## Success criteria

- [ ] Phone buzzes for Family calendar events  
- [ ] Desktop shows same events + notifications  
- [ ] Cash / Portfolio / Off blocks exist for the coming week  
- [ ] No calendar secrets in git  
