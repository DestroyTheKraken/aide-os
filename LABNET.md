# LabNET inventory — `192.168.20.0/24`

| Field | Value |
|-------|--------|
| **Updated** | 2026-08-13 |
| **Scanned from** | um690 (`192.168.20.100`, user `joshua`) |
| **Gateway** | `192.168.20.1` (VyOS on M93p Tiny) |
| **SoT** | `~/SovereignAid/ARCHITECTURE.md` |

---

## System focus (2026-08-13)

Sovereign Mesh rebuilt: **4 nodes**, new tailnet **`tail13a119.ts.net`**.  
fam-media console seat is **retired** — that M93p is now **node3**.

---

## Live hosts

| IP | Hostname | MAC | Role | OS | SSH | Tailscale |
|----|----------|-----|------|----|-----|-----------|
| **`.1`** | **router** (VyOS) | `9c:69:d3:81:3b:e2` | L3 gateway · home/lab split | VyOS rolling | `vyos@` from um690 | — |
| **`.100`** | **um690** | `58:47:ca:70:aa:02` | Mesh **control plane** | Ubuntu 26.04 · UM690 | `joshua@` | `100.90.171.47` · `um690.tail13a119.ts.net` |
| **`.101`** | **node1** | `d8:cb:8a:01:7a:89` | Worker | Ubuntu 26.04 · M93p | `kraken@` | `100.85.76.33` · `node1.tail13a119.ts.net` |
| **`.102`** | **node2** | `44:8a:5b:dd:a0:c5` | Worker | Ubuntu 26.04 · M93p | `kraken@` | `100.116.240.9` · `node2.tail13a119.ts.net` |
| **`.103`** | **node3** | `d8:cb:8a:86:c8:02` | Worker (ex-fam-media) | Ubuntu 26.04 · M93p | `kraken@` | `100.71.46.114` · `node3.tail13a119.ts.net` |
| **`.109`** | **samsung** | `20:15:de:c6:fe:f6` | Display only | Samsung TV | no SSH | — |

`.104` and `.111` are **unassigned**. Do not put fam-media back on the former MAC — it is node3.

---

## Switch map (physical)

```text
switch
├── router (VyOS M93p)     .1
├── um690                  .100
├── node1                  .101
├── node2                  .102
├── node3                  .103   ← former fam-media hardware
└── Samsung TV             .109
```

---

## DHCP statics (VyOS — applied 2026-08-13)

| Mapping | IP | MAC |
|---------|-----|-----|
| um690 | `.100` | `58:47:ca:70:aa:02` |
| node1 | `.101` | `d8:cb:8a:01:7a:89` |
| node2 | `.102` | `44:8a:5b:dd:a0:c5` |
| node3 | `.103` | `d8:cb:8a:86:c8:02` |
| samsung | `.109` | `20:15:de:c6:fe:f6` |

---

## Access from um690

```bash
ssh node1          # kraken@192.168.20.101
ssh node2
ssh node3
ssh node1-ts       # MagicDNS fallback
ssh router         # vyos@192.168.20.1
```

AIDE console (when served): `http://192.168.20.100:8765/`

---

## Related

- Platform: `~/SovereignAid/ARCHITECTURE.md` · `specs/cluster.md` · `specs/network.md`
- Brand: [README.md](./README.md) · [GLOSSARY.md](./GLOSSARY.md)
