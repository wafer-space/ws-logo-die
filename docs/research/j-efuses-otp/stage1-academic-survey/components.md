# Sub-block breakdown — academic angle

For each silicon-paper-anchored OTP topology, list the sub-
blocks an implementation would need. Numbers are sourced from
the anchor papers in `solutions.md` and `references.md`.

## Common to all OTP families

| Block | Function | Reference |
|---|---|---|
| Bit-cell array | The OTP element itself, replicated NxM | all anchors |
| Row decoder | Selects WL during program / read | Robson 2007 CICC |
| Column mux + bit-line driver | Selects BL; provides program-current path | Tonti 2003 BPM |
| Sense amp | Discriminates intact vs programmed | Kim 2011 JSTS |
| Programming-control FSM | State machine for program flow | Tonti 2003 §"Pgm Optimization" |
| Test-mode entry mux | Selects program vs read on existing pads | TODO §j R-J5 |
| Lock register | Permanent disable of program path | Cha 2011 IEDM |
| Brown-out detector | Inhibits read during low-rail | Robson 2007 CICC §3 |
| Optional ECC encoder/decoder | Multi-bit error correction | Mukhopadhyay 2008 DSN |

## POLY-EFUSE-COSI2 specifics

| Block | Function | Sizing reference |
|---|---|---|
| eFuse PCell | `gf180mcu_fd_pr__efuse` | PDK Magic gencell |
| Programming pass-NMOS | 5 mA at V_DS ≈ 1 V; 5 V tox | W ≈ 33 µm at 0.18 µm; Kothandaraman 2002 |
| Read pull-up resistor | Sets I_read ≈ 10 µA at intact-fuse trip | poly resistor; Tonti 2003 |
| Reference fuse OR poly resistor | Half-way between intact (~200 Ω) and trip (~2.5 kΩ) | Choi 2012 JCSU differential-paired |
| 25-pulse train generator | 10 µs on / 10 µs off × 25 | Tonti 2003 Fig 5a |
| Latch with hysteresis | Captures sense output | Tonti 2003 BPM |

## ANTIFUSE-2T / 3T specifics (NOT shipped in `gf180mcuD`)

| Block | Function | Sizing reference |
|---|---|---|
| Antifuse transistor | Thin-oxide PMOS or NMOS | Wang 2014 ASICON |
| Access transistor | Standard logic transistor | Wang 2014 |
| Block transistor (3T only) | High-V isolation | Lee 2011 JSTS |
| Charge pump | 5 V → 9 V Dickson, 1 mA load | sister first-principles §5.3 |
| Pump cap stack | 2 × 10 pF MIM | sister first-principles §5.3 |
| Sense amp | Differential vs reference cell | Wang 2014 |
| Read-disturb monitor | Tracks gate-oxide ageing | Stathis 2001 IRPS |

## FG-OTP-SINGLE-POLY specifics (NOT shipped in `gf180mcuD`)

| Block | Function | Sizing reference |
|---|---|---|
| Floating-gate PMOS pair | Stores charge, modulates I_D | Holleman 2007 WVU |
| Coupling cap (MIM) | Couples control voltage to FG | Hasler 2005 GA-Tech |
| Tunnelling injector (MOS-cap) | FN tunnelling site | Holleman 2007 §3 |
| Bias generator | Sets read I_D for matched programmed/unprogrammed reads | Holleman 2007 §4 |
| FN-program cap pump | 5 V → 6.4 V single-stage Dickson | sister first-principles §5.6 |

## ECC vs redundancy decision

For ≤ 200-bit OTP at 99.97% time-zero programming yield (Tonti
2003 E-Fuse B), expected bit-errors per array = 0.06.

- **No protection:** P(any bit error) = 1 − (0.9997)²⁰⁰ ≈
  6 % — **unacceptable** for chip-ID critical bits.
- **3-fuse vote** on critical 32-bit ID: P(error) = 1 −
  (1 − 0.0003³)³² ≈ 8.6×10⁻⁷ — acceptable. Area cost: 3× on
  protected bits.
- **Hamming(15,11) SEC** on full 200-bit array: 36% area
  overhead. Single-bit-correction handles 1 random fail; cannot
  handle correlated programming-yield failures.
- **Reed-Solomon GF(2⁵)(32,28)** on full 256-bit array: 14%
  overhead. Best for clustered programming failures — but the
  decoder is non-trivial (~1000 gates).

**Recommendation (academic):** 3-fuse-vote on critical trim
(8 bits) and ID (32 bits); single-fuse on non-critical
payload. Total fuses: 3×40 + (200-40) = 280 fuses ≈ 14 000 µm².
**Within budget.**

## Programming-control FSM states

Per Tonti 2003 BPM design (Fig 4) and Robson 2007 CICC §3:

1. `IDLE` — chip operating normally; OTP read-only
2. `TEST_MODE_DETECT` — strap pattern on existing pads
3. `LOAD_DATA` — shift register load via DQ pad
4. `PROGRAM_PULSE_TRAIN` — 25 × 10 µs pulses with 10 µs gaps
5. `VERIFY_READ` — sense each programmed bit
6. `RE_PROGRAM` — additional pulse if intact (yield recovery)
7. `LOCK` — set lock fuse to prevent further programming
8. `RETURN_TO_IDLE`

The `RE_PROGRAM` state is the *yield-recovery* mechanism that
Tonti 2003 implies but doesn't explicitly name. **It is the
single biggest test-flow improvement** for screening out the
80 % E-Fuse A-style fragility risk: any fuse that doesn't sense
as programmed after the first 25-pulse train gets a *second*
train. Most failed-to-blow bits will succeed on the second
pass; the small remaining tail can be ECC-handled or the chip
binned out.
