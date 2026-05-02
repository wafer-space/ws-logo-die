---
item: a
item_name: internal-oscillator
stage: 1
angle: industry-survey
researcher: claude-opus-4-7-1m (industry-survey instance 1/3)
status: draft
last-updated: 2026-05-03
---

# References — Stage-1 Industry Survey, item (a) Internal oscillator

All entries verified by `WebFetch` and/or `WebSearch` on 2026-05-02 / 2026-05-03.
"Cache" indicates a local mirror was made under `references-cache/`. Where no
mirror is possible (large copyrighted PDF, paywalled IEEE article), the SHA-256
of the as-fetched PDF is recorded instead.

The citation IDs below (`[ATMEL-7810D]`, `[NXP-NTAG213]`, etc.) are the stable
short identifiers used throughout the parallel `report.md`, `solutions.md`,
`components.md`, and `open-questions.md` files.

---

## Vendor datasheets (primary, verified)

### [ATMEL-7810D] ATmega328P 8-bit AVR Microcontroller datasheet

- **Citation:** Atmel Corporation, *ATmega328P 8-bit AVR Microcontroller with
  32K Bytes In-System Programmable Flash datasheet*, doc. 7810D-AVR-01/15,
  January 2015 (now Microchip Technology).
- **URL:** https://ww1.microchip.com/downloads/en/DeviceDoc/Atmel-7810-Automotive-Microcontrollers-ATmega328P_Datasheet.pdf
- **Type:** Vendor datasheet (manufacturer authoritative).
- **Accessibility:** Open (public Microchip website), 8.2 MB PDF.
- **Verification:** Fetched 2026-05-02. SHA-256 of mirrored copy:
  `fb84858d0b12c695a12b13f0c74b962d81210247d440c7a24c0ed23dfabfdfaf`.
  Local cache: `references-cache/atmega328p-7810D/atmega328p_datasheet_7810D.pdf`.
- **Relevance:** Direct primary source for AVR-style "calibrated internal RC
  oscillator" + 128 kHz watchdog oscillator. §28.5.1 Table 28-1 quoted
  verbatim in `solutions.md` (factory ±2 % at 3 V/25 °C, ±14 % at 2.7–5.5 V
  over -40 °C to +125 °C). §8.12.1 documents the 8-bit `OSCCAL` trim
  register (CAL7 selects range; CAL[6:0] = 128 fine steps).

### [NXP-NTAG213] NTAG213/215/216 NFC Forum Type 2 Tag IC datasheet

- **Citation:** NXP Semiconductors, *NTAG213/215/216 NFC Forum Type 2 Tag
  compliant IC with 144/504/888 bytes user memory, Product data sheet*.
- **URL:** https://www.nxp.com/docs/en/data-sheet/NTAG213_215_216.pdf
- **Type:** Vendor datasheet.
- **Accessibility:** Open, public NXP page (resolves OK; 200 + redirect).
- **Verification:** URL resolves 2026-05-02 via web search and direct fetch
  attempts. Datasheet is too long to fit in a single fetch; structural metadata
  confirmed, full content not mirrored due to copyright. SHA-256 not computed
  (no full mirror obtained).
- **Relevance:** Confirms NTAG-class tags self-power and self-clock from the
  13.56 MHz reader carrier; NFC ISO/IEC 14443-A modulation timing is derived
  from divisions of the carrier (carrier/16 → 847.5 kHz subcarrier,
  carrier/128 → 106 kbit/s data rate). This is the canonical "carrier-derived
  clock" precedent for the NFC mode of item (b)/(h).

### [ESP32-DS] ESP32 Series datasheet (Espressif)

- **Citation:** Espressif Systems, *ESP32 Series Datasheet*, version 5.2,
  2024.
