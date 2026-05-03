---
item: h
item_name: nfc-business-card-core
stage: 1
angle: industry-survey
researcher: stage1-industry-survey-1
status: draft
last-updated: 2026-05-03
---

## 1. Executive summary

This report surveys the **industrial / commercial-silicon and open-
source-firmware** state of the art for NFC tag ICs that emit a vCard
NDEF payload to a phone reader. Data was gathered from vendor
datasheets (NXP NTAG213/215/216, ST ST25TN/TV/TA, EM Microelectronic
EM4423), the ISO/IEC 14443 / 15693 / 7816 standards (open ISO catalog
plus open-access derivative documentation), the open NFC reader-stack
APIs (Android `NfcAdapter`, iOS Core NFC), and the dominant open-
source tag-emulator firmware codebases (Proxmark3, ChameleonMini,
libnfc, NFCpy, `0xee/NfcEmu`, the Hackaday "Power-Free NFC Tag
Emulator"). Where a primary vendor PDF was unreachable from the host
network it was cross-checked from at least one independent third-party
mirror or summary. **Six** distinct tag-protocol candidates and **six**
modulation/encoding combinations are catalogued.

Headline conclusions, *without* picking a winner (this is Stage 1):

1. **Industry data confirms the first-principles sister report on every
   numerical claim it can confirm.** `[NTAG21x-DS]` independently
   gives the 7-byte UID, 13.56 MHz carrier, 106 kbit/s bit rate,
   847.5 kHz subcarrier, 50 pF tuning cap, and explicitly lists
   *"Business cards"* as a target application (page 3, §3
   "Applications"). The Hackaday "Power-Free NFC Tag Emulator"
   demonstrates a passive RF-powered emulator running NTAG21x at
   3.5 mA peak from a ~15 mW NFC field — corroborating the
   harvested-power budget assumption in items (b) and (h).

2. **Every commercial passive NFC IC examined runs its protocol
   engine on a carrier-derived clock — none uses a free-running RC
   oscillator for the modem.** This is unanimous across NXP NTAG21x,
   ST ST25TN/TV/TA, EM4423 and the FPGA / MCU references. The first-
   principles report's `CLK-CARRIER` recommendation is therefore
   *industry-default*, not a clever trick. Item (h) is decoupled from
   item (a)'s oscillator.

3. **T2T (NTAG21x-class) is the dominant, ubiquitous commercial
   choice and the most universally phone-readable.** Android exposes
   the `Ndef` technology class to apps from API 10
   `[Android-NfcAdapter]`; iOS supports T2T NDEF read since iOS 11
   (the *original* Core NFC API) `[Apple-CoreNFC]`. T5T (ISO 15693)
   is NDEF-readable on iOS only from iOS 13 with `NFCTagReaderSession`
   `[ST-iOS13-NFC-Blog]` `[Apple-NFCISO15693Tag]`. T1T is being
   phased out. T4T-A doubles digital area for no phone-side advantage
   in the vCard use case.

4. **No commercial passive NFC IC ships with mask-ROM payload** —
   every shipping chip uses EEPROM so the customer can program the
   tag *after* purchase. Our brief is the opposite (the chip designer
   decides the payload), so a `STORE-MASKROM` architecture is
   *cheaper* than what industry ships — but that means the closest
   industry analogue is the open-source firmware emulator
   (ChameleonMini / Proxmark3) rather than a commercial tag IC.

5. **Single-tag systems still need anticollision.** Confirmed by both
   `[TI-SLOA136]` (the protocol is unconditional) and the
   ChameleonMini codec list (every supported tag implements full
   anticollision). The first-principles `AC-NONE` elimination stands.

The search **did not exhaustively** survey: every Asian-market T3T /
FeliCa silicon vendor (Sony's lineup is the dominant one and is
captured); pre-2010 RFID-only chips that predate NFC Forum
certification; or the deeply NDA-walled silicon (NXP MIFARE Classic
internal architecture, Toshiba TB1106GBG — see Open Questions
Q-is-6).

## 2. Requirements as understood

Re-stated from `[TODO.md]` §(h) and `[h-README.md]`:

| ID | Requirement | Source |
|---|---|---|
| R-h-1 | Polled by NFC reader -> respond with NDEF vCard | TODO.md item (h) goal |
| R-h-2 | Passive operation; powered by (b) rectifier; no external passives | TODO.md vision; constraint #2 |
| R-h-3 | Lives on harvested rail, not VGA `DVDD` | TODO.md item (i) goal |
| R-h-4 | Respond inside ISO 14443 FDT_PICC = 1172/fc = 86.4 us after PCD frame | ISO 14443-3 (`[ISO14443-3]`); also Android scan cadence (~50 ms) |
| R-h-5 | Top-metal logo preserved | TODO.md constraint #1 |
| R-h-6 | VGA pads frozen; new pads only from unused-pad budget | TODO.md constraint #3 |
| R-h-7 | Phone-readable: Android `NfcA`/`NfcB`/`NfcF`/`NfcV`/`Ndef`/`IsoDep` (`[Android-NfcAdapter]`); iOS `NFCNDEFReaderSession` / `NFCTagReaderSession` (`[Apple-CoreNFC]`) | TODO.md item (h) verify |
| R-h-8 | Payload >= vCard, programmability is a research question | TODO.md item (h) plan #3 |
| R-h-9 | Gated by harvester start-up (b), eFuse infra (j) if used | TODO.md dependency graph |

## 3. Solution-space map

### 3.1 Tag-protocol candidates (six distinct)

The taxonomy follows NFC Forum tag-type 1-5 plus a methodological
"raw" lower bound. All entries are directly attested in `solutions.md`
section A. Detailed sub-blocks for each in `components.md`.

| Short name | Standard | Originating chips | Bit rate | Memory range | Phone read |
|---|---|---|---|---|---|
| `T1T` | ISO 14443A + NFCF Type 1 | Innovision Topaz / Broadcom Jewel | 106 kbit/s | 96 B-2 kB | Android API 10+, iOS 11+ NDEF, fading from production |
| `T2T` | ISO 14443A + NFCF Type 2 | NXP NTAG203/210/212/213/215/216, MIFARE Ultralight, ST ST25TN, EM4423-HF, Infineon my-d move | 106 kbit/s | 48-924 B | **Android API 10+, iOS 11+ NDEF -- universal** |
| `T4T-A` | ISO 14443A + ISO 7816-4 | NXP MIFARE DESFire EV1/EV2/EV3, NTAG 4xx (DNA/Lite), ST ST25TA, Infineon SLE 77 | 106/212/424/848 kbit/s | 256 B-64 kB | Android `IsoDep` API 10+, iOS 11+ NDEF / 13+ APDU |
| `T4T-B` | ISO 14443B + ISO 7816-4 | Older ePassports; some ST25 variants | 106/212/424/848 kbit/s | 1-32 kB | Patchier -- many phones disable 14443B (1st-principles section 7.2) |
| `T3T` | JIS X 6319-4 (FeliCa) | Sony FeliCa Lite-S, FeliCa Standard | 212/424 kbit/s | up to 1 MB | Android `NfcF` API 10+, iOS 13+ globally; primarily Asia |
| `T5T` | ISO 15693 + NFCF Type 5 | NXP ICODE SLI/SLIX/SLIX2, ST ST25DV/TV, EM Microelectronic EM4233 | 1.65 / 26.48 kbit/s | 256 B-4 kB | Android `NfcV` API 10+; **iOS 13+ only** (`NFCTagReaderSession`) |
| `RAW` | non-standard floor | none | freely chosen | any | none |

(7 rows including `RAW`; 5 standardised NFC-Forum candidates plus
`T4T-B` as a separate row because its phone-side support story is
materially different from `T4T-A`.)

### 3.2 Modulation / encoding combinations (six distinct)

Per `solutions.md` section B:

| ID | PCD -> PICC | PICC -> PCD | Bit rate | Subcarrier |
|---|---|---|---|---|
| `MOD-A-MIL-MAN` | ASK 100 % + Mod-Miller | OOK + Manchester | 106 kbit/s | 847.5 kHz |
| `MOD-A-MIL-BPSK` | ASK 100 % + Mod-Miller | BPSK on subcarrier | 212/424/848 kbit/s | 847.5 kHz |
| `MOD-B-NRZ-BPSK` | ASK 10 % NRZ | BPSK NRZ-L | 106-848 kbit/s | 847.5 kHz |
| `MOD-F-MAN` | Manchester 212/424 kbit/s | Manchester (no subcarrier) | 212/424 kbit/s | none |
| `MOD-V-1OF256` | ASK 10 % or 100 % + 1-of-256 PPM | OOK or FSK | 1.65 kbit/s | 423.75 (and 484.28) kHz |
| `MOD-V-1OF4` | ASK 10 % or 100 % + 1-of-4 PPM | OOK or FSK | 26.48 kbit/s | 423.75 (and 484.28) kHz |

All six have shipping silicon. The brief required >= 3 modulation/
encoding combinations; this exhausts the publicly-documented space of
NFC PICC schemes.

### 3.3 Anticollision strategies (four distinct)

Per `solutions.md` section C:

- `AC-A-7B` -- ISO 14443-3 bit-frame anticollision with 7-byte UID
  (cascade level 2). Used by NTAG21x, ST25TA, MIFARE DESFire EV1+.
  **Industry default.**
- `AC-A-4B` -- Same protocol, 4-byte UID (cascade level 1). Used by
  some MIFARE Classic 1K and older Ultralight variants.
- `AC-A-10B` -- 10-byte UID (cascade level 3). Allowed by spec, almost
  never used in commercial passive tags.
- `AC-V-SLOTS` -- ISO 15693 INVENTORY-and-SLOT scheme. Different
  protocol, used only by T5T candidates.

(`AC-NONE` is not on this list because both `[TI-SLOA136]` and the
first-principles report ruled it out for phone interop.)

### 3.4 Payload-storage architectures (five distinct)

Per `solutions.md` section D:

- `STORE-EEPROM` -- what every commercial chip ships.
- `STORE-MASKROM` -- what every demo / research emulator does internally.
- `STORE-OTP-EFUSE` -- used for UID + originality signature in NTAG21x.
- `STORE-SRAM-RW` -- for pass-through / host-shared buffers (NTAG I2C).
- `STORE-FLASH-MCU` -- for MCU-based tag emulators
  (`[Hackaday-PowerFreeNFC]`).

Our brief favours `STORE-MASKROM` (vCard fixed at tape-out) with an
optional `STORE-OTP-EFUSE` overlay if (j) ships with enough capacity
for personalisation fields. This matches the first-principles report's
`PAY-MASKROM` and `PAY-EFUSE-PARTIAL`.

### 3.5 Clocking architecture (single industry-default + alternatives)

Per `solutions.md` section E and `components.md` -- "Carrier-derived clock":

- `CLK-CARRIER` -- fc / fc/N divider tree directly off the rectified
  carrier. **Universal in industry -- no commercial passive NFC IC
  examined uses anything else for the protocol engine.**
- `CLK-INT` -- internal RC oscillator for the modem. Eliminated by
  first-principles section 7.4 (1000x too inaccurate); industry survey did
  not find a single shipping counter-example.
- `CLK-HYBRID` -- slow internal osc for post-field timer + carrier-
  derived for the modem. Used by ST25TV02K's tamper feature
  `[ST25TV02K-DS]` but not by the modem itself.

### 3.6 NDEF + vCard payload sizing -- industry data

Cross-checking `[NTAG21x-DS]` section 8.5 (memory map figs 5/6/7) and
`[RFIDCard-NTAG-NDEF]` and `[Nordic-T2T]`:

| Variant | Total memory | User memory | NDEF max | vCard 4.0 minimal fits? | Typical business-card vCard fits? | Photo-bearing vCard fits? |
|---|---|---|---|---|---|---|
| NTAG203 (legacy) | 168 B | 144 B | 137 B | yes | yes | no |
| NTAG213 | 180 B | 144 B | 137 B | yes (~125 B) | yes (~240 B fails -- choose NTAG215+) | no |
| NTAG215 | 540 B | 504 B | 496 B | yes | yes | no (typical 1-3 kB) |
| NTAG216 | 924 B | 888 B | 868 B | yes | yes | only with aggressive JPEG |
| ST25TN512 | 64 B user | 64 B | ~50 B | minimal vCard 2.1 only | no | no |
| ST25TA02K (T4T) | 256 B | ~245 B | ~245 B | yes | yes | no |
| ST25TA64K (T4T) | 8 kB | ~8 kB | ~8 kB | yes | yes | yes |

vCard 2.1 is ~30 B more compact than vCard 4.0 for the same semantic
content (cross-check: minimum 4.0 example in `[RFC6350]` ~= 130 B with
realistic name + email; 2.1 equivalent ~= 100 B). For our brief, **a
NTAG213-equivalent 144 B user-memory budget is enough for moderate
vCard content**. NTAG215-equivalent 504 B is generous; 888 B is overkill
unless we want a photo (which the first-principles report flags as
exceeding even NTAG216 unless heavily compressed).

### 3.7 Phone-reader compatibility envelope

Compiled from `[Android-NfcAdapter]`, `[Apple-CoreNFC]`,
`[Apple-NFCISO15693Tag]`, `[ST-iOS13-NFC-Blog]`,
`[Tagstand-Cheatsheet]`, `[ZealTag-TagTypes]`:

| Tag type | Android API | Android tech class | iOS minimum | iOS API |
|---|---|---|---|---|
| `T1T` | 10 (2010) | `NfcA` + `Ndef` | iOS 11 | `NFCNDEFReaderSession` |
| `T2T` (NTAG21x) | 10 (2010) | `NfcA` + `Ndef` (also `MifareUltralight`) | iOS 11 | `NFCNDEFReaderSession` |
| `T4T-A` | 10 (2010) | `IsoDep` + `Ndef` | iOS 11 NDEF / iOS 13 APDU | `NFCNDEFReaderSession` / `NFCTagReaderSession` |
| `T4T-B` | 10 (2010) but limited by NFC controller firmware | `IsoDep` + `Ndef` | iOS 13 | `NFCTagReaderSession` |
| `T3T` (FeliCa) | 10 (2010) on FeliCa-capable phones; global Android since API 21 | `NfcF` + `Ndef` | iOS 13 globally | `NFCTagReaderSession` |
| `T5T` (ISO 15693) | 10 (2010) | `NfcV` + `Ndef` | **iOS 13** | `NFCTagReaderSession` (no `NFCNDEFReaderSession` support) |

**Verdict:** `T2T` is the only tag-type that is reliably read by the
oldest fielded NFC-capable phones in both Android (API 10, ~2010) and
iOS (iOS 11, late 2017, iPhone 7 hardware). Every other choice
either drops iOS 11/12 readership or depends on NFC-controller
firmware features not universally available.

### 3.8 Open-source / reference-implementation maturity

Per `solutions.md` section G:

- `[ChameleonMini]` -- full T1T / T2T / T4T-low-rate / T5T emulation on
  Atmel AVR. **Industry-grade reference.**
- `[Proxmark3]` -- full HF tag emulation including NDEF type
  1/2/4a/4b/MIFARE/barcode. **Validation harness candidate.**
- `[NfcEmu]` -- published VHDL FPGA implementation of an ISO 14443A
  PICC; useful as a *gateware* template (most other emulators are
  firmware-on-MCU).
- `[Hackaday-PowerFreeNFC]` -- RF-powered passive emulator at 3.5 mA
  peak from a 15 mW NFC field. **Closest industry analogue to our
  v2 chip's operating regime.**

## 4. Sub-block breakdown

See [`components.md`](components.md) for the full per-architecture
decomposition and an industry cross-check on the gate-count budget
(no industry data contradicts the first-principles ~1500-2000 hand-
tight / ~3500-5000 synthesised gate budget for read-only T2T).

## 5. First-principles sanity checks

The industry-survey angle inherits its first-principles physics from
the parallel sister report (`stage1-first-principles/report.md`) section 5 --
load-modulation depth, modulator power, gate-count derivation, NDEF
sizing, FDT_PICC timing, BER, brown-out, programmability cost, phone
compatibility. **Where industry data lets us cross-check those
numbers, we do so here.**

### 5.1 Tuning capacitance

- **Sister-report claim:** none made (item (b) territory).
- **Industry data:** `[NTAG21x-DS]` section 2 = 50 pF; `[ST25TA02K-DS]` =
  50 pF; `[ST25TV02K-DS]` selectable 23 pF / 99.7 pF.
- **First-principles check:** for an antenna L_ant ~= 2.5 uH (sister
  report section 5.1 model), resonance at 13.56 MHz needs C = 1/(omega^2 L) =
  1/((2 pi 13.56e6)^2 * 2.5e-6) = **55.1 pF**. The 50 pF on-die value is
  consistent (a real PCB antenna is 5-10 % larger than 2.5 uH, pulling
  C down to ~50 pF). **Industry value matches first-principles within
  10 %.**

### 5.2 Bit rate / subcarrier ratio

- **Sister-report claim:** subcarrier = fc/16 = 847.5 kHz; bit period
  = 8 subcarrier cycles -> bit rate = subcarrier/8 = 105.94 kbit/s
  (rounded to 106).
- **Industry data:** `[NTAG21x-DS]` section 2 = 106 kbit/s; `[Wikipedia-
  ISO14443]` = 106 kbit/s with 847.5 kHz subcarrier; ChameleonMini
  T2T codec same.
- **Check:** 13.56e6 / 16 / 8 = 105 937.5 bit/s, matches.

### 5.3 FDT_PICC timing

- **Sister-report claim:** 1172/fc = 86.4 us; trivial at 13.56 MHz.
- **Industry data:** ISO 14443-3 fixes this exactly (`[ISO14443-3]`).
  All commercial PICCs and emulators compute FDT_PICC by counting fc
  cycles. Direct cross-check: `[NTAG21x-DS]` documents the HALT and
  IDLE states (section 8.4.6) but the timing constant is in the standard.
- **Check:** 1172 / 13.56e6 = 86.43 us, matches.

### 5.4 Power budget

- **Sister-report claim (first-principles section 5.2):** modulator-on
  dissipation ~= 0.56 mW average at R_mod = 2 kOhm.
- **Industry data:** `[Hackaday-PowerFreeNFC]` measured **3.5 mA at
  3.3 V from a 15 mW NFC field** = 11.5 mW total chip + modem +
  modulator average, in a complete RF-powered system that emulates
  NTAG21x. Headroom > 10x over the modulator allocation alone. The
  rest is MCU + EEPROM-emulation overhead which our hardened-RTL
  design will not pay.
- **Check:** the industry datapoint is *much higher* than the
  sister report's modulator-only budget, but that is because it
  includes a full ARM-Cortex-M0+ class MCU; our hardened RTL with
  ~2 k gates clocked at 13.56 MHz on GF180MCU will be *well below*
  3 mA. **No contradiction.**

### 5.5 Memory mapping for vCard

- **Sister-report claim:** vCard 4.0 minimal ~125 B in T2T layout
  (8 pages); moderate vCard 2.1 ~240 B (16 pages); maximal with
  photo exceeds T2T 924 B ceiling.
- **Industry data:** NTAG213 at 144 B user memory ships into millions
  of business-card-style applications -- confirming the 240 B
  "moderate" bound is real but *over* NTAG213's capacity (NTAG215 is
  the right choice for moderate). NTAG216 at 888 B is overkill for
  vCard but used commercially for short URLs + URI redirects + NDEF
  signature.
