#!/usr/bin/env bash
# =============================================================================
# LFCS Cluster Scanner — discovers live tailnet assets and writes inventory.
# Run from um690 (control plane). Safe to re-run anytime.
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LFCS_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
INV_DIR="${LFCS_ROOT}/inventory"
INV_JSON="${INV_DIR}/cluster.json"
INV_MD="${LFCS_ROOT}/guides/CLUSTER_INVENTORY.md"
SSH_USER="${SSH_USER:-kraken}"
SCAN_TS="$(date -Iseconds)"

mkdir -p "${INV_DIR}" "${LFCS_ROOT}/guides" "${LFCS_ROOT}/notifications/daily"

log() { printf '[%s] %s\n' "$(date '+%H:%M:%S')" "$*"; }

# Probe a host over SSH — outputs valid JSON via python
probe_host() {
    local name="$1" ip="$2"
    local reachable="false" ssh_ok="false"
    local os="" ram="" cores="" docker="" lan="" uptime="" disk=""

    if tailscale ping -c 1 -timeout 3s "${ip}" &>/dev/null; then
        reachable="true"
    fi

    if [[ "${reachable}" == "true" ]]; then
        local remote
        remote="$(ssh -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=accept-new \
            "${SSH_USER}@${ip}" '
            echo "OS=$(source /etc/os-release 2>/dev/null; echo ${PRETTY_NAME:-unknown})"
            echo "RAM=$(free -h | awk "/^Mem:/{print \$2}")"
            echo "CORES=$(nproc)"
            echo "DOCKER=$(systemctl is-active docker 2>/dev/null | head -1 || echo inactive)"
            echo "LAN=$(ip -4 -br addr show | awk "/eno|eth/{print \$3}" | head -1 | cut -d/ -f1)"
            echo "UPTIME=$(uptime -s 2>/dev/null || echo unknown)"
            echo "DISK=$(lsblk -d -n -o SIZE,MODEL 2>/dev/null | grep -v loop | head -1)"
        ' 2>/dev/null)" && ssh_ok="true"

        if [[ "${ssh_ok}" == "true" && -n "${remote}" ]]; then
            os="$(echo "${remote}"    | grep '^OS='    | cut -d= -f2-)"
            ram="$(echo "${remote}"   | grep '^RAM='   | cut -d= -f2-)"
            cores="$(echo "${remote}" | grep '^CORES=' | cut -d= -f2-)"
            docker="$(echo "${remote}"| grep '^DOCKER='| cut -d= -f2-)"
            lan="$(echo "${remote}"    | grep '^LAN='   | cut -d= -f2-)"
            uptime="$(echo "${remote}" | grep '^UPTIME='| cut -d= -f2-)"
            disk="$(echo "${remote}"   | grep '^DISK='  | cut -d= -f2-)"
        fi
    fi

    NAME="${name}" IP="${ip}" REACH="${reachable}" SSH_OK="${ssh_ok}" \
    OS="${os}" RAM="${ram}" CORES="${cores}" DOCKER="${docker}" \
    LAN="${lan}" UPTIME="${uptime}" DISK="${disk}" python3 -c "
import json, os
print(json.dumps({
    'name': os.environ['NAME'],
    'tailscale_ip': os.environ['IP'],
    'reachable': os.environ['REACH'] == 'true',
    'ssh': os.environ['SSH_OK'] == 'true',
    'os': os.environ.get('OS',''),
    'ram': os.environ.get('RAM',''),
    'cores': os.environ.get('CORES',''),
    'docker': os.environ.get('DOCKER',''),
    'lan_ip': os.environ.get('LAN',''),
    'uptime': os.environ.get('UPTIME',''),
    'disk': os.environ.get('DISK',''),
}))
"
}

