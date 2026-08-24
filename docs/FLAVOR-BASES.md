# Ubuntu flavor bases for AIDE_OS / GrokAide

**Principle:** Build GrokAide on **established Ubuntu flavors**. Do not ship a forked desktop as the OS.

| Flavor | Product seat | Typical host |
|--------|--------------|--------------|
| **Ubuntu Studio** (Plasma) | Platform / Work GrokAide (creative + ops) | **um690** (this machine) |
| **Edubuntu** | Education desktop GrokAide | Multipass desktop track, VBox, or reimaged lab node |
| **Ubuntu Server** | LFCS CLI client (fast rebuild) | **Multipass `grokaide-edu`**, node1/node2 CLI |
| **Ubuntu Desktop** (GNOME) | Optional Work / field | Only if needed |
| **Ubuntu Core** | HickMedia / appliances only | **Not** AIDE education core |

## Layering

```text
Official Ubuntu flavor (session + packages + updates)
    └── AIDE layer: ~/AIDE_OS labs, vault, aidectl, launchers, games links
```

## ISO sources (platform USB)

- PNY / Ventoy: official desktop and server ISOs under `ISO/`  
- Multipass: `multipass find` cloud images (e.g. `26.04` / `24.04`)

## Related

- [EDUCATION-CLIENTS.md](./EDUCATION-CLIENTS.md)  
- [PRODUCT-SCOPE-AND-EDBUNTU.md](./PRODUCT-SCOPE-AND-EDBUNTU.md)  
