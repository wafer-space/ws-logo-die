---
item: e
stage: 1
angle: academic-survey
---

# Annotated bibliography

## Verification legend

- `OA` — open-access PDF accessed
- `PW` — paywall, abstract-only verified via DOI / Semantic Scholar
- `MIRROR` — accessed via faculty / ResearchGate / preprint mirror
- `FAIL` — could not verify (logged as such, not silently dropped)

---

## A1 — Gambino 2019 (Al2O3/SiO2 MIM at 180 nm 3.3 V)

**Citation.** J. P. Gambino, D. Allman, G. R. Hall, D. Price,
L. Sheng, R. Takada, Y. Kanuma, "Reliability of an Al2O3/SiO2
MIM Capacitor for 180 nm (3.3 V) Technology," *Proc. IEEE Int.
Reliability Physics Symposium (IRPS) 2019*, pp. 1-5.
DOI: 10.1109/IRPS.2019.8720443.

**Type.** Peer-reviewed conference (IRPS).

**Verification.** `PW` — IEEE Xplore paywall; abstract verified
via Semantic Scholar paper-id
5e5cba4b019070681a7869b91508b7f67d37ba52 (2026-05-04). ResearchGate
abstract page 333347965 also accessible. Full-text not retrieved.

**Relevance.** This is *the* canonical 180 nm MIM reliability
paper, cited by the sister industry-survey report and explicitly
named in the assignment. Confirms 5.0 nm Al2O3 + 2.7 nm SiO2
stack, ~6 fF/µm² achievable, BV 9.5 V (12 MV/cm), TDDB > 10 yr
at 125 °C / 3.3 V. The PDK MIM-2.0 (2.0 fF/µm² @ 6.6 V) is a
conservative selection from this dielectric family.

---

## A2 — Achanta-McGahay high-k MIM 65 nm

**Citation.** R. Achanta, V. McGahay et al., "High-k MIM
dielectric reliability study in 65 nm node," ~2010.

**Type.** Peer-reviewed.

**Verification.** `PW` — Semantic Scholar paper-id
0e7ac8a916b39bf73b516fb90724a5c42cd03cb4 (2026-05-04).

**Relevance.** Reference point for "high-k at advanced node",
demonstrates 13 fF/µm² with ALD HfO2. Cited only as bound for
what is *theoretically* possible — not transferable to 180 nm.

---

## A3 — Lo Ta2O5 MIM leakage

**Citation.** Various authors, "Leakage behavior and reliability
assessment of tantalum oxide dielectric MIM capacitors,"
ResearchGate publication 4013592.

**Type.** Peer-reviewed.

**Verification.** `MIRROR` — RG-pub 4013592.

**Relevance.** Frenkel-Poole leakage temperature scaling model
used in §5.4 of `report.md`.

---

## B1 — ZrO2 nanosecond-laser-anneal MIM

**Citation.** Multiple authors (per WebSearch), "Ni/ZrO2/TiN
nanosecond-laser-annealed MIM achieves 75 fF/µm²", ~2018.

**Type.** Peer-reviewed (specific venue not pinned in this
survey).

**Verification.** `FAIL` — citation captured at title-level only
from WebSearch result snippet. Listed transparently; would need
follow-up from a Stage-2 reviewer to lock down the venue.

**Relevance.** Bound for "highest-density-MIM-ever-published".
Out of scope for this PDK; included to show research ceiling.

---

## B2 — TaN/Al2O3/ZrO2/Al2O3/TaN ALD MIM

**Citation.** "Dielectric Enhancement of Atomic Layer-Deposited
Al2O3/ZrO2/Al2O3 MIM Capacitors by Microwave Annealing,"
*Discover Nano* (Springer Open), DOI 10.1186/s11671-019-2874-5,
2019.

**Type.** Peer-reviewed open-access journal.

**Verification.** `OA` via SpringerOpen.

**Relevance.** ZrO2 ε_r = 41.9 with microwave anneal, ~20 fF/µm².

