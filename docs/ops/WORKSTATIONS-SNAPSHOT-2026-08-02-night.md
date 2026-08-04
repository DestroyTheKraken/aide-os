# Workstations snapshot — night of 2026-08-02

| Field | Value |
|-------|--------|
| **Host** | Lab control workstation · GNOME **Wayland** · Ubuntu 26.04 |
| **Workspace names** | **1 Control** · **2 Brain** · **3 Lab** · **4 Platform** (+ 5th spare) |
| **num-workspaces** | 5 · dynamic-workspaces = false |
| **Autostart** | `~/.config/autostart/aide-workstations.desktop` → `aide-workstations-start` |

## Target layout (Workstations 1–3)

| WS | Name | Morning open (autostart) |
|----|------|---------------------------|
| **1** | **Control** | **Grok Build** (Ghostty/TUI in AIDE_OS) · optional Ptyxis lab shell |
| **2** | **Brain** | **Obsidian** vault `~/AIDE_OS/brain` (DAY-START) · **Firefox** for docs/Grok.com |
| **3** | **Lab** | **Brave** (LF portal / tools) · optional lab VM |
| **4** | **Platform** | Manual / later — cluster ops |

Captured running at snapshot time: `grok`, `firefox`, `ptyxis`, `gedit` (morning note).

## Workstation 2 — large transfer follow-up

**Do this on WS2 (Brain) when needed:**

Large offline backup transfers (e.g. family archive to a remote host) stay **private**. Do not commit hostnames, Tailscale IPs, or account names into this public repo.

- Check morning note / private ops memory on the control plane for current job paths.
- Prefer resume-safe `rsync --partial --inplace` over restarting a healthy GUI SFTP mid-transfer.
- Verify byte sizes match before unpacking on the destination.

Private job archives: NAS under `kraken/jobs/` (not git).

## Media backup (this night)

NAS: `/mnt/systems_admin/kraken/backups/AIDE-OS-docs-media-LATEST`  
(~681 MB screenshots + Aug 2 screencasts + docs/ops + labs assets)

## Related

- `WORKSPACES-APPS-URLS.md` (earlier URL inventory)
- `SCREENSHARE-INDEX-2026-08-02.md`
- Desktop morning note (local only — do not commit secrets)
