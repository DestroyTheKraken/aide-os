# AIDE_OS portfolio site (skeleton)

**Local path:** `~/AIDE_OS/site/`  
**Public path target:** `https://aide-os.home-desktop-2.ts.net/aide/home/joshua/`  
**Updated:** 2026-07-31

## Preview on um690

```bash
cd ~/AIDE_OS/site && ./serve.sh
# open http://127.0.0.1:8099/aide/home/joshua/
```

## Deploy to home-desktop-2 (when SSH works)

```bash
# Example rsync — adjust remote web root to match home-desktop-2 Caddy/nginx
rsync -av --delete \
  ~/AIDE_OS/site/aide/ \
  home-desktop-2:/var/www/aide-os/aide/
```

Configure Tailscale Serve / reverse proxy hostname `aide-os` → that root so  
`/aide/home/joshua/` maps to `aide/home/joshua/index.html`.

## Contents

| Path | Purpose |
|------|---------|
| `aide/home/joshua/` | Portfolio home (DTK brand · HickMedia neon theme) |
| `aide/home/joshua/projects/` | LabNET, AIDE_OS, Core practice, VTS |
| `aide/home/joshua/skills/` | AI · DevOps · Linux evaluation · usage calibration |
| `aide/home/joshua/docs/` | Public doc pointers |
| `aide/home/joshua/downloads/` | Future Core images + SHA256 |
| `aide/home/joshua/assets/` | CSS + logo, headshot, lab stills |

## Theme

- **Brand:** Destroy The Kraken (logo, name)  
- **Visual language:** HickMedia neon tokens (`#00f0ff` / `#ff2bd6` / `#c77dff`, starfield CSS)  
- **Not:** HickMedia gaming product merge on this portfolio  

## Preview

```bash
cd ~/AIDE_OS/site && ./serve.sh
# http://127.0.0.1:8099/aide/home/joshua/
# http://127.0.0.1:8099/aide/home/joshua/projects/
# http://127.0.0.1:8099/aide/home/joshua/skills/
```

## Rules

- Redact Tailscale IPs, secrets, personal phone/home address  
- No school-SKU or student PII  
- Lab screenshots OK if anonymized  

