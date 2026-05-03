---
item: e
item_name: mim-cap-storage
stage: 1
angle: first-principles
researcher: stage1-first-principles-1
status: draft
last-updated: 2026-05-03
---

## 1. Executive summary

This report addresses on-die energy-storage capacitance for the v2
chip on `gf180mcuD` 180 nm 5 V CMOS. From PDK direct read, ε₀ε_r/d
sanity, and electrostatic energy E = ½CV², the headline numbers
are:

| Family | Density (fF/µm²) | Vop_max | Energy density (nJ/mm²) at Vop_max | Notes |
|---|---|---|---|---|
| MIM-1.0 (M4-M5, "MIM-B 5LM") | 0.987 | 20 V | **197.4** | Lowest density but highest energy/area — needs charge pump for 5 V chip |
| MIM-1.5 (M4-M5) | 1.47 | 10 V | 73.5 | |
| MIM-2.0 (M4-M5) | 1.99 | 6.6 V | 43.3 | Densest at 5 V rail |
| MOSCAP nfet 3.3 V | 3.98 (peak) | 3.6 V | 25.8 | tanh(V), single-polarity |
| MOSCAP nfet 6 V | 2.18 (peak) | 6.6 V | **47.4** | **Beats MIM-2.0 by ~10 %** at same V |
| MoM/fringe (hand-built) | ~0.2-0.5 | ≤any rail | ~5-10 | No PDK SPICE; needs RC-extract |
| Poly-poly | absent | — | — | **Not in gf180mcuD** |
| Deep-trench | absent | — | — | **Not in gf180mcuD** |
| Ferroelectric | absent | — | — | **Not in gf180mcuD** |
| Multi-pair stacked MIM | absent (only 1 pair on 5LM) | — | — | **Not a tape-out option** |

**Headline conclusions:**

1. **The three MIM densities are mutually-exclusive mask options**
   chosen at tape-out — only one is realised. They sit in identical
   physical space (M4-fusetop-M5 sandwich; verified in
   `gf180mcuD.tech` Magic file).
2. **MOS-cap nfet 6V at peak inversion (47 nJ/mm²) beats MIM-2.0
   (43 nJ/mm²)** at the same 6.6 V rail — surprise finding, gate
   oxide is thinner than MIM dielectric.
3. **Most surprising finding** — under ambient-RF mode (~5 µW),
   leakage on a permanently-biased big cap bank exceeds the harvest
   budget. **A 5 mm² MIM bank at 6.6 V leaks 33 µW vs ~5 µW ambient
   harvest budget.** Re-frames the storage problem: not "minimise
   droop" but "minimise integrated leakage".
4. **LED long-pulse 5 mA × 100 ms at 3 V demands C ≥ 500 µF =
   250 mm² of MIM** — 12× whole die. **INFEASIBLE** — must run
   from live harvested current, not stored energy.
5. **MIM bottom-plate must avoid logo M4 by 1.2 µm** (MIMTM.1) —
   inside the logo bbox the MIM cap shapes must be the
   **complement** of the logo's M4 pattern, eroded by 1.2 µm.

## 2. Requirements as understood

| # | Requirement | Source |
|---|---|---|
| R1 | No external caps | TODO.md hard cross-cutting #2 |
| R2 | Top metal stays a logo | TODO.md hard cross-cutting #1 |
| R3 | Per-rail cap budget set by load events | TODO.md item (b)(c)(d) |
| R4 | Density-rule interaction with `Metal2_ignore_active` | librelane/config.yaml |
| R5 | Floorplan area: 20.14 mm² die, 12.92 mm² core | librelane/slots/slot_1x1.yaml |
| R6 | 50 mW power budget (PRIOR_CONTEXT.md hypothesis) | PRIOR_CONTEXT.md |
| R7 | Voltage rails: 5 V DVDD + 3.3 V harvested | TODO.md (i) |

## 3. Solution-space map — Eight cap-storage strategies

**S1 — Single big MIM bank.** One contiguous M4-M5 array under any
free area. Simplest. Up to ~50 nF in 25 mm² at MIM-2.0. Loses to
leakage in ambient-RF.

**S2 — Hierarchical small-fast MIM + big-slow MOS-cap.** Small
(10 nF) MIM near load for fast transients + bulk (~µF) MOS-cap
fill in std-cell rows for energy. Two-ring PDN.

**S3 — Switched-cap charge pump.** Small (1 nF) flying cap pumped
at 1 MHz delivers C·f·V = 1 mW continuous from a much smaller die
budget than holding 1 µF static. Standard PMIC topology.

**S4 — Multi-bank time-sliced.** N caps switched into rail in
sequence. Distributes charge work; can isolate idle banks.

**S5 — Charge-pumped MIM-1.0 (boost cap to 20 V).** Use lowest-
density MIM at maximum operating voltage to extract V² advantage.
Energy density 4.6× over MIM-2.0. Costs a charge pump (which we
likely need for eFuse anyway). LDMOS-class HV switch needed.

