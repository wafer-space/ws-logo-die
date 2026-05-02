---
item: a
item_name: internal-oscillator
stage: 1
angle: first-principles
researcher: stage1-first-principles agent (parallel instance 1 of 3)
status: draft
last-updated: 2026-05-02
---

# Open questions

These are concrete unanswered questions that surfaced during the
first-principles derivation, with the decision they unblock and a
guess at how they'd be settled. Stage 2 / 3 should pick these up; some
need a Spice run, some need the parallel Stage-1 surveys to finish,
and some need a PCB measurement.

## Q1 — Does the chip need an internal oscillator at all in NFC mode?

**Decision unblocked:** whether the oscillator must satisfy NFC-tag
timing budgets (847.5 kHz subcarrier accuracy, 5 ms wake-up).

**My current view:** **No.** ISO14443A traditionally derives all tag
timing from the carrier (E3 in `solutions.md`); the chip only needs an
internal oscillator when the carrier is *absent*. Confirming this
removes the tightest accuracy spec from the oscillator's
requirements — drops the requirement from "ppm" to "couple of percent."

**How it would be settled:** read ISO/IEC 14443-2 §8 (clock
recovery) and -3 §6 (frame timing). Cite the relevant clauses
explicitly so the decision is auditable. (Out of scope of
first-principles angle; the academic-survey researcher should pick
this up.)

## Q2 — What is the realistic loaded-Q of the NFC PCB-loop antenna
        when the rectifier and modulator are connected?

**Decision unblocked:** whether topology C3 (PCB-loop tank as
cold-clock) is viable. C3 needs Q ≥ ~10 to oscillate against the
losses; if loaded-Q drops below that the topology fails.

**My current view:** intrinsic Q at 13.56 MHz on PCB copper is 30–80,
but the rectifier presents a varying load (from open during the
positive half-cycle to short during the negative half-cycle in a
diode-bridge rectifier). Modulator load is even worse — by design it
shorts the antenna for hundreds of ns at 847.5 kHz. The "loaded Q"
during the field-absent state (when the rectifier is off) might still
be high, but verification is non-trivial.

**How it would be settled:** S-parameter co-simulation of the PCB
loop with the on-die rectifier in its "field-absent" state — needs
item (b)'s rectifier circuit. Could also be measured on a v1
PCB-only build by sweeping the loop with a network analyser.

## Q3 — Can the bandgap and current-starved ring start up within
        5 ms of a cold-start "field present" event?

**Decision unblocked:** whether `rc-relax-stable` (B2) is a viable
NFC-mode primary clock.

**My current view:** typical bandgap settling is 50–500 µs once
V_DD is up. The pessimistic case (500 µs settling + 100 µs ring
warmup + safety margin) is well under 5 ms. **Probably yes**, but
under brown-out (V_DD oscillating around the bandgap's operating
floor), the bandgap can take orders of magnitude longer to settle as
it gets repeatedly reset.

**How it would be settled:** transient Spice sim with a realistic
NFC-rail ramp profile. Field-present V_DD ramps from 0 to nominal
in ~100 µs (set by rectifier capacitance and reader impulse).

## Q4 — What's the actual Cox / mismatch for `cap_mim_2f0fF` at our
        relevant operating points?

**Decision unblocked:** capacitance ratio precision for the
switched-cap relaxation (B3) and the cap-bank trim (Core-108).

**My current view:** ratio matching of MIM caps is typically <0.1 %
for caps >1 pF, degrading to ~1 % at 100 fF and worse below. PDK
provides matching specs in the design manual. Need to pull the actual
numbers.

**How it would be settled:** read GF180MCU PDK design manual §7
(passives) — likely already extracted in the spice models'
mismatch parameters.

## Q5 — Does GF180MCU support a low-V_DD digital flow that could
        run sub-threshold rings as part of the *standard* digital,
        not as a custom block?

**Decision unblocked:** whether D1 can be implemented as stdcell or
must be custom. If stdcell, the area cost drops by ~10×.

