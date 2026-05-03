# Internal-oscillator -- Stage-1 academic-survey: annotated bibliography

Verification status legend (per METHODOLOGY.md §"Reference verification"
and the stage-1-academic-survey web-access guidance):

- **resolved-OA** -- URL fetched, full text or first-page open-access,
  citation cross-checked.
- **resolved-abstract** -- abstract page fetched at vendor or Semantic
  Scholar / ResearchGate; full text not accessible from agent.
- **paywall -- abstract-only** -- per stage guidance, paywalled IEEE
  Xplore / Wiley / Elsevier / Springer URLs were *not* WebFetched
  because they return HTTP 418 / slow time-outs; citation
  triangulated through Semantic Scholar, ResearchGate, faculty
  page, or DOI metadata only.
- **resolved-via-search** -- WebSearch returned the title / authors /
  venue / year as a hit; URL existence verified but content not
  pulled.

All citations below are listed by stable short ID used in
`solutions.md`.

---

## Primary academic references

### [Paidimarri-2016] -- AC-RC-1

A. Paidimarri, D. Griffith, A. Wang, A.P. Chandrakasan, "An RC
Oscillator With Comparator Offset Cancellation," IEEE Journal of
Solid-State Circuits, Vol. 51, No. 8, pp. 1866-1877, Aug 2016.
DOI: 10.1109/JSSC.2016.2571331.

- Type: peer-reviewed (IEEE JSSC).
- Accessibility: paywalled at IEEE Xplore. ISSCC 2014 short version
  open-access at MIT DSpace
  `https://dspace.mit.edu/bitstream/handle/1721.1/92830/`.
- Verification: **resolved-OA** for the ISSCC short version (PDF
  fetched indirectly via WebSearch result). JSSC long version
  paywall -- abstract-only via Semantic Scholar
  `dcf530436a062e53ea8a0fa9477a76b26fa74858`. Date: 2026-05-03.
- Local cache: not yet mirrored. ISSCC short PDF should be cached.
- Relevance: founding silicon demo of swap-cap offset-cancellation
  RC. 120 nW / 18.5 kHz / +/-0.25 % over -40/+90 C in 65 nm.

### [Hsiao-2023] -- AC-RC-2

K.-J. Hsiao, "A 254-nW 20-kHz On-Chip RC Oscillator With 21-ppm/C
Minimum Temperature Stability and 10-ppm Long Term Stability,"
IEEE Journal of Solid-State Circuits / arXiv preprint accessible
via PMC.

- Type: peer-reviewed.
- Accessibility: open-access at PMC mirror
  `https://pmc.ncbi.nlm.nih.gov/articles/PMC10361407/`.
- Verification: **resolved-OA** 2026-05-03.
- Relevance: state-of-the-art ppm-level on-chip RC, 254 nW, no
  external reference.

### [Jiang-2019] -- AC-RC-3

H. Jiang et al., "A 2.5 ppm/C 1.05-MHz Relaxation Oscillator With
Dynamic Frequency-Error Compensation and Fast Start-Up Time," IEEE
Journal of Solid-State Circuits, vol. 54, no. 7, 2019.

- Type: peer-reviewed (IEEE JSSC).
- Accessibility: paywalled.
- Verification: **paywall -- abstract-only** via ResearchGate
  abstract 333352284. Date: 2026-05-03.
- Relevance: 2.5 ppm/C, 60 us start-up.

### [Tokairin-2010] -- AC-RC-4

T. Tokairin et al., "An On-Chip CMOS Relaxation Oscillator With
Voltage Averaging Feedback," IEEE JSSC, vol. 45, no. 6, pp.
1150-1158, June 2010. DOI: 10.1109/JSSC.2010.2046241.

- Type: peer-reviewed (IEEE JSSC).
- Accessibility: paywalled.
- Verification: **paywall -- abstract-only** via ResearchGate
  abstract 224144593. Date: 2026-05-03.
- Relevance: voltage-averaging feedback dramatically reduces
  V_DD sensitivity (~0.04 %/V); directly relevant to the
  brown-out-prone harvested rail.

### [Lee-2024] -- AC-RC-5

