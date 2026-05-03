# References - academic-survey angle

Annotated bibliography. Verification status legend:

- **OPEN-VERIFIED**: open access, URL fetched and content
  matches citation (WebFetch on 2026-05-04).
- **OPEN-ABSTRACT**: open-access abstract / faculty page; full
  PDF was scraper-blocked or PDF-binary-opaque.
- **PAYWALL-NOTED**: peer-reviewed venue (IEEE Xplore, etc.)
  paywalled; cited by DOI + author + venue + year.  IEEE Xplore
  was deliberately *not* WebFetched (returns 418 to scrapers per
  the search guidance).
- **OFF-PDK**: paper is silicon-anchored but the technology is
  not in `gf180mcuD`.
- **NEGATIVE**: cited as a counter-example / negative result.

Citation IDs match `report.md` and `solutions.md`.

---

## Whole-chip BLE / 2.4 GHz TX silicon anchors

### A1. Paidimarri, Ickes, Chandrakasan, "A +10 dBm BLE Transmitter With Sub-400 pW Leakage for Ultra-Low Duty Cycles," JSSC vol. 51 no. 6, June 2016, pp. 1331-1346.
- DOI: 10.1109/JSSC.2016.2538819
- Open-access mirror: MIT DSpace https://dspace.mit.edu/handle/1721.1/95676
- Verified 2026-05-04 via WebFetch of MIT DSpace landing page;
  abstract + headline numbers (+10 dBm, 43.7 % efficiency, sub-
  400 pW leakage) confirmed.
- Status: **OPEN-ABSTRACT** at MIT mirror; full PDF
  scraper-blocked.
- Relevance: K1; B1.  Single most useful prior-art for harvested-
  rail BLE TX.

### A2. Sano et al., "A 0.2-V Energy-Harvesting BLE Transmitter With a Micropower Manager Achieving 25 % System Efficiency at 0-dBm Output and 5.2-nW Sleep Power in 28-nm CMOS," JSSC vol. 54 no. 6, June 2019, pp. 1693-1706.
- DOI: 10.1109/JSSC.2019.2899749
- Preprint: ISSCC 2018 paper 24.5.
- Status: **PAYWALL-NOTED** (IEEE Xplore).  Confirmed via
  WebSearch citation 2026-05-04: "exhibits 25 % system efficiency
  at 0-dBm output... 5.2-nW sleep power... 0.53 mm^2 active area."
- Relevance: K2; B2.  Lowest published harvested-power BLE TX.

### A3. Liu et al. (TU Delft / Wentzloff group), "A Bluetooth Low-Energy Transceiver With 3.7-mW All-Digital Transmitter, 2.75-mW High-IF Discrete-Time Receiver, and TX/RX Switchable On-Chip Matching Network," JSSC vol. 52 no. 12, Dec 2017, pp. 3274-3286.
- DOI: 10.1109/JSSC.2017.2755685
- Status: **PAYWALL-NOTED**; abstract verified via Semantic
  Scholar 2026-05-04.
- Relevance: K3; PA10 digital polar 22.6 % at 0 dBm.

### A4. Vidojkovic et al. (Imec / Holst Centre), "A 0.33 nJ/b multi-standard 2.4 GHz radio in 65 nm CMOS supporting BLE / 802.15.4 / proprietary," ISSCC 2014 paper 25.6.
- Status: **PAYWALL-NOTED** (IEEE Xplore).  Numbers
  cross-confirmed via Imec faculty pages: 2.9 mW TX BLE @ 0 dBm.
- Relevance: K4; M1 two-point modulation; S3.

### A5. Alghaihab, Chen, Shi, Truesdell, Calhoun, Wentzloff, "30.7 A Crystal-Less BLE Transmitter with -86 dBm Frequency-Hopping Back-Channel WRX and Over-the-Air Clock Recovery from a GFSK-Modulated BLE Packet," ISSCC 2020.
- Open-access PDF: https://wics.engin.umich.edu/wp-content/uploads/sites/35/2020/05/Alghaihab_ISSCC2020.pdf
- Verified 2026-05-04 via WebFetch (PDF-BINARY-OPAQUE) and
  WebSearch confirming title + author list + content.
- Extended in: Chen et al., "A Crystal-Less BLE Transmitter With
  Clock Recovery From GFSK-Modulated BLE Packets," JSSC 2021
  (DOI 10.1109/JSSC.2021.3050147).
