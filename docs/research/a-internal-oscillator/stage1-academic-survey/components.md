# Internal-oscillator -- Stage-1 academic-survey: sub-block breakdown

This file enumerates the sub-blocks each silicon-anchored academic
topology in [`solutions.md`](./solutions.md) requires. The deeper
academic literature reveals several blocks the industry-survey
sister report does not need to enumerate, because industry
implementations bury them inside trim cells or behind PLL macros.

For each topology family, the canonical block list is given,
followed by GF180MCU PDK availability notes (where they differ
materially from the industry-survey notes).

---

## AC-RC family (chopper / offset-cancelled RC)

### AC-RC-1 (Paidimarri / Chandrakasan swap-cap, 120 nW @ 18.5 kHz)

| Sub-block | Function | GF180MCU device |
|---|---|---|
| Bandgap voltage / current reference | Sets the comparator threshold ratio and the timing-cap charging current. Bandgap drift directly enters period drift. | Custom -- bipolar PNP plus n+ poly resistor. No PDK macro. ~3000 um^2. |
| Two MIM caps, swap-routed | Storage caps swapped each half cycle so that comparator offset cancels to first order. | `cap_mim_1f0fF`, `cap_mim_2f0fF`. ~2 fF/um^2; for 1 pF unit cap, 500 um^2 each. |
| Comparator (low-offset, mid-bandwidth) | Detects timing-cap voltage crossing the threshold. Offset is cancelled by the swap; residual offset (random) ~5 mV. | Custom diff pair + cross-coupled load. ~500 um^2. |
| Swap-state SR latch | Drives the cap-swap MOS switches at the start of each half cycle. | Standard cell `mcu7t5v0__sdfq_*` or hand-made; tens of um^2. |
| Cap-swap MOS switches | T-gates routing each MIM cap into the timing path or the reset path, swapped each half cycle. | NMOS pass + PMOS pass; minimum-W; sub-50 um^2 each. |
| Bias mirror | Generates a temperature-flat charging current from the bandgap. | NMOS+PMOS mirror with PTAT-cancelled bias. ~500 um^2. |
| Output edge detector + divider | Generates symmetric digital output. | Standard cells. |

**Net area:** ~6500 um^2 in 65 nm; on GF180MCU 180 nm, scale by
~3x area = ~20000 um^2 = 0.02 mm^2.

**Net power:** 120 nW at 65 nm 1.2 V. On GF180MCU at 1.8-3 V the
bias current scales linearly with V_DD overhead; allow 500-1000 nW
on the 5 V flow with V_DD-friendly cascoding.

### AC-RC-2 (Hsiao 254 nW @ 20 kHz, 21 ppm/C)

Same blocks as AC-RC-1 plus:

| Additional sub-block | Function | GF180MCU device |
|---|---|---|
| PTAT/CTAT-tracking sub-bias | Generates the curvature-compensated bias that flattens RC-TC at a chosen mid-temperature. | Bandgap + temperature sensor. ~1000 um^2. |
| Trim DAC for TC slope | 4-6 bit; sets the PTAT/CTAT mix ratio at probe trim. | Switched-resistor or switched-cap; ~500 um^2. |
| eFuse register | Stores TC-slope trim word (links to TODO item j). | PDK eFuse cell; depends on (j) work. |

### AC-RC-4 (Tokairin VAFB)

| Additional sub-block | Function |
|---|---|
| Voltage-averaging integrator | RC-LP-filtered version of the V_C waveform, fed back to the threshold reference. Reduces V_DD sensitivity to ~0.04 %/V. |
| Loop comparator | Compares the average against the bandgap reference, generates the threshold-correction current. |

This adds ~1500 um^2 of area for a ~25x V_DD-rejection improvement.

### AC-RC-5 (Lee leakage-compensated 8.1 nW)

| Additional sub-block | Function |
|---|---|
| Replica-leakage current mirror | Matches and subtracts the timing-branch transistor's sub-threshold leakage from the integration current. |
| Forward-body-bias buffer | Drives the comparator with an FBB'd output stage, giving stable operation down to V_DD ~ 0.4 V. |

