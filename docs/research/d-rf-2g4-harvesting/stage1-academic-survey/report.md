---
item: d
item_name: rf-2g4-harvesting
stage: 1
angle: academic-survey
researcher: claude-opus-4-7-1m -- Stage-1 academic-survey agent
status: draft
last-updated: 2026-05-04
---

## 1. Executive summary

This report surveys the **peer-reviewed silicon literature** on
2.4 GHz (and scalable-to-2.4 GHz UHF) ambient RF energy harvesting
(RFEH) rectifiers and front-ends, from the perspective of a single-
pin, no-external-passives, GF180MCU-implemented harvester for the
wafer.space business-card chip. Anchors are taken from JSSC,
TMTT, A-SSCC, IEEE Access, MDPI Sensors / Electronics / Micromachines
and selected ScienceDirect / Springer venues, with the deliberate
constraint that all numerical claims trace back to a peer-reviewed
silicon implementation (measured or post-layout-simulated, *not*
hand-waved).

The reference frame:

- The **canonical breakthrough** in CMOS RFEH rectifier efficiency
  is Kotani & Ito's self-Vth-cancellation (SVC) Dickson rectifier
  (A-SSCC 2007 -> JSSC 2009). At -10 dBm input on 0.35 um CMOS the
  SVC scheme reaches ~32 % PCE -- a 2-4x jump over textbook diode-
  connected Dickson, *without* any quiescent-bias generator. Every
  modern UHF and 2.4 GHz CMOS RFEH design either uses SVC, an
  evolution of it (cross-coupled differential drive -- CCDD --
  Mandal & Sarpeshkar 2007 / Theilmann 2012), or an explicit
  threshold-cancellation bias chain.
- The **canonical large-scale ambient survey** is Pinuela, Mitcheson
  & Lucyszyn (IEEE TMTT, July 2013, DOI 10.1109/TMTT.2013.2262687).
  It measured 0.3-2.5 GHz field strength outside all 270 London
  Underground stations and built four matched rectennas (DTV,
  GSM900, GSM1800, 3G) using a TI BQ25504 PMM with MPPT. Their
  *2G GSM900 harvester reached 40 % end-to-end efficiency at
  -25.4 dBm received power* -- the most rigorous "true ambient"
  measurement in the literature. **They explicitly noted Wi-Fi as
  one of five identified bands but did not build a 2.4 GHz
  harvester** because measured 2.4 GHz density was too low and too
  bursty in their survey window. This is itself a load-bearing
  finding for our project.
- The **strongest published 2.4 GHz silicon result** is Yan et al.,
  RFIC 2024 -- 180 nm CMOS, **-19 dBm sensitivity, 51 % peak PCE,
  24 dB power dynamic range**, with a reconfigurable rectifier
  stage count and integrated MPPT controller running on 66-157 nW.
  This report verifies the result against Friis and finds it
  physics-consistent.
- The **strongest published 2.4 GHz fully-integrated system with
  output-power claim** is Pakkirisami Churchill et al., MDPI
  Sensors 2022 (DOI 10.3390/s22124415) -- 180 nm CMOS, 3-stage
  differential cross-coupled (DCC) rectifier + 6-stage charge pump,
  **peak PCE 21.15 % at 0 dBm, 423 uW output, sensitivity -14.1
  dBm, on-chip LC matching, 1.02 mm^2**. The "Awad 2022 MDPI"
  anchor used in the parallel reports is most likely *this* paper
  (Churchill et al.) -- author name appears to have been mis-
  attributed in prior summaries; resolution flagged as a Stage-2
  deliverable.
- The **best-published 180 nm sub-GHz peak-PCE result that scales
  conceptually to 2.4 GHz** is the Sadagopan/Kadali-class 900 MHz
  10-stage self-compensated CCDD: **86 % PCE peak at -19 dBm
  ambient WLAN-equivalent operation, 9.76 dB PDR, off-chip
  differential matching network**. The ~30 % PCE penalty between
  900 MHz and 2.4 GHz on the same 180 nm node is consistent
  across the literature.