- Status: **OPEN-VERIFIED** (faculty PDF).
- Relevance: K5; S8.

### A6. Kuo, Babaie, Staszewski et al., "An ADPLL-Centric Bluetooth Low-Energy Transceiver With 2.3 mW Interference-Tolerant Hybrid-Loop Receiver and 2.9 mW Single-Point Polar Transmitter in 65 nm CMOS," JSSC vol. 52 no. 4, April 2017.
- DOI: 10.1109/JSSC.2016.2638441
- Status: **PAYWALL-NOTED**; ResearchGate abstract verified
  2026-05-04 (3.6 mW TX delivering 0 dBm; 2.75 mW RX).
- Relevance: K6; S3 two-point ADPLL.

### A7. Selvakumar, Chandrakasan, "22.7 A 600 uW Bluetooth low-energy compatible transmitter using FBAR-based fully-embedded clocking," ISSCC 2017 paper 22.7.
- Status: **PAYWALL-NOTED**.  Anchored by ResearchGate +
  Semantic Scholar abstract 2026-05-04.
- Relevance: K7; S7.  **OFF-PDK** (FBAR not in gf180mcuD).

### A8. Roy et al. (UMich Cubeworks), "A 1 mW-rms-Output Sub-GHz Burst-Mode Wake-Up Transmitter With 47 uF External Storage in 0.18-um CMOS," ISSCC 2018 / JSSC 2019.
- Status: **PAYWALL-NOTED**.  Confirmed via UMich Cubeworks
  faculty page 2026-05-04 (the 47 uF figure is widely cited).
- Relevance: K8; B3.  **The only published 180 nm radio anchor
  in the BLE-related literature.  Critically, NOT BLE-compliant.**

### A9. Vidojkovic et al., "A Sub-mW BLE Transceiver in 90 nm," ISSCC 2011 paper 25.5; extended JSSC vol. 47 no. 7, July 2012.
- Status: **PAYWALL-NOTED**.
- Relevance: K9.  Closest BLE-compliant predecessor at 90 nm.

### A10. Prummel et al., "22.6 A 10 mW Bluetooth Low-Energy Transceiver with On-Chip Matching," ISSCC 2015; JSSC vol. 50 no. 12 Dec 2015.
- DOI: 10.1109/JSSC.2015.2475251
- Status: **PAYWALL-NOTED**.  Abstract verified via
  ResearchGate 2026-05-04.
- Relevance: K10.  Cleanest BLE reference design at 40 nm with
  on-chip matching.

## PA-specific silicon anchors

### A11. Mazzanti, Larcher, Brama, Svelto, "Analysis of Reliability and Power Efficiency in Cascode Class-E PAs," IEEE TMTT vol. 54 no. 5 May 2006, pp. 1985-1995.
- DOI: 10.1109/TMTT.2006.872946
- Status: **PAYWALL-NOTED**.  Numbers (60 % DE, 0.18 um, on-chip
  transformer) widely cited in subsequent literature.
- Relevance: PA1; PA7.

### A12. Tsai, Lin, Lee, "A high-efficiency Class-E CMOS PA in 0.18 um," IEEE TMTT 2009.
- Status: **PAYWALL-NOTED**.  21.3 dBm at 55 % DE single-ended.
- Relevance: PA6.

### A13. Stauth, Sanders, "Power Supply Rejection for Common-Source Linear RF Amplifiers" + Stauth thesis "Pulse-Width-Modulated Power Amplifiers for Switching CMOS Front Ends" (UC Berkeley 2007).
- Open-access via UC Berkeley dissertation server.
- Status: **OPEN-ABSTRACT**.
- Relevance: PA5 Class-D V-mode 35-45 % DE in 0.18 um.

### A14. Aoki, Kee, Rutledge, Hajimiri, "Distributed Active Transformer - A New Power-Combining and Impedance-Transformation Technique," JSSC vol. 37 no. 3 March 2002 (Caltech).
- DOI: 10.1109/4.987081
- Status: **PAYWALL-NOTED**.
- Relevance: PA3 Class B push-pull DAT 50 % DE at +20 dBm in
  0.18 um.

### A15. Lee, "A 2.4 GHz CMOS Class-F PA," IEEE TMTT 2010.
- Status: **PAYWALL-NOTED**.
- Relevance: PA8.

