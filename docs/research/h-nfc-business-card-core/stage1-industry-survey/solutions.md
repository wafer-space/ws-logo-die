---
item: h
item_name: nfc-business-card-core
stage: 1
angle: industry-survey
researcher: stage1-industry-survey-1
status: draft
last-updated: 2026-05-03
---

# Solutions surveyed — industry data points

This file captures the architectures / topologies surveyed in the
industry. It is referenced from `report.md` §3 (solution-space map).
Citation tags `[X]` resolve in `references.md`.

## A. Tag-protocol architectures

### A1. ISO 14443-3 Type A + NFC Forum Type 1 Tag (T1T)

- **Originating chip family:** Innovision Topaz / Broadcom BCM20203
  ("Jewel"). Largely abandoned; few or no current new tape-outs.
- **Reader-to-tag modulation:** ASK 100 % + Modified Miller; **tag-to-
  reader modulation:** OOK Manchester at 847.5 kHz subcarrier.
- **Bit rate:** 106 kbit/s only.
- **Memory range:** 96 B (Topaz 96) to ~2 kB.
- **Reference designs:** Topaz datasheet (legacy); supported by
  Proxmark3 `[Proxmark3]`, ChameleonMini `[ChameleonMini]` (read-only).
- **Phone support:** Android since API 10 via `NfcA` + `Ndef`;
  iOS supports T1T NDEF read since iOS 11 `[Apple-CoreNFC]`. Becoming
  rare in the wild — most production phones still parse it because
  the NFC controllers (Broadcom, NXP PN-class) historically supported
  it.

### A2. ISO 14443-3 Type A + NFC Forum Type 2 Tag (T2T)

- **Originating chip family:** NXP MIFARE Ultralight (the original);
  modern variants are NXP NTAG203/210/212/213/215/216/424 DNA, ST
  ST25TN, EM Microelectronic em|echo (EM4423 HF side), Infineon
  my-d move (SLE66 lineage). Listed in `[Tagstand-Cheatsheet]`,
  `[ZealTag-TagTypes]`.
- **Reader-to-tag modulation:** ASK 100 % + Modified Miller; **tag-to-
  reader modulation:** OOK Manchester at 847.5 kHz subcarrier
  (= fc/16) `[Wikipedia-ISO14443]`, `[NTAG21x-DS]`.
- **Bit rate:** 106 kbit/s only (T2T spec does not enable the higher
  rates).
- **Memory range:** 48 B (MIFARE Ultralight original) → 924 B
  (NTAG216 total) `[NTAG21x-DS]` §2.1; user payloads:
    - NTAG213: 144 user / 137 NDEF max `[RFIDCard-NTAG-NDEF]`
    - NTAG215: 504 user / 496 NDEF max
    - NTAG216: 888 user / 868 NDEF max
    - ST25TN512: 64 user (208 B incl. management) `[ST25TN512-DS]`
    - ST25TN01K: 160 user
- **Anticollision UID:** typically 7-byte (cascade level 2)
  `[NTAG21x-DS]` §8.5.1; ISO 14443-3 also allows 4-byte single (rare on
  modern chips) and 10-byte triple (extremely rare).
- **Tuning capacitance (on-die):** NTAG213/215/216 = **50 pF**
  `[NTAG21x-DS]` §2; ST25TA02K = **50 pF**, ST25TV02K = **23 pF or
  99.7 pF** (variant-selectable) `[ST25TV02K-DS]`. Establishes the
  in-class norm for a credit-card-sized antenna.
- **Reference designs (open RTL or firmware):** ChameleonMini
  `[ChameleonMini]` (full T2T including NTAG); Proxmark3 `[Proxmark3]`
  (full); NfcEmu `[NfcEmu]` (FPGA, generic 14443A PICC at 106 kbit/s);
  Hackaday "Power-Free NFC Tag Emulator" `[Hackaday-PowerFreeNFC]`
  (passive RF-powered, NTAG21x and ISO 15693 emulation, 27.12 MHz
  CW32L010 MCU, ≈ 3.5 mA peak from a 3.3 V/15 mW NFC field).