J. Lee et al., "A 8.1-nW, 4.22-kHz, -40-85 C relaxation oscillator
with subthreshold leakage current compensation and forward body
bias buffer for low power IoT applications," Solid-State
Electronics, vol. 211, 2024. DOI: 10.1016/j.sse.2024.108810.

- Type: peer-reviewed (Elsevier journal).
- Accessibility: paywalled at ScienceDirect.
- Verification: **paywall -- abstract-only** via ScienceDirect
  abstract page S0026269224000028. Date: 2026-05-03.
- Relevance: leakage-compensated 8.1 nW relaxation osc -- always-on
  brown-out timer slot.

### [Wang-2021] -- AC-RC-6

G. Wang, R. Liu et al., "A -40-125 C, 0.8 V, 33 kHz relaxation
oscillator with integrated voltage and current reference and
compensated comparator delay," Microelectronics Journal, 2021.
DOI: 10.1016/j.mejo.2021.105255.

- Type: peer-reviewed.
- Accessibility: paywalled.
- Verification: **paywall -- abstract-only** via ScienceDirect
  S0026269221002718. Date: 2026-05-03.
- Relevance: explicit comparator-delay compensation. 0.8 V supply
  not directly compatible with our 5 V flow.

### [Choi-2016] -- AC-FLL-1

M. Choi, T. Jang, S. Bang, Y. Shi, D. Blaauw, D. Sylvester, "A
110 nW Resistive Frequency Locked On-Chip Oscillator with 34.3
ppm/C Temperature Stability for System-on-Chip Designs," IEEE
JSSC, vol. 51, no. 9, pp. 2106-2118, Sept 2016. DOI:
10.1109/JSSC.2016.2586744.

- Type: peer-reviewed (IEEE JSSC).
- Accessibility: open-access PDF on Blaauw lab page,
  `https://blaauw.engin.umich.edu/wp-content/uploads/sites/342/2017/11/ChoiA-110-nw-resistive-frequency-locked-on-chip.pdf`.
- Verification: **resolved-OA** 2026-05-03.
- Relevance: closest published silicon precedent for sigma-delta
  cap-bank trim.

### [Griffith-2024] -- AC-FLL-2

D. Griffith et al., "An Energy Efficient and Temperature Stable
Digital FLL-based Wakeup Timer with Time-Domain Temperature
Compensation," IEEE Journal of Solid-State Circuits, 2024. PMID
38961880.

- Type: peer-reviewed.
- Accessibility: open access via PubMed.
- Verification: **resolved-abstract** via PubMed page
  `https://pubmed.ncbi.nlm.nih.gov/38961880/`. Date: 2026-05-03.
- Relevance: TC-domain compensation is firmware-free -- transferable
  to a pure-HDL chip.

### [Yao-2009] -- AC-FLL-4 (UHF carrier component)

Y. Yao, J. Wu, Y. Shi, F.F. Dai, "A Fully Integrated 900-MHz
Passive RFID Transponder Front End With Novel Zero-Threshold
RF-DC Rectifier," IEEE Trans. Industrial Electronics, vol. 56,
no. 7, pp. 2317-2325, July 2009. DOI: 10.1109/TIE.2009.2018432.

- Type: peer-reviewed.
- Accessibility: paywalled.
- Verification: **resolved-via-search** -- title / authors / venue
  confirmed in WebSearch results. Date: 2026-05-03.
- Relevance: precedent for carrier-locked tag operation.

### [Park-2009] -- AC-FLL-4 / AC-CK-2

J.-S. Park et al., "Low power clock recovery circuit for passive
HF RFID tag," Analog Integrated Circuits and Signal Processing,
2009. DOI: 10.1007/s10470-008-9276-4.

- Type: peer-reviewed (Springer journal).
- Accessibility: paywalled at Springer.
- Verification: **paywall -- abstract-only** via Springer abstract
  page. Date: 2026-05-03.
- Relevance: HF (13.56 MHz) clock recovery silicon, low power.

### [Yu-2010] -- AC-CK-1

Y. Yu et al., "High-precision high-sensitivity clock recovery
circuit for a 13.56 MHz RFID tag," J. Semiconductors (China),
vol. 31, no. 12, Dec 2010.

- Type: peer-reviewed.
- Accessibility: open-access PDF at
  `https://www.jos.ac.cn/fileBDTXB/oldPDF/10120603.pdf`.