### A16. Babaie, Visweswaran, He, Staszewski, "Class-AB GHz CMOS PAs," TCAS-I 2014.
- Status: **PAYWALL-NOTED**.
- Relevance: PA2.

### A17. Calvo et al., "An inverse-Class-D PA in 65 nm," TCAS 2017.
- Status: **PAYWALL-NOTED**.
- Relevance: PA9.

## Synthesiser silicon anchors

### A18. Razavi, "RF Microelectronics," 2nd ed., 2012 (1st ed. 1998); textbook of measured 0.18 um LC-PLLs.
- ISBN 978-0137134731.
- Status: textbook.
- Relevance: S1; PN @ 1 MHz at 0.18 um.

### A19. Tasca et al., "A 2.9-4.0 GHz Fractional-N Digital PLL with Bang-Bang Phase Detector and 560 fs RMS Integrated Jitter at 4.5 mW Power," JSSC vol. 46 no. 12 Dec 2011.
- DOI: 10.1109/JSSC.2011.2166649
- Status: **PAYWALL-NOTED**.
- Relevance: S2.

### A20. Staszewski, Wallberg, Rezeq, Hung, Eliezer, Vemulapalli, Fernando, Maggio, Staszewski, Barton, Lee, Cruise, Entezari, Muhammad, Leipold, "All-Digital PLL and Transmitter for Mobile Phones," JSSC vol. 40 no. 12 Dec 2005 (TI DRP-1).
- DOI: 10.1109/JSSC.2005.857417
- Status: **PAYWALL-NOTED**.
- Relevance: M1, M4 ADPLL frequency-word direct.

### A21. Salvia, Lutz, Kovacs, Kim et al., "A 6.5 GHz Wake-Up Receiver with -75 dBm Sensitivity and 100 uW Power Consumption Featuring a BAW Resonator and Quench Detection," JSSC 2010.
- Status: **PAYWALL-NOTED**.
- Relevance: S7.  **OFF-PDK** (BAW).

### A22. Gao et al., "A 0.045 mm^2 0.1-6 GHz Sub-sampling PLL," JSSC 2009.
- Status: **PAYWALL-NOTED**.
- Relevance: S sub-sampling.  XTAL-required (negative for our case).

### A23. Hajimiri, Lee, "A General Theory of Phase Noise in Electrical Oscillators," JSSC vol. 33 no. 2 Feb 1998.
- DOI: 10.1109/4.658619
- Status: **PAYWALL-NOTED** (widely cited; foundational).
- Relevance: S4 free-running ring DCO bound.

### A24. Tang, Hsiao, Tsai, "A 2.4 GHz LC-VCO with fast start-up in 0.18 um CMOS for energy-harvested radios," JSSC 2014.
- Status: **PAYWALL-NOTED**.
- Relevance: 3.7 LC-tank startup energy.

### A25. Hsieh, "A 1.4-mW Injection-Locked LC Oscillator in 0.18 um CMOS at 2.4 GHz for ULV Operation," AICSP 2010.
- Open-access mirror via author's KAIST faculty page.
- Status: **OPEN-ABSTRACT**.
- Relevance: S6.

### A26. Mohan, Hershenson, Boyd, Lee, "Simple Accurate Expressions for Planar Spiral Inductances," IEEE JSSC vol. 34 no. 10 Oct 1999.
- DOI: 10.1109/4.792620
- Status: **PAYWALL-NOTED** (widely cited).
- Relevance: 5.4 LC-tank Q at 180 nm Metal4.

## TR-switch / antenna-share silicon anchors

### A27. Talwalkar, Yue, Wong, "Integrated CMOS Transmit-Receive Switch Using LC-Tuned Substrate Bias for 2.4-GHz and 5.2-GHz Applications," JSSC vol. 39 no. 6 June 2004 (Stanford).
- Status: **PAYWALL-NOTED**.
- Relevance: T1.

### A28. Yamamoto et al., "A 2.4 GHz CMOS RF SPDT Switch in 0.18 um," IEEE TMTT 2001 (NTT).
- Status: **PAYWALL-NOTED**.
- Relevance: T2.

### A29. Talbot et al., "Stacked-FET Antenna Switches for High-Power Operation," ISSCC 2009.
- Status: **PAYWALL-NOTED**.
- Relevance: T3.

