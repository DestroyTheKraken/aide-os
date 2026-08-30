# Tablet quick start — study console

The cluster is the **backend**. Your **operator-tablet** (when online) or **operator-phone** is the **console**. Reach hosts by MagicDNS over the lab Tailscale identity (`destroythekraken@`). Do not bookmark Tailscale CGNAT addresses in public docs.

## Bookmark these (MagicDNS)

| Service | URL pattern | Purpose |
|---------|-------------|---------|
| Study portal | `http://um690:3080/` | Daily dashboard (if that service is running) |
| Lab browser | `https://um690:3001/` | Container browser lab (if deployed) |

Credentials for any local service stay on the workstation — never in this public repo.

## Morning routine

1. Connect Tailscale on the phone/tablet (lab profile).
2. Open the portal on `um690` if you use it that day.
3. SSH to today's node via Termius using MagicDNS:

```bash
ssh kraken@node1
ssh kraken@node2
ssh kraken@node3
```

## Lab Tailscale membership (2026-08-29)

`um690`, `node1`, `node2`, `node3`, `operator-phone` (active), `operator-tablet` (offline ~4 days).

Full redacted tables: [homelab](https://github.com/DestroyTheKraken/homelab).

## Security reminders

- Prefer Tailscale + MagicDNS; do not publish `100.x` addresses.
- UFW on lab hosts should stay default-deny with SSH + `tailscale0` as needed.
- Rotate any password that ever appeared in an old guide commit.