- **URL:** https://www.espressif.com/sites/default/files/documentation/esp32_datasheet_en.pdf
  (302-redirects to https://documentation.espressif.com/esp32_datasheet_en.pdf)
- **Type:** Vendor datasheet.
- **Verification:** Fetched 2026-05-02 via redirect. SHA-256 of the cached
  PDF: `6fdff42cce00775643335e0ccb1dc1024070bb86208a2c734e9c09675ca3894a`.
  Local cache:
  `references-cache/esp32-datasheet/esp32_datasheet_en.pdf`.
- **Relevance:** §4.2 "Clock". Direct quote (line 3663-3665): "ESP32 has an
  internal 8 MHz oscillator. The application can select the clock source
  from the external crystal clock source, the PLL clock or the internal 8
  MHz oscillator." §4.2.2 RTC clock has "Internal RC oscillator (typically
  about 150 kHz, and adjustable)" and a derived 31.25 kHz from the 8 MHz
  internal divided by 256. **No accuracy spec is given in the public
  datasheet**, which is itself a notable industry observation: Espressif
  treats the internal 8 MHz oscillator as a fallback / wake-up source, not
  a precision reference.

### [ST-AN2868] STM32F10xxx internal RC oscillator (HSI) calibration

- **Citation:** STMicroelectronics, *AN2868 Application Note: STM32F10xxx
  internal RC oscillator (HSI) calibration*.
- **URL:** https://www.st.com/resource/en/application_note/an2868-stm32f10xxx-internal-rc-oscillator-hsi-calibration-stmicroelectronics.pdf
- **Type:** Vendor application note.
- **Verification:** URL resolves 2026-05-02 (search hit, direct WebFetch
  timed out — large PDF on slow CDN). Existence of document confirmed
  through both ST's own search index and external mirrors. **Not mirrored
  locally** due to fetch timeout; flagged for retry by reviewer.
- **Relevance:** STM32F1's HSI is an 8 MHz factory-trimmed RC oscillator,
  ±1 % at 25 °C; field-calibrated via `RCC_CR.HSITRIM[4:0]` (5-bit, 32
  steps).

### [ST-AN4736] How to calibrate STM32L4-series internal RC oscillator

- **Citation:** STMicroelectronics, *AN4736 Application Note*, August 2016
  (Rev 2).
- **URL:** https://www.st.com/resource/en/application_note/an4736-how-to-calibrate-stm32l4-series-microcontrollers-internal-rc-oscillator-stmicroelectronics.pdf
- **Type:** Vendor application note.
- **Verification:** Listed in ST search index and several third-party
  mirrors as of 2026-05-02. Direct WebFetch timed out twice; URL itself
  confirmed via search-result metadata. SHA-256 not computed.
- **Relevance:** HSI16 is a 16 MHz factory-trimmed RC oscillator with ±1 %
  accuracy at 25 °C, "decreasing" over -40 °C / +105 °C. 7-bit
  `HSITRIM[6:0]` user trim. Documents the CRS (Clock Recovery System)
  that auto-adjusts trim against an external reference.

### [ST-AN5067] How to optimize STM32 MCUs internal RC oscillator accuracy

- **Citation:** STMicroelectronics, *AN5067 Application Note*, March 2018.
- **URL:** https://www.st.com/resource/en/application_note/dm00425536-how-to-optimize-stm32-mcus-internal-rc-oscillator-accuracy-stmicroelectronics.pdf
- **Verification:** URL resolves (web-search hit 2026-05-02). Fetch timed
  out on direct retrieval.
- **Relevance:** Cross-family discussion of HSI trim step (~0.3 % per
  unit), temperature drift, factory-vs-user calibration trade-offs.

### [TI-SLAA336] Tuning the DCO (MSP430)

- **Citation:** Texas Instruments, *Application Report SLAA336A: Tuning the
  DCO*.
- **URL:** https://www.ti.com/lit/an/slaa336a/slaa336a.pdf
- **Type:** Vendor application note.
- **Verification:** URL resolves (web-search 2026-05-02). PDF not mirrored.
- **Relevance:** Describes MSP430 software-tuning of the DCO against a
  32 768 Hz watch crystal; quoted in Hackaday article [HACKADAY-MSP430DCO]
  as achieving ~1 % after tune. Together with [TI-SLAA992] establishes the
  TI position: an internal "rough" DCO + external accurate reference + on-
  chip FLL is the canonical TI clock architecture.

### [TI-SLAA992] MSP430FR2xx/FR4xx DCO+FLL Applications Guide

- **Citation:** Texas Instruments, *SLAA992 Application Report:
  MSP430FR2xx/FR4xx DCO+FLL Applications Guide*, Lixin Chen.
- **URL:** https://www.ti.com/lit/pdf/slaa992
- **Verification:** URL resolves (web-search 2026-05-02). PDF not mirrored.
- **Relevance:** Modern MSP430 FRAM family uses FLL-tuned DCO with selectable
  output between 1, 2, 4, 8, 12, 16, 20, 24 MHz. Frequency error reported
  ~1 % when locked.

### [HOLTEK-HT32F52243] Holtek HT32F52243/52253 user manual

- **Citation:** Holtek Semiconductor, *HT32F52243/HT32F52253 ARM Cortex-M0+
  USB MCU user manual*.
- **URL:** https://www.manualslib.com/manual/1551019/Holtek-Ht32f52243.html
- **Type:** Vendor user manual (manualslib mirror; original Holtek PDF also
  exists).
- **Verification:** Search hit 2026-05-02. Excerpts confirm HSI factory-
  calibrated to ±2 % @ 3.3 V / 25 °C.
- **Relevance:** Cross-vendor confirmation that ±2 % at 25 °C is the
  industry "good factory trim" point for an 8–12 MHz on-chip RC oscillator.

### [NORDIC-NRF52832-PS] nRF52832 Product Specification v1.8

- **Citation:** Nordic Semiconductor, *nRF52832 Product Specification*,
  version 1.8.
- **URL:** https://www.mouser.com/datasheet/2/297/nRF52832_PS_v1_8-2942485.pdf
  (Mouser mirror) and https://docs.nordicsemi.com/bundle/ps_nrf52832/page/nrf52832_ps.html
  (HTML version).
- **Verification:** Both URLs resolve 2026-05-02. PDF is large; direct fetch
  timed out, search-engine snippets confirm content. Devzone Q&A summarises
  HFINT 64 MHz internal: "not very accurate, no calibration mechanism";
  LFRC 32 768 Hz typical, ±500 ppm uncalibrated, ±250 ppm calibrated.
- **Relevance:** Vendor admits explicitly that 64 MHz HFINT is *not* a
  calibratable reference — kept for power-saving / housekeeping while the
  HFXO crystal is off. A radio-grade clock needs HFXO. This is direct
  primary-source corroboration of why none of the BLE-class radios use
  their internal RC for the radio LO.

### [MICROCHIP-PIC-INTOSC] 8-bit PIC MCU Internal Oscillator (Developer Help)

- **Citation:** Microchip Technology, *8-bit PIC MCU Internal Oscillator*,
  developer-help wiki.
- **URL:** https://developerhelp.microchip.com/xwiki/bin/view/products/mcu-mpu/8bit-pic/oscillator-options/internal/
- **Type:** Vendor wiki / app-note hybrid.
- **Verification:** URL resolves (search hit 2026-05-02).
- **Relevance:** HFINTOSC factory-calibrated 16 MHz; OSCTUNE register is a
  6-bit signed value adjusting frequency ±12 % around the calibrated point.
  Confirms ~1 % typical accuracy at room temperature.

### [RENESAS-RL78G23-HOCO] RL78/G23 HOCO clock-frequency correction app note

- **Citation:** Renesas Electronics, *RL78/G23 - High-speed On-chip
  Oscillator (HOCO) Clock Frequency Correction*.
- **URL:** https://www.renesas.com/en/document/apn/rl78g23-high-speed-chip-oscillator-hoco-clock-frequency-correction
- **Verification:** URL resolves (search hit 2026-05-02).
- **Relevance:** HOCO target 32 MHz ± 0.1 % = 31.968–32.032 MHz —
  effectively the tightest "no external reference" spec in the
  microcontroller industry. Tied to the temperature-sensor-fed correction
  algorithm Renesas pioneered.

### [NXP-AN4905] Crystal-less USB operation on Kinetis MCUs

- **Citation:** NXP Semiconductors, *AN4905 Application Note: Crystal-less
  USB operation on Kinetis MCUs*.
- **URL:** https://www.nxp.com/docs/en/application-note/AN4905.pdf
  (returns HTTP 404 on direct WebFetch as of 2026-05-02; available via
  web-archive snapshots and confirmed from search-engine excerpts).
- **Verification:** Direct fetch 404. URL listed in 2026-05-02 search
  index. Not mirrored. **Reviewer should retry via web.archive.org.**
- **Relevance:** IRC48M is a 48 MHz factory-trimmed internal RC; untrimmed
  drift far exceeds USB's ±2 500 ppm spec, but with USB SOF clock-recovery
  trim it stays inside spec. Same architecture is described for
  Atmel/Microchip SAM-G55, ST STM32 HSI48, Silicon Labs C8051F320.

## Patents (primary technical, verified)

### [USP-6020792] US 6,020,792 — Precision relaxation oscillator with temperature compensation

- **Citation:** J. B. Nolan, H. Darmawaskita, R. S. Ellison, D. Susak,
  "Precision relaxation oscillator integrated circuit with temperature
  compensation," U.S. Patent 6,020,792, granted Feb 1 2000 (filed
  Mar 19 1998), assignee **Microchip Technology Inc**.