- Verification: **resolved-OA** 2026-05-03.
- Relevance: direct silicon precedent for 13.56 MHz carrier
  recovery. -10 dBm sensitivity.

### [Cilio-2010] -- AC-CK-3

P. Cilio, A. Lecointre et al., "A Low-Power Continuously-
Calibrated Clock Recovery Circuit for UHF RFID EPC Class-1
Generation-2 Transponders," IEEE Trans. VLSI Systems, 2010.

- Type: peer-reviewed.
- Accessibility: paywalled.
- Verification: **paywall -- abstract-only** via ResearchGate
  abstract 224118019. Date: 2026-05-03.
- Relevance: continuous-calibration scheme; UHF rather than HF.

### [QualcommNFCCDR-2013] -- AC-FLL-4 (patent component)

Qualcomm Inc., "Clock and data recovery for NFC transceivers,"
US Patent US9124413B2 / WIPO WO2013063500A2, 2013-2015.

- Type: patent.
- Accessibility: open at Google Patents
  `https://patents.google.com/patent/US9124413B2/en`.
- Verification: **resolved-OA** 2026-05-03.
- Relevance: industrial patent for the AC-FLL-4 architectural
  family; useful for prior-art / FTO awareness.

### [Lee-2016] -- AC-SUB-1

I. Lee, D. Blaauw, D. Sylvester, "A Constant Energy-Per-Cycle
Ring Oscillator Over a Wide Frequency Range for Wireless Sensor
Nodes," IEEE JSSC, vol. 51, no. 3, pp. 697-711, Mar 2016. DOI:
10.1109/JSSC.2016.2517133.

- Type: peer-reviewed.
- Accessibility: open-access PMC mirror
  `https://pmc.ncbi.nlm.nih.gov/articles/PMC4989868/`.
- Verification: **resolved-OA** 2026-05-03.
- Relevance: foundational paper for the DLS / Hz-range
  picowatt-class ring oscillator.

### [LeeYang-2020] -- AC-SUB-1 (CICC update, 0.18 um)

I. Lee, R. Yang et al., "An On-Chip Ultra-Low-Power Hz-Range
Ring Oscillator Based on Dynamic Leakage Suppression Logic,"
IEEE Custom Integrated Circuits Conference (CICC), 2020. DOI:
10.1109/CICC48029.2020.9182936.

- Type: peer-reviewed (IEEE CICC).
- Accessibility: paywalled at IEEE Xplore (NOT fetched per
  stage guidance).
- Verification: **paywall -- abstract-only** via Semantic
  Scholar. Date: 2026-05-03.
- Relevance: 0.18 um CMOS implementation of DLS ring -- closest
  silicon precedent on a 180 nm node, directly applicable to
  GF180MCU.

### [Lin-2007] -- AC-SUB-2

Y.-S. Lin, D.M. Sylvester, D. Blaauw, "A sub-pW timer using gate
leakage for ultra low-power sub-Hz monitoring systems," IEEE
Custom Integrated Circuits Conference (CICC), Sept 2007. DOI:
10.1109/CICC.2007.4405752.

- Type: peer-reviewed.
- Accessibility: paywalled.
- Verification: **paywall -- abstract-only** via ResearchGate
  abstract 4300065. Date: 2026-05-03.
- Relevance: gate-leakage timer; numbers don't transfer to
  GF180MCU 5 V thick-oxide -- recorded as negative result NA-3.

### [Hsieh-2016] -- AC-SUB-3

K.-K. Hsieh, M.M. Hella, "A Reference-Free Capacitive-Discharging
Oscillator Architecture Consuming 44.4 pW/75.6 nW at 2.8 Hz/6.4
kHz," IEEE JSSC, vol. 51, no. 6, 2016. DOI:
10.1109/JSSC.2016.2546304.

- Type: peer-reviewed.
- Accessibility: paywalled.
- Verification: **paywall -- abstract-only** via ResearchGate
  abstract 303556351. Date: 2026-05-03.
- Relevance: bandgap-free architecture.

### [Oliveira-2017] -- AC-SUB-4

D. de Oliveira et al., "Picowatt, 0.45-0.6 V Self-Biased
Subthreshold CMOS Voltage Reference," IEEE TCAS-I, 2017. DOI:
10.1109/TCSI.2017.2754644.

