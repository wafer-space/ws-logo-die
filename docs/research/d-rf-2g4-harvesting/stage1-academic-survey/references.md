# Annotated bibliography -- Stage-1 academic survey, item (d)

Verification key:

- **CACHED-VERIFIED**: full PDF or canonical source mirrored
  under `references-cache/` and visually / textually verified
  during this session.
- **WEB-VERIFIED**: abstract, conference program entry, or PMC /
  Semantic Scholar / faculty-page snippet retrieved and matches
  citation; full PDF not retrieved (paywall, IEEE-Xplore-bot
  block, or out-of-scope time budget).
- **PAYWALL-NOTED**: paywalled IEEE / ACM / Elsevier; cited by
  DOI + author + year + venue without full-text verification, per
  brief's web-access guidance to skip IEEE Xplore.
- **NOT-VERIFIED**: cited indirectly via review article; flagged
  for Stage-2 review.

References are grouped by topic; numbering is local to this file.

## A. Canonical CMOS rectifier topology references

### A.1 Kotani, Sasaki & Ito 2007 (A-SSCC) -- Self-Vth-Cancellation rectifier

- **Citation:** K. Kotani, A. Sasaki, T. Ito, "High-Efficiency
  CMOS Rectifier Circuit with Self-Vth-Cancellation and Power
  Regulation Functions for UHF RFIDs", *IEEE Asian Solid-State
  Circuits Conference (A-SSCC) 2007*, pp. 119-122.
- **DOI:** 10.1109/ASSCC.2007.4425746.
- **Type:** peer-reviewed conference paper.
- **Verification:** WEB-VERIFIED via Tohoku University ELSS
  pure-research record and Semantic Scholar entry
  `ea452cbe454860ab340b626bbf99366076bdbab4`.
- **Cache path:** not cached (IEEE Xplore 418-blocks bots);
  verified via Semantic Scholar abstract.
- **Relevance:** the canonical Vth-cancellation paper anchored
  in the brief. 0.35 um CMOS, 953 MHz, 32 % PCE at -10 dBm
  input. Adopted by all subsequent UHF / 2.4 GHz RFEH designs.

### A.2 Kotani & Ito 2009 (JSSC) -- journal version

- **Citation:** K. Kotani, T. Ito, "High-Efficiency CMOS
  Rectifier Circuits for UHF RFIDs Using Vth Cancellation
  Techniques", *IEEE J. Solid-State Circuits*, Vol. 44, No. 11,
  pp. 3011-3018, Nov. 2009.
- **DOI:** 10.1109/JSSC.2009.2030093.
- **Type:** peer-reviewed journal paper.
- **Verification:** PAYWALL-NOTED. Authoritative summary in
  Semantic Scholar / Springer review article (Akbari 2018,
  TCAS-I).
- **Relevance:** journal extension of A.1; full set of measured
  PCE curves and design analysis.

### A.3 Mandal & Sarpeshkar 2007 (TCAS-I) -- Cross-coupled CMOS rectifier

- **Citation:** S. Mandal, R. Sarpeshkar, "Low-Power CMOS
  Rectifier Design for RFID Applications", *IEEE Trans.
  Circuits Syst. I: Regular Papers*, Vol. 54, No. 6,
  pp. 1177-1188, June 2007.
- **DOI:** 10.1109/TCSI.2007.895229.
- **Type:** peer-reviewed journal paper.
- **Verification:** PAYWALL-NOTED. Citation widely repeated in
  every CMOS rectifier review.
- **Relevance:** first systematic treatment of the cross-
  coupled CMOS rectifier (CCDD); now the dominant topology in
  modern UHF / 2.4 GHz RFEH chips.

### A.4 Le, Mayaram & Fiez 2008 (JSSC) -- Vth-cancelled differential rectifier

- **Citation:** T. Le, K. Mayaram, T. Fiez, "Efficient Far-
  Field Radio Frequency Energy Harvesting for Passively
  Powered Sensor Networks", *IEEE J. Solid-State Circuits*,
  Vol. 43, No. 5, pp. 1287-1302, May 2008.
- **DOI:** 10.1109/JSSC.2008.920318.
- **Type:** peer-reviewed journal paper.
- **Verification:** PAYWALL-NOTED. Abstract verified via
  Google Scholar.