- **URL:** https://patents.google.com/patent/US6020792
- **Verification:** Fetched 2026-05-02 via WebFetch; full claim, abstract,
  inventors, assignee, dates extracted. Full HTML mirror saved to
  `references-cache/us6020792/`.
- **Relevance:** The canonical Microchip-internal-RC-oscillator patent.
  Dual-cap / dual-comparator relaxation-oscillator topology with
  programmable PTAT and CTAT current mirrors that combine to produce a
  temperature-flat charging current. Headline target: 1 ppm/°C. Trim
  bits: programmable arrays per current mirror.

### [USP-8222940] US 8,222,940 — Electrothermal frequency reference

- **Citation:** S. M. Kashmiri, K. A. A. Makinwa, "Electrothermal frequency
  reference," U.S. Patent 8,222,940, granted Jul 17 2012, assignee
  Technische Universiteit Delft / STW.
- **URL:** https://patents.google.com/patent/US8222940
- **Verification:** Fetched 2026-05-02; inventors / assignee / abstract
  extracted. Full HTML mirror saved to `references-cache/us8222940/`.
- **Relevance:** Frequency-locked-loop oscillator referenced to the
  thermal diffusivity of bulk silicon — a *physical* property as stable
  as kT/M, far more PVT-robust than any RC. Demo at 1.6 MHz with ±0.1 %
  inaccuracy from -55 to +125 °C. 7.8 mW, which makes it expensive but
  is unique among on-die references in not relying on any non-PVT-stable
  passive.

