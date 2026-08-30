# Docker Compose — Weak-Area Drill

**LFCS domains:** Operations & Deployment (~25%), Networking (port binding)  
**AIOS schedule:** Days 24, 26 (Project 09 capstone) · `weak_area: docker-compose`  
**Lab nodes:** Day 24 → `node3` (forge host) · Day 26 → validation on cluster  
**Study guide:** `Study_Projects/09.md` — Secure Browser Forge  
**Live reference:** `docker/docker-compose.yml` on um690

Compose v2 syntax (`docker compose`, not legacy `docker-compose` standalone). Your AIOS stack runs five services on um690; Project 09 deploys the Mullvad browser pattern with the same compose discipline.

---

## Day 24 checklist (Phase 3 — deploy stack)

1. Confirm `FORGE_BIND_IP` is your **Tailscale IP** (never `0.0.0.0` on exam-facing services)
2. Write or extend `docker-compose.yml` with `restart`, `volumes`, `networks`
3. `docker compose --env-file .env up -d`
4. Verify containers healthy: `docker ps`, healthcheck status

## Day 26 checklist (Phase 5 — persistence)

1. Confirm `restart: unless-stopped` on all services
2. Optional systemd unit wrapping `docker compose up -d` for boot
3. Reboot test → all containers return without manual intervention
4. `validation/VALIDATION.md` evidence block

---

## File layout (AIOS / LFCS)

```
docker/
├── docker-compose.yml    # service definitions
└── .env                  # secrets + bind IP (never commit passwords to git)
```

Deploy copies compose to `/opt/lfcs/secure-browser-forge/` via `automation/lfcs-backend-deploy.sh`. Development edits happen in `${LFCS_ROOT}/docker/`.

---

## Compose file anatomy

```yaml
services:
  service-name:
    image: repo/image:tag
    container_name: human-readable-name
    hostname: dns-name-on-bridge
    restart: unless-stopped

    environment:
      - KEY=${KEY_FROM_ENV:?required}

    ports:
      - "${BIND_IP}:host_port:container_port"

    volumes:
      - named-volume:/path/in/container
      - ${HOST_PATH}:/container/path:ro

    depends_on:
      other-service:
        condition: service_healthy

    healthcheck:
      test: ["CMD-SHELL", "curl -sf http://localhost/ || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 5
      start_period: 60s

    networks:
      - app-net

networks:
  app-net:
    driver: bridge

volumes:
  named-volume:
    name: explicit-volume-name
```

### Top-level keys (LFCS must-know)

| Key | Purpose |
|-----|---------|
| `services` | One stanza per container |
| `image` | Pull source (`nginx:alpine`, `ollama/ollama:latest`) |
| `build` | Build from Dockerfile (less common on LFCS than `image`) |
| `ports` | Publish container port to host |
| `volumes` | Bind mounts (`host:container`) or named volumes |
| `environment` | Env vars; `${VAR}` substitution from `.env` |
| `depends_on` | Start order; use `condition: service_healthy` when healthchecks exist |
| `healthcheck` | Docker marks service healthy → dependents can start |
| `restart` | `no` · `always` · `on-failure` · `unless-stopped` (LFCS default) |
| `networks` | Bridge network isolates service DNS (`lfcs-ollama` hostname) |
| `mem_limit` / `cpus` | Resource caps (AIOS Ollama service) |

---

## AIOS stack — service map

| Service | Image | Host port | Role |
|---------|-------|-----------|------|
| `lfcs-portal` | `nginx:alpine` | 3080 | Dashboard |
| `lfcs-ide` | `codercom/code-server` | (proxied `/ide/`) | Workspace |
| `lfcs-openwebui` | Open WebUI | 3082 | Ara tutor |
| `lfcs-ollama` | `ollama/ollama` | 11434 | LLM runtime |
| `mullvad-browser` | linuxserver/mullvad-browser | 3001 | Lab browser |

All published ports use `${FORGE_BIND_IP}`:

```yaml
ports:
  - "${FORGE_BIND_IP:?Set FORGE_BIND_IP}:3080:80"
```

The `:?` syntax **fails compose parsing** if the variable is unset — prevents accidental `0.0.0.0` bind from empty env.

---

## `.env` file patterns

