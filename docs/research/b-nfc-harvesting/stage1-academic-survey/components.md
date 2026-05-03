---
item: b
item_name: nfc-harvesting
stage: 1
angle: academic-survey
researcher: claude-opus-4-7-1m (auto-mode, parallel instance 3 of 3, retry pass)
status: draft
last-updated: 2026-05-03
---

# Sub-block breakdown — academic-rectifier-anchored implementation cost

For each of the 9 silicon-anchored topologies in
[`solutions.md`](solutions.md), this file lists the building blocks
that an implementation in `gf180mcuD` would need. The blocks are
grouped by topology family.

The column "Comparator class" is the single most-important
implementation parameter for the active-rectifier family — the
papers in §A and §D differ primarily in what they do *to the
comparator* (switched offset, dynamic biasing, SAR-driven delay,
timing-mode delay).

---

## R-PD-baseline / R-PD-native (passive MOS bridge)

| Sub-block | Count | gf180mcuD device | Notes |
|---|---|---|---|
| Diode-connected nFET (or native-nFET) | 4 | `nfet_06v0` (5 V) or `nfet_06v0_nvt` (native) | All four bridge arms; native-nFET is the headline PDK leverage. |
| V_RECT smoothing cap | 1 | MIM 1.5 fF/µm² | ~1 nF (sister 1st-princ. §5.5). |
| ESD pad diodes (re-used as fall-back) | 2 | PDK ESD cell | Not for steady-state conduction. |
| Tuning cap (parallel) | switched bank, ~4–6 bits | MIM | ~86 pF nominal. |
| Antenna pads | 2 | LA, LB pad cells | Differential. |

No comparator, no bias chain. The simplest implementation in this
list. Risk: native-nFET reverse-leakage characterisation without
academic precedent for HF — Stage 4 spice deep-dive required.

## R-GR-HF-1stage (single-stage Greinacher)

| Sub-block | Count | gf180mcuD device | Notes |
|---|---|---|---|
| Series DC-blocking cap | 2 | MIM | ~10 pF each. |
| Diode-connected MOS | 4 | `nfet_06v0_nvt` preferred | 2× to-VDD, 2× to-GND for differential. |
| V_RECT smoothing cap | 1 | MIM | Same as baseline ~1 nF. |
| Mode-switch FET (engages/disengages this path) | 2 | `nfet_06v0` | Bypassed in steady-state; engaged only at brown-out. |

Mode-switching cost: the series caps must be in-series only when
the brown-out path is selected, otherwise they reduce the Q of the
main-rail rectifier. Adds 2x series-pass FETs.

## R-CC-academic (cross-coupled bridge, no comparators)

| Sub-block | Count | gf180mcuD device | Notes |
|---|---|---|---|
| Cross-coupled NMOS (low side) | 2 | `nfet_06v0` | Wide; gates wired to opposite-phase RF input. |
| Cross-coupled PMOS (high side) | 2 | `pfet_06v0` | Wide; gates wired to opposite-phase RF input. |
| Body-diode parasitic (start-up path) | implicit | parasitic | Used as start-up rectifier seed. |
| V_RECT smoothing cap | 1 | MIM | ~1 nF. |

Comparator class: none. This is the academic baseline before
adding comparators — every Lee/Mok-line paper builds on top of this
skeleton.

## R-AC-LeeMok-switched-offset (the seminal 2013/2014 active rectifier)

| Sub-block | Count | gf180mcuD device | Notes |
|---|---|---|---|
| Cross-coupled NMOS / PMOS bridge | 4 | as R-CC | Same skeleton. |
| High-side comparator (Vds-sense) | 2 (one per high arm) | `nfet_03v3`/`pfet_03v3` low-Vt bias | Switched-offset architecture: Lu–Lam–Ki–Mok TBioCAS 2014 [A1]. |
| Switched-offset bias cell | 2 | MIM coupling cap + nFET switch | The "switched offset" — pre-charges the comparator with delay-compensating Vos. |
| Bias-current generator (~30 µA) | 1 | nFET current mirror | Each comparator draws ~30 µA. |
| Start-up path (body-diode-only mode) | implicit | as R-CC | Bootstraps to ~1.5 V before comparators come alive. |
| V_RECT smoothing cap | 1 | MIM | ~1 nF. |

