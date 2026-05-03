# Solutions / architectures surveyed -- academic angle

This file unpacks the protocol-and-architecture cells of
[`report.md`](report.md) section 3 into per-architecture descriptions
suitable for the Stage-2 synthesis agent to merge with the parallel
sister reports' `solutions.md`.

Each section starts with the same short-name the sister reports use
(stable identifier across reports), then a one-paragraph
description, then known peer-reviewed silicon attestation, then the
condition under which the approach was *abandoned* in prior art (if
any) and whether that abandonment applies to **our** brief.

## A. Tag-protocol candidates

### A.1 `T1T` -- ISO 14443A NFC Forum Type 1

Topaz/Jewel-class HF tag. 4-byte read/write commands; 96 B-2 kB
memory; carrier-derived bit clock; modified Miller PCD->PICC, Manchester
PICC->PCD. NDEF Type 1 is supported.

**Academic silicon attestation:** *no recent peer-reviewed academic
silicon paper found.* Topaz devices were academically interesting at
the time of the original Innovision / Broadcom merger, but academic
attention shifted to T2T after NTAG21x became the *de-facto*
NDEF tag in the mid-2010s. Industry survey already documents the
phase-out.

**Why abandoned (in industry/academia):** market consolidation
around T2T; almost no advantage over T2T for NDEF use cases.

**Application to our brief:** rules out -- consistent with sister
reports.

### A.2 `T2T` -- ISO 14443A NFC Forum Type 2 (NTAG-class)

Standard ISO 14443-3 PICC at 106 kbit/s with 7-byte (or 4-byte)
UID, 4-byte page-addressed memory layout, NDEF Type 2 capability
container in pages 3-4. The *de-facto* NDEF tag.

**Academic silicon attestation:** `[Lu-2016]` (passive tag IC in
0.18 um, biomedical-targeted, 14443A-style front-end with
67.7 uW analog-only); `[Myny-2017-ISSCC]` (flexible metal-oxide
TFT 14443A NFC barcode tag with direct fc-divider clock and 128-bit
on-chip ROM, ISSCC 15.2, Myny et al. IMEC/Holst).

**Why abandoned:** *not* abandoned -- this is the dominant
academic and commercial choice. The only debate is whether to add
RAM-RW (sister item: complexity multiplier).

**Application to our brief:** primary candidate.

### A.3 `T2T-flex` -- ISO 14443A on flexible metal-oxide TFTs

Same protocol as `T2T` but on a *non-silicon* substrate (rolled
metal-oxide TFT process, IMEC/Cartamundi/Holst). Demonstrated as a
"barcode-equivalent" tag with 128-bit ROM payload and 7.5 mW total
power.

**Academic silicon attestation:** `[Myny-2017-ISSCC]` (ISSCC 15.2,
2017); follow-up at later ISSCC sessions (`[Myny-followup-2018]`)
introduces 128 b NDEF.

**Why interesting to us:** the "direct clock division circuit
from 13.56 MHz carrier" architectural claim is **the canonical
peer-reviewed precedent for our `CLK-CARRIER` decision**, and is
demonstrated on a far worse substrate than `gf180mcuD`. If a
metal-oxide TFT can run carrier-derived clocking and pass ISO
14443-A timing, GF180 trivially can.

**Why abandoned:** not for our use case (we are silicon, not
flexible TFT). Listed as supporting evidence, not a candidate.

### A.4 `T4T-A` -- ISO 14443A + ISO 7816-4

Same physical layer as `T2T`, but the application-layer protocol
above the 14443-4 block is ISO 7816-4 APDUs over an ISO-7816-style
file system. Used by NXP DESFire EVx, ST25TA, NTAG 4xx (DNA/Lite),
and -- critically -- by every NFC-enabled banking card.

**Academic silicon attestation:** `[Yin-2010-RFID-T4T]` (passive
HF RFID tag in 0.18 um for ISO/IEC 14443-B + 7816-4, 0.42 mW
front-end power); various follow-on dissertations and conference
papers in mid-2010s.

**Why abandoned (for our brief):** doubles the digital area for
NDEF-only use cases that fit in T2T. The only reason to use it
would be > 1 kB payload (photo-bearing vCard).

**Application to our brief:** secondary candidate, only if photo-
in-vCard becomes a hard requirement.

### A.5 `T4T-B` -- ISO 14443B + ISO 7816-4

ISO 14443B physical layer (10 % ASK NRZ, BPSK NRZ-L PICC->PCD,
106-848 kbit/s) with the same 7816-4 application layer. Used by
older ePassports and some ST25 variants.

