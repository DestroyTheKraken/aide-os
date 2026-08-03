# Firewall, NAT & Port Forwarding — LFCS Reference

**LFCS weight:** ~25% · **Projects:** 07, 09  
**AIOS nodes:** node2 (edge gateway), node3 (firewalld capstone)  
**Tracker:** `guides/OBJECTIVES_TRACKER.md` §§ 7, 9

Stateful firewall, default deny, NAT/masquerade, port forwarding, bonding preview, time sync. Ubuntu cluster uses **ufw**; Rocky Project 09 uses **firewalld** — LFCS may test either.

---

## ufw — Ubuntu (um690, node1)

```bash
sudo ufw status verbose
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow in on tailscale0 to any port 22 proto tcp
sudo ufw allow in on tailscale0 to any port 3080 proto tcp
sudo ufw enable
sudo ufw reload
```

AIOS deploy script (`lfcs-backend-deploy.sh`) applies tailnet rules for 3080, 3001, 3082, 11434.

```bash
sudo ufw status numbered
sudo ufw delete 3
```

---

## firewalld — Rocky / RHEL (node2, node3 Project 09)

```bash
sudo systemctl enable --now firewalld
sudo firewall-cmd --state
sudo firewall-cmd --get-default-zone
sudo firewall-cmd --list-all
```

### Default deny + open services

```bash
sudo firewall-cmd --set-default-zone=drop
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-port=3001/tcp
sudo firewall-cmd --reload
```

### Rich rule — tailnet only (Project 09)

```bash
sudo firewall-cmd --permanent --add-rich-rule='
  rule family="ipv4"
  source address="100.64.0.0/10"
  port protocol="tcp" port="3001" accept'
sudo firewall-cmd --reload
sudo firewall-cmd --list-rich-rules
```

Tailscale CGNAT range: `100.64.0.0/10`.

### Block subnet

```bash
sudo firewall-cmd --permanent --add-rich-rule='
  rule family="ipv4" source address="203.0.113.0/24" reject'
```

---

## nftables (awareness)

```bash
sudo nft list ruleset
# RHEL may use nftables backend for firewalld
```

LFCS may reference `nft` — firewalld is higher-level on RHEL labs.

---

## Kernel forwarding & NAT (Project 07)

### Enable forwarding (persistent)

```bash
# /etc/sysctl.d/99-gateway.conf
net.ipv4.ip_forward = 1
```

```bash
sudo sysctl --system
sysctl net.ipv4.ip_forward
```

### firewalld masquerade (NAT)

```bash
sudo firewall-cmd --permanent --add-masquerade
sudo firewall-cmd --reload
```

### Port forwarding (DNAT) — example

Forward public 8080 → internal 192.168.68.101:80:

```bash
sudo firewall-cmd --permanent \
  --add-forward-port=port=8080:proto=tcp:toport=80:toaddr=192.168.68.101
sudo firewall-cmd --reload
```

### iptables reference (legacy exam)

```bash
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -i eth1 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
```

Know concept; prefer firewalld/nft on modern RHEL.

---

## Bonding / teaming (Project 07 phase 1)

```bash
# awareness — nmcli bonding on RHEL
sudo nmcli con add type bond ifname bond0 mode active-backup
sudo nmcli con add type ethernet ifname eth0 master bond0
sudo nmcli con add type ethernet ifname eth1 master bond0
```

Verify failover: `cat /proc/net/bonding/bond0`

---

## Time synchronization — Chrony (Project 07, PR 19)

```bash
sudo apt install chrony                  # Ubuntu
sudo systemctl enable --now chrony
chronyc tracking
chronyc sources -v
timedatectl status
```

LFCS: skew < 100ms across cluster; exam may ask to point to internal NTP.

```bash
# /etc/chrony/chrony.conf — pool or internal server
pool 2.ubuntu.pool.ntp.org iburst
```

---

## Verify binding & exposure (Project 09)

```bash
ss -tlnp | grep 3001
# GOOD: 100.82.177.52:3001
# BAD:  0.0.0.0:3001 or *:3001 on public interface
```

```bash
curl -k --connect-timeout 3 https://100.82.177.52:3001/
# from node1 on tailnet — should work
# from LAN without tailnet — should fail (rich rule)
```

---

## HAProxy / load balance (awareness)

Project 07 phase 4 — distribute HTTP across backends:

```bash
sudo apt install haproxy
# /etc/haproxy/haproxy.cfg — frontend + backend servers
sudo systemctl enable --now haproxy
```

Know frontend/backend concept for LFCS; full config is stretch.

---

## Verification drills

```bash
sudo ufw status verbose
sudo firewall-cmd --list-all
sysctl net.ipv4.ip_forward
ss -tlnp
chronyc tracking
```

Reboot persistence: rules must survive `sudo reboot` — `--permanent` for firewalld, enabled ufw, sysctl.d file.

---

## Common exam traps

1. **Forgot `--permanent`** on firewalld — rules lost on reload/reboot.
2. **MASQUERADE without ip_forward** — NAT silently fails.
3. **Opening 0.0.0.0** instead of tailnet source restriction.
4. **ufw enable without allow SSH** — lockout.
5. **Rich rule wrong interface** — use `tailscale0` or source CIDR `100.64.0.0/10`.
6. **Chrony not enabled** — time drift breaks TLS/logs.

---

## man pages

```bash
man ufw
man firewall-cmd
man firewalld.richlanguage
man sysctl.d
man chrony.conf
man haproxy
```

---

## Ara prompts

- "firewalld rich rule for tailnet-only port 3001?"
- "Enable NAT masquerade on node2 gateway?"
- "ufw allow SSH only on tailscale0?"
- "Verify service not bound to 0.0.0.0?"

**Related:** `Study_Projects/07.md`, `09.md` · `ip-dns-routing.md` · `weak-areas/docker-compose.md`