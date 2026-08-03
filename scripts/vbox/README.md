# VirtualBox scripts — AIDE_OS lab

Design SoT: `docs/design/2026-08-02-aide-lab-virtualbox.md` (**Accepted**).

| Script | Role |
|--------|------|
| `hostonly-net.sh` | Idempotent `vboxnet0` 192.168.56.1/24 + DHCP |
| `preflight.sh` | k3s Ready + MemAvailable floors (`demo` / `hybrid-llm`) |
| `shared-folders.sh` | `AIDE_OS_ref` + `screenshots` **ro** |
| `create-aide-lab.sh` | **PR3** classic `aide-lab` — **Option A Edubuntu preferred**, C fallback |
| `create-aide-os-core-vm.sh` | **Core** appliance track (`AIDE_OS`) — black TTY, not MVP UI |

## Tracks (do not confuse)

| VM name | Track | UI |
|---------|-------|-----|
| **`aide-lab`** | Classic MVP (PR3+) | **Edubuntu** (Learn Aide clone) — course UI track |
| **`aide-lab-cinnamon`** | Spare Option C clone | Ubuntu Cinnamon — optional only |
| **`AIDE_OS`** | Ubuntu Core practice (PR11) | Console / TTY — **no desktop** |
| **Learn Aide (edubuntu 26.06)** | Source image | Registered; savestate discarded at promote |

## Quick start (classic MVP)

```bash
# Auto: Edubuntu Learn Aide if present, else Cinnamon
bash ~/AIDE_OS/scripts/vbox/create-aide-lab.sh --start

# Force Edubuntu / force Cinnamon
bash ~/AIDE_OS/scripts/vbox/create-aide-lab.sh --option a --start
bash ~/AIDE_OS/scripts/vbox/create-aide-lab.sh --option c --start
```

## After first boot (guest)

1. Log in (Edubuntu user from Learn Aide clone).
2. Optional: `sudo adduser aide` + Desktop groups; design prefers guest user **`aide`**.
3. Install / update **Guest Additions** matching host VBox 7.2.x.
4. `sudo usermod -aG vboxsf $USER` then re-login — mounts under `/media/sf_*`.
5. UI target: GrokAide / Obsidian composition (screenshot `18-11-40`) via **PR7**.

## UI reference

`~/Pictures/Screenshots/Screenshot From 2026-08-02 18-11-40.png`  
GrokAide · SysAdmin & Platform Development Course look (dark neon / Cyber Glow).
