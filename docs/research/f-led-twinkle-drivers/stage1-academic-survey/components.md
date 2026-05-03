# Components — sub-block inventory (item f, Stage 1 academic-survey)

This file maps the 7 silicon-anchored driver topologies and 6
academic-only contributions in [`solutions.md`](solutions.md) onto
sub-blocks. Sub-blocks build on the industry-survey
[`components.md`](../stage1-industry-survey/components.md).

## Common sub-blocks (cross-cutting)

- **LED bond pads.** Per industry survey: `gf180mcu_fd_io__asig_5p0`
  (passive bond pad, 26 250 µm²) for both LED pads, with the LED
  current source/driver on-die in the harvested-rail power island.
- **Brown-out detector** (cross-ref item (i)). Required because
  every academic-anchored topology degrades when V_rail dips below
  LED Vf + headroom.

## Per-topology composition

### T1 (resistor ballast + switch) — Curty 2005, Karthaus 2003
- Poly resistor (sub-200 Ω at 1 mA target).
- Power MOS switch (W ≈ 50 µm).
- **Karthaus 2003 ~~gate count for whole tag including LED
  indicator~~ RF receiver-sensitivity threshold (corrected
  2026-05-04 per reviewer-1; see references.md REF-PW-2 caveat
  — the original "whole-tag including LED" framing is retracted):
  ~16.7 µW** — the most aggressive silicon-anchored low-power LED
  budget known.

### T2 (diode-connected MOS-as-resistor) — Doutreloigne 2015
- Diode-connected MOS as ballast (eliminates poly).
- Switch.
- Conference-grade silicon.

### T3 (current mirror + bandgap) — Tan & Mok 2009
- Bandgap reference (~1 µA Iq).
- Current mirror (3-bit DAC trim).
- Power MOS switch.
- Conference-grade. Iq tax of ~1 µA may be too high for ambient-RF
  budget.

### T4 (charge-pumped bucket-dump) — Le 2011, Seeman & Sanders 2008
- MIM bucket cap (10 nF, sized per first-principles §5.5).
- High-side switch + low-side switch.
- Non-overlap clock generator.
- Brown-out detector.
- **Must include 2× Talbot–Plateau margin** (Greene 2015 (corrected from "Davis 2015" 2026-05-04 per reviewer-1)) — either
  2× peak current or 2× pulse rate vs first-principles sizing.

### T5 (SC voltage doubler) — Wens & Steyaert 2011
- 2 flying caps (1–10 pF MIM each).
- 4 switches.
- Non-overlap clock.
- Useful when LED Vf > V_rail (e.g. blue/white LEDs from 3.3 V
  rail).

### T6 (Dickson multiplier) — Dickson 1976, Mandal 2007
- N stage flying caps.
- N+1 stage diode-connected MOS.
- Clock generator.
- Useful for sub-1 V harvested rail to drive red LED.

### T7 (direct switch) — not silicon-anchored as primary
- Power MOS only; LED dynamic-r as ballast.
- Smallest area; brittle to PVT.

### ACAD-A (sigma-delta brightness) — Hofer & Schmid 2018
- 2nd-order ΔΣ modulator (~50–100 gates).
- DAC code register (4–6 bit).
- Power MOS switch.
- **Stronger academic anchor than NXP patent EP2081414**.

### ACAD-B (chaotic-oscillator TRNG) — Yang 2015, Pareschi 2010
- ~80 nW oscillator at 900 bps, 180 nm CMOS.
- vs ~30 gates LFSR (much smaller area).
- **Overkill for twinkle scales**; statistical-quality
  randomness wasted at 30 Hz update rate.

## Vision-perception sub-blocks

These are not on-die hardware blocks but are *load-bearing on
sizing*:

- **Talbot–Plateau correction factor** (Greene 2015 (corrected from "Davis 2015" 2026-05-04 per reviewer-1) / Greene & Morrison 2023 (corrected from "Davis 2023" 2026-05-04 per reviewer-1)).
  Apply 2× to T4 pulse rate or peak current.
- **Hecht-Shlaer floor** (1942 *J. Gen. Physiol.*). ~~0.1 µA
  red dark-adapted threshold; 5× tighter than first-principles
  estimate.~~

  > **CAVEAT 2026-05-04** (reviewer-1): the µA-class translation
  > from Hecht-Shlaer's 5-14 photons is **~10⁵× too coarse** —
  > reviewer-1's recalc puts the dark-adapted threshold at
  > **picoamps**, not microamps. The 5-14 photon claim itself
  > stands; the µA translation does not. The LED twinkle
  > architecture must NOT rely on "0.1 µA dark-adapted floor"
  > as a sizing input.

  ~~Binding constraint for ambient-RF harvested mode.~~ At
  picoamp threshold, the binding constraint flips: any LED
  current >> picoamps is visible in the dark, so the *visibility
  floor* is no longer a sizing constraint at all.
- **PAR1789 thresholds** (Bullough 2011, Wilkins 2010). Same as
  industry-survey: ≥1.25 kHz low-risk, ≥3 kHz no-effect at 100 %
  modulation depth.
- **Peripheral-CFF envelope** (Tyler & Hamer 1993). Twinkle
  modulation < 25 Hz to be consciously seen from peripheral
  glance; PWM carrier ≥ 1.25 kHz separately.
