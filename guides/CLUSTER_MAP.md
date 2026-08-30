# Lab cluster map — node roles

**Networking SoT:** [homelab](https://github.com/DestroyTheKraken/homelab)  
**Lab Tailscale (2026-08-29):** `destroythekraken@` — `um690`, `node1`–`node3`, `operator-phone` (active), `operator-tablet` (offline ~4d)

Tailscale addresses are omitted. Prefer MagicDNS hostnames over any CGNAT address.

## Control plane: um690

| | |
|---|---|
| LAN | `192.168.20.100` |
| Role | Control seat / study authoring |

## Fleet

| Host | LAN | Role |
|------|-----|------|
| node1 | `192.168.20.101` | Ubuntu lab worker |
| node2 | `192.168.20.102` | Ubuntu lab worker |
| node3 | `192.168.20.103` | Ubuntu lab worker |
| vyos-router | `192.168.20.1` | Premises edge / lab gateway |

## Admin clients (lab tailnet)

| Device (published) | Use |
|--------------------|-----|
| operator-tablet | Termius / browser console when online |
| operator-phone | Backup SSH / admin client (active as of 2026-08-29) |
| um690 desktop | Direct terminal at the desk |

## Topology (roles only)

```
Internet (Starlink CGNAT)
       │
  [vyos-router]
       │
  ┌────┴──────── Lab LAN 192.168.20.0/24 ────────┐
  │  um690 .100   node1 .101   node2 .102   node3 .103  │
  └────┬─────────────────────────────────────────┘
       │ Tailscale lab identity (destroythekraken@)
       │ um690 · node1 · node2 · node3 · operator-phone · operator-tablet
```

Home WLAN (`192.168.10.0/24`) is a separate segment. Details and redaction policy: homelab repo.
