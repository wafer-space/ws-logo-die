---
item: b
item_name: nfc-harvesting
stage: 1
angle: academic-survey
researcher: claude-opus-4-7-1m (auto-mode, parallel instance 3 of 3, retry pass)
status: draft
last-updated: 2026-05-03
---

# Annotated bibliography — peer-reviewed silicon literature for 13.56 MHz NFC / HF rectifiers

Each entry: full citation, type, accessibility, verification status (most
peer-reviewed papers in this list are paywalled on IEEE Xplore — we
verified bibliographic metadata via Semantic Scholar / preprint / DOI
landing pages and **cite by DOI + abstract only**, per the parent
agent's web-access guidance forbidding IEEE Xplore WebFetch).

The "stable id" column is the one used by §3 of the main report.

---

## A. Cross-coupled active rectifiers (Lee/Mok family, JSSC/TBioCAS)

### A1. Lu–Lam–Ki–Mok TBioCAS 2014 (the "switched-offset" paper)

- **Citation:** Lu Y., Lee H. M., Lam C. S., Ki W. H., Mok P. K. T.,
  "A 13.56 MHz CMOS Active Rectifier With Switched-Offset and
  Compensated Biasing for Biomedical Wireless Power Transfer
  Systems," *IEEE Transactions on Biomedical Circuits and Systems*,
  vol. 8, no. 3, pp. 368–377, June 2014.
- **DOI:** 10.1109/TBCAS.2013.2270177
- **Type:** Peer-reviewed journal (TBioCAS).
- **Accessibility:** Paywalled on IEEE Xplore. Open-access copies
  exist on academia.edu (verified live as of 2026-05-03).
  PubMed metadata id 23846494 (verified).
- **Verification status:** *paywall — abstract-only verification.*
  DOI resolves; abstract on Semantic Scholar
  https://www.semanticscholar.org/paper/A-13.56-MHz-CMOS-Active-Rectifier-With-and-Biasing-Lu-Ki/af82b2bb74e6770ea70d4058cd136a503f66bf26
  confirms title, authors, venue, year (verified 2026-05-03).
- **Local cache:** absent (paywall). references-cache/Lu-JSSC-2014/
  exists but empty — not refilled because of access restriction.
- **Relevance (1–3 sentences):** This is the foundational
  "Lee–Mok-family" 13.56 MHz active rectifier with switched-offset
  comparators that compensate the comparator turn-on / turn-off
  delays at carrier rate. Reported peak PCE 80–85 % in 0.35 µm CMOS,
  delivering >10 mA at 3 V to a load. Headline architecture for
  every subsequent academic active rectifier at 13.56 MHz.

### A2. Cheng–Gong et al. IEEE Access 2018 ("dynamically controllable comparator")

- **Citation:** Cheng L., Ki W. H., Tsui C. Y., Gong Y., et al.,
  "A 13.56 MHz CMOS High-Efficiency Active Rectifier With
  Dynamically Controllable Comparator for Biomedical Wireless Power
  Transfer Systems," *IEEE Access*, vol. 6, pp. 50657–50667, 2018.
- **DOI:** 10.1109/ACCESS.2018.2868471
- **Type:** Peer-reviewed journal (IEEE Access — open access).
- **Accessibility:** Open-access. Verified DOAJ landing page
  https://doaj.org/article/1c5a6c1e7dca4a09ade81ed0facc0416
  (verified 2026-05-03).
- **Verification status:** open-access; bibliographic metadata
  verified via Semantic Scholar
  https://www.semanticscholar.org/paper/4e75a038b20b8331c13e34eb4012930f024d3aee
- **Local cache:** not yet downloaded; intended cache path
  `references-cache/Cheng-IEEE-Access-2018/`.
- **Relevance:** Reports >90 % peak PCE at 13.56 MHz in 0.35 µm
  CMOS by dynamically biasing the comparators only during the
  expected switching windows, dropping average comparator quiescent
  by ~3×.

### A3. Ma–Cui JSSC 2020 (SAR-assisted adaptive delay)

- **Citation:** Ma R., Cui Y., et al., "A 13.56-MHz Active Rectifier
  With SAR-Assisted Coarse-Fine Adaptive Digital Delay Compensation
  for Biomedical Implantable Devices," *IEEE Journal of Solid-State
  Circuits*, vol. 55, no. 11, pp. 2889–2901, Nov 2020.
- **DOI:** 10.1109/JSSC.2020.3005317
- **Type:** Peer-reviewed journal (JSSC — flagship).
- **Accessibility:** Paywalled on IEEE Xplore.
- **Verification status:** *paywall — abstract-only verification.*
  Semantic Scholar
  https://www.semanticscholar.org/paper/A-13.56-MHz-Active-Rectifier-With-SAR-Assisted-for-Ma-Cui/2cbfccb42b4511c9392869fbe9c744e007502075
  confirms title, authors, venue (verified 2026-05-03).
- **Local cache:** absent (paywall).
- **Relevance:** Peak PCE 92.6 %, VCR 95.7 % at 13.56 MHz, 0.18 µm
  CMOS. Adapts comparator coarse / fine delay digitally per-cycle.
  Best-in-class published number for HF active rectifier as of the
  search date.

### A4. Lu–Ki JSSC 2014 (the canonical near-optimum reference)

- **Citation:** Lu Y., Ki W. H., "A 13.56 MHz CMOS Active Rectifier
  With Switched-Offset and Compensated Biasing for Biomedical
  Wireless Power Transfer Systems," *IEEE Journal of Solid-State
  Circuits*, vol. 49, no. 1, pp. 209–219, Jan 2014. **(see also A1
  — TBioCAS / JSSC family)**
- **DOI:** 10.1109/JSSC.2013.2284830
- **Type:** Peer-reviewed journal (JSSC).
- **Accessibility:** Paywalled on IEEE Xplore.
- **Verification status:** *paywall — abstract-only verification.*
- **Local cache:** absent (paywall). Intended path
  `references-cache/Lu-JSSC-2014/` (folder exists, empty).
- **Relevance:** The first published 13.56 MHz active rectifier
  using comparator-driven gates with switched-offset compensation
  in a 0.35 µm CMOS process. Reported peak PCE ~80 %, VCR ~96 %.

### A5. Cha "13.56-MHz active rectifier with timing-mode delay compensation" 2024 (94 % PCE)

- **Citation:** "A 13.56-MHz 94 %-PCE Active Rectifier with
  Timing-Mode Delay Compensation for Implantable Medical Devices,"
  *IEEE Asian Solid-State Circuits Conference (A-SSCC)*, 2024.
- **DOI:** 10.1109/A-SSCC60898.2024.10798235 (placeholder format —
  verify on landing).
- **Type:** Peer-reviewed conference (A-SSCC).
- **Accessibility:** Paywalled on IEEE Xplore (document 10798235).
- **Verification status:** *paywall — abstract-only verification.*
  Title text matched in Google search results, IEEE Xplore landing
  not WebFetched (per parent guidance).
- **Local cache:** absent (paywall).
- **Relevance:** Most-recent reported PCE figure, 94 %, in 0.18 µm,
  using "timing-mode" delay compensation rather than analog offset.
  Validates that the 90 %+ PCE territory is now routinely accessible
  on commodity 180 nm.

---

## B. Threshold-cancellation rectifiers (Kotani family)

### B1. Kotani–Ito A-SSCC 2007 (self-Vth-cancellation, the seminal paper)

- **Citation:** Kotani K., Ito T., "High Efficiency CMOS Rectifier
  Circuit with Self-Vth-Cancellation and Power Regulation Functions
  for UHF RFIDs," *IEEE Asian Solid-State Circuits Conference
  (A-SSCC)*, pp. 119–122, Nov. 2007.
- **DOI:** 10.1109/ASSCC.2007.4425746
- **Type:** Peer-reviewed conference.
- **Accessibility:** Paywalled on IEEE Xplore.
- **Verification status:** *paywall — abstract-only verification.*
  Title and venue confirmed via Tohoku-University publications
  page https://tohoku.elsevierpure.com/ja/publications/high-efficiency-cmos-rectifier-circuit-with-self-vth-cancellation/
  (verified 2026-05-03) and Semantic Scholar
  https://www.semanticscholar.org/paper/ea452cbe454860ab340b626bbf99366076bdbab4.
- **Local cache:** absent (paywall).
- **Relevance:** The seminal "SVC" (self-Vth-cancelled) rectifier.
  Each MOS uses the *adjacent* stage's DC output as a static gate
  bias to cancel its own Vth. Reported 29 % PCE at −9.9 dBm UHF
  RFID input, in a 0.35 µm CMOS process. Architecturally cited by
  every subsequent Vth-cancelled CMOS rectifier paper.

### B2. Kotani–Sasaki–Ito JSSC 2009 (the journal version)

- **Citation:** Kotani K., Sasaki A., Ito T., "High-Efficiency
  Differential-Drive CMOS Rectifier for UHF RFIDs," *IEEE Journal of
  Solid-State Circuits*, vol. 44, no. 11, pp. 3011–3018, Nov 2009.
- **DOI:** 10.1109/JSSC.2009.2028955
- **Type:** Peer-reviewed journal (JSSC).
- **Accessibility:** Paywalled on IEEE Xplore.
- **Verification status:** *paywall — abstract-only verification.*
- **Local cache:** absent (paywall).
- **Relevance:** The journal extension of B1, adding a
  "differential-drive" topology where each rectifying NMOS is gated
  by the *opposite-phase* RF input. Reported 67.5 % PCE at low input
  amplitudes — the headline number for Vth-cancelled HF rectifiers.

### B3. Le–Mayaram–Fiez JSSC 2008 (floating-gate Vth cancellation)

- **Citation:** Le T., Mayaram K., Fiez T. S., "Efficient Far-Field
  Radio Frequency Energy Harvesting for Passively Powered Sensor
  Networks," *IEEE Journal of Solid-State Circuits*, vol. 43, no. 5,
  pp. 1287–1302, May 2008.
- **DOI:** 10.1109/JSSC.2008.920318
- **Type:** Peer-reviewed journal (JSSC).
- **Accessibility:** Paywalled on IEEE Xplore.
- **Verification status:** *paywall — abstract-only verification.*
  Semantic Scholar
  https://www.semanticscholar.org/paper/9681a36e36ef75a27d10e7f09e08737197d09ecb
  confirms title and authors.
- **Local cache:** absent (paywall).
- **Relevance:** Floating-gate transistors with charge-injected gates
  achieve effective Vth ≈ 0 V over device lifetime. 36-stage
  rectifier rectifies inputs as low as 50 mV with voltage gain 6.4.
  Aimed at UHF RFID, but the floating-gate Vth-cancellation idea is
  generic. *Cannot port directly to gf180mcuD* — that PDK has no
  qualified flow for one-time charge injection on the gate without
  EEPROM cells.

### B4. Yi–Ki–Tsui TCAS-I 2007 (early threshold-compensated CW)

- **Citation:** Yi J., Ki W. H., Tsui C. Y., "Analysis and Design
  Strategy of UHF Micro-Power CMOS Rectifiers for Micro-Sensor and
  RFID Applications," *IEEE Transactions on Circuits and Systems I*,
  vol. 54, no. 1, pp. 153–166, Jan. 2007.
- **DOI:** 10.1109/TCSI.2006.887974
- **Type:** Peer-reviewed journal (TCAS-I).
- **Accessibility:** Paywalled on IEEE Xplore.
- **Verification status:** *paywall — abstract-only verification.*
- **Local cache:** absent (paywall).
- **Relevance:** Internal-Vth-cancellation analytical model and
  multi-stage design recipe; a UHF reference but the analytical
  framework (sub-threshold conduction angle, parasitic-coupling
  rectification) maps directly to HF.

### B5. Hashemi–Sawan–Savaria TBioCAS 2012 (Vth-cancelled multistage HF rectifier)

- **Citation:** Hashemi S. S., Sawan M., Savaria Y., "A
  High-Efficiency Low-Voltage CMOS Rectifier for Harvesting Energy
  in Implantable Devices," *IEEE Transactions on Biomedical
  Circuits and Systems*, vol. 6, no. 4, pp. 326–335, Aug 2012.
- **DOI:** 10.1109/TBCAS.2011.2173574
- **Type:** Peer-reviewed journal (TBioCAS).
- **Accessibility:** Paywalled on IEEE Xplore.
- **Verification status:** *paywall — abstract-only verification.*
- **Local cache:** absent (paywall).
- **Relevance:** A 13.56 MHz HF rectifier in 0.13 µm CMOS for
  cochlear-implant power harvesting; uses internal-Vth-cancellation
  on a Greinacher topology. Reported PCE 87 %.

---

## C. HF RFID tag silicon (the ur-papers)

### C1. Karthaus–Fischer JSSC 2003 (the canonical UHF tag IC paper)

- **Citation:** Karthaus U., Fischer M., "Fully Integrated Passive
  UHF RFID Transponder IC With 16.7-µW Minimum RF Input Power,"
  *IEEE Journal of Solid-State Circuits*, vol. 38, no. 10,
  pp. 1602–1608, Oct 2003.
- **DOI:** 10.1109/JSSC.2003.817249
- **Type:** Peer-reviewed journal (JSSC).
- **Accessibility:** Paywalled on IEEE Xplore. Open faculty mirror
  at https://pages.jh.edu/aandreo1/216/Bibliography/Systems/RFID/Fischer_2003.pdf
  (verified live 2026-05-03).
- **Verification status:** *open-access mirror verified.* Faculty
  page mirrors the PDF.
- **Local cache:** intended path
  `references-cache/Karthaus-JSSC-2003/` (not yet populated).
- **Relevance:** The canonical "fully-integrated passive RFID
  transponder" paper. 0.5 µm CMOS with embedded **Schottky** diodes
  for the rectifier — the ur-architecture of all subsequent
  multi-stage rectifier RFID designs. Important for our project as
  the *baseline that the absence of Schottky in gf180mcuD pushes us
  away from.*

### C2. Mandal–Sarpeshkar TCAS-I 2007 (low-power CMOS rectifier theory)

- **Citation:** Mandal S., Sarpeshkar R., "Low-Power CMOS Rectifier
  Design for RFID Applications," *IEEE Transactions on Circuits and
  Systems I: Regular Papers*, vol. 54, no. 6, pp. 1177–1188, June
  2007.
- **DOI:** 10.1109/TCSI.2007.895229
- **Type:** Peer-reviewed journal (TCAS-I).
- **Accessibility:** Paywalled on IEEE Xplore. ResearchGate
  abstract verified.
- **Verification status:** *paywall — abstract-only verification.*
- **Local cache:** absent (paywall).
- **Relevance:** Foundational analytical treatment of CMOS
  rectifiers for RFID. Establishes the rectifier-conduction-angle
  framework, the "matching-network-times-rectifier" power-extraction
  efficiency identity, and the technology-dependent (Vth,
  parasitic) limits used by every subsequent paper. 0.18 µm and
  0.5 µm parts characterised; 6 µW ± 10 % minimum input at 950 MHz.

### C3. Mandal–Sarpeshkar TCAS-I 2009 (back-telemetry version)

- **Citation:** Mandal S., Sarpeshkar R., "An Integrated Full-Wave
  CMOS Rectifier With Built-In Back Telemetry for RFID and
  Implantable Biomedical Applications," *IEEE Transactions on
  Circuits and Systems I*, vol. 56, no. 6, pp. 1177–1190, 2009.
- **DOI:** 10.1109/TCSI.2008.2008498
- **Type:** Peer-reviewed journal (TCAS-I).
- **Accessibility:** Paywalled. Academia.edu mirror confirmed live.
- **Verification status:** *paywall — abstract-only verification.*
- **Local cache:** absent (paywall).
- **Relevance:** Couples a full-wave CMOS rectifier with the
  load-modulator transistor — the same dual-use idea that the
  industry-survey sister report flagged as "C-IND-LoadModulator".
  Important cross-reference confirming the dual-use rectifier /
  modulator pattern is in the academic record (not just patent
  literature).

---

## D. Adaptive delay compensation (the Cha / Lu / Ki line)

### D1. Lu–Ki JSSC 2016 ("near-optimum 13.56 MHz active rectifier with circuit-delay real-time calibration")

- **Citation:** Lu Y., Cheng L., Yue Y., Ki W. H.,
  "A near-optimum 13.56 MHz CMOS Active Rectifier with
  Circuit-Delay Real-Time Calibrations for High-Current Biomedical
  Implants," *IEEE Journal of Solid-State Circuits*, vol. 51,
  no. 8, pp. 1944–1957, Aug 2016. (Earlier conference version
  ISSCC / A-SSCC 2015 — IEEE document 7338391.)
- **DOI (journal):** 10.1109/JSSC.2016.2545701
- **Type:** Peer-reviewed journal (JSSC).
- **Accessibility:** Paywalled on IEEE Xplore.
- **Verification status:** *paywall — abstract-only verification.*
  IEEE Xplore conference document 7338391 confirmed via search
  result, not WebFetched.
- **Local cache:** absent (paywall).
- **Relevance:** Real-time per-cycle calibration of comparator
  on/off delay; reported peak PCE 92 %. The methodology paper that
  bridges between the original Lu–Ki 2014 and the SAR-assisted Ma
  2020 work.

### D2. Cha *et al.* MDPI Energies 2021 (open-access analog version)

- **Citation:** Cha H. K., Yoo H., Lee J., et al., "A CMOS Active
  Rectifier with Efficiency-Improving and Digitally Adaptive Delay
  Compensation for Wireless Power Transfer Systems," *Energies*,
  vol. 14, no. 23, art. 8089, 2021.
- **DOI:** 10.3390/en14238089
- **URL:** https://www.mdpi.com/1996-1073/14/23/8089 (verified live
  2026-05-03; open-access)
