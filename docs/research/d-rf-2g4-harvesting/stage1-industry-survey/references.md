# References — item (d) Stage-1 industry-survey

Annotated bibliography. Verification status as of 2026-05-03.
Cached PDFs live in `../references-cache/`.

## I1 — Powercast P2110B 915 MHz RF Powerharvester Receiver

- **Citation:** Powercast Corporation, "P2110B 915 MHz RF
  Powerharvester Receiver," datasheet rev 2016/12.
- **URL (vendor):** https://www.powercastco.com (page reorganised;
  direct PDF URL returned 404 on 2026-05-03 — datasheet was cached
  in a prior agent's session).
- **Type:** Datasheet.
- **Verification status:** **VERIFIED 2026-05-03** (cached PDF read
  end-to-end in this session). Quoted facts: "Operation down to
  -12 dBm input power"; "RF input ... 902-928 MHz ... will operate
  outside this band with reduced efficiency"; "Boost efficiency:
  85 % typ" at I_out=20 mA; "Internally matched to 50 ohms".
- **Local cache:** `references-cache/powercast-p2110b-datasheet.pdf`
  (3.08 MB).
- **Relevance:** The closest commercial RFEH IC datasheet; primary
  industry anchor for sensitivity / efficiency claims at 915 MHz.
  Frequency-mismatch to our 2.4 GHz target is what motivates the
  Friis re-derivation in `report.md` §5.1.

## I2 — Powercast P21XXCSR-EVB Powerharvester Chipset Reference Design

- **Citation:** Powercast Corporation, "P21XXCSR-EVB v2.0,"
  datasheet 2018/5.
- **Verification status:** **VERIFIED 2026-05-03** (cached PDF
  read in this session). Quoted facts: J6 SMA = "Wi-Fi 2.4 GHz"
  band, six bands total; storage caps "C1 = 2200 µF", "C3 =
  50 mF"; underlying chips listed as PCC110 + PCC210.
- **Local cache:**
  `references-cache/powercast-p21xxcsr-evb-datasheet.pdf` (2.30 MB).
- **Relevance:** Establishes that Powercast's only 2.45 GHz
  product is the multi-band evaluation board, not a dedicated
  2.4 GHz IC. The supercap-scale storage (50 mF) reveals the
  energy-storage architecture commercial RFEH actually uses —
  far above the on-die nF we can realistically build.

## I3 — Powercast PCC110 / PCC210 Powerharvester Chipset

- **Citation:** Powercast Corporation, "PCC110 RF-to-DC Converter"
  + "PCC210 Boost Converter."
- **URL:** https://www.powercastco.com/ (product brief listed but
  individual datasheet PDFs returned 404 on 2026-05-03).
- **Verification status:** **VERIFICATION PARTIAL** — confirmed via
  third-party search snippets: "PCC110 ... is designed to maximize
  RF to DC conversion efficiency, up to 75%, while supporting a
  wide range of input power levels"; available at DigiKey/Mouser
  ($3.12–3.54 each, in stock). Distributor product summaries
  agree on its role as the reusable RF-to-DC chip behind the
  P21XXCSR-EVB at 2.45 GHz.
- **Action for Stage-2 reviewer:** Mirror the actual PCC110 + PCC210
  datasheet PDFs.
- **Relevance:** The closest commercial precedent to what we want
  to build (a band-flexible RF rectifier IC). Q1 in
  `open-questions.md` depends on resolving its 2.45 GHz spec.

## I4 — e-peas AEM30940 RF Energy Harvesting Application Note

- **Citation:** e-peas SA, "RF Energy Harvesting with the
  AEM30940," PRELIMINARY / Copyright 2020.
- **Verification status:** **VERIFIED 2026-05-03** (cached PDF
  read in this session). Quoted facts: "We did first focus on the
  frequency bands (868 MHz or 915 MHz). For other frequencies,
  please refer to applicable regulations"; "using a non-dedicated
  RF source (such as WiFi, 3G, 4G or Bluetooth) prevents control
  on the antenna and on the real emitted power"; Tables 4 & 6 of
  available average power vs distance and EIRP at both bands.
