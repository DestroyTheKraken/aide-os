# fam-media full scan — 2026-07-12

Scan host: `fam-media` (192.168.20.104) via SSH from um690.  
**Constraint:** improve functionality only — **no layout/theme changes**.

---

## Snapshot

| Item | Value |
|------|--------|
| Hardware | Lenovo M93p · Haswell iGPU · 16 GiB RAM · ~98 G root (15 G used) |
| OS | Ubuntu 26.04 LTS · kernel 7.0.0-27 |
| Session | **Plasma Wayland** (active) · SDDM · KWin Wayland |
| Uptime at scan | ~3 min after boot |
| Network | Lab `.104` · Tailscale `100.119.236.78` OK |
| Apps (snaps) | Firefox 152, Bitwarden, Obsidian, Termius (policy), microk8s, prometheus |

---

## What works

- Boots to GUI (`graphical.target`, SDDM enabled, GDM inactive)
- Plasma + KWin Wayland session running for `joshua`
- Firefox installed + Nextcloud homepage policies present
- Aurorae decorations in use (`Utterly-Round-Dark` in `kwinrc`) — theme left alone
- User themes present: Tokyo Night colors/plasma, Carl/Utterly aurorae, Flight-Splash
- Tailscale mesh OK

---

## Problems (evidence-based)

### 1. Widget store / “Get New…” broken (high confidence)

`plasmashell` logs:

```text
Type NewStuff.DialogContent unavailable
Type Kirigami.ApplicationItem unavailable
… DrawerHandle … component versioning
kf.newstuff.widgets: Error creating QtQuickDialogWrapper
```

Cause: lean install left **incomplete Kirigami / NewStuff QML stack**. Store UI cannot build.

**Fix:** install missing QML + Discover (see `12-plasma-functionality.sh`).

### 2. Stock plasmoids incomplete / noisy (medium)

```text
Could not find required file "mainscript" for … icontasks / activitypager / minimizeall
```

Several `/usr/share/plasma/plasmoids/*` trees are **metadata-only** (Ubuntu Plasma 6.6 packaging ships stubs for some applets). Combined with missing add-on widgets, panel/widget explorer is fragile.

**Fix:** reinstall `plasma-desktop{,-data}` + install `plasma-widgets-addons`.

### 3. plasmashell ~60% CPU (high impact)

PID plasmashell pegged ~60% shortly after login while store/widget explorer errors fire.

Likely mix of:

- QML store failures retrying
- Third-party plasmoids: `AndromedaLauncher`, `KdeControlStation`, `com.github.k-donn.plasmoid-wunderground`
- microk8s also active (~8% CPU / 2.3% RAM) — unrelated to layout but adds load

**Fix:** functionality packages + optional stop microk8s + if needed temporarily remove bad user plasmoids (does not change wallpaper/colors/aurorae theme).

### 4. Krohnkite not installed

`~/.local/share/kwin/scripts/` empty; no `krohnkiteEnabled` in `kwinrc`.  
Earlier install failed (root tmpdir permissions).

**Fix:** re-run Krohnkite install (included in functionality script).

### 5. microk8s always on

Not a GUI bug, but steals CPU/RAM on a 16 GiB media/dev box. Safe to leave running if intentional.

### 6. Minor

- `mtp-probe` missing (`libmtp-runtime`) — phone USB noise in udev logs  
- `xdg-desktop-portal-gnome` still installed alongside KDE portal — prefer KDE in portals.conf  
- Termius: snap was present earlier; confirm after reboot if missing from menu

---

## Recommended action (no theme/layout edits)

```bash
scp -r ~/AIDE_OS/console-pack fam-media:~/AIDE_OS/
ssh -t fam-media 'sudo bash ~/AIDE_OS/console-pack/install.sh --add=functionality'
# or:
ssh -t fam-media 'sudo bash ~/AIDE_OS/console-pack/12-plasma-functionality.sh'
```

Then **log out and back in** (or reboot).

### Manual checks after

1. Panel → Add Widgets → **Get New Widgets…** opens without blank/error  
2. **Discover** opens and can search  
3. Settings → KWin Scripts → **Kröhnkite** present  
4. `ps -p $(pgrep plasmashell) -o %cpu` — should drop when idle  
5. Optional: `sudo snap stop microk8s` if not needed on this PC  

### If a single widget still glitches

User-installed only (safe to remove without touching global theme):

```text
~/.local/share/plasma/plasmoids/AndromedaLauncher
~/.local/share/plasma/plasmoids/KdeControlStation
~/.local/share/plasma/plasmoids/com.github.k-donn.plasmoid-wunderground
```

---

## Out of scope (per request)

- Changing wallpaper, colors, Plasma style, Aurorae decoration, panel layout  
- Removing GNOME packages (optional later space reclaim)  
- Switching back to Mutter/Forge  
