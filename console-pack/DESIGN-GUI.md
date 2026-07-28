# fam-media GUI design (living)

## Current target stack

| Layer | Choice |
|-------|--------|
| DM | **SDDM** (X11 greeter; reliable on Haswell) |
| Session | **Plasma 6 (Wayland)** |
| Compositor / WM | **KWin** |
| Tiling | **Krohnkite** (Plasma 6 fork: anametologin/krohnkite) |
| Terminal | **Termius only** |
| Browser | Firefox (optional module) |

Install / restore:

```bash
sudo bash install.sh --stack=plasma-krohnkite
sudo reboot
```

At login pick **Plasma (Wayland)**. Enable Krohnkite under  
**System Settings → Window Management → KWin Scripts** if needed.

## Previous stacks (not default)

| Stack | Status |
|-------|--------|
| GNOME + Mutter + **Forge** | Superseded; GDM disabled by plasma-krohnkite script |
| Plasma lean without sessions/Xorg | Fixed earlier (black screen) |
| Openbox | Never deployed on fam-media |

## Notes

- Classic **i3** does not run under KWin; Krohnkite is a KWin script.
- **Forge** requires GNOME Shell; not used with Plasma.
- Optional: `sudo apt purge gdm3 gnome-shell mutter` after Plasma works.
