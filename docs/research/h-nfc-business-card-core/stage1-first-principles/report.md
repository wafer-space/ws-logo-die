---
item: h
item_name: nfc-business-card-core
stage: 1
angle: first-principles
researcher: stage1-first-principles-1
status: draft
last-updated: 2026-05-03
---

## 1. Executive summary

Five tag-protocol candidates compared (T1T, T2T, T4T, T5T, plus a
RAW baseline floor); three modulation/encoding combinations;
three architectural axes (mask-ROM payload, eFuse-loaded,
reader-writable); three clocking strategies.

Headline conclusions:

1. **The carrier itself supplies sufficient timing for a TX-only tag
   emitting at fc/16 = 847.5 kHz (Type-2) or fc/64 = 211.875 kHz
   (NFC-V).** An on-die oscillator (item (a)) is **not required**
   for NFC tag emulation provided the digital baseband is fully
   synchronous to the rectified carrier. **(h) is decoupled from
   (a).** This is possibly the largest single cross-cutting
   decoupling in the entire TODO graph.
2. **Load-modulation depth is dominated by mutual inductance, not
   modulator R_DSon.** For a credit-card antenna at typical phone-
   tap distances (≤ 20 mm), shunting a Q≈30 antenna with
   R_mod = 2 kΩ produces ~13.5 mV per sideband on the reader
   coil — comfortably above ISO 14443-2 §8.2.1's "few-mV minimum
   sideband" requirement. R_mod = 100 Ω overkills modulation depth
   at 5× the dissipation cost.
3. **Minimum-viable read-only `T2T` baseband:** ~1,500–2,000 gates
   hand-tight RTL, ~3,500–5,000 gates synthesised. `T4T` is ~2×.
4. **Most surprising finding:** dropping anticollision is **not
   safe** even in a single-tag system. Real phone readers (Android
   `NfcAdapter.enableReaderMode()`, iOS Core NFC) require the
   anticollision handshake to complete before exposing the tag as
   `Ndef`-readable. The handshake itself, with a fixed UID, is only
   ~150 gates — much cheaper than I expected.
5. **NDEF vCard payload range:** 70–256 bytes for any realistic
   business card. Embedded photo blows past 1 kB. eFuse capacity
   (item (j)) of 256–2048 bits = 32–256 bytes is **not enough** for
   a useful full vCard. The realistic split: **mask-ROM holds the
   vCard template + NDEF wrapper, eFuse holds only personalisation
   fields** (`PAY-EFUSE-PARTIAL`).

Limits on the search: this is the first-principles angle, so I have
not surveyed commercial NFC tag IC datasheets or academic papers in
detail — that's the parallel surveys' job.

## 2. Requirements as understood

| ID | Requirement | Source |
|---|---|---|
| R-h-1 | Polled by NFC reader → respond with NDEF vCard | TODO.md item (h) goal |
| R-h-2 | Passive operation; powered by (b) rectifier; no external passives | TODO.md vision; constraint #2 |
| R-h-3 | Lives on harvested rail, not VGA `DVDD` | TODO.md item (i) goal |
| R-h-4 | Respond within ~5 ms of carrier application; FDT_PICC = 1172/fc = 86.4 µs | ISO 14443-3; Android scan cadence |
| R-h-5 | Top-metal logo preserved | TODO.md constraint #1 |
| R-h-6 | VGA pads frozen; new pads from unused-pad budget | TODO.md constraint #3 |
| R-h-7 | Phone-readable: Android `NfcA`/`Ndef`/`IsoDep`, iOS `NFCNDEFReaderSession` | TODO.md item (h) verify |
| R-h-8 | Payload ≥ vCard; programmability is itself a research question | TODO.md item (h) plan #3 |
| R-h-9 | Gated by harvester start-up (b), eFuse infra (j) if used | TODO.md dependency graph |

## 3. Solution-space map

### 3.1 Tag-protocol candidates (five distinct)

