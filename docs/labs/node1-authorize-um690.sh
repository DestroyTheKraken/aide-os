#!/bin/bash
# Run ON node1 as edu (local terminal)
set -e
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
grep -qxF 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILwFNCb0XCfOivn+Z/C64YF0vSNH7cDu8HnZQa63azwx grokaide-edu@um690' "$HOME/.ssh/authorized_keys" 2>/dev/null || echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILwFNCb0XCfOivn+Z/C64YF0vSNH7cDu8HnZQa63azwx grokaide-edu@um690' >> "$HOME/.ssh/authorized_keys"
chmod 600 "$HOME/.ssh/authorized_keys"
echo "authorized_keys updated. From um690: ssh node1"