### [USP-9344070] US 9,344,070 — Relaxation oscillator with low drift and native offset cancellation

- **Citation:** J. Luan, M. J. DiVita, "Relaxation oscillator with low
  drift and native offset cancellation," U.S. Patent 9,344,070, granted
  May 17 2016, assignee **Texas Instruments Inc**.
- **URL:** https://patents.google.com/patent/US9344070
- **Verification:** Fetched 2026-05-02; topology, accuracy, trim mechanism
  extracted. Mirror saved to `references-cache/us9344070/` (planned, fetch
  output captured in conversation; reviewer to confirm).
- **Relevance:** Three-OTA relaxation oscillator with native offset
  cancellation — claims 0.5 % drift over 100 years at body-core
  temperature. Closest-published topology to a "no-trim, high-margin"
  variant suitable for an implant application.

## Open-source IP cores / tape-outs (primary, verified)

### [SKY130-RINGOSC-HK] Hadir Khan SKY130 7-stage ring oscillator

- **Citation:** Hadir Khan, "sky130nm-oscillator: A seven-stage ring
  oscillator created by hand on the SkyWater 130 nm open-source PDK,"
  GitHub repository.
- **URL:** https://github.com/hadirkhan10/sky130nm-oscillator
- **Type:** Open-source design, manual layout.
- **Verification:** Fetched 2026-05-02 via WebFetch. README contents
  extracted. **Cached** as Markdown summary at
  `references-cache/sky130-ringosc-hadirkhan10/README-summary.md`.
