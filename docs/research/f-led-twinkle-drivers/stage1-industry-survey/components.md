# Components — sub-block breakdown (item f, Stage 1 industry-survey)

Cross-references the topology IDs from `report.md` §3.

## Per-topology block lists (industry-mapped)

**T1 (resistor ballast + switch).** As cpldcpu's RE'd dies show,
no separate "resistor" exists in commodity candle-flicker LEDs:
the on-die NMOS switch is sized W/L to act as the current-limiting
element. Blocks: pre-driver (1-2 inverters), W/L-tuned NMOS pull-
down (50-100 µm typ), optional eFuse W-trim FETs in parallel.

**T2 (constant-current sink, TLC59xx-class).** Bandgap reference
(50k µm² in 180 nm); ref-resistor (10-100 kΩ); cascode mirror;
output FET; pre-driver; PWM gate; quiescent current 1-3 mA per
the closest TI-family datasheets — *over budget for our use case*.

**T3 (current-DAC + PWM, BC/DC).** All of T2 + binary-weighted
6-bit DAC tail (matched mirrors); 7-bit BC register; 12-bit PWM
counter (TLC59281-style).

**T4 (charge-pump bucket-dump).** Bucket MIM cap 5-50 nF;
high-side PMOS (rail→bucket, ~50 µm W); low-side NMOS
(bucket→LED→GND, ~80 µm W); non-overlap 2-phase clock; pre-
drivers; (opt) series resistor for I_peak limit; brown-out
comparator hooked to V_bucket > V_f. *Industry referent: NFC tag
field-LED drivers.*

**T6 (Dickson + bucket-dump).** All of T4 + 2nd flying MIM cap;
3-phase non-overlap clock; 2 series-mode switches; gate-bootstrap
to handle the elevated rail. *Industry referent: EEPROM Vpp pumps
(every modern microcontroller).*

**T7 (direct switch).** Wide switch FET sized for worst-case PVT
(100-200 µm W); pre-driver; (strongly rec.) eFuse-trimmable W via
parallel-FET strapping. *Industry referent: 2024 candle-flicker
LED's PIC12-like port driver.*

## Pad-cell block (all topologies)

- **`gf180mcu_fd_io__asig_5p0`** — passive analog pad. Internal:
  4-finger DVSS→PAD diode (`diode_nd2ps_06v0`, AREA=150 fF·m²),
  4-finger PAD→DVDD diode (`diode_pd2nw_06v0`, same), 4-finger
  DVSS→DVDD ESD clamp diode, plus a 36-instance MOS-cap
  (`cap_nmos_06v0`, 15×15 µm) decoupling DVDD to DVSS. **No active
  driver; no level shifters.** Verified at
  `gf180mcu_pdk/gf180mcuD/libs.ref/gf180mcu_fd_io/cdl/gf180mcu_fd_io.cdl`
  lines 15-37.
- **`gf180mcu_fd_io__bi_24t`** — 24 mA fixed-strength push-pull
  bidir pad. Inputs: A (data), OE (output-enable), IE (input-
  enable), CS (cell select), SL (slew-rate select), PU/PD (pull-
  up/down enable). Output: Y (input back-buffer). Drive_current =
  24,000 µA per LIB. Cell area 75×350 = 26,250 µm². Already used
  by VGA outputs in v1.
- **`gf180mcu_fd_io__bi_t`** — same as `bi_24t` but with extra
  PDRV0/PDRV1 inputs selecting 8/16 mA. Otherwise architecturally
  identical. Same area.
- **`gf180mcu_fd_io__brk2`/`brk5`** — pad-ring break cells (rail
  isolation gaps); needed at the boundary between the existing VGA
  power-domain pads and the new harvested-rail pads. *Critical for
  item (i).*

## Pattern-generator blocks (algorithm-cross-referenced)

- **PAT-1 (LFSR → PWM duty).** N-bit LFSR (24 b ≈ 70 gates per
  IND-FP estimate; 17 b minimum for non-perceptible-period at
  ~13 Hz update); top M bits of LFSR → PWM duty register; PWM
  comparator + counter (8-12 b).
- **PAT-2 (rejection-sampling).** 8-bit LFSR + comparator against
  a 12-entry brightness threshold table (mask-ROM). Per cpldcpu's
  RE: ≤4 attempts to land in the desired histogram.
- **PAT-3 (sine LUT).** 8×4-bit ROM + 8-bit phase accumulator. ≤50
  gates.
- **PAT-4 (Perlin / value noise).** 8-bit gradient table (mask-ROM
  64 entries) + 16-bit interpolator + smoothstep ROM. 200-300
  gates.
- **PAT-5 (random-walk integrator).** 8-bit LFSR + 8-bit
  accumulator with saturation; ~100 gates.
- **PAT-6 (sigma-delta).** 1st-order ΔΣ: 8-bit accumulator +
  carry-out → switch enable. With dither: + 4-bit LFSR XOR'd into
  LSBs (per EP2081414).
- **PAT-7 (mask-ROM table).** Per-time-step mask ROM (1024 entries
  × 4-6 b); pointer counter. Cost ≈ 4-6 kbit ROM = significant.
- **PAT-8 (phase-stagger).** Trivially: invert the PWM clock for
  LED2 vs LED1 (or use a 90°-shifted counter). Halves rail ripple
  for pulsed topologies.

## Shared infrastructure

- Brown-out comparator on V_rail (intrinsic to (e)/(i)).
- Per-LED enable from harvested-rail power-good signal (so the LEDs
  are dark in VGA-only mode).
- Optional eFuse interface for pattern-select / brightness-cap
  (depends on (j); 4-8 b per LED suffices).
- Two output bond pads — recommended `asig_5p0` (per `report.md`
  §"Recommended pad cell"); fallback `bi_24t`.
