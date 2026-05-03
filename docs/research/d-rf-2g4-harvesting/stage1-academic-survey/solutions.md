# Architectures / topologies surveyed -- Stage-1 academic survey, item (d)

This file lists the **distinct architectural compositions** that
the peer-reviewed silicon literature offers for ambient 2.4 GHz
RFEH on a 180 nm-class CMOS node, ordered from "simplest dumb"
to "most sophisticated". Each entry names the topology, cites a
peer-reviewed silicon implementation, and scores it against the
wafer.space project's hard constraints (single-pin antenna; no
external passives; LED-twinkle consumer; logo-friendly area).

## S1. `naive-dickson-monomode`

**Composition:** N-stage diode-connected NMOS Dickson; LC pi
or transformer match; LDO; storage cap.

**Reference silicon:** Yi, Mok & Ki, IEEE JSSC 2007 (0.18 um,
953 MHz baseline measurements).

**Performance:** Sensitivity ~-5 dBm; PCE 5-15 % at -10 dBm
input. Useless below ~150 mV peak input swing.

**Project verdict:** strawman / "simplest-dumb" reference.

## S2. `native-vt-dickson-monomode`

**Composition:** Same as S1 but with native-Vt NMOS
(`nfet_06v0_nvt`).

**Reference silicon:** typical low-area UHF RFID tags in
180 nm-class CMOS; multiple in Chun 2022 IEEE Access review.

**Performance:** Sensitivity ~-12 dBm; PCE 5-10 % at -20 dBm.

**Project verdict:** floor-of-feasibility reference;
demonstrates "always works" trivially. Does not meet visible-
twinkle threshold past ~1 m from a 100 mW AP.

## S3. `villard-svc-asymmetric`

**Composition:** Half-wave Villard cascade with Kotani SVC
bias chain; on-chip LC pi match; SC charge pump back-end.

**Reference silicon:** Kotani SVC concept (A-SSCC 2007 / JSSC
2009); Villard implementation surveyed in Chun 2022 review.

**Performance:** Sensitivity -15 to -20 dBm; PCE 15-25 % at
-15 dBm. Naturally single-ended drive -- fits our antenna
without a balun.

**Project verdict:** **strong candidate** for our project:
single-pin compatible, well-characterised, smaller than
CCDD+balun, matches "good enough for LED twinkle" goal.

## S4. `ccdd-svc-with-balun`

**Composition:** 3-stage cross-coupled differential rectifier
with Kotani SVC bias; on-die transformer balun (Theilmann-style)
to convert single-pin antenna to differential rectifier input;
SC charge pump back-end.

**Reference silicon:** Composite of Pakkirisami Churchill 2022
(MDPI Sensors, 21.15 % PCE @ 0 dBm, 2.4 GHz, 180 nm) +
Theilmann & Asbeck TMTT 2012 (transformer balun) + Le 2008
(CCDD-SVC hybrid).

**Performance:** Sensitivity -16 to -19 dBm; peak PCE 25-50 %
at 0 dBm; ~15-25 % at -15 dBm. Higher than S3 but at ~3x area
cost.

**Project verdict:** **strong candidate** if area budget
permits. Ties together three distinct published anchors --
none of them co-implemented in any single published 2.4 GHz
chip, so this is partly novel.

## S5. `yan-2024-reconfigurable`

**Composition:** Reconfigurable-stage rectifier (4-8 stages
selectable); on-die LC match; 3x SC charge pump; dual LDOs;
P&O MPPT controller running on a 50-mV-V_DD relaxation
oscillator. **Single-pin compatible** because Yan's reference
implementation uses a meander dipole antenna with direct
differential feed -- but the *architecture* is portable to
single-pin via S4's transformer balun.

**Reference silicon:** Yan et al., IEEE RFIC 2024 (180 nm
CMOS, **-19 dBm sensitivity, 51 % peak PCE, 24 dB PDR,
1.08 mm^2**, full system measured).

**Performance:** State-of-the-art for 2.4 GHz silicon. Does
buy ~6 dB sensitivity vs S3/S4 in exchange for ~3x system
area + digital MPPT controller power (66-157 nW continuous).

**Project verdict:** **upper bound** in
performance/complexity; copy this architecture and add a
single-ended -> differential balun in front of it. Highest
sensitivity available in the literature for this band/node.

## S6. `dtmos-ccdd-pmos-only`

**Composition:** 3-stage CCDD with DTMOS body-bias on PMOS
half only (limited by GF180MCU bulk -- NMOS body cannot be
isolated); deep-N-well-isolated PMOS; on-chip LC match.

**Reference silicon:** Honma et al., MDPI Electronics 2019
(65 nm SOTB, full-CCDD DTMOS, 2.77 uW DC at -19.4 dBm).
**Partial port** to GF180MCU: DTMOS gain on PMOS only --
~2-3 dB sensitivity recovery vs S4 plain CCDD-SVC. Not the
full 6 dB that SOTB-DTMOS achieves.