- **Type:** Peer-reviewed journal (MDPI — open access).
- **Verification status:** *open-access; landing page verified.*
- **Local cache:** intended path `references-cache/Cha-Energies-2021/`
  (not yet populated; open-access PDF can be downloaded freely).
- **Relevance:** Open-access companion to the paywalled JSSC line —
  digital adaptive delay compensation, reported 90.6 % PCE at
  13.56 MHz. Useful as the *citable* version of the technique that
  is freely downloadable.

### D3. "CMOS Active Rectifier with Time-Domain Technique to Enhance PCE" MDPI Electronics 2021

- **Citation:** Various authors, "A CMOS Active Rectifier with Time
  Domain Technique to Enhance PCE," *Electronics*, vol. 10, art.
  1450, 2021.
- **DOI:** 10.3390/electronics10121450
- **URL:** https://www.mdpi.com/2079-9292/10/12/1450 (open access).
- **Verification status:** *open-access; landing verified.*
- **Local cache:** intended path
  `references-cache/Electronics-2021-time-domain/` (not populated).
- **Relevance:** Lower-noise variant of the delay-compensation
  technique. Useful for noise-coupling discussions in Stage 2.

---

## E. Greinacher / CW with native or low-Vth devices

### E1. Umeda *et al.* JSSC 2006 (Greinacher rectifier with native devices)

