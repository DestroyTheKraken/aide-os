# INSTALL — B2 Core appliance

## 0. Local vs GrokBuild

| Step | Mode |
|------|------|
| Download image, convert VDI, create VM | **Local** (near-zero SuperGrok %) |
| First-boot confusion, design tradeoffs | **GrokBuild** short brief |
| Daily content / VO | Morning `grokAide-start` |

## 1. Image

```bash
# Prefer current Core 26 (already on this lab if you followed night bring-up)
ls -lah ~/AIDE_OS/dist/ubuntu-core/ubuntu-core-26-amd64.img
# Or re-download — see docs/ops/AIDE-OS-CORE-VM.md
```

## 2. Create VM

```bash
bash ~/AIDE_OS/scripts/vbox/create-aide-os-core-vm.sh --start
# Or open VirtualBox → AIDE_OS
```

## 3. First boot

- Ignore normal GRUB `ubuntu-boot` / EndEntire noise  
- Wait for install / reboot  
- Complete **console-conf**  
- Snapshot:

```bash
VBoxManage snapshot AIDE_OS take post-console-conf \
  --description "After console-conf"
```

## 4. Where you watch GUI

**VirtualBox window `AIDE_OS`** — text console on Core (not GNOME desktop).

## 5. Network (next module)

- NAT works for first boot (`10.0.2.x` style)  
- Next: attach **host-only** `vboxnet0` (already creatable on host)  
- Later: Tailscale / TV NAD (ask + tags)

## 6. Verify

```bash
bash ~/AIDE_OS/programs/aia/B2-core-appliance/verify.sh
```
