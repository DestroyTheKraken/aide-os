# Operations & Deployment — LFCS Reference

**LFCS weight:** ~25% · **Projects:** 04, 08, 09  
**AIOS nodes:** node1 (systemd), um690 (automation + compose)  
**Tracker:** `guides/OBJECTIVES_TRACKER.md` §§ 4, 8, 9

systemd services, process control, resource limits, kernel tuning, bash automation, cron/at, containers. Cross-links: `weak-areas/docker-compose.md`.

---

## systemd — service lifecycle (Project 04)

### Unit file anatomy

```ini
# /etc/systemd/system/myapp.service
[Unit]
Description=LFCS lab application
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=labuser
ExecStart=/usr/local/bin/myapp.sh
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

### Essential commands

```bash
sudo systemctl daemon-reload          # after unit file edit
sudo systemctl start myapp.service
sudo systemctl stop myapp.service
sudo systemctl restart myapp.service
sudo systemctl reload nginx.service   # if supported
sudo systemctl enable myapp.service   # boot
sudo systemctl enable --now myapp.service
sudo systemctl disable myapp.service
sudo systemctl status myapp.service
sudo systemctl is-enabled myapp.service
sudo systemctl is-active myapp.service
systemctl list-dependencies myapp.service
```

### Journal logs

```bash
journalctl -u myapp.service
journalctl -u myapp.service -n 100 --no-pager
journalctl -u myapp.service -f
journalctl -b                       # this boot
journalctl --since "1 hour ago"
```

### AIOS example

`lfcs-backend.service` wraps `docker compose up -d` on um690 — same pattern as Project 09 boot persistence.

---

## Process management

```bash
ps aux
ps aux --sort=-%mem | head
ps -ef --forest                   # tree
top                               # interactive
htop                              # if installed
pgrep -a nginx
pidof sshd

# Signals
kill PID                          # SIGTERM (15)
kill -9 PID                       # SIGKILL — last resort
killall processname
nice -n 10 command
renice -n 5 -p PID
```

| Signal | Number | Use |
|--------|--------|-----|
| SIGTERM | 15 | polite stop |
| SIGHUP | 1 | reload config |
| SIGKILL | 9 | force kill |

---

## Resource limits (Project 04)

### limits.conf

```bash
# /etc/security/limits.conf
labuser soft nofile 4096
labuser hard nofile 8192
labuser soft nproc 512
labuser hard nproc 1024
```

Verify: `su - labuser -c 'ulimit -a'`

### systemd service limits

```ini
[Service]
LimitNOFILE=8192
LimitNPROC=512
```

---

## Kernel parameters — sysctl (Projects 04, 07)

```bash
# View
sysctl -a | grep ip_forward
sysctl net.ipv4.ip_forward

# Runtime change
sudo sysctl -w net.ipv4.ip_forward=1

# Persistent — /etc/sysctl.d/99-lfcs.conf
net.ipv4.ip_forward = 1
vm.swappiness = 10

sudo sysctl --system                 # load all
sudo sysctl -p /etc/sysctl.d/99-lfcs.conf
```

**NAT gateway (Project 07):** `net.ipv4.ip_forward=1` required.

---

## Bash scripting (Project 08)

```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LFCS_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
LOG="${LFCS_ROOT}/notifications/study-journal.log"

log() { printf '[%s] %s\n' "$(date -Iseconds)" "$*"; }

main() {
  if ! mountpoint -q /backup; then
    log "ERROR: /backup not mounted"
    exit 1
  fi
  tar -czf "/backup/lab-$(date +%F).tar.gz" -C "${HOME}" lab
  log "Backup OK"
}

main "$@"
```

| Option | Effect |
|--------|--------|
| `set -e` | Exit on command failure |
| `set -u` | Error on unset variable |
| `set -o pipefail` | Pipe fails if any stage fails |

---

## Scheduling — cron & at (Project 08)

### cron

```bash
crontab -e                  # user crontab
sudo crontab -e             # root
crontab -l
ls -la /etc/cron.d/
cat /etc/crontab

# Field order: min hour dom month dow command
# 07:00 daily
0 7 * * * /home/kraken/Projects/aios-ed/automation/lfcs-daily-guidance.sh
```

AIOS: `install-daily-cron.sh` schedules guidance at 07:00.

**Cron rule:** Use **absolute paths** in scripts — cron has minimal `$PATH`.

### at

```bash
sudo systemctl enable --now atd
echo "systemctl restart myapp" | at now + 1 hour
atq                         # queue
atrm JOB_ID
```

---

## Containers (summary — detail in weak-areas/docker-compose.md)

```bash
docker ps -a
docker logs container
docker inspect container
docker compose up -d
docker compose ps
```

Project 09 capstone: tailnet bind, `restart: unless-stopped`, systemd wrapper.

---

## Verification drills

```bash
# Custom unit survives reboot
systemctl is-enabled myapp.service
systemctl is-active myapp.service

# sysctl persistence
grep ip_forward /etc/sysctl.d/*.conf
sysctl net.ipv4.ip_forward

# Cron registered
crontab -l | grep lfcs-daily

# Script safety
bash -n script.sh           # syntax check
shellcheck script.sh        # if installed
```

---

## Common exam traps

1. **Forgot `daemon-reload`** after editing unit file.
2. **`enable` vs `start`** — enable is boot only; need both for now+boot.
3. **SIGKILL first** — try SIGTERM before `-9`.
4. **sysctl without persistent file** — lost on reboot.
5. **Cron relative paths** — use full paths.
6. **Running long scripts as root** — use dedicated service user.

---

## man pages

```bash
man systemd.service
man systemctl
man journalctl
man crontab
man at
man bash
man sysctl.d
```

---

## Ara prompts

- "Write a systemd unit for a bash script at boot."
- "Make sysctl ip_forward persistent across reboot."
- "Explain set -euo pipefail in LFCS scripts."
- "cron vs at — when to use each?"

**Related:** `Study_Projects/04.md`, `08.md`, `09.md` · `weak-areas/docker-compose.md`