**Performance:** Estimated sensitivity -17 to -19 dBm; PCE
20-30 % at -15 dBm.

**Project verdict:** **fall-back if S5 area is too costly
and S4 sensitivity is insufficient.** Adds a deep-N-well
floorplan dependency on PMOS placement.

## S7. `stoopman-co-designed-antenna-rectifier`

**Composition:** No-LC-match rectifier; antenna is designed
to present complex Z conjugate to rectifier input; 5-stage
NMOS-only diff-rectifier; LDO load regulator.

**Reference silicon:** Stoopman et al., IEEE JSSC 2014
(90 nm, 0.866 GHz, **-27 dBm sensitivity, 1 V output, 18 uW
load** -- the published silicon record for sensitivity at any
frequency).

**Performance (scaled to 2.4 GHz GF180MCU):** estimated
sensitivity -20 to -22 dBm; PCE 10-15 % at -20 dBm.

**Project verdict:** **highest potential sensitivity** if PCB
team co-designs the IFA's complex impedance to the rectifier
input. Requires PCB-side EM co-simulation as a hard
prerequisite. **Architectural fork** vs S3/S4/S5/S6 -- the
others all work with a 50-Ohm-port antenna; Stoopman's does
not.

## S8. `hybrid-dual-topology-2023`

**Composition:** Two rectifier topologies in parallel
(typically a low-power CCDD and a high-power Dickson),
power-level-aware switch selects the active one.

**Reference silicon:** "A High-Performance Dual-Topology CMOS
Rectifier With 19.5-dB Power Dynamic Range for RF-Based
Hybrid Energy Harvesting", IEEE Access 2023.

**Performance:** 19.5 dB PDR; PCE > 25 % across the entire
range.

**Project verdict:** **conceptual descendant of Yan-2024**.
Worth flagging for Stage 2 / Stage 3 but does not appear to
buy distinct value over S5 for our LED-twinkle use case.

## S9. `floating-gate-trim-cilek`

**Composition:** Single-stage rectifier with floating-gate
threshold trim; OTP-programmed gate offset cancels Vth.

**Reference silicon:** Cilek et al., IEEE TCAS-II 2009
(180 nm process, sub-GHz UHF RFID).

**Performance:** Sensitivity -22 dBm achieved with single-
stage; high PCE in narrow band.

**Project verdict:** **incompatible with our minimal-OTP
budget.** Item (j) eFuse capacity is reserved for vCard
content, oscillator trim, die ID. Adding floating-gate trim
to every rectifier stage would balloon item (j)'s scope.

## S10. `injection-locked-active-rectifier`

**Composition:** Active CMOS oscillator injection-locked to
the incoming RF signal; oscillator output drives a
synchronous rectifier; high PCE at high input.

**Reference silicon:** Lo et al., ISSCC 2013.

**Performance:** Sensitivity > -10 dBm; PCE > 60 % at -5 dBm.

**Project verdict:** **rejected** -- active oscillator
quiescent is ~50 uW (10x our entire harvested budget at 5 m).
Loses to passive rectifiers in our regime.

## Summary matrix

| Solution | Single-pin compat | Area (mm^2) | Sensitivity (dBm) | Peak PCE | Project fit |
|---|---|---|---|---|---|
| S1 naive-dickson | YES | 0.005 | -5 | 5-15 % | strawman |
| S2 native-vt-dickson | YES | 0.005 | -12 | 5-10 % | floor |
| S3 villard-svc | YES (native) | 0.02 | -17 | 20 % | strong |
| S4 ccdd-svc+balun | YES (via balun) | 0.08 | -19 | 25-50 % | strong |
| S5 yan-2024 | needs balun | 1.08 | -19 | 51 % | upper bound |
| S6 dtmos-pmos-only | YES (via balun) | 0.08 | -18 | 25-30 % | fall-back |
| S7 stoopman-co-design | YES (no match) | 0.02 | -20 to -22 | 10-15 % | best sensitivity |
| S8 dual-topology | needs balun | 0.10 | -19 | 25-50 % | flag for S2 |
| S9 floating-gate-trim | YES (single-stage) | 0.04 | -22 | 30 % | rejected |
| S10 injection-locked | YES | 0.20 | -10 | 60 % | rejected |

## Stage-2 carry-over

The shortlist of architectures that should reach Stage-3 deep
dives is **S3, S4, S5, S6, S7** -- this is 5 distinct silicon-
paper-anchored topologies, exactly the exhaustiveness bar set
by the brief. S1/S2 are strawmen kept for completeness; S8 is a
2023 dual-topology refinement of S5 (folds into the S5 deep
dive); S9/S10 are explicitly rejected with reasons above.