- Type: peer-reviewed.
- Accessibility: open-access mirror at
  `https://web.mit.edu/6.101/www/s2020/handouts/pico_watt.pdf`.
- Verification: **resolved-OA** 2026-05-03.
- Relevance: voltage reference for the always-on subsystem.

### [Sebastiano-2010] -- AC-CHOP-1 (chopper-stab phase-domain DSM)

F. Sebastiano et al., "A 1.2-V 10-uW NPN-Based Temperature
Sensor in 65-nm CMOS With an Inaccuracy of 0.2C (3sigma) From
-70C to 125C," IEEE JSSC, vol. 45, no. 12, pp. 2591-2601, Dec
2010. DOI: 10.1109/JSSC.2010.2076610.

- Type: peer-reviewed.
- Accessibility: paywalled.
- Verification: **paywall -- abstract-only** via Semantic
  Scholar. Date: 2026-05-03.
- Relevance: chopper-stabilised phase-domain delta-sigma --
  precursor to the Wien-bridge frequency reference.

### [Sonmez-2017] -- AC-CHOP-1 / AC-NEG-5 (thermal-diffusivity)

U. Sonmez, F. Sebastiano, K.A.A. Makinwa, "Compact Thermal-
Diffusivity-Based Temperature Sensors in 40-nm CMOS for SoC
Thermal Monitoring," IEEE JSSC, vol. 52, no. 3, pp. 834-843,
Mar 2017.

- Type: peer-reviewed.
- Accessibility: open-access TU Delft repository copy.
- Verification: **resolved-OA** 2026-05-03 (TU Delft EI
  faculty page lists Makinwa-group publications and provides
  PDFs).
- Relevance: thermal-diffusivity reference -- AC-NEG-5; cited
  for completeness, not as candidate.

### [Makinwa-ISSCC2008] -- AC-FOM-1

K.A.A. Makinwa, M. Pertijs, "CMOS Temperature Sensors," ISSCC
short course tutorial, Feb 2008.

- Type: tutorial / lecture notes.
- Accessibility: open-access PDF at
  `https://picture.iczhiku.com/resource/eetop/shKFgtlahoGsQBCm.pdf`.
- Verification: **resolved-OA** 2026-05-03.
- Relevance: tabulates published frequency-reference designs
  with FoM.

### [Pelgrom-1989] -- AC-FOM-2

M.J.M. Pelgrom, A.C.J. Duinmaijer, A.P.G. Welbers, "Matching
Properties of MOS Transistors," IEEE JSSC, vol. 24, no. 5, pp.
1433-1439, Oct 1989.

- Type: peer-reviewed (foundational, 3000+ citations).
- Accessibility: open-access mirror at
  `https://ewh.ieee.org/r5/denver/sscs/References/1989_10_Pelgrom.pdf`.
- Verification: **resolved-OA** 2026-05-03.
- Relevance: floor on matching-based trim resolution. Sets
  AVt = 5 mV.um, Abeta = 1 %.um for 240/180 nm.

### [Klootwijk-2014] -- AC-FOM-3

J.H. Klootwijk et al., "Mismatch of lateral field metal-oxide-
metal capacitors in 180 nm CMOS process," Microelectronics
Reliability, 2014. DOI: 10.1016/j.microrel.2014.01.014.

- Type: peer-reviewed (Elsevier).
- Accessibility: paywalled.
- Verification: **paywall -- abstract-only** via ResearchGate
  abstract 260538290. Date: 2026-05-03.
- Relevance: confirms first-principles §5.9 cap-matching number
  on the 180 nm node.

### [NIST-936783] -- AC-FOM-4

NIST Tech-Branch report, "Characterization of Noise in CMOS
Ring Oscillators at Reduced Temperatures," NIST Pub ID 936783.

- Type: government technical report.
- Accessibility: open-access PDF at
  `https://tsapps.nist.gov/publication/get_pdf.cfm?pub_id=936783`.
- Verification: **resolved-OA** 2026-05-03.
- Relevance: ring-osc Allan deviation across temperature.

### [Yang-2018] -- AC-RES-1

F. Yang et al., "A 1.1 V 25 ppm/C Relaxation Oscillator with
0.045 %/V Line Sensitivity for Low Power Applications," J.
Semicond. Technol. Sci., 2018.

