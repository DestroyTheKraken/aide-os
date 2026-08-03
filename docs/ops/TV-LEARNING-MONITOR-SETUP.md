# Samsung TV · LabNET learning / dev monitor

| Field | Value |
|-------|--------|
| **Target** | Samsung TV · intended static **192.168.20.103** |
| **MAC** (LabNET) | `20:15:de:c6:fe:f6` |
| **Subnet** | LabNET `192.168.20.0/24` · gateway `.1` |
| **um690** | `192.168.20.100` (serves portfolio) |
| **SSH on TV** | **No** — display only |
| **Updated** | 2026-08-02 |

TV is **up on ethernet** (ping OK from um690). You finish static IP + browser URL.

---

## You do (TV) — static IP

### Option A — on the TV (fastest)

1. Settings → **Network** → (wired) **Network Status** / Expert settings  
2. Set **IP settings → Static** (wording varies by Tizen year):
   - IP: **192.168.20.103**  
   - Subnet: **255.255.255.0**  
   - Gateway: **192.168.20.1**  
   - DNS: **192.168.20.1** or **1.1.1.1**  
3. Apply · reboot TV if needed  
4. Confirm TV still online: from um690 `ping 192.168.20.103`

### Option B — VyOS DHCP static-mapping (durable, like fam-media)

On router (when you have a calm ops slot):

```text
# Pseudocode — match your VyOS style for fam-media
# static-mapping samsung-tv
#   mac 20:15:de:c6:fe:f6
#   ip 192.168.20.103
```

Then TV can stay DHCP client but always gets `.103`.

---

## You do (um690) — website on the wall

1. Start server (LAN-visible):

```bash
cd ~/AIDE_OS/site && ./serve.sh
```

2. On TV browser (or Smart View / cast a Chrome tab from um690):

```text
http://192.168.20.100:8099/aide/home/joshua/
```

| Page | URL path |
|------|----------|
| Portfolio home | `/aide/home/joshua/` |
| Projects | `/aide/home/joshua/projects/` |
| Skills | `/aide/home/joshua/skills/` |

3. **Workflow:** leave TV on that URL · I edit site files · you **refresh TV** · you prompt changes · I patch · stop (no essay) unless Traceback / plan / Q&A needed.

---

## Learning monitor uses

| Mode | What plays on TV |
|------|------------------|
| **Dev** | Portfolio / docs pages live |
| **LFCS** | YouTube from `lesson-today.py` (Cast or YouTube app + URL) |
| **Day start** | Optional second screen while Obsidian Workspace 1 on desk |

Design deep-dive: `docs/design/2026-08-02-learning-wall-tv-nad.md`

---

## Collaboration protocol (browser-first / “ASH”)

| Situation | Grok behavior |
|-----------|----------------|
| Visual change on site | Patch → **stop** (no long reply) unless you ask |
| You need to fix something | Short **Q/A** or **plan mode** · like a Traceback + next command |
| Teaching moment | One clarifying question max, then wait |
| Success silent OK | Green path = minimal text |

Think: advanced themeable terminal — **prompt → action → optional diagnostic**.