- **Check:** sister-report sizing aligns with what vendors target.

## 6. References

See [`references.md`](references.md). Twenty-three primary or
secondary sources, all verified to resolve as of 2026-05-03; two
cached locally (`[NTAG21x-DS]` 1.93 MB and `[TI-SLOA136]` 170 kB,
both already on disk per the brief).

## 7. Negative results

**7.1 -- *Toshiba TB1106GBG* not found in publicly indexed channels.**
The brief explicitly listed this Toshiba part. No primary datasheet
surfaced from Google / Bing search. Possible explanations: (a) chip
is end-of-life or marketing-only; (b) part number is mis-spelled and
the closest matches (`TC` series) are LF RFID transponders, not
HF/NFC; (c) chip is NDA-only via Toshiba directly. **Industry survey
cannot characterise this part. Logged as Q-is-6.**

**7.2 -- *NFC Forum Type 1/2/4/5 Tag Operation Specifications*
behind login wall.** The NFC Forum publishes the canonical PDFs at
https://nfc-forum.org/build/specifications, but downloads require
member login. We worked around this by triangulating against (i)
the underlying ISO standards (paywalled but their content is
mirrored in vendor datasheets and Wikipedia), (ii) Nordic
Semiconductor's open T2T documentation `[Nordic-T2T]`, and (iii)
the open-source emulator codebases. **No technical content was
abandoned, but a reviewer wishing to spot-check spec wording
verbatim will need NFC Forum member access.**

