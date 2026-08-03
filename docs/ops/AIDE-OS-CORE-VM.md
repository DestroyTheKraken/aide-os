# AIDE_OS — Ubuntu Core VirtualBox VM

| Field | Value |
|-------|--------|
| **Created** | 2026-08-02 |
| **VM name** | `AIDE_OS` |
| **UUID** | `4390b131-3a07-4475-846b-b65e0e0459df` |
| **Image** | Ubuntu Core **26** amd64 (pre-built stable current) |
| **Image path** | `~/AIDE_OS/dist/ubuntu-core/ubuntu-core-26-amd64.img` (+ `.xz`, `SHA256SUMS`) |
| **VDI** | `~/VirtualBox VMs/AIDE_OS/AIDE_OS-core26.vdi` (resized **20 GiB**) |
| **Resources** | 4 GiB RAM · 2 vCPU · EFI · VMSVGA · NIC1 NAT |
| **Script** | `~/AIDE_OS/scripts/vbox/create-aide-os-core-vm.sh` |
| **Snapshot** | `post-console-conf` (UUID `962f0b5f-d710-4be6-a965-884dd9841d7d`) — after console-conf |
| **Host-only** | `vboxnet0` created · **not yet attached** to VM (next session) |
| **Status check** | 2026-08-02 night: **VMState=running** · snapshot current = `post-console-conf` |

## Relationship to design (classic-first)

Product design (`docs/design/2026-08-02-aide-lab-virtualbox.md`) keeps **classic Ubuntu/Edbuntu** as the day-1 education desktop MVP.

This **Core VM** is the **appliance / Core practice track** (PR11 direction + HickMedia Core lessons): install milestones, snap-only thinking, `aidectl` future on Core — **not** a HickMedia gaming merge.

## First-boot success criteria (Canonical PC path)

| Milestone | Meaning |
|-----------|--------|
| GRUB `no such device: ubuntu-boot` / `/EndEntire` | **Normal noise** — do not reflash |
| `Installing the system, please wait for reboot` | Install progressing |
| **`Press enter to configure`** | Install succeeded → console-conf |
| Network + Ubuntu One SSH keys | Reachable for `aidectl` later |

## Operator commands

```bash
# Start / stop
VBoxManage startvm AIDE_OS --type gui
VBoxManage controlvm AIDE_OS acpipowerbutton   # preferred
# VBoxManage controlvm AIDE_OS poweroff       # hard

# Status
VBoxManage showvminfo AIDE_OS | head -30

# Recreate (destroy carefully)
# VBoxManage unregistervm AIDE_OS --delete
# bash ~/AIDE_OS/scripts/vbox/create-aide-os-core-vm.sh --start
```

## Download image again (if needed)

```bash
DIST=~/AIDE_OS/dist/ubuntu-core
mkdir -p "$DIST" && cd "$DIST"
curl -fL -o SHA256SUMS \
  https://cdimage.ubuntu.com/ubuntu-core/26/stable/current/SHA256SUMS
curl -fL -C - -o ubuntu-core-26-amd64.img.xz \
  https://cdimage.ubuntu.com/ubuntu-core/26/stable/current/ubuntu-core-26-amd64.img.xz
grep ubuntu-core-26-amd64.img.xz SHA256SUMS | sha256sum -c -
xz -dk -T0 ubuntu-core-26-amd64.img.xz
```

## Not used without ask

- Tailnet peers / Samsung TV as NAD learning display — optional later (user resource list)
- Bridged LabNET `.100` collision — avoid; NAT for first boot

## Usage calibration

Log Screenshots → SuperGrok Usage while building. See `docs/ops/USAGE-LOG.md` + `USAGE-CALIBRATION.md`.

## Next steps

1. Complete console-conf (network, user, SSH)
2. Snapshot: `VBoxManage snapshot AIDE_OS take post-console-conf`
3. Document learner path for basic SuperGrok tier (when to use Build vs local)
4. Optional: host-only NIC after `hostonly-net.sh`
5. Classic `aide-lab` desktop VM remains separate MVP track