GF180MCU note: forward body bias on the standard 5 V devices is
not normally exercised by the PDK flow. Need to verify N-well
contact accessibility for FBB schemes; this is `Q-AC-12` in
open-questions.md.

---

## AC-FLL family (frequency-locked loops)

### AC-FLL-1 (Choi/Blaauw 110 nW resistive-FLL with sigma-delta DCO)

| Sub-block | Function | GF180MCU device |
|---|---|---|
| Self-biased ring DCO | Free-running oscillator whose frequency is digitally controlled by the trim word. Self-bias makes the ring's f_osc roughly proportional to (V_DD - V_T) / RC_eff. | Inverter chain + PMOS/NMOS bias mirror. ~1500 um^2. |
| RC time-constant network | The "reference" against which the DCO is locked. Period-tracked by switching the cap onto the resistor and observing the discharge time. | nplus_u or nwell resistor + MIM cap. ~3000 um^2 for 70 kHz. |
| Single-bit chopped comparator | Compares each DCO cycle against the RC discharge time; outputs +1 / -1. Chopping removes input offset. | 2-stage diff pair with chopper; ~500 um^2. |
| Digital sigma-delta loop filter | First- or second-order DSM that integrates the comparator's +1/-1 output and drives the DCO trim word. | Synthesisable HDL. ~500 um^2 std cells. |
| DCO trim DAC (sigma-delta cap-bank) | 8-12 bit MIM cap-bank steered by the DSM output. The brief's "Sigma-Delta capacitor banks, current-DAC bias" maps directly here. | MIM unit cap (1 fF) + thermometer or binary decoder. ~3000 um^2. |
| Power-on reset / lock detector | Indicates when the FLL has converged. | HDL counter. |

**Net area:** ~10000 um^2 + ~1 mm^2 spread for the cap bank if
the bank wants pF-level total. **Net power:** 110 nW at 65 nm
0.9 V; allow 1-3 uW on GF180MCU 5 V flow.

### AC-FLL-2 (Griffith 2024 TC-domain digital FLL)

Same blocks as AC-FLL-1 plus:

| Additional sub-block | Function |
|---|---|
| Second RC reference with a different TC | Two RC time-constants whose ratio is temperature-dependent in a known way. The DSM compares the DCO against the *ratio* rather than against a single reference. |
| TC-ratio digital correction | Synthesisable; folds the TC of the two RC paths into a quadratic correction. |

### AC-FLL-4 (NFC-carrier FLL -- the project-defining family)

This is the strongest academic-anchored candidate for v2. The
blocks are:

| Sub-block | Function | GF180MCU device |
|---|---|---|
| Carrier-input comparator (Schmitt) | Detects zero-crossings of the 13.56 MHz carrier at the rectifier-coil node. | Hysteresis comparator near the antenna pads. ~500 um^2. |
| Edge-counter divide chain | Divides the 13.56 MHz carrier down to the FLL reference frequency (typically /256 = 53 kHz). | Synthesisable HDL. ~200 um^2. |
| Free-running ring DCO | Same as AC-FLL-1's DCO. | As above. |
| Phase-frequency detector | Compares the divided carrier against the divided DCO output. Can be a simple counter-difference or a classical PFD. | HDL or hand-made. ~300 um^2. |
| Digital loop filter | Integrates phase error into trim-word updates. | HDL. ~300 um^2. |
| Trim word output | Drives the cap-bank / current-DAC; same as AC-FLL-1. | Same. |
| Field-presence detector | Indicates when the carrier is present and lock is achievable. | Comparator at antenna pad. |
| eFuse-shadow trim register | Stores last-known good trim word; loaded at field-absent power-up. Links to TODO item j. | PDK eFuse cell. |