Comparator class: static switched-offset, ~30 µA quiescent each.
Paper reports 80–85 % PCE at 13.56 MHz on 0.35 µm. Equivalent in
0.18 µm gf180mcuD should be similar or better.

## R-AC-adaptive-delay (Lu–Ki 2016 / Cha 2021 line)

| Sub-block | Count | gf180mcuD device | Notes |
|---|---|---|---|
| Cross-coupled bridge | 4 | as R-CC | Skeleton. |
| Comparator with controllable delay | 2 (high-side) | analog | Programmable delay (e.g. tapped delay line). |
| Delay-detector | 2 | digital | Detects whether comparator switched too early / too late on each cycle. |
| Calibration FSM | 1 | digital | Slides the delay control until detector sees zero error. |
| Bias-current generator | 1 | nFET current mirror | ~30–50 µA per comparator. |
| V_RECT smoothing cap | 1 | MIM | ~1 nF. |

Comparator class: comparator with adaptive delay. Lu–Ki 2016 [D1]
reports 92 % PCE; Cha 2021 [D2] reports 90.6 % PCE — both in
0.18 µm.

## R-AC-SAR-Ma2020 (best-in-class published)

| Sub-block | Count | gf180mcuD device | Notes |
|---|---|---|---|
| Cross-coupled bridge | 4 | as R-CC | Skeleton. |
| Comparator with coarse + fine delay control | 2 | analog | Two-stage tapped delay. |
| Delay-detector (coarse + fine) | 2 | digital | Detects sign and magnitude of delay error. |
| 6-bit SAR | 1 | digital | Per-cycle binary search for ideal delay. |
| Bias-current generator | 1 | nFET current mirror | ~50 µA. |
| V_RECT smoothing cap | 1 | MIM | ~1 nF. |

Comparator class: comparator with SAR-assisted coarse-fine adaptive
delay. Ma 2020 [A3] reports peak 92.6 % PCE, 95.7 % VCR. Most
sophisticated in the literature; *also the most digital-heavy*,
which is good news for synthesis-friendly implementation.

## R-TC-Kotani-self-Vth (threshold-cancellation rectifier)

| Sub-block | Count | gf180mcuD device | Notes |
|---|---|---|---|
| Diode-connected MOS with adjacent-stage gate bias | 4 | `nfet_06v0` or `pfet_06v0` | Each gate gets a static DC bias from the *adjacent* output node. |
| Coupling caps for AC drive | 4 | MIM | One per gate. |
| Bias-bleed resistor (for stability) | 4 | high-Z polysilicon | Avoids slow charge drift on coupled gates. |
| V_RECT smoothing cap | 1 | MIM | ~1 nF. |

Comparator class: none — fully passive, but with capacitive-
coupling-plus-DC-bias to cancel Vth.

Anchor performance: Kotani 2009 [B2] 67.5 % at low input
amplitudes; Hashemi 2012 [B5] 87 % at 13.56 MHz on 0.13 µm. The
HF-relevant number is ~80–87 %.

## R-AC-half-active (one comparator only)

| Sub-block | Count | gf180mcuD device | Notes |
|---|---|---|---|
| Cross-coupled NMOS (passive low-side) | 2 | `nfet_06v0` (or native for low-Vth) | Diode-connected on low side. |
| Active high-side PMOS with comparator | 2 | `pfet_06v0` + comparator | One comparator per arm. |
| Bias-current generator | 1 | smaller — only one comparator pair | ~30 µA. |
| V_RECT smoothing cap | 1 | MIM | ~1 nF. |

Comparator class: one comparator pair only (high-side).
Lu–Lam–Ki–Mok 2014 [A1] §III.B reports ~70 % PCE.

---

## Cross-topology shared infrastructure (all 9)

