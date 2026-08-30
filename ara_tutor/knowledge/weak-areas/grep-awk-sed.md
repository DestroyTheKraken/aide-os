# grep, awk & sed — Weak-Area Drill

**LFCS domains:** Essential Commands (text processing), Operations (log analysis)  
**AIOS schedule:** Days 5–6 (Project 02) · `weak_area: grep-awk-sed`  
**Lab nodes:** Day 5 → `node1` · Day 6 → `um690`  
**Study guide:** `Study_Projects/02.md` — Log Analytics & Report Engine

This reference supports hands-on log forensics: filter auth logs, extract fields, transform text, summarize threats, and archive evidence. Commands assume **Ubuntu** (`/var/log/auth.log`). On RHEL/CentOS use `/var/log/secure` instead.

---

## Day 5 checklist (phases 1–2)

1. Locate auth log and stage a working copy
2. `grep` failed SSH / sudo attempts
3. Extract IPv4 addresses with `grep -oE` or `awk`
4. Build `/tmp/threat_actors.txt` (unique IPs + counts)

## Day 6 checklist (phases 3–4)

1. `awk` / `cut` — username + IP columns for report
2. `sed` — normalize or mask strings in report
3. Tab-delimited summary report
4. `tar -czvf` evidence archive + `tar -tzf` verify without extracting

---

## Log paths and permissions

| Distro | Auth log | Read as |
|--------|----------|---------|
| Ubuntu / Debian | `/var/log/auth.log` | `sudo` or `adm` group |
| RHEL / Rocky / Alma | `/var/log/secure` | `sudo` |

```bash
# Staging dir (do not edit originals)
sudo mkdir -p /var/lfcs-staging/project02
sudo cp /var/log/auth.log /var/lfcs-staging/project02/raw-auth.log
sudo chmod 640 /var/lfcs-staging/project02/raw-auth.log
```

**Sample lines** (pattern you will grep):

```
2026-06-15T06:25:01 hostname sshd[18432]: Failed password for invalid user admin from 203.0.113.44 port 51422 ssh2
2026-06-15T06:25:03 hostname sshd[18432]: Failed password for root from 203.0.113.44 port 51422 ssh2
2026-06-15T06:26:11 hostname sudo:     kraken : command not allowed ; TTY=pts/0 ; PWD=/home/kraken ; USER=root ; COMMAND=/usr/bin/passwd root
2026-06-15T06:30:00 hostname sshd[19001]: Accepted password for kraken from <tailscale-client> port 44102 ssh2
```

---

## grep — filter lines

### Essential flags (LFCS)

| Flag | Meaning | Example |
|------|---------|---------|
| `-i` | Case insensitive | `grep -i failed` |
| `-v` | Invert match (exclude) | `grep -v 'Accepted password'` |
| `-E` | Extended regex (egrep) | `grep -E 'Failed\|Invalid'` |
| `-c` | Count matches | `grep -c 'Failed password' auth.log` |
| `-n` | Line numbers | `grep -n 'Failed' auth.log` |
| `-o` | Only matching part | `grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+'` |
| `-A` / `-B` / `-C` | Context lines | `grep -A2 'Failed password'` |
| `-r` | Recursive | `grep -r 'error' /var/log/` |
| `-w` | Whole word | `grep -w root auth.log` |

### Day 5 — failed logins

```bash
LOG=/var/lfcs-staging/project02/raw-auth.log

# Failed SSH passwords
sudo grep 'Failed password' "$LOG" | tee /var/lfcs-staging/project02/failed-ssh.log

# Failed + invalid user (extended regex)
sudo grep -E 'Failed password|Invalid user' "$LOG"

# Unauthorized sudo (adjust pattern to your sudo log format)
sudo grep 'command not allowed' "$LOG"

# Exclude successful logins — isolate anomalies only
sudo grep -v 'Accepted password' "$LOG" | grep -E 'Failed|Invalid|not allowed'
```

### Extract IPv4 only (grep -oE)

```bash
sudo grep 'Failed password' "$LOG" \
  | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' \
  | sort | uniq -c | sort -rn \
  | tee /tmp/threat_actors.txt
```

Output shape:

```
      4 203.0.113.44
      1 198.51.100.7
```

### Date-range filtering (phase 1)

Auth logs often use `Jun 15` or ISO timestamps. Match what your file uses:

```bash
# Traditional syslog month-day
sudo grep 'Jun 15' "$LOG" > /var/lfcs-staging/project02/jun15.log

# ISO prefix
sudo grep '^2026-06-15' "$LOG" > /var/lfcs-staging/project02/2026-06-15.log
```

### Append streams without overwrite (phase 1)

```bash
# >> appends; > overwrites
sudo grep 'sshd' /var/log/auth.log >> /var/lfcs-staging/project02/consolidated.log
sudo grep 'sudo'  /var/log/auth.log >> /var/lfcs-staging/project02/consolidated.log
```

---

## awk — fields and reports

`awk` splits each line on whitespace (default FS). Auth log field positions vary — **always print `$0` and `$NF` first** on a sample line before assuming column numbers.

### Print user and source IP from Failed password lines

Common Ubuntu `sshd` pattern: user appears after `for`, IP after `from`:

```bash
sudo awk '/Failed password/ {
  for (i=1; i<=NF; i++) {
    if ($i == "for") user = $(i+1)
    if ($i == "from") ip = $(i+1)
  }
  print user, ip
}' "$LOG" | sort | uniq -c | sort -rn
```

### Tab-delimited report (phase 4)

```bash
REPORT=/var/lfcs-staging/project02/threat-summary.tsv
{
  echo -e "count\tuser\tip"
  sudo awk '/Failed password/ {
    user=""; ip=""
    for (i=1; i<=NF; i++) {
      if ($i=="for") user=$(i+1)
      if ($i=="from") ip=$(i+1)
    }
    if (user != "" && ip != "") print user "\t" ip
  }' "$LOG" | sort | uniq -c | awk '{print $1 "\t" $2 "\t" $3}' | sort -t$'\t' -k1 -rn
} | sudo tee "$REPORT"
```

### Useful awk patterns

```bash
# Print column 1 and 11
awk '{print $1, $11}' file

# Lines matching pattern
awk '/Failed password/ {print}' file

# Count per first field
awk '{c[$1]++} END {for (k in c) print c[k], k}' file

# Custom delimiter
awk -F: '{print $1, $3}' /etc/passwd
```

---

## cut — fixed columns (when fields are stable)

```bash
# Characters 1-15 (timestamp slice — verify width on your log)
cut -c1-15 "$LOG" | head

# Delimiter-based (careful: messages contain spaces)
echo "user:203.0.113.44:22" | cut -d: -f1,2
```

Prefer `awk` when fields are not fixed-width.

---

## sed — stream editing

`sed` edits line-by-line. Use for normalization and masking in reports — **not** on live `/var/log/*` originals.

### Common forms

| Form | Action |
|------|--------|
| `sed 's/old/new/'` | Replace first match per line |
| `sed 's/old/new/g'` | Replace all on line |
| `sed -n '5p'` | Print line 5 only |
| `sed -n '/pattern/p'` | Print matching lines (like grep) |
| `sed '/pattern/d'` | Delete matching lines |
| `sed -i.bak 's/x/y/' file` | In-place with backup |

### Phase 3 examples

```bash
# Lowercase service name in report copy
sed 's/SSHD/sshd/g' /var/lfcs-staging/project02/failed-ssh.log

# Mask username (replace literal admin with REDACTED)
sed 's/invalid user admin/invalid user REDACTED/g' /var/lfcs-staging/project02/failed-ssh.log

# Delete successful login lines from working copy
sed '/Accepted password/d' /var/lfcs-staging/project02/consolidated.log \
  > /var/lfcs-staging/project02/no-success.log
```

**Exam tip:** `sed -i` without extension overwrites in place. LFCS persistence tasks often expect backup suffix (`-i.bak`) or edit a staged copy.

---

## End-to-end pipeline (Day 5 → Day 6)

