# Solutions catalogue (item b, Stage 1 first-principles)

Stable short-name keys used across this report and `report.md`.

## R-A — Half-wave diode-connected MOS

Single diode-connected MOSFET, antenna single-ended-to-ground.
Vth-loss = 1·Vth (≈ 0.67 V at 5-V flavour, ≈ 0.04 V at native).
**Verdict:** start-up seed only.

## R-B — Half-wave voltage-doubler (Villard)

DC-blocking series cap drives one-diode-to-VDD plus one-diode-to-
GND. Output ≈ 2·Vpk_ant − 2·Vth. **Verdict:** marginal — best
topology only at brown-out edge with Vpk_ant ~1.5 V.

## R-C — Greinacher / Cockcroft-Walton multi-stage charge pump

N-stage cascade. Output ≈ 2N·Vpk_ant − 2N·Vth. Sweet spot is
2.4 GHz where Vpk_ant ≪ Vth. **Verdict:** wrong tool at LF; retain
N=1 for brown-out edge only.

## R-D — Full-bridge (4-diode) passive rectifier

Two arms of two diode-connected MOS, antenna differential.
Vth loss: 2·Vth.

- **R-D-5V variant:** all four devices `nfet_06v0`. Vth = 0.67 V.
  Brown-out boundary = 3.55 V Vpk_ant — fails at ISO Hmin.
- **R-D-native variant:** `nfet_06v0_nvt`. Vth = 0.04 V. Brown-out
  boundary = 2.28 V — works at Hmin. **Leading candidate.**

## R-E — Cross-coupled gate-driven full bridge ("CMOS bridge")

NMOS-low + PMOS-high cross-connected to opposite-phase antenna.
η ≈ 75–85 %. Start-up bootstraps via body-diode in tens of µs.

## R-F — Cross-coupled active rectifier (comparator-driven gates)

R-E + Vds-sense comparators driving high-side PMOS. η ≈ 90 %+.
Comparator quiescent (~30 µA × 3.3 V = 100 µW) is a flat tax.

## R-G — Active rectifier with charge-pumped gate-bootstrap

R-F overlay with a small charge pump driving PMOS gates above
V_RECT. Gets PMOS into deep linear at low Vpk_ant.

## R-H — Threshold-cancellation rectifier

Bias added to each gate so effective Vth ≈ 0. Variants:
internal-Vth-cancellation (charge-pumped reference), self-Vth-
cancellation (DC-blocking cap), floating-gate (programmed at test).

## R-I — Half-active hybrid

Active comparators only on high-side PMOS; low-side stays diode-
connected NMOS. η ≈ 70 %, 1·Vthn loss only, one comparator.
**Risk-mitigated fallback to R-F.**

## Tuning network

- **T-A — Parallel-resonant tank:** Cap differentially across the
  loop. **Primary topology.**
- **T-B — Series-resonant network:** Cap in series with the loop.
  Catalogued. Worth revisiting only if Stage-4 prefers current-
  mode rectifier input.

## Voltage regulator

- **V-A — Series LDO:** Primary regulation topology.
- **V-B — Shunt regulator:** Useful as over-voltage clamp at V_REG.
- **V-A + V-B hybrid:** Tight LDO regulation in steady state, with
  shunt clamp activating only when V_REG starts to climb.

## Over-voltage clamp

- **C-A — Static Zener-equivalent (stacked diode-connected MOS):**
  Required as always-active backstop.
- **C-B — Active-shunt clamp:** Required for efficiency in
  moderate fields. **Two-stage clamp (C-A + C-B) is mandatory** per
  §5.6 of `report.md`.

## Brown-out detector

- **B-A — Vth-referenced:** Coarse, sub-100 nA. First-stage enable.
- **B-B — Bandgap-referenced:** Precise, sub-µA. Second-stage
  enable for digital domain.

## Antenna feed architecture

- **Differential** (chosen) — common-mode rejection at the
  rectifier; modulator's bridge-bypass current is the dominant CM
  disturbance.
- **Single-ended** (rejected) — NR-7.

## Discarded approaches (one-line reasons)

- Synchronous rectifier driven by on-die oscillator — start-up
  chicken-and-egg.
- Class-D resonant self-rectifier — wrong loss-dominance regime at
  13.56 MHz.
- Mechanical / piezo / triboelectric — no off-die passives.
- Pad-ESD-diodes-as-rectifier — ESD diodes sized for one-shot
  events.
- Switched-capacitor LDO — start-up chicken-and-egg + extra ripple.

## Architectural recommendations to Stage 2 (without picking a winner)

Per METHODOLOGY.md, Stage 1 does **not** pick a single approach.
Three observations:

1. **R-D-native + T-A + V-A+V-B + C-A+C-B + B-A→B-B** combination
   is the simplest, lowest-risk, most-PDK-compatible architecture.
2. **R-F + T-A + V-A+V-B + C-A+C-B + B-A→B-B** is the highest-η
   variant, at the cost of comparator quiescent and start-up
   complexity.
3. **R-E** (no-comparator cross-coupled bridge) is a worthwhile
   middle-ground deep-dive.

All three should be Stage-4 deep-dive candidates.