| Short name | Standard | Modulation | Subcarrier | Bit rate | NDEF | Phone support |
|---|---|---|---|---|---|---|
| `T1T` | ISO 14443A + NFCF Type 1 | OOK + Miller | 847.5 kHz | 106 kbit/s | yes | Android yes, iOS NDEF only |
| `T2T` | ISO 14443A + NFCF Type 2 | OOK + Manchester | 847.5 kHz | 106 kbit/s | yes (NTAG-class) | **Ubiquitous** |
| `T4T` | ISO 14443A or B + NFCF Type 4 | OOK Man (A) / BPSK (B) | 847.5 kHz | 106 / 212 / 424 / 848 kbit/s | yes (ISO 7816) | Android yes (`IsoDep`), iOS yes |
| `T5T` | ISO 15693 / NFC-V | OOK + 1-of-256 or 1-of-4 PPM | 423.75 / 484.28 kHz | 1.65 / 26.48 kbit/s | yes | Android yes (`NfcV`), iOS partial |
| `RAW` | non-standard floor | OOK on raw 13.56 MHz | none | freely chosen | no | none |

`RAW` is included as the "simplest dumb" boundary case (methodology
requires both spectrum ends). It does **not** solve the brief but
bounds the gate-count floor at ~200 gates.

### 3.2 Modulation / encoding combinations

For 14443A: `MOD-OOK-MAN` (Manchester), `MOD-OOK-MIL` (modified-
Miller), `MOD-BPSK` (14443B and higher rates). For ISO 15693:
`MOD-1OF256` (slow, big margin), `MOD-1OF4` (faster).

### 3.3 Payload-storage architecture (five distinct)

- **`PAY-MASKROM`** — fixed at tape-out, synthesised constants.
- **`PAY-EFUSE`** — entire payload from eFuse (depends on (j)).
- **`PAY-EFUSE-PARTIAL`** — wrapper mask-ROM, only personalisation
  fields from eFuse. **Realistic compromise.**
- **`PAY-RAM-RW`** — SRAM-backed, reader-writable. ~2.4× digital area.
- **`PAY-RAM-RW-AUTH`** — RAM-RW + password. ~2.5× digital area.

### 3.4 Clocking architecture

- **`CLK-CARRIER`** — divide rectified carrier (fc / N, N ∈ {16, 64,
  128}). No internal osc needed.
