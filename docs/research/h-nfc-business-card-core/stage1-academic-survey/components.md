# Sub-block breakdown -- academic-silicon cross-check

This file decomposes each protocol-level approach in
[`report.md`](report.md) section 3 into the analog and digital sub-blocks
required for an implementation, and -- where peer-reviewed silicon
publishes a measured number for that block -- cites the value next
to the first-principles sister-report's analytical estimate.

The structure intentionally mirrors the parallel
`stage1-industry-survey/components.md` and
`stage1-first-principles/components.md` so that Stage-2 can fold
columns side-by-side.

## A. Analog front-end (shared across all protocol candidates)

| Sub-block | First-principles target | Academic silicon attestation | Notes |
|---|---|---|---|
| Tuning capacitor (on-die) | ~50 pF for L_ant ~ 2.5 uH | `[Bhattacharyya-2018]` integrated on-die; `[Lu-2016]` 0.18 um IC has on-die tank (paywall, abstract-only) | Sister industry survey cites NTAG21x and ST25T family at 50 pF -- consistent. |
| Full-wave rectifier | Cross-coupled NMOS/PMOS bridge (no Schottky in `gf180mcuD`) | `[Bhattacharyya-2018]` "four parallel gate-cross-connected NMOS rectifier units"; `[Lu-2016]` "CMOS gate cross-coupled rectifier with diode" | Both papers explicit on the topology. Active synchronous rectification is the academic consensus for HF. |
| Overvoltage clamp | clamp to ~3 V at the rail, with antenna swing > 30 V near-field | `[Lu-2016]` includes "over-voltage protection circuit" in PMU block; `[Bhattacharyya-2018]` similarly | First-principles 257 V_pk unclamped figure motivates this. Academic silicon all clamps. |
| Bandgap reference | low-power, ~few uA bias | `[Bhattacharyya-2018]` reuses bandgap as envelope-detector load (novel) | Demonstrates ultra-low-power dual-use trick. |
| LDO / regulator | 1.2-1.8 V output at ~50 uA sustained | `[Bhattacharyya-2018]` LDO1 / LDO2 dual-rail | First-principles target hit. |
| Brown-out detector | release at V_rail >= V_BO | Implicit in all academic silicon; not separately specified in abstracts | Standard sub-block; behind paywall in detail. |
| Demodulator (envelope detector) | 10-25 mV ASK sensitivity | `[Bhattacharyya-2018]` 25 mV demodulation sensitivity | Matches sister-report claim. |
| Load-modulator switch | R_DSon ~ 2 kOhm | `[Lu-2016]` LSK switch (paywall, value not in abstract) | Sister industry survey cites NTAG21x equivalent ~2 kOhm; consistent. |

## B. Digital baseband (T2T-specific block list)

| Sub-block | Sister gate count | Academic silicon evidence | Notes |
|---|---|---|---|
| Manchester decoder | ~60 g | All examined T2T papers implement | Common-denominator block. |
| fc/16 prescaler | ~32 g | `[Myny-2017-ISSCC]` headlines this with "direct clock division" | Validates sister `CLK-CARRIER` decision. |
| Subcarrier modulator gate driver | ~10 g | All examined T2T papers | Trivial. |
| CRC-A 16-bit shift-XOR | ~80 g | All examined T2T papers; CRC-A is mandatory in ISO 14443-3 | Common-denominator. |
| FDT timer (1172/fc, 11-bit cycle counter) | ~88 g | Patent CN102968657A documents the timer's existence | Standard fc-counter. |
| ATQA shifter | ~64 g | All academic T2T papers ship a hard-wired ATQA value | First two bytes after REQA. |
| Anticollision comparator | ~40 g | `[Lu-2016]`, `[Myny-2017-ISSCC]`, `[NfcEmu-VHDL]` all implement full 14443-3 anticollision | `AC-NONE` not seen anywhere. |
| SAK shifter | ~32 g | All examined T2T papers | Returns the cascade-bit terminator. |
| READ block-addr parser | ~50 g | `[Lu-2016]` references READ at protocol layer | T2T-specific opcode. |
| ROM addr mux + 64-byte LUT | ~250 g | `[Myny-2017-ISSCC]` ships 128-bit ROM = 16 B, ~80 g; ours scales linearly | Lower bound observed. |
| Bit serializer | ~40 g | All examined T2T papers | Standard. |
| Top-level FSM | ~120 g | All examined T2T papers | Common-denominator. |
| Field-detect / POR | ~50 g | All examined silicon; sometimes part of PMU | Common-denominator. |

Total sister-estimate ~916 hand-tight gates, ~1500-2000 with
synthesis overhead. **No academic paper publishes a contradicting
gate count for read-only T2T**, but most papers don't separate the
modem from the SoC at all (they report total chip transistor count
or area instead of gate count).

## C. T4T-A delta (over T2T)

| Sub-block | Cost | Academic silicon evidence | Notes |
|---|---|---|---|
| ISO 7816-4 APDU parser | +~500 g | `[Yin-2010-RFID-T4T]` 14443B/T4 (paywall) | Adds `SELECT FILE`, `READ BINARY`, `UPDATE BINARY`. |
| File system (CC, NDEF, optional propr) | +~300 g | Same | Commonly 2-3 elementary files. |
| 4-byte CID handling | +~80 g | Same | Card identifier, 14443-4 layer. |
| Higher rates 212/424/848 | +~600 g (BPSK + clock-recovery) | Some `[Yin-2010-RFID-T4T]` modes | Optional; we'd not need it for vCard. |
| **T4T-A net cost** | **2-3x T2T** | Consistent with sister estimate `~3-7 k gates` | Confirmed. |