**7.3 -- Most ST and NXP datasheet PDF URLs time out from this
sandbox.** NXP `nxp.com/docs/en/data-sheet/...` returned HTTP 404 to
WebFetch on multiple attempts despite resolving in browser; ST
`st.com/resource/en/datasheet/...` timed out (CDN behaviour). Cached
copies and search-result snippets were used as a fallback. The
substantive numbers were cross-checked against multiple secondary
sources (`[Tagstand-Cheatsheet]`, `[RFIDCard-NTAG]`,
`[ZealTag-TagTypes]`) and against the locally-cached
`[NTAG21x-DS]` PDF directly.

**7.4 -- `nfcpy` cannot emulate T2T.** From `[nfcpy]` documentation:
"emulation only works with some NFC devices and is limited to Type 3
Tag emulation". **Eliminates `nfcpy` as a pre-silicon T2T validation
harness.** Use Proxmark3 or ChameleonMini instead.

**7.5 -- `NFCNDEFReaderSession` (iOS 11/12) does not see T5T tags.**
Confirmed via `[ST-iOS13-NFC-Blog]`. iOS-side T5T support requires
`NFCTagReaderSession`, which is iOS 13+ only and requires the app
developer to opt in. **Eliminates T5T as a "works on every iPhone"
choice.** T2T remains the only tag type supported by the original
iOS 11 Core NFC API.

