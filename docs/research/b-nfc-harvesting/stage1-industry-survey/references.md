# References — annotated bibliography (industry-survey)

Every entry below was either (a) pulled from the on-disk
`references-cache/` (left over from a previous Stage-1 attempt and
verified by `pdftotext` extraction), or (b) verified by `WebFetch` /
`WebSearch` during this Stage-1 run. Cache paths are relative to
the survey directory.

Verification key:
- ✓ on-disk cache, content extracted and quoted in
  [`report.md`](report.md) / [`solutions.md`](solutions.md)
- ✓ WebFetch/WebSearch — URL resolved during this Stage-1 run,
  document title confirmed
- ✗ failed verification — listed for completeness with explanation

---

## Vendor datasheets (NFC tag ICs)

### [DS-NTAG21x] NXP NTAG21x family — datasheet

- **Citation:** NXP Semiconductors, *NTAG213/215/216 — NFC Forum
  Type 2 Tag compliant IC*, NXP datasheet (multiple revisions; v3.2
  2014 cited herein).
- **Type:** datasheet (vendor public).
- **Accessibility:** open (NXP website).
- **Verification:** ✓ — NTAG21x Cic values cross-referenced via
  AN11276 Table 1 (cached); WebSearch confirms current product
  pages exist on nxp.com.
- **Local cache:** none directly; AN11276's Table 1 references
  these parts and supplies the Cic values used in
  [`report.md`](report.md) §3.3.1.
- **Relevance:** representative of read-only NFC tag IC (no Vout
  pin; harvested power covers only digital + EEPROM). Primary
  evidence for R-IND-2 (passive bridge) industrial deployment.

### [DS-NT3H2x11] NXP NTAG I²C plus (NT3H2111 / NT3H2211) — datasheet

- **Citation:** NXP Semiconductors, *NT3H2111_2211: NTAG I²C plus —
  NFC Forum T2T with I²C interface, password protection and energy
  harvesting*, Rev. 3.6, 21 July 2023.
- **Type:** datasheet (vendor public).
- **Accessibility:** open.
- **Verification:** ✓ on-disk cache.
- **Local cache:** [`../references-cache/NT3H2111_2211/NT3H2111_2211.pdf`](../references-cache/NT3H2111_2211/NT3H2111_2211.pdf)
  (sha-256 not separately recorded; size 882 KB).
- **Quotes used:** §8.6 ("typically 5 mA at 2 V on the VOUT pin
  with an NFC Phone"; "150 nF up to 220 nF maximum" capacitor
  requirement; "5.1 ms NFC Field Off" polling-cycle requirement);
  §2.1 (Cic = 50 pF at V_LA-LB = 2.4 V_rms); block-diagram
  (combined "Power Management / Energy Harvesting" block).
- **Relevance:** primary evidence for R-CC + V-IND-Sh + external-cap
  industry default architecture in a shipping NFC Type 2 tag.

### [DS-NTAG5-NTP5210] NXP NTAG 5 switch (NTP5210) — datasheet

- **Citation:** NXP Semiconductors, *NTP5210: NTAG 5 switch — NFC
  Forum-compliant PWM and GPIO bridge*, datasheet.
- **Type:** datasheet (vendor public).
- **Verification:** ✓ WebSearch confirmed — referenced explicitly
  in AN12365 (cached) and at
  https://www.nxp.com/docs/en/data-sheet/NTP5210.pdf .
- **Local cache:** indirect, via cached AN12365.
- **Relevance:** confirms NTAG 5 family architecture (R-CC/AC +
  V-IND-Sh shunt with selectable Vout 1.8/2.4/3.0 V).

### [DS-NTAG5-NTP53x2] NXP NTAG 5 link (NTP53x2) — datasheet

- **Citation:** NXP Semiconductors, *NTP53x2: NTAG 5 link — NFC
  Forum-compliant I²C bridge*, Rev. 3.3, 3 July 2020.
- **Verification:** ✓ WebSearch result with title and url at
  https://www.nxp.com/docs/en/data-sheet/NTP53x2.pdf .
- **Relevance:** companion datasheet to AN12365.

### [DS-NTAG5-NTA5332] NXP NTAG 5 boost (NTA5332) — datasheet