---

## B3 — HfO2-MIM 7 nm CMOS-compatible decap

**Citation.** "CMOS compatible MIM decoupling capacitor with
reliable sub-nm EOT high-k stacks for the 7 nm node and beyond,"
ResearchGate-pub 313469026, ~2017.

**Type.** Peer-reviewed.

**Verification.** `MIRROR`.

**Relevance.** 43 fF/µm² with 5 fA/µm² leakage. Out-of-node bound.

---

## C1 — Jayaraman ICICDT 2012 IBM DTC

**Citation.** B. Jayaraman et al., "Performance analysis and
modeling of deep trench decoupling capacitor for 32 nm
high-performance SOI processors and beyond," *IEEE ICICDT 2012*.
DOI 10.1109/ICICDT.2012.6232872. Also research.ibm.com/publications.

**Type.** Peer-reviewed conference.

**Verification.** `OA` — IBM Research publications page mirror,
also academia.edu/81434755.

**Relevance.** Canonical 32 nm SOI DTC paper. ESR 3.5x improved
vs prior. Establishes that DTC is real but exclusive to IBM SOI.

---

## C2 — El-Damak APEC 2014 / Andersen ECTC 2016 DTC SC DC-DC

**Citation.** El-Damak et al., DTC-based reconfigurable SC at
32 nm SOI, *APEC 2014*; Andersen et al., "3Di DC-DC Buck Micro
Converter with TSVs, Grind Side Inductors, and Deep Trench
Decoupling Capacitors in 32 nm SOI CMOS," *ECTC 2016*.

**Type.** Peer-reviewed conferences.

**Verification.** `MIRROR` — IBM Research page; Andersen also
on ResearchGate.

**Relevance.** DTC enables fully-integrated SC DC-DC at 32 nm
SOI. Out of scope for `gf180mcuD`.

---

## C3 — Tower 180 nm BCD

**Citation.** Tower Semiconductor, "180 nm Power Management"
process brief, towersemi.com/technology/power-management/.

**Type.** Vendor brief, not peer-reviewed.

**Verification.** `OA` via industry-survey sister report.

**Relevance.** Confirms that *some* 180 nm processes carry DTC,
but `gf180mcuD` is not one of them.

---

## E1 — Pelliconi JSSC 2003

**Citation.** R. Pelliconi, D. Iezzi, A. Baroni, M. Pasotti, P.
Rolandi, "Power efficient charge pump in deep submicron standard
CMOS technology," *IEEE J. Solid-State Circuits*, vol. 38, no. 6,
pp. 1068-1071, June 2003. DOI 10.1109/JSSC.2003.811965.

**Type.** Peer-reviewed (IEEE JSSC).