- **Local cache:** `references-cache/epeas-aem30940-rf-appnote.pdf`
  (594 KB).
- **Relevance:** The most candid commercial vendor about the
  ambient-vs-cooperative distinction. Tables provide Friis-
  consistent power-vs-distance numbers that we extrapolate to
  2.45 GHz in `report.md` §5.3.

## I5 — Texas Instruments BQ25504 Ultra-Low-Power Boost Converter

- **Citation:** Texas Instruments Inc., "BQ25504 Ultra-Low-Power
  Boost Converter With Battery Management For Energy Harvester
  Applications," SLUSAH0G — October 2011, revised August 2023.
- **URL:** https://www.ti.com/product/BQ25504
- **Verification status:** **VERIFIED 2026-05-03** (cached PDF
  read in this session). Quoted facts: "V_IN ≥ 130 mV (Typical)"
  ultra-low-power operating threshold; "Cold-start voltage:
  V_IN ≥ 600 mV (typical)"; "I_Q < 330 nA"; integrated MPPT.
- **Local cache:** `references-cache/ti-bq25504-datasheet.pdf`
  (2.73 MB).
- **Relevance:** Industry-canonical back-end PMIC for any harvester
  → battery-or-cap → load chain. Sets the 130 mV / 600 mV
  voltage thresholds that any *competing* on-die SC charge pump
  must meet.

## I6 — Antenova RUFA 2.4 GHz SMD Antenna

- **Citation:** Antenova, "Rufa 2.4 GHz SMD Antenna," Product
  Specification AE020157-M, P/N 3030A5839 / 3030A5887.
- **Verification status:** **VERIFIED 2026-05-03** (cached PDF
  read in this session). Quoted facts: "Frequency 2.4 - 2.5 GHz";
  "Peak gain 2.1 dBi"; "Average gain -1.2 dBi"; "Average
  efficiency 75 %"; "Maximum Return Loss -11 dB"; "Maximum VSWR
  1.8:1"; "Dimensions 12.8 × 3.9 × 1.1 mm".
- **Local cache:** `references-cache/antenova-rufa-chip-antenna.pdf`
  (554 KB).
- **Relevance:** The -1.2 dBi *average* gain (vs 2.1 dBi peak) is a
  key reality check on textbook 2 dBi IFA assumptions —
  `report.md` §5.5.

## I7 — Silicon Labs AN930.2 EFR32 Series 2 2.4 GHz Matching Guide

- **Citation:** Silicon Laboratories, "AN930.2: EFR32 Series 2 2.4
  GHz Matching Guide," Rev. 1.6, Copyright 2025.
- **Verification status:** **VERIFIED 2026-05-03** (cached PDF
  read in this session). Quoted facts: "4-element discrete LC
  match for up to 0 dBm power levels"; "3-element discrete LC
  match for up to +10 dBm"; "5-element discrete LC match for up
  to +20 dBm power levels"; the EFR32xG28 uses "4-element discrete
  LCLC ladder matching circuit with an additional series
  dc-blocking capacitor".
- **Local cache:** `references-cache/silabs-an930-2-efr32-matching.pdf`
  (2.29 MB).
- **Relevance:** The reference for "what mainstream commercial
  2.4 GHz radios do for matching" — they all use 3- to 5-element
  off-board LC ladders. Our no-external-passives constraint rules
  out this entire reference-design family.

## I8 — Silicon Labs EFR32 BG24 BLE SoC product page

- **Citation:** Silicon Laboratories, "EFR32BG24 Series 2 SoCs"
  (BLE 5.4 with AI/ML).
