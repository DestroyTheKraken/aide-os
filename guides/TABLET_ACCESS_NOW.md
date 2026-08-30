# Tablet / phone access

Backend services (when running) live on `um690`. Connect with the **lab** Tailscale profile (`destroythekraken@`), then use MagicDNS — not Tailscale CGNAT addresses.

## Reach the control seat

| Client | Notes |
|--------|--------|
| operator-phone | Active on lab tailnet as of 2026-08-29 |
| operator-tablet | Offline ~4 days as of 2026-08-29 |
| um690 local terminal | When you are at the desk |

Examples (only if those listeners are up on your box):

```text
http://um690:3080/
https://um690:3001/
```

## Credentials

Service passwords are **not** stored in this public repository. Read them from your private local notes on `um690` if you still run those containers.

## If a container service will not connect

On `um690`:

```bash
sg docker -c 'docker ps -a'
```

Inventory SoT: [homelab](https://github.com/DestroyTheKraken/homelab/blob/main/docs/04-tailscale.md).
