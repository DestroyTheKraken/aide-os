# ara_tutor knowledge corpus

LFCS reference content for Ara RAG indexing. Populated by AIOS PR plan.

## linux/ (PR 4 :bi-check-lg:)

| File | LFCS domain | Projects |
|------|-------------|----------|
| `essential-commands.md` | Essential Commands ~20% | 00, 01, 02 |
| `operations-deployment.md` | Operations ~25% | 04, 08, 09 |
| `storage-filesystems.md` | Storage ~20% | 05 |
| `users-groups-permissions.md` | Users & Groups ~10% | 03 |

## networking/ (PR 4 :bi-check-lg:)

| File | Topics | Projects |
|------|--------|----------|
| `ip-dns-routing.md` | Static IP, DNS, NFS | 06 |
| `ssh-remote-access.md` | OpenSSH hardening | 06, 09 |
| `firewall-nat-forwarding.md` | ufw, firewalld, NAT, chrony | 07, 09 |

## weak-areas/ (PR 2–3 :bi-check-lg:)

Learner-specific drills — see `weak-areas/README.md`.

## Indexing rules

See `guides/AIOS_SYSTEM_DESIGN.md` — manifest includes `knowledge/**/*.md`; excludes generated `session/` and `meta/` files.