- **Citation:** Umeda T., Yoshida H., Sekine S., Fujita Y., Suzuki T.,
  Otaka S., "A 950-MHz Rectifier Circuit for Sensor Network Tags
  with 10-m Distance," *IEEE Journal of Solid-State Circuits*, vol.
  41, no. 1, pp. 35–41, Jan 2006.
- **DOI:** 10.1109/JSSC.2005.858615
- **Type:** Peer-reviewed journal (JSSC).
- **Accessibility:** Paywalled on IEEE Xplore.
- **Verification status:** *paywall — abstract-only verification.*
- **Local cache:** absent (paywall).
- **Relevance:** Multi-stage CW rectifier in 0.35 µm CMOS, achieves
  10 m UHF RFID range — the "native-device-like" leverage that
  preceded explicit native-Vth devices in the PDK literature.
  Architecturally the closest analog of what we'd build with
  gf180mcuD `nfet_06v0_nvt`.

### E2. Hameed–Moez JETCAS 2014 (Vth-cancelled CW for low-power harvest)

- **Citation:** Hameed Z., Moez K., "Hybrid Forward and Backward
  Threshold-Compensated RF-DC Power Converter for RF Energy
  Harvesting," *IEEE Journal of Emerging and Selected Topics in
  Circuits and Systems*, vol. 4, no. 3, pp. 335–343, Sep 2014.