**Academic silicon attestation:** `[Yin-2010-RFID-T4T]` is the
nearest fit (it implements 14443-B at 0.18 um). Generally less
academic activity than 14443A.

**Why abandoned (for our brief):** patchier phone reader-chip
support. Sister industry survey 7.6 documents Broadcom firmware
disabling 14443B in flagship phones.

**Application to our brief:** ruled out -- reach loss not justified.

### A.6 `T3T` -- JIS X 6319-4 (FeliCa)

Sony FeliCa physical and protocol layer. 212/424 kbit/s
Manchester-coded, no subcarrier. Dominant in Japan.

**Academic silicon attestation:** Sony has shipped FeliCa silicon
for two decades; almost all academic activity is in Japanese-
language venues / theses we did not survey.

**Why abandoned (for our brief):** non-Asian phone deployment is
spotty; Apple iOS 13 globally, but Android phones outside
Japan/HK often disable FeliCa to save power.

**Application to our brief:** ruled out -- reach loss not justified.

### A.7 `T5T` (medical / industrial) -- ISO 15693, NFC-V

ISO 15693 PICC at 1.65 or 26.48 kbit/s, 423.75 / 484.28 kHz
subcarriers, ASK 10 % or 100 % uplink, OOK or FSK downlink.
Long-range read (~10 cm), low data rate, easier through-body
performance. Dominant in industrial logistics and biomedical
implants.

**Academic silicon attestation:** `[Bhattacharyya-2018]` (Sensors,
0.18 um CMOS, 107 uW total, ISO 15693 / NFC Type 5, 1.5x1.5 mm die);
`[Dehennis-2016-TBioCAS]` (TBioCAS, NFC-enabled CMOS IC for
fully implantable glucose sensor, 0.6 um, ISO 15693, sub-mW);
`[Anabtawi-2016-BHI]` (BHI, 14 nm CMOS, 13.56 MHz harvest, glucose
SoC).

**Why interesting to us:** academic implant literature converges
on T5T because the data-rate floor permits sub-mW total tag-IC
power.

**Why abandoned (for our brief):** iOS Core NFC's original
`NFCNDEFReaderSession` (iOS 11/12) does not surface ISO 15693 tags
as `Ndef`; only iOS 13+ `NFCTagReaderSession` exposes them, and
only when the application explicitly opts in. Sister industry
survey 7.5 documents this.

**Application to our brief:** ruled out -- iOS 11/12 reach loss
not justified for a *flat business card* (where the implant-tag
range/through-tissue advantages buy nothing).

### A.8 `T2T+UWB` -- 14443A downlink + impulse-UWB uplink

Methodology requires the *upper bound* of architectural
sophistication. `[Pelissier-2011-ISSCC]` is an ISSCC paper that
combines a passive 14443A downlink (low-rate command channel) with
a 10 Mbit/s impulse-UWB uplink at -18.5 dBm sensitivity. Total
chip 0.18 um.

**Why interesting:** demonstrates that *upstream* data rate is
where the power budget goes when you scale beyond ISO-14443. Not
phone-compatible (no consumer phone has UWB RX paired with NFC
PCD).

**Why abandoned (for our brief):** explicitly out of scope; we
listed it for methodological completeness only.

### A.9 `RAW` -- non-standard floor

Not a real candidate. Methodology requires both spectrum extremes.

## B. Modulation / encoding combinations

### B.1 `MOD-A-MIL-MAN`

ASK 100 % Modified Miller PCD->PICC; OOK Manchester PICC->PCD on
847.5 kHz subcarrier. ISO 14443-2 8 / -3 6.

**Silicon attestation:** `[Lu-2016]`, `[Myny-2017-ISSCC]`.

### B.2 `MOD-A-MIL-BPSK`

ASK 100 % Modified Miller PCD->PICC; BPSK on 847.5 kHz subcarrier
PICC->PCD. Used at 212/424/848 kbit/s in 14443-A high-rate modes.

**Silicon attestation:** `[Yin-2010-RFID-T4T]` (high-rate path,
behind paywall).

### B.3 `MOD-B-NRZ-BPSK`

ASK 10 % NRZ PCD->PICC; BPSK NRZ-L PICC->PCD. ISO 14443-B physical
layer.

**Silicon attestation:** `[Yin-2010-RFID-T4T]`.

### B.4 `MOD-V-1OF256` / `MOD-V-1OF4`

ISO 15693 ASK 10 % or 100 % + 1-of-256 (slow) or 1-of-4 (fast)
PPM PCD->PICC; OOK or FSK on 423.75/484.28 kHz subcarrier
PICC->PCD.

