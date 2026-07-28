# AIDE_OS console-pack — iterative GUI (historical)

> **2026-07-26:** fam-media is **HickMedia Console dev**, not AIDE education product.  
> AIDE/Edbuntu scope: `../docs/PRODUCT-SCOPE-AND-EDBUNTU.md`.  
> Gaming console: `~/HickMedia`. Do **not** treat this pack as the gaming console SoT.

## Policy (legacy fam-media / .104)

| Item | Choice |
|------|--------|
| Boot | **graphical.target** + **SDDM** → **Plasma (Wayland)** |
| Compositor / WM | **KWin** |
| Tiling | **Krohnkite** (KWin script) |
| Terminal | **Termius only** — **Local Terminal** |
| Work model | GUI + Termius on fam-media; **Grok on um690** |
| Everything else | Add only when you ask |

See [DESIGN-GUI.md](./DESIGN-GUI.md).

---

## Restore Plasma + Krohnkite (current design)

```bash
scp -r ~/AIDE_OS/console-pack fam-media:~/AIDE_OS/
ssh -t fam-media 'sudo bash ~/AIDE_OS/console-pack/install.sh --stack=plasma-krohnkite && sudo reboot'
```

After reboot: **SDDM → Plasma (Wayland)** → joshua → Termius.  
**Settings → KWin Scripts → Kröhnkite** ON.

---

## Other commands

```bash
sudo bash install.sh --base                 # Plasma base only (no Krohnkite)
sudo bash install.sh --add=firefox
sudo bash install.sh --add=theme-support    # Aurorae decorations
sudo bash install.sh --add=system-apps
sudo bash install.sh --stack=mutter-forge   # old GNOME path (not recommended now)
bash install.sh --verify base
```