- **Commands:** the T2T command set is small —
  `READ` (0x30), `WRITE` (0xA2), `SECTOR_SELECT` (0xC2 — only on
  NTAG-I²C and DESFire EV1, not on plain NTAG21x), and the NTAG21x-
  specific `FAST_READ` (0x3A), `READ_CNT` (0x39), `PWD_AUTH` (0x1B),
  `READ_SIG` (0x3C), `GET_VERSION` (0x60), `COMPATIBILITY_WRITE` (0xA0)
  `[NXP-AN13089]`. A read-only baseline can implement just `READ` (and
  ignore unknown commands → NACK).
- **Phone support:** **the most universally supported tag type** —
  Android `NfcA` + `Ndef` since API 10 `[Android-NfcAdapter]`; iOS
  NDEF read since iOS 11 `[Apple-CoreNFC]`; iOS write since 13. NTAG21x
  is the *de-facto industry baseline* for tap-to-share applications
  including mobile-phone "business card" tags (so listed by NXP in
  `[NTAG21x-DS]` §3).

### A3. ISO 14443-4 Type A + NFC Forum Type 4A Tag (T4T-A)

- **Originating chip family:** NXP MIFARE DESFire EV1/EV2/EV3, NTAG 4xx
  (Lite/DNA), ST ST25TA, ST25TA-E, Infineon SLE 77 (Java Card),
  Samsung Tectiles (limited).
- **Modulation:** Same as T2T at 106 kbit/s; T4T can additionally
  negotiate up to 848 kbit/s via the ATS (Answer To Select).
- **Memory range:** 256 B (ST25TA02K `[ST25TA02K-DS]`) → 64 kB
  (ST25TA64K, MIFARE DESFire 4 K/8 K).
- **Tuning cap:** ST25TA02K = 50 pF `[ST25TA02K-DS]`.
- **Protocol stack:** runs ISO 7816-4 SELECT / READ_BINARY /
  UPDATE_BINARY APDUs over the ISO 14443-4 T-block transport.
  Implementations need a complete CC file + NDEF file abstraction.
- **Reference designs:** Proxmark3 (full T4T A and B), ChameleonMini
  (low-bit-rate DESFire only), all major commercial dev kits (TI
  TRF7970A, NXP CLRC663, ST CR95HF).
- **Phone support:** Android `IsoDep` + `Ndef` since API 10; iOS NDEF
  since iOS 11, full T4T APDU access since iOS 13 `[Apple-CoreNFC]`.
- **Why not the default for our brief:** roughly 2× the gate count of
  T2T, no advantage in phone compatibility, and the only practical
  benefit (>1 kB payloads) only matters if we want embedded photos in
  the vCard (which the first-principles report estimates at 300+
  bytes plus photo overhead).

### A4. ISO 14443-3/4 Type B + NFC Forum Type 4B Tag (T4T-B)

- **Originating chip family:** ATQB-class chips — older ePassports,
  some ST25 variants, Atmel ATA5567/ATA5577 (legacy).
- **Modulation:** ASK 10 % NRZ from PCD; BPSK NRZ-L from PICC at
  847.5 kHz subcarrier `[Wikipedia-ISO14443]`.
- **Bit rate:** 106 / 212 / 424 / 848 kbit/s.
- **Reference designs:** Proxmark3 (full); ChameleonMini ISO 14443B
  codec (limited application layer).
- **Phone support:** **patchier**. Many flagship-class Android phones
  ship with NFC controllers (Broadcom in older Pixels and Galaxy
  models; some MTK NFC IPs) where 14443B was disabled or unstable in
  early firmware revisions (`AC-NONE`-like report from
  flipperdevices/flipperzero-firmware issue tracker; first-principles
  sister report §7.2).
- **Why not the default:** strictly fewer compatible phones than
  T4T-A, no functional advantage for our brief.

### A5. JIS X 6319-4 + NFC Forum Type 3 Tag (T3T / FeliCa)