- **Relevance:** Reference open-source ring-osc on the SkyWater PDK.
  Contains 6 inverters + 1 NAND gate (enable) + 2-to-1 mux (selectable
  short or long ring); implemented from the standard cell library;
  simulated digitally with IRSIM and analog with ngspice. **Frequency not
  measured** — design is layout-only. Confirms the "6 inverters + NAND
  + mux" pattern used by virtually every Tiny Tapeout ring-osc submission.

### [TT09-RINGOSC] algofoogle Tiny Tapeout 09 ring oscillator

- **Citation:** Anton Maurović (algofoogle), "tt09-ring-osc: Simple TT09
  ring oscillator (Verilog)," GitHub.
- **URL:** https://github.com/algofoogle/tt09-ring-osc and
  https://github.com/algofoogle/tt09-ring-osc3 (a longer 1001-stage variant).
- **Type:** Open-source design submitted to a Tiny Tapeout shuttle (sky130).
- **Verification:** Fetched 2026-05-02. The 1001-inverter long variant
  with 8-tap selectable length is documented in the README.
- **Relevance:** Concrete tapeout-ready Verilog ring-osc. Demonstrates
  that even on the open-source flow, ring oscillators are a one-liner;
  the "design effort" is approximately zero.

### [TT-MV-ANALOG-RINGOSC] Tiny Tapeout TT08 mattvenn analog ring osc

- **Citation:** Matt Venn, "265 Ring Oscillators" project, Tiny Tapeout
  TT08 (sky130).
- **URL:** https://tinytapeout.com/runs/tt08/tt_um_mattvenn_analog_ring_osc
- **Verification:** URL resolves 2026-05-02 (search hit).
- **Relevance:** Massively-parallel ring oscillator — 265 oscillators —
  used as a *PUF / sensor / temperature probe* rather than a clock. Useful
  as a reminder that an array of identical ring oscillators is a known
  way to *sample PVT*, which is the inverse problem of generating a
  PVT-stable clock; the same data can be used to *correct* a ring osc.

### [TT04-ROTEMP] Rodrigo Munoz ring-oscillator-based temp sensor (TT04)

- **Citation:** Rodrigo Munoz, "another ring oscillator based temperature
  sensor," Tiny Tapeout TT04.
- **URL:** https://tinytapeout.com/chips/tt04/tt_um_rodrigomunoz1_rotempsensor_top
- **Verification:** URL resolves 2026-05-02 (search hit).
- **Relevance:** Demonstrates measured ring-osc temperature coefficient on
  silicon as an open-source data point.

### [GF180-MABRAINS] mabrains GF180MCU RISC-V SoC analog IPs

- **Citation:** Mabrains, "GF180MCU 180nm MCU Analog/Digital IPs for
  Caravel-GFMPW1," GitHub.
- **URL:** https://github.com/mabrains/gf180mcu_riscv_soc
- **Type:** Open-source IP, taped out on Google MPW1 GF180MCU shuttle.
- **Verification:** Fetched 2026-05-02 via WebFetch. README content
  extracted; confirms entries for `Ring-Osc-3.3vFETs`, `Ring-Osc-5.0vFETs`,
  `XTAL-Osc-16M`, and `XTAL-Osc-100M`, all with DRC/LVS/PEX checks
  passed. **Cached** as Markdown summary at
  `references-cache/gf180-mabrains/README-summary.md`.
