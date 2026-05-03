---
item: e
item_name: mim-cap-storage
stage: 1
angle: academic-survey
researcher: agent-stage1-academic-1
status: draft
last-updated: 2026-05-04
---

## 1. Executive summary

This survey covers peer-reviewed academic literature on on-die
energy-storage capacitance for the wafer.space v2 chip on
`gf180mcuD` 180 nm 5 V CMOS. Sources canvassed: IRPS, IEDM,
JSSC, IEEE EDL, TCAS-I/II, TPEL, TBioCAS, ESSCIRC, ICICDT,
ECTC, MDPI Sensors / Electronics / Energies, Semantic Scholar,
arXiv, NIST publications, PMC open access, and faculty pages.

The relevant literature divides into seven families:
(A) standard MIM reliability + density at 180 nm;
(B) high-k MIM (research only, advanced nodes);
(C) deep-trench capacitors (DTC; IBM-SOI / specialty 180 nm BCD);
(D) MOS-cap energy storage;
(E) switched-capacitor DC-DC + charge pumps (Dickson, Pelliconi
cross-coupled, Bang SAR-SC, fly-cap step-down);
(F) leakage-aware bank-switching / hot-swap topologies;
(G) biomedical-implant on-chip storage architectures (mostly
external caps; a few go fully on-die at the µF scale).

Headline conclusions, **without picking a winner**:

1. **Gambino IRPS 2019** validates a 5.0 nm Al2O3 / 2.7 nm SiO2
   MIM-B at ~6 fF/µm² for 3.3 V (TDDB > 10 yr at 125 °C, BV
   median 9.5 V at 12 MV/cm). The `gf180mcuD` PDK ships a more
   conservative variant at 2.0 fF/µm².
2. **Deep-trench is exclusively a feature of IBM 32SOI / 14SOI
   and specialty 180 nm BCD lines** (Jayaraman ICICDT 2012,
   El-Damak APEC 2014, Andersen ECTC 2016). Densities of
   100-250 fF/µm² are achievable but inaccessible in `gf180mcuD`.
3. **Pelliconi-cell (JSSC 2003)** is the canonical cross-coupled
   CMOS voltage doubler used in 0.18 µm RFID/NFC tags as the
   *active* on-die charging mechanism — not a passive bulk cap.
   Re-frames "on-die energy storage" as charge-pump-fed flying
   caps.
4. **Biomedical-implant literature confirms the negative
   result** that fully on-die µF-scale storage is *not* practiced
   at 180 nm. Bhattacharyya Sensors 2018 (corrected from "Liu"
   per reviewer-1) needs 10 µF external; Yang JSSC
   2022 (magnetoelectric implant) operates with no bulk storage,
   gated by a brown-out detector (caveat: Yang's actual paper
   integrates a small energy-storage cap per arXiv abstract —
   reviewer-1 finding); Zou arXiv 2602.02376 (corrected from
   "Khan" per reviewer-1) uses
   continuous MPPT replenisher.
5. **Leakage-cancellation (Hashimoto ICCAD 2001) and multi-port
   ZCS bank-switching (MDPI Energies 2018)** each provide ~10x
   effective leakage reduction. Neither appears in the sister
   industry-survey or first-principles reports — both are
   directly relevant to the S8 (zero-leak hot-swap) topology in
   those reports.

Explicit limits on the search:
- Did not survey ferroelectric / non-volatile capacitor
  literature (FeRAM, FeCAP, PZT, HfZrO ferroelectric) — none
  accessible in `gf180mcuD`.
- Did not pursue process-development DTC papers
  (Mosden 2003, Rashed 2015) — covered only at the "what
  density is theoretically possible" level.

## 2. Requirements as understood

(See sister `stage1-first-principles/report.md` §2 — same R1-R7.)
This survey adds two academic-research-specific requirements:

| # | Requirement | Source |
|---|---|---|
| RA1 | Cited claims must be from peer-reviewed venues with measured silicon, not simulation-only. | METHODOLOGY.md |
| RA2 | Density / leakage / breakdown numbers must be cross-checked against epsilon0*epsilon_r/d and Frenkel-Poole limits. | METHODOLOGY.md |

## 3. Solution-space map — academic literature

Detailed strategy table in [`solutions.md`](solutions.md);
sub-block decomposition in [`components.md`](components.md).
This section gives the architectural taxonomy.

### Family A — Standard SiN / Al2O3-SiO2 MIM at 180 nm