# Local control-plane probe (um690)
probe_local() {
    source /etc/os-release
    NAME=um690 IP="$(tailscale ip -4 2>/dev/null || echo unknown)" \
    OS="${PRETTY_NAME}" RAM="$(free -h | awk '/^Mem:/{print $2}')" \
    CORES="$(nproc)" DOCKER="$(systemctl is-active docker 2>/dev/null || echo inactive)" \
    LAN="$(ip -4 -br addr show eno1 2>/dev/null | awk '{print $3}' | cut -d/ -f1)" \
    python3 -c "
import json, os
print(json.dumps({
    'name': 'um690',
    'role': 'control-plane',
    'tailscale_ip': os.environ['IP'],
    'reachable': True,
    'ssh': True,
    'os': os.environ['OS'],
    'ram': os.environ['RAM'],
    'cores': os.environ['CORES'],
    'docker': os.environ['DOCKER'],
    'lan_ip': os.environ.get('LAN',''),
    'storage': '1.9TB NVMe + 1.9TB btrfs',
    'services': ['microk8s', 'lxd', 'tailscale'],
}))
"
}

log "Scanning LFCS cluster..."

# Tailnet peers from tailscale
TS_PEERS="$(tailscale status --json 2>/dev/null | python3 -c "
import json,sys
d=json.load(sys.stdin)
self_ip=d.get('Self',{}).get('TailscaleIPs',[''])[0]
peers=[]
for v in d.get('Peer',{}).values():
    peers.append({
        'name': v.get('HostName','?'),
        'ip': v.get('TailscaleIPs',[''])[0],
        'online': v.get('Online',False),
        'os': v.get('OS','?'),
        'last_seen': v.get('LastSeen',''),
    })
print(json.dumps({'self': self_ip, 'peers': peers}))
" 2>/dev/null || echo '{"self":"","peers":[]}')"

LOCAL_JSON="$(probe_local)"
NODE1_JSON="$(probe_host node1 100.75.124.36)"
NODE2_JSON="$(probe_host node2 100.104.54.20)"
NODE3_JSON="$(probe_host node3 100.82.177.52)"

# Write JSON inventory (use env vars — avoid bash expanding ${n} in heredoc)
export SCAN_TS LOCAL_JSON NODE1_JSON NODE2_JSON NODE3_JSON TS_PEERS INV_JSON
python3 - <<'PY'
import json, datetime, os

scan_ts = os.environ["SCAN_TS"]
local = json.loads(os.environ["LOCAL_JSON"])
nodes = [json.loads(os.environ[k]) for k in ("NODE1_JSON", "NODE2_JSON", "NODE3_JSON")]
ts = json.loads(os.environ["TS_PEERS"])
inv_json = os.environ["INV_JSON"]

# LFCS role assignments (based on live capabilities)
roles = {
    "um690":  {"lfcs_role": "control-plane", "projects": ["00","02","08","scheduling"]},
    "node1":  {"lfcs_role": "primary-worker", "projects": ["01","04","06","09-prep"]},
    "node2":  {"lfcs_role": "edge-gateway",   "projects": ["06","07"]},
    "node3":  {"lfcs_role": "storage-forge",  "projects": ["03","05","09"]},
}

for n in [local] + nodes:
    r = roles.get(n["name"], {})
    n["lfcs_role"] = r.get("lfcs_role", "unassigned")
    n["assigned_projects"] = r.get("projects", [])

inventory = {
    "scan_timestamp": scan_ts,
    "control_plane": "um690",
    "admin_clients": ["j-tab (Termius tablet)", "j-phn (phone)"],
    "tailnet": ts,
    "lfcs_cluster": [local] + nodes,
    "nas": {"path": "/mnt/XstorA", "symlink": "/home/kraken/XDrive", "note": "Mount when available for Project 05 backups"},
    "lan_subnet": "192.168.68.0/22",
    "node_lan_ips": {"node1": "192.168.68.101", "node2": "192.168.68.102", "node3": "192.168.68.103", "um690": "192.168.68.100"},
}

with open(inv_json, "w") as f:
    json.dump(inventory, f, indent=2)
print(f"Wrote {inv_json}")
PY

# Write human-readable inventory
cat > "${INV_MD}" <<HEADER
# LFCS Cluster Inventory

