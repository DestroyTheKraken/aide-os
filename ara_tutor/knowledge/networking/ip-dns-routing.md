# IP, DNS & Routing — LFCS Reference

**LFCS weight:** ~25% (networking core) · **Project:** 06  
**AIOS nodes:** node2 (gateway labs), node1 (NFS client)  
**Tracker:** `guides/OBJECTIVES_TRACKER.md` §§ 5–6

Static IP, routes, hosts file, DNS resolver, basic connectivity. Ubuntu uses **netplan**; RHEL uses **nmcli** or ifcfg files — know both for LFCS.

---

## Interface discovery

```bash
ip link show
ip -br addr
ip addr show eth0
ip -s link                       # stats
nmcli device status              # NetworkManager
nmcli connection show
```

AIOS tailnet (always up): `tailscale ip -4` → `100.x.x.x` on `tailscale0`.

---

## Static IPv4 — ip commands (runtime)

```bash
IF=eth0
sudo ip addr flush dev "${IF}"
sudo ip addr add 192.168.68.201/22 dev "${IF}"
sudo ip link set "${IF}" up
sudo ip route add default via 192.168.68.1
```

Verify:

```bash
ip route show
ping -c 3 192.168.68.1
ping -c 3 8.8.8.8
```

---

## Static IP — netplan (Ubuntu persistent)

```yaml
# /etc/netplan/01-lfcs.yaml
network:
  version: 2
  ethernets:
    eth0:
      addresses:
        - 192.168.68.201/22
      routes:
        - to: default
          via: 192.168.68.1
      nameservers:
        addresses:
          - 1.1.1.1
          - 8.8.8.8
```

```bash
sudo chmod 600 /etc/netplan/01-lfcs.yaml
sudo netplan try                  # safe test — auto-reverts
sudo netplan apply
```

---

## Static IP — nmcli (RHEL/Ubuntu NM)

```bash
sudo nmcli con mod "Wired connection 1" \
  ipv4.addresses "192.168.68.201/22" \
  ipv4.gateway "192.168.68.1" \
  ipv4.dns "1.1.1.1" \
  ipv4.method manual
sudo nmcli con up "Wired connection 1"
```

---

## /etc/hosts (Project 06)

```bash
# /etc/hosts
127.0.0.1   localhost
192.168.68.101  node1.lan node1
192.168.68.102  node2.lan node2
REDACTED   node1
```

Test: `getent hosts node1` · `ping node1`

---

## DNS resolver

**Ubuntu (systemd-resolved):**

```bash
# /etc/systemd/resolved.conf  or netplan nameservers
resolvectl status
resolvectl query example.com
```

**Classic:**

```bash
# /etc/resolv.conf
nameserver 1.1.1.1
nameserver 8.8.8.8
search lan
```

```bash
dig example.com
dig @1.1.1.1 example.com
nslookup example.com
host example.com
```

---

## Routing

```bash
ip route show
ip route add 10.10.0.0/16 via 192.168.68.1
ip route del 10.10.0.0/16
traceroute 8.8.8.8
tracepath 8.8.8.8
```

---

## Connectivity tests

```bash
ping -c 4 target
ping6 -c 4 target                 # IPv6
curl -I http://target
ss -tuln                          # local listening ports
```

---

## NFS client (Project 06 phase 4)

```bash
sudo apt install nfs-common
showmount -e nfs-server.tailnet
sudo mkdir -p /mnt/nfs_share
sudo mount -t nfs nfs-server:/export /mnt/nfs_share
df -h /mnt/nfs_share
```

**fstab entry:**

```fstab
nfs-server:/export  /mnt/nfs_share  nfs  defaults,_netdev  0  0
```

---

## SSHFS (alternative remote mount)

```bash
sudo apt install sshfs
mkdir -p ~/remote
sshfs user@host:/remote/path ~/remote
fusermount -u ~/remote
```

---

## Lab cluster addressing (current premises)

Public SoT: [homelab](https://github.com/DestroyTheKraken/homelab). Tailscale CGNAT addresses omitted — use MagicDNS.

| Host | LAN | Tailscale |
|------|-----|-----------|
| um690 | 192.168.20.100 | MagicDNS `um690` |
| node1 | 192.168.20.101 | MagicDNS `node1` |
| node2 | 192.168.20.102 | MagicDNS `node2` |
| node3 | 192.168.20.103 | MagicDNS `node3` |
| operator-phone | — | lab tailnet · active (2026-08-29) |
| operator-tablet | — | lab tailnet · offline ~4d (2026-08-29) |

Lab LAN: `192.168.20.0/24`. Home WLAN: `192.168.10.0/24`. Older `192.168.68.0/22` examples elsewhere in study notes are historical practice problems, not this lab.

---

## Verification drills

```bash
ip -br addr
ip route | grep default
getent hosts node1
resolvectl status 2>/dev/null || cat /etc/resolv.conf
ping -c 2 REDACTED
findmnt /mnt/nfs_share
```

---

## Common exam traps

1. **Forgot `ip link set up`** — interface admin down.
2. **Wrong prefix** — `/22` vs `/24` on your LAN.
3. **Editing resolv.conf directly** on resolved-managed systems — overwritten.
4. **NFS without `_netdev`** in fstab — boot hang.
5. **netplan typo** — `netplan try` before apply saves you.
6. **Testing only LAN** — verify default route to internet if required.

---

## man pages

```bash
man ip
man 5 hosts
man 5 resolv.conf
man netplan
man nfs
man fstab
```

---

## Ara prompts

- "Configure static IP on Ubuntu with netplan."
- "Difference between /etc/hosts and DNS?"
- "NFS fstab line with _netdev?"
- "How to verify default gateway?"

**Related:** `Study_Projects/06.md` · `ssh-remote-access.md` · `firewall-nat-forwarding.md`