**Sharing with item (b) NFC harvesting:** the carrier-input
comparator is *the same comparator* the rectifier already needs
for synchronous rectification. Marginal added area for FLL is
just the divider + PFD + loop filter -- ~1000 um^2 on top of
the rectifier-side comparator the v2 chip is going to build for
item (b) regardless. **This is the headline area-amortisation
finding of the academic-survey angle.**

---

## AC-SUB family (sub-threshold ring, gate-bias-compensated)

### AC-SUB-1 (DLS Hz-range ring)

| Sub-block | Function | GF180MCU device |
|---|---|---|
| Stacked-OFF inverter stages | Each stage is a stack of three transistors all biased OFF; the gate-leakage current charges the next stage's input cap. | Standard CMOS inverter with stack; ~50 um^2 per stage. |
| Stage capacitor | MIM or MOS cap setting the per-stage delay. | `cap_mim_1f0fF`; ~50 um^2 for 100 fF. |
| Stack-bias generator | Sets the gate voltages of the stacked OFF transistors. | Diode-connected MOS stack; ~200 um^2. |
| Output buffer | Restores rail-to-rail levels after the slow ring. | Std cell `mcu7t5v0__inv_*`. |

**Net area:** 7-stage Hz-range ring fits in <1000 um^2.
**Net power:** picowatts -- the ring runs entirely on
sub-threshold leakage. Brown-out tolerant down to ~0.24 V V_DD.

GF180MCU note: 5 V thick-oxide gate leakage is far smaller than
the 0.18 um / 65 nm nodes the original work targets. The DLS
ring's frequency would be sub-Hz on GF180MCU 5 V devices --
useful for the *brown-out timer* but not for the LED-twinkle
clock. **See open-questions Q-AC-1.**

### AC-SUB-3 (Hsieh reference-free capacitive-discharging)

| Sub-block | Function |
|---|---|
| Two MIM caps, ratio-set | Period set by ratio; absolute-value-insensitive. |
| Self-stabilising sub-threshold device | Provides the discharge current; its V_GS auto-converges to the gate voltage that keeps the ratio-set period stable. |
| Edge-detect comparator | Generates the digital output. |

This is the *area-cheapest* always-on always-tolerable architecture
in the catalogue. Recommended as a backup to AC-SUB-1 if the
GF180MCU 5 V gate leakage proves too small for AC-SUB-1 to run.

---

## AC-CHOP family (chopper-stabilised)

### AC-CHOP-1 (Wien-bridge frequency reference)

| Sub-block | Function | GF180MCU device |
|---|---|---|
| Wien-bridge RC filter | Two RC sections; phase shift at the resonant frequency is exactly 0 (or pi) with a particular f_osc that depends on R*C and the bridge's resistor TC. | Silicided p+ poly resistor + MIM cap. Several thousand um^2 for the bridge alone. |
| Continuous-time chopper-stabilised amplifier | Drives the bridge at the resonant frequency; chopper modulates input offset to high frequency. | Diff pair with chopping switches; ~1000 um^2. |
| Phase-domain delta-sigma modulator | Digitises the bridge phase error into a 1-bit stream. | Synthesisable HDL plus a 1-bit DAC. |
| Bias generator | Sets the bridge drive current. | Bandgap-derived. |

**Net area:** 5000-15000 um^2.
**Net power:** 87 uA at 1.8 V (Sebastiano 2010 ref), so
~150 uW total. **Heavy** -- not directly suitable for our
harvested rail's uA-scale power budget. Cited as the academic
benchmark, not as a candidate.

---

## AC-RES family (resistor / RC + bandgap, silicon-anchored)

Same blocks as AC-RC family above; differences are:
- **AC-RES-1 (Yang 2018):** adds a current-mode V_DD-cancellation
  feedback that gives the headline 0.045 %/V line sensitivity.
- **AC-RES-2 (Mossawir 2020):** adds two RC paths in parallel
  with opposite-sign TC for residual cancellation.
- **AC-RES-3 (Lee 2014):** adds an F-V converter to close a
  self-correction loop.

---

## AC-CK family (carrier-derived clocks)

