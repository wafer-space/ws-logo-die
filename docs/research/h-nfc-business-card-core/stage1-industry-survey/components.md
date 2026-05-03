---
item: h
item_name: nfc-business-card-core
stage: 1
angle: industry-survey
researcher: stage1-industry-survey-1
status: draft
last-updated: 2026-05-03
---

# Sub-block / building-block breakdown — industry-survey angle

This file decomposes each surveyed tag-protocol architecture into the
sub-blocks an implementation would need. Citation tags `[X]` resolve
in `references.md`. References to "first-principles §5.X" point to the
parallel sister report.

## Common sub-block inventory (used by every NFC PICC)

| Block                       | Purpose                                                | Notes |
|-----------------------------|--------------------------------------------------------|-------|
| Antenna LC tank             | Couples to PCD coil, resonates at fc = 13.56 MHz       | Item (b)'s tuning-cap bank lives here. Industry norm: 50 pF on-die for credit-card antenna `[NTAG21x-DS]`, `[ST25TA02K-DS]`. ST25TV02K offers selectable 23 pF / 99.7 pF for vicinity-class antennas `[ST25TV02K-DS]`. |
| Voltage limiter / clamp     | Protects internal nodes from > 30 V open-circuit swing | Item (b) again. NTAG21x uses an on-die clamp (datasheet does not name a number). |
| Rectifier                   | DC harvested rail                                      | Item (b). Industry uses synchronous cross-coupled NMOS/PMOS bridge. |
| POR / field-detect          | Asserts reset until rail rises                         | All vendors. Carrier-detect is a "RF on/off" comparator on the rectified envelope. |
| **Carrier-derived clock**   | Clean fc / fc/2 / fc/16 / fc/32 / fc/64 derivatives    | **Universal in industry — no commercial passive NFC IC uses an internal RC oscillator for the protocol engine** (cross-checked across `[NTAG21x-DS]`, `[ST25TN512-DS]`, `[ST25TV02K-DS]`, `[ST25TA02K-DS]`, `[EM4423-DS]`). Confirms `CLK-CARRIER` (first-principles §5.7). |
| Envelope detector           | OOK demodulation of PCD ASK                            | Industry standard analog block — small NMOS diode + LP cap. |
| Demod sampler & frame timer | Samples envelope at 4 × bit rate; frames against pause width | Sub-µs comparator and a few flip-flops. |
| Modulator switch (PICC → PCD) | Shunts antenna to ground via series resistor or FET to load-modulate | First-principles §5.1 sized this at R_mod ≈ 2 kΩ. |
| Bit decoder (PCD-side coding) | Decodes Modified Miller (T1T/T2T/T4T-A) or NRZ (T4T-B) or 1-of-4 / 1-of-256 PPM (T5T) | Different per architecture (see below). |
| Bit encoder (PICC-side coding) | Manchester (T2T/T4T-A 106), BPSK (T4T high-rate, T4T-B), 423.75 kHz / 484.28 kHz subcarrier OOK or FSK (T5T) | Different per architecture. |
| CRC engine                  | 16-bit CRC-A (T2T/T4T-A), CRC-B (T4T-B), CRC-15693 (T5T) | All polynomials documented in respective standards. ~80 gates each. |
| FSM / protocol engine       | REQA → ATQA → SELECT → READ ...                        | The "digital baseband" we need to design. |
| Payload memory              | NDEF + CC + lock + UID                                 | EEPROM in commercial chips; mask-ROM for our brief. |
| Anticollision register file | Holds UID for SELECT cascade comparison                | ~7 bytes for 7-byte UID = 56 flip-flops. |
| FDT_PICC timer              | 1172/fc = 86.4 µs response window                       | 11-bit counter against fc. |

## A1. T1T-specific blocks

- Topaz/Jewel command parser (RID, RALL, READ, WRITEE, WRITENE, RSEG,
  READ8, WRITEE8, WRITENE8). About 8 commands. Slightly fewer than
  T2T but shares the same 14443A modem.