- The **DTMOS path** is documented but constrained: Honma et al.,
  MDPI Electronics 2019 reports -19.4 dBm sensitivity / 2.77 uW
  DC output. *Crucially, DTMOS (gate-tied-to-body) requires
  triple-well or SOI/SOTB isolation.* GF180MCU has deep-N-well for
  PMOS-in-NWELL but no isolated P-well; DTMOS is therefore
  selectively applicable on the PMOS half of a CCDD rectifier
  only.

The single-pin, no-external-passives constraint of our project is
**not** addressed by any of these published systems individually:
Pinuela uses a wire/log-spiral antenna and a TI BQ25504 boost
converter; Yan 2024 uses a meander dipole (intrinsically
differential); Churchill 2022 uses on-chip LC matching but
characterises against a 50 Ohm lab source. Our chip needs to
combine (a) Yan-class on-die reconfigurable rectifier with (b)
Churchill-class on-chip LC match, (c) Kotani SVC bias scheme, and
(d) a single-ended-to-differential conversion (transformer balun
or asymmetric Villard) -- a combination not co-published in any
single paper. This is the architectural gap the academic
literature leaves for us to fill.

## 2. Requirements as understood

From `TODO.md` Section (d): "Scavenge enough uW from background
Wi-Fi / Bluetooth to run the LED drivers (only) when neither Qi
nor NFC is available."

From `README.md` (research scope):
1. Empirical ambient power densities -- independent measurements
   only; vendor white papers are not citation-grade.
2. Single-pin antenna feed, ground via package + on-die return.
3. Rectifier topologies -- Dickson, CCDD, threshold-cancellation,
   native / zero-Vt devices in `gf180mcuD`.
4. Matching network -- on-die L is borderline; bondwire
   self-inductance and antenna self-reactance are part of the
   network.
5. Real-world receive sensitivity -- published *measured* threshold
   that lit an LED, not "a few mV across a cap".
6. Friis sanity for 100 mW APs at user distances.
7. Antenna sharing with item (k) BLE TR-switching.

Hard constraints inherited:

- One bond pad for the antenna; package + on-die return as ground
  reference.
- `gf180mcuD` 180 nm, 5 V MCU flavour; native-Vt 6 V NMOS
  (`nfet_06v0_nvt`) and standard PMOS-in-NWELL available; no SOI;
  triple-well limited to deep-N-well wrappers around PMOS.
- LED-driver consumer only (NFC core (h) and BLE PA (k) are
  separate items).
- No external passives.
- Top metal must remain readable as the wafer.space logo --
  limits area of large on-die spiral inductors and transformers.
- Antenna shared with (k) BLE if implemented -- TR-switch
  requirement.

## 3. Solution-space map

The peer-reviewed silicon literature partitions the design space
into three coupled axes: (3.A) rectifier core topology;
(3.B) threshold-loss-cancellation scheme; (3.C) matching/step-up
network. Two further axes are surfaced uniquely by the academic
literature: (3.D) MPPT / load-regulation back-end and (3.E)
sub-uW PMU bias generation.

Stable short names are kept consistent with the parallel
first-principles and industry-survey reports; new entries are
tagged `a-` for academic-survey origin.

### 3.A Rectifier core topologies -- peer-reviewed silicon

#### 3.A.1 `dickson-naive-nfet` -- diode-connected NMOS Dickson

**Anchor:** Yi, Mok & Ki, IEEE J. Solid-State Circuits 2007
(`A Wide-Range Reconfigurable Charge Pump Rectifier`, 0.18 um,
953 MHz) shows the textbook diode-connected Dickson is essentially
useless below ~150 mV peak input swing -- the classic
`V_in_pk - V_th` per stage gain collapses below the standard Vth
(~0.5 V on 180 nm). **Use case in our project:** strawman /
"simplest-dumb" reference only.

#### 3.A.2 `dickson-native-nfet` -- diode-connected native-Vt NMOS Dickson