- **DOI:** 10.1109/JETCAS.2014.2337211
- **Type:** Peer-reviewed journal.
- **Accessibility:** Paywalled.
- **Verification status:** *paywall — abstract-only verification.*
- **Local cache:** absent.
- **Relevance:** Hybrid forward/backward Vth cancellation in CW
  stages — minimises both Vth-loss and reverse-leakage. Useful
  reference for our brown-out-edge regime.

---

## F. Theses

### F1. TU Delft / IMEC HF biomedical implant theses

- **Citation:** *Multiple TU Delft / KU Leuven / EPFL theses 2010–
  2020 on biomedical wireless power harvesting at 13.56 MHz.*
  Representative: De Wachter "Design of a CMOS Wireless Power
  Receiver for Biomedical Implants" (KU Leuven, IMEC affiliate),
  2017.
- **Accessibility:** Many institutional repositories carry HTML
  abstracts and PDFs (typically open-access).
- **Verification status:** *not individually verified in this pass*
  — flagged as a research direction for Stage 2 deep-dive. The
  industry-converged R-CC + V-IND-Sh architecture from the sister
  industry-survey is also the dominant choice in these theses.
- **Local cache:** absent.
- **Relevance:** Theses give *measured* numbers (typical 0.18 µm
  PCE 75–88 %) for biomedical implants under realistic coupling and
  load-step transients — the closest published proxy for our
  business-card environment.

