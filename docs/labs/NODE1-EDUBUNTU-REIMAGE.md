# node1 reimage — Edubuntu 26.04 (hardware LFCS client)

| Field | Value |
|-------|--------|
| **Host** | node1 · LabNET **192.168.20.101** |
| **MAC** | `d8:cb:8a:01:7a:89` (VyOS static-mapping **node1**) |
| **ISO** | `edubuntu-26.04-desktop-amd64.iso` on **256GB PNY** (`/ISO/`) |
| **Role after** | GrokAide **Education** hardware client (LFCS + Canonical) |
| **Platform** | um690 authoring + Multipass `grokaide-edu` remains available |

> **Physical step required.** This reimage cannot be completed over the network without console + USB boot. Follow §1 at the machine, then §2 from um690.

---

## 0. Confirm before wipe

- [ ] Nothing unique on node1 that is not backed up (historical k3s worker data is disposable unless you say otherwise).
- [ ] PNY USB has `ISO/edubuntu-26.04-desktop-amd64.iso` (~7.4 G).
- [ ] Keyboard/monitor (or KVM) on node1.
- [ ] Lab switch: node1 cable on LabNET (same as today).

**IP after reimage:** DHCP should still offer **`.101`** via VyOS static-mapping (MAC unchanged if using same NIC `eno1`).

---

## 1. At node1 (console + PNY USB)

1. Insert **256GB PNY** (Ventoy layout: boot menu should list ISOs).
2. Power on → enter boot menu (often **F12** / **F10** on ThinkCentre M93p) → boot USB.
3. Select **`edubuntu-26.04-desktop-amd64.iso`**.
4. Install Edubuntu:
   - Disk: wipe whole disk (single user lab machine).
   - Computer name: **`node1`**
   - Username: **`learner`** (or `joshua` if you prefer one identity)
   - Enable **Install OpenSSH server** if the installer offers it (or install after first boot).
   - Network: DHCP (LabNET).
5. Reboot, remove USB, log in once, open terminal.

### First boot on node1 (local)

```bash
# Identity
hostnamectl
ip -br a

# Should be 192.168.20.101 if MAC matches VyOS static
ip link show eno1 | grep -i ether
# expect: d8:cb:8a:01:7a:89

sudo apt update
sudo apt install -y openssh-server git curl vim tmux tree jq
sudo systemctl enable --now ssh

# Temporary password SSH from um690 (tighten later with keys):
# Prefer: copy platform public key when you have one
```

Optional — create key on **um690** before reimage and paste `~/.ssh/id_ed25519_edu.pub` into node1 `~/.ssh/authorized_keys` during install.

---

## 2. From platform um690 (after node1 is online)

```bash
# Discover
ping -c2 192.168.20.101
ssh learner@192.168.20.101   # or joshua@

# Bootstrap LFCS client layer
bash ~/AIDE_OS/scripts/education/bootstrap-lfcs-client.sh learner@192.168.20.101
```

Bootstrap will:

- Install lab packages  
- Clone or rsync education paths (Study_Projects, guides, LFCS brain subset)  
- Write `~/LFCS/README` with day-1 commands  
- Optionally add host entry `node1` in um690 `~/.ssh/config`

---

## 3. Day-1 LFCS on node1

```bash
ssh learner@192.168.20.101
cd ~/LFCS/Study_Projects
less 00.md
less ~/LFCS/guides/OBJECTIVES_TRACKER.md
```

Destructive labs stay on **node1** (or Multipass). Platform um690 remains SoT.

---

## 4. Rollback / dual path

| Path | Purpose |
|------|---------|
| Multipass `grokaide-edu` | Fast disposable CLI labs (already running) |
| node1 Edubuntu | Real hardware + desktop education UX |
| node2 | Second host later (same ISO procedure, IP `.102`) |

---

## 5. IP note (lab map)

| IP | Host | Notes |
|----|------|--------|
| `.100` | um690 | Platform |
| `.101` | **node1** | This reimage target |
| `.102` | node2 | Worker / future edu peer |
| `.109` | Samsung TV (MAC `20:15:de:…`) | **Not** fam-media; no SSH |
| `.111` | **fam-media** | GrokAide Console host (not HickMedia gaming) |

If HickMedia appeared as `.109` in an old note, that was the **TV** lease, not fam-media.
