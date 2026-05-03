# Open questions (item f, Stage 1 academic-survey)

## Q-AC1 — How much does the 2× Talbot–Plateau correction propagate?

Greene 2015 (corrected from "Davis 2015" 2026-05-04 per reviewer-1) *PLOS ONE* PMC4395448 reports a 2× deviation from
Talbot–Plateau at sub-µs pulse durations. T4 charge-pump bucket-
dump architecture (first-principles §3.5) operates at 1 µs pulses.

**Decision impact**: T4 sizing (peak current and pulse rate) must
have 2× margin vs first-principles calculation.

**Settle by**: Stage-4 SPICE simulation comparing pulsed LED at
fixed Talbot-equivalent average current (industry-survey) vs
Davis-corrected average current (this report) and confirm the
factor is 2× (not 1.5× or 3×).

## Q-AC2 — Is the dark-adapted Hecht-Shlaer floor binding?

For ambient 2.4 GHz harvesting (TODO §(d), ~µW/cm² densities), the
0.1 µA red-LED current floor (Hecht-Shlaer 1942) is binding only
in dark conditions. In typical office light (300–500 lux), the
floor relaxes to ~5–10 µA.

**Decision impact**: Whether the card "twinkles" at all in ambient
mode depends on viewing conditions. If users primarily display
the card in dark conferences/networking events (typical), 0.1 µA
is achievable. If the card sits in normal office light, ambient-
RF harvesting may produce no visible LED.

**Settle by**: User-experience review with realistic deployment
scenarios.

## Q-AC3 — Is Hofer & Schmid 2018 ΔΣ brightness directly portable?

The 2nd-order ΔΣ control loop in Hofer & Schmid 2018 *IEEE TPE*
33(11) targets 100 mA-class LED drivers, not sub-mA. Loop
stability and overshoot may differ at our power scale.

**Decision impact**: Whether ACAD-A (ΔΣ brightness) replaces PWM
in our v2 chip.

**Settle by**: Stage-4 behavioural simulation of the ΔΣ loop with
sub-mA LED dynamics.

## Q-AC4 — Are chaotic-oscillator TRNGs ever worth the area?

PAT-9 (chaotic TRNG) at ~80 nW vs LFSR at ~30 gates. At twinkle
scales (~30 Hz update rate), statistical-quality randomness is
wasted.

**Decision impact**: PAT-9 is rejected unless we use the same
TRNG for cryptographic randomness in (j) eFuse-protected vCard
NDEF or (k) BLE address randomisation — neither is currently in
scope.

**Settle by**: Cross-reference (j) and (k) cryptographic-RNG
needs.

## Q-AC5 — Does Karthaus 2003 16.7 µW include the LED?

The "16.7 µW whole-tag" figure includes the on-die LED indicator.
But the LED itself draws far more than 16.7 µW (a sub-mA red LED
at ~1.7 V draws hundreds of µW). Resolution: Karthaus 2003 is
likely a *dim, intermittent* LED indicator with very low duty
cycle (e.g. a brief flash at every NFC poll, not continuous
twinkle).

**Decision impact**: How directly transferable is Karthaus 2003 to
our continuous-twinkle architecture?

**Settle by**: Stage-2 close-read of Karthaus 2003 to extract LED
duty cycle and average vs peak currents.

## Q-AC6 — Open-circuit voltage at the LED bond pad in VGA-only mode?

The first-principles report's negative-result N3 flagged that DVDD
is alive but harvested rail is dead in VGA-only mode, allowing
forward-bias of the LED → ESD diode → DVDD path. Academic
literature on shared bond-pad ESD strategies in multi-rail chips
(cross-ref item (i)) may have a published mitigation.

**Settle by**: Stage-4 SPICE sim of the cross-domain leakage path
+ literature search on "ESD diode forward bias dim LED" pattern.

## Q-AC7 — PAR1789 modulation depth at sub-µs pulses?

PAR1789 was calibrated at 100 % modulation depth at PWM
frequencies in the 100 Hz – 10 kHz range. Our T4 charge-pump
bucket-dump produces 1-µs pulses (≫ 1 MHz fundamental). The
PAR1789 thresholds may not directly apply.

**Settle by**: Stage-2 review of PAR1789-2015 §5 limits at MHz-
range fundamentals.

## Q-AC8 — Peripheral-CFF envelope in the LED visibility model?

Tyler & Hamer 1993 distinguishes foveal CFF (~60 Hz) from
peripheral (~15 Hz). Our card is more often viewed from
peripheral angles than centrally fixated.

**Decision impact**: Twinkle envelope frequency (the
intentionally-visible flicker that makes the card "alive")
should target peripheral CFF, i.e. ~10–25 Hz, not 30–50 Hz.

**Settle by**: User-experience review.