- **Originating chip family:** Sony FeliCa Lite-S, FeliCa Standard.
- **Modulation:** Manchester at 212 / 424 kbit/s — different physical
  layer to 14443.
- **Reference designs:** nfcpy `[nfcpy]` is the canonical open
  implementation (it was *built* around T3T because Sony RC-S380 is
  the only USB dongle that supports T3T emulation).
- **Phone support:** universal in Japan; Android `NfcF` since API 10
  on phones with FeliCa-enabled NFC controllers; iOS supports T3T
  since iOS 13 globally (every iPhone XS and later includes the
  FeliCa codec to support Suica/Pasmo). Outside Japan/Asia, "works
  but few apps" — many users will never have used a FeliCa tag.
- **Why not the default:** for a worldwide-shipped business card we
  gain nothing over T2T and the protocol is foreign to most non-JP
  developers; the ROM/HDL would need a different baseband entirely
  (Manchester with no subcarrier).

### A6. ISO/IEC 15693 + NFC Forum Type 5 Tag (T5T / NFC-V)

- **Originating chip family:** NXP ICODE SLI / SLIX / SLIX2 / SLIX-L /
  SLIX-S, ST ST25DV / ST25TV / LRI series, EM Microelectronic
  EM4233/EM4233 SLIC.
- **Modulation:** ASK (10 % or 100 %) + 1-of-256 PPM (1.65 kbit/s) or
  1-of-4 PPM (26.48 kbit/s) from PCD; load modulation via 423.75 kHz
  (ASK) or 423.75/484.28 kHz (FSK) subcarriers from VICC. Significantly
  *slower* than 14443A and *no Miller decoder needed*
  `[Wikipedia-ISO15693]`, `[ST25TV02K-DS]`.
- **Read range:** vicinity standard — up to 1–1.5 m with industrial
  readers, but **only 4–5 cm with a phone** because phone antennas are
  small and the protocol is tuned for vicinity-class antennas
  `[ZealTag-TagTypes]`.
- **Memory range:** 256 B → 4 kB (ST25TV04K, ICODE SLIX2).
- **Reference designs:** Proxmark3 (full), ChameleonMini (any
  ISO 15693 tag, full).
- **Phone support:** Android `NfcV` since API 10. **iOS T5T NDEF read
  arrived in iOS 13** with the rest of the `NFCTagReaderSession` API
  `[ST-iOS13-NFC-Blog]`, `[Apple-NFCISO15693Tag]`. iOS 11/12 NDEF
  reader (`NFCNDEFReaderSession`) **does not** see T5T tags. So iOS
  compatibility is "good on iPhone XS / XR onwards, not on iPhone 7
  through X".
- **Why a candidate at all:** the modem is *much simpler* — no Miller
  decoder, no fc/16 subcarrier generator (generates 423.75 kHz =
  fc/32 instead, and only when answering), and the Manchester /
  Miller asymmetry of 14443A vanishes. Gate count *can* be lower than
  T2T, at the cost of dropping iOS-11-and-12 compatibility.

### A7. Proprietary / non-standard "raw" tag

- **Originating chip family:** none in the NFC space; included as a
  methodological lower bound (rule from the first-principles sister
  report).
- **Phone support:** none.
- **Why included:** we must enumerate the spectrum extremes. This sets
  the ~200-gate floor.

## B. Modulation / encoding combinations actually shipping

(See table in `report.md` §3.2 for the comparison row.)

