# Components — sub-block inventory (item h, Stage 1 first-principles)

## Common to all candidates

1. Antenna interface (shared with (b)) — diff bond pads, MIM tuning
   cap bank ~30–100 pF, ESD/OV clamp.
2. Rectifier + rail regulator — item (b)'s deliverable; consume its
   1.5–3.3 V.
3. Modulator transistor — NMOS shunt across antenna; sized per
   §5.1; R_mod = 2 kΩ recommended.
4. Carrier-clock recovery — high-speed comparator on one antenna
   pin → digital 13.56 MHz square wave; divide-by-16/64/128
   prescaler.
5. Internal oscillator — only `CLK-INT`/`CLK-HYBRID`; from item (a)
   (eliminated for the modem function in §7.4).
6. POR / reset / brown-out (rail > ~1.2 V) + field-detect.
7. Digital baseband (per-protocol below).
8. Payload store (per §3.3).

## Per-candidate digital baseband

`T1T`: REQA/WUPA poller; ATQA shifter; T1T command handler
(RID/RALL/READ/WRITE-E/WRITE-NE); NDEF-T1 TLV reader; CRC-B engine.

`T2T` (recommended baseline): REQA/WUPA poller; ATQA (16-bit
constant 0x4400); SELECT cascade (1 level for 4-byte UID, 2 for
7-byte); READ block handler; NDEF-T2 capability container @
block 3; TLV walker; CRC-A 0x1021; FDT_PICC timer.

`T4T`: T2T blocks + ATS shifter + ISO 14443-4 block-protocol layer
(PPS, I/R/S blocks) + ISO 7816-4 file system (SELECT FILE, READ
BINARY, NDEF Tag App with CC file 0xE103 and NDEF file 0xE104) +
CID/NAD handling.

`T5T`: Inventory cmd handler (1-slot or 16-slot); Read-Single /
Multiple-Block handler; 1-of-256 or 1-of-4 PPM modulator (~150
gates); CRC-15693 (different polynomial from CRC-A); NDEF-T5 CC.

## Payload store sub-blocks

| Architecture | Storage element | Read path | Write path | Gate count |
|---|---|---|---|---|
| `PAY-MASKROM` | Synthesised LUT | Direct addr→data | none | ~8 gates/byte |
| `PAY-EFUSE` | eFuse macro from (j) + serial readout shifter at PoR | Mux + flop array | Charge pump + program FSM (~200 gates) | ~5 gates/byte + macro |
| `PAY-EFUSE-PARTIAL` | eFuse personalisation (~64 B) + mask-ROM wrapper (~256 B) | Mux at TLV walker | Program-time only | ~10 gates/byte (mux) + macro |
| `PAY-RAM-RW` | Stdcell flop array or SRAM macro | Same as ROM | WRITE handler ~270 gates + storage ~5 NAND/bit | 64 B → ~2,560 gates as flops, ~500 gates as SRAM |
| `PAY-RAM-RW-AUTH` | Above + 32-bit password store + lock bits | + auth gate | + 32-bit comparator (~80 gates), lock-bit FSM (~100), auth state (~60) | +240 gates over `PAY-RAM-RW` |

## Anticollision sub-blocks

| Architecture | Components | Gate count |
|---|---|---|
| `AC-NONE` | (none) | 0 |
| `AC-FIXED-UID` | UID compare, bit pump, BCC generator | ~150 gates |
| `AC-EFUSE-UID` | Above + eFuse readout (already counted in `PAY-EFUSE`) | ~150 gates incremental |
| `AC-FULL` | Multi-tag collision resolution | ~400 gates (not needed) |

## Cross-block dependencies

```
(h)NFC-core ─── L_ant, C_tune ──→ (b)NFC-harvester
            ─── modulator share ─→ (b) rectifier (must tolerate antenna shorts)
            ─── harvested rail ──→ (i) power-domain isolation
            ─── eFuse readout ───→ (j) OTP infrastructure
            ─── tuning cap bank ─→ (e) MIM caps
            X─── (does NOT depend on) ─X (a) internal oscillator
```

The "does NOT depend on (a)" arrow is a Stage-1 first-principles
finding (see report.md §5.7) — possibly the largest single
cross-cutting decoupling in the entire TODO graph.