**Silicon attestation:** `[Bhattacharyya-2018]`.

### B.5 `MOD-LSK`

Pure load-shift keying without a separate subcarrier (uplink-only
narrowband mode used by some implant tags). ISO 14443-2 5.

**Silicon attestation:** `[Anabtawi-2016-BHI]`.

## C. Anticollision

### C.1 `AC-A-7B`

ISO 14443-3 cascade-level-2 7-byte UID. PCD sends `REQA -> ATQA ->
SEL CL1 -> SAK_cl1 -> SEL CL2 -> SAK_cl2 -> ACTIVE`. Roughly 150
gates of state machine if UID is hard-wired.

**Silicon attestation:** every academic T2T paper found.

### C.2 `AC-A-4B`

Cascade-level-1 4-byte UID. Older Ultralight-style chips. Same
protocol skeleton, fewer states.

### C.3 `AC-V-SLOTS`

ISO 15693 INVENTORY frame with 1- or 16-slot anticollision; PICC
selects a slot according to its UID hash and replies in that slot.

**Silicon attestation:** `[Bhattacharyya-2018]`.

### C.4 `AC-NONE`

Not implemented in any peer-reviewed silicon paper found.
Eliminated by sister reports.

## D. Payload-storage architecture

### D.1 `STORE-MASKROM`

Payload baked into the silicon at tape-out as synthesised
constants in the digital RTL. No post-fab personalisation possible.

**Academic silicon attestation:** `[Myny-2017-ISSCC]` (128 b ROM
on a flexible NFC tag); generally implicit in any
"emulator-style" academic paper.

### D.2 `STORE-EEPROM`

Customer-programmable non-volatile memory. The default for every
*commercially-shipped* HF tag IC (academic chips that target
commercial use likewise).

**Academic silicon attestation:** `[Lu-2016]` "0.18-um 2-poly
5-metal mixed signal CMOS technology with EEPROM process"
(verbatim from abstract).

### D.3 `STORE-OTP-EFUSE`

Fuse / antifuse one-time-programmable storage. Used in every
NTAG21x for the UID and originality signature, and in academic
silicon for unique-per-die data.

**Academic silicon attestation:** `[Lu-2016]` referenced; sister
industry survey D documents NTAG21x usage.

### D.4 `STORE-SRAM-RW`

SRAM-backed payload that the reader can write at runtime. Used
for sensor pass-through and host-shared buffers.

**Academic silicon attestation:** `[Anabtawi-2016-BHI]` SoC has
sensor-data buffer in RAM.

### D.5 `STORE-FLASH-MCU`

External or on-die flash on an MCU-emulator implementation. Not
relevant to our hardened-RTL plan (sister industry survey 3.4).

## E. Clocking architecture

### E.1 `CLK-CARRIER`

Divide rectified 13.56 MHz carrier by N to obtain the modem clock
(N in {16, 64, 128} for ISO 14443-A). No internal oscillator
needed for the modem.

**Academic silicon attestation:** universal across all examined
peer-reviewed silicon papers. `[Myny-2017-ISSCC]` makes it the
title of the paper.

### E.2 `CLK-INT`

Free-running on-die RC oscillator. Eliminated by sister
first-principles report 7.4. **No academic silicon paper uses an
internal oscillator for the modem path.** Some papers use one for
slow housekeeping (sleep, watchdog) only.

### E.3 `CLK-HYBRID`

Slow internal osc for post-field-loss timer + carrier-derived for
the modem. Used by some commercial silicon (sister industry
survey 3.5) -- not seen in academic literature in the sources
we searched.

## F. Open-source academic gateware

### F.1 `NfcEmu-VHDL`

Published VHDL ISO 14443A PICC emulator on FPGA. Documented in
multiple HDL-courseware blogs and at least one academic project
page. The closest open-source *gateware* template for our
hardened-RTL approach.

### F.2 `ChameleonMini`

Atmel-AVR-firmware emulator (already in industry survey). Useful
as a *validation harness*, not as a template.

### F.3 `Proxmark3`

ARM + FPGA + firmware reader/emulator. The FPGA half is
Verilog. Useful as a hostile-reader test rig.

## G. Phone-side compatibility (academic-grade studies)

No peer-reviewed paper publishes a phone-compatibility matrix.
The closest is the NFC Forum / RFID Journal joint
analog-parameter alignment whitepaper `[NFC-Forum-Analog-Align]`,
which documents the ISO 14443 / NFC Forum coil-and-amplitude
parameter spaces but does not match tag-types to specific phones.

This is a literature gap, not a project gap. See
`open-questions.md` Q-as-1.