---
item: e
stage: 1
angle: academic-survey
---

# Components / sub-blocks per surveyed strategy

Cross-references the AS-N IDs in `solutions.md`.

## AS-1 Standard MIM (PDK MIM-2.0 / Gambino-class)

- MIM cap PCell: foundry `cap_mim_2f0_m4m5_noshield` (or 1.5 / 1.0
  variants).
- Bottom plate: M4.
- Top plate: FuseTop.
- Per-tile DRC limit 100 x 100 µm² (MIMTM.8b) — banks are arrays
  of 100x100 tiles linked in parallel.

## AS-2 High-k MIM (research, not PDK)

Not implementable in this PDK; included only as ceiling reference.

## AS-3 Deep-trench cap (research, not PDK)

Sub-blocks would be: deep silicon etch, ALD high-k conformal,
doped-poly fill. Not implementable.

## AS-4 MOS-cap

- `cap_nmos_06v0` (or 03v3) PCell.
- Free in std-cell-row spacers (`fillcap_4..64`).
- N-well isolation for series strings if higher than VDD.

## AS-5 Pelliconi cross-coupled doubler

| Block | PDK realisation | Approx. count / size |
|---|---|---|
| Cross-coupled NMOS | nfet_06v0 | 2 x ~10 µm/0.5 µm |
| Cross-coupled PMOS | pfet_06v0 | 2 x ~20 µm/0.5 µm |
| Flying cap | MIM-2.0 | 2 x 1-10 pF (~5000 µm² each) |
| Non-overlap clock gen | std-cells from gf180mcu_fd_sc | ~100 µm² |
| Hold cap | MIM-2.0 or MIM-1.0 | 10-100 pF |
| Output rectifier / level-shifter | nfet+pfet 06v0 | small |

## AS-6 Dickson voltage multiplier

| Block | PDK realisation | Notes |
|---|---|---|
| N-stage rectifier | diode-connected nfet_06v0 OR active-rectifier | At sub-V_in, need ULP diode tricks (Karthaus 2003) |
| Stage caps | MIM-2.0 (or fly through MIM-1.0 if HV) | 1-10 pF each, 2-6 stages typical for 2.4 GHz |
| Single-phase clock | std-cells | 100s MHz at 2.4 GHz harvest |
| Hold cap | MIM-2.0 / MIM-1.0 | Per output rail |

## AS-7 Bang SAR-SC

| Block | PDK realisation |
|---|---|
| 8 binary-weighted flying caps | MIM-2.0 array |
| 16 switches | nfet/pfet_05v0 per side |
| 8-bit SAR controller | digital std-cell |
| Comparator | nfet/pfet 03v3 latched comparator |
| Hysteretic regulator | nfet/pfet + comparator + hysteresis |

## AS-8 2:1 fully-integrated SC step-down

Same blocks as AS-7 but fixed ratio; smaller controller, two
flying caps.

## AS-9 multi-port ZCS bank-switching

| Block | PDK realisation |
|---|---|
| Storage banks | MIM-2.0 (each 100x100 tile or larger array) |
| Per-bank HV switch (top) | pfet_06v0 with body-bias, HV-tolerant |
| Per-bank HV switch (bottom) | nfet_06v0 |
| Bank sequencer | digital FSM, std-cells |
| Voltage-monitor comparator | per bank or shared |

## AS-10 active leakage-cancellation

| Block | PDK realisation |
|---|---|
| Sense amp at floating-off node | weak-inversion OTA, 03v3 transistors |
| Compensation current source | matched current mirror |
| Tuning DAC (optional) | resistor ladder + digital trim |

## AS-11 brown-out-only (Yang/Khan)

| Block | PDK realisation |
|---|---|
| Reference voltage | bandgap / weak-inversion ref |
| Brown-out comparator | hysteretic comparator, 03v3 |
| Power gate | pfet_06v0 header switch |
| Small fast hold cap | 100 pF MIM-2.0 (~50000 µm²) |

## AS-12 Output-cap-less LDO

| Block | PDK realisation |
|---|---|
| Pass FET | pfet_06v0 |
| Error amp (sub-threshold) | nfet/pfet_03v3, biased ~50 nA |
| Slew-rate boost | dynamic-bias auxiliary path |
| Bandgap | standard PTAT+CTAT bandgap |

## AS-13 MPPT continuous replenisher

| Block | PDK realisation |
|---|---|
| MPPT controller | digital FSM + ADC (slow) |
| Reconfigurable rectifier | active rectifier with controllable phase |
| Tiny hold cap | 1-10 pF MIM-2.0 |
| Energy-recycling switch | pfet_06v0 reverse-current path |

## AS-14 on-chip resonance tuner

| Block | PDK realisation |
|---|---|
| Tuning cap-DAC | binary-weighted MIM-2.0 array |
| Switches | nfet_06v0 |
| Tuning controller | digital + magnitude-sensing comparator |

## Common-blocks cross-cut

- **Brown-out detector** (used by AS-9, AS-11, AS-13): bandgap +
  comparator. ~0.05 mm². Probably one shared instance for whole
  chip.
- **Non-overlap clock generator** (AS-5, AS-6, AS-7, AS-8, AS-9):
  std-cell, ~100-1000 µm² depending on frequency and dead-time.
- **Charge pump for HV switches** (AS-9 if HV switches need
  V_GS > rail): possibly served by AS-5 itself.