- 4-byte block addressing (cf. T2T's 4-byte page addressing).
- Read-only locking via `lock` block.
- *Optional* Type-1 dynamic memory model (DMEM beyond 96 B).

## A2. T2T-specific blocks (recommended baseline)

- Carrier-derived clocking tree:
  - **fc** = 13.56 MHz (top-level latch).
  - **fc/16** = 847.5 kHz subcarrier — used as the modulator carrier
    `[NTAG21x-DS]` §2; cross-checked from `[Wikipedia-ISO14443]`.
  - **fc/128** = ~106 kHz — used as the bit-clock for the Manchester
    encoder (each bit period = 8 subcarrier cycles per the
    14443-2 spec).
- Modified-Miller decoder (PCD → PICC): pause-width discriminator and
  3-state decoder (logic-1 / logic-0 / start-of-comm).
- Manchester encoder (PICC → PCD): drives the modulator switch in
  half-bit slots gated by the 847.5 kHz subcarrier.
- CRC-A engine: 16-bit shift-XOR, polynomial 0x1021, init 0x6363.
  Identical to ISO 14443A and used by NTAG21x and every other
  T2T `[ISO14443-3]`.
- Command parser for T2T baseline (read-only): handle `READ` (0x30)
  with a 4-byte page argument; reject everything else with NAK.
  `WRITE` (0xA2) and `COMPATIBILITY_WRITE` (0xA0) optional. Other
  NTAG21x extensions (`FAST_READ` 0x3A, `READ_CNT` 0x39, `PWD_AUTH`
  0x1B, `READ_SIG` 0x3C, `GET_VERSION` 0x60) are NTAG-vendor
  proprietary — phones don't *require* them, but many reader apps
  *probe* with `GET_VERSION` to identify the chip; safest to respond
  with a short NAK so the reader falls back to plain T2T parsing.
- Memory map (per `[NTAG21x-DS]` §8.5, Figs 5/6/7):
  - Page 00: SN0 (manufacturer ID, 04h for NXP), SN1, SN2, BCC0
  - Page 01: SN3..SN6 (rest of UID)
  - Page 02: BCC1, internal byte, lock bytes
  - Page 03: 4-byte capability container (CC)
  - Pages 04..N: user data area (TLV blocks)
  - Trailing pages: dynamic lock bytes, CFG0/CFG1, PWD, PACK
  - Our v2 chip: **mask-ROM exact reproduction of pages 0–3 + N user
    pages + dynamic-lock byte at the right offset**. The dynamic lock
    bytes can be hard-wired to the "all-locked, read-only" pattern
    so that real readers see a tag they can read but never write.
- Capability container values per variant (cross-checked
  `[NTAG21x-DS]` and `[NXP-AN13089]`):
  - NTAG213: `E1 10 12 00`  → 0x12 × 8 = 144 bytes data
  - NTAG215: `E1 10 3E 00`  → 0x3E × 8 = 496 bytes data
  - NTAG216: `E1 10 6D 00`  → 0x6D × 8 = 872 bytes data
  - For our minimum-vCard, `E1 10 06 00` (48 B) suffices — matching
    the minimum profile NDEF capability size — but we should plan
    payload sized to fit comfortably (see vCard NDEF sizing in
    `report.md` §3.6).

## A3. T4T-A-specific blocks (optional escalation)

In addition to the common stack:

- ISO 14443-4 T-block transport: PCB / RATS / ATS, I-block / R-block /
  S-block framing, NAD / CID handling. ~3× more state than T2T.
- ISO 7816-4 APDU parser + dispatcher: SELECT (with AID, file-id, MF,
  EF), READ_BINARY, UPDATE_BINARY, GET_RESPONSE.
- Two virtual files (CC file 0xE103, NDEF file 0xE104) with their own
  length prefixes.
- Bit-rate negotiation logic (106 / 212 / 424 / 848 kbit/s) — implies
  PLL or programmable divider.

The first-principles report estimates this at ~2× T2T gate count
(3 k gates hand-tight, 7 k synthesised); confirmed in spirit by
ChameleonMini's DESFire support being marked "low bit rate only" —
even on a 32 MHz Atmel AVR the higher rates are tight `[ChameleonMini]`.

## A6. T5T-specific blocks (alternate path)

- Carrier-derived clocking tree:
  - **fc/32** = 423.75 kHz — used as the load-modulation subcarrier
    (one path) `[Wikipedia-ISO15693]`.
  - **fc/28** ≈ 484.28 kHz — second FSK tone (optional).
- 1-of-256 / 1-of-4 PPM decoder: counts pulse positions in a 256- or
  4-slot envelope window. *Different state structure to Manchester /
  Miller*; no subcarrier in the PCD direction.
- ISO 15693 INVENTORY / SELECT / READ_SINGLE_BLOCK / READ_MULTIPLE_BLOCKS
  / WRITE_SINGLE_BLOCK / LOCK_BLOCK command set.
- 64-bit UID register file (E0 manufacturer + 7-byte UID
  `[ST25TV02K-DS]`).
- CRC-15693 (poly 0x1021, init 0xFFFF, complemented at end).
- **No bit-frame anticollision** — uses a slot-counter scheme instead.
- Per ISO 15693, the maximum bit rate is **53 kbit/s** (one source) or
  **26.48 kbit/s** (1-of-4 PPM standard high-rate); FSK return of 53
  kbit/s requires a vendor-extended fast mode.
- Trade-off: simpler modem (no Miller decoder + no Manchester encoder),
  *but* loses iOS 11/12 readership.

## D. Payload-storage blocks (commercial vs ours)

| Block                | Industry default                                      | Our v2 chip (recommended) |
|----------------------|-------------------------------------------------------|---------------------------|
| Manufacturer UID     | OTP at test (NTAG21x §8.5.1, EM4423 §UID register)    | Mask-ROM (or eFuse if (j) ships) — wafer.space manufacturer ID |
| BCC0/BCC1 check bytes | Computed at OTP burn time                            | Computed at synthesis time from chosen UID |
| Capability Container | OTP at test                                           | Mask-ROM constants (`E1 10 12 00` style) |
| Lock bytes / CFG     | EEPROM, user-writable                                  | Mask-ROM constants (locked) |
| User memory (NDEF)   | EEPROM, customer-writable                             | Mask-ROM (`PAY-MASKROM` from first-principles §3.3) — vCard hard-baked at synthesis. |
| Originality signature | OTP, NXP-signed ECC                                   | **Out of scope** for our brief (no ECC engine) |

## E. Modulator drive stage

- Industry topology: a single NMOS shunting either the antenna node to
  ground via a series load resistor (typical R_mod = 1.8–2 kΩ), or a
  pair of FETs across the LC tank for differential antennas.
- First-principles §5.2 sized R_mod = 2 kΩ → ~0.56 mW average, well
  inside the harvester budget. **R_mod ≈ 100 Ω**, the "aggressive
  shunt" extreme, is cited in §5.2 as 10× over budget; cross-checked
  against `[Hackaday-PowerFreeNFC]` (which runs at ~~3.5 mA total
  ≈ 11.5 mW from a 15 mW field~~ — see correction note below).
  > **Correction 2026-05-04** (reviewer-1): the Hackaday project
  > page actually says **"4.5 mA budget from 3.3 V/15 mW reader;
  > 3.5 mA is the MCU's stand-alone draw"** — the prior text
  > conflated the two figures. The architectural conclusion
  > ("a few-mW modulator allocation is the right order of
  > magnitude") survives with ≫10× headroom either way.
- Drive logic: AND the 847.5 kHz subcarrier with the Manchester bit
  clock; drive the modulator gate when both are 1. The combinational
  cell is ~3 gates.

## F. Brown-out / field-loss handling

- Industry approach: hard-reset the entire baseband when V_rail drops
  below the brown-out threshold (≈ 0.7 × V_LDO). Half-completed frames
  are simply lost; the reader retries. NTAG21x §8.4.6 documents the
  HALT state but the *unintentional* field-loss behaviour is not
  specified — implementations rely on reader retry.
- Our chip should mirror this: a single brown-out comparator + reset
  fan-out to all flip-flops in the protocol engine.

## G. Validation & test infrastructure

- **Pre-silicon RTL test harness:** drive the modem with a synthesised
  PCD signal generated from `[Proxmark3]`-derived golden traces; check
  the modulator output on the PICC side bit-for-bit against
  ChameleonMini and NfcEmu emulator outputs. Cocotb test framework
  recommended (per item (h) §verify in `[TODO.md]`).
- **Phone-bring-up matrix (post-silicon):** Android and iOS readers as
  enumerated in `report.md` §3.7.
- **Reference reader chips for benchtop validation:** TI TRF7970A, NXP
  CLRC663 / PN5180, ST CR95HF / ST25R3911B, Identive ACR122U.

## H. Sub-block sizes — industry data points cross-referencing first-principles

Where the industry survey *can* corroborate the first-principles
gate counts (§5.3):

- Modified-Miller decoder ~ 60 gates: matches the size of the bit-
  decoder in NfcEmu's VHDL trace (single FSM with ~5 states + a
  counter).
- CRC-A ~ 80 gates: standard 16-bit shift-XOR; identical in every
  industry reference (ChameleonMini, Proxmark3, NfcEmu all use the
  same loop body).
- ROM 64–256 B for vCard: trivially in mask-ROM area (≈ 1 std-cell
  height per byte at GF180MCU densities).

Industry data does *not* contradict the first-principles report's
"~1500–2000 gates hand-tight, ~3500–5000 synthesised" baseline for a
read-only T2T.