**Last scan:** ${SCAN_TS}
**Control plane:** um690 (\`$(tailscale ip -4 2>/dev/null || echo n/a)\`)
**Admin access:** Termius on j-tab (Joshua's Tab S10 Ultra)

> Auto-regenerated by \`automation/lfcs-cluster-scan.sh\`. Re-run before each study week.

---

## Cluster Summary

| Host | Tailscale IP | LAN IP | OS | RAM | Cores | Docker | LFCS Role |
|------|-------------|--------|----|-----|-------|--------|-----------|
HEADER

INV_JSON="${INV_JSON}" python3 - <<'PY' >> "${INV_MD}"
import json, os
with open(os.environ["INV_JSON"]) as f:
    inv = json.load(f)
for h in inv["lfcs_cluster"]:
    print(f"| {h['name']} | {h['tailscale_ip']} | {h.get('lan_ip','—')} | {h.get('os','?')} | {h.get('ram','?')} | {h.get('cores','?')} | {h.get('docker','?')} | **{h.get('lfcs_role','?')}** |")
PY

cat >> "${INV_MD}" <<'FOOTER'

---

## Full Tailnet (all peers)

| Host | Tailscale IP | Status | OS | LFCS Use |
|------|-------------|--------|----|----------|
FOOTER

INV_JSON="${INV_JSON}" python3 - <<'PY' >> "${INV_MD}"
import json, os
with open(os.environ["INV_JSON"]) as f:
    inv = json.load(f)
lfcs_hosts = {"um690","node1","node2","node3","j-tab","j-phn"}
uses = {
    "node1":"Primary worker — docker, systemd, SSH labs",
    "node2":"Edge gateway — firewall, NAT, bonding (7GB RAM)",
    "node3":"Storage + capstone forge host",
    "j-tab":"Termius tablet — your exam-style admin console",
    "j-phn":"Phone — emergency SSH",
    "hickles":"Spare Linux (SSH key needed)",
    "a-lap":"Offline laptop",
    "n-dsk":"Offline Windows desktop",
}
for p in inv["tailnet"]["peers"]:
    name = p["name"]
    status = "online" if p["online"] else "offline"
    use = uses.get(name, "—")
    if name in lfcs_hosts or p["online"]:
        print(f"| {name} | {p['ip']} | {status} | {p['os']} | {use} |")
PY

cat >> "${INV_MD}" <<'FOOTER2'

---

## Project → Node Assignments

| Project | Title | Assigned Node | Why |
|---------|-------|---------------|-----|
| 00 | Documentation Matrix | um690 | man/info lookup from control plane |
| 01 | Directory Sandbox | node1 | Clean worker, docker available |
| 02 | Log Analysis | um690 or node1 | Auth logs on any node |
| 03 | Permissions & Identity | node3 | Isolated user/group lab |
| 04 | systemd & Services | node1 | Service lifecycle practice |
| 05 | Storage Provisioning | node3 | Secondary disk / NAS mount |
| 06 | Networking & SSH | node2 | Edge networking focus |
| 07 | Firewall & NAT | node2 | Gateway simulation |
| 08 | Automation & cron | um690 | Script authoring + scheduling HQ |
| 09 | Secure Browser Forge | node3 | Capstone — deploy via automation |

---

## Network Topology

```
[Starlink/Deco 192.168.68.0/22]
        |
   [um690 .100] ─── control plane, docs, cron, LFCS repo
        |
   +----+----+----+
   |    |    |    |
node1  node2 node3  (M93p Tiny fleet .101-.103)
.101   .102  .103
   \    |    /
    [tailscale0 mesh 100.x.x.x]
         |
    [j-tab Termius]  [j-phn]
```

---

## Important Notes (live scan findings)

- **OS:** Nodes run **Ubuntu** (24.04/26.04), not Rocky. LFCS exam skills transfer; use `apt` instead of `dnf`, `ufw` or manual nftables where guides say firewalld.
- **node1** has Docker **active** — best target for container labs until node3 is provisioned.
- **node2** has 7 GB RAM — assign lightweight edge/firewall labs only.
- **br-lfcs** bridge exists on um690 (192.168.100.0/24) for isolated lab networking when brought up.
- **XstorA** NAS: symlink at `/home/kraken/XDrive` — mount before Project 05 NAS exercises.

FOOTER2

log "Inventory written:"
log "  JSON: ${INV_JSON}"
log "  Markdown: ${INV_MD}"