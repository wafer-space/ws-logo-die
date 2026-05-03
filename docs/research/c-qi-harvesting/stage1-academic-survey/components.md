# Components — sub-block inventory (item c, Stage 1 academic survey)

This file maps each silicon-paper-anchored topology in
[`report.md`](report.md) §3 to the sub-blocks an implementation in
`gf180mcuD` would need. It is the academic-survey companion to
`stage1-first-principles/components.md` — where the first-principles
inventory derives blocks from physics, this inventory derives blocks
from the published silicon papers' block diagrams.

## Common to every Qi-band silicon receiver in the surveyed literature

The following building blocks appear in the block diagrams of every
peer-reviewed Qi/PMA silicon paper surveyed ([Khan2018-Energies],
[Wu2019-Qi], [Wu2020-AICSP], [Quang2015-TIE], [QuangHa2015-WideTriple]):

| Block | Function | Typical area (paper-reported) | Our `gf180mcuD` device(s) |
|---|---|---|---|
| AC bond pad pair | Coil terminals; ESD-rated for >= 50 V transient | n/a (off-die) | Custom IO with primary diode + secondary clamp |
| Input AC clamp | Hard limit on AC swing; protects against open-circuit overvoltage | < 0.005 mm^2 | Diode-connected `nfet_06v0_nvt` stack |
| Bandgap reference | 1.2 V reference; PVT +/-2 % | 0.005-0.01 mm^2 | CTAT+PTAT, `pfet_03v3` + `npn_05p00` |
| Rectifier core (4 FETs) | AC -> DC | 0.005-0.05 mm^2 | `nfet_06v0` + `pfet_05v0` (or native) |
| Rail comparator(s) | Detect AC zero-crossing for sync rectifier | 0.003-0.01 mm^2 each | Diff-pair, `pfet_03v3` + `nfet_03v3` |
| Storage cap on Vrect | Filter AC ripple | 0.01-0.1 mm^2 | `cap_mim` (1.0 / 1.5 / 2.0 fF/um^2) |
| Linear LDO pass-FET | Vrect -> 3.3 V | 0.005-0.02 mm^2 | `pfet_05v0` |
| LDO error amp | Closes regulator loop | 0.005-0.01 mm^2 | Two-stage opamp |
| UVLO / brown-out detector | Disable LDO if Vrect too low | 0.002 mm^2 | Comparator with hysteresis |

**Common total: ~0.05-0.25 mm^2**, with the storage cap dominating
when sized for free-rider duty-cycled operation.

## Per-topology architecture-specific sub-blocks

### AS-B1 (passive PN bridge) — academic baseline

| Block | Spec | Area |
|---|---|---|
| 4x PN-junction rectifier diodes | 1 A_pk surge each | 0.004 mm^2 |

**Architecture-specific area: ~ 0.004 mm^2**, identical to
first-principles FP-1.

### AS-B2 (native-NMOS bridge) — [Mandal2007] lineage

| Block | Spec | Area |
|---|---|---|
| 4x diode-connected `nfet_06v0_nvt` | Vth ~ 0 V; W = 1000 um each | 0.004 mm^2 |

**Architecture-specific area: ~ 0.004 mm^2**. Identical area to B1
but with ~6x lower forward drop. Only ever published for biomedical
implants in the 100 kHz - 1 MHz band, not for Qi BPP specifically;
reproducing this in our project would be a small academic
contribution.

### AS-B3 (cross-coupled latched comparator) — [LeeGhov2011], [ChaPark2012], [LuKi2014]

| Block | Spec | Area (paper-reported, scaled to GF180) |
|---|---|---|
| 2x cross-coupled NMOS (low side) | W = 2000 um each | 0.004 mm^2 |
| 2x PMOS (high side) | W = 2000 um each | 0.004 mm^2 |
| 2x zero-crossing comparator | 100 ns delay (relaxed from HF) | 0.005 mm^2 each, 0.01 mm^2 total |
| Static-trim offset DAC | 4-bit; one-shot per part at test | 0.002 mm^2 |

**Architecture-specific area: ~ 0.02 mm^2** — close to the 0.009 mm^2
reported by [ChaPark2012] at 0.18 um CMOS, scaled up to GF180's
0.18 um-class density.

### AS-B4 (digitally-adaptive delay-comp) — [Khan2018-Energies], [LeeKim2021-Energies]

Adds (over AS-B3):

| Block | Spec | Area |
|---|---|---|
| Replica delay line | Tracks comparator propagation delay | 0.003 mm^2 |
| 3-bit ADC for delay readout | Slow (~1 kHz update) | 0.005 mm^2 |
| Calibration ROM | Stores per-corner offset trim | 0.001 mm^2 |
| Digital control FSM | ~1 kgates synth | 0.015 mm^2 |

**Architecture-specific area: ~ 0.05 mm^2** — consistent with
[Khan2018-Energies]'s reported total receiver-IC area of 0.18 mm^2 in
0.18 um CMOS (with most of that being the LDO and clamp).

### AS-B5 (R^3 rectifier modified for off-resonant) — [ChengKi2017] inspired

Cannot be directly reproduced at Qi LF without ~140 mm^2 of MIM. A
*modified* version replaces the switched-cap detune bank with a
coil-shorting FET:

| Block | Spec | Area |
|---|---|---|
| 4x sync-rect FETs (cross-coupled) | As B3 | 0.008 mm^2 |
| Coil-shorting FET | W = 5000 um; controls energy dump | 0.005 mm^2 |
| Hysteretic shorting controller | Vrect comparator -> SR latch -> driver | 0.003 mm^2 |
| Boost-trap drive for shorting FET | Charge pump for high-side gate | 0.005 mm^2 |

**Architecture-specific area: ~ 0.02 mm^2** — but with substantially
larger control-loop design effort. **This is a Stage-3 deep-dive
candidate, not a Stage-1 picked solution.**

### AS-B6 (triple-mode auto-select) — [QuangHa2015-WideTriple]

| Block | Spec | Area |
|---|---|---|
| 4x sync-rect FETs (large) | W = 5000 um | 0.04 mm^2 |
| 4x passive bridge diodes (small) | Cold-start | 0.002 mm^2 |
| Mode-detect comparator | Vrect threshold 1.5 V vs 3 V | 0.003 mm^2 |
| Mode-select FSM | 3-state; hysteresis | 0.001 mm^2 |

**Architecture-specific area: ~ 0.05 mm^2**.

### AS-C1 (multi-feedback LDO) — [Khan2018-Energies]

| Block | Spec | Area |
|---|---|---|
| Pass-PMOS | W = 2000 um; 30 mA | 0.005 mm^2 |
| Primary error amp | DC loop | 0.008 mm^2 |
| AC ripple feed-forward path | Tracks rectifier ripple | 0.002 mm^2 |
| Frequency-compensation cap | 50 pF Miller | 0.025 mm^2 |

**Architecture-specific area: ~ 0.04 mm^2** — the largest single
block in [Khan2018-Energies]'s breakdown (~25 % of their reported
0.18 mm^2 total).

### AS-D3 (full WPC compliance digital) — [Khan2018-Energies], [Wu2020-AICSP]

| Block | Spec | Area |
|---|---|---|
| ASK back-channel modulator | NMOS shunt across antenna | 0.001 mm^2 |
| Modulator gate driver | Drives 4 pF in 1 us | 0.0002 mm^2 |
| Qi packet framer (HDL) | Manchester encode + CRC-8 + bit-stuff | 0.03 mm^2 |
| Qi state machine | All 6 phases, error handling | 0.15 mm^2 |
| Qi LF clock | ~10 kHz, +/-10 % | 0.005 mm^2 |
| Power-loss accounting (FOD) | 12-bit MAC | 0.03 mm^2 |
| Identification ROM | 256 bits | 0.005 mm^2 |
| CEP timer | 250 ms | 0.003 mm^2 |

**Architecture-specific area: ~ 0.22 mm^2** — consistent with
[Khan2018-Energies]'s reported digital-block area of "approximately
3 kgates" (extrapolated to ~0.05 mm^2 of pure synth, plus the FOD
MAC and ROM).

## Cumulative die-area estimates (academic-survey reproduction)

| Architecture | + common | + arch-specific | Total |
|---|---|---|---|
| AS-B1 + AS-C1 (passive bridge + LDO) | 0.10 | 0.044 | **0.14 mm^2** |
| AS-B2 + AS-C1 | 0.10 | 0.044 | **0.14 mm^2** |
| AS-B3 + AS-C1 (sync rect + multi-fb LDO) | 0.10 | 0.06 | **0.16 mm^2** |
| AS-B4 + AS-C1 (delay-comp + LDO) | 0.10 | 0.09 | **0.19 mm^2** |
| AS-B5 (R^3 off-resonant modified) | 0.10 | 0.02 | **0.12 mm^2** |
| AS-B6 + AS-C1 (triple-mode + LDO) | 0.10 | 0.09 | **0.19 mm^2** |
| AS-B3 + AS-C1 + AS-D3 (full compliance) | 0.10 | 0.28 | **0.38 mm^2** |

For a 1 mm^2 die, every option except the full-compliance one fits
with margin for NFC, 2.4 GHz, oscillator, eFuse, and core. **The
full-compliance reproduction (~0.38 mm^2) is roughly the same total
area as first-principles FP-5** — consistent across reports.

## Cross-reference to first-principles inventory

| Academic-survey topology | First-principles topology | Notes |
|---|---|---|
| AS-B1 (passive PN bridge) | FP-1's B1 | Identical |
| AS-B2 (native-NMOS bridge) | FP-2's B2 | Identical |
| AS-B3 (cross-coupled comparator-driven) | FP-3's B3 | Identical |
| AS-B4 (digitally-adaptive delay-comp) | First-principles does not separate | New axis from this report |
| AS-B5 (R^3 modified) | FP-3's C5 (detuning regulation) | Same idea; this report shows the published-paper provenance and the LF-cap-budget barrier |
| AS-B6 (triple-mode auto-select) | First-principles does not separate | New axis from this report |
| AS-C1 (multi-feedback LDO) | C1 | Same; this report adds multi-feedback variant |
| AS-C2 (CEP-adjusted Vrect) | C-via-D3 | Same |
| AS-D3 (full WPC compliance) | D3 | Same |

The academic survey adds two new axes (AS-B4 digitally-adaptive
delay-comp; AS-B6 triple-mode auto-select) that first-principles
did not separately enumerate but that exist as silicon prior art.