**My current view:** the `mcu7t5v0` library is characterised down to
2.25 V (lib file `gf180mcu_fd_io__ss_125C_2v25.lib` exists for IO);
stdcell digital `mcu7t5v0` is characterised down to 4.5 V. So
sub-1V operation is **not** supported by stdcell. D1 must be custom.

**How it would be settled:** check standard-cell library coverage in
`libs.ref/gf180mcu_fd_sc_mcu7t5v0/lib/` for any low-V_DD corner.
**Already done** — no <4.5 V corner exists. D1 = custom-only,
confirmed.

## Q6 — Is the "spiral inductor under the logo" geometry compatible
        with the logo's optical-readability constraint?

**Decision unblocked:** whether C1 (on-die LC tank for BLE) can fit
in the v2 die at all without violating the "top metal stays the
wafer.space logo" hard constraint.

**My current view:** an octagonal spiral at 100×100 µm is
significantly smaller than the logo, so could be hidden inside one of
the rocket's "ring" features and read as part of the design from
above. But this needs an explicit graphic-design review, not just an
electrical review.

**How it would be settled:** mock up the chip floorplan with the
spiral footprint embedded in the logo's metal usage; review with the
logo's designer. Possibly: design the spiral to *be* the logo's
ring elements (if we are *very* clever).

## Q7 — Is the harvested-rail brown-out frequency known?

**Decision unblocked:** whether the rail-droop happens fast enough
to invalidate "long-term-average" PSRR claims in B1, B2, etc.

**My current view:** brown-out frequency for the harvested rail
is bounded by:
- Qi mode: switching freq 100–205 kHz, droop at the rectified envelope
  ~100 kHz.
- NFC mode: subcarrier modulation 847.5 kHz; the rail droop at this
  rate is exactly what the smoothing cap (item (e)) is supposed to
  filter, but residual droop at 100s of kHz is plausible.
- 2.4 GHz harvest mode: rail droop at the LED PWM rate (1–10 kHz)
  because that's what loads the cap.

So the "supply noise" frequency we care about is roughly 100 Hz to
1 MHz. The classic textbook PSRR claim (60 dB at DC, dropping to 30 dB
at 1 MHz) is *barely adequate* — exactly at the harvested-rail noise
band. **The brown-out condition is more dangerous than the noise
condition** — when V_DD drops below the bandgap operating floor
entirely, the oscillator must restart cleanly without latching up.

**How it would be settled:** bench measurement once items (b)/(c)/(d)
have a working rectifier; until then, conservative simulation with
±20 % rail dip at 100 kHz on top of a 4.5 V baseline.

## Q8 — Will the FLL (E1) lock fast enough to be useful in a
        100-ms-class NFC tap?

**Decision unblocked:** whether to favour FLL (E1) or
injection-locking (E2) for the carrier-locked architecture.

**My current view:** FLL bandwidth scales as `2π·BW < f_ref/10` for
loop stability. With f_ref = 13.56 MHz / N (where N is the divider
ratio) and N = 256, BW ≈ 5 kHz, lock time ~1 ms. **Fast enough for
NFC.** Injection lock (E2) is faster (<1 µs) but has narrower
pull-in range. FLL is the safer choice; IL is an optional speedup.

**How it would be settled:** behavioural sim of the loop. Easy.

## Q9 — Does the chip's own 25.175 MHz VGA pixel clock disturb the
        2.4 GHz harvester's input?

**Decision unblocked:** whether the LO can free-run during VGA mode
(item (d)'s open question raised this).

**My current view:** 25.175 MHz × 96 = 2.41 GHz, *exactly inside*
the 2.4 GHz harvester band. A square-wave clock has strong
odd-harmonic content; the 95th harmonic at 2.39 GHz and 97th at
2.44 GHz are non-trivial. If they couple into the harvester
antenna, they'll either help (free RF input) or hurt (saturate the
rectifier). This is a coexistence question that affects the
oscillator design only if we *avoid* this exact case by choosing a
different VGA clock or FLL reference.