**Verification.** `PW` for the JSSC paper itself; abstract
confirmed via Semantic Scholar (2026-05-04). Open-access mirror
of the schematic and analysis available at
ece.ualberta.ca/~kambiz/papers/J29.pdf (Hosseini 2018, "High-
Efficiency Charge Pumps for Low-Power On-Chip Applications").

**Relevance.** Canonical cross-coupled CMOS charge pump.
Architectural foundation for E1 in §3.

---

## E2 — Dickson voltage multiplier (canonical + modern)

**Citation.** J. F. Dickson, "On-chip high-voltage generation in
MNOS integrated circuits using an improved voltage multiplier
technique," *IEEE J. Solid-State Circuits*, vol. 11, no. 3,
pp. 374-378, June 1976. Plus modern: "Analysis and design of
the Dickson charge pump for sub-50 mV energy harvesting,"
*Microelectronics J.*, 2019,
DOI 10.1016/j.mejo.2019.07.006.

**Type.** Peer-reviewed.

**Verification.** `PW` (Dickson 1976); modern paper `MIRROR`
via ScienceDirect.

**Relevance.** Baseline voltage multiplier for ambient-RF mode.
Sub-50 mV variant key for marginal-harvest case.

---

## E3 — Bang JSSC 2016 SAR-SC

**Citation.** S. Bang, A. Wang, B. Giridhar, D. Blaauw,
D. Sylvester, "A Successive-Approximation Switched-Capacitor
DC-DC Converter With Resolution of V_IN/2^N for a Wide Range of
Input and Output Voltages," *IEEE J. Solid-State Circuits*,
vol. 51, no. 4, pp. 1051-1064, April 2016.

**Type.** Peer-reviewed (IEEE JSSC).

**Verification.** `OA` — full PDF at
blaauw.engin.umich.edu/wp-content/uploads/sites/342/2017/11/
BangASuccessiveApproximation2016.pdf (faculty mirror).

**Relevance.** Demonstrates 2^N ratio reconfigurable SC DC-DC at
180 nm with peak efficiency >80 %, area ~1 mm². Architecture
candidate for harvested-rail step-down to 3.3 V.

---

## E4-a — MIT Le merged-stage 180 nm SC

**Citation.** "Merged Two-Stage Power Converter With Soft
Charging Switched-Capacitor Stage in 180 nm CMOS,"
DSpace MIT 1721.1/87099.

**Type.** Peer-reviewed (thesis-derived journal paper).

**Verification.** `OA` via dspace.mit.edu.

**Relevance.** 5 V to 1 V at 0.8 W, 81 % peak efficiency at
180 nm. Direct precedent for `gf180mcuD` SC step-down.

---

## E4-b — Multiphase SC ring 180 nm

**Citation.** L. G. Salem and P. P. Mercier, "A Multiphase
Switched-Capacitor DC-DC Converter Ring With Fast Transient
Response and Small Ripple."

**Type.** Peer-reviewed.

**Verification.** `MIRROR` via ResearchGate-pub 309757247.

**Relevance.** 83 % peak efficiency, 200 mA, 180 nm.

---

## E4-c — Two-stage cascaded hybrid SC

**Citation.** "A Two-Stage Cascaded Hybrid Switched Capacitor
DC-DC Converter," NSF par.nsf.gov/servlets/purl/10280420.

**Type.** Peer-reviewed.

**Verification.** `OA`.

**Relevance.** 87.5 % peak, 450 mA. Adds inductor — not relevant
since we are inductor-less, but confirms upper bound on hybrid
efficiency at this node.

---

## E4-d — Alon HotChips tutorial

**Citation.** E. Alon, "Fully Integrated Switched-Capacitor
DC-DC Conversion," HotChips 23 tutorial,
old.hotchips.org/wp-content/uploads/hc_archives/hc23/HC23.17.1.

**Type.** Tutorial slides.

**Verification.** `OA`.

**Relevance.** Survey of trade-offs and 180 nm reference designs.

---

## E5 — Hong cross-coupled improved-latch-up CP

**Citation.** S.-W. Hong et al., "CMOS charge pumps using
cross-coupled charge transfer switches with improved voltage
pumping gain and low gate-oxide stress for low-voltage memory
circuits," IEEE document 1010761, ~2002.

**Type.** Peer-reviewed.

**Verification.** `PW`.

**Relevance.** Predecessor of Pelliconi; cited for completeness.

---

## F1 — Hashimoto / Sanyal leakage-canceller

**Citation.** ICCAD-2001 / IEEE doc 945424, "Leakage current
cancellation technique for low power switched-capacitor circuits".

**Type.** Peer-reviewed.

**Verification.** `PW` — IEEE document 945424; abstract via
Semantic Scholar.

**Relevance.** ~10x leakage reduction for switched-off nodes.
Highly relevant to ambient-RF mode where MIM static leakage is
the dominant loss.

---

## F2 — MDPI Energies multi-port ZCS

**Citation.** "Multi-Port Zero-Current Switching Switched-
Capacitor Converters for Battery Management Applications,"
*Energies*, 11(8):1934, 2018.
DOI 10.3390/en11081934.

**Type.** Peer-reviewed open-access.

**Verification.** `OA` via mdpi.com.

**Relevance.** Bank-switching zero-current topology. Direct
academic backing for S8 in first-principles report.

---

## F3 — PMC NB-IoT output-cap-less LDO

**Citation.** "A 640 nA IQ Output-Capacitor-Less LDO with
Sub-Threshold Slew-Rate Enhancement for NB-IoT Applications,"
*Sensors* 2024. PMC11356146.

**Type.** Peer-reviewed open-access.

**Verification.** `OA` via PubMed Central.

**Relevance.** Demonstrates "no bulk cap by design" — alternative
philosophy to bulk-cap storage.

---

## G1 — Bhattacharyya Sensors 2018 RFID/NFC frontend

> **Correction 2026-05-04** (reviewer-1): the prior author
> attribution was "Liu et al." Reviewer-1's spot-check against
> the MDPI Sensors mirror confirms the actual lead author is
> **Bhattacharyya et al.** Updated below.

**Citation.** Bhattacharyya et al., "An Ultra-Low-Power
RFID/NFC Frontend IC Using 0.18 µm CMOS," *Sensors*, 18(5):1452,
2018.

**Type.** Peer-reviewed open-access (MDPI Sensors).

**Verification.** `OA` (industry-survey sister report);
author-list re-verified by reviewer-1 on 2026-05-04.

**Relevance.** **Negative result confirmation**: even an academic
ultra-low-power 0.18 µm NFC frontend uses Cst = 10 µF *external*.

---

## G2 — Yang JSSC 2022 magnetoelectric bio-implant

**Citation.** J. C. Chen, P. Kan, Z. Yu, F. Alrashdan, R. Garcia,
A. Singer, J. T. Robinson, K. Yang, "Magnetoelectric Bio-Implants
Powered and Programmed by a Single Transmitter for Coordinated
Multisite Stimulation," *IEEE J. Solid-State Circuits*, 2022.
arXiv preprint 2112.15552; PMC9581110.

**Type.** Peer-reviewed (JSSC) + open-access preprint.

**Verification.** `OA` via arXiv 2112.15552 + PMC9581110.

**Relevance.** ~~Canonical "no bulk cap" implant design; runs
directly off rectified ME-harvested current with brown-out
gate.~~

> **Correction 2026-05-04** (reviewer-1): the prior summary
> claimed this paper has "no bulk storage; brown-out gate".
> Reviewer-1 verified the actual arXiv abstract explicitly says
> each implant integrates "an energy storage capacitor".
> **The "no bulk cap" claim does NOT hold** — this anchor is
> not load-bearing for NA-1. Stage-2 must downgrade or replace
> NA-1 evidence. Updated relevance: this paper is still useful
> as a *low-cap* implant reference (cap is on-die but small),
> but it is not "cap-less". Specific cap value pending re-read.

---

## G3 — Zou arXiv 2602.02376 mm-implant PMU

> **Correction 2026-05-04** (reviewer-1): the prior author
> attribution was "Khan". Reviewer-1's spot-check against the
> arXiv mirror confirms actual lead author is **Zou et al.**

**Citation.** Zou et al., "An Efficient Power Management Unit
with Continuous MPPT and Energy Recycling for Wireless
Millimetric Biomedical Implants," arXiv 2602.02376.

**Type.** Preprint (peer-review status unverified).

**Verification.** `OA` via arXiv.

**Relevance.** Active replenisher loop replaces bulk-cap droop
tolerance. Cap-area much less than 1 mm².

---

## G4 — Trigui 2024 on-chip resonance tuning

**Citation.** "A Wireless Power Conversion Chain With Fully
On-Chip Automatic Resonance Tuning System for Biomedical
Implants," ResearchGate-pub 379385457, 2024.

**Type.** Peer-reviewed.

**Verification.** `MIRROR`.

**Relevance.** All-on-chip cap-bank-tuned WPT; demonstrates
0.1-1 mm² is sufficient for tuning, *not* for bulk storage.