## D. T5T (ISO 15693) sub-block delta

| Sub-block | Cost | Academic silicon evidence | Notes |
|---|---|---|---|
| 1-of-256 / 1-of-4 PPM decoder | +~120 g | `[Bhattacharyya-2018]` | Replaces Modified Miller. |
| INVENTORY / SLOT-MARKER state machine | +~150 g | `[Bhattacharyya-2018]` | Replaces 14443-3 anticollision. |
| Subcarrier 423.75 / 484.28 kHz divider | +~32 g | `[Bhattacharyya-2018]` | fc/32 vs fc/16. |
| Lower-rate Manchester | -~20 g | -- | Simpler at 1.65/26.48 kbit/s. |
| **T5T net cost** | comparable to T2T (~1.4-1.6 k gates) | Sister-report figure consistent with `[Bhattacharyya-2018]` | Not cheaper enough to overcome iOS 11/12 reach loss. |

## E. Power management / harvest interaction

| Sub-block | First-principles target | Academic silicon evidence |
|---|---|---|
| MIM cap storage | 1-10 nF for modulation transients (sister item (e)) | `[Anabtawi-2016-BHI]` reports SMPS + storage architecture trade-offs | Item (e) territory; cross-cutting. |
| Modulator-induced antenna short tolerance | <10 % rectifier-output droop during modulation cycle | Implicit -- all measured passive tag ICs work | Sister item (b) territory. |
| Wake-from-zero latency (carrier-on -> first response) | < 1 ms typical, << reader scan cadence | `[Anabtawi-2016-BHI]` SMPS startup tracking is a journal-grade study point | Direct sister-(b) input. |

## F. Interaction with sister item (j) (eFuse / OTP)

The academic literature treats the UID storage as either:

- **Hard-wired in mask ROM** (`[Myny-2017-ISSCC]`) -- our default
  for v2 if (j) doesn't ship.
- **One-time-programmed in fuse / antifuse** (`[Lu-2016]` uses an
  EEPROM process; `[Bhattacharyya-2018]` likewise) -- maps to our
  `STORE-OTP-EFUSE` if (j) delivers >= 56 b for a 7-byte UID.

The `STORE-EFUSE-PARTIAL` sister architecture (full vCard
template in mask ROM, only personalisation fields in eFuse) does
**not** appear verbatim in the academic literature -- *because*
academic silicon papers are written about chips that ship payloads
defined by the customer post-fab, not by the chip designer at
tape-out. Our brief is the inverse, which is *easier* not harder.

## G. Sub-block <-> approach matrix

A compressed cross-reference for the Stage-2 synthesis agent. Rows
are sub-blocks, columns are protocol approaches. `Y` = required, `~`
= optional, `-` = not used.

| Sub-block | T2T | T2T-flex | T4T-A | T5T | T5T-implant | T2T+UWB |
|---|---|---|---|---|---|---|
| Tuning cap | Y | Y | Y | Y | Y | Y |
| Rectifier | Y | Y | Y | Y | Y | Y |
| OV clamp | Y | Y | Y | Y | Y | Y |
| LDO | Y | Y | Y | Y | Y | Y |
| Demod | Y | Y | Y | Y | Y | Y |
| Load mod | Y | Y | Y | Y | Y | -- (UWB uplink) |
| Manchester | Y | Y | Y | -- | -- | Y |
| Modified-Miller | Y | Y | Y | -- | -- | Y |
| 1-of-N PPM | -- | -- | -- | Y | Y | -- |
| BPSK on subcarrier | -- | -- | ~ (high rates) | -- | -- | -- |
| 7B UID anticoll | Y | Y | Y | -- | -- | Y |
| 15693 SLOT | -- | -- | -- | Y | Y | -- |
| FDT timer | Y | Y | Y | -- | -- | Y |
| CRC-A | Y | Y | Y | -- | -- | Y |
| CRC-15693 | -- | -- | -- | Y | Y | -- |
| ROM payload | Y | Y | Y | Y | ~ (sensor data) | Y |
| ISO 7816-4 APDU | -- | -- | Y | -- | -- | -- |
| Sensor AFE | -- | -- | -- | -- | Y | -- |
| UWB TX (impulse PA) | -- | -- | -- | -- | -- | Y |

## H. Stage-2 hand-off

The matrix above plus the gate-count and power-budget cross-checks
in section A-E should let the Stage-2 agent draft a *common*
sub-block manifest across our protocol-shortlist that the Stage-3
deep-dive agents can extend block-by-block.

The single biggest **architectural decision** that academic-silicon
literature does *not* settle for us is whether to use mask-ROM
(`[Myny-2017-ISSCC]` style) or eFuse-overlay
(`[Lu-2016]`/`[Bhattacharyya-2018]` style) for the payload. That is
because no academic paper has the same constraint we do (chip
designer chooses payload at tape-out). The gating dependency on
sister item (j) is therefore the right question to ask in
Stage 2.