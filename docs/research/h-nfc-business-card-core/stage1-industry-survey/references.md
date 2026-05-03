---
item: h
item_name: nfc-business-card-core
stage: 1
angle: industry-survey
researcher: stage1-industry-survey-1
status: draft
last-updated: 2026-05-03
---

# References — Stage 1, industry survey, item (h)

Each entry: full citation, type, accessibility, verification status, local cache,
and a 1–3 sentence relevance note. Verification used `WebFetch`/`WebSearch` on
2026-05-03 unless noted.

Citation IDs are stable across the four sibling files in this stage.

---

## Tag-IC primary datasheets (vendor)

### `[NTAG21x-DS]` — NXP NTAG213/215/216 product data sheet, Rev. 3.2

- Authors / publisher: NXP Semiconductors N.V.
- Title: *NTAG213/215/216 — NFC Forum Type 2 Tag compliant IC with
  144/504/888 bytes user memory*
- Version / date: Rev. 3.2 — 2 June 2015 (document 265332).
- URL: https://www.nxp.com/docs/en/data-sheet/NTAG213_215_216.pdf
- Type: vendor product datasheet (COMPANY PUBLIC).
- Accessibility: open access; PDF is large (≈ 1.9 MB) and times out from
  some hosts (404/timeout via `WebFetch`).
- Verification: URL listed in NXP's product-page index and confirmed to
  resolve via Google search 2026-05-03; **local cached copy** exists at
  `references-cache/ntag21x-datasheet/NTAG213_215_216_rev3.2.pdf`
  (1,932,396 bytes), inspected page-by-page in this report (cover, §1.1,
  §2 features, §8.4 state machine, §8.5 memory map, Figs 5/6/7).
- Relevance: **the** reference for what a phone-readable T2T looks like
  internally. Confirms 13.56 MHz, 106 kbit/s, 7-byte UID at cascade
  level 2, 50 pF input capacitance, full ISO 14443 Type A and NFC Forum
  T2T compliance, and (per §3 "Applications", page 3) explicitly lists
  *"Business cards"* as a target use case. Memory map figs 5–7 give
  the byte-exact T2T layout we will replicate.

### `[ST25TN512-DS]` — STMicroelectronics ST25TN512 datasheet

- Title: *ST25TN512 ST25TN01K — NFC Forum Type 2 tag IC with 512-bit /
  1-Kbit EEPROM*.
- URL: https://www.st.com/resource/en/datasheet/st25tn512.pdf
- Type: vendor datasheet.
- Accessibility: open access; ST's CDN times out under WebFetch but URL
  resolves via Google search index (`st.com` link confirmed).
- Verification: 2026-05-03, resolution confirmed indirectly via search
  results which quote the document title and key features (208 B user,
  106 kbit/s, RF-only powered, UFDFPN5 1.7 × 1.4 mm).
- Relevance: ST's competitor to NTAG213 in the smallest-area T2T class.
  Useful for cross-checking the "T2T baseline" against a second vendor.

### `[ST25TV02K-DS]` — STMicroelectronics ST25TV02K datasheet

- Title: *ST25TV02K — Dynamic NFC/RFID tag IC with 2-Kbit EEPROM,
  ISO/IEC 15693 and NFC Forum Type 5*.
- URL: https://www.st.com/resource/en/datasheet/st25tv02k.pdf
- Type: vendor datasheet.
- Accessibility: open access (CDN timeouts as above; resolution confirmed
  via search index).
- Verification: 2026-05-03 — title and key parameters (53 kbit/s data
  rate, 2 kbit EEPROM, 64-bit UID, 23 pF or 99.7 pF tuning cap, 60-year
  retention) reproduced from search-result snippets.
- Relevance: representative T5T (ISO/IEC 15693) data point, used in §3.1
  to bracket the long-range / lower-bit-rate end of the design space.

### `[ST25TA02K-DS]` — STMicroelectronics ST25TA02K datasheet

- Title: *ST25TA02K — NFC Forum Type 4 Tag IC with 2-Kbit EEPROM and
  general-purpose output*.
