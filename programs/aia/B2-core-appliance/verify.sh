#!/usr/bin/env bash
# verify B2 Core appliance module
set -euo pipefail
ok=0
fail=0
check() {
  if eval "$2" &>/dev/null; then
    echo "OK  $1"; ok=$((ok+1))
  else
    echo "FAIL $1"; fail=$((fail+1))
  fi
}
check "Core img present" "test -f \$HOME/AIDE_OS/dist/ubuntu-core/ubuntu-core-26-amd64.img"
check "VBoxManage available" "command -v VBoxManage"
check "VM AIDE_OS registered" "VBoxManage showvminfo AIDE_OS"
check "Snapshot post-console-conf" "VBoxManage snapshot AIDE_OS list | grep -q post-console-conf"
check "Ops doc present" "test -f \$HOME/AIDE_OS/docs/ops/AIDE-OS-CORE-VM.md"
check "create script present" "test -x \$HOME/AIDE_OS/scripts/vbox/create-aide-os-core-vm.sh"
echo "---"
echo "passed=$ok failed=$fail"
[[ "$fail" -eq 0 ]]