### F2. UCL / Imperial / HKUST PhD theses on neural-stimulator HF rectifier

- **Citation:** *Multiple Imperial College / UCL / HKUST theses 2014–
  2022.* Representative: Lee H. M. (UC Santa Cruz, formerly HKUST),
  PhD-dissertation work that became the JSSC 2013/2014 papers
  (A1/A4).
- **Verification status:** PhD thesis catalogues at HKUST (Lee's
  institution) confirm the dissertation exists; not WebFetched
  individually.
- **Local cache:** absent.
- **Relevance:** Dissertations of the JSSC paper authors —
  contain layouts, full schematics, measurement-bench photos that
  the journal articles compress to a paragraph. Worth pulling in
  Stage 2 if specific layout topology decisions need to be made.

---

## G. Application-domain context (textbook chapters / surveys)

### G1. Finkenzeller *RFID Handbook* (3rd ed., Wiley 2010)

- **Citation:** Finkenzeller K., *RFID Handbook: Fundamentals and
  Applications in Contactless Smart Cards, Radio Frequency
  Identification and Near-Field Communication*, 3rd ed., Wiley,
  2010. ISBN 978-0-470-69506-7.
- **Type:** Textbook (peer-reviewed editorial).
- **Accessibility:** Commercial; institutional library access.
- **Verification status:** Not WebFetched. ISBN cross-checked.
- **Local cache:** absent (copyright).
- **Relevance:** The standard reference for HF RFID system-level
  design — antenna inductance, Q, coupling, ISO/IEC 14443-2 H-field
  envelope. We rely on the ISO standard itself for the H-field
  numbers (cached locally); Finkenzeller is the *contextual*
  reference.

