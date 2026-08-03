# PR3 — classic `aide-lab` status

| Field | Value |
|-------|--------|
| **Date** | 2026-08-02 (evening) |
| **Design** | `docs/design/2026-08-02-aide-lab-virtualbox.md` — **Accepted** (rev g) |
| **Option** | **A** — clone of **Learn Aide (edubuntu 26.06)** |
| **VM** | `aide-lab` (intent display: AIDE_OS Lab) |
| **Script** | `scripts/vbox/create-aide-lab.sh --option a --start` |
| **Spare** | `aide-lab-cinnamon` — earlier mistaken Option C clone (kept) |

---

## Acceptance (design PR3)

| Criterion | Result |
|-----------|--------|
| `vboxnet0` exists @ 192.168.56.1/24 | **Yes** |
| Classic desktop = **Edubuntu** (not Core, not Cinnamon MVP) | **Yes** — from Learn Aide (edubuntu 26.06) |
| NIC1 NAT + NIC2 host-only | **Yes** |
| VRAM 128 + VMSVGA | **Yes** |
| RAM 10 GiB / 4 vCPU (demo) | **Yes** |
| Disk grown toward 50 GiB | **Yes** |
| Shares ro: `AIDE_OS_ref`, `screenshots` | **Yes** (mount needs Guest Additions + `vboxsf`) |
| Snapshots | `learn-aide-promoted` on `aide-lab`; source savestate discarded |
| GUI started | **Yes** (`startvm --type gui`) |
| No Core flash as day-1 | **Yes** |

**Correction:** First PR3 spin used Option C (Cinnamon). Director corrected → rebuilt Option A Edubuntu as `aide-lab`; Cinnamon renamed `aide-lab-cinnamon`.

---

## Black TTY vs desktop (operator)

| Window | VM | Expect |
|--------|-----|--------|
| **Black console / TTY** | `AIDE_OS` | Ubuntu **Core 26** — no course UI |
| **Edubuntu desktop** | **`aide-lab`** | **MVP course track** |
| **Cinnamon (spare)** | `aide-lab-cinnamon` | Optional only |

UI / theme reference (GrokAide SysAdmin & Platform Development):  
`~/Pictures/Screenshots/Screenshot From 2026-08-02 18-11-40.png`

---

## Guest next (you / PR7)

1. Log into Cinnamon (same user as the Cinnamon VM had).  
2. Optional design user: `sudo adduser aide` + groups.  
3. Install/update **Guest Additions** (host VBox **7.2.12**).  
4. `sudo usermod -aG vboxsf $USER` → re-login → `/media/sf_AIDE_OS_ref`, `/media/sf_screenshots`.  
5. Later PRs: aidectl modules (PR4), dashboard (PR5), agent (PR6), Obsidian/GrokAide workspace + theme (PR7).

---

## Host commands

```bash
# Start classic lab
bash ~/AIDE_OS/scripts/vbox/create-aide-lab.sh --start

# Stop Core if you only want one window
VBoxManage controlvm AIDE_OS acpipowerbutton

# Status
VBoxManage list runningvms
VBoxManage showvminfo aide-lab | head -30
```