**S6 — Distributed MOS-cap fill + active LDO replenisher.**
Replace bulk cap with always-on current-source fed from harvester.
Loop bandwidth must exceed load event rate. Best for LED long-
pulse mode.

**S7 — MoM-fringe under logo M1-M3 voids.** Hand-built fringe caps
in inter-logo gaps on layers MIM doesn't use. ~0.2-0.5 fF/µm².
Backstop / supplement only — energy density too low to be primary.

**S8 — Hot-swap cap-array banking with zero-leakage idle.**
Multiple banks; idle banks have BOTH terminals isolated → exp-
suppressed leakage. Critical for ambient-RF mode. Specialty
topology.

## 4. Sub-block breakdown

See [`components.md`](components.md). Per-strategy blocks include:

- MIM cap PCells (`cap_mim_2f0_m4m5_noshield` etc.) at 100×100 µm
  tile maximum (DRC MIMTM.8b cap).
- Bottom-plate Metal4 mesh.
- Top-plate FuseTop layer.
- Switch FETs for S3/S4/S8 banking.
- Charge pump (S3, S5) — needs Metal-2 / Metal-3 caps.
- MOS-cap fillcap_64 cells (28.6 fF / 140.5 µm² apparent density).

## 5. First-principles sanity checks

### 5.1 Cap density consistency with PDK dielectric

`C_area = ε₀ ε_r / d_eff`. With C_area = 2 × 10⁻³ F/m² and pure
SiO₂ (ε_r = 3.9), d ≈ 17.3 nm; with Si₃N₄ (ε_r = 7), d ≈ 31 nm.
At 6.6 V, E-field is 3.8 / 2.1 MV/cm respectively — comfortable
margin in both cases. **Number is physically plausible, conservative.**

### 5.2 Max on-die cap, slot_1x1 core (12.92 mm²)

Ceiling = 2 fF/µm² × 1.292 × 10⁷ µm² = **25.8 nF** if 100 % covered.
Realistic 30-50 % budget = **8-13 nF**. Energy at 13 nF, 3.3 V =
70 nJ. LED-pulse demand 2 × 5 mA × 3 V × 100 ms = 3 mJ. Ratio ≈
4 × 10⁴ — **pulse must come from continuous harvester, not stored
energy.**

### 5.3 Per-consumer demand vs feasibility

| Consumer | I, dt, ΔV | C_min | Area at MIM-2.0 | Verdict |
|---|---|---|---|---|
| NFC sub-carrier 1-cycle (847.5 kHz, 5 mA, ΔV=0.3 V) | — | **9.8 nF** | 0.005 mm² | **Trivially feasible** |
| NFC sub-carrier 10-cycle burst | — | **98 nF** | 0.05 mm² | **Easily feasible** |
| LED twinkle 5 mA × 100 µs at 3 V | ΔV=1 V | **500 nF** | 0.25 mm² | **Feasible** |
| LED long-pulse 5 mA × 100 ms (TODO target) | ΔV=1 V | **500 µF** | 250 mm² | **INFEASIBLE — pivot needed** |
| eFuse program 100 mA × 10 µs at 5 V | ΔV=1 V | **1.0 µF** | 0.5 mm² | **Feasible but ~5 % of core** |
| BLE TX burst 10 mW × 200 µs at 3.3 V | ΔV=0.5 V | **1.2 µF** | 0.6 mm² | **Feasible but tight** |

### 5.4 Surprising leakage vs ambient-RF crossover

Spec: ≤1 pA/µm² @ rated V (PDK DRM). Over 1 mm² MIM-2.0 at 6.6 V:
**6.6 µW/mm² continuous leakage**.

| Bank size | Leakage at 6.6 V | vs harvest budget |
|---|---|---|
| 0.5 mm² (1 nF MIM-2.0) | 3.3 µW | < NFC (100 µW) and Qi (1 mW), > 2.4 GHz ambient (5 µW est) |
| 5 mm² (10 nF) | 33 µW | OK on NFC/Qi, **6× ambient-RF budget** |
| 50 mm² (100 nF) | 330 µW | > NFC budget |

**Key conclusion**: under ambient-RF mode (~5 µW), a permanently-
biased big cap bank is a *net energy sink*. Ambient-RF operation
requires either:
(a) bank-switching that **isolates both terminals** of idle banks (S8),
(b) operating cap below rated voltage,
(c) running the cap small enough that leakage < harvest.

### 5.5 Density / DRC interaction

`density.drc`: M1.4 / M2.4 / M3.4 / M4.4 / M5.4 require ≥30 % MIN
coverage, **no MAX rule** for any metal. So a giant MIM array on
M4-M5 *adds* density and cannot trigger density violations on
those layers. The existing `KLAYOUT_FILLER_OPTIONS:
Metal2_ignore_active: true` workaround is for M2 — completely
orthogonal to MIM addition (MIM is M4-M5).