- **URL:** https://www.silabs.com/wireless/bluetooth/efr32bg24-series-2-socs
- **Verification status:** **VERIFIED 2026-05-03** by WebFetch.
  Quoted facts: "1 Mbit/s GFSK: -97.6 dBm sensitivity" (QFN);
  "-98.1 dBm" (CSP); "125 kbps GFSK: -105.7 dBm sensitivity".
- **Relevance:** Anchors the 80-dB-or-so gap between BLE
  *bit-detection* sensitivity and *energy-harvest* sensitivity
  used in `report.md` §3.F.3.

## I9 — Atmosic Energy Harvesting Advantage white paper

- **Citation:** Atmosic Technologies, "Atmosic Energy Harvesting
  Advantage," Doc. No. ATM-WPEHA-0051, v0.51, February 3, 2023.
- **URL:** https://www.atmosic.com/atmosic-energy-harvesting/
  (PDF embedded; fetched binary, content extracted).
- **Verification status:** **VERIFIED 2026-05-03** (cached locally
  and read in this session). Quoted facts: "Whether using a
  photovoltaic cell, TEG, RF energy captured with an antenna, or
  mechanical harvester there must be a match between the amount
  of energy that can be captured and the needs of the
  application"; the worked-example load is "a remote control with
  a 12 cm² PV cell" — *not* a 2.4 GHz RFEH demonstrator;
  end-to-end efficiency (boost mode) "60-66 %".
- **Local cache:** `references-cache/atmosic-energy-harvesting-advantage-whitepaper.pdf`
  (788 KB). SHA-256 `39acf50f26295cee0fd3fc1e7c74486c79a5ffe0c9893e6fb6f663cf91ae1caa`.
- **Relevance:** Critical for the report's "Atmosic 'RF
  harvesting' is not an integrated 2.4 GHz rectifier" finding.
  Confirms Atmosic's contribution is a generic harvester PMU
  inside a BLE SoC — not silicon that itself rectifies 2.4 GHz.

## I10 — Atmosic Product Selector Guide

- **Citation:** Atmosic Technologies, product page describing
  ATM3 / ATM33e / ATM34e parts.
- **URL:** https://www.atmosic.com/products/
- **Verification status:** **VERIFIED 2026-05-03** by WebFetch.
  Quoted facts: ATM33 series includes "Bluetooth 5.3" radio with
  "Transmit power of 10 dBm", "Cortex-M33 application core
  running at 64 MHz", "Up to 1536 KB non-volatile memory and 128
  KB RAM"; ATM33e/ATM34e add energy harvesting support.
- **Relevance:** Confirms there is no published 2.4 GHz RFEH
  sensitivity number for Atmosic parts. The "energy harvesting"
  marketing label means "PMU accepts harvested DC", not "BLE
  radio rectifies its own RX channel".

## I11 — Wiliot IoT Pixels (Wikipedia entry)

- **Citation:** Wikipedia, "Wiliot," accessed 2026-05-03.
- **URL:** https://en.wikipedia.org/wiki/Wiliot
- **Verification status:** **VERIFIED 2026-05-03** by WebFetch.
  Quoted facts: IoT Pixels are "postage stamp-sized printed
  computer[s]" that "power themselves through energy harvesting
  from ambient Wi-Fi, cellular, and Bluetooth signals"; ARM
  Cortex-M0+ + BLE; cost under 10 cents each. No specific
  sensitivity numbers in the Wikipedia entry.
- **Relevance:** Sole commercial example of a battery-free 2.4 GHz
  BLE chip claimed to harvest from ambient signals. The lack of
  a published sensitivity figure in either the Wikipedia page or
  Wiliot's own product page is itself informative — it suggests
  the practical operating point is energizer-dependent.

## I12 — FCC 47 CFR §15.247 (Cornell LII mirror)

- **Citation:** US Federal Communications Commission, 47 CFR
  §15.247, "Operation within the bands 902-928 MHz, 2400-2483.5
  MHz, and 5725-5850 MHz."