| ID            | PCD → PICC               | PICC → PCD                                  | Bit rate                | Subcarrier | Used by               |
|---------------|--------------------------|---------------------------------------------|-------------------------|------------|-----------------------|
| `MOD-A-MIL-MAN` | ASK 100 % + Mod-Miller | OOK + Manchester                            | 106 kbit/s              | 847.5 kHz  | T1T, T2T `[NTAG21x-DS]`, T4T-A 106 |
| `MOD-A-MIL-BPSK` | ASK 100 % + Mod-Miller | BPSK on subcarrier                          | 212/424/848 kbit/s      | 847.5 kHz  | T4T-A high-rate       |
| `MOD-B-NRZ-BPSK` | ASK 10 % NRZ           | BPSK NRZ-L                                  | 106/212/424/848 kbit/s  | 847.5 kHz  | T4T-B `[Wikipedia-ISO14443]` |
| `MOD-F-MAN`     | Manchester at 212/424 kbit/s | Manchester (no subcarrier)             | 212/424 kbit/s          | none       | T3T / FeliCa           |
| `MOD-V-1OF256`  | ASK 10 % or 100 % + 1-of-256 PPM | OOK or FSK on 423.75 (and 484.28) kHz  | 1.65 kbit/s             | 423.75 kHz | T5T low-rate `[Wikipedia-ISO15693]` |
| `MOD-V-1OF4`    | ASK 10 % or 100 % + 1-of-4 PPM | OOK or FSK on 423.75/484.28 kHz         | 26.48 kbit/s            | 423.75 kHz | T5T high-rate          |

Three modulation/encoding *combinations relevant to our problem* are
`MOD-A-MIL-MAN`, `MOD-V-1OF256`, and `MOD-V-1OF4` (the others are
either out of scope or incremental extensions).

## C. Anticollision approaches in commercial silicon

### C1. Bit-frame anticollision with 4-byte (cascade level 1) UID

- ISO 14443-3 §6 / `[TI-SLOA136]`. SAK after SELECT_CL1 has bit 6 = 0.
- Used in: original MIFARE Ultralight (some), MIFARE Classic (4-byte
  variants), older NTAG203 (some lots).

### C2. Bit-frame anticollision with 7-byte (cascade level 2) UID

- ISO 14443-3 §6.5 / `[TI-SLOA136]`. ANTICOLLISION_CL1 returns 4 bytes
  starting with the cascade tag (CT = 0x88), then a SELECT_CL1 returns
  SAK with bit 3 = 1, then ANTICOLLISION_CL2 returns the remaining
  4 bytes.
- Used in: **NTAG21x** `[NTAG21x-DS]` §8.5.1 (manufacturer ID 0x04 in
  SN0); ST25TA02K `[ST25TA02K-DS]`; NXP MIFARE DESFire EV1+;
  ChameleonMini default for NTAG/MFUL emulation `[ChameleonMini]`.
- **Recommended for our chip** because it matches what the dominant
  commercial tag family does and avoids upsetting reader app heuristics
  that key on UID length.

### C3. Triple-cascade 10-byte UID

- Allowed by ISO 14443-3 but extremely rare in shipping silicon.
- Cited by `[TI-SLOA136]` as a structural option.
- **Not recommended:** offers nothing for our brief and adds a third
  SELECT round-trip.

### C4. ISO 15693 32-bit slot anticollision

- `[Wikipedia-ISO15693]`, `[ST25TV02K-DS]`. INVENTORY command, mask
  bits, slot counter (1 or 16 slots). Different beast from 14443A.
- Used in T5T candidate `A6`.

## D. Payload-storage architectures — what shipping ICs do

| ID                 | Description                                                 | Examples |
|--------------------|-------------------------------------------------------------|---------|
| `STORE-EEPROM`     | Multi-time programmable EEPROM (10/40/60/200 yr retention)  | Every commercial tag IC `[NTAG21x-DS]`, `[ST25TN512-DS]`, `[ST25TV02K-DS]`, `[ST25TA02K-DS]`, `[EM4423-DS]` |
| `STORE-MASKROM`    | Tape-out-fixed payload                                       | None in mass-market commercial — but *every* prototype FPGA emulator (`[NfcEmu]`, `[ChameleonMini]` test modes) does this in BRAM/flash |
| `STORE-OTP-EFUSE`  | One-time programmable; per-die UID always uses this even on EEPROM chips | NTAG21x UID + originality signature `[NTAG21x-DS]` §1.3 |
| `STORE-SRAM-RW`    | Volatile SRAM holding session data / pass-through interface | NTAG I²C plus NTAG 5 boost (host-side written buffer) |
| `STORE-FLASH-MCU`  | Tag is an MCU running tag firmware off internal flash       | Power-Free NFC Emulator `[Hackaday-PowerFreeNFC]` |