| Sub-block | Notes |
|---|---|
| Differential antenna pads (LA, LB) | Mandatory for all topologies. ESD-coordinated pad-frame layout. |
| On-die parallel tuning cap (switched MIM bank, 4–6 bit trim) | ~86 pF nominal, ±30 % range; sister industry-survey §3.3.1 confirmed 17–97 pF as industry-validated range. |
| Active shunt clamp at V_RECT (4.5 V threshold) | Mandatory for *all* topologies — sister first-principles §5.6 shows clamp must be active even at compliance Hmin. |
| Stacked diode-connected MOS hard-clamp at 6 V | Backup for the active clamp. |
| Series LDO (PMOS pass + bandgap + error amp) at V_REG = 1.8 / 3.3 V | Sister industry-survey §3.2.1 prefers shunt regulator, but for our low-cap regime a series LDO with on-die compensation may serve better — Stage 2 decision. |
| Brown-out detector — Vth-referenced (B-IND-Vth) for first-stage | Universal across all topologies. |
| Brown-out detector — bandgap-referenced UVLO (B-IND-Bandgap) for digital | Universal across all topologies. |
| V_REG smoothing cap | Sister first-principles §5.7: ~6 nF needed for 847.5 kHz modulation pause; *binding area constraint*. |

---

## Comparator design micro-spec (the binding hard part)

The active-rectifier topologies all hinge on a comparator that sits
across each high-side rectifying FET and trips when the forward-
conduction window opens / closes. Sizing constraints from the
academic record:

| Parameter | Lu–Ki 2014 [A4] | Lu–Ki 2016 [D1] | Ma 2020 [A3] | Cha 2021 [D2] |
|---|---|---|---|---|
| Carrier period | 73 ns | 73 ns | 73 ns | 73 ns |
| Comparator response time | < 5 ns | < 3 ns | < 2 ns | < 5 ns |
| Reported peak PCE | 80 % | 92 % | 92.6 % | 90.6 % |
| Process | 0.35 µm | 0.18 µm | 0.18 µm | 0.18 µm |
| Comparator quiescent | ~30 µA | ~50 µA | ~50 µA | ~30 µA |
| Delay calibration mechanism | switched offset (static) | real-time (continuous) | SAR (per-cycle) | digital adaptive |

For gf180mcuD (also 0.18 µm), the response-time requirement of
< 5 ns is achievable: fT ≈ 50 GHz means a single-stage comparator
has gain-bandwidth of ~5 GHz, easily clocking through 5 ns. No
academic topology is rejected on bandwidth grounds.

The *binding* design challenge is offset and delay over PVT — and
that is exactly what the adaptive-calibration papers attack. Stage
2 should treat the choice of calibration mechanism as the central
architectural decision (static vs adaptive vs SAR vs timing-mode),
not the choice of rectifier topology per se.

---

## Power-budget cost per comparator (tying back to harvested DC)

Sister first-principles report §5.10 gives:

- Marginal corner: P_DC_avail ≈ 0.84 mW.
- Working corner: P_DC_avail ≈ 7.7 mW.

Per-comparator quiescent at 30 µA × 1.8 V = 54 µW. Two comparators
(full active rectifier) = 108 µW.

| Corner | P_DC budget | 2-comparator cost | Fractional cost |
|---|---|---|---|
| Marginal (k = 0.05) | 840 µW | 108 µW | 12.9 % |
| Working (k = 0.15) | 7700 µW | 108 µW | 1.4 % |

At marginal coupling, two comparators are ~13 % of the budget.
This is exactly the trade Cheng 2018 [A2] addresses by dynamically
biasing the comparators only during the expected switching windows
— they save ~3x of the average comparator power.

For our project, the implication is: at marginal coupling we
should select a passive bridge (R-PD-native) — and at working
coupling we should select an adaptive-delay active rectifier
(R-AC-adaptive-delay or R-AC-SAR-Ma2020). This is the sister
industry-survey's "B-IND-Powercheck" finding restated from the
academic side: the correct topology depends on the field strength,
not on a single design choice.