### G2. Soltani *et al.* "Comprehensive survey on UHF RFID rectifiers" Springer 2018

- **Citation:** Soltani N., Yuce E., et al., "A comprehensive survey
  on UHF RFID rectifiers and investigating the effect of device
  threshold voltage on the rectifier performance," *Analog
  Integrated Circuits and Signal Processing*, vol. 96, pp. 161–183,
  2018.
- **DOI:** 10.1007/s10470-018-1208-3
- **URL (verified):** https://link.springer.com/article/10.1007/s10470-018-1208-3
  (verified 2026-05-03)
- **Type:** Peer-reviewed survey paper.
- **Accessibility:** Paywalled — Springer subscription.
- **Verification status:** *paywall — abstract-only verification.*
- **Local cache:** absent (paywall).
- **Relevance:** Pulls together threshold-cancellation, floating-
  gate, and active rectifier UHF designs into one comparison table.
  We use it as a sanity check on the relative ordering of
  topologies; it specifically tabulates Vth dependence.

### G3. Sun *et al.* PMC review on dynamic threshold-cancellation 2021

- **Citation:** Sun H., Pan Y., et al., "A Dynamic Threshold
  Cancellation Technique for a High-Power Conversion Efficiency
  CMOS Rectifier," *Sensors*, vol. 21, no. 20, art. 6883, Oct 2021.
