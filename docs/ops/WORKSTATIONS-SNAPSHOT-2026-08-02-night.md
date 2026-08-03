# Workstations snapshot — night of 2026-08-02

| Field | Value |
|-------|--------|
| **Host** | um690 · GNOME **Wayland** · Ubuntu 26.04 |
| **Workspace names** | **1 Control** · **2 Brain** · **3 Lab** · **4 Platform** (+ 5th spare) |
| **num-workspaces** | 5 · dynamic-workspaces = false |
| **Autostart** | `~/.config/autostart/aide-workstations.desktop` → `aide-workstations-start` |

## Target layout (Workstations 1–3)

| WS | Name | Morning open (autostart) |
|----|------|---------------------------|
| **1** | **Control** | **Grok Build** (Ghostty/TUI in AIDE_OS) · optional Ptyxis lab shell |
| **2** | **Brain** | **Obsidian** vault `~/AIDE_OS/brain` (DAY-START) · **Firefox** for docs/Grok.com |
| **3** | **Lab** | **Brave** (LF portal / tools) · note: VBox AIDE_OS if you use Core guest |
| **4** | **Platform** | Manual / later — cluster ops, Nextcloud TS |

Captured running at snapshot time: `grok`, `firefox`, `ptyxis`, `gedit` (morning note).

## Workstation 2 — SFTP / rsync (Nathon → pookie)

**Do this on WS2 (Brain) morning session:**

Source (NAS):
```text
/mnt/systems_admin/joshua/Backups/Nathon/nathon-bak-2026.tar.gz
```
(~38 GiB · do not interrupt a healthy Termius SFTP)

Dest:
```text
adm1@pookie  (or 100.71.166.67 / pookie.taile52ad9.ts.net)  →  /Backups/
```

**If Termius SFTP still running:** leave it; only verify progress.

**If stuck / failed:** fix SSH, then resume with rsync:

```bash
# 1) SSH from um690 (interactive once for host key)
ssh adm1@100.71.166.67 'hostname; df -h /Backups; ls -lh /Backups/nathon-bak-2026.tar.gz 2>/dev/null'

# 2) Resume-safe copy (no re-compress — already .tar.gz)
rsync -aH --partial --inplace --info=progress2 \
  -e 'ssh -o Compression=no -c aes128-gcm@openssh.com' \
  /mnt/systems_admin/joshua/Backups/Nathon/nathon-bak-2026.tar.gz \
  adm1@100.71.166.67:/Backups/

# 3) Verify sizes match, then unpack on pookie
# stat -c '%s' both paths  → expect 40437570081
```

## Media backup (this night)

NAS: `/mnt/systems_admin/kraken/backups/AIDE-OS-docs-media-LATEST`  
(~681 MB screenshots + Aug 2 screencasts + docs/ops + labs assets)

## Related

- `WORKSPACES-APPS-URLS.md` (earlier URL inventory)
- `SCREENSHARE-INDEX-2026-08-02.md`
- Desktop: `MORNING-TODOS-AND-RESTORE-NOTE.txt`
