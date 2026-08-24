# GrokAide Console & Productivity Dashboard

**Role:** Browser console for education + lab productivity.  
**Not** HickMedia (no gaming, RetroArch, or media kiosk defaults).

## Seats

| Seat | IP | Use |
|------|-----|-----|
| um690 (platform) | 192.168.20.100 | Author + serve dashboard |
| Any LabNET / Tailscale browser | — | Open the um690 URL |
| Samsung TV | 192.168.20.109 | Display only |

## Serve on platform

```bash
cd ~/AIDE_OS/console
python3 -m http.server 8765 --bind 0.0.0.0
```

Open:

- Local: http://127.0.0.1:8765/
- LabNET: http://192.168.20.100:8765/
- Any mesh node / TV browser: same LabNET URL

fam-media is **retired** (that hardware is node3). Serve from um690 only.

## Related

- [EDUCATION-CLIENTS.md](../docs/EDUCATION-CLIENTS.md)
- [NODE1-EDUBUNTU-REIMAGE.md](../docs/labs/NODE1-EDUBUNTU-REIMAGE.md)
