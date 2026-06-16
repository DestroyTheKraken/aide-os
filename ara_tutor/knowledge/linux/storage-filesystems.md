# Storage & Filesystems — LFCS Reference

**LFCS weight:** ~20% · **Project:** 05  
**AIOS node:** node3 (storage + capstone)  
**Tracker:** `guides/OBJECTIVES_TRACKER.md` § 5

Partition disks, create filesystems, configure persistent mounts, manage swap, monitor usage. GPT preferred on modern systems.

---

## Identify block devices

```bash
lsblk
lsblk -f
sudo fdisk -l
sudo partprobe                    # re-read partition table
blkid
ls -l /dev/disk/by-uuid/
```

---

## Partitioning — GPT (Project 05)

```bash
# WARNING: targets empty disk — verify device name
DISK=/dev/sdb

sudo parted -s "${DISK}" mklabel gpt
sudo parted -s "${DISK}" mkpart primary ext4 1MiB 10GiB
sudo parted -s "${DISK}" mkpart primary linux-swap 10GiB 12GiB
sudo parted "${DISK}" print

# Alternative: fdisk (interactive or scripted)
sudo fdisk "${DISK}"
# g → n → partitions → w
```

| Tool | Use |
|------|-----|
| `parted` | GPT, scripting |
| `fdisk` | MBR or GPT |
| `gdisk` | GPT interactive |

---

## Create filesystems

```bash
PART=/dev/sdb1
SWAP=/dev/sdb2

sudo mkfs.ext4 -L LABDATA "${PART}"
sudo mkfs.xfs -L LABXFS /dev/sdb3    # if third partition
sudo mkswap -L LABSWAP "${SWAP}"
```

```bash
sudo e2label /dev/sdb1 LABDATA       # ext label
sudo xfs_admin -L LABXFS /dev/sdb3   # xfs label
blkid "${PART}"
```

---

## Swap

```bash
sudo swapon "${SWAP}"
sudo swapon --show
free -h
sudo swapoff "${SWAP}"
```

---

## Mount points & fstab (persistence)

```bash
sudo mkdir -p /mnt/labdata
sudo mount /dev/sdb1 /mnt/labdata
mount | grep labdata
df -h /mnt/labdata
```

### `/etc/fstab` — use UUID (exam gold standard)

```bash
UUID=$(blkid -s UUID -o value /dev/sdb1)
SWAP_UUID=$(blkid -s UUID -o value /dev/sdb2)
```

```fstab
# /etc/fstab
UUID=xxxx-xxxx  /mnt/labdata  ext4  defaults,noatime  0  2
UUID=yyyy-yyyy  none          swap  sw                0  0
```

| Field | Meaning |
|-------|---------|
| 1 | UUID or device |
| 2 | Mount point (`none` for swap) |
| 3 | fstype |
| 4 | Options |
| 5 | dump (0=off) |
| 6 | fsck order (0=skip, 1=root, 2=other) |

### Safe fstab test (no reboot)

```bash
sudo umount /mnt/labdata
sudo mount -a                     # mount all fstab entries
echo $?                           # must be 0
findmnt /mnt/labdata
```

**Exam trap:** Bad fstab → boot failure. Always `mount -a` before reboot.

---

## Remote & network mounts (preview — Project 06)

```fstab
server:/export  /mnt/nfs  nfs  defaults,_netdev,x-systemd.requires=network-online.target  0  0
```

`_netdev` delays mount until network is up.

---

## Disk usage & inodes

```bash
df -h
df -i                             # inode exhaustion
du -sh /var/*
du -h --max-depth=1 /home
ncdu /                            # if installed
```

---

## Filesystem maintenance

```bash
# ext4 check — partition must be unmounted
sudo umount /mnt/labdata
sudo fsck.ext4 -f /dev/sdb1
sudo mount /mnt/labdata

# xfs
sudo xfs_repair /dev/sdb3         # unmounted only
```

---

## LVM (exam stretch objective)

```bash
sudo pvcreate /dev/sdb1
sudo vgcreate vg_lab /dev/sdb1
sudo lvcreate -L 5G -n lv_data vg_lab
sudo mkfs.ext4 /dev/vg_lab/lv_data
```

Extend: `lvextend -L +2G /dev/vg_lab/lv_data` + `resize2fs` (ext4).

---

## AIOS context

- node3: storage labs + Project 09 capstone volumes
- NAS symlink: `/home/kraken/XDrive` → `/mnt/XstorA` (optional backup target OQ5)
- Docker named volumes on um690 are **not** fstab — separate concern (`docker-compose.md`)

---

## Verification drills (Project 05)

```bash
lsblk -f
findmnt --verify                  # systemd fstab check (if available)
grep -v '^#' /etc/fstab | grep -v '^$'
swapon --show
# Reboot test — LFCS gold standard
sudo reboot
# after reconnect:
findmnt /mnt/labdata && swapon --show
```

---

## Common exam traps

1. **Device names (`/dev/sdb`)** change — use **UUID** in fstab.
2. **Skipping `mount -a` test** before reboot.
3. **fsck on mounted filesystem** — corrupts data.
4. **Wrong fsck pass number** — root is 1, others 2.
5. **Forgot `sw` option** for swap line.
6. **GPT without bios_grub/EFI** on legacy BIOS — know your firmware.

---

## man pages

```bash
man 5 fstab
man mkfs.ext4
man swapon
man parted
man lvm
```

---

## Ara prompts

- "Write fstab line for ext4 using UUID."
- "Safe workflow to test fstab without reboot?"
- "Difference between ext4 and xfs for LFCS?"
- "How to add swap partition persistently?"

**Related:** `Study_Projects/05.md` · `networking/ip-dns-routing.md` (NFS mounts)