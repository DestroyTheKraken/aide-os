# AIDE_OS — notes for agents working in this tree

**Authoring host:** um690 · Ubuntu Studio · user on this seat is the operator  
**Learner in the product:** Student  
**Working directory:** `~/AIDE_OS` (same as `~/Projects/aide-os`)

## What this is

AIDE is a thin learning layer on official Ubuntu (Studio, Server, or Edubuntu). It is not a custom desktop OS, not HickMedia, and not a client-services business.

## How people start

| Who | Command |
|-----|---------|
| Student | `aide-day` |
| Author | `grokAide-start` or `cd ~/AIDE_OS && grok` |
| Product inventory | `aide-review` |

Do not send a learner to Docker, the old portal, or `aide-menu` (that menu is emergency/backup).

## Lab seats

| Seat | Purpose |
|------|---------|
| um690 | Authoring, Student UI, Multipass host |
| grokaide-edu | Disposable Ubuntu Server VM for labs |
| node1–node3 | Lab fleet on the wired LAN — only use when a lesson says so |
| Games | `~/AIDE_OS-games` — mount into the VM, not the desktop |

Destructive work belongs in the VM, not on the authoring desktop.

## Paths that matter

| Path | Role |
|------|------|
| `START.md` | Human start page |
| `Study_Projects/` | Labs 00–09 |
| `schedule/` | 45-day order |
| `product/student.json` | Learner name and welcome flag |
| `scripts/learning/day-start-app.py` | Student UI |
| `guides/OBJECTIVES_TRACKER.md` | Exam checklist |
| [homelab](https://github.com/DestroyTheKraken/homelab) | Public, redacted network notes |

Do not copy addresses, MACs, or Tailscale IPs into new public docs. Older files under `docs/design/` may still have them; treat those as historical.
