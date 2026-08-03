# Users, Groups & Permissions — LFCS Reference

**LFCS weight:** ~10% · **Project:** 03  
**AIOS node:** node3  
**Tracker:** `guides/OBJECTIVES_TRACKER.md` § 3

Accounts, groups, standard permissions, ACLs, sudoers, special bits (SUID/SGID/sticky), file attributes.

---

## User & group management

```bash
# Users
sudo useradd -m -s /bin/bash alice_hr
sudo useradd -m -G dev_dept bob_dev
sudo passwd alice_hr
sudo usermod -aG dev_dept bob_dev      # append group
sudo userdel -r olduser                 # -r removes home

# Groups
sudo groupadd hr_dept
sudo groupadd dev_dept
getent passwd alice_hr
getent group dev_dept
id bob_dev
groups bob_dev
```

| File | Purpose |
|------|---------|
| `/etc/passwd` | user accounts |
| `/etc/shadow` | password hashes |
| `/etc/group` | groups |
| `/etc/gshadow` | group passwords |

---

## Standard permissions

```bash
ls -l file
chmod 640 file                        # rw-r-----
chmod u+x,g-w file
chmod -R 750 directory
chown user:group file
chown -R user:group dir
umask                                 # default new file perms
umask 027
```

| Octal | Meaning |
|-------|---------|
| 7 | rwx |
| 6 | rw- |
| 5 | r-x |
| 4 | r-- |
| 0 | --- |

**Directories:** need `x` to enter (`cd`).

---

## SGID shared directory (Project 03)

Department folder — new files inherit group:

```bash
sudo mkdir -p /srv/dev_shared
sudo chown root:dev_dept /srv/dev_shared
sudo chmod 2770 /srv/dev_shared       # 2 = SGID
# verify: create file as bob → group should be dev_dept
```

---

## Sticky bit — public dropbox

```bash
sudo mkdir -p /srv/dropbox
sudo chmod 1777 /srv/dropbox          # 1 = sticky
# anyone can create; only owner deletes own files
```

---

## SUID awareness

```bash
find /usr/bin -perm -4000 -ls 2>/dev/null | head
# passwd, sudo, etc. — understand security implications
```

Do not casually add SUID to custom scripts.

---

## ACLs (Project 03)

```bash
sudo apt install acl                  # Ubuntu

# Grant auditor read on locked dept folder
sudo setfacl -m u:charlie_audit:r-x /srv/hr_confidential
sudo setfacl -m u:charlie_audit:r-- /srv/hr_confidential/report.pdf

# Default ACL — new children inherit
sudo setfacl -d -m u:charlie_audit:r-x /srv/hr_confidential

# View
getfacl /srv/hr_confidential

# Remove all ACLs
sudo setfacl -b /srv/hr_confidential
```

ACLs override standard perms for listed users/groups without adding them to the owning group.

---

## sudoers (Project 03, 09)

**Always use `visudo`** — syntax errors lock you out.

```bash
sudo visudo
sudo visudo -f /etc/sudoers.d/forgesvc
sudo visudo -c                       # validate all
```

```sudoers
# /etc/sudoers.d/forgesvc
forgesvc ALL=(root) NOPASSWD: /usr/bin/docker compose *
bob_dev ALL=(root) NOPASSWD: /bin/systemctl restart myapp.service
```

Test: `sudo -l -U forgesvc`

**Exam trap:** Never edit `/etc/sudoers` directly without `visudo -c`.

---

## Environment profiles

```bash
# /home/alice_hr/.bashrc
alias ll='ls -la'
export EDITOR=vim

# System-wide
/etc/profile
/etc/bash.bashrc
/etc/skel/                            # template for new users
```

---

## Immutable attributes (Project 03 phase 4)

```bash
sudo chattr +i /etc/sudoers.d/forgesvc
sudo lsattr /etc/sudoers.d/forgesvc
sudo chattr -i /etc/sudoers.d/forgesvc  # remove immutability
```

Even root cannot edit `+i` files until attribute removed.

---

## Project 09 tie-in — `forgesvc`

Capstone service account pattern:

```bash
sudo useradd -r -s /sbin/nologin -M forgesvc
sudo usermod -aG docker forgesvc
# PUID/PGID in compose match forgesvc uid/gid
id forgesvc
```

---

## Verification drills

```bash
id alice_hr
getfacl /srv/hr_confidential
ls -ld /srv/dev_shared                # look for 's' in group (SGID)
ls -ld /srv/dropbox                   # 't' sticky
sudo -l -U bob_dev
sudo visudo -c
```

---

## Common exam traps

1. **`usermod -G` replaces groups** — use `-aG` to append.
2. **ACL without `acl` mount option** — ext4 defaults OK on Ubuntu; xfs may need `acl`.
3. **sudoers typo** — `visudo -c` before closing session.
4. **chmod 777 "fix"** — wrong; use targeted ACL or group perms.
5. **SGID on file vs directory** — SGID on dir affects new file group.

---

## man pages

```bash
man useradd
man chmod
man chown
man setfacl
man sudoers
man chattr
```

---

## Ara prompts

- "Set up SGID shared folder for dev_dept."
- "Grant auditor read-only via ACL without group membership."
- "Safe way to edit sudoers for one command?"
- "What does sticky bit on /tmp do?"

**Related:** `Study_Projects/03.md`, `09.md`