# B2 — Core appliance lab (Ubuntu Core on VirtualBox)

| Field | Value |
|-------|--------|
| **Track** | AI IoT Augmentation (`aia`) |
| **Outcome** | Boot Ubuntu Core 26 in VirtualBox, finish console-conf, snapshot, document SSH path |
| **Hardware** | Host: mid PC (e.g. UM690-class, 16+ GB free RAM for 4 GB guest) |
| **Time** | ~1–2 h first time (download + convert + first boot) |
| **GrokBuild** | Strategic only (decisions/debug); download/VBox = **local** |
| **Source sessions** | Design AIDE_OS VirtualBox; night close Core bring-up |

## Success criteria

- [ ] Core image verified (SHA256) under `~/AIDE_OS/dist/ubuntu-core/`  
- [ ] VM `AIDE_OS` exists, EFI, boots  
- [ ] console-conf completed  
- [ ] Snapshot `post-console-conf`  
- [ ] Operator can open VirtualBox GUI for console  
- [ ] `verify.sh` exits 0  

## Links

- Install: [INSTALL.md](./INSTALL.md)  
- Ops deep dive: `docs/ops/AIDE-OS-CORE-VM.md`  
- Learning track: `docs/labs/LEARNING-TRACK-AIDE-OS.md`  
