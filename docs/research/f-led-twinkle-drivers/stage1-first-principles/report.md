---
item: f
item_name: led-twinkle-drivers
stage: 1
angle: first-principles
researcher: claude-opus-4-7-1m — Stage-1 first-principles agent
status: draft
last-updated: 2026-05-03
---

## 1. Executive summary

Working from LED diode physics, human visual psychophysics, and
GF180MCU device behaviour — without surveying prior LED-driver IP —
the constraints collapse to three first-order conclusions:

1. **The 3.3 V harvested rail strongly preferences red, orange,
   yellow, yellow-green, and "true-green" InGaN LEDs.** Vf at the
   µA-mA currents we can supply: red ≈1.7-1.85 V, orange ≈1.8-1.95 V,
   yellow ≈1.9-2.05 V, green-InGaN ≈2.6-2.85 V, blue/white
   ≈2.6-3.0 V (marginal), royal-blue/UV ≥3.4 V (rejected).
2. **Twinkle ≠ steady illumination.** The eye integrates over Bloch
   (~50-100 ms) and averages above CFF (~60 Hz photopic, ~15 Hz
   scotopic; Ferry-Porter scaling). We can run pulses 10-100×
   shorter than perceived "on-time" and still produce visible
   twinkle. **This is the biggest lever against the µW-mW power
   budget.**
3. **Topology is a near-trivial choice once the energy-balance math
   is done.** Seven topologies enumerated below; charge-pumped pulse
   drivers and current-DAC+PWM both satisfy constraints; fixed
   on-die ballast is the simplest and reasonable; classical analog
   current mirrors are an *anti-feature* under intermittent power;
   boost converters are physically impossible on this die.

No single topology is recommended at Stage 1. §9 hands a structured
comparison table to Stage 2.

## 2. Requirements as understood

| ID | Requirement | Source |
|---|---|---|
| R1 | Drive 2 off-chip LEDs visibly | TODO §(f) |
| R2 | Power only from harvested rail, nominally 3.3 V | TODO §(f), §(b)-(d) |
| R3 | No external passives; on-die R, C, L only | Cross-cutting #2 |
| R4 | Visually pleasing "twinkle" (organic) | TODO §(f) goal |
| R5 | Brown-out aware: graceful dim as rail dips below Vf+headroom | TODO §(f) bullet 4 |
| R6 | 2 LED pads co-located with harvested-rail pads | TODO §(f) Execute |
| R7 | `bi_24t` pad available, 24 mA spec | TODO §(f) bullet 6 |
| R8 | Pattern selection may be eFuse-driven (depends on j) | TODO §(f) bullet 7 |
| R9 | Logo on top metal preserved | Cross-cutting #1 |
| R10 | Two-rail isolation; LEDs dark on VGA-only supply | TODO §(i) |
| R11 | Harvested rail intermittent; storage cap (e) is the buffer | TODO §(b)-(e) |

R1, R2, R3, R5, R10, R11 = physics-binding. R4 = psychophysics-
binding. R6-R9 = integration-binding, tradeable.

## 3. Solution-space map

### 3.1 LED-side physics (shared)

Diode equation `I = I_s · (exp(qV/(nkT))-1)` with n ≈ 1.5-3.0 for
III-V LEDs at low currents. Useful operational form:

```
ΔV_f = n·V_T · ln(I_high / I_low)
```

V_T = kT/q ≈ 25.85 mV @ 300 K. **A 200× current decade costs only
~0.20-0.27 V of Vf.** Pushing 20 mA → 100 µA only drops Vf by
≈250 mV, *not* by an order of magnitude. This is the critical fact
for our regime.

| Colour | λ (nm) | Vf @ 20 mA | Vf @ 100 µA (calc) | Headroom @ 3.3 V | Verdict |
|---|---|---|---|---|---|
| Red AlGaInP | 630 | 2.0 V | 1.7-1.85 V | 1.45-1.6 V | Plenty |
| Orange AlGaInP | 605 | 2.1 V | 1.8-1.95 V | 1.35-1.5 V | Plenty |
| Yellow AlGaInP | 590 | 2.2 V | 1.9-2.05 V | 1.25 V | Workable |
| Yellow-green AlGaInP | 570 | 2.2 V | 1.95-2.05 V | 1.25 V | Workable |
| Green InGaN | 525 | 3.0-3.2 V | 2.6-2.85 V | 0.45-0.7 V | Tight |
| Blue InGaN | 470 | 3.0-3.4 V | 2.6-3.0 V | 0.3-0.7 V | Marginal |
| White (B+phosphor) | broad | 3.0-3.4 V | 2.6-3.0 V | 0.3-0.7 V | Marginal |
| Royal-blue / UV | <450 | ≥3.4 V | ≥3.1 V | <0.2 V | Rejected |