- **URL:** https://www.law.cornell.edu/cfr/text/47/15.247
- **Verification status:** **VERIFIED 2026-05-03** by WebFetch.
  Quoted facts: 2.4 GHz digitally-modulated systems: 1 W max peak
  conducted output; "The conducted output power limit ... is
  based on the use of antennas with directional gains that do not
  exceed 6 dBi"; +1 dB power reduction per +3 dB antenna gain
  above 6 dBi for non-fixed P2P.
- **Relevance:** Defines the upper bound on Wi-Fi EIRP that any
  US-deployed AP we expect to harvest from is allowed to emit.
  Anchors `report.md` §5.6 sanity check.

## I13 — Yan, Huang, Lai, Liao et al., 2024 IEEE RFIC

- **Citation:** J.R. Yan, Y.W. Huang, W.J. Lai, J.H. Liao et al.,
  "A 2.4 GHz, -19 dBm Sensitivity RF Energy Harvesting CMOS Chip
  with 51% Peak Efficiency and 24 dB Power Dynamic Range," 2024
  IEEE Radio Frequency Integrated Circuits Symposium.
- **URL:** https://ieeexplore.ieee.org/document/10599958
- **Verification status:** **VERIFICATION PARTIAL** — IEEE Xplore
  returned HTTP 418 on direct fetch attempts; numerical claims
  (-19 dBm sensitivity, 51 % peak PCE, 24 dB PDR, 180 nm CMOS,
  meander dipole antenna, reconfigurable rectifier + MPPT + 3×
  switched-cap charge pump + 2 regulators + ULP diode) sourced
  from Google Scholar abstract excerpts, multiple independent
  searches, 2026-05-03.
- **Action for Stage-2 reviewer:** Verify against the original PDF
  via institutional access; cache and SHA-256.
- **Relevance:** The headline industry-adjacent silicon SOTA at
  2.4 GHz in the open literature. Sets the upper bound on what
  the project's own design could realistically achieve at the
  same node.

## I14 — Kadali, Manumanthu et al., 2021 IEEE Conf. Electrical Eng.

- **Citation:** L. Kadali, S.K. Manumanthu et al., "A CMOS
  RF-to-DC Rectifier with 86 % PCE at Input Power of -14 dBm @
  2.4 GHz for RF Energy Harvester," 2021 IEEE Conference on
  Electrical Engineering.
- **URL:** https://ieeexplore.ieee.org/document/9616630
- **Verification status:** **VERIFICATION PARTIAL** — same IEEE
  Xplore HTTP 418 issue; abstract excerpt from Google Scholar
  search 2026-05-03.
- **Action for Stage-2 reviewer:** Verify against original PDF.
- **Relevance:** Highest published PCE figure in the immediate
  neighbourhood (86 %) — though at -14 dBm input, not -20 dBm
  ambient. Demonstrates the *peak* end of what 180 nm cross-
  coupled differential rectifiers can do.

## I15 — Chun, Ramiah, Mekhilef 2022 IEEE Access review

- **Citation:** A.C.C. Chun, H. Ramiah, S. Mekhilef, "Wide Power
  Dynamic Range CMOS RF-DC Rectifier for RF Energy Harvesting
  System: A Review," IEEE Access, 2022.
- **URL:** https://ieeexplore.ieee.org/document/9722868 (document
  ID 9722868).
- **Verification status:** **VERIFICATION PARTIAL** — same IEEE
  Xplore HTTP 418 issue; abstract via Google Scholar 2026-05-03.
- **Action for Stage-2 reviewer:** Mirror PDF via institutional
  access.
- **Relevance:** Tertiary survey; cited because it is the most
  recent comprehensive comparison table of CMOS RF-DC rectifier
  topologies (82 citations on Google Scholar) and is the
  canonical reference for the "Power Dynamic Range" concept that
  the Yan 2024 paper claims to extend.

## I16 — Pinuela, Mitcheson, Lucyszyn 2013 IEEE TMTT