**How it would be settled:** measure on Run 1 silicon; until then,
EM-co-simulate.

## Q10 — Is there a PDK-provided oscillator IP I missed?

**Decision unblocked:** whether to write a custom oscillator at all,
vs. instantiating a PDK macro.

**My current view (verified):** Listed `libs.ref/gf180mcu_fd_pr/mag/`
contains only passives + eFuse macros. No `*osc*`, no `*pll*`, no
`*xtal*`. `libs.ref/gf180mcu_fd_ip_sram/` is SRAM only.
`libs.ref/gf180mcu_fd_io/` is the pad ring. **There is no
PDK-provided oscillator macro on gf180mcuD.** Confirmed during this
research.

**How it would be settled:** ✅ already settled.

## Q11 — Can a single internal oscillator cover *all* non-VGA modes
        or do we need per-mode oscillators?

**Decision unblocked:** chip-level architectural decision: 1 osc vs
N osc.

**My current view:** A two-tier hybrid (G1) covers the LED-twinkle
slow domain and the housekeeping fast domain with one cheap-fast
ring + one cheap-slow ring. Adding the FLL (G2) gives ppm precision
when needed. **One physical oscillator block** with mode-dependent
cap-bank settings can cover everything if the band of frequencies
needed isn't too wide. The harvested-rail "always-on" sub-threshold
ring (D1) at 1 kHz might want to be a separate, second physical
block because its V_DD floor is much lower.

**How it would be settled:** Stage-3 architectural synthesis
(merge with items (b)/(c)/(d) power-budget findings).

## Q12 — Is the eFuse program voltage compatible with the harvested
        rail?

**Decision unblocked:** whether we can program the trim word in the
field, or only at chip test.

**My current view:** GF180MCU eFuse is 5–6 V program. The harvested
rail's *peak* voltage at 0-mm NFC distance can exceed 30 V (item (b)
flagged this) — *more* than enough. So in principle the chip could
self-program its trim word from a strong NFC field, but the
power budget for the program pulse (typically 50 mA × 10 µs) is
many orders of magnitude beyond what NFC realistically delivers.
**At-test programming is the only realistic path.**

**How it would be settled:** energy-budget sanity check; cross-ref
item (j).

## Q13 — Does the sub-threshold ring (D1) work at the harvested-rail
        floor of ~1 V (worst case) with 6 V-devices?

**Decision unblocked:** whether the always-on brown-out timer can be
implemented at all without a charge pump.

**My current view:** the 6 V NMOS native (`nfet_06v0_nvt`) has Vt ≈
0.4 V at TT (lower at FF, higher at SS). At 1 V V_DD, V_DS_sat is
~600 mV — sub-threshold but workable. Pure sub-threshold rings have
been demonstrated below 0.5 V V_DD in 65 nm; 180 nm with a 0.4 V Vt
device should manage 1 V comfortably. **Probably yes**, but
verification needed.

**How it would be settled:** Spice sim of a 7-stage sub-threshold
ring across PVT at 1.0 V V_DD with the native NMOS device.

## Q14 — Are the published "RC oscillator achieves 1 % accuracy"
        claims robust to the harvested-rail's *non-stationary*
        noise spectrum?

**Decision unblocked:** how much trim margin to budget on top of
the textbook "1 %" number.

**My current view:** **No, those claims aren't robust here.** They
assume:
1. V_DD is bounded (4.5–5.5 V or similar) — *probably true* if the
   regulator works.
2. V_DD noise is below ~10 mV at the comparator's bandwidth —
   **violated** at brown-out instants.
3. Temperature is bounded (-40 to 125 °C, drifting slowly) —
   *probably true.*
4. The bandgap reference is settled before any measurement is made
   — **violated** at every cold-start.

A 1 % oscillator becomes a 5 % oscillator in our environment. We
should specify it as ±5 % and design downstream consumers
accordingly.

**How it would be settled:** Spice corner sims with realistic
brown-out injection. Design margin study.
