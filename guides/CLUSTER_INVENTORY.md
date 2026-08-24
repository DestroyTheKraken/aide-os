# LFCS / LabNET Cluster Inventory

**Last scan:** 2026-08-10T23:28:37-07:00
**Scanned from:** um690 (user joshua)
**Control plane:** um690 (`100.68.189.19` · LAN `192.168.20.100`)
**LabNET:** `192.168.20.0/24` via gateway `192.168.20.1`
**Admin access:** Termius on j-tab / j-phn

> Live scan 2026-08-10. Regenerated inventory — old `lfcs-cluster-scan.sh` IPs/user are stale.

---

## Cluster Summary

| Host | Status | Tailscale | LAN | OS | RAM | Cores | SSH | Role |
|------|--------|-----------|-----|----|-----|-------|-----|------|
| **um690** | ✅ up | 100.68.189.19 | 192.168.20.100 | Ubuntu 26.04 LTS | 60Gi | 16 | ✅ | **control-plane** |
| **node1** | ✅ up | 100.106.228.114 | 192.168.20.101 | Ubuntu 26.04 LTS | 15Gi | 4 | ✅ | **primary-worker** |
| **node2** | ✅ up | — | 192.168.20.102 | unknown (live probe blocked) | ? | ? | ❌ | **edge-gateway / k3s-worker (docs)** |
| **node3** | ❌ down | — | — | ? | ? | ? | ❌ | **storage-forge (historical)** |

### Other LabNET hosts

| IP | Label | MAC | SSH | Role |
|----|-------|-----|-----|------|
| `192.168.20.1` | router (VyOS) | `9c:69:d3:81:3b:e2` | open (auth fail) | L3 gateway |
| `192.168.20.100` | um690 | `58:47:ca:70:aa:02` | local | control plane |
| `192.168.20.101` | node1 | `d8:cb:8a:01:7a:89` | ok as edu@ | primary worker / LFCS lab |
| `192.168.20.102` | node2 | `44:8a:5b:dd:a0:c5` | open (publickey only, key rejected) | k3s worker (historical) |
| `192.168.20.109` | Samsung TV | `20:15:de:c6:fe:f6` | closed | display |
| `192.168.20.111` | fam-media | `d8:cb:8a:86:c8:02` | open (pubkey+password, key rejected) | GrokAide console seat |

---

## Full Tailnet

| Host | Tailscale IP | Status | OS |
|------|-------------|--------|----|
| **um690** (self) | 100.68.189.19 | online | linux |
| a-lap | 100.117.190.127 | offline | linux |
| AIOS_Field_Kit | 100.106.44.126 | offline | android |
| Alyssa's S21 | 100.72.236.24 | offline | android |
| hickles | 100.92.254.81 | online | linux |
| j-phn | 100.100.196.29 | online | android |
| j-tab | 100.75.74.14 | offline | android |
| node1 | 100.106.228.114 | online | linux |
| pookie | 100.71.166.67 | online | linux |

---

## Stack status (orchestration)

- **k3s:** not running on um690
- **docker:** not running on um690 or node1
- **microk8s:** not running
- **orchestration:** none active — bare metal + Tailscale mesh only

## um690 services

- Hardware: Minisforum UM690 · 60Gi RAM · 16 cores
- Disk: 1.9T NVMe (186G used, 11%) + 1.9T USB NAS_A mounted
- Listening: ssh:22, ollama:11434 (localhost), console http:8765
- Ollama: active (phi3.5:latest)
- Docker/k3s/microk8s/lxd: all inactive

## Findings

- LabNET is 192.168.20.0/24 (not old 192.168.68.0/22).
- node3 is completely offline / decommissioned from mesh and LAN.
- SSH key id_ed25519_edu works only for node1 (edu@) from um690.
- node2, fam-media, router, hickles, pookie need key install or password auth.
- Stock automation/lfcs-cluster-scan.sh is STALE (hardcoded old TS IPs + SSH_USER=kraken).
- Ollama active on um690 (phi3.5) and port open on node1 localhost.
- AIDE console served on um690:8765.
- External USB volume NAS_A mounted at /run/media/joshua/NAS_A (1.9T, 5% used).

---

## Network topology (live)

```
[home WiFi 192.168.10.0/24]     [LabNET 192.168.20.0/24]
  um690 wlp .150 ──┐              │
  hickles ~.130    │         [VyOS router .1]
  j-phn etc        │              │
                   │    ┌─────────┼─────────┬──────────┐
                   │  um690     node1     node2    fam-media
                   │  .100      .101      .102     .111
                   │  SSH ok    edu@ ok   SSH 🔑❌  SSH 🔑❌
                   │
              [tailscale mesh 100.x]
              um690 · node1 · hickles · pookie · j-phn
              (node2/node3 not on tailnet this scan)
```

---

## Action items

1. **Install `id_ed25519_edu.pub` (or admin key)** on node2, fam-media, router, hickles, pookie.
2. **Update `automation/lfcs-cluster-scan.sh`** — replace hardcoded TS IPs, set `SSH_USER=edu`, LabNET `.20`, drop/flag node3.
3. **Confirm node3 fate** — decommissioned or offline hardware.
4. **Decide orchestration** — k3s/docker currently off; stack is bare metal + Tailscale only.

