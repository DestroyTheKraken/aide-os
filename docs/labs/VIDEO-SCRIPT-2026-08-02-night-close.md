# Video script — Night close · AIDE_OS Core VM

| Field | Value |
|-------|--------|
| **Date** | 2026-08-02 |
| **Picture lock** | `~/Videos/Screencasts/Screencast From 2026-08-02 01-40-45.webm` (~master timeline) |
| **Brand** | Destroy The Kraken |
| **Tone** | Calm, clear, career-changer honest — not hype |
| **Length target** | VO ~2.5–3.5 min under B-roll from screenshare · then **live VO end-card** · **outro** |

---

## Edit map (rough)

| Segment | Source | On-screen | VO |
|---------|--------|-----------|-----|
| **A · Cold open** 0:00–0:20 | Still: synthwave / DTK logo · cut to screencast start | Title card | Opening |
| **B · What we built** | Screencast: VirtualBox · Core · console-conf | UI only, no secrets | Body 1 |
| **C · How we learn** | Portfolio / design / USAGE panes (redact %) | Cutaways | Body 2 |
| **D · Network roadmap** | Simple diagram cards (host-only → Tailscale → TV) | Text cards | Body 3 |
| **E · Live close** | **Camera or desk mic · freeze last frame of screencast** | You on mic | **You read “Live close”** |
| **F · Outro** | Logo + URL card · 5–8 s music bed optional | End card | Outro line only |

**Hard stop:** After Live close line *“That’s where we stop tonight.”* → **cut to outro** (no more talk).

---

## Title card (on screen, 3 s)

```text
DESTROY THE KRAKEN
AIDE_OS Lab · Night Log
Ubuntu Core VM · 2026-08-02
```

---

## VO — Opening (read under title → first B-roll)

I’m Joshua Hickman — Destroy The Kraken.

Tonight I stood up an **AIDE_OS** lab appliance: **Ubuntu Core** in **VirtualBox**, finished **console-conf**, and locked the work in documentation so this isn’t just a one-off demo.

This channel — and this lab — is about making hard systems work in real life: hills, small shops, and a career change into Linux and DevOps. Not a school product. Not hype.

---

## VO — Body 1 · What we built

On the control machine, we pulled a current **Ubuntu Core 26** image, verified it, and created a VirtualBox machine named **AIDE_OS** — EFI, four gigs of RAM, two CPUs, NAT for first boot.

First boot on Core always looks scary: GRUB messages about `ubuntu-boot` and `EndEntire`. Those are normal. The win condition is **press enter to configure** — and I finished that path.

That snapshot is our checkpoint: **post-console-conf**. From here we can break things on purpose and roll back.

---

## VO — Body 2 · How we learn (basic Grok tier)

While we build, we **log SuperGrok usage** from Settings — percentage only, no secret numbers from the vendor.

The point isn’t to panic about credits. It’s to **calibrate**: how much real work equals how much of the weekly pool, so we can plan weekdays hard and keep **evenings and weekends free** when the plan works.

AIDE_OS is also a **learning track**: videos, reading, links, light notifications, and automated session notes — so a **basic Grok tier** user can follow without burning the whole week thrashing.

Local work — VirtualBox, docs, portfolio pages — barely moves the usage bar. Heavy GrokBuild sessions do. We use Build for decisions and hard debugging; we use local for reps.

---

## VO — Body 3 · What’s next (network & display)

Three upgrades, in order:

**One — host-only NIC.** A private link between the host and the guest so SSH and lab dashboards don’t depend on port-forward spaghetti.

**Two — Tailscale into the guest.** Same mesh as the rest of the lab — only after we agree on tags and access. I won’t open the tailnet casually.

**Three — Samsung TV as a network-attached display.** A learning wall: lessons, progress, notifications — hands on the keyboard, eyes on a bigger board.

That’s the roadmap. Not all of it lands in one night.

---

## LIVE CLOSE — you on camera / desk mic  
### (Read this aloud as the last spoken section of the night)

*[Pause. Look at camera or speak clean into mic. Freeze last frame of the screenshare under you or cut to face.]*

Tonight’s last entry:

I finished **console-conf** on **AIDE_OS** — Ubuntu Core in VirtualBox.

We documented the image, the VM, the learning track, and the usage log.

We are **not** joining Tailscale or the TV display tonight. Those wait for a calm next session, in order: host-only, then Tailscale if I approve, then the TV as a learning screen.

I’m measuring usage so I can work hard when it counts — and rest when the week’s work is done.

**That’s where we stop tonight.**

*[Beat · silence 1 s]*

---

## CUT TO OUTRO (no more dialogue after the stop line)

### Outro card (5–8 seconds)

```text
DESTROY THE KRAKEN
Joshua Hickman

AIDE_OS · Lab Portfolio
destroythekraken.com

Ubuntu · DevOps · AI-assisted ops
No school SKU · No client data on this page
```

### Optional VO (one line only, if you want voice on outro)

Destroy the Kraken — make the impossible work.

### Optional end sting
- 2–3 s of synth / silence  
- Fade logo  

---

## Lower-thirds (optional)

| Time | Text |
|------|------|
| Open | Joshua Hickman · Destroy The Kraken |
| Body 1 | AIDE_OS · Ubuntu Core 26 · VirtualBox |
| Body 2 | SuperGrok usage calibration |
| Body 3 | Host-only → Tailscale → TV NAD |
| Live close | Night log · 2026-08-02 |

---

## Producer checklist

- [ ] Mute or bleep any passwords / emails on console-conf frames  
- [ ] Blur Tailscale IPs / absolute home paths if visible  
- [ ] Keep DTK logo + neon theme consistent with portfolio site  
- [ ] Export master: `AIDE_OS-night-close-2026-08-02.mp4` (host-local; not multi-GB raw in git)  
- [ ] Link path in portfolio docs when published  

---

## Teleprompter-only paste (Live close)

```
Tonight’s last entry:

I finished console-conf on AIDE_OS — Ubuntu Core in VirtualBox.

We documented the image, the VM, the learning track, and the usage log.

We are not joining Tailscale or the TV display tonight.
Those wait for a calm next session, in order:
host-only, then Tailscale if I approve, then the TV as a learning screen.

I’m measuring usage so I can work hard when it counts —
and rest when the week’s work is done.

That’s where we stop tonight.
```
