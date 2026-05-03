# References (item h, Stage 1 first-principles)

This is a first-principles report. References here are anchors for
*standards-defined values* (frequencies, FDT_PICC, modulation specs)
and platform-API claims (§5.9 Android/iOS support). Verification
status: `unverified-pending-orchestrator` for all entries — Stage-1
first-principles agent did not have web access; orchestrator's
reviewer must verify URLs and flag any that fail.

## R1 — ISO/IEC 14443-2:2020

- **Citation:** ISO/IEC 14443-2:2020 *Cards and security devices for
  personal identification — Contactless proximity objects — Part 2:
  Radio frequency power and signal interface.*
- **Type:** International standard, paywalled.
- **Verification:** unverified-pending-orchestrator.
- **Local cache:** `references-cache/R1-iso-14443-2/iso-14443-2-2020-summary.md`
  (paraphrase only — full text under copyright).
- **Relevance:** Source of carrier frequency 13.56 MHz, subcarrier
  847.5 kHz (= fc/16), modulation depth requirement (§8.2.1.2),
  PCD field-strength operating envelope H_min = 1.5 A/m to
  H_max = 7.5 A/m. Used in §5.1 of report.md.

## R2 — ISO/IEC 14443-3:2018

- **Citation:** ISO/IEC 14443-3:2018 *Part 3: Initialization and
  anticollision.*
- **Verification:** unverified-pending-orchestrator.
- **Relevance:** REQA / WUPA / ATQA framing; anticollision cascade
  levels (4-byte vs 7-byte UID); FDT_PICC = 1172 / fc spec. Used
  in §5.5 of report.md.

## R3 — ISO/IEC 14443-4:2018

- **Citation:** ISO/IEC 14443-4:2018 *Part 4: Transmission
  protocol.*
- **Relevance:** Block protocol (I/R/S blocks, PPS) for Type-4
  tag emulation. Used in §4.2 component breakdown for `T4T`
  (~600-gate estimate).

## R4 — ISO/IEC 15693-3:2019

- **Relevance:** 1-of-256 PPM and 1-of-4 PPM modulation; CRC-15693
  polynomial; Inventory / Read Single Block frame formats. Used
  in §3.2 and §5.3 for `T5T`.

## R5 — NFC Forum Type 2 Tag Operation Specification, T2TOP 1.2 (2017)

- **Relevance:** Capability container format at block 3; TLV NDEF
  wrapping; lock-byte semantics; static memory map for `T2T`
  payload. Used in §4.2 and §5.4.

## R6 — NFC Forum Type 1 / 4 / 5 Tag Operation Specifications

- **Type:** Industry consortium specs.
- **Relevance:** Per-protocol command sets and NDEF mappings, used
  in §4.2 sub-block breakdowns and §5.3 gate-count estimates.

## R7 — Android `NfcAdapter` / `Ndef` / `IsoDep` developer documentation

- **URL:** https://developer.android.com/reference/android/nfc/package-summary
- **Relevance:** API tier support claims in §5.9; in particular
  that `NfcAdapter.enableReaderMode()` requires a successful
  SELECT (referenced in §7.1 negative result).

## R8 — Apple Core NFC `NFCNDEFReaderSession` documentation

- **URL:** https://developer.apple.com/documentation/corenfc/nfcndefreadersession
- **Relevance:** iOS support tiers referenced in §5.9 (NDEF read
  iOS 11+, full ISO 7816 / NfcV iOS 13+ / iOS 17+).

## R9 — vCard format specifications

- **Citations:**
  - Howes et al., *vCard MIME Directory Profile*, RFC 2426 (vCard
    3.0), 1998.
  - Perreault, *vCard Format Specification*, RFC 6350 (vCard 4.0),
    2011.
  - Internet Mail Consortium *vCard 2.1: A versitcard
    specification*, 1996.
- **Relevance:** Byte-counts in §5.4 derived from these grammars.

## R10 — Wheeler / Mohan inductance formulas for printed coils

- **Citations:**
  - Mohan et al., *Simple accurate expressions for planar spiral
    inductances*, IEEE JSSC 34(10), 1999.
  - Wheeler, *Simple inductance formulas for radio coils*,
    Proceedings of the IRE, 1928.
- **Relevance:** Sanity-check L_ant ≈ 2.5 µH for a 4-turn 80×50 mm
  loop in §5.1.

## R11 — NXP NTAG21x family datasheet

- **Citation:** NXP Semiconductors *NTAG213/215/216 NFC Forum
  Type 2 Tag IC datasheet*, Rev 3.2, 2019.
- **Local cache:** Available at
  `docs/research/h-nfc-business-card-core/references-cache/ntag21x-datasheet/NTAG213_215_216_rev3.2.pdf`
  (committed).
- **Relevance:** Production-realistic R_mod values, modulator power
  dissipation numbers, ATQA / SAK constants, 4-byte vs 7-byte UID
  conventions used as cross-checks against the first-principles
  derivations in §5.

## R12 — Project source documents

- **Citations:**
  - `TODO.md` (current branch HEAD).
  - `docs/research/METHODOLOGY.md`.
  - `docs/research/h-nfc-business-card-core/README.md`.
- **Verification:** verified — read directly during preparation.
- **Relevance:** Source of every R-h-* requirement in §2; physical
  antenna parameters in §5.1; cross-block dependency map.

> **Reviewer task:** every entry above marked `unverified-pending-
> orchestrator` must be checked by the orchestrator's reviewer
> before this report exits draft. URLs must be confirmed to
> resolve; paywalled standards must be cross-checked against
> authoritative summaries.