The **MIM-A option (M2-M3) would help M2/M3 density**, but it's
only available in the 3LM stack; `gf180mcuD` is 5LM, so MIM-A is
not selectable. **Negative result**: cannot opt into M2-M3 MIM at
this tape-out.

A separate concern: the MIM bottom-plate is *the* M4 layer —
wherever the logo draws Metal4, that piece of M4 is committed to
logo decoration and cannot also serve as a cap bottom-plate
(would short logo to cap). MIMTM rules require 1.2 µm spacing of
MIM bottom-plate to "unrelated" M4. Inside the logo bbox the MIM
cap shapes must be the **complement** of the logo's M4 pattern,
eroded by 1.2 µm.

## 6. References

See [`references.md`](references.md). Verified directly: PDK SPICE
(`sm141064.ngspice`, `sm141064_mim.ngspice`), Magic tech file
`gf180mcuD.tech`, KLayout PCell `cap_mim.py`, DRC `mim_a.drc` and
`mim_b.drc`, density.drc. PRIOR_CONTEXT.md confirms PIP not in PDK.

## 7. Negative results

- **N-1**: Multi-pair stacked MIM is NOT a PDK option (only one
  MIM pair on 5LM).
- **N-2**: Deep-trench, ferroelectric, poly-poly cap primitives all
  absent.
- **N-3**: 500 µF "100 ms LED on" infeasible at any density (>6×
  die area).
- **N-4**: 5 mm² MIM bank at 6.6 V leaks 33 µW > 5 µW ambient-RF
  harvest. Naive "max area" strategy is energy-negative for
  ambient-RF.
- **N-5**: MIM-1.0 + 20 V charge pump shrinks 4.6× advantage to
  ~2-3× after pump efficiency.
- **N-6**: MIM under logo cannot use regions where logo draws
  solid M4/M5 — cap shape must be the *complement* of the logo on
  those layers, eroded by 1.2 µm.
- **N-7**: GF180MCU has no calibrated MoM/fringe SPICE primitive —
  MoM caps need post-extraction characterisation.

## 8. Open questions

See [`open-questions.md`](open-questions.md). Top-priority: Q-3
effective MIM bottom-plate spacing rule against logo M4 (does it
eliminate >50 % of logo voids?); Q-7 real (typical not max-spec)
MIM leakage at 1 V vs 6 V (likely 10× lower than 1 pA/µm² spec);
Q-8 MIM density mask choice (1.0 / 1.5 / 2.0) is one tape-out
decision affecting *all* analog blocks.

## 9. Comparison readiness

| Approach | Headline performance | Area / power cost | Maturity | Best fit | Worst fit |
|---|---|---|---|---|---|
| S1 single big MIM | 50 nF in 25 mm² (MIM-2.0); 33 µW leak per 5 mm² | scales 1:1 | PDK-blessed | NFC/Qi steady-state | Ambient RF |
| S2 hierarchical | 100 nF MIM + µF MOS | additive | Std PDN methodology | Mixed transients | Pure DC |
| S3 SC charge pump | 1 mW deliv from 1 nF·1 MHz·1 V | ~0.5 mm² + switch | PMIC industry std | Persistent low-I | Single huge transient |
| S4 multi-bank | tens-nF, isolated leak | extra switches | IoT power mgmt | Discontinuous loads | Continuous |
| S5 HV-pumped MIM-1.0 | 197 nJ/mm² | pump + HV switch | HV analog std | Max energy/area | Low-V flows |
| S6 active LDO replenish | µF via dcap fill | active loop | std-cell native | Decoupling | Big bursts |
| S7 MoM-fringe | 0.2-0.5 fF/µm² | reuses logo voids | Custom char only | Backstop | Primary storage |
| S8 zero-leak hot-swap | scalable | extra switches | Specialty | Ambient-RF µW | Steady-state |

## 10. Author's notes

PDK gives three mutually-exclusive MIM density mask options — 1.0
/ 1.5 / 2.0 fF/µm² (Vop_max 20 / 10 / 6.6 V) — all sandwiched
between Metal4 and Metal5 only. **MOS-caps offer 3.98 fF/µm² peak
at 3.3 V or 2.18 at 6 V**; no poly-poly, no MoM, no deep-trench,
no ferroelectric, no multi-pair stack.

Floorplan: 20.14 mm² die, 12.92 mm² core, 6.50 mm² big_logo macro,
**22.4 % of logo bbox is solid metal on every Metal1-5**, leaving
5.05 mm² inter-logo void per layer.

Most surprising finding: **MIM leakage spec (1 pA/µm² @6V)
translates to 6 µW/mm² static loss**. A 5 mm² bank under ambient-RF
(~5 µW harvest) is a net energy sink — drives an architecture
pivot to bank-switched zero-leakage idle (S8). Second surprise:
MOS-cap 6 V peak energy density (47 nJ/mm²) beats MIM-2.0
(43 nJ/mm²) at same rail.
