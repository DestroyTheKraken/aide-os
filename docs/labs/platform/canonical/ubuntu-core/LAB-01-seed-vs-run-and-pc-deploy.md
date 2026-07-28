---
status: Todo
---
# Lab 01 — Ubuntu Core: seed vs run, and PC deploy (verified)

**Track:** platform / Canonical  
**Role:** Linux admin · embedded/IoT systems  
**Seat:** AIDE_OS learning on **um690** · device under study: **fam-media** (HickMedia console target)  
**Status:** Verified 2026-07-26 on um690 (QEMU + official docs + image SHA256)  
**Official SoT:** [Ubuntu Core documentation](https://documentation.ubuntu.com/core/)

---

## Learning objectives

By the end of this lab you can:

1. Explain why **`error: no such device: ubuntu-boot`** appears on first boot and why it is **not** a failed flash.
2. Name the four Core partitions and when each is created.
3. Contrast **seed-only install image** vs **run mode** system.
4. Follow Canonical’s **PC deploy** path (live USB → `dd` to **internal** disk), not “boot Core USB as Desktop installer.”
5. Verify an image with checksum + optional QEMU before risking hardware.

---

## Prerequisites

| Item | Notes |
|------|--------|
| Host | um690 (`kraken`) |
| Image | `~/HickMedia/dist/ubuntu-core/ubuntu-core-24-amd64.img(.xz)` |
| Official sum | `https://cdimage.ubuntu.com/ubuntu-core/24/stable/current/SHA256SUMS` |
| Docs | Core → Tutorials → Try pre-built → **Use the dd command** |
| Tools | `sgdisk`, `parted`, optional `qemu-system-x86_64` + `ovmf` |

---

## Concept map (mental model)

```
┌─────────────────────────────────────────────────────────────┐
│  PRE-BUILT .img (what you download / flash)                 │
│  ┌──────────┐ ┌────────────────┐                            │
│  │ BIOS Boot│ │ ubuntu-seed    │  ← only these in the file  │
│  │ (tiny)   │ │ ESP + recovery │                            │
│  └──────────┘ │ systems/ snaps │                            │
│               │ GRUB → install │                            │
│               └────────────────┘                            │
│  (ubuntu-boot / save / data are MISSING until install mode) │
└─────────────────────────────────────────────────────────────┘
                            │
                            │  first boot: snapd_recovery_mode=install
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  AFTER INSTALL (on the TARGET disk)                         │
│  seed │ ubuntu-boot │ ubuntu-save │ ubuntu-data (expanded)  │
│       │  kernels    │  identity   │  system + user data     │
│  GRUB run mode boots from ubuntu-boot                       │
└─────────────────────────────────────────────────────────────┘
```

### Partition roles (storage layout)

| Partition | Role | On stock UC24 amd64 `.img`? |
|-----------|------|-----------------------------|
| **ubuntu-seed** | Recovery/install bootloader + systems + snaps | **Yes** (vfat ESP) |
| **ubuntu-boot** | Run-mode bootloader + kernels | **No** — created in install mode |
| **ubuntu-save** | Device identity / recovery data | **No** — created in install mode |
| **ubuntu-data** | Writable system/user data | **No** — created in install mode |

Canonical: *“A device image … must only contain bootloader-specific partitions and **ubuntu-seed** … Installation will create and size the other missing partitions.”*  
→ [Storage layout](https://documentation.ubuntu.com/core/explanation/core-elements/storage-layout/)

### Modes (recovery modes)

| Mode | Meaning |
|------|---------|
| **install** | Ephemeral system from seed; create partitions; then reboot |
| **run** | Normal operation (needs ubuntu-boot) |
| **recover** | Temp pristine system; data preserved |
| **factory-reset** | Wipe user system; keep ubuntu-save |

→ [Recovery modes](https://documentation.ubuntu.com/core/explanation/recovery-modes/) · [How installation works](https://documentation.ubuntu.com/core/explanation/how-installation-works/)

---

## Verified facts (do not skip)

### 1) Image integrity (um690)

```bash
curl -sS -o /tmp/SHA256SUMS.core \
  https://cdimage.ubuntu.com/ubuntu-core/24/stable/current/SHA256SUMS
sha256sum ~/HickMedia/dist/ubuntu-core/ubuntu-core-24-amd64.img.xz
grep ubuntu-core-24-amd64.img.xz /tmp/SHA256SUMS.core
```

**Verified:** our xz matches  
`d82b5b9b86e7b592dc6b48edfbce7b16be6c5064c779db91f720a1ce071622a0`

### 2) Seed-only GPT (image file)

```bash
parted -s ~/HickMedia/dist/ubuntu-core/ubuntu-core-24-amd64.img print
```

**Verified:** only **BIOS Boot** + **ubuntu-seed** — no ubuntu-boot.

### 3) GRUB intentionally searches for ubuntu-boot

Seed `EFI/ubuntu/grub.cfg` contains:

```grub
search --no-floppy --set=boot_fs --label ubuntu-boot
# default mode if unset:
# snapd_recovery_mode=install
```

Failed search → `error: no such device: ubuntu-boot` + `/EndEntire` (device path print).

### 4) Official PC guide says ignore that error

From [Use the dd command](https://documentation.ubuntu.com/core/tutorials/try-pre-built-images/use-the-dd-command/):

> When your device boots for the first time, you will see the following error message. **This can be safely ignored:**  
> `Error: no such device ubuntu-boot`

Then wait for install output and eventually: **`Press enter to configure.`**

### 5) QEMU verification (um690, 2026-07-26)

Booted our image (grown to 16G) with OVMF. Serial log showed, in order:

1. `error: no such device: ubuntu-boot.`
2. `/EndEntire` + path to `kernel.efi`
3. `EFI stub: Loaded initrd...`
4. `snapd_recovery_mode=install`
5. **`Installing the system, please wait for reboot`**
6. Created **ubuntu-boot**, **ubuntu-save**, **ubuntu-data**
7. Reboot → `snapd_recovery_mode=run`
8. **`Press enter to configure.`**

Post-boot GPT on the test disk:

```
1 BIOS Boot
2 ubuntu-seed
3 ubuntu-boot   (750 MiB)
4 ubuntu-save   (32 MiB)
5 ubuntu-data   (~14 GiB)
```

**Conclusion:** Image and flash pipeline are **good**. Waiting only on the GRUB errors is mis-diagnosis; **wrong deploy target** (USB as “installer OS” vs **internal disk**) is the PC procedure mistake.

---

## Critical procedure difference (PC vs Pi SD card)

| Device class | Canonical method |
|--------------|------------------|
| **Raspberry Pi** | Write image to **microSD**; boot that media as the system |
| **NUC / generic PC (fam-media)** | Boot **live Ubuntu Desktop** from USB → **`dd` Core to internal disk** → reboot internal |

PC guide quote:

> NUC or PC installations require the Ubuntu Core image to be written **directly to internal storage**. This cannot be done from an OS running on the same storage.

**Wrong path we took:** flash Core to USB → boot USB expecting a full install UI like Ubuntu Desktop.  
Booting seed USB can still run **install mode on that same stick** (QEMU does this on one disk), but for reimaging **fam-media’s internal drive**, you must write Core **to that internal drive** (or select it as install target once install mode fully runs on a machine that sees both disks).

---

## Lab exercises

### Exercise A — Confirm seed-only layout (10 min)

```bash
parted -s ~/HickMedia/dist/ubuntu-core/ubuntu-core-24-amd64.img unit MiB print
sgdisk -p ~/HickMedia/dist/ubuntu-core/ubuntu-core-24-amd64.img | head -25
```

**Success criteria:** Only two named partitions; free space inside the small image GPT is normal.

### Exercise B — Checksum (5 min)

Match xz SHA256 to official `SHA256SUMS` (commands above).

### Exercise C — Optional QEMU (20 min)

```bash
# Requires: qemu-system-x86 ovmf
TESTDIR=/tmp/uc24-lab
mkdir -p "$TESTDIR"
cp --sparse=always ~/HickMedia/dist/ubuntu-core/ubuntu-core-24-amd64.img "$TESTDIR/disk.img"
truncate -s 16G "$TESTDIR/disk.img"
sgdisk -e "$TESTDIR/disk.img"
cp /usr/share/OVMF/OVMF_VARS_4M.fd "$TESTDIR/OVMF_VARS.fd"

qemu-system-x86_64 -enable-kvm -smp 2 -m 2048 -machine q35 -cpu host \
  -global ICH9-LPC.disable_s3=1 \
  -netdev user,id=net0 -device virtio-net-pci,netdev=net0 \
  -drive file=/usr/share/OVMF/OVMF_CODE_4M.fd,if=pflash,format=raw,unit=0,readonly=on \
  -drive file="$TESTDIR/OVMF_VARS.fd",if=pflash,format=raw,unit=1 \
  -drive file="$TESTDIR/disk.img",if=none,format=raw,id=disk1 \
  -device virtio-blk-pci,drive=disk1,bootindex=1 \
  -serial mon:stdio
```

**Success criteria:** See install message, then eventually `Press enter to configure.` Ignore ubuntu-boot error.

### Exercise D — Plan fam-media reimage (desk work)

Write the disk names you will use **before** any wipe:

```text
Live USB device:     /dev/???
Internal target:     /dev/???   (NOT the live USB)
```

Only after `lsblk` on the live system.

### Exercise E — Canonical PC deploy (on fam-media, with monitor+keyboard)

1. Flash **Ubuntu Desktop** ISO to a USB (Ventoy ISO or Etcher) — **not** the Core img as the only plan.
2. Boot **Try Ubuntu**.
3. Download/copy Core img.xz; identify internal disk in GParted/`lsblk`.
4. Write:

```bash
xzcat /path/to/ubuntu-core-24-amd64.img.xz | \
  sudo dd of=/dev/INTERNAL_DISK bs=32M status=progress
sync
```

5. Remove USB, boot internal.
6. Expect `no such device: ubuntu-boot` → **wait** (minutes).
7. `Press enter to configure` → network → Ubuntu One email for SSH keys.

→ Full guide: [Use the dd command](https://documentation.ubuntu.com/core/tutorials/try-pre-built-images/use-the-dd-command/)

---

## Reflection questions (AIDE / SuperGrok style)

1. Why must `ubuntu-boot` be absent on a fresh seed image for install mode to make sense?
2. If GRUB defaulted to **run** mode with no ubuntu-boot, what would the user experience be?
3. Why is writing Core to a 29 G USB stick “valid” but still the wrong goal for wiping fam-media’s SSD?
4. How does TPM / Secure Boot change install (encryption)? What does the guide say about clearing TPM on reinstall?

---

## Success criteria (lab complete)

- [ ] Can explain ubuntu-boot error without blaming the flash stick  
- [ ] Can list four partitions and creation timing  
- [ ] Has a written fam-media plan: live USB + internal `dd`  
- [ ] Optional: reproduced install progression in QEMU  

---

## Related HickMedia ops (product, not education tree)

| Topic | Path |
|-------|------|
| fam-media Path C install notes | `~/HickMedia/docs/CONSOLE-V2-INSTALL-FAM-MEDIA.md` |
| Product boundary AIDE vs console | `~/AIDE_OS/docs/PRODUCT-SCOPE-AND-EDBUNTU.md` |

**Do not merge** gaming console product into AIDE_OS; this lab is **platform/Canonical literacy** for Edbuntu/admin pathways.
