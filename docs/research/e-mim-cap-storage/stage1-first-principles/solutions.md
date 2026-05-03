# Solutions catalogue (item e, Stage 1 first-principles)

| Strategy | Headline | Primary use | Cap density / leakage | Maturity |
|---|---|---|---|---|
| S1 — Single big MIM bank | One contiguous M4-M5 array; 50 nF in 25 mm² (MIM-2.0); 33 µW leak per 5 mm² | NFC/Qi steady-state | 2.0 fF/µm², 6 µW/mm² leak @6V | PDK-blessed |
| S2 — Hierarchical MIM + MOS-cap | Small fast MIM near load + bulk MOS-cap fill | Mixed transients | 2 fF/µm² + 0.2 fF/µm² fill | Std PDN methodology |
| S3 — Switched-cap charge pump | Small flying cap pumped at 1 MHz; C·f·V = 1 mW from 1 nF | Persistent low-I | small footprint | PMIC industry std |
| S4 — Multi-bank time-sliced | N caps switched in sequence; isolate idle banks | Discontinuous loads | scales with N banks | IoT power mgmt |
| S5 — Charge-pumped MIM-1.0 (boost to 20 V) | Lowest density × highest V² advantage; 197 nJ/mm² | Max energy/area | 1.0 fF/µm² @ 20 V | HV analog std |
| S6 — Distributed MOS-cap fill + active LDO replenisher | Replace bulk cap with always-on current source | Decoupling | 0.2 fF/µm² fill + active loop | std-cell native |
| S7 — MoM-fringe under logo M1-M3 voids | Hand-built fringe caps in inter-logo gaps | Backstop / supplement | 0.2-0.5 fF/µm² | Custom char only |
| S8 — Hot-swap cap-array with zero-leakage idle | Multiple banks with BOTH terminals isolated when idle → exp-suppressed leakage | Ambient-RF µW operation | 2 fF/µm² + isolation FSM | Specialty |

## Eight strategies catalogued (exceeds Stage-1 minimum of 5)

Both ends of the spectrum represented:

- **Simplest:** S1 (single big bank) and S7 (free fringe in voids).
- **Most sophisticated:** S5 (HV-boost cap pump) and S8 (zero-
  leakage hot-swap banking).

## Discarded approaches

- **PIP / poly-poly cap** — not in `gf180mcuD` (verified by
  `PRIOR_CONTEXT.md`).
- **Junction caps** — poor density, strong VC.
- **LC-tank-as-storage** — resonator, not storage.
- **Bondpad-as-cap** — ~0.1 pF/pad × 44 pads ≈ 4 pF, useless.
- **External cap** — forbidden by `TODO.md`.

## Per-consumer mapping

| Consumer | Recommended strategy | C target | Area |
|---|---|---|---|
| NFC sub-carrier (~10 nF) | S1 or S2 | 10–100 nF | 0.005-0.05 mm² |
| LED twinkle 100 µs pulse | S1 | 500 nF | 0.25 mm² |
| LED long-pulse 100 ms | **S6** (continuous harvest, NOT stored) | n/a | n/a |
| eFuse program burst | S1 with HV variant | 1 µF | 0.5 mm² |
| BLE TX burst | S1 or S5 | 1.2 µF | 0.6 mm² |
| Ambient RF mode | **S8** mandatory | scaled | scaled |

## Stage-2 / Stage-3 handoff

The Stage-1 first-principles shortlist for Stage-2 gap analysis:

- **S1** (single big bank) — default for high-power harvest paths.
- **S5** (HV-pumped MIM-1.0) — best energy/area when charge pump
  exists for other reasons (eFuse).
- **S6** (active LDO replenish) — required for LED long-pulse mode
  since 500 µF is infeasible.
- **S8** (zero-leak banking) — required for ambient-RF mode since
  big bank leakage > harvest budget.
- **S2** (hierarchical) — wraps the above as a unified PDN.

S3, S4, S7 are deferred unless area pressure pushes them up.
