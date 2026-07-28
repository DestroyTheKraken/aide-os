---
tags: [lfcs, lab]
status: draft
host: um690
risk: read-only
---

# Lab 04 — Network inspect

> [!todo] Next
> - [ ] Capture `ip -br addr` and default route in debrief

```bash
ip -br addr
ip route
resolvectl status 2>/dev/null | head -40 || cat /etc/resolv.conf
ss -tlnp 2>/dev/null | head -20 || netstat -tlnp 2>/dev/null | head -20
```

## Debrief

1. 
2. 
3. 

---

#lfcs