```bash
STAGE=/var/lfcs-staging/project02
LOG=$STAGE/raw-auth.log
sudo mkdir -p "$STAGE"

sudo cp /var/log/auth.log "$LOG"

# 1. Filter failures
sudo grep -E 'Failed password|command not allowed' "$LOG" > "$STAGE/failures.log"

# 2. Threat actor counts
sudo grep 'Failed password' "$LOG" \
  | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' \
  | sort | uniq -c | sort -rn > /tmp/threat_actors.txt

# 3. TSV report
sudo awk '/Failed password/ {
  for (i=1;i<=NF;i++) { if ($i=="for") u=$(i+1); if ($i=="from") p=$(i+1) }
  if (u && p) print u "\t" p
}' "$LOG" | sort | uniq -c | awk '{print $1"\t"$2"\t"$3}' \
  | sed '1i count\tuser\tip' | sudo tee "$STAGE/threat-summary.tsv"

# 4. Archive (Day 6)
sudo tar -czvf /backup/incident-$(date +%F).tar.gz \
  -C "$STAGE" failures.log threat-summary.tsv /tmp/threat_actors.txt

# 5. Verify without extracting
tar -tzf /backup/incident-$(date +%F).tar.gz
```

Adjust `/backup` path — create with `sudo mkdir -p /backup` if needed.

---

## tar — archive and verify (Day 6)

| Task | Command |
|------|---------|
| Create gzip archive | `tar -czvf archive.tar.gz file1 dir/` |
| List contents | `tar -tzf archive.tar.gz` |
| Extract | `tar -xzvf archive.tar.gz` |
| Extract to path | `tar -xzvf archive.tar.gz -C /target/dir` |

**Flags:** `-c` create · `-x` extract · `-z` gzip · `-v` verbose · `-f` file · `-t` list

```bash
# LFCS evidence bundle
sudo tar -czvf /backup/incident.tar.gz \
  /var/lfcs-staging/project02/failures.log \
  /var/lfcs-staging/project02/threat-summary.tsv \
  /tmp/threat_actors.txt

tar -tzf /backup/incident.tar.gz   # verify integrity
```

---

## Regex quick reference (LFCS)

| Pattern | Matches |
|---------|---------|
| `.` | Any single character |
| `*` | Zero or more of previous |
| `^` / `$` | Start / end of line |
| `[0-9]` | Digit |
| `[a-zA-Z]` | Letter |
| `\+` / `\|` | One or more / alternation (use `grep -E`) |
| `([0-9]{1,3}\.){3}[0-9]{1,3}` | IPv4 (simplified) |

```bash
grep -E '^[0-9]{4}-[0-9]{2}-[0-9]{2}' file    # ISO date lines
grep -oE 'port [0-9]+' file                   # capture port numbers
```

---

## Verification commands (self-check)

```bash
# Count failed attempts
grep -c 'Failed password' /var/lfcs-staging/project02/raw-auth.log

# Top attacker IP
awk '/Failed password/ {for(i=1;i<=NF;i++) if($i=="from") print $(i+1)}' \
  /var/lfcs-staging/project02/raw-auth.log | sort | uniq -c | sort -rn | head -1

# Archive lists expected files
tar -tzf /backup/incident.tar.gz | wc -l

# No accidental edit of original
diff -q /var/log/auth.log /var/lfcs-staging/project02/raw-auth.log && echo "staging copy OK"
```

---

## Common mistakes (exam + lab)

1. **Editing live logs** — always stage under `/var/lfcs-staging/` or `$HOME/lab/`.
2. **`grep` without sudo** — empty output on `/var/log/auth.log` is often permissions, not “no attacks”.
3. **Wrong log file** — `secure` vs `auth.log` by distro.
4. **`>` vs `>>`** — overwrite vs append when consolidating streams.
5. **Assuming awk field numbers** — `sshd` and `sudo` lines have different shapes; match on text first.
6. **`sed -i` on production paths** — edit copies; keep audit trail.
7. **Forgetting `sort | uniq -c`** — exam tasks often want **counts**, not raw lines.
8. **`tar` path semantics** — archive from `-C` staging dir to avoid absolute-path surprises on extract.

---

## man pages to know

```bash
man grep
man awk        # or man gawk on some systems
man sed
man cut
man sort
man uniq
man tar
man regex    # if available; else man 7 regex
```

---

## Ara tutoring prompts (examples)

- "Walk me through Day 5 Project 02 on node1 step by step."
- "Why is my `grep Failed password` returning nothing?"
- "Show awk to extract user and IP without hardcoding field numbers."
- "Difference between `grep -oE` and awk for IPv4 extraction?"
- "Write the tar command to bundle my staging dir and verify without extracting."

**Related:** `Study_Projects/02.md` · Days 5–6 in `schedule/daily-schedule.json` · `guides/OBJECTIVES_TRACKER.md` § Text Manipulation