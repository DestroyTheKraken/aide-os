# Tablet Quick Start — Your Daily LFCS Learning UI

This cluster is your **backend**. Your tablet (j-tab) is your **console**. Two URLs, tailnet-only.

## Bookmark These on j-tab

| Service | URL | Purpose |
|---------|-----|---------|
| **LFCS Portal** | `http://100.81.13.95:3080/` | Daily dashboard — start here each morning |
| **Mullvad Browser** | `https://100.81.13.95:3001/` | Secure Firefox — do all lab work here |

Credentials: `notifications/tablet-credentials.txt` on um690 (generated at deploy). The dashboard shows **username only** — SSH to um690 via Termius to read the password file (PR 6b security).

---

## Morning Routine (2 minutes)

1. Connect to Tailscale on your tablet (automatic if installed).
2. Open **LFCS Portal** → read today's Program Day, project, and steps.
3. Tap **Open Mullvad Browser** → log in → accept self-signed cert.
4. In Firefox, open the Portal in a tab (or use pre-seeded bookmarks).
5. SSH to today's assigned node via Termius for hands-on work:
   ```bash
   ssh kraken@100.75.124.36   # node1
   ssh kraken@100.104.54.20   # node2
   ssh kraken@100.82.177.52   # node3
   ```
6. When done: log completion on um690:
   ```bash
   echo "$(date -Iseconds) Project NN DONE" >> ~/Projects/aios-ed/notifications/study-journal.log
   ```

---

## First-Time Backend Setup (once, on um690)

```bash
cd /home/kraken/Projects/aios-ed/automation
sudo ./lfcs-backend-deploy.sh
```

This installs Docker, deploys Portal + Mullvad Browser, configures firewall, enables boot persistence, and writes your tablet credentials.

---

## What Runs Where

```
j-tab (tablet)
    │
    ├── http://100.81.13.95:3080  → lfcs-portal (nginx dashboard)
    └── https://100.81.13.95:3001 → mullvad-browser (Firefox lab)
              │
              um690 (control plane)
              ├── /home/kraken/Projects/aios-ed/  (guides, schedule, scripts)
              ├── Daily cron 07:00 → guidance + portal refresh
              └── SSH ──→ node1, node2, node3 (hands-on labs)
```

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Portal won't load | `sudo systemctl status lfcs-backend docker` on um690 |
| Browser slow first boot | Wait 3–5 min; `docker logs secure-browser-forge` |
| Cert warning | Expected — tap Advanced → Proceed (self-signed) |
| Wrong day shown | `~/Projects/aios-ed/automation/lfcs-daily-guidance.sh` |
| After um690 reboot | Services auto-start; wait 2 min, refresh portal |

---

## Security

- Ports bind to **Tailscale IP only** — not exposed to Starlink/LAN.
- ufw allows **100.64.0.0/10** on `tailscale0` only.
- Browser requires **HTTP basic auth** even on tailnet.
- Mullvad Browser routes through VPN inside the container for web privacy during study.