- URL: https://www.st.com/resource/en/datasheet/st25ta02k.pdf
  (also octopart mirror used for verification:
  https://datasheet.octopart.com/ST25TA02K-DC6H5-STMicroelectronics-datasheet-48704723.pdf)
- Type: vendor datasheet.
- Accessibility: open access; PDF binary stream returns; 1.3 MB.
- Verification: 2026-05-03 — confirmed 50 pF tuning, 106 kbit/s, 256-byte
  EEPROM, 7-byte UID, 128-bit password, ISO 14443-A + ISO 7816-4
  command set (SELECT / READ_BINARY / UPDATE_BINARY) per ST product
  overview.
- Relevance: T4T data point. Establishes the gate-count / feature
  premium of going from T2T to T4T (file system, ISO 7816 APDU layer).

### `[EM4423-DS]` — EM Microelectronic EM4423 (em|echo) datasheet

- Authors / publisher: EM Microelectronic-Marin SA.
- Title: *em|echo / EM4423 — Dual Frequency NFC Type 2 & EPC Gen2v2*.
- URL: https://www.emmicroelectronic.com/sites/default/files/products/datasheets/4423-ds.pdf
- Type: vendor datasheet.
- Accessibility: open access. WebFetch timeout but URL is referenced
  from EM Microelectronic's product page
  (https://www.emmicroelectronic.com/product/nfc-high-frequency-ics/em-echo-em4423)
  and from independent third-party mirrors (rfidlabel.com, shopnfc.com).
- Verification: 2026-05-03 — search confirmed protocol set (ISO/IEC
  14443-A / NFC Forum Type 2 + ISO/IEC 18000-6C / EPC Gen2v2 UHF),
  memory (2 kbit HF EEPROM + 512 bit UHF EEPROM).
- Relevance: included to demonstrate the *dual-protocol* end of the
  industry. Confirms that even sophisticated commercial designs lean
  on **T2T** for the HF/NFC-Forum side.

## Standards (de-jure)

### `[ISO14443-2]` — ISO/IEC 14443-2:2020

- Title: *Cards and security devices for personal identification —
  Contactless proximity objects — Part 2: Radio frequency power and
  signal interface*.
- URL: https://www.iso.org/standard/73599.html
- Type: ISO international standard.
- Accessibility: paywalled (CHF 178). Open-access *technical content*
  appears in derivative works (Wikipedia, app notes).
- Verification: 2026-05-03 — ISO catalog page reached; the substantive
  modulation rules (Type A: ASK 100 % + modified Miller from PCD;
  OOK + Manchester at fc/16 sub-carrier from PICC; Type B: ASK 10 % NRZ
  + BPSK NRZ-L) cross-checked against
  https://en.wikipedia.org/wiki/ISO/IEC_14443 (fetched 2026-05-03,
  matches NXP and ST datasheet wording).
- Relevance: anchor reference for §3.2 modulation/encoding choices and
  for the 14 mV-class load-modulation sideband requirement reported in
  the first-principles sister report.

### `[ISO14443-3]` — ISO/IEC 14443-3:2018

- Title: *... — Part 3: Initialization and anticollision*.
- URL: https://www.iso.org/standard/73598.html
- Type: ISO international standard.
- Accessibility: paywalled.
- Verification: 2026-05-03 — ISO catalog reached. Substantive content on
  REQA/ATQA/SELECT/SAK and 4/7/10-byte UID cascade levels was
  cross-checked against `[TI-SLOA136]` (cached PDF), Wikipedia
  ISO/IEC 14443 article, and `[NTAG21x-DS]` §8.5.1 (which references
  ISO 14443-3 cascade level 2 explicitly for its 7-byte UID).
- Relevance: anchor for anticollision discussion (§3.5). Read-only
  inspection of `[TI-SLOA136]` confirms the protocol is the same one
  every 14443A reader expects, regardless of whether multiple tags are
  actually present.

### `[ISO14443-4]` — ISO/IEC 14443-4:2018

- Title: *... — Part 4: Transmission protocol*.
- URL: https://www.iso.org/standard/73599.html (and 73600)
- Accessibility: paywalled.
- Verification: 2026-05-03 — ISO catalog confirmed. Substantive content
  cross-checked against `[Wikipedia-ISO14443]` and `[ST25TA02K-DS]`
  feature list (which calls out ISO 14443-4 / ISO 7816-4 directly).
- Relevance: defines the T-block half-duplex transport that T4T uses on
  top of 14443-3. We need this only if we move from T2T to T4T.

### `[ISO15693-3]` — ISO/IEC 15693-3:2019

- Title: *Cards and security devices for personal identification —
  Contactless vicinity objects — Part 3: Anticollision and transmission
  protocol*.
- URL: https://www.iso.org/standard/73602.html
- Accessibility: paywalled.
- Verification: 2026-05-03 — ISO catalog reached. Modulation/encoding
  details (1-of-256 PPM at 1.65 kbit/s, 1-of-4 PPM at 26.48 kbit/s,
  423.75 kHz / 484.28 kHz subcarriers) cross-checked against
  https://en.wikipedia.org/wiki/ISO/IEC_15693 (fetched 2026-05-03)
  and `[ST25TV02K-DS]`.
- Relevance: T5T baseline reference (long-range, low-bit-rate option).

### `[ISO7816-4]` — ISO/IEC 7816-4:2020

- Title: *Identification cards — Integrated circuit cards — Part 4:
  Organization, security and commands for interchange*.
- URL: https://www.iso.org/standard/77180.html
- Accessibility: paywalled.
- Verification: 2026-05-03 — ISO catalog confirmed. APDU command set
  (SELECT, READ_BINARY, UPDATE_BINARY, etc.) is referenced verbatim in
  `[ST25TA02K-DS]` and in NXP NTAG 4xx documentation.
- Relevance: only relevant if the design selects T4T. The fact that
  T4T requires a complete 7816-4 APDU parser is a major argument
  *against* T4T for our minimum-gate requirement.

### `[ISO18092]` — ISO/IEC 18092:2013 (NFCIP-1)

- Title: *Information technology — Telecommunications and information
  exchange between systems — Near Field Communication — Interface and
  Protocol (NFCIP-1)*.
- URL: https://www.iso.org/standard/56692.html
- Accessibility: paywalled.
- Verification: 2026-05-03 — ISO catalog reached. Defines NFC-A, NFC-F
  active/passive modes; cross-referenced from NFC Forum Tag Type 1/2
  specs.
- Relevance: bookkeeping reference; we are not implementing NFCIP-1
  active mode (target/initiator), only passive PICC mode.

## NFC Forum specifications (de-facto industry standards)

### `[NFCF-Specs]` — NFC Forum specifications portal

- URL: https://nfc-forum.org/build/specifications
- Type: standards portal.
- Accessibility: free login required to download individual PDFs;
  spec list itself is open.
- Verification: 2026-05-03 — page reached but content is mostly
  promotional; the spec PDFs require a member login. Useful spec
  designations and version numbers (Type 2 Tag Operation Specification,
  Technical Specification Type 2 Tag, Version 1.2 — last public
  revision; NDEF Specification 1.0; RTD spec 1.0) cross-checked from
  third-party summaries (zealtag.com, gototags.com, rfidcard.com).
- Relevance: the canonical NFC Forum tag-type taxonomy. We rely on it
  for §3.1 even though the underlying PDFs are members-only.

## NFC Forum Tag-Type / NDEF derivative documentation (open)

### `[Nordic-T2T]` — Nordic Semiconductor — *Type 2 Tag* documentation

- URL: https://docs.nordicsemi.com/bundle/com.nordic.infocenter.sdk5.v15.3.0/page/nfc_type2tag_format_dox.html
  (originally https://infocenter.nordicsemi.com/topic/com.nordic.infocenter.sdk5.v15.3.0/nfc_type2tag_format_dox.html, redirects to docs.nordicsemi.com).
- Type: vendor SDK documentation.
- Accessibility: open access; portal returns minimal markup to WebFetch
  (Zoomin viewer needs JS), but the content is captured in cached
  search-result snippets and an equivalent page exists at
  https://developer.nordicsemi.com/nRF_Connect_SDK/doc/2.4.3/nrfxlib/nfc/doc/type_2_tag.html
- Verification: 2026-05-03 — primary page reached (Nordic Zoomin viewer
  shell); content reproduced in search-result snippet which gives the
  byte-exact CC layout (E1/10/size/RW) and 992-byte data area cap.
- Relevance: open-access, vendor-neutral description of the T2T memory
  map and the 4-byte CC plus TLV blocks (NDEF Message TLV 0x03,
  Lock-Control 0x01, Memory-Control 0x02, Terminator 0xFE).

### `[Adafruit-NDEF]` — Adafruit — *NDEF and NFC Data Exchange Format*

- URL: https://learn.adafruit.com/adafruit-pn532-rfid-nfc/ndef
- Type: tutorial / reference page.
- Accessibility: open access.
- Verification: fetched 2026-05-03; full content captured. Confirms
  TNF values (Empty / Well-Known / MIME-Media / Absolute-URI / External
  / Unknown / Unchanged), URI prefix code table, and TLV blocks.
- Relevance: open-access secondary source for NDEF record-level
  encoding. Used to size the vCard NDEF wrapper overhead (~7 B for an
  SR=1 record with payload < 256 B).

## Anticollision & Type-A protocol (open-access)

### `[TI-SLOA136]` — TI application note SLOA136A

- Authors: Texas Instruments.
- Title: *ISO/IEC 14443A Anticollision*, application note SLOA136A.
- URL: https://www.ti.com/lit/an/sloa136a/sloa136a.pdf
- Type: vendor application note.
- Accessibility: open access.
- Verification: fetched 2026-05-03 via WebFetch; full PDF returned
  (165.5 kB) and cached at
  `references-cache/ti-sloa136-anticollision/sloa136.pdf` (170 kB
  on disk; existed prior to this run). Content excerpt confirms
  REQA/ATQA/SELECT cascade flow and 4/7/10-byte UID classes with the
  cascade-tag (CT) byte mechanism.
- Relevance: open-access proof that the 14443-3 anticollision protocol
  is unconditional — i.e. real-world readers expect REQA → ATQA →
  ANTICOLLISION → SELECT → SAK even when only one tag is present.
  Backstops the first-principles report's `AC-FIXED-UID` recommendation.

## Wikipedia background (rapid lookup; cross-checked elsewhere)

### `[Wikipedia-ISO14443]` — *ISO/IEC 14443* (Wikipedia article)

- URL: https://en.wikipedia.org/wiki/ISO/IEC_14443
- Type: encyclopedia.
- Accessibility: open.
- Verification: fetched 2026-05-03; content matches the modulation /
  bit-rate facts asserted in `[NTAG21x-DS]`, `[ISO14443-2]` and
  `[ST25TA02K-DS]`.
- Relevance: open-access cross-check on paywalled ISO content.

### `[Wikipedia-ISO15693]` — *ISO/IEC 15693* (Wikipedia article)

- URL: https://en.wikipedia.org/wiki/ISO/IEC_15693
- Type: encyclopedia.
- Accessibility: open.
- Verification: fetched 2026-05-03; agrees with `[ST25TV02K-DS]`.
- Relevance: open-access cross-check for T5T modulation parameters.

### `[Wikipedia-MIFARE]` — *MIFARE* (Wikipedia article)

- URL: https://en.wikipedia.org/wiki/MIFARE
- Type: encyclopedia.
- Accessibility: open.
- Verification: fetched 2026-05-03.
- Relevance: provides the per-product memory taxonomy (Ultralight 64 B,
  Classic 1K/4K, DESFire EV1/EV2 with AES) that we cross-reference in
  §3.1 against ChameleonMini's emulator list.

### `[Wikipedia-vCard]` — *vCard* (Wikipedia article)

- URL: https://en.wikipedia.org/wiki/VCard
- Type: encyclopedia.
- Accessibility: open.
- Verification: fetched 2026-05-03.
- Relevance: vCard 2.1 / 3.0 / 4.0 lineage and that NFC is an explicitly
  listed transport. Pointer to RFC 6350 for vCard 4.0 grammar.

### `[RFC6350]` — IETF RFC 6350 — *vCard Format Specification*

- Authors: S. Perreault.
- Title: *vCard Format Specification*, IETF RFC 6350, August 2011.
- URL: https://datatracker.ietf.org/doc/html/rfc6350
- Type: IETF Standards Track RFC.
- Accessibility: open.
- Verification: 2026-05-03 — IETF datatracker entry confirmed; minimal
  vCard 4.0 example (BEGIN/VERSION/FN/N/...END) reproduced from search
  hit and matches the RFC text.
- Relevance: the normative format for the vCard payload our tag
  returns.

## Phone reader-stack documentation

### `[Android-NfcAdapter]` — Android `android.nfc.NfcAdapter` API ref

- URL: https://developer.android.com/reference/android/nfc/NfcAdapter
- Type: vendor API documentation.
- Accessibility: open.
- Verification: fetched 2026-05-03; confirms `FLAG_READER_NFC_A`,
  `FLAG_READER_NFC_B`, `FLAG_READER_NFC_F`, `FLAG_READER_NFC_V` reader
  flags and the `enableReaderMode()` API. Tech-class list (NfcA, NfcB,
  NfcF, NfcV, IsoDep, MifareClassic, MifareUltralight, Ndef,
  NdefFormatable) reproduced verbatim.
- Relevance: the Android side of the phone-reader compatibility
  envelope. Confirms `Ndef` is a separate technology class (not
  implicit in `NfcA`), which means our T2T must publish a valid CC and
  TLV before Android exposes us as an `Ndef` tag.

### `[Apple-CoreNFC]` — Apple Developer — *Core NFC* framework

- URL: https://developer.apple.com/documentation/corenfc
- Type: vendor API documentation.
- Accessibility: open (rendered page contains schema; full content
  requires JS rendering, partially captured by WebFetch).
- Verification: fetched 2026-05-03. WebFetch returned summary of
  `NFCNDEFReaderSession` (iOS 11+) and `NFCTagReaderSession` (iOS 13+,
  iPhone XS / XR / 11+) tag-type support (`.iso14443`, `.iso15693`,
  `.iso18092` / FeliCa). Cross-checked against
  `[ST-iOS13-NFC-Blog]`.
- Relevance: iOS phone-reader compatibility side of R-h-7. Confirms T2T
  is read-only via `NFCNDEFReaderSession` from iOS 11 (iPhone 7+
  exposed the chip-level support, software API gated by 11.0).

### `[Apple-NFCISO15693Tag]` — Apple Developer — `NFCISO15693Tag`

- URL: https://developer.apple.com/documentation/corenfc/nfciso15693tag
- Type: vendor API documentation.
- Accessibility: open.
- Verification: 2026-05-03 — referenced from the Core NFC index;
  confirmed to exist via search results that quote class members and
  `NFCTagReaderSession` polling option `.iso15693`.
- Relevance: T5T support story on iOS (iOS 13+, iPhone 11+ for
  background tag reading via `NFCTagReaderSession`).

### `[ST-iOS13-NFC-Blog]` — STMicro blog — *Type-5 Custom Commands on
iOS 13*

- URL: https://blog.st.com/ios-13-nfc/
- Type: vendor blog (technical).
- Accessibility: open (CDN returned 473 to WebFetch but indexed by
  Google with usable preview).
- Verification: 2026-05-03 — search-result snippet confirms iOS 13
  added ISO 15693 single/multi-block read/write/lock/custom commands
  via `NFCTagReaderSession`; corroborates `[Apple-CoreNFC]`.
- Relevance: independent confirmation that T5T is fully phone-readable
  from iOS 13 onward (R-h-7 envelope argument).

## Open-source NFC tag-emulator references (RTL / firmware)

### `[ChameleonMini]` — Kasper & Oswald ChameleonMini firmware

- URL: https://github.com/emsec/ChameleonMini and supported-cards wiki:
  https://github.com/emsec/ChameleonMini/wiki/Supported-Cards-and--Codecs
- Type: open-source firmware (GPL).
- Accessibility: open.
- Verification: fetched 2026-05-03; supported codec list includes
  ISO 14443A (MIFARE Ultralight, Ultralight EV1, MIFARE Classic 1K/4K,
  NTAG, MIFARE DESFire low-bit-rate, MIFARE Plus low-bit-rate) and
  ISO 15693 (any tag).
- Relevance: existence proof that *all* of T1T/T2T/T4T (low-rate) and
  T5T can be emulated in firmware on an Atmel AVR-class microcontroller.
  Implies our 1.5–5 k-gate hardened-RTL budget is comfortable.

### `[Proxmark3]` — Iceman fork of Proxmark3 firmware

- URL: https://github.com/RfidResearchGroup/proxmark3
- Type: open-source firmware (GPLv3).
- Accessibility: open.
- Verification: fetched 2026-05-03; confirms HF emulation of
  ISO 14443A T2T/T4T, ISO 14443B, ISO 15693, FeliCa, plus full NDEF
  type 1/2/4a/4b round-trip.
- Relevance: reference *and* validation harness — we can use Proxmark3
  pre-tape-out to test the RTL behaviour against the same protocol code
  the security-research community trusts.

### `[libnfc]` — libnfc

- URL: https://github.com/nfc-tools/libnfc
- Type: open-source library (LGPL).
- Accessibility: open.
- Verification: fetched 2026-05-03.
- Relevance: PC-side reader/emulator library. Useful as a Linux-side
  pre-silicon test harness, although its tag-emulation is limited (it
  is primarily a PCD/reader stack).

### `[nfcpy]` — nfcpy library

- URL: https://nfcpy.readthedocs.io/en/latest/topics/get-started.html
- Type: open-source library (EUPL).
- Accessibility: open.
- Verification: fetched 2026-05-03; tag emulation supported only for
  Type 3 tags on Sony RC-S380 dongle.
- Relevance: useful for protocol-level investigation, *not* useful as a
  T2T emulator (limitation noted as a negative result in §7).

### `[NfcEmu]` — Nicolas Kruse — `0xee/NfcEmu`

- URL: https://github.com/0xee/NfcEmu
- Type: open-source FPGA project (no license declared).
- Accessibility: open.
- Verification: fetched 2026-05-03; confirms the codebase emulates
  ISO 14443A PICCs at 106 kbit/s on a Saxo-Q FPGA with a softcore 8051.
- Relevance: closest published *RTL* reference for an ISO 14443A tag.
  Confirms that the modem can be done in HDL as a small block; the 8051
  softcore in the published design handles the protocol layer, but our
  T2T target is dumb enough to be a pure FSM.

### `[Hackaday-PowerFreeNFC]` — *Power-Free NFC Tag Emulator*

- URL: https://hackaday.io/project/203582-power-free-nfc-tag-emulator
- Type: project log.
- Accessibility: open.
- Verification: fetched 2026-05-03; confirms ISO 14443A NTAG21x and
  MIFARE 1 + ISO 15693 emulation off the field at ~3.5 mA on a 27.12
  MHz CW32L010 MCU.
- Relevance: real-world data point that a *passive* (RF-powered) tag
  emulator is feasible at sub-15 mW total. Supports R-h-2.

### `[Adafruit-NDEF]` — see above (also used here).

## Comparative tag-product taxonomies (industry secondary)

### `[Tagstand-Cheatsheet]` — *NFC Chip Cheatsheet*

- URL: https://www.tagstand.com/nfc-chip-cheatsheet/
- Type: vendor knowledge-base.
- Accessibility: open.
- Verification: fetched 2026-05-03.
- Relevance: industry-curated comparison spanning NTAG 210µ → 424 DNA,
  ST25TA/TV, MIFARE Ultralight C / EV1 / DESFire EV1, ICODE SLIX(1/2/-L/-S),
  FeliCa Lite-S. Used in §3.1 to ensure no major commercial chip was
  silently omitted.

### `[ZealTag-TagTypes]` — ZealTag — *NFC Tag Types 1-5: Ultimate Guide*

- URL: https://zealtag.com/blog/nfc-tag-types-guide/
- Type: vendor blog.
- Accessibility: open.
- Verification: fetched 2026-05-03; cross-checked against
  `[Wikipedia-ISO14443]` and `[Wikipedia-ISO15693]`.
- Relevance: most concise vendor-neutral table mapping each NFC Forum
  tag type to the originating chip family (Topaz / NTAG / FeliCa /
  DESFire / ICODE).

### `[RFIDCard-NTAG]` — *Find Your Perfect NFC Match: Guide to NXP NTAG®
213/215/216*

- URL: https://www.rfidcard.com/find-your-perfect-nfc-match-guide-to-nxp-ntag-213-215-216/
- Type: vendor blog.
- Accessibility: open.
- Verification: fetched 2026-05-03; numbers (144/504/888 user bytes,
  10 yr retention, 100k write cycles, 50 pF, 100 mm range) match
  `[NTAG21x-DS]`.
- Relevance: open-access mirror of the NTAG21x feature data because the
  primary PDF times out from CDN.

### `[RFIDCard-NTAG-NDEF]` — *NFC Card Types Explained: NTAG213/215/216
vs NTAG424 DNA*

- URL: https://www.rfidcard.com/nfc-card-types-explained-how-to-choose-between-ntag213-ntag215-ntag216-and-ntag424-dna/
- Type: vendor blog.
- Accessibility: open.
- Verification: fetched 2026-05-03; provides per-variant max NDEF
  message size (NTAG213 137 B, NTAG215 496 B, NTAG216 868 B).
- Relevance: cross-checks the user-memory-vs-NDEF overhead in
  `[NTAG21x-DS]` and `[Nordic-T2T]`.

### `[NXP-AN13089]` — NXP application note AN13089 — *NTAG 21x Features
and Hints*

- URL: https://www.puntoflotante.net/AN13089.pdf
  (original on docstore.nxp.com requires login)
- Authors / publisher: NXP Semiconductors.
- Date: Rev. 1.0, 5 May 2021.
- Type: vendor application note.
- Accessibility: open via mirror; primary login-walled.
- Verification: 2026-05-03 — search hits confirm document title and
  that it is the modern successor to AN11305.
- Relevance: documents per-variant CC values
  (NTAG213 = `E1 10 12 00`, NTAG215 = `E1 10 3E 00`, NTAG216 = `E1 10 6D 00`).
  These values are the format we replicate.

## Hardware-platform / context

### `[Mikroe-NFC4]` — *NFC Tag 4 Click* product page

- URL: https://www.mikroe.com/nfc-tag-4-click
- Type: vendor product page.
- Accessibility: open.
- Verification: 2026-05-03 — surfaced via search; corroborates ST25TA
  T4T usage in commercial dev kits.
- Relevance: bookkeeping; shows commercial footprint of T4T-A tags
  (counter-evidence to the T4T-only-for-banking caricature).

---

## Coverage of the references the per-item README required

| Required reference family            | Covered? | IDs                                                                |
|--------------------------------------|----------|--------------------------------------------------------------------|
| NXP NTAG datasheets                  | ✓        | `[NTAG21x-DS]`, `[NXP-AN13089]`                                    |
| ST25TA/TV/TN datasheets              | ✓        | `[ST25TA02K-DS]`, `[ST25TV02K-DS]`, `[ST25TN512-DS]`               |
| EM4423 datasheet                     | ✓        | `[EM4423-DS]`                                                      |
| Toshiba TB1106GBG                    | partial  | not found in vendor channel; see §7 negative results in `report.md` |
| ISO 14443-2/3/4                      | ✓        | `[ISO14443-2]`, `[ISO14443-3]`, `[ISO14443-4]`                     |
| ISO 7816-4                           | ✓        | `[ISO7816-4]`                                                      |
| ISO 18092                            | ✓        | `[ISO18092]`                                                       |
| NFC Forum T1/T2/T3/T4/T5 specs       | ✓        | `[NFCF-Specs]` (members-only), with open mirrors `[Nordic-T2T]`    |
| NDEF spec                            | ✓        | via `[NFCF-Specs]`, `[Adafruit-NDEF]`, `[Nordic-T2T]`              |
| vCard 2.1 / 3.0 / 4.0                | ✓        | `[Wikipedia-vCard]`, `[RFC6350]`                                   |
| AN10787 / AN11305 / AN11340          | partial  | succeeded by `[NXP-AN13089]` in NXP's current portfolio            |
| ST AN4910                            | partial  | not located in publicly indexed channel; flagged as open question  |
| Proxmark3, ChameleonMini, libnfc, NFCpy | ✓     | `[Proxmark3]`, `[ChameleonMini]`, `[libnfc]`, `[nfcpy]`, `[NfcEmu]`, `[Hackaday-PowerFreeNFC]` |
| Android NfcAdapter, iOS Core NFC     | ✓        | `[Android-NfcAdapter]`, `[Apple-CoreNFC]`, `[Apple-NFCISO15693Tag]`, `[ST-iOS13-NFC-Blog]` |