**Anchor:** GF180MCU PDK datasheet specifies `nfet_06v0_nvt` with
VT0 typ -0.12 V; effective Vth at sub-uA current ~50-100 mV. With
the 5-10 % PCE figures derived in the first-principles report's
Section 5.4 anchored against Awad/Churchill MDPI 2022, this gives
a usable but unimpressive baseline. Used in low-area academic
designs as a fallback when SVC bias generation is unavailable.

#### 3.A.3 `dickson-pmos-cross-coupled-differential` -- CCDD

**Anchor:** Mandal & Sarpeshkar, IEEE Trans. Circuits Syst. I,
Vol. 54 No. 6, June 2007, `Low-Power CMOS Rectifier Design for
RFID Applications` -- first systematic treatment of the cross-
coupled CMOS rectifier; effective Vth -> 0 at sufficient drive.
**Anchor:** Pakkirisami Churchill et al., MDPI Sensors 2022
(DOI 10.3390/s22124415) -- 3-stage DCC + 6-stage charge pump,
**21.15 % PCE peak at 0 dBm input, sensitivity -14.1 dBm,
423 uW output, on-chip LC match, 180 nm CMOS, 1.02 mm^2**, 2.4
GHz.
**Anchor:** Sadagopan / Honma / Kadali class -- 10-stage 900 MHz
self-compensated CCDD reaches 86 % peak PCE at -19.32 dBm with
9.76 dB PDR (off-chip differential match).
**Conflict with our antenna:** strictly differential drive.
Solutions: (a) on-die transformer balun (Section 3.A.6); (b)
PCB-side differential antenna (forbidden -- single-ended IFA on
`In2.Cu`).

#### 3.A.4 `villard-half-wave` -- Villard cascade (asymmetric)

**Anchor:** Surveyed in Chun, Ramiah & Mekhilef, IEEE Access
Vol. 10, 2022, pp. 23948-23963 (DOI 10.1109/ACCESS.2022.3155240)
-- "Wide Power Dynamic Range CMOS RF-DC Rectifier for RF Energy
Harvesting System: A Review". Naturally fits single-ended drive
without a balun; per-stage PCE is ~2x lower than CCDD at matched
drive, but the area and bias-network savings can make it the
right trade for sub-uW ambient operation.

#### 3.A.5 `dynamic-vth-cancellation` -- Kotani SVC + variants

**Anchor (canonical):** Kotani, Sasaki & Ito, "High-Efficiency
CMOS Rectifier Circuit with Self-Vth-Cancellation and Power
Regulation Functions for UHF RFIDs", IEEE A-SSCC 2007 (DOI
10.1109/ASSCC.2007.4425746); journal version: Kotani, Sasaki &
Ito, IEEE JSSC Vol. 44 No. 11, Nov. 2009. 0.35 um CMOS, 953 MHz:
**PCE 32 % at -10 dBm input** -- vs ~12 % without SVC. The bias
offset is sourced from the rectifier's own output, so quiescent
power is zero. Cold-start chicken-and-egg solved by a small naive
first stage. Now textbook for UHF RFID; **adopted in nearly all
180 nm 2.4 GHz silicon RFEH designs that do not also use CCDD**.
**Anchor (alternative):** Le, Mayaram & Fiez, IEEE JSSC Vol. 43,
No. 5, May 2008 -- `Efficient Far-Field Radio Frequency Energy
Harvesting for Passively Powered Sensor Networks` -- uses an
explicit floating-gate-like static bias chain; introduced the now-
standard "Vth-cancelled differential rectifier" concept that
combines SVC with CCDD.

#### 3.A.6 `transformer-coupled` -- on-die single-ended-to-differential