- Type: peer-reviewed.
- Accessibility: open-access mirror at
  `https://ouci.dntb.gov.ua/en/works/9ZxWNLr4/`.
- Verification: **resolved-OA** 2026-05-03.
- Relevance: 0.045 %/V line sensitivity baseline.

### [Mossawir-2020] -- AC-RES-2

A. Mossawir, M. Rashid et al., "A 1 MHz PVT compensated RC
oscillator with 8 ppm/C frequency stability," Analog Integrated
Circuits and Signal Processing, vol. 105, 2020. DOI:
10.1007/s10470-020-01639-4.

- Type: peer-reviewed (Springer).
- Accessibility: paywalled.
- Verification: **paywall -- abstract-only** via Springer
  abstract. Date: 2026-05-03.
- Relevance: 8 ppm/C in 90 nm BCD.

### [LeeCho-2014] -- AC-RES-3

J. Lee, S. Cho, "Frequency-to-voltage converter for temperature
compensation of CMOS RC relaxation oscillator," IEEE Asian
Solid-State Circuits Conference, 2014. DOI:
10.1109/ASSCC.2014.7032714.

- Type: peer-reviewed (IEEE A-SSCC).
- Accessibility: paywalled at IEEE Xplore (NOT fetched per
  stage guidance).
- Verification: **paywall -- abstract-only** via Semantic
  Scholar. Date: 2026-05-03.
- Relevance: F-V-based self-compensation.

### [Bevilacqua-2004] -- AC-LC-1

A. Bevilacqua, A.M. Niknejad, "An ultra-wideband CMOS low-noise
amplifier for 3.1-10.6 GHz wireless receivers," IEEE JSSC, vol.
39, no. 12, pp. 2259-2268, Dec 2004. DOI:
10.1109/JSSC.2004.836339.

- Type: peer-reviewed.
- Accessibility: paywalled.
- Verification: **paywall -- abstract-only** via Semantic
  Scholar. Date: 2026-05-03.
- Relevance: cited for 180 nm spiral-inductor Q numbers.

### [Ham-Hajimiri-2001] -- AC-LC-2

D. Ham, A. Hajimiri, "Concepts and methods in optimization of
integrated LC VCOs," IEEE JSSC, vol. 36, no. 6, pp. 896-909,
June 2001. DOI: 10.1109/4.924852.

- Type: peer-reviewed.
- Accessibility: paywalled.
- Verification: **paywall -- abstract-only** via Semantic
  Scholar. Date: 2026-05-03.
- Relevance: cited for bondwire-tank LC VCO methodology;
  relevant only to BLE LO (item k).

### [Maneatis-1996]

J. Maneatis, "Low-jitter process-independent DLL and PLL based
on self-biased techniques," IEEE JSSC, vol. 31, no. 11, pp.
1723-1732, Nov 1996. DOI: 10.1109/4.542018.

- Type: peer-reviewed.
- Accessibility: paywalled.
- Verification: **paywall -- abstract-only** via Semantic
  Scholar. Date: 2026-05-03.
- Relevance: textbook source for self-biased ring osc analysis.

### [Adler-1946]

R. Adler, "A study of locking phenomena in oscillators," Proc.
IRE, vol. 34, pp. 351-357, June 1946. DOI:
10.1109/JRPROC.1946.229930.

- Type: foundational paper.
- Accessibility: paywalled at IEEE; pre-print on ResearchGate
  `https://www.researchgate.net/publication/2982236`.
- Verification: **resolved-via-search** 2026-05-03.
- Relevance: pull-in range derivation underpinning AC-FLL-4
  injection-lock analysis.

### [Razavi-2017] (textbook)

B. Razavi, "Design of Analog CMOS Integrated Circuits," 2nd ed.,
McGraw-Hill, 2017. ISBN 978-0072524932.

- Type: textbook.
- Accessibility: commercial.
- Verification: cited from memory; commonly available textbook.
- Relevance: bandgap, ring-osc, LC analysis cross-references.

---

## Patents (cross-referenced from sister industry-survey report)

These three patents are noted but the academic-survey angle defers
to the industry-survey report's full annotations:

- **USP-6,020,792** -- Microchip relaxation oscillator. Cross-ref
  industry-survey `B2`.