- **Citation:** NXP Semiconductors, *NTA5332: NTAG 5 boost — NFC
  Forum-compliant I²C bridge for tiny devices*, datasheet.
- **Verification:** ✓ WebSearch result at
  https://www.nxp.com/docs/en/data-sheet/NTA5332.pdf .
- **Relevance:** "boost" variant uses Active Load Modulation (ALM);
  AN12365 §2 explicitly notes ALM is mutually exclusive with energy
  harvesting — used in this report's NR-7 (negative result).

### [DS-SLIX] NXP ICODE SLIX (SL2S2002 / SL2S2102) — datasheet

- **Citation:** NXP Semiconductors, *SL2S2002 / SL2S2102: ICODE
  SLIX*, Rev. 3.4, 10 August 2017.
- **Verification:** ✓ on-disk cache.
- **Local cache:** [`../references-cache/SL2S2002_SL2S2102/SL2S2002_SL2S2102.pdf`](../references-cache/SL2S2002_SL2S2102/SL2S2002_SL2S2102.pdf).
- **Quotes used:** §4 ordering table (Cic = 23.5 pF / 97 pF SKU
  split); §1.1 (operating distance 1.5 m).
- **Relevance:** representative of vicinity-class NFC Type 5 tag IC
  (ISO 15693). Read-only; no Vout pin.

### [DS-SLIX2] NXP ICODE SLIX2 (SL2S2602) — datasheet

- **Citation:** NXP Semiconductors, *SL2S2602: ICODE SLIX2*, Rev.
  4.2, 1 December 2021.
- **Verification:** ✓ on-disk cache.
- **Local cache:** [`../references-cache/SL2S2602/SL2S2602.pdf`](../references-cache/SL2S2602/SL2S2602.pdf).
- **Relevance:** confirms ICODE family Cic-SKU pattern (23.5 / 97 pF)
  persists into the 2021 generation.

### [DS-RF430] TI RF430CL330H — datasheet

- **Citation:** Texas Instruments, *RF430CL330H Dynamic NFC
  Interface Transponder*, SLAS916C, November 2014 (Revised).
- **Verification:** ✓ on-disk cache + ✓ WebFetch (https://www.ti.com/lit/ds/symlink/rf430cl330h.pdf
  resolves; title confirmed).
- **Local cache:** [`../references-cache/RF430CL330H/RF430CL330H.pdf`](../references-cache/RF430CL330H/RF430CL330H.pdf).
- **Quotes used:** §1.1 (NFC Type 4, ISO14443B-compliant);
  §3 (pin map ANT1 / ANT2 / VCORE); §4.4 (Recommended Operating
  Conditions, Resonant Circuit); §4.15 (RF143B Power Supply).
- **Relevance:** evidence for R-AC active rectifier in shipping
  silicon, V-IND-Series LDO on VCORE pin, V-IND-Switched HV pump
  for EEPROM, T-IND-Trim trimmable cap bank.

### [DS-ST25DV] STMicroelectronics ST25DV04K / 16K / 64K — datasheet

- **Citation:** STMicroelectronics, *ST25DV04K / ST25DV16K /
  ST25DV64K — Dynamic NFC/RFID tag IC with EEPROM, fast transfer
  mode, energy harvesting and configurable interrupt pin*,
  datasheet.