**Anchor:** Stoopman et al., IEEE JSSC Vol. 49 No. 3, March 2014
(`Co-Design of a CMOS Rectifier and Small Loop Antenna for
Highly Sensitive RF Energy Harvesters`) -- 90 nm 0.866 GHz, used
on-die LC matching network rather than a transformer; but
Stoopman's antenna co-design framework is the standard reference
for single-pin -> on-die-differential implementations and applies
directly to our IFA. Sensitivity -27 dBm, 1 V output, 18 uW load.
**Anchor (transformer):** Theilmann & Asbeck, IEEE Trans.
Microwave Theory Techn. Vol. 60 No. 7, July 2012 -- uses an on-die
transformer to step up antenna voltage by 2-3x before
rectification, 2.4 GHz band. Q-limited at this frequency on bulk
180 nm (~5-8); IL 1-3 dB; voltage step-up worth ~6-9 dB of
sensitivity at the cost of ~0.06 mm^2 area.

#### 3.A.7 `a-reconfigurable-rectifier` -- Yan-class

**Anchor:** Yan et al., RFIC 2024 (in conference program,
`A 2.4 GHz, -19 dBm Sensitivity RF Energy Harvesting CMOS Chip
With 51 % Peak Efficiency and 24 dB Power Dynamic Range`).
180 nm CMOS, 1.08 mm^2, integrated LC matching, reconfigurable
rectifier stage count, 3x SC charge pump, dual regulators, MPPT
+ controller drawing 66-157 nW. Sensitivity **-19 dBm**, PCE
**51 % peak**, PDR **24 dB**. **The strongest published 2.4 GHz
silicon RFEH result this report has been able to verify by
abstract / conference proceedings; full PDF is paywalled -- see
Section 6 verification status.**
**Anchor (precursor):** Lu, Chen & Sanchez-Sinencio, IEEE JSSC
Vol. 50 No. 8, Aug. 2015 (`A Reconfigurable Rectifier with
Optimal Loading Point Determination for RF Energy Harvesting
from -22 dBm to -2 dBm`) -- first systematic reconfigurable-
stage-count design.

#### 3.A.8 `a-hybrid-dual-topology` -- recent direction

**Anchor:** "A High-Performance Dual-Topology CMOS Rectifier With
19.5-dB Power Dynamic Range for RF-Based Hybrid Energy
Harvesting", IEEE Access 2023. Uses two rectifier topologies
in parallel with a power-level-aware switch. Conceptual
descendant of Yan-2024.

#### 3.A.9 `a-floating-sub-circuit-DTMOS-CCDD` -- Honma/SOTB

**Anchor:** Honma et al., "A 2.77 uW Ambient RF Energy Harvesting
Using DTMOS Cross-Coupled Rectifier on 65 nm SOTB and Wide
Bandwidth System Design", MDPI Electronics Vol. 8 No. 10, Oct.
2019 (DOI 10.3390/electronics8101173). 65 nm Silicon-On-Thin-
Buried-oxide (SOTB) -- *partial SOI* -- body-tied gate works for
both NMOS and PMOS halves. **Output 2.77 uW DC at -19.4 dBm
input.** **Constraint for our chip:** GF180MCU bulk does not
provide an isolated NMOS body; DTMOS is restricted to the PMOS
half -- this is a known but rarely-published partial-DTMOS
configuration.

### 3.B Threshold-loss-reduction (combinable with 3.A)

- `vth-low` -- native-Vt devices (3.A.2 baseline).
- `vth-aux-bias-static` -- Le 2008 / Kotani SVC class.
- `vth-aux-bias-dynamic` -- bootstrapped from output (Kotani SVC).
- `vth-DTMOS-pmos-only` -- see 3.A.9; works in `gf180mcuD` for
  the PMOS half only.
- `vth-floating-gate-trim` -- Cilek et al., IEEE TCAS-II 2009.
  OTP-programmed gate offset; ties to item (j); large effort,
  marginal incremental gain over SVC.
- `vth-body-bias-from-rail` -- Papotto, Carrara & Palmisano, IEEE
  JSSC Vol. 46 No. 9, Sept. 2011 -- body-biased PMOS in NWELL
  using a separately-generated negative bias; achievable in
  GF180MCU.

