# AdGuard Home — LabNET ad blocking (um690)

**Updated:** 2026-07-31  
**Host:** um690 · **Lab IP:** `192.168.20.100`  
**Stack:** Docker Compose · `adguard/adguardhome`

---

## Endpoints

| Service | URL / address |
|---------|----------------|
| **Admin UI** | http://192.168.20.100:3080 · http://127.0.0.1:3080 |
| **DNS** | `192.168.20.100` port **53** (TCP/UDP), LabNET only |

First visit Admin UI → complete **setup wizard** (admin password stays in Bitwarden, not git).

---

## Ops

```bash
cd ~/AIDE_OS/infra/adguard
docker compose ps
docker compose logs -f --tail=50
docker compose restart
docker compose down    # stop blocking (clients using this DNS will fail until DNS changed)
docker compose up -d
```

Data: `./work` · config: `./conf` (local; do not commit secrets).

---

## Cutover (optional — after wizard)

### Test one client first
On a single PC/phone: set DNS manually to `192.168.20.100` · browse · confirm ads drop and sites work.

### Lab-wide (VyOS DHCP) — only when ready
1. Note current DNS (usually `192.168.20.1` or ISP).  
2. Set DHCP DNS option to `192.168.20.100` (and optional secondary `1.1.1.1` if you want fallback).  
3. Renew leases on clients.  
4. **Rollback:** restore DHCP DNS to `192.168.20.1` immediately if anything breaks.

**Do not** point CoreDNS/k3s cluster DNS at AdGuard without a deliberate design — this service is for **LabNET clients**, not kube-system.

---

## Upstream DNS (recommended after wizard)

- Cloudflare `1.1.1.1` / `1.0.0.1` or Quad9 `9.9.9.9`  
- Enable blocklists (AdGuard base + OISD small is enough to start)

---

## Data-loss / safety

- Stopping the container only affects clients that use its DNS.  
- um690 itself still uses systemd-resolved (`127.0.0.53`) unless you change host resolv.  
- Backups: copy `conf/` + export filter lists from UI after setup.  