```bash
# docker/.env (example keys — rotate secrets locally)
FORGE_BIND_IP=  # set locally; do not commit Tailscale IP          # tailscale ip -4
LFCS_ROOT=/home/kraken/Projects/aios-ed
FORGE_PUID=1000
FORGE_PGID=1000
FORGE_WEB_USER=lfcs
FORGE_WEB_PASSWORD=<set-strong-password>
TZ=America/Chicago
```

| Variable | Used by | Notes |
|----------|---------|-------|
| `FORGE_BIND_IP` | All `ports:` mappings | Tailnet-only exposure |
| `LFCS_ROOT` | Bind mounts for portal, ara_tutor, IDE | Absolute path on um690 |
| `FORGE_WEB_PASSWORD` | IDE + Mullvad browser | Required (`:?` in compose) |
| `FORGE_PUID` / `FORGE_PGID` | linuxserver images | Match service account ownership |

**Exam trap:** Never commit real passwords. `.env` stays on the host; git tracks `.env.example` with empty placeholders.

---

## Essential commands (Compose v2)

```bash
cd /home/kraken/Projects/aios-ed/docker

# Validate compose syntax
docker compose config

# Start all services (detached)
docker compose --env-file .env up -d

# Start one service
docker compose up -d lfcs-portal

# View status
docker compose ps
docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'

# Logs
docker compose logs -f lfcs-ollama
docker logs --tail 50 lfcs-portal

# Recreate after compose edit
docker compose up -d --force-recreate lfcs-openwebui

# Stop without removing volumes
docker compose stop

# Tear down (containers + networks; named volumes persist)
docker compose down

# Tear down including named volumes (destructive)
docker compose down -v
```

---

## depends_on + healthchecks (AIOS pattern)

Open WebUI waits for healthy Ollama:

```yaml
lfcs-openwebui:
  depends_on:
    lfcs-ollama:
      condition: service_healthy

lfcs-ollama:
  healthcheck:
    test: ["CMD-SHELL", "ollama list >/dev/null 2>&1 || exit 1"]
    interval: 30s
    start_period: 45s
```

Portal waits for IDE and Open WebUI **started** (not healthy):

```yaml
lfcs-portal:
  depends_on:
    lfcs-ide:
      condition: service_started
    lfcs-openwebui:
      condition: service_started
```

**LFCS lesson:** `service_healthy` prevents race where a dependent starts before the API is ready.

---

## Volumes — bind vs named

```yaml
# Bind mount — live-edit host files (portal static assets)
volumes:
  - ${LFCS_ROOT}/portal/www:/usr/share/nginx/html:ro

# Named volume — persistent container state (Ollama models, browser profile)
volumes:
  - ollama-data:/root/.ollama

volumes:
  ollama-data:
    name: lfcs-ollama-data
```

| Type | Survives `docker compose down`? | Use case |
|------|----------------------------------|----------|
| Bind mount | Yes (host files) | Config, HTML, `ara_tutor/` |
| Named volume | Yes (unless `down -v`) | Databases, model weights, browser profile |

---

## Networks — internal DNS

Services on `lfcs-net` resolve each other by **service name**:

```yaml
environment:
  - OLLAMA_BASE_URL=http://lfcs-ollama:11434
```

External clients use **host** Tailscale IP + published port — not container DNS.

---

## Tailnet-only binding (Project 09 / LFCS exam)

**Requirement:** Service listens on Tailscale IP only, not `0.0.0.0`.

```bash
# Good — compose with FORGE_BIND_IP=  # set locally; do not commit Tailscale IP
ss -tlnp | grep 3080
# LISTEN on tailscale0:3080 (address omitted in public docs)

# Bad — exposed to LAN/Starlink
# LISTEN 0.0.0.0:3080
```

Pair with host firewall (ufw on Ubuntu um690, firewalld on Rocky node3):

```bash
# Ubuntu um690 (deploy script applies similar rules)
sudo ufw allow in on tailscale0 to any port 3080 proto tcp
```

Project 09 on Rocky uses **firewalld rich rules** for `100.64.0.0/10` on `tailscale0`.

---

## Minimal exam-style compose (from scratch)

Task: Run `nginx:alpine` on port 8080, tailnet-only, restart on boot, custom HTML from host.