### AC-CK-1 (HF RFID rec)

| Sub-block | Function | GF180MCU device |
|---|---|---|
| Antenna-tap zero-crossing comparator | Detects 13.56 MHz carrier zero-crossings at -10 dBm. | Comparator with hysteresis. ~500 um^2. |
| Divide-by-N counter | Generates the divided clock for tag protocol use. | HDL. ~200 um^2. |
| Field-presence and reset logic | Sequences the tag wake-up. | HDL. |

**This is the sparsest topology in the catalogue.** Total area
under 1000 um^2 if the comparator is shared with the rectifier.

---

## AC-LC family (deferred to BLE -- item k)

| Sub-block | Function |
|---|---|
| On-die spiral inductor (or bondwire) | Tank L. ~3 nH for 2.4 GHz BLE. |
| MIM cap (or varactor) | Tank C. |
| Cross-coupled FET pair | Negative-resistance generator. |
| Bias mirror | Sets tail current. |
| Output buffer | Drives the divider chain. |

Not relevant to item (a) housekeeping; deferred to the BLE
deep-dive.

---

## Cross-topology block summary -- shared infrastructure

The single most important academic-survey finding is that the
following blocks are *shared* across multiple topologies, and
several are also shared with TODO items (b), (c), (i), (j):

| Block | Used by item (a) topologies | Also used by | Notes |
|---|---|---|---|
| Bandgap reference | AC-RC-1, AC-RC-2, AC-RC-3, AC-RES-1, AC-RES-2, AC-CHOP-1 | item (b) rectifier ref, item (c) brown-out, item (i) PDN | Single bandgap shared across all blocks; ~3000 um^2 amortised. |
| MIM cap (timing) | All AC-RC, AC-FLL, AC-SUB-3 | item (e) energy storage | Cap-bank density 2 fF/um^2. |
| Comparator (with hysteresis) | All AC-RC, AC-FLL, AC-CK | item (b) sync rect, item (i) brown-out | Shared comparator topology; layout-replicated. |
| eFuse trim register | All trimmed topologies | item (j) | Direct dependency on item (j). |
| Sub-bandgap PTAT/CTAT | AC-RC-2, AC-RES-1, AC-RES-2 | (potentially) item (h) NFC modulator | ~1000 um^2. |
| Carrier-input comparator | AC-FLL-4, AC-CK-1 | item (b) NFC, item (h) NFC modem | **Shared with item (b)** -- key amortisation. |
| Synthesisable digital state machines | All FLL families | item (h) NFC protocol | HDL; tiny synthesised footprint. |
| Sigma-delta cap-bank trim DAC | AC-FLL-1, AC-FLL-2 | (chip-specific to osc) | Brief explicitly calls this out -- AC-FLL-1 is the silicon precedent. |
| Forward-body-bias buffer | AC-RC-5 | (none yet) | GF180MCU compatibility unconfirmed -- Q-AC-12. |

**Headline takeaway:** the marginal area attributable to "the
oscillator" once items (b), (c), (i), (j) are built out is
remarkably small for AC-FLL-4: <2000 um^2. This is even smaller
than the AC-RC-2 single-rail Hsiao topology which has to carry
its own bandgap.

This is the Stage-2-input architecture argument: if the v2 chip
is ever going to add NFC harvesting, the *cheapest* path to a
ppm-class oscillator is to share the carrier-input comparator
between the rectifier and the FLL, and pay only for the divider,
PFD, loop filter, and DCO. Total marginal area ~1500-2000 um^2.

The matching-floor calculation (Pelgrom AC-FOM-2): with AVt =
5 mV.um and a 1 um^2 unit current-DAC cell, sigma/mu ~0.5 % per
LSB. An 8-bit DAC therefore has ~0.25 LSB matching at full
range = ~0.1 % overall trim resolution. This is the floor on
how cleanly the FLL can pull the DCO; and it's adequate for
all our consumer specs except a hypothetical sub-100 ppm
post-trim target (which the project does not require).