### 3.2 Topology T1 — fixed on-die ballast resistor + switch

LED in series with poly resistor R and a switching FET. Steady-on:
I ≈ (V_rail − V_f − V_DSsat)/R. Red LED on 3.3 V at 1 mA target
⇒ R ≈ 1.35 kΩ; salicide-blocked poly at 0.3-1 kΩ/sq ⇒
≈1500-5000 µm² resistor area. ±30% PVT tolerable for "twinkle".

- **Efficiency:** η = V_f/V_rail = 1.85/3.3 = **56 %** (red).
- **Brown-out:** as V_rail → V_f current drops smoothly.
  **Best-in-class graceful dim.**
- **Twinkle:** modulate by gating the switch. Resistor sets peak;
  PWM/PDM sets perceived brightness.
- **Caveat:** strictly worse for blue (eats the headroom we don't
  have).

### 3.3 Topology T2 — current mirror with on-die reference

Bandgap or beta-multiplier ⇒ I_ref = 12-120 µA via 10-100 kΩ ref
resistor. Mirror gain N=10-100 ⇒ 0.12-12 mA LED current. Compliance
≥ V_DSsat ≈ 100-300 mV at 1 mA in 5 V devices.

- **Efficiency:** η = V_f/V_rail (same as T1; mirror does *not*
  improve average power).
- **Brown-out:** mirror tries to hold I const, falls out of
  saturation abruptly when V_DSsat is no longer met. **Cliff-edge —
  undesirable here.** For our intermittent rail we *want* I to
  track V_rail.
