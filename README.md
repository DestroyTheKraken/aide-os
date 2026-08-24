# AIDE_OS

A personal Linux study environment for system administration. The learner in the software is named **Student**. The authoring machine is this lab workstation.

This tree is the current project. It grew out of [SovereignAid](https://github.com/DestroyTheKraken/SovereignAid), which is kept only as history.

It is not a product for sale, not a school district package, and not a game console.

## How to start

On the lab workstation:

```bash
aide-day
```

That opens the Student seat in a browser. First visit shows a short welcome. After **Begin as Student**, you get today’s lesson, the lab text, a timer, and a way to mark the day complete.

Optional practice VM:

```bash
multipass start grokaide-edu
multipass shell grokaide-edu
```

`aide-review` lists leftover folders from earlier experiments. Use it when deciding what still belongs in the product — not when taking a lesson.

More detail: [START.md](./START.md).

## What lives here

| Area | Role |
|------|------|
| Student UI | `aide-day` — `scripts/learning/day-start-app.py` |
| Lessons | `Study_Projects/` and `schedule/` |
| Tutor notes | `ara_tutor/knowledge/` |
| Lab notes | Network picture is in [homelab](https://github.com/DestroyTheKraken/homelab), not in this README |

Related installers: [nc-lin-cs](https://github.com/DestroyTheKraken/nc-lin-cs), [ssh-ufw-ts-install](https://github.com/DestroyTheKraken/ssh-ufw-ts-install).

## Status

Active study tree. The Student seat is the supported front door. Older Docker portal, tablet, and k3s notes are leftovers.

Job search: [joshua.hickman1@gmail.com](mailto:joshua.hickman1@gmail.com)
