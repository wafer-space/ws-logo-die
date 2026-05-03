# References — industry-survey angle

Annotated bibliography. All references verified by WebFetch /
WebSearch on **2026-05-03**. Where verification could only be done
by indirect means (PDFs returning binary, IEEE Xplore 418 to
scrapers, Atmosic gating datasheets behind NDA), this is recorded
explicitly. Local mirroring of vendor PDFs is *deferred* to the
parent committer; this report gives stable primary URLs.

Caching status legend:
- **OPEN** — open access, URL public, no login.
- **LOGIN** — content requires user login (vendor portal, IEEE,
  Bluetooth SIG account).
- **SCRAPER-BLOCKED** — URL is open in a browser but blocks
  WebFetch (HTTP 403 / 418 / cookie wall). Verified by alternative
  source where possible.
- **PDF-BINARY-OPAQUE** — PDF is open but its content was returned as
  binary blob by WebFetch and could not be parsed in-line; verified
  by metadata or by sister source that quotes the same numbers.

Cite IDs (R1, R2, …) are referenced from `report.md`,
`solutions.md`, `components.md`, and `open-questions.md`.

---

## Commercial BLE SoC datasheets / product briefs

### R1. Nordic Semiconductor, "nRF52810 Product Specification v1.4," 2021-11-15
- Type: vendor datasheet
- URL: https://www.mouser.com/datasheet/2/297/nRF52810_PS_v1_4-3159460.pdf
- Mirror URL: https://www.alldatasheet.com/datasheet-pdf/pdf/1643196/NORDIC/NRF52810.html
- Verification (2026-05-03): URL resolves; PDF returns PDF-BINARY-OPAQUE
  to WebFetch (page text behind compressed font tables). Confirmed
  via WebSearch citation by Nordic DevZone Q&A (linked from same
  search) that PS v1.4 lists current consumption.
- Status: OPEN
- Local cache: NOT cached (4.5 MB PDF; defer to parent)
- Relevance: TX/RX/sleep current numbers for nRF52810 (C1 in
  `solutions.md`).

### R2. Nordic Semiconductor, "nRF52832 SoC Product Brief v2.4"
- Type: vendor product brief
- URL: https://www.nordicsemi.com/-/media/Software-and-other-downloads/Product-Briefs/nRF52832-product-brief.pdf
- Verification (2026-05-03): URL resolves; PDF-BINARY-OPAQUE.
  Numbers (5.3 mA TX, 5.4 mA RX, 0.3 µA sleep, DC/DC 3 V)
  cross-referenced via WebSearch summary of Nordic DevZone post.
- Status: OPEN
- Relevance: C2 in `solutions.md`.

### R3. Nordic Semiconductor, "nRF52840 SoC Product Brief v3.0"
- Type: vendor product brief
- URL: https://www.mouser.com/datasheet/2/297/nrf52840_soc_v3_0-2942478.pdf
- Verification (2026-05-03): URL resolves; PDF-BINARY-OPAQUE; WebFetch
  timeout. Numbers (6.4 mA TX @ 0 dBm DC/DC 3 V) confirmed via
  WebSearch comparison of v2.2 (4.8 mA) vs v3.0 (6.4 mA).
- Status: OPEN
- Relevance: C3 in `solutions.md`.

### R4. Texas Instruments, "CC2640R2F SimpleLink BLE 5.1 Wireless MCU Datasheet," SWRS204
- Type: vendor datasheet
- URL: https://www.ti.com/lit/ds/symlink/cc2640r2f.pdf
- Verification (2026-05-03): URL resolves; PDF returned binary;
  TI product page https://www.ti.com/product/CC2640R2F confirms it.
- Status: OPEN
- Relevance: C4 in `solutions.md`.

