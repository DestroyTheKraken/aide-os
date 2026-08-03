# SSH & Remote Access — LFCS Reference

**LFCS weight:** Networking ~25% · **Projects:** 06, 09  
**AIOS nodes:** node2 (hardening), node3 (capstone), j-tab (Termius client)  
**Tracker:** `guides/OBJECTIVES_TRACKER.md` §§ 1, 6, 9

OpenSSH server/client, key auth, hardening drop-ins, session management. **Exam trap:** lock yourself out — always `sshd -t` before reload.

---

## Client basics

```bash
ssh user@host
ssh -i ~/.ssh/lfcs_lab user@100.75.124.36
ssh -p 2222 user@host                 # custom port

# Config shortcut — ~/.ssh/config
Host node1
  HostName 100.75.124.36
  User kraken
  IdentityFile ~/.ssh/lfcs_lab

ssh node1
```

---

## Key-based authentication

```bash
ssh-keygen -t ed25519 -f ~/.ssh/lfcs_lab -C "lfcs-j-tab"
chmod 600 ~/.ssh/lfcs_lab
chmod 644 ~/.ssh/lfcs_lab.pub

ssh-copy-id -i ~/.ssh/lfcs_lab.pub user@host
# manual:
mkdir -p ~/.ssh && chmod 700 ~/.ssh
cat lfcs_lab.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

---

## Server hardening drop-in (Project 06, 09)

```bash
sudo mkdir -p /etc/ssh/sshd_config.d
sudo nano /etc/ssh/sshd_config.d/99-lfcs.conf
```

```sshd
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
MaxAuthTries 3
AllowUsers kraken forgesvc
# Port 2222                        # optional — update firewall + client
```

**Validate before reload:**

```bash
sudo sshd -t && echo "syntax OK" || echo "FIX BEFORE RELOAD"
sudo systemctl reload sshd
# keep existing session open until verified
```

Test new session from j-tab **before** closing old one.

---

## File transfer

```bash
scp file user@host:/path/
scp -r dir user@host:/path/
rsync -avz -e ssh dir/ user@host:/path/
sftp user@host
```

---

## Monitor & manage sessions

```bash
who
w
last | head
sudo ss -tnp | grep ':22'
sudo journalctl -u ssh -n 50
```

Disconnect stale session: identify TTY from `w`, then `sudo pkill -t pts/1` (careful).

---

## Auth log review (Project 02 tie-in)

```bash
# Ubuntu
sudo grep 'Failed password' /var/log/auth.log | tail
sudo grep 'Accepted' /var/log/auth.log | tail

# RHEL
sudo grep 'Failed password' /var/log/secure | tail
```

---

## Project 09 — capstone SSH requirements

From `Study_Projects/09.md`:

- `PermitRootLogin no`
- Key-only auth
- Drop-in: `/etc/ssh/sshd_config.d/99-lfcs-forge.conf`
- Audit with `sshd -t` + `grep PermitRootLogin /etc/ssh/sshd_config.d/*`

Tablet workflow: Termius on j-tab → SSH to node3 for forge work.

---

## Tailscale SSH (AIOS bonus)

```bash
tailscale ssh kraken@um690
tailscale ping node1
```

LFCS exam uses standard OpenSSH — practice both.

---

## Verification drills

```bash
sudo sshd -t
sshd -T | grep -E 'permitrootlogin|passwordauthentication|pubkeyauthentication'
systemctl is-active ssh
ssh -o BatchMode=yes node1 echo OK    # key auth non-interactive
```

Attempt root login should fail:

```bash
ssh root@node2                         # expect permission denied
```

---

## Common exam traps

1. **Reload without `sshd -t`** — syntax error locks you out.
2. **Disable password before keys work** — keep backup session.
3. **Wrong `AllowUsers` spelling** — blocks all logins.
4. **Changing Port without firewall** — apparent "SSH down".
5. **SELinux context on authorized_keys** — RHEL: `restorecon -R ~/.ssh`.
6. **Editing main `sshd_config` instead of drop-in** — drop-ins are cleaner and exam-friendly.

---

## man pages

```bash
man sshd_config
man ssh
man ssh-keygen
man authorized_keys
```

---

## Ara prompts

- "Harden SSH without locking myself out — step order?"
- "Write 99-lfcs.conf for key-only, no root."
- "How to verify key auth works before disabling passwords?"
- "Where to see failed SSH attempts on Ubuntu?"

**Related:** `Study_Projects/06.md`, `09.md` · `weak-areas/grep-awk-sed.md` · `firewall-nat-forwarding.md`