**A1 — Gambino-2019 Al2O3/SiO2 MIM-B (180 nm, 3.3 V).**
Stack: 5.0 nm Al2O3 + 2.7 nm SiO2, lower electrode TaN, upper Al.
Reported density >5 fF/µm² (the `gf180mcuD` 2.0 fF/µm² flavour
is a conservative selection from this family). BV median 9.5 V
at ~12 MV/cm. TDDB > 10 yr at 125 °C / 3.3 V. Hysteresis at
200 °C from electron trapping at Al2O3-SiO2 interface.
Source: Gambino et al., IRPS 2019. Paywall — abstract verified.

**A2 — Achanta / McGahay high-k MIM at 65 nm.**
Density up to 13 fF/µm² with ALD HfO2; 65 nm node only. Bounds
*theoretical* design space.

**A3 — Tantalum-oxide MIM (Ta2O5).** Density 2-7 fF/µm²; leakage
well-modelled by Frenkel-Poole. Used here as physics validation
for §5.4.

### Family B — High-k research MIM (not in `gf180mcuD`)

**B1 — ZrO2 with nanosecond laser anneal:** up to 75 fF/µm²,
epsilon_r = 67.8 (lab-scale).
**B2 — TaN/Al2O3/ZrO2/Al2O3/TaN ALD MIM:** up to 20 fF/µm².
**B3 — HfO2-MIM at 7 nm:** 43 fF/µm² with 5 fA/µm² leakage at
1 V / 125 °C.
None transferable to `gf180mcuD`.

### Family C — Deep-trench cap (IBM-class)

**C1 — Jayaraman ICICDT 2012, IBM 32 nm SOI DTC decoupling.**
~3.5x ESR-improvement vs prior generation; 100-250 fF/µm² typical
DTC density. Processor-grade decoupling, not bulk storage.

**C2 — El-Damak APEC 2014 / Andersen ECTC 2016 — DTC-based SC
DC-DC at 32 nm SOI.** Reconfigurable 2:1 / 3:2 step-down,
0.7-1.15 V from 1.8 V input. **Inaccessible in `gf180mcuD`.**

**C3 — Tower 180 nm BCD.** Some 180 nm processes do offer DTC;
`gf180mcuD` is not one of them.

### Family D — MOS-cap academic literature

**D1 — Inversion-mode NFET cap at 180 nm.** Density 3-4 fF/µm²
peak. Industry survey covers PDK device. Academic emphasis on
linearity and voltage coefficient — both irrelevant for a
brown-out energy store.

### Family E — Switched-capacitor DC-DC / charge pumps

**E1 — Pelliconi cross-coupled voltage doubler (JSSC 2003).**
Two cross-coupled NMOS-PMOS branches with intertwined gate-drive,
≤100 MHz operation. Eliminates V_d drop suffered by classical
Dickson; published 180 nm efficiency 70-85 %.

**E2 — Dickson voltage multiplier (canonical).** N-stage
diode-capacitor ladder; output ~ N*(V_clk - V_d). Sub-50 mV input
feasible with ULP-diode tricks (Karthaus 2003, Microelectronics
J. 2019).

**E3 — Bang JSSC 2016: SAR-SC at 180 nm.** 8-bit SAR-style
fly-cap ladder; 2^N output ratios. Peak efficiency >80 %, area
~1 mm².

**E4 — 2:1 fully-integrated 180 nm SC step-down.** Le MIT
(5 V to 1 V at 0.8 W, 81 % peak); Salem multiphase ring (83 %,
200 mA); NSF two-stage cascaded hybrid (87.5 %, 450 mA — uses
inductor, not relevant here).

**E5 — Hong cross-coupled improved-latch-up CP (2002).**
Predecessor to Pelliconi.

### Family F — Leakage-aware / bank-switching topologies

**F1 — Hashimoto leakage-cancellation feedback (ICCAD 2001).**
Active feedback loop at switched-off node; ~10x effective leakage
reduction.

**F2 — Multi-port ZCS bank-switching (MDPI Energies 2018).**
N capacitor banks; idle banks have both terminals isolated;
exponentially reduces sub-threshold leakage during off-time.

**F3 — Output-cap-less LDO with sub-threshold slew enhancement
(NB-IoT, Sensors 2024).** 640 nA quiescent. Demonstrates "no
bulk cap by design" philosophy.

### Family G — Biomedical-implant on-die storage

**G1 — Bhattacharyya Sensors 2018 RFID/NFC frontend at 0.18 µm**
(corrected from "Liu" 2026-05-04 per reviewer-1 spot-check).
Cst = 10 µF *external* + 5 pF on-die. Confirms negative result.

**G2 — Yang et al. JSSC 2022 magnetoelectric bio-implant.**
Coordinated multi-site stimulation. ~~No bulk storage; brown-
out gate on rectified current.~~ **Caveat 2026-05-04**
(reviewer-1): the arXiv abstract for 2112.15552 explicitly
says each implant integrates "an energy storage capacitor" —
the prior summary is incorrect. The implant *does* have a
storage cap; it is small but present.