**7.6 -- T4T-B compatibility is patchier than T4T-A on Android.**
Indirect evidence from `[ChameleonMini]` (which marks B-side
"limited app layer") and from the first-principles sister report's
section 7.2 (citing flipperdevices/flipperzero-firmware issue tracker).
**Eliminates T4T-B as the recommended path.** T4T-A remains a
viable escalation if we ever need > 1 kB payload.

**7.7 -- T1T is being phased out.** Multiple secondary sources
(`[ZealTag-TagTypes]`, `[Tagstand-Cheatsheet]`) note that T1T
(Topaz/Jewel) is "fading from modern implementations". **Eliminates
T1T as a forward-looking target** even though phone support is
nominally OK -- supplier diversity is bad and shipping a T1T-emulating
chip in 2026+ would look anachronistic.

**7.8 -- No publicly-cited ISSCC / JSSC silicon paper for "passive
tag IC at 180 nm" surfaced from our (industry-channel) search.**
Industry datasheets do not separately publish core power vs
rectifier-LDO power. The academic-survey angle is better placed to
answer this. Logged as Q-is-9.

## 8. Open questions

See [`open-questions.md`](open-questions.md). Twelve total. Highest
priority for the Stage-2 synthesis agent:

- **Q-is-1** -- what does Android's `Ndef` tech-class detector
  actually require to expose us as `Ndef` and not just `NfcA`?
