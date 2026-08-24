# Linux Skills Evaluation — Joshua Hickman (lab evidence)

| Field | Value |
|-------|--------|
| **Date** | 2026-08-02 |
| **Evaluator** | Lab evidence review (Grok on um690) |
| **Scope** | Observable skills on personal LabNET — **not** a formal cert result |
| **Target roles** | Entry SysAdmin / junior DevOps / edge ops |

**Scale:** Emerging · Working · Solid · Advanced

---

## Summary headline (resume-safe)

> Intermediate self-taught Linux lab operator. Runs a live multi-node Ubuntu/k3s edge lab with Tailscale, durable storage, and written design discipline. LFCS pathway in progress. Not claiming production SRE or multi-tenant cloud seniority.

**Overall:** **Working → Solid** for home-lab / junior ops; **Emerging → Working** for unaided production incident command.

---

## Rubric by domain

| Domain | Level | Evidence | Gap / next step |
|--------|-------|----------|-----------------|
| **Daily Linux use** | Solid | GNOME desktop daily driver; Ghostty; multi-user seats (kraken/joshua/vtech); bash history depth | Keep LFCS timed drills without AI first 60% |
| **Filesystem & storage** | Working–Solid | ext4 root + btrfs NAS map; STORAGE-MAP inventory; dual working/durable trees | Practice LVM/RAID scenarios for LFCS; document restore drills |
| **Networking** | Working–Solid | LabNET static map; Tailscale mesh; VyOS gateway awareness; host-only VBox design | Teach-back: OSI walk, DNS/DHCP failure stories without notes |
| **Containers / k8s** | Working | **Live k3s triad Ready 24d+** (control + 2 workers); CSI mounts present | Deeper: debug CrashLoop, network policies, etcd backup story |
| **Virtualization** | Working | VirtualBox 7.x multi-VM; Multipass present; Core QEMU lessons | Finish golden OVA path; one clean multipass worker demo |
| **Automation** | Working | `aidectl` classic-shim; SovereignAid phase scripts; design-led PR plans | Ship idempotent provision end-to-end; less vibe-loop rework |
| **Security hygiene** | Working | Bitwarden SoT policy; no secrets in git rules; UFW/SSH mesh habits | Formal: least-privilege audit writeup; fail2ban/ssh hard notes |
| **Debugging / postmortems** | Working–Solid | HickMedia Core retrospective (wrong defaults, stop-rules, milestones) | Publish 2–3 public (redacted) postmortems |
| **Docs & ops culture** | Solid | Design docs, LABNET SoT, USAGE-LOG discipline, portfolio redaction rules | Keep public site redacted; weekly USAGE-LOG rows |
| **AI-assisted ops** | Solid (tooling) | Grok Build orchestration, hybrid local/API policy design | Interview risk: prove solo troubleshooting under time box |

---

## What you can claim confidently

1. You **operate** a real multi-node cluster, not a single laptop demo.  
2. You **document** architecture and failure lessons (retros > screenshots alone).  
3. You understand **edge reality** (constrained M93p workers, Core flash pain).  
4. You can navigate **modern Ubuntu** desktop + server hybrid seats.  
5. You design **before** coding (PR plans, non-goals, alternatives).

## What not to over-claim

1. Years of paid production on-call Linux  
2. Expert Kubernetes (multi-cluster, service mesh, large-scale)  
3. Security certification / hardened compliance lead  
4. “Fully autonomous self-healing AI platform” as finished product  

---

## 30-day skill growth (aligned with portfolio)

| Week | Focus | Proof artifact |
|------|-------|----------------|
| 1 | LFCS weak domains + single-node mastery writeup | Public redacted lab note |
| 2 | Cluster failure/recovery demo | Video ≤8 min (no IPs) |
| 3 | Provision automation (aidectl / cloud-init) | Repo + checklist |
| 4 | Portfolio site + LinkedIn link + mock interview | Live site section |

---

## Related

- [PORTFOLIO-PROJECTS.md](./PORTFOLIO-PROJECTS.md)  
- Design: `docs/design/2026-08-02-aide-lab-virtualbox.md`  
- Brand public: [github.com/DestroyTheKraken](https://github.com/DestroyTheKraken)  