- **`CLK-INT`** — on-die RC osc (item (a)). **Eliminated** — ±5 %
  drift cannot decode 106 kbit/s Manchester (1000× worse than
  14443-2's ±50 ppm requirement).
- **`CLK-HYBRID`** — slow internal osc for response buffer, carrier-
  derived for modem.

### 3.5 Anticollision strategy

- **`AC-NONE`** — REQA → ATQA → stream NDEF. **Phones reject.**
- **`AC-FIXED-UID`** — full handshake, hard-wired UID. ~150 gates.
- **`AC-EFUSE-UID`** — same with per-die eFuse UID.
- **`AC-FULL`** — multi-tag collision resolution. Not needed.

## 4. Sub-block breakdown

See [`components.md`](components.md).

## 5. First-principles sanity checks

### 5.1 Load-modulation depth derivation

Reader requirement (ISO 14443-2 §8.2.1.2): few-mV sideband on
reader coil min. Card-side antenna model (4-turn loop, 80 × 50 mm,
L_ant ≈ 2.5 µH, R_ant ≈ 1 Ω at fc):

```
ωL_ant = 213 Ω; Q_unloaded = 213; Q_loaded ≈ 30
V_ind/turn at H=5 A/m: 2.14 V; total 8.6 V
V_antenna_pk = 8.6 × Q_loaded ≈ 257 V_pk_unclamped
```

The 257 V_pk unclamped is why item (b)'s overvoltage clamp design
is first-order, not an afterthought. With a working clamp at
V_clamp_pk ≈ 4 V, antenna swing is bounded.

Modulator switch R_mod = 100 Ω collapses Q to 0.47; R_mod = 2 kΩ
drops to ~9 (mild reduction). 2 kΩ is the production-realistic
choice (commercial tag ICs cluster here).

Reflection back to reader at k ≈ 0.10:
```
M = 0.194 µH; ω²M² = 273 Ω²
ΔZ_refl = 0.094 Ω
ΔV_reader_envelope ≈ 28 mV_pk envelope step
```

Sideband amplitude at fc ± 847.5 kHz is ~14 mV per sideband —
comfortably above the ISO 14443-2 minimum.

### 5.2 Modulator power dissipation

Modulator-on, antenna voltage clamped to V_clamp_pk = 3 V:
```
P_mod_on = 9 / (2·R_mod)
        = 2.25 mW (R_mod = 2 kΩ)
        = 45 mW   (R_mod = 100 Ω)
P_mod_avg ≈ 25-50% × P_mod_on
        ≈ 0.56 mW (R_mod = 2 kΩ) → acceptable
        ≈ 11 mW   (R_mod = 100 Ω) → 10× harvester budget
```

### 5.3 Framing-protocol gate counts (`T2T` minimum-viable)

| Block | Gates |
|---|---|
| Manchester decoder | ~60 |
| fc/16 prescaler | ~32 |
| Subcarrier modulator gate driver | ~10 |
| CRC-A 16-bit shift-XOR | ~80 |
| FDT timer (1172/fc, 11-bit counter) | ~88 |
| ATQA shifter | ~64 |
| Anticollision comparator | ~40 |
| SAK shifter | ~32 |
| READ block-addr parser | ~50 |
| ROM addr mux + 64-byte LUT | ~250 |
| Bit serializer | ~40 |
| Top-level FSM | ~120 |
| Field-detect / POR | ~50 |
| **Sub-total** | **~916** |

Synthesis overhead → ~1,500–2,000 hand-tight, ~3,500–5,000 conservative.

### 5.4 NDEF vCard payload size

| Tier | Content | Total Type-2 layout |
|---|---|---|
| Minimal | name + email | ~125 B (8 blocks) |
| Moderate | vCard 2.1 + phone + email + URL | ~240 B (16 blocks) |
| Maximal | vCard 4.0 + base64 photo | exceeds T2T 924-byte ceiling; needs T4T |

vCard 2.1 wins ~30 B over vCard 4.0 for the same semantic content.

### 5.5 Timing budget — carrier on to first response

ISO 14443A FDT_PICC = 86.4 µs. Path from carrier-on to ready:
LC settling ~700 ns + rectifier charging ~600 ns to 3 V + brown-
out release. Reader sends REQA typically 5-10 ms after
antenna-power-on. **Harvester (b) start-up of ~1-10 µs is much
faster than reader's tag-detection wait.** The hard FDT_PICC
constraint of 86.4 µs is trivial at 13.56 MHz logic.

### 5.6 Modulation-scheme BER

At 14 mV sideband / reader LNA noise floor 100 µV/√Hz × √(1 MHz)
= 100 µV_rms: SNR = 42.9 dB; BER (coherent OOK) < 1e-10.
**~38 dB margin** vs target 1e-4. OOK-vs-BPSK choice is moot at
this SNR.

### 5.7 Self-clocking implications

If carrier dies mid-frame: τ_rail = (V_rail/I_load)·C_storage
= (3/1e-3)·1e-9 = 3 µs → digital resets, half-sent frame
corrupted. Acceptable failure mode (reader retries).

**Implication for item (a):** for the NFC function alone, no
internal oscillator needed.

### 5.8 Programmability gate-count multiplier

Read-only baseline: ~2,000 gates. Adding RAM-RW: +2,560 gates SRAM
as flops + ~270 gates write handler = 2.4× multiplier. With proper
SRAM macro: ~1.5×. Adding password: +240 gates → ~2.5× total.

### 5.9 Phone compatibility envelope

| Tag type | Android API min | iOS min | Notes |
|---|---|---|---|
| `T1T` | 10 | iOS 13 | Becoming rare |
| `T2T` | 10 (`NfcA`+`Ndef`) | iOS 11 | **Ubiquitous** |
| `T4T-A` | 10 (`IsoDep`) | iOS 13 | Banking-app-friendly |
| `T4T-B` | 10 | iOS 13 | Patchier reader-chip support |
| `T5T` | 10/21 NDEF | iOS 13/17 | Patchy iOS pre-17 |

## 6. References

See [`references.md`](references.md). Anchored standards
(ISO/IEC 14443-2, -3, -4; ISO/IEC 15693-3; NFC Forum Type 1/2/4/5
Tag Operation Specifications) and platform-API docs.

## 7. Negative results

**7.1 — Eliminating anticollision in single-tag systems.** Android
`NfcAdapter.enableReaderMode()` requires successful SELECT before
exposing the tag as `Ndef`. `AC-NONE` eliminated.

**7.2 — ISO 14443B-only `T4T-B` tags.** Broadcom NFC controllers in
many flagships have 14443B disabled in firmware. `T4T-B`-only path
eliminated for R-h-7.

**7.3 — Reader-writable without auth.** Anyone tapping the card
overwrites with malicious URLs. `PAY-RAM-RW` (no auth) eliminated;
`PAY-RAM-RW-AUTH` retained.

**7.4 — Internal oscillator as sole NFC clock.** GF180MCU RC osc
drifts ±5 % over PVT — 1000× worse than 14443-2's ±50 ppm
requirement. Cannot reliably sample 106 kbit/s Manchester.
`CLK-INT` eliminated for the modem function.

**7.5 — NTAG-216-style 924-byte memory in eFuse.** 7,104 bits eFuse
— well beyond (j)'s projected 256-2048 bits.

**7.6 — Aggressive shunt modulator (R_mod ≈ 100 Ω).** §5.2 shows
this dissipates ~11 mW average — 10× the realistic harvested-power
budget. Eliminate.

**7.7 — Crystal-stabilised internal osc.** Out of bounds (no
external passives).

## 8. Open questions

See [`open-questions.md`](open-questions.md). 12 total; top-
priority: Q1 GF180MCU SRAM-macro availability; Q2 actual eFuse
capacity from (j); Q3 (b) rectifier tolerance to modulator-induced
antenna shorts; Q4 iOS Core NFC `T2T` interop gotchas; Q9 PCB
antenna L_ant verification by EM-sim.

## 9. Comparison readiness

| Stack | Headline | Area / power | Maturity | Best fit |
|---|---|---|---|---|
| `T1T` + masked + free-UID | 106 kbit/s, 64-256 B | ~1.4k gates, 0.5 mW peak | Mature 2007 | Smallest area |
| `T2T` + masked + free-UID | 106 kbit/s, 64-924 B | ~1.5-2k gates, 0.5 mW | Mature (NTAG) | **Best phone-compat × area** |
| `T2T` + eFuse-partial + eFuse-UID | 106 kbit/s, personalisable | ~1.7-2.2k gates + eFuse | Mature | Per-die unique cards |
| `T2T` + RAM-RW-AUTH + eFuse-UID | + reader-writable | ~5k gates incl. flop SRAM | Mature (NTAG-21x) | Field-rewritable |
| `T4T-A` + masked + free-UID | 106-848 kbit/s, ≥1 kB | ~3-7k gates | Mature (banking) | Photo embedded |
| `T5T` + 1-of-256 + masked | 1.65 kbit/s, ~10 cm range | ~1.4k gates, sub-mW mod | Mature (industrial) | Long-range read |
| `RAW` + OOK + masked + no-AC | Unstandardised | ~200 gates | N/A | Calibration only |

## 10. Author's notes

- 257 V_pk unclamped antenna voltage shocked me until I remembered
  that NFC cards must clamp aggressively — this is why item (b)
  flags clamps as first-order.
- I expected dropping anticollision to save hundreds of gates. It
  saves ~150. ROM payload and prescaler dominate either way.
- **The carrier-derived clock proposition is much stronger than I
  expected.** Once committed, item (a)'s oscillator becomes
  irrelevant for this block.
- vCard 4.0 is ~30 B more than vCard 2.1 for the same semantic
  content. For a fixed-size eFuse budget, vCard 2.1 wins.
- The brief's "essentially doubles digital complexity" for write-
  capable cards is conservative; real multiplier is ~2.5× without
  an SRAM macro, ~1.5× with.
