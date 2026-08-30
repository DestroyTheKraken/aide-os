# Lab cluster inventory (redacted)

**Source of truth for premises networking:** [homelab](https://github.com/DestroyTheKraken/homelab)  
**Lab Tailscale last checked:** 2026-08-29 on `um690` (`destroythekraken@`)

This file stays short on purpose. No Tailscale IPs, MACs, or household nicknames.

## Lab Tailscale membership (2026-08-29)

| Hostname (published) | OS | Status |
|----------------------|-----|--------|
| um690 | linux | idle / reachable |
| node1 | linux | idle / reachable |
| node2 | linux | idle / reachable |
| node3 | linux | idle / reachable |
| operator-phone | android | active |
| operator-tablet | android | offline (~4 days) |

Six devices only on the lab tailnet.

## Lab LAN (RFC1918 roles)

| Host | LAN role |
|------|----------|
| vyos-router | `192.168.20.1` gateway |
| um690 | control seat `.100` |
| node1–node3 | Ubuntu fleet `.101`–`.103` |
| display | `.109` (not managed) |

Admin access practice: SSH / Termius from operator phone or tablet over Tailscale. Details and redaction rules live in the homelab repo.