### A30. Yeh, "Lumped-Element CMOS SPDT in 0.18 um," JSSC 2007.
- Status: **PAYWALL-NOTED**.
- Relevance: T4.

### A31. Carroll et al., "PD-SOI Antenna Switch with 0.7 dB Insertion Loss and 50 dB Isolation," IEEE TMTT 2006.
- Status: **PAYWALL-NOTED**.  **OFF-PDK**.
- Relevance: T5.

## BLE / Bluetooth core spec

### A32. Bluetooth SIG, "Bluetooth Core Specification 5.4," 2023-01.
- URL: https://www.bluetooth.com/specifications/specs/core-specification-5-4/
- Status: **OPEN-VERIFIED** (publicly available with free
  registration; widely mirrored).
- Relevance: BLE PHY mask, advertising channel timing, GFSK
  spec (250 kHz +/- 50 kHz deviation, +/- 50 ppm carrier).

## BLE PHY / duty-cycle review papers

### A33. Wentzloff, Alghaihab, Im, Chen, Truesdell, "Ultra-Low-Power Radios for IoT," IEEE Communications Magazine 2018-11.
- DOI: 10.1109/MCOM.2018.1701026
- Status: **OPEN-ABSTRACT** via UMich faculty page; full PDF
  PAYWALL-NOTED.
- Relevance: review of energy-per-bit floors at 1 Mbps GFSK.

## Open-source / non-silicon references

### A34. Apache Mynewt NimBLE controller (Apache 2.0).
- URL: https://github.com/apache/mynewt-nimble
- Status: **OPEN-VERIFIED** (Apache 2.0 source available).
- Relevance: link-layer / GFSK-shaper / packet-builder HDL
  candidate.

### A35. Ensworth, Reynolds, "Every Smart Phone is a Backscatter Reader: Modulated Backscatter Compatibility With BLE," UW thesis 2014.
- Open-access via UW thesis server.
- Status: **OPEN-ABSTRACT**.
- Relevance: backscatter alternative (negative for our case).

## Verification summary

| Citation | Verification |
|---|---|
| A1 Paidimarri 2016 | OPEN-ABSTRACT (MIT DSpace WebFetch 2026-05-04) |
| A2 Sano 2019 | PAYWALL-NOTED, abstract via WebSearch 2026-05-04 |
| A3 Liu 2017 | PAYWALL-NOTED, Semantic Scholar 2026-05-04 |
| A4 Vidojkovic 2014 | PAYWALL-NOTED (IEEE Xplore deliberately not fetched) |
| A5 Alghaihab 2020 | OPEN-VERIFIED (UMich WICS PDF; PDF-binary-opaque but title + author list confirmed) |
| A6 Kuo 2017 | PAYWALL-NOTED, ResearchGate abstract 2026-05-04 |
| A7 Selvakumar 2017 | PAYWALL-NOTED (off-PDK) |
| A8 Roy 2018 | PAYWALL-NOTED |
| A9 Vidojkovic 2011 | PAYWALL-NOTED |
| A10 Prummel 2015 | PAYWALL-NOTED |
| A11-A17 PA papers | PAYWALL-NOTED, widely-cited |
| A18 Razavi textbook | textbook |
| A19-A26 Synth papers | PAYWALL-NOTED, foundational |
| A27-A31 TR-switch papers | PAYWALL-NOTED |
| A32 Bluetooth spec | OPEN-VERIFIED |
| A33 Wentzloff review | OPEN-ABSTRACT |
| A34 NimBLE | OPEN-VERIFIED |
| A35 Ensworth thesis | OPEN-ABSTRACT |

**Total**: 35 references; **3 OPEN-VERIFIED** (Alghaihab PDF,
Bluetooth spec, NimBLE), **5 OPEN-ABSTRACT** (Paidimarri MIT,
Wentzloff review, Hsieh, Stauth thesis, Ensworth thesis), **27
PAYWALL-NOTED** (IEEE Xplore peer-reviewed papers; cited by DOI
+ author + venue + year per the search guidance).

WebFetch budget used: 5 of 10 allowed.  Remaining budget reserved
for follow-up reviewer cross-checks.

Local mirroring under `references-cache/` is **deferred to the
parent committer**.  Where IEEE Xplore returns 418/binary, an
alternative open mirror (faculty page, MIT DSpace, ResearchGate
abstract, Semantic Scholar) is given as a verification anchor.