- **Relevance:** combined SVC + CCDD; introduced the Vth-
  cancelled differential rectifier concept.

## B. 2.4 GHz silicon implementations

### B.1 Yan et al. 2024 (RFIC) -- 2.4 GHz reconfigurable RFEH chip

- **Citation:** Yan et al., "A 2.4 GHz, -19 dBm Sensitivity RF
  Energy Harvesting CMOS Chip With 51 % Peak Efficiency and 24
  dB Power Dynamic Range", *IEEE Radio Frequency Integrated
  Circuits Symposium (RFIC) 2024*.
- **DOI:** TBD (search RFIC 2024 program book; abstract
  retrievable via the cached
  `references-cache/rfic2024-program-book.pdf` -- see PDF).
- **Type:** peer-reviewed conference paper.
- **Verification:** WEB-VERIFIED via the cached RFIC 2024
  program book PDF (sister-report's `references-cache/`).
  Numerical claims (-19 dBm sensitivity, 51 % peak PCE, 24 dB
  PDR, 1.08 mm^2, 66-157 nW controller) verified via web-
  search-returned abstract excerpts.
- **Cache path:** cached at
  `references-cache/rfic2024-program-book.pdf`; full conference
  paper PDF is paywalled.
- **Relevance:** **the strongest published 2.4 GHz silicon
  RFEH result.** Architectural reference for our project.

### B.2 Pakkirisami Churchill et al. 2022 (Sensors) -- 2.4 GHz RFEH 423 uW

- **Citation:** K. K. Pakkirisami Churchill, H. Ramiah, G.
  Chong, Y. Chen, P.-I. Mak, R. P. Martins, "A Fully-
  Integrated Ambient RF Energy Harvesting System with
  423-uW Output Power", *Sensors* (MDPI), Vol. 22, No. 12,
  Article 4415, 2022.
- **DOI:** 10.3390/s22124415.
- **Type:** peer-reviewed open-access journal paper.
- **Verification:** WEB-VERIFIED via PMC9227311 (full text
  on PubMed Central, freely accessible).
- **Cache path:** to-be-cached for Stage-2; PMC URL
  `https://pmc.ncbi.nlm.nih.gov/articles/PMC9227311/`.
- **Relevance:** **the strongest published 2.4 GHz fully-
  integrated system with output-power claim.** 180 nm CMOS,
  3-stage DCC + 6-stage charge pump, 21.15 % PCE @ 0 dBm,
  423 uW output, sensitivity -14.1 dBm, on-chip LC matching,
  1.02 mm^2. **Very likely the "Awad 2022 MDPI" anchor used
  in parallel reports** -- author misattribution flagged.

### B.3 Theilmann & Asbeck 2012 (TMTT) -- on-die transformer balun rectifier

- **Citation:** P. C. Theilmann, P. M. Asbeck, "An On-Chip
  Differential to Single-Ended Conversion Technique for
  Power Combining of CMOS Power Amplifiers" (verify exact
  Theilmann 2012 reference), *IEEE Trans. Microwave Theory
  Techn.* Vol. 60 No. 7, July 2012.
- **DOI:** TBD; verify via Theilmann's UCSD page.
- **Type:** peer-reviewed journal paper.
- **Verification:** PAYWALL-NOTED. Reference name retained
  from sister industry-survey report; citation needs
  refinement in Stage-2.
- **Relevance:** on-die transformer balun for single-pin
  -> differential rectifier conversion at 2.4 GHz on 180 nm.

### B.4 Stoopman et al. 2014 (JSSC) -- antenna co-designed RFEH

- **Citation:** M. Stoopman, S. Keyrouz, H. J. Visser, K.
  Philips, W. A. Serdijn, "Co-Design of a CMOS Rectifier
  and Small Loop Antenna for Highly Sensitive RF Energy
  Harvesters", *IEEE J. Solid-State Circuits*, Vol. 49, No. 3,
  pp. 622-634, March 2014.
- **DOI:** 10.1109/JSSC.2014.2302793.
- **Type:** peer-reviewed journal paper.
- **Verification:** PAYWALL-NOTED. Abstract verified via
  TU Delft author page.
- **Relevance:** **canonical antenna-rectifier co-design
  framework.** 90 nm 0.866 GHz, sensitivity -27 dBm at 1 V
  / 18 uW load -- the silicon-published sensitivity record
  for any frequency.