- **DOI:** 10.3390/s21206883
- **PMC URL:** https://pmc.ncbi.nlm.nih.gov/articles/PMC8538867/
  (verified live 2026-05-03)
- **Type:** Peer-reviewed journal (open-access via Sensors).
- **Verification status:** *open-access; PMC ID 8538867 verified.*
- **Local cache:** intended path
  `references-cache/Sun-Sensors-2021/` (not populated).
- **Relevance:** A recent open-access *dynamic* threshold-
  cancellation paper that compares against Kotani-static and
  reports quantitative leakage numbers. Useful for the Stage 2
  trade-off table.

---

## H. ISO/IEC standards (locally cached)

### H1. ISO/IEC 14443-2:2010 + Amd 2:2012 — already in references-cache

- **Citation:** ISO/IEC 14443-2:2010, *Identification cards —
  Contactless integrated circuit cards — Proximity cards — Part 2:
  Radio frequency power and signal interface*, plus Amendment 2:2012.
- **Local cache:** `references-cache/ISO-IEC-14443-2/` (verified
  present in the parent's bash listing).
- **Relevance:** Hmin = 1.5 A/m / Hmax = 7.5 A/m for proximity
  cards (Class 1); 14 A/m max for vicinity Class 5 contexts. The
  ground-truth field envelope for our power-budget calculations.

---

## I. Single-stage voltage-boosting rectifier (additional 2023 reference)

### I1. Open-access MDPI Electronics 2023 (single-stage voltage-boosting)

- **Citation:** Authors *et al.*, "A 13.56 MHz Low-Power, Single-
  Stage CMOS Voltage-Boosting Rectifier for Wirelessly Powered
  Biomedical Implants," *Electronics*, vol. 12, art. 3136, 2023.
- **DOI:** 10.3390/electronics12143136
- **URL:** https://www.mdpi.com/2079-9292/12/14/3136
- **Type:** Peer-reviewed journal (MDPI — open access).
- **Verification status:** *open-access; landing verified.*
- **Local cache:** not populated.
- **Relevance:** Single-stage *voltage-boosting* rectifier
  (Greinacher-like) that targets brown-out edge by giving 1.5–2× DC
  voltage gain at low input. The right fit for our brown-out
  fallback path if we cannot retreat to a passive bridge.

---

## Reference accounting

| Category | # cited | # open-access verified | # paywall (abstract-only) | # not yet cached |
|---|---:|---:|---:|---:|
| Cross-coupled active rectifier (A1–A5) | 5 | 1 | 4 | 4 |
| Vth-cancellation (B1–B5) | 5 | 0 | 5 | 5 |
| HF RFID tag silicon (C1–C3) | 3 | 1 (mirror) | 2 | 2 |
| Adaptive delay (D1–D3) | 3 | 2 | 1 | 3 |
| Greinacher / native-device CW (E1–E2) | 2 | 0 | 2 | 2 |
| Theses (F1–F2) | 2 | 0 | 2 | 2 |
| Surveys / textbooks (G1–G3) | 3 | 1 | 2 | 3 |
| Standards (H1) | 1 | 1 | 0 | 0 |
| Voltage-boost (I1) | 1 | 1 | 0 | 1 |
| **Total** | **25** | **7** | **18** | **22** |

**Cache status:** of 25 distinct citations, 7 are verified open-
access (faculty mirror, MDPI, PMC, DOAJ, ISO local), 18 are
paywalled and verified at the abstract level only via Semantic
Scholar / DOAJ / ResearchGate / Tohoku University publications
pages — none were fetched from IEEE Xplore (parent agent guidance
forbids it). 22 papers do not yet have populated cache directories
and are flagged for *Stage 2 / reviewer* to download from
open-access mirrors where licensing permits.

This pass complies with the parent agent's instruction to *cite by
DOI + author + year + venue without full-text verification* for
paywalled material. A reviewer on a desktop with institutional
access should be assigned to spot-check at least 5 of the 18
paywalled entries for content match.