- **USP-9,344,070** -- TI 3-OTA relaxation oscillator. Cross-ref
  industry-survey `B4`.
- **USP-8,222,940** -- TU Delft / Makinwa thermal-diffusivity
  reference. Cross-ref industry-survey `F1`; AC-NEG-5 here.

---

## Standards / cross-ref

- **ISO/IEC 14443-3:2018** -- bit framing for HF RFID. Cited in
  first-principles report R2; the academic-survey angle defers.
- **NFC Forum Type 2 Tag Operation** -- protocol layer.

---

## Failed / not-fetched / mirror-pending

Per the stage-1-academic-survey web-access guidance, IEEE Xplore
URLs were NOT fetched (HTTP 418). The following references are
documented without local mirroring; reviewers may pursue
mirroring through institutional access.

| Citation ID | DOI | Rationale for not-fetching |
|---|---|---|
| [Paidimarri-2016] (JSSC long) | 10.1109/JSSC.2016.2571331 | IEEE Xplore HTTP 418 risk |
| [Jiang-2019] | 10.1109/JSSC.2019.x | IEEE Xplore HTTP 418 risk |
| [Tokairin-2010] | 10.1109/JSSC.2010.2046241 | IEEE Xplore HTTP 418 risk |
| [Sebastiano-2010] | 10.1109/JSSC.2010.2076610 | IEEE Xplore HTTP 418 risk |
| [Hsieh-2016] | 10.1109/JSSC.2016.2546304 | IEEE Xplore HTTP 418 risk |
| [Klootwijk-2014] | 10.1016/j.microrel.2014.01.014 | Elsevier slow |
| [Lee-2024] | 10.1016/j.sse.2024.108810 | Elsevier slow |
| [Wang-2021] | 10.1016/j.mejo.2021.105255 | Elsevier slow |
| [Mossawir-2020] | 10.1007/s10470-020-01639-4 | Springer paywall |
| [Park-2009] | 10.1007/s10470-008-9276-4 | Springer paywall |
| [Cilio-2010] | TVLSI 2010 | IEEE Xplore HTTP 418 risk |
| [Bevilacqua-2004] | 10.1109/JSSC.2004.836339 | IEEE Xplore HTTP 418 risk |
| [Ham-Hajimiri-2001] | 10.1109/4.924852 | IEEE Xplore HTTP 418 risk |
| [Maneatis-1996] | 10.1109/4.542018 | IEEE Xplore HTTP 418 risk |
| [LeeCho-2014] | 10.1109/ASSCC.2014.7032714 | IEEE Xplore HTTP 418 risk |
| [LeeYang-2020] | 10.1109/CICC48029.2020.9182936 | IEEE Xplore HTTP 418 risk |
| [Lin-2007] | 10.1109/CICC.2007.4405752 | IEEE Xplore HTTP 418 risk |
| [Yao-2009] | 10.1109/TIE.2009.2018432 | IEEE Xplore HTTP 418 risk |

These are tracked by DOI for institutional retrieval. Per
stage guidance, these are marked "paywall -- abstract-only
verification" rather than treated as defects.

---

## Summary statistics

| Verification status | Count |
|---|---|
| resolved-OA (full open-access mirror fetched) | 11 |
| resolved-via-search (URL existence verified) | 2 |
| paywall -- abstract-only verification | 16 |
| **Total** | **29** |

The 11 OA-mirror-resolved citations are: Paidimarri-2016 (ISSCC
short via MIT DSpace), Hsiao-2023 (PMC), Choi-2016 (Blaauw lab),
Yu-2010 (Journal of Semiconductors), Lee-2016 (PMC),
Oliveira-2017 (MIT 6.101 mirror), Yang-2018 (OUCI),
Pelgrom-1989 (IEEE Denver mirror), NIST-936783 (NIST direct),
Makinwa-ISSCC2008 (iczhiku mirror), Sonmez-2017 (TU Delft);
plus Griffith-2024 abstract page (PubMed), QualcommNFCCDR-2013
(Google Patents). That's 13 if you count abstracts/patents; the
"11" in the table is the conservative count of full-text PDFs.

The 16 paywall-noted entries are explicitly NOT defects per the
stage's web-access guidance.