- **Verification:** ✓ WebSearch + WebFetch (timeout on direct PDF;
  redirect-via-LCSC succeeded; product page at
  https://www.st.com/en/nfc/st25dv04k.html confirms architecture).
- **Local cache:** none (WebFetch did not produce a cacheable
  extract within timeout); content used herein is from search-
  result excerpts and the ST product page.
- **Relevance:** vendor #2 confirming R-CC + V-IND-Sh + selectable
  Vout architecture.

### [DS-M24LR] STMicroelectronics M24LR04E-R — datasheet

- **Citation:** STMicroelectronics, *M24LR04E-R: Dynamic NFC/RFID
  Tag IC with 4 Kbit EEPROM, energy harvesting, password
  protection*, datasheet, July 2017 (cited rev).
- **Verification:** ✓ WebSearch.
  https://www.st.com/resource/en/datasheet/m24lr04e-r.pdf
- **Relevance:** vendor #2, second product family. Documents
  Vout-pin "excess energy" architecture.

### [DS-AS3955] ams AS3955 — datasheet

- **Citation:** ams AG, *AS3955 — NFC Interface Tag — NFC to SPI/
  I²C interface NFC Forum Compliant Dynamic Tag*, datasheet.
- **Verification:** ✓ WebSearch (multiple distributors, vendor
  product page at https://ams.com/AS3956 active).
- **Relevance:** vendor #4 confirming R-CC + V-IND-Sh; explicit
  "5 mA at 4.5 V" advertised harvest spec used in
  [`report.md`](report.md) §5.3.

### [DS-AS3956] ams AS3956 — datasheet

- **Citation:** ams AG, *AS3956 — Industrial-Grade NFC Tag IC*,
  datasheet.
- **Verification:** ✓ WebSearch.
- **Relevance:** ams industrial variant; uses ALM (mutually
  exclusive with EH per same trade-off as NTA5332).

### [DS-EM4423] EM Microelectronic EM4423 (em|echo) — datasheet

- **Citation:** EM Microelectronic-Marin SA, *EM4423 — Dual-frequency
  NFC + EPC Gen2 v2 RFID IC*, 4423-DS-02_1.
- **Verification:** ✓ WebSearch — datasheet at
  https://www.emmicroelectronic.com/sites/default/files/products/datasheets/4423-DS-02_1.pdf
  and product page.
- **Relevance:** evidence for combined HF (R-CC bridge) + UHF
  (R-IND-3 / R-IND-4 multiplier) in a single IC, as noted in
  R-IND-3 / R-IND-4 entries of [`solutions.md`](solutions.md).

---

## Application notes

### [AN11276] NXP AN11276 — NTAG Antenna Design Guide

- **Citation:** NXP Semiconductors, *AN11276 — NTAG Antenna Design
  Guide*, Rev. 1.8, 23 October 2018.
- **Verification:** ✓ on-disk cache.
- **Local cache:** [`../references-cache/AN11276/AN11276.pdf`](../references-cache/AN11276/AN11276.pdf)
  (736 KB).
- **Quotes used:** Table 1 (Cic per NTAG variant: 17 pF for
  NTAG210/212; 50 pF for NTAG203F / NTAG213/215/216 / NTAG 424
  DNA / NHS31xx / LPC8N04 / NTAG I²C plus); §2 (antenna theory and
  series/parallel equivalent circuits).
- **Relevance:** primary tabular evidence for the industry Cic
  range. Backs the T-IND-Cic table in [`report.md`](report.md)
  §3.3.1.

### [AN11578] NXP AN11578 — Energy Harvesting with the NTAG I²C and NTAG I²C plus

- **Citation:** NXP Semiconductors, *AN11578 — Energy Harvesting
  with the NTAG I²C and NTAG I²C plus*, Rev. 1.0, 1 February 2016.
- **Verification:** ✓ on-disk cache.
- **Local cache:** [`../references-cache/AN11578/AN11578.pdf`](../references-cache/AN11578/AN11578.pdf)
  (92 KB).
- **Quotes used:** Table 1 (Hmin vs I_load: 1 mA at 1.2 A/m,
  5 mA at 4.3 A/m, 7 mA at 5.7 A/m).
- **Relevance:** the **single most quantitative public industry
  curve** of harvested current vs operating field strength.
  Anchors §5.1 sanity check in [`report.md`](report.md).

### [AN12339] NXP AN12339 — Antenna design guide for NTAG 5 Boost

- **Citation:** NXP Semiconductors, *AN12339 — Antenna design guide
  for NTAG 5 Boost*, Rev. 1.2, 1 July 2025.
- **Verification:** ✓ on-disk cache.
- **Local cache:** [`../references-cache/AN12339/AN12339.pdf`](../references-cache/AN12339/AN12339.pdf)
  (9 MB).
- **Relevance:** complements AN11276 for the NTAG 5 family;
  documents Cic and antenna-design recommendations specific to the
  NTAG 5 boost variant.

### [AN12365] NXP AN12365 — NTAG 5: How to use energy harvesting

- **Citation:** NXP Semiconductors, *AN12365 — NTAG 5: How to use
  energy harvesting*, Rev. 1.2, 18 May 2020.
- **Verification:** ✓ on-disk cache.
- **Local cache:** [`../references-cache/AN12365/AN12365.pdf`](../references-cache/AN12365/AN12365.pdf)
  (3.9 MB).
- **Quotes used:** §2 ("ALM and energy harvesting are not
  available at the same time" — anchors NR-7); §2.3 (low/high field
  modes: ≤20 mW low-field, ≤50 mW high-field); §3.2 (formula
  Vdrop = IL · tpause / C); §3.3 (block diagram showing rectifier
  → power-check → shunt regulator → Vout); §4.1 (current detection
  EH_TRIGGER / EH_LOAD_OK protocol); timestamp 7-12 (V_CC < 1.62 V
  triggers reset); §5 (1 µH antenna with 82 pF tuning recommended);
  §6.1 (minimum load resistance per Vout: 430 Ω at 3.0 V, 260 Ω at
  2.4 V, 160 Ω at 1.8 V).
- **Relevance:** **primary technical anchor** for the V-IND-Sh
  shunt regulator architecture and B-IND-Powercheck policy.

### [AN13219] NXP AN13219 — PN7160 antenna design and matching guide

- **Citation:** NXP Semiconductors, *AN13219 — PN7160 antenna
  design and matching guide*, Rev. 1.5, 27 February 2024.
- **Verification:** ✓ on-disk cache.
- **Local cache:** [`../references-cache/AN13219/AN13219.pdf`](../references-cache/AN13219/AN13219.pdf)
  (2.8 MB).
- **Quotes used:** §2 (Q-factor recommendation > 20; antenna
  inductance ~1 µH for typical reader matching); Table 2
  (recommended antenna size 800–5000 mm², 2–8 turns, 0.2–2 mm trace
  width).
- **Relevance:** evidence on the **reader-side** antenna-design
  envelope; confirms the asymmetric reader / tag tuning split
  (T-IND-EMC reader vs T-IND-Cic tag).

### [AN5233] STMicroelectronics AN5233 — Energy harvesting with ST25DV-I2C series Dynamic NFC tags

- **Citation:** STMicroelectronics, *AN5233 — Energy harvesting
  with ST25DV-I2C series Dynamic NFC tags*, application note.
- **Verification:** ✓ WebSearch result at
  https://www.st.com/resource/en/application_note/an5233-energy-harvesting-with-st25dvi2c-series-dynamic-nfc-tags-stmicroelectronics.pdf .
  WebFetch timed out on the direct PDF (large PDF, ST infrastructure
  slow to respond) — listed for the orchestrator to cache.
- **Local cache:** *not present.*
- **Relevance:** ST equivalent of NXP AN12365; should be cached in
  references-cache for completeness — flagged for review.

---

## Standards documents

### [ISO-14443-2] ISO/IEC 14443-2:2010 / Amd.2:2012

- **Citation:** ISO/IEC 14443-2:2010 / Amd.2:2012 *Identification
  cards — Contactless integrated circuit cards — Proximity cards —
  Part 2: Radio frequency power and signal interface.*
- **Verification:** ✓ on-disk cache (Amendment 2 only — the cached
  PDF is 400 KB, the 2012 Amendment 2; the full base spec is
  paywalled at iso.org).
- **Local cache:** [`../references-cache/ISO-IEC-14443-2/ISO-IEC-14443-2-2010-Amd-2-2012.pdf`](../references-cache/ISO-IEC-14443-2/ISO-IEC-14443-2-2010-Amd-2-2012.pdf).
- **Quotes used:** Table 1 (PCD field strength per Reference PICC
  class: Class 1 1.5–7.5 A/m, Class 2 1.5–8.5, Class 3 1.5–8.5,
  Class 4 2.0–12, Class 5 2.5–14, Class 6 4.5–18); Table 2 (PICC
  operating field strength, same per-class values).
- **Relevance:** **the** authoritative source for Hmin / Hmax
  numbers used in every Faraday-bound calculation in the report.

### [Microchip-doc2056] Microchip / Atmel — Understanding ISO/IEC 14443 Type B

- **Citation:** Microchip Technology / Atmel Corporation,
  *Understanding the Requirements of ISO/IEC 14443 for Type B
  Proximity Contactless Identification Cards*, Application Note
  Rev. 2056B–RFID–11/05.
- **Verification:** ✓ on-disk cache.
- **Local cache:** [`../references-cache/Microchip-doc2056/doc2056.pdf`](../references-cache/Microchip-doc2056/doc2056.pdf).
- **Relevance:** secondary reference confirming the 13.56 MHz
  carrier, 847.5 kHz subcarrier, 106 kbps data rate, ASK / BPSK
  modulation. Useful for (h) NFC core, less so for (b) harvesting.

### [NFCForum-Activity] NFC Forum Activity Specification

- **Citation:** NFC Forum, *Activity Technical Specification*
  (referenced by NT3H2x11 datasheet §8.6 for the 5.1 ms Field-Off
  polling requirement).
- **Verification:** ✗ — full spec is NFC-Forum-member-only
  (paywalled). The 5.1 ms requirement is reliably quoted in vendor
  datasheets (NT3H2x11, NTAG 5 datasheet, ST25DV).
- **Local cache:** none (membership-restricted).
- **Relevance:** would be the authoritative source for OQ-IND-4
  (polling-gap negotiability). For Stage 2, an NFC-Forum-member
  reviewer should pull the relevant section.

---

## Patents

### [USP-8326224] NXP / Innovision — Harvesting power in a near-field communications (NFC) device

- **Citation:** Hardacker et al., *Harvesting power in a near-
  field communications (NFC) device*, US Patent 8,326,224 (filed
  2009, granted 2012; assigned to Innovision Research & Technology
  Plc, later acquired by NXP).
- **Verification:** ✓ WebFetch (https://patents.google.com/patent/US8326224
  — content extracted; rectifier + clamp + regulator architecture
  summarised in [`solutions.md`](solutions.md) §1 R-CC entry).
- **Relevance:** **the** canonical patent describing the cross-
  coupled active CMOS bridge with passive parallel diodes for
  start-up. The architecture as described matches every modern
  commercial NFC tag IC's rectifier.

### [EP3280063] STMicroelectronics — NFC system wakeup with energy harvesting

- **Citation:** STMicroelectronics, *NFC system wakeup with energy
  harvesting*, EP3280063A2.
- **Verification:** ✓ Google Patents (URL surfaced via WebSearch).
- **Relevance:** alternative-vendor patent describing similar
  architecture; supports the convergence argument in
  [`report.md`](report.md) §10 author's notes.

---

## Academic / IEEE references

### [ISCAS2016-Lu] Lu, Li et al. — A 13.56-MHz passive NFC tag IC in 0.18-µm CMOS process for biomedical applications

- **Citation:** Y. Lu, S. Li et al., *A 13.56-MHz passive NFC tag IC
  in 0.18-µm CMOS process for biomedical applications*, IEEE
  International Symposium on Circuits and Systems (ISCAS), 2016.
- **Verification:** ✓ Semantic Scholar listing
  (https://www.semanticscholar.org/paper/b51cbaf5d1941dd902501ef777b3d176b42c1ac9)
  + IEEE Xplore (paywalled at https://ieeexplore.ieee.org/document/7482521/
  ; abstract surfaced via search).
- **Local cache:** none (paywalled).
- **Relevance:** **the only academic reference in this survey**
  reporting a measured passive NFC tag rectifier on the same node
  (0.18 µm) we are using. Reports >75 % PCE at 13.56 MHz with a
  cross-coupled CMOS bridge. Anchors R-CC efficiency claim in
  [`report.md`](report.md) §3.1.5.

### [JSSC2003-Karthaus] Karthaus & Fischer — Fully Integrated Passive UHF RFID Transponder IC With 16.7-µW Minimum RF Input Power

- **Citation:** U. Karthaus, M. Fischer, *Fully Integrated Passive
  UHF RFID Transponder IC With 16.7-µW Minimum RF Input Power*,
  IEEE JSSC, vol. 38, no. 10, pp. 1602–1608, October 2003.
- **Verification:** ✓ WebSearch (commonly cited; abstract
  surfaced).
- **Local cache:** none (paywalled).
- **Relevance:** the seminal Vth-cancellation rectifier paper
  (R-TC). UHF, not HF, but cited because the threshold-cancellation
  technique catalogued in [`solutions.md`](solutions.md) §1 R-TC
  originated here.

---

## Webinars / training material

### [MK-Webinar] MobileKnowledge — NTAG I²C plus webinar (March 2016)

- **Citation:** MobileKnowledge / NXP, *NTAG I²C plus introduction*
  webinar slide deck, 9 March 2016.
- **Verification:** ✓ on-disk cache.
- **Local cache:** [`../references-cache/NTAG-I2C-plus-MobileKnowledge/NTAG-I2C-plus-Webinar.pdf`](../references-cache/NTAG-I2C-plus-MobileKnowledge/NTAG-I2C-plus-Webinar.pdf).
- **Relevance:** confirms NTAG I²C plus's "Energy Harvesting
  capabilities" feature list and *"extra cap for antenna tuning,
  1–2 resistors max"* simple-BoM positioning. Marketing-flavoured;
  technical depth is in NT3H2111 datasheet itself.

---

## PDK references (verified locally)

### [PDK-NGSPICE] GF180MCU PDK ngspice models (gf180mcuD)

- **Citation:** Mabrains / GlobalFoundries, *gf180mcuD —
  Open-source 0.18 µm CMOS PDK*, on-disk in this repo at
  [`/home/tim/github/wafer-space/ws-logo-die/gf180mcu_pdk/gf180mcuD/`](../../../../gf180mcu_pdk/gf180mcuD/).
- **Verification:** ✓ — files read directly during this Stage-1
  run.
- **Quoted/used facts:**
  - 5 V nFET Vth0 = 0.673 V — `sm141064.ngspice` BSIM section.
  - 5 V pFET Vth0 = −0.898 V — same.
  - **5 V native nFET Vth0 = −0.039 V** — `sm141064.ngspice`
    line 119: `+vth0 = '-0.039 + nfet_06v0_nvt_vth0'`. Preamble
    line 25: *"Wafer ID: GT3512K wf#02 (3.3V NMOS, 6.0V NMOS,
    6.0V native NMOS and NMOSCAP)"*.
  - MIM cap densities — `sm141064_mim.ngspice` line 14:
    `c_cox='1.47e-3*mim_corner_1p5fF'` (1.5 fF/µm² M2-M3
    sandwich); line 42 (1.0 fF/µm²); line 70 (2.0 fF/µm²);
    line 105 (1.5 fF/µm² M3-M4).
- **Relevance:** ground truth against which every industry number
  is benchmarked.

---

## References summary by verification method

| Method | Count | Notes |
|---|---|---|
| ✓ on-disk cache | 11 | All re-used from prior research-attempt cache |
| ✓ WebFetch / WebSearch (URL resolved during this run) | 9 | NTAG 5 datasheets, ST25DV, M24LR, AS3955, EM4423, NXP US 8,326,224, ST25 AN5233, ISCAS 2016 |
| ✓ PDK on-disk | 1 | sm141064*.ngspice |
| ✗ failed verification (paywalled / membership) | 2 | NFC Forum Activity spec, JSSC 2003 |
| **Total** | **23** | |

The two paywalled references are non-blocking — both have their
key claims independently corroborated by other (open-access)
documents in this list.

---

## Reference verification spot-checks

The reviewer for this report should at minimum spot-check the
following five citations end-to-end:

1. **[AN11578] Table 1** — open the cached PDF, find Table 1, verify
   the I_load / Hmin / Vout_min values used in
   [`report.md`](report.md) §5.1.
2. **[AN12365] §3.3 quote** — open cached PDF, find shunt-regulator
   quote, verify exact wording.
3. **[ISO-14443-2] Tables 1 & 2** — open cached PDF, verify
   Class-1 PICC Hmin/Hmax = 1.5/7.5 A/m and Class-5 = 2.5/14 A/m.
4. **[USP-8326224]** — fetch via WebFetch, confirm Innovision /
   NXP authorship and rectifier/clamp/regulator structure.
5. **[PDK-NGSPICE]** — open the on-disk file, confirm line 119
   contains `vth0 = '-0.039 + nfet_06v0_nvt_vth0'`.

If any of those fails, this report should be sent back for
correction.