- **Citation:** M. Pinuela, P.D. Mitcheson, S. Lucyszyn,
  "Ambient RF Energy Harvesting in Urban and Semi-Urban
  Environments," IEEE Trans. Microwave Theory Tech., vol. 61,
  no. 7, July 2013.
- **Verification status:** **VERIFICATION PARTIAL** (same as
  first-principles report R3 — the cached PDF was fetched but
  binary integrity unverified by the prior agent; numbers
  reproduced from search snippets). Cached at
  `references-cache/pinuela-2013-london-rf-survey.pdf` (1.39 MB).
- **Action for Stage-2 reviewer:** Verify cached PDF integrity
  (SHA-256, opens cleanly), independently extract the
  -60 to -14.5 dBm/m² envelope numbers.
- **Relevance:** The most-cited *measured* ambient-RF-density
  survey at city scale. Anchors the argument that
  `mode-true-ambient` is sub-nW total at 2.4 GHz absent a
  cooperating source.

## I17 — Pakkirisami Churchill et al. (corrected from "Awad et al." 2026-05-04 per reviewer-1), 2022 MDPI Sensors

- **Citation:** Pakkirisami Churchill et al. (corrected from "Awad et al." 2026-05-04 per reviewer-1), "A Fully-Integrated Ambient RF
  Energy Harvesting System with 423 µW Output Power," Sensors
  (MDPI) 22(12):4415, 2022. DOI 10.3390/s22124415.
- **Verification status:** **VERIFIED** by the parallel
  first-principles report (R2). Direct re-fetch attempted in this
  session returned 403 — re-use the prior verification. Quoted
  facts (per the first-principles report): "Operating Frequency:
  2.4 GHz. Input RF Power for 423 µW Output: 0 dBm (1 mW). Peak
  RF-to-DC Efficiency: 21.15% @0 dBm at a 3.3 kΩ load. Rectifier
  Topology: 3 × 3 stage differential cross-coupled rectifier
  cascaded ... combined with a 6-stage charge pump."
- **Relevance:** Anchor for the η ∝ P_in scaling used in
  `report.md` §5.3 to extrapolate e-peas's 915 MHz tables to
  2.45 GHz.

## I18 — GitHub search for Tiny Tapeout RF / energy-harvest projects

- **Citation:** GitHub repository search,
  `tinytapeout RF rectifier OR "energy harvest"`.
- **URL:** https://github.com/search?q=tinytapeout+RF+rectifier+OR+%22energy+harvest%22&type=repositories
- **Verification status:** **VERIFIED 2026-05-03** by WebFetch.
  GitHub returned "Your search did not match any repositories"
  (zero hits).
- **Relevance:** Confirms the absence of open-source TT silicon
  precedent for RFEH at any frequency — supports the
  `report.md` §7 negative-result point.

## Verification status summary

| Ref | Status | Action for Stage-2 reviewer |
|---|---|---|
| I1 | VERIFIED | (cached) |
| I2 | VERIFIED | (cached) |
| I3 | PARTIAL | Mirror PCC110/PCC210 datasheets |
| I4 | VERIFIED | (cached) |
| I5 | VERIFIED | (cached) |
| I6 | VERIFIED | (cached) |
| I7 | VERIFIED | (cached) |
| I8 | VERIFIED | Optional snapshot |
| I9 | VERIFIED | (cached, SHA-256 recorded) |
| I10 | VERIFIED | Optional snapshot |
| I11 | VERIFIED (Wikipedia level) | Find Wiliot FCC test report |
| I12 | VERIFIED | Optional snapshot |
| I13 | PARTIAL | Mirror Yan 2024 RFIC PDF |
| I14 | PARTIAL | Mirror Kadali 2021 PDF |
| I15 | PARTIAL | Mirror Chun 2022 IEEE Access PDF |
| I16 | PARTIAL | Verify cached PDF integrity |
| I17 | VERIFIED (sister report) | Re-verify in own context |
| I18 | VERIFIED | (zero-hit search, no cache) |