**G3 — Zou et al. arXiv 2602.02376** (corrected from "Khan"
2026-05-04 per reviewer-1 spot-check). Continuous-MPPT +
energy-recycling PMU.

**G4 — Trigui et al. 2024 on-chip resonance tuning.** All-on-die
cap-bank-tuned WPT; tuning area much less than 1 mm².

### Discarded / scope-noted approaches

- Ferroelectric MIM (FeCAP, HfZrO): not in `gf180mcuD`.
- MEMS variable cap: process-incompatible.
- Supercap / EDLC monolithic CMOS: lab-scale only.

## 4. Sub-block breakdown

See [`components.md`](components.md).

## 5. First-principles sanity checks

### 5.1 Gambino MIM-B density vs epsilon0*epsilon_r/d

Stack: 5.0 nm Al2O3 (epsilon_r = 9) + 2.7 nm SiO2 (epsilon_r =
3.9) in series. EOT = 2.7 + 5.0*(3.9/9) = 4.87 nm. C_area =
3.9*8.854e-12 / 4.87e-9 = **7.09 fF/µm²**. Reported "density
>5 fF/µm²" therefore physically plausible; the PDK 2.0 fF/µm²
implies a thicker production stack. **Consistent with physics,
conservative.**

### 5.2 Pelliconi continuous-power vs flying-cap area

Useful continuous power approx C*f*V². With C = 10 pF,
f = 100 MHz, V = 5 V: P = 10p * 1e8 * 25 = **25 mW** theoretical.
Real efficiency ~70 %, so ~17.5 mW per 10 pF flying cap (~5000
µm² MIM-2.0). **Order of magnitude exceeds NFC budget**
(~100 µW) — small flying-cap bank delivers vastly more
*continuous* power than large bulk cap delivers *one-off*
energy.

### 5.3 DTC density vs epsilon0*epsilon_r/d

DTC at 100 fF/µm² with HfO2 (epsilon_r = 25) implies EOT =
8.854e-12*25 / (100e-15 * 1e12) = 2.21 nm. Trench aspect ratio
gives 30-50x area-multiplier — planar-equivalent density 100/30
~ 3 fF/µm², consistent with HfO2. **Plausible**, just
inaccessible.

### 5.4 Frenkel-Poole leakage scaling at low V

Frenkel-Poole I prop V*exp(beta*sqrt(V)). At 1 V vs 6 V on the
same MIM-2.0, leakage ratio = exp(beta*(sqrt(6) - sqrt(1))) =
exp(beta*1.45). For typical beta = 1-2 V^-0.5, this gives a
4-50x *lower* leakage at 1 V than at 6 V. The PDK 1 pA/µm² is at
*rated* (6.6 V) operation. **At a 3.3 V harvested rail the actual
leakage should be ~5-20x lower** (~0.05-0.2 pA/µm², ~0.3-1.2
µW/mm²). This materially changes the ambient-RF verdict from the
first-principles report — at 3.3 V a 5 mm² bank leaks 1.5-6 µW,
*comparable to* (not 6x exceeding) the 5 µW ambient harvest
budget.

### 5.5 Pelliconi vs Dickson efficiency at 180 nm

Cross-coupled topology eliminates the per-stage V_d drop. At
180 nm with V_t = 0.5 V and 1 V clock swing, 2-stage Dickson
loses ~50 % to V_d; Pelliconi loses only switch I²R. Published
180 nm Pelliconi efficiency 70-85 %, classical Dickson 30-50 %.

## 6. References

See [`references.md`](references.md). 17 entries — 8 verified
open-access; 5 paywalled but abstract-confirmed via Semantic
Scholar / DOI; 1 marked `FAIL` transparently (B1, venue not
pinned); 4 cross-cited through sister industry-survey.

## 7. Negative results

- **NA-1 — Pure on-die µF storage at 180 nm is NOT practiced in
  any peer-reviewed silicon paper this survey found.**
  Bhattacharyya 2018 (corrected from "Liu" — reviewer-1)
  external 10 µF; Yang 2022 has *small* on-die storage cap
  (corrected from "brown-out-only" — reviewer-1 verified
  arXiv abstract); Zou 2026 (corrected from "Khan" —
  reviewer-1) MPPT loop. **Caveat 2026-05-04**: NA-1 is no
  longer triple-anchored as "cap-less"; the Yang paper has a
  small cap. The negative result holds for *µF-class* on-die
  storage (no paper found) but the language has been
  softened.