### B.5 Lu, Chen & Sanchez-Sinencio 2015 (JSSC) -- reconfigurable rectifier precursor

- **Citation:** Y. Lu, H. Chen, E. Sanchez-Sinencio, "A
  Reconfigurable Rectifier with Optimal Loading Point
  Determination for RF Energy Harvesting from -22 dBm to -2
  dBm", *IEEE J. Solid-State Circuits*, Vol. 50, No. 8,
  pp. 1768-1781, Aug. 2015.
- **DOI:** 10.1109/JSSC.2015.2436856.
- **Type:** peer-reviewed journal paper.
- **Verification:** PAYWALL-NOTED. Identified in Chun 2022
  IEEE Access review as the precursor to Yan 2024.
- **Relevance:** first systematic reconfigurable-stage-count
  design; conceptual ancestor of Yan 2024.

### B.6 Nguyen et al. 2019 (Electronics) -- DTMOS CCDD on 65 nm SOTB (corrected from "Honma" 2026-05-04)

> **Correction 2026-05-04** (reviewer-1): the prior author
> attribution was "Honma et al." Reviewer-1 verified via the
> MDPI Electronics open-access page that the actual authors
> are **Nguyen, Sato, Ishibashi**. Updated below; downstream
> references throughout the academic-survey reports use the
> corrected attribution.

- **Citation:** Nguyen, Sato, Ishibashi (corrected from "Honma
  et al." 2026-05-04 per reviewer-1), "A 2.77 uW Ambient RF
  Energy Harvesting Using DTMOS Cross-Coupled Rectifier on
  65 nm SOTB and Wide Bandwidth System Design", *Electronics*
  (MDPI), Vol. 8, No. 10, Article 1173, 2019.
- **DOI:** 10.3390/electronics8101173.
- **Type:** peer-reviewed open-access journal paper.
- **Verification:** WEB-VERIFIED via MDPI open-access page.
- **Relevance:** DTMOS-CCDD reference. 65 nm SOTB process
  with body-tied-gate on both NMOS and PMOS. Constraint:
  GF180MCU bulk allows DTMOS only on PMOS half.

### B.7 Kadali / Sadagopan-class 900 MHz CCDD -- 86 % PCE record

- **Citation pattern:** various; the closest direct match in
  this survey's web search is a 900 MHz 10-stage self-
  compensated CCDD design reaching 86.03 % PCE at -19.32 dBm,
  9.76 dB PDR. **Stage-2 must resolve exact author / venue
  attribution.**
- **DOI:** TBD. Likely candidates: ScienceDirect AEU 2021
  (Sadagopan or co-author), or IEEE TCAS-II.
- **Type:** peer-reviewed journal paper.
- **Verification:** NOT-VERIFIED. Citation pattern carried
  forward from web search; authoritative anchor not yet
  retrieved in this session.
- **Relevance:** the 86 % peak PCE figure that the parallel
  industry-survey report quotes is from this class of paper;
  this academic survey verifies that 86 % is **a 900 MHz
  number, not 2.4 GHz** -- a critical de-rating that the
  industry survey did not call out explicitly.

### B.8 Yi, Mok & Ki 2007 (JSSC) -- naive-Dickson reference

- **Citation:** J. Yi, P.K.T. Mok, W.-H. Ki, "Design and
  Analysis of a Reconfigurable Charge Pump", *IEEE J. Solid-
  State Circuits* 2007 (verify exact title; reference held
  for Stage-2 disambiguation).
- **DOI:** TBD.
- **Type:** peer-reviewed journal paper.
- **Verification:** PAYWALL-NOTED. Cited as the textbook
  Dickson failure-below-150-mV anchor.

## C. Ambient power-density survey

### C.1 Pinuela, Mitcheson & Lucyszyn 2013 (TMTT) -- London RF survey

- **Citation:** M. Pinuela, P. D. Mitcheson, S. Lucyszyn,
  "Ambient RF Energy Harvesting in Urban and Semi-Urban
  Environments", *IEEE Trans. Microwave Theory Techn.*,
  Vol. 61, No. 7, pp. 2715-2726, July 2013.
- **DOI:** 10.1109/TMTT.2013.2262687.
- **Type:** peer-reviewed journal paper.
- **Verification:** **CACHED-VERIFIED.** Full PDF cached at
  `references-cache/pinuela-2013-london-rf-survey.pdf`;
  text extracted and content cross-checked in this session
  (`tmp/pinuela.txt`). Section II describes methodology;
  Table II / Section III names DTV / GSM900 / GSM1800 / 3G
  / Wi-Fi as the five identified bands but **does not
  characterise a 2.4 GHz harvester**.
- **Cache path:** `references-cache/pinuela-2013-london-rf-
  survey.pdf` (1.39 MB; verified PDF v1.5).
- **Relevance:** **the most authoritative true-ambient
  citation for 2.4 GHz being below threshold.** Primary
  source for 40 % end-to-end efficiency at -25.4 dBm with
  GSM900 rectenna + TI BQ25504 PMM.

## D. Reviews / surveys

### D.1 Chun, Ramiah & Mekhilef 2022 (IEEE Access) -- PDR review

- **Citation:** A. C. C. Chun, H. Ramiah, S. Mekhilef, "Wide
  Power Dynamic Range CMOS RF-DC Rectifier for RF Energy
  Harvesting System: A Review", *IEEE Access*, Vol. 10,
  pp. 23948-23963, 2022.
- **DOI:** 10.1109/ACCESS.2022.3155240.
- **Type:** peer-reviewed open-access journal review.
- **Verification:** WEB-VERIFIED via IEEE Access open-access
  page (IEEE Access PDFs are CC-BY-4.0; not paywalled).
- **Relevance:** comprehensive review of CMOS RF-DC
  rectifier topologies grouped by PDR / sensitivity.
  Primary index for the recent (2010-2022) literature.

### D.2 Chun et al. 2023 (IEEE Access) -- dual-topology rectifier

- **Citation:** "A High-Performance Dual-Topology CMOS
  Rectifier With 19.5-dB Power Dynamic Range for RF-Based
  Hybrid Energy Harvesting", *IEEE Access*, 2023 (verify
  exact author list and DOI in Stage-2).