- **When it fits:** if accurate steady current were required (it
  isn't).

### 3.4 Topology T3 — current-DAC + PWM gating

T2 plus binary-weighted mirror tail (3-6 bits, 8-64 levels) plus a
digital PWM counter.

- **Efficiency:** η_avg = d · I_DAC · V_f / (d · I_DAC · V_rail) =
  V_f/V_rail. **PWM does not improve average power efficiency for
  resistive/current-source loads.** (See N3.)
- **Twinkle compatibility:** excellent. LFSR → DAC level for
  "envelope"; system clock → PWM at ≥ CFF for brightness-averaging.
- **Brown-out:** inherits T2's cliff edge.

### 3.5 Topology T4 — pulsed charge-pump bucket-dump

Bucket cap C_b charged from V_rail to 3.3 V, then dumped through
LED. C_b = 10 nF, V_min = 1.7 V, V_rail = 3.3 V:

```
E_pulse  = ½·C_b·(V_rail² − V_min²)
         = ½·10 nF·(10.89 − 2.89) = 40 nJ
W_rail   (per pulse) = C_b·ΔV·V_rail = 10 nF · 1.6 V · 3.3 V = 52.8 nJ
W_LED_photons ≈ V_f·ΔV·C_b = 1.85·1.6·10 nF = 29.6 nJ
η_wall_plug ≈ 29.6 / 52.8 = 56 %
```

I_peak ≈ C_b·ΔV / τ_pulse = 10 nF · 1.6 V / 1 µs = 16 mA (within
`bi_24t`).

- **Brown-out:** pulse energy ∝ V_rail² − V_f². **Smooth collapse,
  no glitch.**
- **Rail-coupling (key advantage):** rail sees only charging current
  spread over 1/f − τ_pulse ≈ 1 ms; LED's 16 mA peak is supplied by
  C_b not V_rail. **~1000× rail-ripple reduction vs T1/T3 with same
  pulse current.** (See §5.6.)

### 3.6 Topology T5 — boost converter with on-die inductor — REJECTED

On-die spiral inductor at 200×200 µm ≈ 5-15 nH. E_L = ½LI² =
½·10 nH·(10 mA)² = **0.5 fJ**, vs LED-pulse target **37 nJ**. Ratio
= 1.4×10⁻⁵ ⇒ would require ~70,000 switching cycles per pulse, i.e.
tens of GHz. **Unphysical.** Listed explicitly so Stage 2 can verify
nothing was silently dropped.

### 3.7 Topology T6 — tribrid: switched-cap multiplier + bucket-dump

Variant of T4 where two caps are charged to V_rail in parallel,
then series-connected to give V_bucket ≈ 2·V_rail = 6.6 V before
dump. Opens headroom for blue/white (Vf ≈ 3.0 V) and series-LED
strings (2× red, Vf_total ≈ 3.7 V).

- Capacitor doubler theoretical ceiling ½·C·V_rail² per cycle
  (Dickson / charge-redistribution); practical 50-80 %.
- **Brown-out deferred** to V_rail < V_f/2 ≈ 0.93 V — the rest of
  the chip browns out long before the LED does.
- Cost: one extra cap, 2-3 extra switches, three-phase non-overlap
  clock.

### 3.8 Topology T7 — direct switch (no ballast)

LED + switch FET only; LED's own r_d = nV_T/I (≈51 Ω at 1 mA, n=2)
and switch V_DSsat are the only limits.

- I varies ~3× over PVT corners. **Acceptable for twinkle.**
- Pros: zero ballast area; max efficiency at given V_f/V_rail.
- Cons: brittle. Strongly recommend eFuse-trimmed switch W
  (depends on j).
- The simplest possible "dumb floor".

### 3.9 Summary table

| Short | Topology | Naïve / sophisticated |
|---|---|---|
| T1 | On-die resistor ballast + switch | Naïve floor |
| T2 | Classical current mirror | Conventional analog |
| T3 | Current-DAC + PWM | Conventional + digital |
| T4 | Charge-pumped bucket-dump | Sophisticated |
| T5 | Boost converter w/ on-die L | **Rejected (physics)** |
| T6 | Tribrid: SC multiplier + bucket-dump | Most sophisticated |
| T7 | Direct switch (LED dynamic-r only) | Simplest |

## 4. Sub-block breakdown

See [`components.md`](components.md).

## 5. First-principles sanity checks

### 5.1 LED Vf at low currents

ΔV = n·V_T·ln(I_high/I_low). For 20 mA→100 µA, ln(200) ≈ 5.30.
n=1.5 ⇒ ΔV=205 mV; n=1.8 ⇒ 246 mV; n=2.0 ⇒ 274 mV. **Range
0.20-0.27 V** for 200× current reduction. Justifies "Vf@20mA −
250 mV" in §3.1.

### 5.2 Visible-current threshold

At 100 µA, P_drawn = 1.85 V · 100 µA = 185 µW; P_radiant ≈ 37 µW
(η_e=0.2 red); luminous flux ≈ 37 µW · 0.265 · 683 lm/W =
**6.7 mlm**. At 1 cm range into 1 mm² pupil, ~µlux at the eye —
**~3 orders of magnitude above scotopic threshold (~10⁻⁶ cd/m²)**.
Visible.

Threshold (dark-adapted, point source): ~10⁻⁹ W into pupil,
corresponding to ~0.1 µW radiant ≈ **0.5 µA at η_e=0.2**.
**Below 1 µA invisible. 10 µA visible in dim ambient. 100 µA
"obviously on". 1 mA "business-card-grade".** Target 100 µA - 1 mA
peak.

Photometric efficacy table:

| Colour | λ | V(λ) | η_e (typ commodity) | η_lum ≈ 683·V(λ)·η_e |
|---|---|---|---|---|
| Red | 630 | 0.265 | 0.20 | 36 lm/W |
| Orange | 605 | 0.503 | 0.18 | 62 lm/W |
| Yellow | 590 | 0.757 | 0.10 | 52 lm/W |
| Yellow-green | 570 | 0.952 | 0.08 | 52 lm/W |
| Green InGaN | 525 | 0.793 | 0.10 | 54 lm/W |
| Blue | 470 | 0.091 | 0.30 | 19 lm/W |
| White | broadband | ≈0.27 eff | 0.20 | 37 lm/W |

### 5.3 Twinkle / flicker-fusion psychophysics

- CFF foveal photopic plateau ≈ **60 Hz** (Wikipedia "Flicker fusion
  threshold", verified 2026-05-02).
- CFF peripheral/scotopic plateau ≈ **15 Hz**.
- **Ferry-Porter law:** CFF ∝ log(L); high-luminance can climb to
  80-90 Hz (irrelevant here).
- **Talbot-Plateau law:** above CFF, perceived brightness =
  time-averaged luminance.
- **Bloch's law:** for τ < 50-100 ms, perceived brightness ∝ E·τ.

**Design implication:** twinkle envelope must have *modulation*
below 30 Hz (visible flicker = the desired effect); inside each
~33 ms frame, PWM brightness carrier runs at 1-10 kHz (above CFF,
brightness-averaging regime). Pattern generator → 30 Hz update;
PWM clock → 1-10 kHz.

### 5.4 Charge-pump fundamental ½·C·ΔV² loss (T4)

For *any* resistive charge of cap from V₀ to V₀+ΔV at rail
V_rail = V₀+ΔV: W_dissipated = W_rail − W_stored = ½·C·ΔV².
Independent of R. Topological limit.

Our T4 with V_min=1.7 V, V_rail=3.3 V, ΔV=1.6 V:
W_rail = 52.8 nJ, W_stored = 40 nJ, **rail-to-bucket η = 76 %.**
LED dump phase: W_LED_photons ≈ 26.8 nJ ⇒ **wall-plug η ≈ 51 %.**
T1 wall-plug = V_f/V_rail = 56 %. **T1 *more* efficient than T4 at
steady state.** T4's value is rail-decoupling and brown-out
gracefulness, *not* efficiency.

### 5.5 On-die inductor energy ceiling (T5)

L=10 nH, I=10 mA ⇒ E_L = 0.5 fJ. E_LED = 37 nJ. Ratio = 1.4×10⁻⁵.
⇒ ~70,000 switch cycles/pulse at 1 µs = tens of GHz. **T5 rejected.**

### 5.6 Rail-coupling impulse calc

T1/T3 with τ_on = 100 µs, I_peak = 1 mA, C_storage = 100 nF:
ΔV_cap = I·τ_on/C = **1.0 V dip** on 3.3 V rail ⇒ chip brown-out.
**Catastrophic.** Reduce τ_on to 1 µs ⇒ ΔV_cap = 10 mV.
**Tolerable.** ⇒ T1/T3 must use 1-10 µs pulses at 1-30 kHz.

T4: rail sees only avg charging current = C_b·ΔV/τ_charge =
10 nF·1.6 V/1 ms = **16 µA avg, low ripple**. LED's 16 mA peak
supplied entirely by C_b. **~1000× rail-ripple reduction vs T1/T3
at same I_peak.** This is the headline argument for T4.

### 5.7 Pattern-generator gate count

- 8-bit Galois LFSR (period 255): ~30 gates.
- 16-bit LFSR (65535): ~50 gates.
- 24-bit LFSR (16M): ~70 gates.
- Sine LUT (8×4 bit): ~50 gates.
- Value-noise / Perlin 1D: ~150-300 gates.
- Brownian (LFSR + 8-bit accumulator + saturation): ~100 gates.
- Additive (3 LFSRs at different rates): ~120 gates.
- **Budget per LED ≤ 500 gates; both LEDs ≤ 1k gates. Rounding
  error vs the existing screensaver. Don't optimise here.**

### 5.8 GF180MCU device-level sanity

5 V NMOS Vth ≈ 0.7 V (PDK [V3]); native NMOS Vth ≈ 0 V (optional,
[V4]). At V_GS = 3.3 V (digital): V_OV = 2.6-3.3 V; I_DSAT/W
several hundred µA/µm. For 16 mA peak ⇒ W ≈ 50-80 µm. R_on linear
≈ 5-15 Ω ⇒ V_DSsat 80-240 mV. PMOS pull-up similarly ≈ 100-150 µm.
Comfortably small.

## 6. References

See [`references.md`](references.md).

## 7. Negative results

**N1 — On-die boost converter (T5).** §5.5: E_L=0.5 fJ vs
E_LED=37 nJ ⇒ five orders of magnitude short. Switch-rate to
deliver = tens of GHz. Rejected. Conditions: 6-metal GF180MCU,
200×200 µm L footprint, 10 mA pulse. Applies to *our*
requirements: yes — kills boost permanently unless an external L
is allowed (it isn't, per R3).

**N2 — Plain current mirror as primary driver (T2).** §3.3:
cliff-edge brown-out fights the intermittent rail; mirror provides
no efficiency benefit (V_f/V_rail either way); current-source
behaviour is *anti-correlated* with desired graceful dim.
Conditions: 3.3 V harvested, 100 µA-1 mA, intermittent rail.
Eliminated as primary driver; possibly useful as a bucket-charge
current limiter in T4.

**N3 — "PWM is more efficient than a resistor".** Common hobbyist
claim. §3.4 / §5.4 disprove it for resistive/current-source LED
loads: average η = V_f/V_rail regardless of duty. The claim
conflates PWM-of-a-buck-converter (where switching = conversion,
more efficient than linear) with PWM-of-a-resistor (no efficiency
benefit). Filed so Stage 2 can call it out when the industry survey
parrots it.

**N4 — Direct rail-PWM with hundreds-of-µs pulses.** §5.6: 100 µs
· 1 mA on 100 nF cap → 1 V rail dip → chip brown-out. Rejected as
default; only viable with τ_on ≤ 10 µs at current item-(e) cap
budgets.

**N5 — Visible-light LEDs at I < 1 µA.** §5.2: scotopic threshold
~0.5 µA into 20%-η red LED at 1 cm. Below this, invisible *even
dark-adapted*. ⇒ **At 2.4 GHz ambient densities < 0.1 µW/cm², no
twinkle is possible** regardless of topology. Card sits dark. This
is the implicit answer to TODO §(d)'s open question on µW-budget
feasibility.

## 8. Open questions

See [`open-questions.md`](open-questions.md).

## 9. Comparison readiness

| Approach | Headline performance | Area / power cost | Maturity | Best fit for | Worst fit for |
|---|---|---|---|---|---|
| T1 — resistor ballast | η ≈ V_f/V_rail (56% red, ≤50% blue marginal); peak I limited by R; brittle to PVT only in absolute current | ≈2-5 kΩ poly + 50-100 µm switch; ~10k µm² | Trivial | Red/orange/yellow on intermittent rail; min area; graceful dim | Blue/white (eats headroom); precise brightness |
| T2 — current mirror | I-regulated; η identical to T1; cliff-edge brown-out | Bandgap (~50k µm²) + mirror (~5k µm²) | Mature analog | Steady controlled-I apps | Twinkle on intermittent rail (anti-feature) |
| T3 — current-DAC + PWM | Programmable I; PWM duty; η identical to T1 | T2 + DAC tail (~5k µm²) + PWM counter (~1k gates) | Mature | Multi-level twinkle without per-LED pulse engine | Strict area minimisation |
| T4 — bucket-dump | η ≈ 50%; ~1000× rail-coupling reduction; graceful brown-out | 10 nF MIM (~50k µm² @ 2 fF/µm²) + 2 switches + non-overlap clk | Less common but well-understood | Brown-out-prone rails; pulse-LED protection; multi-LED phase-stagger | Steady illumination; when MIM area scarce |
| T5 — boost w/ on-die L | n/a | E_L=0.5 fJ vs E_LED=37 nJ — physically impossible | Rejected | n/a | Everything (rejected) |
| T6 — tribrid SC-mult + bucket | η ≈ 30-40%; drives blue/white from 3.3 V; deferred brown-out | T4 + 1 cap + 3 switches | Less common; textbook charge-redistribution | Blue/white at 3.3 V; series strings; ultra-low brown-out floor | When red is sufficient (over-engineered) |
| T7 — direct switch | η = V_f/V_rail (max); I set entirely by switch I_DSAT | ≈100-200 µm switch + eFuse trim; tiny ~2k µm² | Trivial | Single colour, single LED, area-constrained, ±3× PVT spread acceptable | Anywhere needing brightness uniformity |

## 10. Author's notes (surprises)

1. **PWM is *not* an efficiency win** for resistive/current-source
   LED loads (§N3). PWM's role is psychophysical brightness
   perception (Talbot-Plateau averaging), not power efficiency.
2. **On-die boost is dead by 5 orders of magnitude** (§5.5). Worth
   writing down explicitly because someone *will* propose this
   again.
3. **T1 (humble ballast) is competitive with T4 (charge pump) on
   efficiency.** T4 wins on rail-coupling and on enabling blue via
   T6, *not* on efficiency. The naïve and sophisticated end up
   close because the dominant loss is V_f/V_rail.
4. **Two-LED phase-staggering in T4/T6** could roughly halve rail
   ripple again — worth a Spice in Stage 4.
5. **Eye-perception math is *much* more permissive than LED-physics
   math.** Twinkle is budget-rich on the visual side; the
   bottleneck is the harvested rail and cap (e), never the eye.