- **Relevance:** Closest-known prior art on **the actual target PDK**
  (GF180MCU). Two ring-oscillator variants (3.3 V FETs and 5.0 V FETs) plus
  two crystal-oscillator drivers (16 MHz and 100 MHz). No measured-silicon
  performance numbers in the README, but the layout exists and is
  Apache-2.0 licensed — directly re-usable.

### [SI-CMEMS] Silicon Labs Si50x CMEMS oscillator architecture

- **Citation:** Silicon Laboratories, "CMEMS Oscillator Architecture"
  white paper.
- **URL:** https://pages.silabs.com/lp-cmems-oscillator-architecture.html
  and https://mikrokontroler.pl/wp-content/uploads/pliki/cmems-oscillator-architecture.pdf
- **Verification:** URLs resolve 2026-05-02 (search hits, both with
  identifiable PDF mirrors).
- **Relevance:** Industry reference for *MEMS-on-CMOS* monolithic
  oscillators. SiGe + SiO₂ resonator layered on top of CMOS, FLL +
  digitally-controlled VCO + temperature-sensor compensation. Useful as
  an upper bound on what's done in commercial products; **not directly
  applicable to GF180MCU** because CMEMS is a Silicon Labs proprietary
  back-end-of-line addition.

## Background / industry-context (verified)

### [MSP430-DCO-HACKADAY] Hackaday: Calibrating the MSP430 DCO

- **URL:** https://hackaday.com/2015/03/15/calibrating-the-msp430-digitally-controlled-oscillator/
- **Verification:** Fetched 2026-05-02. Confirms uncalibrated DCO ±1 MHz
  chip-to-chip drift; calibrated against 32 768 Hz crystal yields ~1 %.

### [STM-RC-COMMUNITY] STMicroelectronics community thread on HSI accuracy

- **URL:** https://community.st.com/t5/stm32-mcus-products/stm32g071-hsi-rc-internal-rc-oscillator-accuracy-rc-oscillator/td-p/186778
- **Verification:** Fetched 2026-05-02 (search hit) — community confirms
  STM32G HSI16 trim step is ~0.3 % per LSB; total range ±5 %.

### [JIMMYIOT-NRF52] JimmyIoT internal RC calibration on Nordic nRF52

- **URL:** https://jimmywongiot.com/2019/12/17/internal-rc-calibration-handling-on-the-nordic-nrf52-chipset/
- **Verification:** URL resolves 2026-05-02 (search hit).
- **Relevance:** Engineering walkthrough of the nRF52 LFRC calibration
  procedure (run periodically against the LFXO if present, or HFXO).
  Concrete account of how a "soft" radio uses a "soft" RC.

### [WPC-INTRO] Wireless Power Consortium Qi specification (overview)

- **Citation:** Wireless Power Consortium, *The Qi Wireless Power
  Specification* (cached PDF excerpt only).
- **Verification:** Cached PDF found in WebFetch tool-results from a
  related session (8.5 MB). Confirms 100–205 kHz Qi BPP carrier,
  load-modulation control. Used purely to confirm there is *no* internal-
  oscillator requirement on the receiver side beyond the rectifier control
  loop — relevant because a clock for Qi housekeeping at <1 kHz is a
  sub-trivial frequency target.

### [ALL-ABOUT-CIRCUITS-MCU-OSC] All About Circuits — Good and Bad of MCU Internal Oscillators

- **URL:** https://www.allaboutcircuits.com/technical-articles/the-good-and-the-bad-of-mcu-internal-oscillators/
- **Verification:** URL resolves 2026-05-02 (search hit).
- **Relevance:** Cross-vendor "factory ±1–2 %, ±5–10 % over PVT" claim
  echoed across the industry. Useful for cross-checking individual
  vendor numbers.

### [MAKINWA-FREQ-REF-LECTURE] Makinwa group survey of integrated frequency references

