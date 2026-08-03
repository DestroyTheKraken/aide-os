# Essential Commands — LFCS Reference

**LFCS weight:** ~20% · **Projects:** 00, 01, 02  
**AIOS nodes:** um690 (docs), node1 (dirs + logs)  
**Tracker:** `guides/OBJECTIVES_TRACKER.md` §§ 1–2

Baseline interaction: navigate the filesystem, manage files, find documentation, process text streams. Ubuntu examples; exam may use RHEL patterns (`dnf`, `/var/log/secure`).

---

## Documentation discovery (Project 00)

| Task | Command |
|------|---------|
| Rebuild man db | `sudo mandb` |
| Keyword search | `man -k partition` · `man -k cron` |
| Full-text man search | `man -K ACL` |
| Specific section | `man 5 fstab` · `man 1 tar` |
| Info docs | `info coreutils` |
| Package docs | `ls /usr/share/doc/*/README*` |
| Compressed readme | `zless /usr/share/doc/package/README.gz` |
| Quick help | `whatis chmod` · `chmod --help` |
| tldr (if installed) | `tldr tar` |

**Section numbers:** 1=user commands · 5=config files · 8=admin

```bash
man 5 fstab          # /etc/fstab layout
man bash | grep -A20 EXAMPLES
apropos firewall
```

---

## Shell environment & navigation

```bash
whoami; id; pwd; echo $SHELL
cd ~                    # home
cd /absolute/path
cd ../parent
ls -la                  # include hidden
ls -lh                  # human sizes
tree -L 2 ~/lab         # if tree installed
```

| Symbol | Meaning |
|--------|---------|
| `.` | Current directory |
| `..` | Parent |
| `~` | Home |
| `-` | Previous directory |

---

## Files & directories (Project 01)

```bash
# Create tree in one command
mkdir -p ~/lab/projects/archive/2026

# Files
touch ~/lab/projects/report.txt
cp source dest
cp -r dir1 dir2          # recursive
mv old new
rm file
rm -rf directory         # destructive — verify path first

# Find
find ~/lab -type f -name '*.log'
find /var/log -mtime -1 -type f
find /etc -name '*.conf' 2>/dev/null
```

### Links

```bash
ln -s /path/to/target ~/shortcut      # symbolic (breaks if target deleted)
ln /path/to/file ~/hardlink           # hard (same inode)
ls -li file hardlink                  # same inode number
readlink -f ~/shortcut
```

---

## Archives & compression (Project 02)

```bash
tar -czvf archive.tar.gz dir/
tar -xzvf archive.tar.gz
tar -tzvf archive.tar.gz              # list
gzip file    # → file.gz
gunzip file.gz
bzip2 file   # → file.bz2
```

| Flag | Meaning |
|------|---------|
| `-c` create | `-x` extract | `-t` list |
| `-z` gzip | `-j` bzip2 | `-v` verbose | `-f` file |

---

## Text processing (see also `weak-areas/grep-awk-sed.md`)

```bash
grep pattern file
grep -r pattern /etc/nginx/
grep -v '^#' /etc/fstab | grep -v '^$'
sed 's/old/new/g' file
awk '{print $1, $3}' file
cut -d: -f1,3 /etc/passwd
sort file | uniq -c | sort -rn
wc -l file
head -20 file; tail -f /var/log/syslog
```

---

## Pipes, redirects, streams

```bash
cmd > file              # stdout overwrite
cmd >> file             # stdout append
cmd 2> errors.log       # stderr
cmd &> all.log          # both
cmd | other
tee file                # stdout + file
cmd1 | cmd2 | cmd3
```

---

## Services (quick reference — detail in operations-deployment.md)

```bash
systemctl status ssh
systemctl start|stop|restart|reload ssh
systemctl enable --now ssh
journalctl -u ssh -n 50
journalctl -f
```

---

## Package management

**Ubuntu (your cluster):**

```bash
sudo apt update
sudo apt install package
sudo apt remove package
apt search keyword
apt show package
dpkg -l | grep nginx
```

**RHEL/Rocky (exam variant):**

```bash
sudo dnf install package
sudo dnf remove package
rpm -qa | grep httpd
```

---

## Disk usage (quick)

```bash
df -h
du -sh ~/lab/*
lsblk
blkid
```

---

## SSH client (Project 01)

```bash
ssh-keygen -t ed25519 -f ~/.ssh/lfcs_lab
ssh-copy-id -i ~/.ssh/lfcs_lab.pub user@100.75.124.36
ssh -i ~/.ssh/lfcs_lab kraken@node1
scp file user@host:/path
```

AIOS tailnet: `ssh kraken@100.75.124.36` (node1).

---

## Verification drills

```bash
# Project 00 deliverables
man 5 fstab | head -30
man bash | grep -n loop

# Project 01
test -L ~/shortcut && echo "symlink OK"
find ~/lab -type d | wc -l

# Archives
tar -tzf archive.tar.gz | wc -l
```

---

## Common exam traps

1. **`rm -rf /` typo** — always echo path first.
2. **Relative vs absolute** in scripts — use absolute paths in cron.
3. **Wrong log file** — `auth.log` vs `secure`.
4. **Forgetting `sudo`** for system paths.
5. **`man` section** — config file is section 5, not 1.
6. **Hard vs soft link** — directories only as symlinks.

---

## man pages

```bash
man man
man find
man tar
man grep
man ln
man ssh
```

---

## Ara prompts

- "How do I find fstab format with man only?"
- "mkdir -p vs mkdir for nested paths?"
- "When use hard link vs symbolic link?"
- "tar create vs extract flags?"

**Related:** `Study_Projects/00.md`, `01.md`, `02.md` · `weak-areas/grep-awk-sed.md`