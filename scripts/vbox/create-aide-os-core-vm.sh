#!/usr/bin/env bash
# Create VirtualBox VM "AIDE_OS" from Ubuntu Core pre-built image.
# Default: Core 26 under ~/AIDE_OS/dist/ubuntu-core/
# Usage: bash ~/AIDE_OS/scripts/vbox/create-aide-os-core-vm.sh [--start] [--memory 4096] [--cpus 2]
set -euo pipefail

VM_NAME="${VM_NAME:-AIDE_OS}"
MEM_MB="${MEM_MB:-4096}"
CPUS="${CPUS:-2}"
DISK_GB="${DISK_GB:-20}"
DIST="${DIST:-$HOME/AIDE_OS/dist/ubuntu-core}"
IMG="${IMG:-}"
START=0

for a in "$@"; do
  case "$a" in
    --start) START=1 ;;
    --memory) shift; MEM_MB="${1:-$MEM_MB}" ;;
    --cpus) shift; CPUS="${1:-$CPUS}" ;;
    --help|-h)
      echo "Usage: $0 [--start]  # env: MEM_MB CPUS DISK_GB IMG DIST VM_NAME"
      exit 0
      ;;
  esac
done

if [[ -z "$IMG" ]]; then
  if [[ -f "$DIST/ubuntu-core-26-amd64.img" ]]; then
    IMG="$DIST/ubuntu-core-26-amd64.img"
  elif [[ -f "$DIST/ubuntu-core-24-amd64.img" ]]; then
    IMG="$DIST/ubuntu-core-24-amd64.img"
  else
    echo "No Core .img under $DIST — download first (see docs/ops/AIDE-OS-CORE-VM.md)" >&2
    exit 1
  fi
fi

# Host headroom soft check
AVAIL_KB=$(awk '/MemAvailable:/ {print $2}' /proc/meminfo)
if (( AVAIL_KB < MEM_MB * 1024 + 12 * 1024 * 1024 )); then
  echo "WARN: MemAvailable low for ${MEM_MB}MB guest + host/k3s — continuing anyway" >&2
fi

BASE="$HOME/VirtualBox VMs"
VMDIR="$BASE/$VM_NAME"
VDI="$VMDIR/AIDE_OS-core.vdi"

if VBoxManage showvminfo "$VM_NAME" &>/dev/null; then
  echo "VM already exists: $VM_NAME"
  VBoxManage showvminfo "$VM_NAME" | head -20
  if [[ "$START" -eq 1 ]]; then
    state=$(VBoxManage showvminfo "$VM_NAME" --machinereadable | sed -n 's/^VMState="\(.*\)"/\1/p')
    [[ "$state" == "running" ]] || VBoxManage startvm "$VM_NAME" --type gui
  fi
  exit 0
fi

mkdir -p "$VMDIR"
if [[ ! -f "$VDI" ]]; then
  echo "convertfromraw: $IMG → $VDI"
  VBoxManage convertfromraw "$IMG" "$VDI" --format VDI
  VBoxManage modifymedium disk "$VDI" --resize $((DISK_GB * 1024))
fi

VBoxManage createvm --name "$VM_NAME" --ostype "Ubuntu_64" --register --basefolder "$BASE"
VBoxManage modifyvm "$VM_NAME" \
  --memory "$MEM_MB" \
  --cpus "$CPUS" \
  --firmware efi \
  --vram 32 \
  --graphicscontroller vmsvga \
  --nic1 nat \
  --audio-enabled off \
  --clipboard-mode bidirectional \
  --boot1 disk --boot2 none --boot3 none --boot4 none \
  --rtcuseutc on \
  --description "AIDE_OS Ubuntu Core lab (Destroy The Kraken). Source: $IMG"

VBoxManage storagectl "$VM_NAME" --name "SATA" --add sata --controller IntelAhci --portcount 2 --bootable on
VBoxManage storageattach "$VM_NAME" \
  --storagectl "SATA" --port 0 --device 0 --type hdd --medium "$VDI"

echo "Created $VM_NAME (EFI, ${MEM_MB}MB, ${CPUS} CPU, NAT)"
if [[ "$START" -eq 1 ]]; then
  VBoxManage startvm "$VM_NAME" --type gui
fi
echo "Success criteria: console-conf → 'Press enter to configure' (first boot install may reboot once)."
echo "Normal GRUB noise: 'no such device: ubuntu-boot' / EndEntire — ignore per Canonical PC path."