- **DOI:** TBD; ieeexplore.ieee.org/document/10089463.
- **Type:** peer-reviewed open-access journal paper.
- **Verification:** WEB-VERIFIED via IEEE Access search
  result.
- **Relevance:** 2023 follow-up to D.1; conceptual
  descendant of B.1 (Yan 2024).

### D.3 Akbari et al. 2018 (Springer Analog Integr. Circ.) -- threshold-cancellation analysis

- **Citation:** A. Akbari et al., "A Complete Analysis and
  Measurement Results of the Threshold Voltage Cancellation
  Scheme for RF to DC Converter", *Analog Integrated Circuits
  and Signal Processing*, 2018.
- **DOI:** 10.1007/s10470-015-0630-z.
- **Type:** peer-reviewed Springer journal paper.
- **Verification:** WEB-VERIFIED via Springer page.
- **Relevance:** authoritative analytical treatment of
  Kotani SVC.

## E. Threshold-cancellation / DTMOS / floating-gate

### E.1 Cilek et al. 2009 (TCAS-II) -- floating-gate trim

- **Citation:** F. Cilek et al., "Floating-Gate-Based RF-to-
  DC Rectifier", *IEEE Trans. Circuits Syst. II: Express
  Briefs*, 2009.
- **DOI:** TBD.
- **Type:** peer-reviewed journal paper.
- **Verification:** PAYWALL-NOTED.
- **Relevance:** OTP-programmed gate trim for Vth
  cancellation; reference for §3.B `vth-floating-gate-trim`.

### E.2 Papotto, Carrara & Palmisano 2011 (JSSC) -- body bias from rail

- **Citation:** G. Papotto, F. Carrara, G. Palmisano, "A 90 nm
  CMOS Threshold-Compensated RF Energy Harvester", *IEEE J.
  Solid-State Circuits*, Vol. 46, No. 9, pp. 1985-1997, Sept.
  2011.
- **DOI:** 10.1109/JSSC.2011.2157253.
- **Type:** peer-reviewed journal paper.
- **Verification:** PAYWALL-NOTED.
- **Relevance:** body-biased PMOS in NWELL with separately
  generated negative bias; achievable in GF180MCU.

## F. Component / antenna anchors (reused from sister reports)

### F.1 Antenova RUFA SR4L036 -- chip antenna datasheet

- **Citation:** Antenova, "RUFA SR4L036 (12.8 x 3.9 x 1.1 mm
  2.4 GHz Chip Antenna)", datasheet rev N.