For a **wafer.space "fixed at tape-out" business card**, `STORE-MASKROM`
is by far the cheapest commercial pattern — and it is what every
non-rewritable demo/test setup actually does. The *commercial* tag
ICs use EEPROM purely so the customer can program the tag *after*
purchase; we as the chip designer have no such constraint.

## E. Clocking from carrier vs internal oscillator — what shipping ICs do

Every commercial passive NFC/RFID tag IC examined (NTAG21x, ST25TN /
ST25TA / ST25TV, EM4423, ICODE SLI, MIFARE DESFire, FeliCa Lite-S)
**derives all baseband timing from the rectified 13.56 MHz carrier**
(or 27.12 MHz / 32 × fc oversampling internally). Search hits in
`[ST-iOS13-NFC-Blog]`, `[Wikipedia-ISO14443]`, `[Hackaday-PowerFreeNFC]`
all corroborate this. None ship with an on-die oscillator that drives
the protocol engine.

The **only** time an internal oscillator is used in a passive NFC IC
is to schedule a *post-field* deferred operation (e.g. ST25TV02K's
"tamper" timer). The protocol engine itself is always carrier-locked.

This independently confirms the first-principles report's `CLK-CARRIER`
recommendation — and decouples item (h) from item (a).

## F. Power consumption — what shipping ICs report

- **NTAG21x `[NTAG21x-DS]`:** does not state DC current directly
  (the chip is not externally biased); the datasheet quantifies
  sensitivity by "operating distance up to 100 mm" at typical reader
  field strengths. Commonly quoted budget for the NTAG IC is
  **< 100 µW peak** in active read.
- **ST25TN512 `[ST25TN512-DS]`:** "powered exclusively by the RF field"
  — no I_cc spec because there is no external supply.
- **ST25TV02K `[ST25TV02K-DS]`:** same. Tuning-cap variants 23 pF or
  99.7 pF.
- **Power-Free NFC Emulator `[Hackaday-PowerFreeNFC]`:** measured
  3.5 mA at 27.12 MHz on CW32L010 from a 3.3 V/15 mW NFC field —
  i.e. ~11.5 mW total. **This is the most direct industry data point
  for the harvester budget our v2 chip will see**, because it is also
  a discrete RF-powered design with no off-die power source.

This confirms `[NTAG21x-DS]` §1.1 ("contactless transmission of data
**and supply energy**") — the harvester (item (b)) provides a sub-mW
to single-mW budget, which is plenty for a digital baseband with
~2 k gates switching at 13.56 MHz.

## G. Open-source / reference RTL & firmware (validation harness)

- **`[NfcEmu]`** — closest to a *gateware* reference (Saxo-Q FPGA,
  VHDL, ISO 14443A PICC at 106 kbit/s with 8051 softcore). Provides a
  template for splitting the design into `(modem, framer, FSM)`.
- **`[ChameleonMini]`** — Atmel AVR firmware. Demonstrates that the
  full T2T (NTAG21x) protocol fits in a small MCU (ATxmega128A4U,
  128 kB flash, 16 kB SRAM). The hand-tight HDL equivalent (no MCU)
  is much smaller — see first-principles §5.3 for the gate-count
  derivation.
- **`[Proxmark3]`** — ARM + Spartan-IIE FPGA. Reference for
  every NFC tag *and* reader; the T2T tag-emulator code is the
  community ground truth and we should run it as a bench test against
  pre-silicon RTL simulations.
- **`[libnfc]`** — host-side reader library; useful for Linux PC
  bench testing.
- **`[nfcpy]`** — host-side library, biased to T3T.
- **`[Hackaday-PowerFreeNFC]`** — modern (2024-25) demonstration that
  passive RF-powered emulation is feasible at sub-15 mW.