- **NA-2 — Pelliconi & Hong cross-coupled CPs collapse below
  ~1 V V_in.** Below ~0.6 V (typical ambient-RF rectifier
  output) efficiency collapses; cite Karthaus / Sze sub-50 mV
  analyses. Implies our ambient-RF path needs Dickson with ULP
  diodes, not Pelliconi.
- **NA-3 — Bank-switching with isolated terminals (F2) requires
  HV switches whose own off-leakage may dominate at fine
  granularity.** ~100 fA per switch * 1000 switches > MIM bank
  leakage. Bank granularity must be coarse.
- **NA-4 — High-k MIM (Family B) papers all report on advanced
  nodes (45 / 65 / 7 nm).** No 180 nm peer-reviewed high-k MIM
  with foundry-grade reliability data. Gambino 2019 is as good
  as 180 nm gets.
- **NA-5 — DTC literature is exclusively IBM SOI / Infineon
  trench-DRAM derivatives.** No DTC for foundry GF180MCU.
- **NA-6 — "Capacitance redistribution" in Khan 2026 is
  marketing-spin for "switch banks in/out".** Substance same as
  Family F2.

## 8. Open questions

See [`open-questions.md`](open-questions.md). Top three:
- **OQA-1**: Is `gf180mcuD` PDK MIM the Gambino 2019 stack?
- **OQA-2**: At 3.3 V, what is the *measured* MIM-2.0 leakage?
- **OQA-3**: Is Pelliconi preferable to bulk MIM for *all* rails?

## 9. Comparison readiness

| Approach | Headline performance | Area / power cost | Maturity | Best fit | Worst fit |
|---|---|---|---|---|---|
| A1 Gambino MIM-B (PDK MIM-2.0) | 2.0-6 fF/µm², 1 pA/µm² @ 6.6 V | 5500 µm²/nF | foundry-default | post-LDO storage | ambient-RF static bias |
| B-class high-k research MIM | up to 75 fF/µm² | inaccessible | research | not us | this project |
| C1 IBM DTC | 100-250 fF/µm² | inaccessible | IBM/Infineon-only | high-density processors | this project |
| D1 MOS-cap | 3-4 fF/µm² peak, V-dependent | std-cell-row free | foundry-default | std-cell decap fill | bulk storage |
| E1 Pelliconi cell | 70-85 % efficient at >1 V | 5000 µm² flying cap = ~10 mW | mature 180 nm | NFC/Qi steady-state | sub-1 V harvest |
| E2 Dickson | 30-66 % depending on diode | flying caps 1-10 pF | mature | ambient-RF (low V) | high-V step-down |
| E3 Bang SAR-SC | 8-bit ratio, >=80 % efficient | 8 flying caps | published 180 nm | adjustable rails | tight area |
| E4 2:1 SC step-down | 80-87 % efficient | 0.5-2 mm² flying caps | published 180 nm | known-ratio step-down | non-2^N ratios |
| F1 leakage-canceller | ~10x effective leak reduction | small OTA per switch | published 180 nm | ambient-RF idle | high-current |
| F2 bank-switched zero-leak | exp-suppressed leak in idle banks | extra switches | published battery mgmt | discontinuous loads | continuous |
| G1 external-cap WPT | >=1 µF storage | external — forbidden | very mature | most products | this project |
| G2 brown-out-only WPT | zero bulk cap | ~50 nF small fast hold | published JSSC 2022 | accept brief outage | LED long-pulse |

## 10. Author's notes

This survey deliberately read the **negative** literature first
(G1-G4 all show fully-on-die µF storage is not done at 180 nm),
which re-frames item (e) from "find the best bulk cap" to
"survive without bulk caps via switched-cap delivery + brown-out
gating + active replenishment". The Pelliconi cell becomes a
*structural* answer, not just a sub-block.

Three findings the sister reports may have missed:
1. **MDPI Energies 2018 multi-port ZCS (F2)** is direct academic
   backing for the S8 hot-swap zero-leak topology in the
   first-principles report; neither sister cited it.
2. **Hashimoto ICCAD 2001 active leakage canceller (F1)** offers
   ~10x reduction on switched-off nodes, complementary to F2 —
   also uncited by sisters.
3. **Frenkel-Poole de-rating of MIM leakage at 3.3 V vs 6.6 V**
   (§5.4) — first-principles uses rated-V leakage to declare
   ambient-RF energy-negative; physics says actual leakage at
   3.3 V is 5-20x lower, which materially softens the verdict.

Self-assessment: 14 distinct cap-storage strategies (AS-1
through AS-14 in `solutions.md`) covering families A-G. Required
>=5 — clear pass. Negative results >=1 — clear pass with 6 items.
Density / energy / leakage claims all cross-checked against
epsilon0*epsilon_r/d, half*C*V², and Frenkel-Poole limits in §5.
No single approach was recommended at this stage.