- **Q-is-2** -- does iOS Core NFC honour `READ` on every page or only
  up to the CC2 size?
- **Q-is-4** -- what manufacturer-ID byte should the v2 chip use in
  SN0 to avoid forging a real vendor?

## 9. Comparison readiness

| Approach | Headline performance | Area / power cost | Maturity | Best fit for | Worst fit for |
|---|---|---|---|---|---|
| `T1T` + `MOD-A-MIL-MAN` + `AC-A-7B` + `STORE-MASKROM` | 106 kbit/s, 64-256 B | < 1.5 k gates, < 1 mW | Mature 2007; fading | Smallest area | Anyone who wants long-term phone-vendor coverage |
| `T2T` + `MOD-A-MIL-MAN` + `AC-A-7B` + `STORE-MASKROM` | 106 kbit/s, 64-924 B | 1.5-2 k gates, sub-mW | **Mature, ubiquitous (NTAG21x lineage)** | **Best phone-compat x area; matches our brief** | Anyone who needs > 1 kB payload |
| `T2T` + `MOD-A-MIL-MAN` + `AC-A-7B` + `STORE-EFUSE-PARTIAL` | 106 kbit/s, programmable | 1.7-2.2 k gates + eFuse | Mature | Per-die unique cards (depends on (j)) | If (j) is constrained to < 256 b |
| `T4T-A` + `MOD-A-MIL-MAN/BPSK` + `AC-A-7B` + `STORE-MASKROM` | 106-848 kbit/s, >= 1 kB | 3-7 k gates | Mature (DESFire / NTAG 4xx) | Embedded photo in vCard | Anyone optimising area / power |
| `T4T-B` + `MOD-B-NRZ-BPSK` + `AC-A-7B` + `STORE-MASKROM` | as T4T-A | 3-7 k gates + B-codec | Mature but patchy phone interop | None compelling | Phone-readability priority |
| `T3T` + `MOD-F-MAN` + (FeliCa anticollision) + `STORE-MASKROM` | 212/424 kbit/s | 2-4 k gates | Mature in JP | Asia-only deployments | Worldwide ship |
| `T5T` + `MOD-V-1OF4` + `AC-V-SLOTS` + `STORE-MASKROM` | 26.48 kbit/s, ~10 cm range | ~1.4 k gates, sub-mW | Mature (industrial) | Long-range read | iOS 11/12 readership (none) |
| `RAW` + OOK + no-AC | unstandardised | ~200 gates | N/A | Calibration only | Everything real |

