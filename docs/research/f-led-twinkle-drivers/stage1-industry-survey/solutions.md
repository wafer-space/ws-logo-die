# Solutions catalogue (item f, Stage 1 industry-survey)

## Driver topologies (T1-T7 cross-shared with first-principles report)

| Short | Topology | Industry source | Naïve / sophisticated |
|---|---|---|---|
| T1 | On-die ballast resistor + switch | candle-flicker LED dies (cpldcpu RE 2013-14) | Naïve |
| T2 | Constant-current sink + internal Iref | TI TLC5947, TLC59281, TLC5926 | Conventional |
| T3 | Current-DAC + PWM (BC/DC trim) | TI TLC59281 | Conventional+digital |
| T4 | Charge-pump bucket-dump | NFC tag IC field-LEDs; TI TIDA-00998 (scaled) | Less common |
| T5 | Boost converter w/ inductor | LT3593, MAX1561/99, MCP1640 | **Rejected (PDK)** |
| T6 | Switched-cap (Dickson) + bucket | EEPROM Vpp pumps, NFC tag pumps | Mature analog |
| T7 | Direct switch (no ballast) | 2024 candle-flicker MCU LED (cpldcpu 2024) | Simplest |

## Industry-only entries

| Short | Topology | Industry source | Notes |
|---|---|---|---|
| IND-A1 | Dual RC + rejection-sampling pattern | candle-flicker LED (cpldcpu 2013) | 12 brightness levels, ~50 % at max |
| IND-A2 | RC + LFSR + 9-stage divider | candle-flicker LED (cpldcpu 2014) | ~30 FF, single RC osc |
| IND-A3 | Embedded OTP MCU + sleep timer | candle-flicker LED (cpldcpu 2024) | 240 µA sleep; 1 MHz core |
| IND-B | Off-chip pattern IC | FR1001 / FR1002 | Drives external N-FET; 5 V VCC |
| IND-C | NFC tag field-LED driver | NXP NTAG21xF; EM4423 | Sub-mA, NFC-field-gated |
| IND-D | Sigma-delta / PDM brightness | EP2081414 (NXP); auto LED drivers | Density-modulated |
| IND-E | Energy-harvest PMIC ref-designs | BQ25505/70, MAX20361, TIDA-00242/998 | Upstream context |
| IND-F | `asig_5p0` pad (passive ESD-only) | GF180MCU PDK | Pad choice |
| IND-G | `bi_24t` pad (24 mA push-pull) | GF180MCU PDK | Pad choice |
| IND-H | `bi_t` pad (8/16 mA programmable) | GF180MCU PDK | Pad choice |
| IND-I | Open-source (Tiny Tapeout, OpenCores) | LED panel/matrix drivers | No direct match |

## Twinkle-pattern algorithms

| ID | Algorithm | Industry source | Notes |
|---|---|---|---|
| PAT-1 | LFSR pseudorandom → PWM duty | cpldcpu 2014; FR1002 | Most common; 17-31 b LFSR sized for non-repeat |
| PAT-2 | Rejection-sampling onto histogram | cpldcpu 2013 | Produces "candle flame" specific look |
| PAT-3 | Sine-table lookup ("breathing") | Apple sleep LED, US 7,031,420 | Smooth periodic, *not* organic-twinkle |
| PAT-4 | Perlin / value-noise | FastLED library; LED art installations | More expensive; arguably overkill |
| PAT-5 | Brownian / random-walk integrator | hobby fairy-light sketches | Low-pass filtered LFSR |
| PAT-6 | Sigma-delta noise-shaped brightness | EP2081414 (NXP) | Higher fundamental f; lower rail ripple |
| PAT-7 | Embedded MCU + table + dither | cpldcpu 2024 (PIC12-class) | Arbitrary patterns, OTP storage cost |
| PAT-8 | Two LEDs × phase-staggered | architectural lighting fixtures | Halves rail ripple in T4/T6 |

**Total topologies: 7 driver topologies (1 explicitly rejected on
PDK grounds, T5) + 11 industry-only entries (3 candle-flicker
generations IND-A1/A2/A3, FR1001/1002, NFC-tag field-LED, PDM
modulator, energy-harvest PMIC reference, three pad-cell choices,
open-source survey).**

**Total pattern algorithms: 8** (≥ 4 bar exceeded).

## Comparison-readiness table

| Approach | Headline | Area / power | Maturity | Best fit | Worst fit |
|---|---|---|---|---|---|
| T1 | η = V_f/V_rail; ±30 % I PVT | ~10k µm² | Trivial | Red/orange/yellow on intermittent rail | Blue/white |
| T2 | Constant I; 0.4-1.5 V headroom; 1-3 mA Iq | ~50k µm² + bandgap | Mature commercial | Display matrices on stiff rail | µW-mW harvested |
| T3 | T2 + per-LED trim DAC | T2 + ~5k µm² + counter | Mature | Multi-LED matched | Single-LED energy-budgeted |
| T4 | η ≈ 50 %; 1000× rail-coupling reduction; brown-out smooth | 10 nF MIM **~5 mm² @ 2 fF/µm²** (corrected 2026-05-04 from "~50k µm²" with 100× cap-arithmetic error; bucket cap must shrink to ≤4 nF or move off-die) + 2 sw | RFID/NFC IC tradition | Brown-out-prone rails | Steady illumination |
| T5 | n/a | impossible on this die | **Rejected** | n/a | Everything |
| T6 | η ≈ 30-40 %; drives blue/white | T4 + 1 cap + 3 sw | Mature (Dickson 1976) | Blue/white at 3.3 V | When red is sufficient |
| T7 | η = V_f/V_rail max; ±3× PVT | ~2k µm² | Trivial; 2024 candle-LED | Single colour, area-limited | Brightness uniformity |
| IND-A3 | OTP MCU; arbitrary patterns | ~0.5 mm² in 180 nm | Modern commercial | Flexible patterns | Strict ultra-low Iq |
| IND-D | PDM brightness; PAR1789-friendly | +3 FF +1 adder | Patented + textbook | When PWM-rate constrained | When PWM is plenty |
| IND-F | `asig_5p0` passive pad | 26,250 µm² | PDK std cell | Direct LED routing | When push-pull also needed |
| IND-G | `bi_24t` push-pull pad | 26,250 µm² | PDK std cell | Reuse v1 infrastructure | When current-source semantics |
