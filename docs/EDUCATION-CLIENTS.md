# Education clients

**Track:** Linux system administration, aligned with LFCS objectives and Ubuntu practice.

| Role | Where | Notes |
|------|--------|------|
| Author | um690 | Writes lessons, runs `grokAide-start`, hosts Multipass |
| Student UI | um690, `aide-day` | Browser seat for the learner named Student |
| Practice VM | Multipass `grokaide-edu` | Disposable Ubuntu Server for labs |
| Hardware labs | node1–node3 when a lesson says so | Do not fight other lab work on those boxes |

## Multipass

```bash
multipass list
multipass start grokaide-edu
multipass shell grokaide-edu
```

Curriculum on the authoring tree: `Study_Projects/`, `guides/OBJECTIVES_TRACKER.md`. Mount that tree into the VM when you want the files inside the guest.

## What this is not

No nested Kubernetes in the education VM. No HickMedia or RetroArch on the Student seat. No school-district packaging.