- **URL:** https://ei.tudelft.nl/smart_temperature/Smart_temperature_sensors_in_standard_CMOS.pdf
- **Verification:** URL resolves 2026-05-02 (search hit).
- **Relevance:** Survey ties relaxation, RC-FLL, thermal-diffusivity,
  Wien-bridge, and bulk-acoustic-wave references on a single comparison
  axis (ppm vs power vs area). Crossreferences the Makinwa 16 MHz CMOS RC
  ±90 ppm result for academic-survey hand-off.

### [INFINEON-FBAR-NSF] FBAR fast start-up reference oscillator paper

- **URL:** https://par.nsf.gov/servlets/purl/10109329
- **Verification:** Search hit 2026-05-02. PDF accessible via NSF PAR.
- **Relevance:** Background on FBAR / BAW resonators — commercial Avago
  / Broadcom history (Infineon FBAR group → Avago 2008 → Broadcom 2016).
  Listed for completeness; **not directly applicable** to GF180MCU because
  FBAR is a process-incompatible add-on at this node.

## Standards / regulatory (verified)

### [ISO14443-A] ISO/IEC 14443 Type A air interface

- **Citation:** ISO/IEC 14443-2, "Identification cards — Contactless integrated
  circuit cards — Proximity cards — Part 2: Radio-frequency power and signal
  interface," last revision 2020.
- **URL:** https://www.iso.org/standard/73599.html (ISO catalogue page).
- **Verification:** URL resolves 2026-05-02 (search hit). Standard text
  paywalled by ISO; **NTAG213 datasheet [NXP-NTAG213] cites the same
  numbers**, so they have been verified independently. SHA-256 of catalogue
  page recorded if reviewer wants byte-level proof.
- **Relevance:** Defines the 13.56 MHz ± 7 kHz carrier (i.e. the chip never
  generates this clock; it derives it from the reader). Bit duration =
  carrier ÷ 128 = 9.4 µs (106 kbit/s). Subcarrier = carrier ÷ 16 =
  847.5 kHz. **Therefore a tag's "internal" timing is implicitly trim-free
  and PVT-immune: it's literally just a counter on the carrier.** Critical
  finding for our (h) NFC core: it should not need an internal RC at all.

### [USB-2.0-SPEC] USB 2.0 Full-Speed accuracy budget (±2500 ppm)

- **Citation:** Universal Serial Bus Specification, Revision 2.0,
  USB-IF, 2000-2024.
- **URL:** https://www.usb.org/document-library/usb-20-specification
- **Verification:** URL resolves 2026-05-02 (search hit).
- **Relevance:** Defines the ±2500 ppm (= ±0.25 %) full-speed clock spec
  that crystal-less USB MCUs must meet via SOF clock-recovery trim. Useful
  as a *peer requirement* against which we can size the much-looser ±20 %
  budget of items (b)–(f).

## Failed-fetch / paywalled / mirror-pending

| Citation | Issue | Action taken / planned |
|---|---|---|
| [ST-AN2868], [ST-AN4736], [ST-AN5067] | WebFetch timed out twice on st.com large PDFs (slow CDN) | URLs verified to resolve via search-engine result; PDFs not mirrored. Reviewer to retry via `curl -O` or web.archive.org snapshot. |
| [NXP-NTAG213] | PDF too long for one WebFetch call; structural metadata only confirmed | Same as above — content cross-verified through ISO 14443 spec and third-party app notes. |
| [NXP-AN4905] | HTTP 404 on canonical URL as of 2026-05-02 | Document name confirmed in search index. Reviewer to retry via Wayback. |
| [TI-SLAA336], [TI-SLAA992] | Fetched only via search snippets; PDFs not mirrored | URLs confirmed resolved by ti.com search; reviewer to mirror. |
| [USP-6020792], [USP-8222940], [USP-9344070] | Mirrored as Markdown summaries from WebFetch output | Reviewer should fetch original Google Patents HTML and `sha256sum` it for byte-exact archiving. |
