# Components — sub-block inventory (item j, Stage 1 first-principles)

## Polysilicon-silicide eFuse (FUSE-POLY-SILICIDE)

| Sub-block | Function | Estimated area | Notes |
|---|---|---|---|
| eFuse cell array | Bit storage | 49.4 µm² × N_bits (PDK bare); +1.6× overhead | PDK PCell `gf180mcu_fd_pr__efuse` |
| Programming pass-NMOS | 5 mA pulse driver per active column | 33 µm × 0.6 µm = 20 µm² per column | 6V-flavour `nfet_06v0` |
| Row decoder | Select 1-of-N row | log₂(N_rows) inverters + word-line drivers: 50–200 µm² | Standard cells |
| Column mux for prog | Steer 5 mA pulse to active column | one large NMOS per column | shared with programming pass-NMOS |
| Sense amp / read latch | Discriminate ~200 Ω vs ~10 kΩ trip | differential current-mirror SA + latch, ≈100 µm² per column | needs ref resistor |
| Reference resistor | Trip point | ~1 kΩ ppolyf_u_1k, ~50 µm² | from PDK resistors |
| Programming control FSM | Sequence pulse train (e.g. 25 × 10 µs) | ~500–1000 standard cells, ~1500–3000 µm² | std synthesis |
| Programming pad / TM mux | TM-EXISTING-PAD strap decode | ~50 µm² | reuses existing pads |
| Lock register | Prevent re-program | a few flops + irreversible "lock" eFuse | one extra bit |
| ECC encoder/decoder (opt) | Tolerate stuck-at fails | Hamming SEC-DED on 64-bit blocks: ~600 µm²/block + log | optional |

**Total at 106 bits, no NFC, with column-mux 8-wide:**
- Array: 106 × 79 = 8 400 µm²
- Programming circuits: ~3 000 µm²
- Sense / decoder / FSM: ~3 000 µm²
- **Total: ~15 000 µm² ≈ 0.015 mm²**

**Total at 1130 bits with full NFC payload, 16-wide column mux, SEC-DED:**
- Array: ~89 000 µm²
- Programming + decoders + 18-bit blocks ECC: ~25 000 µm²
- **Total: ~115 000 µm² ≈ 0.115 mm²**

## Antifuse — gate-oxide rupture (ANTIFUSE-GOX)

| Sub-block | Function | Estimated area |
|---|---|---|
| Antifuse cell (1T) | 3.3V NMOS w/ source/drain shorted, gate as antifuse top | ~6–8 µm² (custom — no PDK cell) |
| Select transistor (1T or 1.5T) | Isolate antifuse during read | shared with cell |
| **Charge pump (Dickson, 2-stage)** | 5 V → ~8 V, ~1 mA | ≈20 000 µm² for 2× 10 pF MIM caps (dominates area) |
| Charge-pump regulation | Trim Vprog | bandgap ref + comparator, ~500 µm² |
| Charge-pump clock | 10 MHz oscillator | self-clocked relax-osc: ~100 µm² |
| Programming pass-PMOS | Switch Vprog onto wordline | small (10 µm width) |
| Sense amp | Discriminate ~kΩ filament vs. open MOS cap | larger SA, read I in µA: ~150 µm²/col |
| Programming control FSM | Sequence Vprog ramp + soak | ~3 000 µm² |

**Pump-amortised costs make ANTIFUSE-GOX competitive only at >500 bits.**

## MASK-ROM (NFC payload only)

| Sub-block | Area |
|---|---|
| Metal-tied bit array | 2–4 µm² per bit |
| Address decoder / mux | folded into NFC RTL |

**At 1024 bits: ~3 000 µm² total. No programming infrastructure.**

## Common: programming-flow pad infrastructure

- **Test-mode strap decoder** (TM-EXISTING-PAD): 4–8 standard
  cells, ~50 µm². Reads `cfg_tile` / `rst_n` strap pattern at
  power-on to enter programming mode.
- **Programming-mode current/voltage source from `DVDD` rail**: a
  brown-out-aware enable signal that gates the programming path.
- **Power-on-reset / brown-out blocking**: ~200 µm² for a brown-
  out detector + program-enable latch with two-FF synchroniser.
- **Lock bit**: One eFuse that, once blown, irreversibly disables
  further programming. Cheap. **Do not omit.**

## Read-path (post-programming)

For the polysilicon eFuse:
- Sense amp activated only at chip POR or trim-refresh wakeup.
- ~10 µA per bit during sense; sense duration ~100 ns.
- Energy per read of 106 bits = 530 pJ.

## Bit-budget allocation

| Consumer | Min bits | Target bits | Max bits |
|---|---|---|---|
| Oscillator trim (a) | 4 | 6 | 8 |
| Die ID / serial | 32 | 64 | 96 |
| LED pattern (f) | 1 | 4 | 4 |
| Lock / calibration | 16 | 32 | 32 |
| **Subtotal (no NFC)** | **53** | **106** | **140** |
| NFC vCard (h) | 0 (mask-ROM) | 1024 | 2048 |
| **Total with NFC** | **53** | **1130** | **2188** |

Recommended Stage-2 default: **106 bits (no programmable NFC
payload), target the PDK eFuse, mask-ROM the vCard.**
