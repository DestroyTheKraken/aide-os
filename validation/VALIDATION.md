# LFCS Project 09 — Secure Browser Forge Validation Report

**Status:** Awaiting first deployment — run the automation script to populate live evidence.

---

## AIOS automation validation (PR 7+)

```bash
cd /home/kraken/Projects/aios-ed
python3 validation/test_program_day.py
python3 validation/test_lesson_tasks.py
python3 validation/test_ara_eval.py
./automation/lfcs-portal-build.sh
./automation/lfcs-ara-sync.sh    # requires Open WebUI + Ollama running
./automation/lfcs-ara-eval.sh
```

Evidence: `notifications/ara-sync.log`, `notifications/ara-eval.log`, `ara_tutor/session/context.md`

---

## How to Generate This Report

```bash
cd /home/kraken/Projects/aios-ed/automation
sudo ./secure-browser-forge.sh
# Option 1: Full Deploy  (generates report automatically)
# Option 4: Generate Validation Report  (refresh evidence anytime)
```

The script overwrites this file with timestamped command output suitable for LFCS exam audit trails.

---

## LFCS Validation Checklist

| # | Requirement | Exam Critical | How to Verify |
|---|-------------|---------------|---------------|
| 1 | Configuration persists across reboots | **Yes** | `systemctl is-enabled secure-browser-forge docker firewalld` after reboot |
| 2 | Secure remote access — Tailscale only | **Yes** | `ss -tlnp \| grep 3001` shows tailnet IP; rich rule on `tailscale0` |
| 3 | Least-privilege permissions | **Yes** | `id forgesvc`; `sudo -l -U forgesvc`; PUID/PGID in compose `.env` |
| 4 | Containerized service with restart policy | **Yes** | `docker ps`; `docker inspect --format='{{.HostConfig.RestartPolicy.Name}}'` |
| 5 | Auditable documentation | **Yes** | This file with live evidence block (auto-generated) |
| 6 | Automation through bash scripts | **Yes** | `automation/secure-browser-forge.sh` — idempotent, interactive |

---

## Reboot Persistence Test (LFCS Gold Standard)

1. Deploy the forge: `sudo ./automation/secure-browser-forge.sh` → option **1**
2. Confirm validation passes: option **4**
3. Reboot: `sudo reboot`
4. Reconnect via Termius (SSH key — root login is disabled)
5. Re-run option **4** — all automated gates must pass without re-deploying

---

## Manual Reference Commands

```bash
# Container
docker ps --filter name=secure-browser-forge
docker logs --tail 50 secure-browser-forge

# Network binding (must NOT show 0.0.0.0:3001)
ss -tlnp | grep 3001

# Firewall
sudo firewall-cmd --list-rich-rules

# SSH hardening
sudo sshd -t
grep -r PermitRootLogin /etc/ssh/sshd_config.d/

# Boot persistence
systemctl is-enabled secure-browser-forge.service docker.service firewalld

# Tailnet access test (from Node1 or tablet on tailnet)
curl -k -I https://100.82.177.52:3001/
```

---

## Live Evidence

*Not yet collected. Run `sudo ./automation/secure-browser-forge.sh` and choose option 4.*

---

*Template — replaced automatically by `secure-browser-forge.sh`*