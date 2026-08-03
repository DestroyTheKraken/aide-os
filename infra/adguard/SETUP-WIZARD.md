# AdGuard Home — first-run setup wizard (um690)

**Your Admin UI:** http://127.0.0.1:3080
(or from another LabNET PC: http://192.168.20.100:3080)

Until you finish the wizard, the browser redirects to **`/install.html`**. That is normal.

**Official docs (AdGuard):**
https://adguard-dns.io/kb/adguard-home/getting-started/

**YouTube (search — pick a recent “AdGuard Home setup” video):**
https://www.youtube.com/results?search_query=AdGuard+Home+setup+wizard+docker
Any 2023–2025 “AdGuard Home Docker install” walkthrough works; **use our ports below**, not whatever the video uses.

---

## Before you start

1. On **um690**, open a browser (Firefox/Chrome).
2. Go to: **http://127.0.0.1:3080**
3. You should see the **Get Started / Install** wizard (not a login form).
4. Have **Bitwarden** ready to save the admin password (do **not** put it in git or chat).

Container should be running:

```bash
docker ps --filter name=adguardhome
```

If not:

```bash
cd ~/AIDE_OS/infra/adguard && docker compose up -d
```

---

## Wizard steps (click through)

AdGuard’s wizard is usually **5 steps**. Labels can vary slightly by version.

### Step 1 — Welcome / Get Started

- Click **Get Started** (or **Next**).

### Step 2 — Admin Web Interface

| Field | What to enter **on this lab** |
|-------|-------------------------------|
| **Listen interface** | All interfaces, **or** the one for `192.168.20.100` |
| **Port** | Leave **3000** *inside* the container if shown — we already map host **3080 → 3000** |

If the UI asks only for “Admin interface port” and defaults to `80` or `3000`:

- Prefer **3000** (matches our Docker map).
- You will keep opening **http://127.0.0.1:3080** from the host (mapped port).

Click **Next**.

### Step 3 — DNS server

| Field | What to enter |
|-------|----------------|
| **Listen interfaces** | All, or LabNET |
| **Port** | **53** (default DNS) |

That matches Docker: `192.168.20.100:53 → 53`.

Click **Next**.

### Step 4 — Configure static IP (if shown)

Some builds show a “configure static IP” note for the **machine**.
**Skip / Next** — um690 already has LabNET address `192.168.20.100` from DHCP/static on the host. You are **not** changing um690’s IP in this wizard.

### Step 5 — Administrator account

| Field | Value |
|-------|--------|
| **Username** | e.g. `admin` or `josh` |
| **Password** | Strong password → **save in Bitwarden** |

Click **Next** / **Open Dashboard**.

You should land on the **Dashboard** (graphs, “DNS queries”, settings gear).
If you see **Login**, use the username/password you just set.

---

## Right after the wizard (2 minutes)

### 1) Upstream DNS

**Settings → DNS settings** (or **DNS**):

- Upstream DNS servers, e.g.:
  - `1.1.1.1`
  - `1.0.0.1`
  or `9.9.9.9`
- Save.

### 2) Blocklists (optional now)

**Filters → DNS blocklists → Add blocklist**
Enable something small first (e.g. AdGuard DNS filter / OISD small).
Save. Don’t enable 50 lists on day one.

### 3) Do **not** change whole-house DNS yet

Until you test one device:

- Leave phones/PCs on normal DNS (VyOS / router).
- **Test one machine only:** set DNS manually to `192.168.20.100`.
- Browse a few sites. If broken, set that machine DNS back to automatic / `192.168.20.1`.

---

## If something goes wrong

| Problem | Fix |
|---------|-----|
| Page won’t load | `cd ~/AIDE_OS/infra/adguard && docker compose up -d` then retry http://127.0.0.1:3080 |
| Stuck on install.html after finishing | Hard refresh (Ctrl+Shift+R) or open http://127.0.0.1:3080/login.html |
| Forgot password | Stop container, remove `conf/` (resets wizard), start again — only if you’re OK redoing setup |
| Port in use / wizard fails | Tell Grok; we remapped admin to **3080** already |

Reset (destroys AdGuard config only, not your PC):

```bash
cd ~/AIDE_OS/infra/adguard
docker compose down
rm -rf conf/* work/*
docker compose up -d
# open http://127.0.0.1:3080 again for a fresh wizard
```

---

## Official + video

| Resource | Link |
|----------|------|
| AdGuard Home Getting Started (KB) | https://adguard-dns.io/kb/adguard-home/getting-started/ |
| GitHub project | https://github.com/AdguardTeam/AdGuardHome |
| YouTube search | “AdGuard Home setup wizard Docker” |

Videos often use port **3000** or **80** on the host. **Your lab uses 3080 for the web UI** and **53 for DNS** on `192.168.20.100`.

---

## Success checklist

- [ ] Dashboard loads at http://127.0.0.1:3080 (not install.html)
- [ ] Admin password in Bitwarden
- [ ] Upstream DNS set
- [ ] One test client using DNS `192.168.20.100` works
- [ ] Other devices still use normal DNS until you choose Lab-wide cutover