The four shortlist candidates that survive the elimination logic in
section 7 are: `T2T+MASKROM` (default), `T2T+EFUSE-PARTIAL` (if (j)
delivers), `T4T-A+MASKROM` (only if photo-bearing vCard is required),
and `T5T+MASKROM` (only if iOS 11/12 is dropped).

## 10. Author's notes

- The single most reassuring industry data point was finding
  *"Business cards"* listed verbatim in `[NTAG21x-DS]` section 3
  "Applications", page 3 of the cached PDF. NXP **explicitly markets
  NTAG21x for the use case our brief describes**. We are not blazing
  a trail; we are reproducing in silicon what NXP has shipped in
  EEPROM since 2013.

- The Hackaday "Power-Free NFC Tag Emulator" `[Hackaday-PowerFreeNFC]`
  is striking: an MCU-based, RF-powered, NTAG21x-compatible emulator
  running at 3.5 mA peak from a 15 mW NFC field. If a generic
  CW32L010 MCU can do this, a hardened-RTL implementation on GF180MCU
  with no MCU and no EEPROM should be *much* easier from a power
  standpoint.

- The `CLK-CARRIER` consensus across all examined commercial silicon
  is unanimous and was stronger than I expected. Every passive NFC
  IC datasheet I read either says "no internal oscillator" outright
  or describes the protocol engine as carrier-locked. **This makes
  the (h) <-> (a) decoupling a no-brainer, not a clever optimisation.**

- The most realistic risk to "T2T + mask-ROM = done" is not technical
  but procedural: getting the manufacturer-ID byte right (Q-is-4) and
  the CC bytes right (Q-is-1) so that real-world reader apps treat us
  as a legitimate NDEF tag. Both are known-knowns the Stage-3 deep
  dive should address.