```yaml
services:
  web:
    image: nginx:alpine
    container_name: lfcs-nginx-lab
    restart: unless-stopped
    ports:
      - "${BIND_IP:?set BIND_IP}:8080:80"
    volumes:
      - ./html:/usr/share/nginx/html:ro
    healthcheck:
      test: ["CMD-SHELL", "wget -qO- http://127.0.0.1:80/ >/dev/null || exit 1"]
      interval: 15s
      retries: 3
```

```bash
export BIND_IP=$(tailscale ip -4)
mkdir -p html && echo '<h1>LFCS lab</h1>' > html/index.html
docker compose up -d
curl -s "http://${BIND_IP}:8080/"
```

---

## systemd boot persistence (Project 09)

Compose alone does not start stacks at **host boot** unless Docker restart policy brings containers back. LFCS capstone often wants a **systemd unit**:

```ini
# /etc/systemd/system/lfcs-backend.service
[Unit]
Description=LFCS Docker Compose Stack
After=docker.service network-online.target
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/opt/lfcs/secure-browser-forge
ExecStart=/usr/bin/docker compose --env-file .env up -d
ExecStop=/usr/bin/docker compose down
TimeoutStartSec=300

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now lfcs-backend.service
sudo systemctl status lfcs-backend.service
```

AIOS uses `lfcs-backend-deploy.sh` to install this unit on um690.

---

## Deploy workflow (um690)

```bash
cd /home/kraken/Projects/aios-ed/automation
sudo ./lfcs-backend-deploy.sh
# or: sudo ./lfcs-backend-deploy.sh --non-interactive
```

Script responsibilities:
- Install Docker if missing
- Copy compose + write `${DEPLOY_DIR}/.env`
- `docker compose up -d`
- ufw tailnet rules for 3080, 3001, 3082, 11434
- systemd enable for boot
- Write `notifications/tablet-credentials.txt`

After editing `docker/docker-compose.yml` in git:

```bash
sudo ./automation/lfcs-backend-deploy.sh --non-interactive
# or manually:
cd /opt/lfcs/secure-browser-forge
sudo docker compose --env-file .env up -d
```

---

## Verification commands

```bash
# All services up
docker compose ps --format 'table {{.Name}}\t{{.Status}}'

# Restart policy
docker inspect --format='{{.HostConfig.RestartPolicy.Name}}' lfcs-portal
# unless-stopped

# Health
docker inspect --format='{{.State.Health.Status}}' lfcs-ollama

# Port bind check
ss -tlnp | grep -E '3080|3001|3082|11434'

# Config drift — what compose will apply
docker compose --env-file .env config | head -40

# Project 09 validation menu
sudo ./automation/secure-browser-forge.sh
# option 4 → refreshes validation/VALIDATION.md
```

---

## Common mistakes (exam + lab)

1. **`0.0.0.0` bind** — use explicit Tailscale IP in `ports:`.
2. **Missing `.env`** — `${VAR:?}` errors look cryptic; run with `--env-file .env`.
3. **`docker-compose` vs `docker compose`** — LFCS expects v2 plugin syntax.
4. **Wrong volume path** — `${LFCS_ROOT}` must exist on host before `up`.
5. **No healthcheck grace** — Ollama needs `start_period: 45s` before marking unhealthy.
6. **Editing running container** — changes lost on recreate; edit compose + `up -d --force-recreate`.
7. **PUID/PGID mismatch** — linuxserver volumes owned by root if IDs wrong.
8. **depends_on without healthcheck** — dependent starts before API ready.
9. **Forgot reboot test** — LFCS gold standard is persistence after `sudo reboot`.

---

## man / help references

```bash
docker compose --help
docker compose config --help
man docker
man systemd.unit   # for unit files
```

Project 09 on Rocky: `man docker`, `man firewalld.richlanguage`, `man sshd_config`.

---

## Ara tutoring prompts (examples)

- "Explain the AIOS `lfcs-portal` service stanza line by line."
- "Why does Open WebUI use `depends_on` with `service_healthy` on Ollama?"
- "Write a compose file for nginx on tailnet port 8080 with a bind mount."
- "Difference between `docker compose down` and `down -v`?"
- "How do I verify my stack survived reboot on um690?"

**Related:** `docker/docker-compose.yml` · `Study_Projects/09.md` · `validation/VALIDATION.md` · Days 24, 26 in `schedule/daily-schedule.json`