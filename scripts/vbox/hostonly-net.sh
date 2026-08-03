#!/usr/bin/env bash
# Idempotent VirtualBox host-only network for aide-lab (K6).
# Creates vboxnet0 @ 192.168.56.1/24 + DHCP 192.168.56.100–200 if missing.
set -euo pipefail

IFNAME="${HOSTONLY_IF:-vboxnet0}"
HOST_IP="${HOSTONLY_IP:-192.168.56.1}"
NETMASK="${HOSTONLY_NETMASK:-255.255.255.0}"
DHCP_IP="${HOSTONLY_DHCP_IP:-192.168.56.2}"
DHCP_LO="${HOSTONLY_DHCP_LO:-192.168.56.100}"
DHCP_HI="${HOSTONLY_DHCP_HI:-192.168.56.200}"

log() { printf 'hostonly-net: %s\n' "$*"; }

# Resolve actual interface name (VirtualBox may number vboxnetN)
find_if() {
  VBoxManage list hostonlyifs 2>/dev/null | awk -v want="$IFNAME" '
    /^Name:/ { n=$2 }
    /^IPAddress:/ { ip=$2 }
    n==want { found=1 }
    END { if (found) print want }
  '
}

create_if() {
  if find_if | grep -q .; then
    log "$IFNAME already exists"
    return 0
  fi
  # If empty host-only list, create
  if ! VBoxManage list hostonlyifs 2>/dev/null | grep -q '^Name:'; then
    log "creating host-only interface"
    out=$(VBoxManage hostonlyif create 2>&1) || true
    log "$out"
  fi
  # Prefer name vboxnet0; if only other names, use first
  local name
  name=$(VBoxManage list hostonlyifs 2>/dev/null | awk '/^Name:/{print $2; exit}')
  if [[ -z "$name" ]]; then
    echo "hostonly-net: failed to create host-only interface" >&2
    exit 1
  fi
  IFNAME="$name"
  log "using interface $IFNAME"
}

configure_ip() {
  log "ipconfig $IFNAME → $HOST_IP $NETMASK"
  VBoxManage hostonlyif ipconfig "$IFNAME" --ip "$HOST_IP" --netmask "$NETMASK" || {
    # Some VBox versions need the if brought up first
    sleep 1
    VBoxManage hostonlyif ipconfig "$IFNAME" --ip "$HOST_IP" --netmask "$NETMASK"
  }
}

configure_dhcp() {
  # Remove/re-add is fragile; try modify then add
  if VBoxManage list dhcpservers 2>/dev/null | grep -q "$IFNAME"; then
    log "DHCP already registered for $IFNAME — modifying"
    VBoxManage dhcpserver modify \
      --ifname "$IFNAME" \
      --ip "$DHCP_IP" \
      --netmask "$NETMASK" \
      --lowerip "$DHCP_LO" \
      --upperip "$DHCP_HI" \
      --enable 2>/dev/null \
      || VBoxManage dhcpserver modify \
        --network="HostInterfaceNetworking-$IFNAME" \
        --ip "$DHCP_IP" --netmask "$NETMASK" \
        --lowerip "$DHCP_LO" --upperip "$DHCP_HI" --enable 2>/dev/null \
      || log "WARN: DHCP modify skipped (manual OK)"
  else
    log "adding DHCP on $IFNAME ($DHCP_LO–$DHCP_HI)"
    VBoxManage dhcpserver add \
      --ifname "$IFNAME" \
      --ip "$DHCP_IP" \
      --netmask "$NETMASK" \
      --lowerip "$DHCP_LO" \
      --upperip "$DHCP_HI" \
      --enable 2>/dev/null \
      || VBoxManage dhcpserver add \
        --network="HostInterfaceNetworking-$IFNAME" \
        --ip "$DHCP_IP" --netmask "$NETMASK" \
        --lowerip "$DHCP_LO" --upperip "$DHCP_HI" --enable 2>/dev/null \
      || log "WARN: DHCP add skipped (guest can use static 192.168.56.100)"
  fi
}

create_if
# Re-resolve after create
IFNAME=$(VBoxManage list hostonlyifs 2>/dev/null | awk '/^Name:/{print $2; exit}')
[[ -n "$IFNAME" ]] || { echo "no host-only if" >&2; exit 1; }
configure_ip
configure_dhcp

log "done — host $HOST_IP on $IFNAME (guest sim LabNET .100 → often $DHCP_LO)"
VBoxManage list hostonlyifs | head -20
exit 0