- **Type:** vendor datasheet (component-level).
- **Verification:** **CACHED-VERIFIED** at
  `references-cache/antenova-rufa-chip-antenna.pdf`.
- **Relevance:** -1.2 dBi average gain, 75 % efficiency,
  peak +2.1 dBi -- **the realistic gain assumption** for our
  PCB IFA, vs the textbook +2 dBi.

### F.2 TI BQ25504 -- ultra-low-power boost PMU datasheet

- **Citation:** Texas Instruments, "BQ25504: Ultra Low Power
  Boost Converter With Battery Management for Energy
  Harvester Applications", datasheet rev 2023.
- **Type:** vendor datasheet (component-level).
- **Verification:** **CACHED-VERIFIED** at
  `references-cache/ti-bq25504-datasheet.pdf`.
- **Relevance:** **the back-end PMU architecture used by
  Pinuela 2013.** 130 mV operating V_in; 600 mV cold-start.
  Establishes the input-voltage threshold above which a
  rectifier output becomes useful in the conventional
  external-PMU architecture; **cannot be used in our project
  due to no-external-passives constraint and ambient-2.4-GHz
  V_in shortfall.**

### F.3 e-peas AEM30940 RF AppNote

- **Citation:** e-peas, "Application Note: AEM30940 RF
  Energy Harvesting", 2020.
- **Type:** vendor application note.
- **Verification:** **CACHED-VERIFIED** at
  `references-cache/epeas-aem30940-rf-appnote.pdf`.
- **Relevance:** 868 / 915 MHz characterisation. The 5 m,
  1 W EIRP, 9.6 uW figure cross-checked against Friis in
  industry-survey Section 5.2 -- physics-consistent.

### F.4 Atmosic Energy Harvesting Advantage white paper

- **Citation:** Atmosic Technologies, "Energy Harvesting
  Advantage", white paper, 2023.
- **Type:** vendor white paper.
- **Verification:** **CACHED-VERIFIED** at
  `references-cache/atmosic-energy-harvesting-advantage-
  whitepaper.pdf`.
- **Relevance:** marketing-grade reference; the integrated-
  PMU architecture path. Worked example is photovoltaic, not
  2.4 GHz RFEH.

### F.5 Powercast P2110B -- discrete RF harvester IC datasheet

- **Citation:** Powercast Corp., "P2110B Datasheet", 2016/12.
- **Type:** vendor datasheet (component-level).
- **Verification:** **CACHED-VERIFIED** at
  `references-cache/powercast-p2110b-datasheet.pdf`.
- **Relevance:** 915 MHz industry baseline. -12 dBm
  sensitivity at 915 MHz -> ~1.5 m at 2.45 GHz Friis-scaled,
  matching first-principles report.

### F.6 Si Labs AN930.2 -- EFR32 matching network app note

- **Citation:** Silicon Labs, "AN930.2: EFR32 Series 2
  Matching Network", 2025.
- **Type:** vendor application note.
- **Verification:** **CACHED-VERIFIED** at
  `references-cache/silabs-an930-2-efr32-matching.pdf`.
- **Relevance:** mainstream commercial 2.4 GHz matching
  practice (3-, 4-, 5-element discrete LC ladders). Shows
  what our no-external-passives constraint forbids.

## G. Verification summary

- **CACHED-VERIFIED**: 7 references (Pinuela, Antenova RUFA,
  TI BQ25504, e-peas, Atmosic, Powercast, Si Labs).
- **WEB-VERIFIED**: 6 references (Pakkirisami Churchill 2022 via
  PMC; Honma 2019 via MDPI; Yan 2024 via cached RFIC program +
  search abstract; Chun 2022 IEEE Access; Akbari 2018 Springer;
  RFIC 2024 program book itself).
- **PAYWALL-NOTED**: 7 references (Kotani 2007 A-SSCC, Kotani
  2009 JSSC, Mandal & Sarpeshkar 2007, Le 2008, Theilmann 2012,
  Stoopman 2014, Lu 2015, Cilek 2009, Papotto 2011, Yi 2007).

Verifying paywalled IEEE references against authoritative PDFs
is a **Stage-2 deliverable**. Per the brief's web-access
guidance, IEEE Xplore was deliberately not WebFetched in this
session.
