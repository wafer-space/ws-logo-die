# Solutions catalogue (item g, Stage 1 first-principles)

Stable short-name list (used as IDs across reports):

| ID | Name | Family | Forks upstream? | Forces re-harden? |
|---|---|---|---|---|
| G1 | wrapper-shrink-to-5 | A — strict cleanup | no | yes |
| G2 | document-only | A — strict cleanup | no | no |
| G3 | route-status-into-dead-bits | B — repurpose | yes (to consume them) | yes |
| G4 | preallocate-for-eFuse-(j) | B — repurpose | maybe | yes |
| G5 | harvested-power-monitor-output | B — repurpose | n/a | **infeasible** (cell-type) |
| G6 | tie-to-test-pattern | B — repurpose | yes (to consume) | yes |
| G7 | wire-to-(f)-LFSR-debug-input | C — silly-but-listable | maybe | yes |
| G8 | internal-const-port-unchanged | C — silly-but-listable | no | **no** |
| G9 | eFuse-mux-per-bit | C — silly-but-listable | maybe | yes |

## Considered and discarded without an ID

- **Remove the pads entirely** — eliminated by frozen-bondout.
- **Swap input[6:7] to Schmitt-trigger** — out of scope; doesn't
  address dead-bit cleanup.

Total distinct options catalogued: **9** (exhaustiveness bar: ≥5).