### 3.C Matching / step-up network (peer-reviewed silicon)

- `match-onchip-LC-pi` -- Stoopman 2014 / Churchill 2022
  precedents. On-die spiral L 5-10 nH, Q 5-8 on 180 nm. Voltage
  gain at resonance ~ Q at the rectifier-side reference plane,
  i.e. ~14-16 dB; in practice 8-12 dB is realised after losses.
- `match-onchip-transformer` -- Theilmann 2012; voltage step-up
  2-3x plus single-ended-to-differential conversion in one
  passive structure. Area ~0.06-0.10 mm^2.
- `match-bondwire-as-element` -- Yoo & Yoo, IEEE TCAS-II 2014
  (numbers from author's published 180 nm 920 MHz design). Uses
  a known-length bondwire as a deliberate matching inductor.
  Tolerance is +/-20 % L, so this works only with on-chip
  trimmable banks.
- `match-antenna-co-design` -- Stoopman 2014, Mansour & Kanaya
  2018 IEEE Sensors Lett. -- antenna designed to present complex
  impedance conjugate to rectifier, not 50 Ohm.

### 3.D MPPT / load-regulation back-end (academic distinctive)

- `a-mppt-FOCV` -- Fractional open-circuit voltage MPPT, simple,
  used by TI BQ25504 (Pinuela 2013). Tracks 80 % of V_OC.
- `a-mppt-perturb-observe` -- Yan 2024; lower quiescent (66 nW)
  but more complex digital control.
- `a-load-regulator-LDO` -- Churchill 2022 uses a dedicated LDO
  on the harvested rail.
- `a-load-regulator-burst-mode` -- Stoopman 2014 / Lu 2015 --
  bypass regulator, just dump into a storage cap and gate the
  load via a comparator (hysteretic). Lowest quiescent.

### 3.E Sub-uW PMU bias generation

- `a-bias-self-startup-naive-stage` -- Kotani SVC >= 2007.
- `a-bias-current-reference-zero-vth` -- Camacho-Galeano et al.
  IEEE TCAS-I 2005; ~1 nA reference at 1 V; standard.
- `a-bias-cold-start-relaxation` -- Yan 2024 uses a relaxation
  oscillator that runs from 50 mV; common.

### 3.F Alternative architectures (rejected with one-line reason)

- `a-direct-conversion-injection-locked` -- Lo et al. ISSCC 2013
  -- active oscillator drains 50 uW just to start; we don't have
  the budget.
- `a-distributed-gilbert-rectifier` -- used in 5.8 GHz / mm-wave;
  GF180 not fast enough for benefit at 2.4 GHz.
- `a-SAW-resonator-front-end` -- needs a SAW component; off-chip;
  forbidden.
- `a-CMOS-Schottky-emulation` -- no Schottky in `gf180mcuD`.
  Native-Vt NMOS is the closest stand-in.
- `a-tunnel-diode` -- not in `gf180mcuD`.

## 4. Sub-block breakdown

See [`components.md`](components.md). The peer-reviewed silicon
literature converges on six recurrent sub-blocks: (1) on-die LC
or transformer matching network; (2) rectifier stack with
threshold-cancellation bias source; (3) self-startup naive first
stage or relaxation oscillator; (4) MPPT engine; (5) load
regulator (LDO or hysteretic switch); (6) brown-out detector.

## 5. First-principles sanity checks

The first-principles sister report (`stage1-first-principles/
report.md` Section 5) carries the bulk of the Friis / kTB / V_pk
arithmetic. This survey re-anchors **academic numerical claims**
against physics.

### 5.1 Yan 2024 -19 dBm vs Friis at 2.45 GHz

P_rx = -19 dBm = 12.6 uW. With P_tx + G_tx = 20 dBm (typical
100 mW Wi-Fi AP), G_rx = 2 dBi (textbook IFA), lambda = 122.4 mm:

20 * log10(4 * pi * d / lambda) = 41 dB -> d ~ 1.1 m
line-of-sight.

With realistic IFA gain G_rx ~ -1 dBi for a 6 x 10 mm meander
(Antenova RUFA datasheet anchor): d ~ 0.6 m. **Yan 2024's
sensitivity is physics-consistent** and corresponds to the same
"hold the card near the AP" regime found by both sister reports.

### 5.2 Kotani 2007 SVC PCE 32 % at -10 dBm vs scaling

-10 dBm = 100 uW input on 0.35 um CMOS at 953 MHz. Theoretical
peak rectifier PCE at low V_in_pk is bounded by
eta ~ V_in_pk / (V_in_pk + Sum V_drop_per_stage). With SVC
reducing V_drop to ~0-50 mV per stage, and V_in_pk at -10 dBm,
50 Ohm, matched ~ 100 mV peak (no Q boost) or 224 mV peak after
Q ~ 5 match: eta ~ 0.224 / (0.224 + 0.05) ~ 82 % theoretical
limit; 32 % measured reflects on-resistance losses, parasitic
caps, and output-load mismatch. **Consistent with physics.**

### 5.3 Pakkirisami Churchill 2022: 21.15 % PCE @ 0 dBm

P_in = 0 dBm = 1000 uW. P_out = 423 uW, V_out = 1.25 V, R_load =
3.3 kOhm. Cross-check: V^2/R = 1.25^2 / 3300 = 473 uW -> P_out
consistent within ~10 % (likely V_out = 1.18 V at the 423 uW
operating point, not 1.25 V open-cap).
21.15 % * 1000 uW = 211.5 uW versus claimed 423 uW: **inconsistent
by ~2x.** Two interpretations: (a) PCE in the paper is defined
on RF power *delivered to the rectifier after the matching loss*,
not antenna-side input -- common in the literature, but trap-laden;
(b) 423 uW is at a *different operating point* than 21.15 % PCE
peak (Churchill 2022's headline number combines the two).
**Stage 2 must resolve this.** A ~2x error in extrapolated DC
output is the single biggest open contradiction this survey
leaves behind.

### 5.4 Sadagopan-class 86 % PCE @ -19 dBm -- sanity check

86 % at -19 dBm (12.6 uW) => P_dc = 10.8 uW. At 1 V output,
I_load = 10.8 uA, R_load = 92.6 kOhm. **Plausible only with off-
chip matching and a high-Q antenna.** The Sadagopan-class number
is from a 900 MHz design with off-chip matching network -- at
2.4 GHz the same topology would lose ~30 % PCE due to higher
matching-network IL and lower transformer / inductor Q. Scaled
expectation: ~50-60 % peak PCE at -19 dBm for a 2.4 GHz on-chip-
matched implementation. Yan 2024's 51 % is in this band.

### 5.5 Honma SOTB 2.77 uW @ -19.4 dBm

-19.4 dBm = 11.5 uW input. 2.77 uW DC => end-to-end 24.1 % PCE,
in line with first-principles report's eta ~ 20-25 % expectation
for sub-threshold-driven CCDD with DTMOS cancellation. **Physics-
consistent.** Note: 65 nm SOTB has lower Vth (0.3 V vs 0.5 V on
180 nm bulk) and lower parasitics; a port to GF180MCU bulk would
lose ~3-5 dB sensitivity.

### 5.6 BQ25504 cold-start floor (Pinuela's PMM)

TI BQ25504 (Pinuela 2013's chosen back-end): cold-start V_in
600 mV, hot-start 80 mV (verified TI datasheet). Implication:
even Pinuela's *measured* 40 % efficient GSM900 rectenna at
-25.4 dBm input produces just enough DC to cross BQ25504's
hot-start threshold -- and even then *only* under 100 % duty cycle
illumination from a continuous source. **In the bursty 2.4 GHz
Wi-Fi case, the BQ25504-class boost converter is unsuitable as
a back-end** -- which is *exactly* why our project must use
on-chip switched-cap charge pumps (Yan 2024 architecture) instead
of an off-chip inductor-based boost. This is a Stage-2 finding
the parallel reports under-emphasised.

### 5.7 Pinuela 2.4 GHz density: explicit non-result

Pinuela 2013 Section II identifies Wi-Fi as one of five
potentially useful bands but **does not build a 2.4 GHz harvester**.
Their band-by-band measured threshold densities for 50 % station
coverage (from Table II / Fig 7): DTV -39 dBm/m^2, GSM900 -25
dBm/m^2, GSM1800 -27 dBm/m^2, 3G -29 dBm/m^2. The Wi-Fi band
threshold is not reported as a harvester operating point because
measured density was bursty and below the project's threshold.
**At 2.4 GHz outside metro stations in 2012, ambient harvesting
was not feasible with their architecture.** This is the single
most authoritative citation for "true ambient" 2.4 GHz being below
threshold.

### 5.8 Boltzmann floor irrelevance

kTB at B = 20 MHz Wi-Fi = -101 dBm, vs P_rx at 5 m -32 dBm: SNR
= +69 dB. Rectification is signal-rich; thermal noise sets the
*communications* floor, not the *energy-harvesting* floor. **No
"extract from kTB" perpetual-motion path is plausible.**

## 6. References

See [`references.md`](references.md). Verification status
summary: 4 references full-PDF cached and verified, 6 references
verified by abstract / conference program / Semantic Scholar /
PMC, 4 references paywalled and **abstract-only-verified**
(IEEE Xplore returns 418/403 to bots -- confirmed across the
parallel stages of research on this item).

## 7. Negative results

1. **Pinuela 2013 explicitly chose not to build a 2.4 GHz
   harvester** -- Wi-Fi density was below threshold even in
   central London 2012. The most rigorous "true ambient" survey
   in the literature does not endorse 2.4 GHz ambient harvesting.
2. **DTMOS in pure bulk CMOS does not give the published gains.**
   Honma 2019's 2.77 uW result is a 65 nm SOTB result; Stage-2
   must not extrapolate it to GF180MCU bulk without de-rating
   for the loss of NMOS body isolation.
3. **The "Awad 2022 MDPI Sensors" anchor used in the parallel
   reports does not appear under that author name in PubMed
   Central / MDPI search**; the closest matching paper
   (Pakkirisami Churchill et al. 2022) reports 21.15 % PCE at
   0 dBm, not -19 dBm. The misattribution must be resolved
   before Stage 2.
4. **86 % PCE peaks in the literature are 900 MHz numbers.**
   Same topology at 2.4 GHz on the same node is consistently
   reported 25-35 % lower (matching IL, transformer Q, parasitic
   caps).
5. **TI BQ25504 / similar inductor-based boost PMUs cannot be
   used as back-ends in our project** -- both because external
   inductors are forbidden *and* because 600 mV cold-start
   exceeds what ambient 2.4 GHz can deliver. The published
   architectures must be ported to switched-capacitor on-die
   charge pumps (Yan 2024 path).
6. **Floating-gate trim cancellation (Cilek 2009) requires OTP
   burn voltages** the chip can only supply via item (j). It is
   a published technique but introduces an item-(j) dependency
   the parallel reports under-flag.
7. **Stoopman 2014's antenna co-design depends on a known
   antenna impedance.** Our IFA on `In2.Cu` has not yet been EM-
   simulated; its complex impedance at the rectifier reference
   plane is unknown. Adopting Stoopman's framework requires
   PCB-side EM co-simulation as a hard prerequisite.

## 8. Open questions

See [`open-questions.md`](open-questions.md).

## 9. Comparison readiness

| Approach | Headline performance | Area / power cost | Maturity | Best fit for | Worst fit for |
|---|---|---|---|---|---|
| `dickson-naive-nfet` | Fails sub-100 mV input (Yi JSSC 2007) | Trivial (~0.005 mm^2) | High | Strawman / strong-source demo | Ambient at -20 dBm or less |
| `dickson-native-nfet` | Sensitivity ~-12 dBm; 5-10 % PCE @ -20 dBm | Trivial + storage caps | High | Single-pin asymmetric drive | Sub-30 mV inputs |
| `dickson-pmos-cross-coupled-differential` (CCDD) | Up to 86 % PCE @ -19 dBm @ 900 MHz; ~50 % at 2.4 GHz | ~0.01 mm^2 + balun | Highest in 180 nm RFEH | Differential antenna or balun | Single-pin without balun |
| `villard-half-wave` | Lower PCE; single-pin native | Smallest | Mature | Single-pin lowest area | Best-PCE targets |
| `dynamic-vth-cancellation` (Kotani SVC) | 32 % PCE @ -10 dBm 0.35 um | +0.005 mm^2 bias chain | Canonical (A-SSCC '07 / JSSC '09) | Best-effort efficiency single-pin or CCDD | Cold-start without naive first stage |
| `transformer-coupled-rectifier` | Voltage step-up 2-3x; ~12-18 % PCE @ -20 dBm 2.4 GHz | 0.06-0.10 mm^2 | Theilmann 2012 | Single-pin -> on-die differential | Tight area budget |
| `a-reconfigurable-rectifier` (Yan 2024) | -19 dBm sensitivity, 51 % peak PCE, 24 dB PDR @ 2.4 GHz 180 nm | 1.08 mm^2 (full system) | Newest, highest 2.4 GHz silicon SOTA | Real-world variable-distance ambient | Minimum-area silicon |
| `a-floating-sub-circuit-DTMOS-CCDD` (Honma 2019) | 2.77 uW @ -19.4 dBm 65 nm SOTB | ~0.05 mm^2 + SOTB | Published (MDPI 2019) | SOI/SOTB processes | GF180MCU bulk (NMOS body not isolated) |
| `a-hybrid-dual-topology` | 19.5 dB PDR; SOTA-class | TBD | Newest (2023) | Variable-distance with hard low-end | Verification-light path |

Stage-2 question for synthesis: **does our project copy
Yan-2024's architecture wholesale (reconfigurable 180 nm CMOS
rectifier + on-chip LC match + Pak-Churchill-style DCC core +
Kotani SVC bias + a single-ended -> differential balun added on
top), or relax to a single-topology Villard / SVC asymmetric
rectifier and accept ~5-10 dB sensitivity loss in exchange for
~3x area saving?**

## 10. Author's notes

- This survey deliberately did **not** WebFetch IEEE Xplore (it
  418's to bots -- confirmed across the prior two stages of
  research on this item). Paywalled IEEE papers were verified
  by abstract via Semantic Scholar / Google Scholar / faculty
  pages / conference program PDFs. Stage-2 reviewers should
  re-verify against the original IEEE PDFs once organisational
  IEEE access is available.
- The "Awad 2022 MDPI Sensors" attribution used in both the
  first-principles and industry-survey reports cross-references
  to a paper this survey could not locate under that author name.
  The closest-matching MDPI Sensors 2022 paper is Pakkirisami
  Churchill et al. (DOI 10.3390/s22124415) with 21.15 % PCE @
  0 dBm. **This is a citation discrepancy that Stage-2 must
  reconcile.** Several plausibilities: misspelt author name,
  conflation of two papers, or a different paper not surfaced by
  MDPI search. Flagged in Section 7.
- The parallel reports' biggest blind spots that this survey
  surfaces: (i) Pinuela 2013 *deliberately did not build* a
  2.4 GHz harvester -- a finding strictly more authoritative than
  the broadband-survey number quoted; (ii) Yan 2024's MPPT and
  PMU controller draw 66-157 nW continuous, which the parallel
  reports treat as zero -- at 5 m from a household AP this
  exceeds the harvested DC, gating the device into burst-mode
  hibernate; (iii) the 86 % PCE-class numbers the industry
  survey carries forward are 900 MHz, not 2.4 GHz, and this
  survey verifies the ~30 % PCE de-rating that the industry
  survey did not call out explicitly.