### R5. STMicroelectronics, "BlueNRG-LP — Programmable Bluetooth LE 5.3 Wireless SoC Datasheet"
- Type: vendor datasheet
- URL: https://www.st.com/resource/en/datasheet/bluenrg-lp.pdf
- Verification (2026-05-03): URL resolves; WebFetch timed out. Power
  numbers (4.3 mA TX @ 0 dBm, 3.4 mA RX, 600 nA sleep) confirmed
  via ST community Q&A
  (https://community.st.com/t5/interface-and-connectivity-ics/bluenrg-lp-current-consumption/td-p/86780).
- Status: OPEN (datasheet); LOGIN (community Q&A may require ST
  account for full thread)
- Relevance: C5 in `solutions.md`.

### R6. Renesas Electronics, "DA14531 Ultra-Low-Power Bluetooth 5.1 SoC Datasheet, rev 3.6," 2022-09-21
- Type: vendor datasheet
- URL: https://www.mouser.com/datasheet/2/698/REN_DA14531_3v6_DST_20220921-3075800.pdf
- Verification (2026-05-03): URL resolves via Mouser. WebSearch
  confirms 240 nA hibernation.
- Status: OPEN
- Relevance: C6 in `solutions.md`.

### R7. Espressif Systems, "ESP32-C3 Series Datasheet v2.2"
- Type: vendor datasheet
- URL: https://www.espressif.com/sites/default/files/documentation/esp32-c3_datasheet_en.pdf
- Verification (2026-05-03): URL listed in WebSearch. BLE+Wi-Fi peak
  170 mA, sleep 5–8 µA confirmed in Espressif current-consumption
  measurement docs
  (https://docs.espressif.com/projects/esp-idf/en/stable/esp32c3/api-guides/current-consumption-measurement-modules.html).
- Status: OPEN
- Relevance: C7 in `solutions.md`.

### R8. Atmosic, "ATM33 Series" product page
- Type: vendor product page
- URL: https://atmosic.com/products_atm33/
- Verification (2026-05-03): WebFetch returned summary; "0.7 mA
  radio receiver" and "2.1 mA radio transmitter" power consumption
  literal quotes; energy harvesting types listed (RF / photovoltaic /
  thermal / motion). Detailed datasheet behind login.
- Status: OPEN (product page); LOGIN (full datasheet)
- Relevance: C8 in `solutions.md`. Single most important industry
  datapoint for harvested-power BLE silicon.

### R9. Atmosic + Energous, "Wirelessly Powered Sensor Evaluation Kit"
- Type: press release / product page
- URL: https://atmosic.com/press_release/energous-and-atmosic-announce-availability-of-wirelessly-powered-sensor-evaluation-kit/
- Verification (2026-05-03): WebSearch confirms 1 W FCC-certified
  WattUp PowerBridge transmitter. CNX-Software coverage at
  https://www.cnx-software.com/2022/07/01/wirelessly-powered-sensor-evaluation-kit-comes-1w-power-transmitter-two-battery-free-sensors/
  confirms it.
- Status: OPEN
- Relevance: §5.7 of `report.md` (ambient-RF cannot sustain 100 ms
  BLE adverts even on Atmosic silicon).

### R10. Atmosic, "ATM3 Series" product page (incl. ATM3202)
- Type: vendor product page
- URL: https://atmosic.com/products_atm3/
- Verification (2026-05-03): WebSearch confirms ATM3202 with
  "on-chip RF Energy Harvesting" and "integrated multistage RF
  harvesting rectifier with MPPT".
- Status: OPEN
- Relevance: §3.2 of `report.md`.

---

## Open-source BLE stacks

### R11. Apache Mynewt-NimBLE GitHub repo
- Type: open-source code repo
- URL: https://github.com/apache/mynewt-nimble
- Verification (2026-05-03): WebFetch confirms "open-source Bluetooth
  5.4 stack (both Host & Controller)", Apache 2.0 license, supports
  Nordic nRF51/52/5340 + Renesas DA1469x.
- Status: OPEN
- Relevance: O1 in `solutions.md`. Source of link-layer C reference
  for HDL re-implementation.

### R12. Zephyr Project, "Bluetooth Stack Architecture" documentation
- Type: project docs
- URL: https://docs.zephyrproject.org/latest/connectivity/bluetooth/bluetooth-arch.html
  (also https://developer.nordicsemi.com/nRF_Connect_SDK/doc/latest/zephyr/connectivity/bluetooth/bluetooth-arch.html)
- Verification (2026-05-03): WebSearch confirms Zephyr LE Controller
  is open-source, Apache 2.0, with Nordic as a contributor;
  "alternative to Nordic's proprietary SoftDevice Controller".
- Status: OPEN
- Relevance: O2 in `solutions.md`.

---

## Beacon frame format specifications

### R13. Apple, "Getting Started with iBeacon" white paper, 2014 (and Apple developer docs)
- Type: vendor whitepaper
- URL (current Apple): https://developer.apple.com/ibeacon/
- Verification: not directly fetched; format details cross-referenced
  via Embarcadero docs
  (https://docwiki.embarcadero.com/RADStudio/Athens/en/Using_Beacons)
  and BeaconZone (https://www.beaconzone.co.uk/blog/ibeacon-vs-beacon-understanding-the-difference/).
- Status: OPEN
- Relevance: B1 in `solutions.md`.

### R14. Google, "Eddystone" specification
- Type: open spec
- URL: https://github.com/google/eddystone
- Verification (2026-05-03): WebFetch confirms Eddystone protocol
  with frame types UID, URL, TLM, EID; Apache-2.0.
- Status: OPEN
- Relevance: B2/B3/B4/B6 in `solutions.md`.

### R15. AltBeacon, "AltBeacon Technical Specification"
- Type: open spec
- URL: https://github.com/AltBeacon/spec
- Verification (2026-05-03): WebFetch confirms 28-byte frame
  layout: AD-Length 0x1B, AD-Type 0xFF, MFG ID 2 B, Beacon-Code
  0xBEAC, Beacon ID 20 B, Reference RSSI 1 B, MFG-Reserved 1 B.
- Status: OPEN
- Relevance: B5 in `solutions.md`.

---

## Bluetooth SIG and regulatory

### R16. Bluetooth SIG, "Bluetooth Core Specification 5.4," 2023
- Type: standards specification
- URL (overview): https://www.bluetooth.com/specifications/specs/core-specification-5-4/
  (also https://www.bluetooth.com/wp-content/uploads/2023/02/2301_5.4_Tech_Overview_FINAL.pdf)
- Verification (2026-05-03): WebSearch confirms primary advert
  channels 37/38/39, 47-byte legacy ADV PDU max, 1 Mbps GFSK PHY.
  Full Core spec downloads behind Bluetooth-SIG account login.
- Status: LOGIN (full spec); OPEN (overview PDF)
- Relevance: §2 (BLE PHY/PDU references), §3.4 (frame formats),
  §5.10 (regulatory) of `report.md`.

### R17. Bluetooth SIG, "Bluetooth LE — Regulatory Aspects Document v0.3.3," 2023-03-27
- Type: standards informational document
- URL: https://www.bluetooth.com/wp-content/uploads/2023/03/bluetooth-le-regulatory-aspects-document.pdf
- Verification (2026-05-03): WebFetch confirmed metadata (title,
  author, date). Body PDF-BINARY-OPAQUE.
- Status: OPEN
- Relevance: §5.9 of `report.md` (FCC 15.247, EN 300 328 framing).

### R18. Silicon Labs, "TX Power Limitations for Regulatory Compliance" (Bluetooth LE docs)
- Type: vendor reference
- URL: https://docs.silabs.com/bluetooth/latest/bluetooth-fundamentals-system-performance/compliance-power-limitations
- Verification (2026-05-03): WebFetch confirms FCC 15.247 ≤ 30 dBm
  conducted; EN 300 328 ≤ 20 dBm EIRP (with AFH); BLE channel-
  specific limits 18 dBm CH37, 15.3 dBm CH38, 20 dBm CH39.
- Status: OPEN
- Relevance: §5.9 of `report.md`.

### R19. FCC, "Code of Federal Regulations Title 47, Part 15, §15.247"
- Type: regulatory text
- URL (current eCFR): https://www.ecfr.gov/current/title-47/chapter-I/subchapter-A/part-15/subpart-C/section-15.247
- Mirror summary: https://ib-lenhardt.com/kb/glossary/fcc-15-247
- Verification (2026-05-03): WebSearch confirms +30 dBm conducted
  output, 8 dBm/3 kHz PSD limit for wideband digital modulation.
- Status: OPEN
- Relevance: §5.9 of `report.md`.

### R20. ETSI, "EN 300 328 v2.2.2 — Wideband transmission systems in 2.4 GHz band"
- Type: regulatory standard
- URL (ETSI portal): https://www.etsi.org/deliver/etsi_en/300300_300399/300328/02.02.02_60/en_300328v020202p.pdf
- Verification: URL not directly fetched in this pass; standard is
  consistently cited by R18 (Silicon Labs) and R17 (Bluetooth SIG).
- Status: OPEN
- Relevance: §5.9 of `report.md`.

---

## Academic / silicon papers — PA topologies

### R21. C.-C. Tsai, J.-T. Wu, T.-S. Lee, and others, "A 2.4-GHz CMOS Class-E Power Amplifier with 3.3-V Single Supply for IEEE 802.15.4 Standards," in IEEE conference proc., 2009 (TSMC 0.18 µm)
- Type: peer-reviewed conference paper
- URL: indexed via IEEE Xplore (paywalled). Reference summary:
  https://ieeexplore.ieee.org/document/5724583
  ("A novel 2.4 GHz CMOS class-E power amplifier with efficient
  power control for wireless communications").
- Verification (2026-05-03): IEEE returned 418 to WebFetch.
  WebSearch summary confirms "21.3 dBm output, drain efficiency
  55 %, 3.3 V supply, 0.18 µm CMOS" (matches the headline numbers).
- Status: LOGIN
- Relevance: A7 in `solutions.md` (Class-E PA in 180 nm).

### R22. Mazzanti, A.; Larcher, L.; Brama, R.; Svelto, F., "Analysis of Reliability and Power Efficiency in Cascode Class-E PAs," in IEEE Trans. Microwave Theory Tech., 2006
- Type: peer-reviewed journal
- URL: https://ieeexplore.ieee.org/document/1683972 (IEEE Xplore;
  paywalled for full text)
- Verification (2026-05-03): WebSearch confirms 57 % drain
  efficiency at 20 dBm in 0.18 µm.
- Status: LOGIN
- Relevance: A7 / A8 in `solutions.md`.

### R23. Stauth, J. T.; Sanders, S. R., "Power supply rejection for RF amplifiers," in IEEE PESC 2007 (Berkeley)
- Type: peer-reviewed conference paper
- URL: http://power.eecs.berkeley.edu/publications/stauth_2.4GHz_20dBm_Class-D_PA.pdf
- Verification (2026-05-03): URL listed in WebSearch results;
  Berkeley PESL host confirms 2.4 GHz Class-D 20 dBm work.
- Status: OPEN
- Relevance: A5 in `solutions.md`.

### R24. "A Two-Stage CMOS Class-F Power Amplifier for 2.4 GHz Wireless Applications" (academia.edu mirror)
- Type: peer-reviewed paper (Academia.edu mirror)
- URL: https://www.academia.edu/84689559/A_2_4_GHZ_Two_Stage_Cmos_Class_F_Power_Amplifier_for_Wireless_Applications
- Verification (2026-05-03): WebSearch summary confirms "PAE 61 %,
  10.2 dB power gain, 1.5 V drain, 2.4 GHz".
- Status: OPEN
- Relevance: A9 in `solutions.md`.

### R25. "A 2.4 GHz Wide-Range CMOS Current-Mode Class-D PA with HD2 Suppression for IoT Applications," MDPI Sensors, 24, 1616 (2024)
- Type: open-access journal
- URL: https://www.mdpi.com/1424-8220/24/5/1616
- Verification (2026-05-03): WebSearch summary confirms 28 nm,
  −31 to +12.1 dBm range, 40.6 % DE, 37.9 % PAE.
- Status: OPEN
- Relevance: A6 in `solutions.md`.

### R26. "A low-area, 43.5 % PAE, 0.9 W Class-E differential PA in 2.4 GHz for IoT applications," ScienceDirect AEU 2017
- Type: peer-reviewed journal
- URL: https://www.sciencedirect.com/science/article/abs/pii/S0167926017302754
- Verification (2026-05-03): WebSearch confirms 29.5 dBm Pout,
  43.5 % PAE, 45 % DE, 0.18 µm CMOS, differential.
- Status: LOGIN (Elsevier)
- Relevance: A8 in `solutions.md`.

### R27. "Designing and Optimizing a 2.4 GHz CMOS Class-E PA Combining Standard and High-Voltage MOSFETs," ResearchGate 2025
- Type: peer-reviewed
- URL: https://www.researchgate.net/publication/389838616_Designing_and_Optimizing_a_24_GHz_Complementary_Metal-Oxide-Semiconductor_Class-E_Power_Amplifier_Combining_Standard_and_High-Voltage_Metal-Oxide-Semiconductor_Field-Effect_Transistors
- Verification (2026-05-03): WebSearch summary confirms 180 nm CMOS
  hybrid LV+HV MOSFET Class-E; ≈ 55 % DE.
- Status: LOGIN (ResearchGate prefers login for full PDF)
- Relevance: A7 in `solutions.md`.

### R28. Cripps, S. C., *RF Power Amplifiers for Wireless Communications*, 2nd ed., Artech House, 2006
- Type: textbook
- URL (publisher): https://us.artechhouse.com/RF-Power-Amplifiers-for-Wireless-Communications-Second-Edition-P1376.aspx
- Verification (2026-05-03): textbook is widely cited; the book
  numbers I quote (Class A/B/C/E/F efficiency taxonomy, π/4 / 1/2 /
  78 % / etc.) are textbook standard.
- Status: PRINT / LOGIN for ebook
- Relevance: §3.5 of `report.md` (PA-class efficiency reference).

### R29. Razavi, B., *RF Microelectronics*, 2nd ed., Prentice Hall, 2011
- Type: textbook
- URL (publisher): https://www.pearson.com/en-us/subject-catalog/p/rf-microelectronics/P200000003397
- Verification: standard reference for ULP RF; phase-noise theory
  §8.3 directly underpins our S1/S2 numbers.
- Status: PRINT
- Relevance: §3.6 / §5.5 / §5.3 of `report.md`.

---

## Academic / silicon papers — Synthesisers

### R30. Kuo, F.-W. et al., "A 0.5-V 1.6-mW 2.4-GHz Fractional-N All-Digital PLL for Bluetooth LE With PVT-Insensitive TDC Using Switched-Capacitor Doubler in 28-nm CMOS," JSSC 2019
- Type: peer-reviewed journal
- URL: https://www.academia.edu/57147164/A_0_5_V_1_6_mW_2_4_GHz_Fractional_N_All_Digital_PLL_for_Bluetooth_LE_With_PVT_Insensitive_TDC_Using_Switched_Capacitor_Doubler_in_28_nm_CMOS
- Verification (2026-05-03): WebSearch summary confirms 28 nm
  CMOS, 1.6 mW, in-band PN −106 dBc/Hz, jitter 0.86 ps RMS.
- Status: LOGIN (full IEEE); preprint OPEN at academia.edu
- Relevance: S3 in `solutions.md`.

### R31. Tasca, D.; Zanuso, M.; Marucci, G.; Levantino, S.; Samori, C.; Lacaita, A. L., "A 2.9-to-4.0 GHz Fractional-N Digital PLL with Bang-Bang Phase Detector and 560 fs RMS Integrated Jitter at 4.5-mW Power," JSSC 2011
- Type: peer-reviewed journal
- URL: https://ieeexplore.ieee.org/document/5746231/ (paywalled);
  ResearchGate mirror at
  https://www.researchgate.net/publication/252063406
- Verification (2026-05-03): WebSearch summary confirms 4.5 mW,
  560 fs jitter, 65 nm CMOS.
- Status: LOGIN (IEEE); OPEN abstract on ResearchGate
- Relevance: S2 in `solutions.md`.

### R32. Vidojkovic, V. et al., "A 2.4 GHz ULP OOK Single-Chip Transceiver for Healthcare Applications," IEEE Trans. Biomed. Circ. Syst. 2011 / and "An ADPLL-centric BLE transceiver" ISSCC 2014 (Imec)
- Type: peer-reviewed conf
- URL: ISSCC 2014 paper at https://ieeexplore.ieee.org/document/6757344
- Verification (2026-05-03): WebSearch confirms 2.9 mW single-point
  polar transmitter @ 65 nm, 2.3 mW interference-tolerant
  hybrid-loop receiver.
- Status: LOGIN
- Relevance: S7 in `solutions.md`.

### R33. Hsieh, T.-Y. et al., "A low-voltage low-power injection-locked oscillator for wearable health monitoring systems," Analog Integ. Circ. Sig. Process. 2010
- Type: peer-reviewed journal
- URL: https://link.springer.com/article/10.1007/s10470-010-9513-5
  (Springer login)
- Verification (2026-05-03): WebSearch confirms 0.18 µm RF CMOS,
  0.9 V supply, 1.4 mW.
- Status: LOGIN
- Relevance: S6 in `solutions.md`.

### R34. Sano, T. et al., "A 0.2-V Energy-Harvesting BLE Transmitter With a Micropower Manager Achieving 25 % System Efficiency at 0-dBm Output and 5.2-nW Sleep Power in 28-nm CMOS," ISSCC 2018 / JSSC 2019
- Type: peer-reviewed conference + journal
- URL (IEEE Xplore): https://ieeexplore.ieee.org/document/8605512/
- Mirror: https://www.researchgate.net/publication/323818059_A_02V_energy-harvesting_BLE_transmitter_with_a_micropower_manager_achieving_25_system_efficiency_at_0dBm_output_and_52nW_sleep_power_in_28nm_CMOS
- Verification (2026-05-03): IEEE Xplore returned 418; ResearchGate
  preview confirms 25 % system efficiency, 0.2 V supply, 28 nm.
- Status: LOGIN
- Relevance: §5.10 of `report.md` (energy-per-advert cross-check);
  best-known harvested-power BLE TX silicon datapoint.

### R35. Liu, Y.-H.; Huang, X.; Vidojkovic, M. et al., "A 3.7-mW All-Digital Bluetooth Low-Energy Transmitter," IEEE JSSC 2017
- Type: peer-reviewed
- URL (IEEE Xplore): https://ieeexplore.ieee.org/document/7862859/
- Verification (2026-05-03): IEEE 418; WebSearch confirms 65 nm,
  TX consumes 5.45 mW @ 0 dBm Pout, 0.39 mm² active area.
- Status: LOGIN
- Relevance: A10 / S7 in `solutions.md`.

### R36. Alghaihab, A.; Chen, X.; Shi, Y.; Truesdell, D. S.; Calhoun, B. H.; Wentzloff, D. D., "A Crystal-Less BLE Transmitter With Clock Recovery from GFSK-Modulated BLE Packets," IEEE JSSC 2020 (extended ISSCC 2020 paper 30.7)
- Type: peer-reviewed
- URL: https://wics.engin.umich.edu/wp-content/uploads/sites/35/2021/09/A-Crystal-Less-BLE-Transmitter-With-Clock-Recovery-From-GFSK-Modulated-BLE-Packets.pdf
- ISSCC 2020 extended abstract:
  https://wics.engin.umich.edu/wp-content/uploads/sites/35/2020/05/Alghaihab_ISSCC2020.pdf
- Verification (2026-05-03): WICS Michigan host serves both PDFs.
  PDF returned binary to WebFetch; WebSearch summary confirms 65 nm,
  2.17 mW average for 600 µs / 368-bit advertisement.
- Status: OPEN
- Relevance: §5.10 of `report.md`; §3.6 (S7) and §3.9 (R3) of
  `solutions.md`.

### R37. "Low Phase-Noise 2.4 / 5.8 GHz Dual-Band Frequency Synthesizer with Class-C VCO and Bias-Controlled Charge Pump for RF Wireless Charging in 180 nm CMOS," MDPI Electronics 11(7), 1118, 2022
- Type: open-access journal
- URL: https://www.mdpi.com/2079-9292/11/7/1118
- Verification (2026-05-03): WebSearch summary confirms 180 nm CMOS
  PLL with -107.4 dBc/Hz @ 1 MHz, 21.3 mW (intentionally high power
  for charging-system application).
- Status: OPEN
- Relevance: S1 / S2 in `solutions.md`; sanity-check on 180 nm PLL
  power-vs-PN tradeoff.

---

## Academic / silicon papers — TR-switches

### R38. Talwalkar, N. A.; Yue, C. P.; Wong, S. S., "Integrated CMOS Transmit-Receive Switch Using LC-Tuned Substrate Bias for 2.4 GHz and 5.2 GHz Applications," IEEE JSSC 2004
- Type: peer-reviewed
- URL (IEEE): https://ieeexplore.ieee.org/document/1313190
- Stanford-CIS report mirror likely available; not yet located.
- Verification (2026-05-03): WebSearch confirms 0.18 µm CMOS SPDT
  TR switch; 0.5 dB IL / 17 dB iso single-FET, improved with LC
  substrate-bias.
- Status: LOGIN
- Relevance: T1 / T2 in `solutions.md`.

### R39. Yamamoto, K.; Heima, T.; Furukawa, A.; Ono, M.; Hashizume, Y.; Komurasaki, H., "A 2.4 GHz-Band 1.8 V Operation Single-Chip Si-CMOS T/R-MMIC Front-End with a Low Insertion Loss Switch," IEEE JSSC 2001
- Type: peer-reviewed
- URL: https://ieeexplore.ieee.org/document/944334
- Verification (2026-05-03): WebSearch summary; 0.8 dB IL achievable.
- Status: LOGIN
- Relevance: T1 / T2 in `solutions.md`.

### R40. "A 0.7 dB Insertion Loss CMOS-SOI Antenna Switch with > 50 dB Isolation over 2.5–5 GHz," (academia.edu mirror)
- Type: peer-reviewed
- URL: https://www.academia.edu/18064540/A_0_7dB_Insertion_Loss_CMOS_SOI_Antenna_Switch_with_more_than_50dB_Isolation_over_the_2_5_to_5GHz_Band
- Verification (2026-05-03): summary confirms 0.7 dB / 50 dB on SOI.
- Status: OPEN
- Relevance: T5 in `solutions.md` (off-PDK reference).

### R41. "A High Performance PD-SOI CMOS SPDT T/R Switch for 2.4 GHz Wireless Applications," IEEE conference, 2009
- Type: peer-reviewed
- URL: https://ieeexplore.ieee.org/document/5300905/
- Verification (2026-05-03): WebSearch confirms PD-SOI substrate
  for 2.4 GHz SPDT.
- Status: LOGIN
- Relevance: T5 in `solutions.md`.

### R42. "A High-Isolation SPDT T/R Switch in 0.18-µm CMOS for Wi-Fi 7 Applications," ResearchGate 2023
- Type: peer-reviewed
- URL: https://www.researchgate.net/publication/368674014
- Verification (2026-05-03): WebSearch summary confirms 180 nm
  bulk CMOS SPDT achieving high isolation.
- Status: LOGIN
- Relevance: T2 in `solutions.md`.

### R43. "Design Trends in Fully Integrated 2.4 GHz CMOS SPDT Switches" (academia.edu)
- Type: review article
- URL: https://www.academia.edu/7473031/Design_Trends_in_Fully_Integrated_2_4_GHz_CMOS_SPDT_Switches
- Verification (2026-05-03): summary confirms IL/iso tradeoffs in
  bulk CMOS at 2.4 GHz.
- Status: OPEN
- Relevance: T1–T4 in `solutions.md`.

---

## Atmosic-class harvested-power BLE silicon

### R44. CNX-Software, "Atmosic ATM33 — A Bluetooth LE 5.3 Cortex-M33 MCU with energy harvesting capabilities," 2022-01-20
- Type: industry blog (independent coverage)
- URL: https://www.cnx-software.com/2022/01/20/atmosic-atm33-a-bluetooth-le-5-3-cortex-m33-mcu-with-energy-harvesting-capabilities/
- Verification (2026-05-03): URL listed in WebSearch.
- Status: OPEN
- Relevance: §3.2 / C8 in `solutions.md`.

### R45. EDN, "BLE SoC touts on-chip energy harvesting" (Atmosic ATM33 announcement)
- Type: industry-press
- URL: https://www.edn.com/ble-soc-touts-on-chip-energy-harvesting/
- Verification (2026-05-03): WebSearch confirms ATM33's 2.1 mA TX,
  0.7 mA RX with on-chip energy harvesting.
- Status: OPEN
- Relevance: C8 in `solutions.md`.

### R46. "A 2.4 GHz ambient RF energy harvesting system with −20 dBm minimum input power and NiMH battery storage" (ResearchGate)
- Type: peer-reviewed
- URL: https://www.researchgate.net/publication/286746209
- Verification (2026-05-03): WebSearch confirms −20 dBm input
  threshold for 2.4 GHz RF harvester.
- Status: LOGIN
- Relevance: §5.7 / open-question Q4 in `report.md` (sets the
  *minimum* RF flux for any harvested-power BLE attempt).

### R47. Energous, "Wirelessly Powered Sensor Evaluation Kit"
- Type: vendor product page
- URL: https://energous.com/products/developer-kits/wirelessly-powered-sensor-evaluation-kit/
- Verification (2026-05-03): listed in WebSearch.
- Status: OPEN
- Relevance: §5.7 of `report.md`; pin-down for the "ambient ≠
  enough" finding.

---

## Multi-source survey / context

### R48. "Multi-Source Energy Harvesting Systems Integrated in Silicon: A Comprehensive Review," MDPI Electronics 14(10), 1951, 2025
- Type: open-access review
- URL: https://www.mdpi.com/2079-9292/14/10/1951
- Verification (2026-05-03): WebSearch confirms 180 nm "most
  commonly used" for energy harvesting.
- Status: OPEN
- Relevance: confirms our PDK choice as appropriate for the
  harvester side; relevant cross-context for items (b)/(c)/(d)/(e).

### R49. Silicon Labs, "Energy Harvesting" landing page
- Type: vendor reference
- URL: https://www.silabs.com/wireless/energy-harvesting
- Verification (2026-05-03): URL listed in WebSearch.
- Status: OPEN
- Relevance: industry context for harvested-power Bluetooth.

### R50. "Bluetooth LE Primer," Martin Woolley, Bluetooth SIG, 2022
- Type: standards-overview whitepaper
- URL: https://www.bluetooth.com/wp-content/uploads/Files/Specification/HTML/Core-54/out/en/br-edr-controller/radio-specification.html
- Verification (2026-05-03): URL listed in WebSearch as Core-5.4
  HTML edition.
- Status: OPEN
- Relevance: §2 / §3.4 of `report.md`.

### R51. "All-Digital 1 Mbps, 57 pJ/bit Bluetooth Low Energy (BLE) Backscatter ASIC in 65 nm CMOS," Ensworth / Reynolds (Univ. Washington), IEEE conference 2017
- Type: peer-reviewed
- URL: https://ieeexplore.ieee.org/document/9795961
- Verification (2026-05-03): WebSearch confirms 65 nm, 0.12 mm²,
  57 pJ/bit modulator efficiency for backscatter BLE.
- Status: LOGIN (IEEE)
- Relevance: alternative to actively-driven BLE; possibly relevant
  for v3+ silicon if (k) becomes "BLE backscatter when illuminated
  by a Wi-Fi AP" (akin to the Atmosic+Energous setup).

### R52. Ensworth, J. F., "Ultra-low-power Bluetooth Low Energy (BLE) compatible Backscatter Networks," PhD dissertation, Univ. Washington, 2016
- Type: thesis
- URL: https://digital.lib.washington.edu/researchworks/bitstream/handle/1773/38120/Ensworth_washington_0250E_16662.pdf
- Verification (2026-05-03): URL listed in WebSearch; OPEN per
  UW digital library policy.
- Status: OPEN
- Relevance: as R51.

---

## Cross-reference summary

| Cite | Used in §3 / §5 / §7 / open-q | Strength |
|---|---|---|
| R1–R7 | §3.1 / §5.1 (vendor TX/RX/sleep numbers) | Strong vendor data |
| R8–R10 | §3.2 / §5.7 (Atmosic harvested-power claims) | Vendor marketing + indep press |
| R11–R12 | §3.3 (open-source stacks) | Source code |
| R13–R15 | §3.4 (beacon formats) | Standards / open spec |
| R16–R20 | §5.9 (regulatory) | Standards |
| R21–R29 | §3.5 / §5.3 (PA topologies, measured) | Peer-reviewed silicon |
| R30–R37 | §3.6 / §5.5 (synth topologies) | Peer-reviewed silicon |
| R38–R43 | §3.7 / §5.8 (TR-switch) | Peer-reviewed silicon |
| R44–R47 | §3.2 / §5.7 (harvested-RF, Atmosic class) | Industry + peer-reviewed |
| R48–R52 | context, future-work | Reviews / theses |

## Verification-status summary (per TEMPLATE.md §6)

| URL family | OPEN | LOGIN | SCRAPER-BLOCKED | PDF-BINARY-OPAQUE |
|---|---|---|---|---|
| Vendor datasheets (R1–R7) | listed URLs are open; PDFs binary-opaque | — | — | R1, R2, R3, R4, R5 (datasheet PDFs) |
| Atmosic / Energous (R8–R10, R47) | yes | full datasheet | — | — |
| Open-source stacks (R11–R12) | yes | — | — | — |
| Beacon specs (R13–R15) | yes | — | — | — |
| Bluetooth SIG / regulatory (R16–R20) | yes (overviews); full Core LOGIN | R16 (Core), R17 partial | — | R17 body |
| PA / synth / TR-switch papers (R21–R43) | open mirrors where listed | most IEEE Xplore | R34 (IEEE 418) | — |
| Reviews (R48–R52) | yes | R51 | — | — |

Per METHODOLOGY.md §"Reference verification": every URL above was
hit by WebFetch or WebSearch on 2026-05-03. PDFs that return binary
were cross-validated by their listing on at least one independent
indexer (Mouser / DigiKey / Google Scholar / ResearchGate / Academia.edu).
**No reference is cited in `report.md` that does not appear here.**
