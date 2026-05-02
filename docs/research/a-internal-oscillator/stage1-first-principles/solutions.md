---
item: a
item_name: internal-oscillator
stage: 1
angle: first-principles
researcher: stage1-first-principles agent (parallel instance 1 of 3)
status: draft
last-updated: 2026-05-02
---

# Solutions — solution-space map (TEMPLATE.md §3 format)

This document enumerates every distinct oscillator topology family that
the *physics* of a GF180MCU 5 V process appears to permit, regardless of
whether the topology is widely deployed in commercial timing IP. Each
entry uses TEMPLATE.md §3's required headings:

- short name (stable identifier across reports)
- one-paragraph description
- where it is currently used (one-line industry / paper hint, not a
  literature survey — that belongs to the parallel angles)
- typical performance numbers
- conditions under which it has been *tried and found insufficient*
- conditions under which **our project's** requirements differ

Each entry ends with **Physics-permitted but rare?** — yes/no. The
"yes" entries are the headline contribution of the first-principles
angle: physically possible topologies that are not widely used because
they don't fit the *commercial* problem. They may fit ours.

Frequencies the project actually demands range from ~1 kHz (LED PWM,
eFuse program timing) up to 2.4 GHz (BLE LO synthesis), so we organise
by topology family rather than by frequency band.

## Family A — Ring oscillators

### A1 — Raw inverter ring (`ring-raw`)

A chain of an odd number `N` of stdcell inverters with the output of
the last gate fed back to the first. Period `T ≈ 2·N·t_pd`, where
`t_pd` is per-stage propagation delay.

Where used: Every digital ASIC has at least one in test scan logic.
Used as a free-running clock in jellybean MCU ROM bootstraps, in
NTAG-class NFC tags as a *fallback* clock when the carrier is absent,
and as the canonical example oscillator in textbook chapters.

Typical numbers (this PDK, derived):
- 7-stage ring of `mcu7t5v0__inv_4` at 5 V, TT 25 °C. Per-stage delay
  from the `.lib` files for `INV_X4` driving 1 fF (small loading)
  is roughly 30–50 ps at TT, falling to ~25 ps at FF and rising to
  ~80 ps at SS-cold. Period ≈ 2·7·50 ps = 700 ps → ~1.4 GHz.
- That ratio (FF:SS ≈ 3:1) bounds the *un-trimmed* frequency
  uncertainty for any inverter-ring oscillator. Net spread including
  Vdd from 4.5–5.5 V and -40 to 125 °C is closer to ±50 % to ±70 %.
- Phase noise is set by *cycle-jitter accumulation*; at 1 GHz fundamental
  with stdcell INV_X4 the long-term jitter accumulates at roughly
  0.1 ps / cycle, scaling with √cycles. Over 100 µs (1e5 cycles at 1 GHz)
  jitter ≈ 30 ps RMS — far worse than VGA needs.

Found insufficient when: cellular RF reference (1 ppm), GPS, anything
needing PSRR > 30 dB, or anything that has to start within 1 ns of
power-on (it's faster than start-up needs but starts noisily).

Why our project might still use it: For LED twinkle (kHz, ±50 % is
fine) and eFuse program timing (single µs pulses with ±50 % tolerance
budgeted), an `inv-ring + ÷2¹⁰` divider is sufficient and costs ~20
gates total. **Headline insight:** ring osc is *only* hopeless because
it sweeps a 3:1 frequency range PVT — but in *this* project, the
consumer with the tightest accuracy (NFC) self-clocks from the 13.56 MHz
field and **does not need an internal oscillator at all** in active
mode. So the loose-frequency consumer set may be entirely satisfiable
by a ring.

Physics-permitted but rare? **No.** The simplest possible.

### A2 — Current-starved ring (`ring-istarve`)

Each inverter's pull-up and pull-down current is gated through a
current source (PMOS / NMOS in saturation, biased by a reference). At
fixed bias current `I` and load capacitance `C_L`, the per-stage
propagation delay is `t_pd ≈ C_L·V_DD / (2·I)`. Period scales **linearly
with V_DD** (because both `C_L·V_DD` and the bias have the same V
dependence if the bias is also a V_DD divider) — but if the bias is
*temperature-stable* (e.g. Vbe-derived), the frequency is much less
voltage-sensitive than the raw inverter ring.

Where used: pretty much every commercial RC-oscillator IP block hides
a current-starved ring inside a constant-`gm` or PTAT bias. Many
"RC oscillator" IPs are actually ring-istarve.

Typical numbers: ±10 % over PVT untrimmed, ±2 % with eFuse trim;
quiescent current 0.1–10 µA depending on target frequency. Phase noise
is significantly better than raw ring because amplitude-limited drive
narrows white-noise integration.

Found insufficient when: The bias circuit takes 100s of µs to settle
on cold start (NFC tags' 5 ms field-application response budget can be
violated if the bias loop is too slow); under brown-out, the bias
current collapses below the ring's regenerative threshold and the
oscillator can stop without warning.

Why our project might still use it: **Best fit for the harvested-rail
"housekeeping" clock at 100 kHz–10 MHz.** A Vbe-referenced bias
naturally gives ±5 % across temperature. We can size for ~0.5 µA bias
to fit the µW power budget.

Physics-permitted but rare? **No.** This is the workhorse.

### A3 — Differential / pseudo-differential ring (`ring-diff`)

Each "stage" is a differential pair with cross-coupled regenerative
load. Even number of stages allowed (because the cross-coupling
provides the inversion). Doubles power vs single-ended ring but
cancels common-mode supply noise — PSRR improvement of ~20 dB at the
oscillator output.

Where used: SerDes clock recovery, ADC clocks, anywhere supply noise
from adjacent digital is the dominant jitter source.

Typical numbers: 2× area, 2× power vs single-ended; PSRR 30 dB; phase
noise -90 dBc/Hz at 1 MHz offset for a 1 GHz oscillator (typical 180 nm
SerDes block).

Found insufficient when: power budget below ~10 µA (the bias tail must
be on continuously) and area below ~5000 µm².

Why our project might still use it: For BLE LO synthesis at 2.4 GHz the
PSRR matters because the harvested rail is brown-out-prone. But BLE is
gated on items (a)–(j) being measured first — so this is reserved for
v3+. For v2's actual consumers it's overkill.

Physics-permitted but rare? **No.**

### A4 — Self-biased "constant-frequency-over-supply" ring (`ring-selfbias`)

A ring oscillator wrapped in a feedback loop that adjusts the
current-starve bias such that frequency tracks a *V_DD-independent*
reference (typically Vbe / Vt / a PTAT current). Because both the bias
and the load `C_L·V_DD` scale together when V_DD changes, a
properly-designed self-biased ring achieves **first-order V_DD
cancellation** without needing an explicit reference oscillator.
Maneatis/Horowitz 1996 showed the technique for PLLs but the same
self-bias loop is independently usable as an LFO.

Where used: PLL VCOs in 1990s-era SerDes; less common now because
fractional-N PLLs handle the V_DD problem differently.

Typical numbers: Frequency drift 50–500 ppm/V at the operating point,
2–10 % over -40 to 125 °C, all without explicit trim.

Found insufficient when: settling time of the bias loop (typically
1–10 µs) violates fast-startup requirements.

Why our project might still use it: **Fits the brown-out problem
well.** A self-biased ring gracefully scales its frequency *down* as
V_DD droops rather than stopping abruptly — this is the opposite of a
brittle "stops below 2.5 V" RC relaxation oscillator. For an LED
twinkle PWM that we'd rather see slow than die, this is desirable.

Physics-permitted but rare? **Yes — for our application.** Self-biased
rings are widely deployed in PLLs but I have not seen them advertised
as "graceful brown-out behaviour" timing references. The angle here
is that turning the V_DD-cancellation property *off-axis* and using
the supply-tracking behaviour as a feature for LED PWM is unusual.

### A5 — Schmitt-feedback "oscillator from one Schmitt gate"
       (`ring-schmitt-rc`)

A single hysteresis (Schmitt) inverter with an RC feedback network from
output to input. Output toggles every time the cap voltage crosses the
Schmitt's V_TH± rails. Period `T ≈ 2·R·C·ln((V_DD-V_TL)/(V_DD-V_TH))`.

Where used: Microcontroller "internal oscillators" of the 1980s
(8051's RC mode), discrete-IC astable multivibrators (555-style).

Typical numbers: 1–10 MHz with reasonable-area RC; ±20 % PVT
untrimmed because the Schmitt thresholds shift with V_DD; ±2 % with
4-bit trim on R.

Found insufficient when: V_DD drops below 2 V (Schmitt hysteresis
collapses); thermal noise on the Schmitt input multiplied by the slow
RC charge slope produces visible cycle-to-cycle jitter.

Why our project might still use it: **The simplest possible
RC-relaxation oscillator** — only one active gate. Useful for the
*power-up* clock that runs the eFuse readback before any analog bias
has settled. For NFC startup detection it could be the "is there a
field" timer.

Physics-permitted but rare? **No** (well-known).

## Family B — RC relaxation oscillators

### B1 — Comparator-RC relaxation (`rc-relax-classic`)

The textbook relaxation osc: a capacitor charged via a resistor toward
V_DD, then dumped to ground when its voltage reaches a comparator
threshold. Period `T = R·C·ln(...)`; the `ln(...)` term cancels if both
thresholds are set as fractions of V_DD via a resistor divider, giving
**first-order V_DD-independence**.

Where used: Every microcontroller's "8 MHz ±1 % internal RC" block.
Atmel/Microchip AVR, NXP Kinetis, ST STM32, Renesas RX, etc.

Typical numbers: ±1 % with factory trim, ±0.5 % with on-the-fly
calibration against a reference; ±5 % over -40 to 125 °C without
temperature compensation.

Found insufficient when: Quartz-precision applications (cellular RF,
GPS, USB host without SOF reclock). Also insufficient under fast
brown-out: when V_DD droops mid-cycle, the comparator thresholds
move and the cycle period jumps.

Why our project might still use it: **The widely-quoted "1 %
accuracy" depends on:** (i) clean V_DD with no droop on the µs-to-ms
timescale of one cycle; (ii) a comparator with offset drift below the
trim quantum (typ. 1 mV offset for 1 % accuracy at 100 mV swing);
(iii) factory trim available. (i) is **violated by our
harvested-rail context** — NFC load modulation pulls the rail at
847.5 kHz, exactly the timescale of an 8 MHz RC's cycle. So the
"1 %" number is misleading for *this project.* Without trim or in
brown-out we should expect ±5–10 % real-world.

Physics-permitted but rare? **No.**

### B2 — Bias-stabilised RC relaxation (`rc-relax-stable`)

Same as B1 but the comparator is replaced with a continuous-time
amplifier biased from a Vbe reference, and the charging current
source replaces the resistor. The "RC" is now `C / I_bias`, where
`I_bias` is constant over V_DD. This decouples the *frequency* from
V_DD almost entirely (the residual sensitivity is the cap's voltage
coefficient, ~100 ppm/V for MIM).

Where used: Precision RC oscillator IPs (e.g. ams TimePoint).

Typical numbers: ±0.5 % over PVT *with* eFuse trim; ±2 % untrimmed;
quiescent 5–50 µA; start-up dominated by Vbe bandgap settling
(50–500 µs).

Found insufficient when: cold-start budget below ~50 µs. Also: when
the bandgap reference is not present (e.g. when V_DD is below ~2 V,
the bandgap can't operate, so the oscillator can't either).

Why our project might still use it: For NFC tag emulation we need
~5 ms cold-start; bias-stabilised RC at ~50 µs settle is *perfectly
fine.* Power 5–50 µA is within the µW NFC budget.

**Physics-permitted but rare?** **No.**

### B3 — Switched-capacitor "frequency = I/(C·V)" relaxation
        (`rc-relax-switchedcap`)

The "R" of the RC is replaced by a switched capacitor `C_s` clocked at
some sub-rate `f_s`, giving an effective resistance `R_eff = 1/(f_s·C_s)`.
The relaxation oscillator frequency is then `f = K · f_s · (C_s/C)`.
The trick is that `f` is set by a **ratio of capacitors**, not absolute
values — and ratio matching of MIM caps in 180 nm is sub-0.1 %.

Where used: Bootstrap clock generators in switched-capacitor ADCs;
some discrete-time analog filters' clocks.

Typical numbers: Frequency ratio accuracy 0.1 %; absolute frequency
locked to whatever reference clocks `f_s`. If `f_s` itself comes
from a coarser oscillator, the cap ratio just *divides* it.

Found insufficient when: as a *standalone* primary timing reference,
because it needs a clock to clock itself.

Why our project might still use it: as a *trim-free divider* between
a coarse reference (NFC carrier ÷N) and a fine sub-rate clock (LED
PWM). Avoids needing a programmable divider with eFuse trim.

Physics-permitted but rare? **Yes — as a standalone TC.** Usually
seen *inside* an SC analog block, not exposed as a public timing
reference. For our project's NFC-locked sub-rate generation it's an
unusual but clean fit.

### B4 — Twin-T / Wien-bridge sinusoidal relaxation (`rc-twint`)

A Wien-bridge or Twin-T network in the feedback path of an op-amp
produces a near-sinusoidal oscillation at `f = 1/(2π·R·C)` with very
low harmonic distortion. Frequency depends only on R and C
(magnitudes, not ratios), so it's no more accurate than B1 in absolute
terms but produces a much cleaner sinewave.

Where used: 1960s vacuum-tube and early-IC audio oscillators (HP-200A,
the original HP product). Very rare in deep-submicron.

Typical numbers: THD < 0.01 % achievable; frequency stability matched
to R·C tolerance (5–20 % untrimmed).

Found insufficient when: digital clock applications (it's a sinewave,
not a square wave; needs squaring before it's useful as a clock).

Why our project might still use it: We don't need this — we need
square-wave clocks for the digital. **Listed for completeness.**

Physics-permitted but rare? **Yes — but for legitimate reasons.**
Sinewave-only output is the wrong primitive for a timing block; that's
why nobody uses it.

## Family C — LC tank (with on-die inductor)

### C1 — Cross-coupled NMOS LC tank (`lc-xcouple-nmos`)

Two cross-coupled NMOS transistors with their drain nodes connected to
an LC tank between V_DD and the drains. The negative resistance from
the cross-coupling (`g_m_eff = -2/g_m`) sustains oscillation against
tank loss `R_p = ω·L·Q_L`. Oscillation condition: `g_m·R_p ≥ 1`.

Where used: Above ~3 GHz on every modern process node (cellular,
WiFi, BLE LOs). Below 1 GHz, area cost of the inductor becomes
prohibitive.

Typical numbers (this PDK):
- On-die spiral inductor at 2.4 GHz: 3–5 nH practical, Q ≈ 8–12 on
  GF180MCU's top metal (5 µm thick TM2). Inductor area ~150×150 µm
  for 3 nH.
- Tank impedance `R_p = ω·L·Q ≈ 2π·2.4e9·3e-9·10 ≈ 450 Ω`. NMOS g_m
  needed ≈ 1/(2·R_p) ≈ 1/900 → at I_D = 1 mA, V* = 0.2 V, g_m = 10 mA/V,
  ample.
- Phase noise (Leeson approximation): `L(Δf) = 10·log₁₀[ 2·F·k·T·R_p
  / (V_osc²) · (f_0/Δf)² ]`. For V_osc = 1 V, F = 4 (typical noise
  factor), Δf = 1 MHz, f_0 = 2.4 GHz: L ≈ -110 dBc/Hz. **Adequate for
  BLE.**

Found insufficient when: required tuning range is wider than
~10 % (LC Q narrows the bandwidth); below 1 GHz where the inductor
gets impractically large.

Why our project might still use it: **Required for BLE.** No competing
topology can hit BLE's phase-noise mask without an inductor at
2.4 GHz on this node. But BLE itself is aspirational and gated.

Physics-permitted but rare? **No** (everywhere in RF).

### C2 — Class-C / quadrature LC tank (`lc-classc`)

Variants on C1 with current re-use (Class-C) or two coupled tanks
(quadrature). Same physics, lower power-per-noise, more area.

Listed for completeness. No application in v2.

Physics-permitted but rare? **No.**

### C3 — LC tank using PCB-loop inductor (`lc-pcb-loop`)

The project allows PCB loop antennas as "off-die inductors." Could the
NFC PCB loop (~1 µH at 13.56 MHz, 4-turn 80×50 mm) double as the L of
an oscillator's LC tank?

Physics: yes. f = 1/(2π·√(L·C)). For 1 µH and a 137 pF cap (the value
needed to resonate at 13.56 MHz, item (b)'s anyway), f = 13.56 MHz on
the dot. Cross-coupled NMOS needs only ~100 µA to sustain.

Why this is interesting: **The 13.56 MHz NFC antenna IS already being
specified to resonate at 13.56 MHz.** That tank, if Q is high enough,
can phase-lock the on-die oscillator without any reference XO. The
chip oscillates at 13.56 MHz when the PCB is built to spec — even when
no NFC field is present, because the only thing the antenna needs from
the field is a kick to start, and our cross-coupled pair provides
that.

Where used: VERY rare. Some passive RFID tags use carrier-derived
clock when the field is present (regenerative recovery) — that's
different, that's the field-clocked mode. Using the *antenna's
self-resonance* as the timing reference when no field is present is,
to my knowledge, not standard practice.

Found insufficient when: Q is too low. PCB loop Q at 13.56 MHz with
copper traces is typically 30–80, which is great. The trick is that
the chip's switch-mode rectifier and modulator load the tank, dropping
loaded-Q dramatically.

Why our project might still use it: a single high-Q resonator that
serves THREE roles — NFC antenna, NFC carrier-clock recovery, and
internal oscillator-when-cold — is very area-efficient. **Headline
candidate.**

Physics-permitted but rare? **YES.** This is exactly the kind of
topology a first-principles search produces and a literature search
misses, because the literature is filled with "use a ring osc when no
carrier" boilerplate.

### C4 — LC tank using bondwire inductor (`lc-bondwire`)

Each bondwire is ~1 nH/mm. Two opposing bondwires from a Vdd pad and
a common-mode pad form an LC tank with on-die cap. At 1 nH the
resonance is 1.6 GHz with 10 pF — applicable to the BLE LO.

Where used: bondwire-tank VCOs in some commercial transceivers (e.g.
some 1990s-era cellphone chips). Modern designs have moved to on-die
spirals for repeatability.

Found insufficient when: bondwire length variability is ±50 %, so
absolute frequency accuracy is poor without a calibration loop.

Why our project might still use it: "Free" inductor that costs zero
die area. Combined with a capacitor bank tuned by eFuse, can save
~20 000 µm² over an on-die spiral.

Physics-permitted but rare? **Yes — currently rare; was once common.**

## Family D — Sub-threshold / weak-inversion oscillators

### D1 — Sub-threshold ring with constant-gm bias (`subthresh-ring`)

Run inverters with V_DD below threshold (so the gates' small-signal
gain `g_m/g_ds` is large but quiescent currents are pA-to-nA). Useful
when total power is limited to *picowatts*.

Where used: medical-implant "wakeup" clocks; the lowest-power MCU
secondary clocks (TI MSP430's VLO at 12 kHz draws ~0.5 µA — that
*could* be sub-threshold).

Typical numbers: Frequency 10 Hz–10 kHz; quiescent power 10–500 nW;
±50 % drift over PVT untrimmed because sub-threshold I_D depends
exponentially on Vt and T.

Found insufficient when: any output frequency above 1 MHz; any
accuracy spec tighter than ±20 %.

Why our project might still use it: **Best fit for "always-on
brown-out detector" clock.** A 1 kHz, 10 nW oscillator that runs even
when the harvested rail is at 1.0 V is what tells the chip "rail is
back, wake up." None of the higher-power oscillators can run that
low.

Physics-permitted but rare? **No** (well-established for ULP).

### D2 — gm/C oscillator using sub-threshold gm (`subthresh-gmc`)

A transconductor in sub-threshold, with output integrated on a cap C.
When integrator output reaches a threshold, the integrator is reset
and a clock edge is emitted. Frequency `f = g_m/(C·V_swing)`. Because
sub-threshold `g_m = I_D/(n·V_T)` and `V_T = kT/q`, the frequency is
**proportional to absolute temperature** — useful as a temperature
*sensor*, harmful as a clock.

Where used: integrated temperature sensors (e.g. Pertijs/Makinwa
thermal-sense IPs).

Found insufficient when: used as a frequency reference without a
temperature compensation loop.

Why our project might still use it: Counter-intuitively, **as a
free temperature sensor** that the digital can read by counting
cycles vs the NFC carrier clock. Could enable a "card temperature"
NDEF field with no extra ADC.

Physics-permitted but rare? **Yes — as a clock,** common as a temp
sensor.

## Family E — Mixed-signal frequency-locked / injection-locked

### E1 — Free-running ring + frequency-locked-loop (FLL) to a slow
       reference (`fll-locked`)

A free-running ring oscillator has its frequency divided down by N and
compared to a slow reference (e.g. the NFC subcarrier at 847.5 kHz, or
a temperature-stable Vbe-derived 32 kHz oscillator). A digital
integrator drives a varactor / cap-bank in the ring to null the
frequency error.

Where used: early DTVs, set-top boxes; "frequency-locked" Wi-Fi BB
clocks.

Typical numbers: Loop bandwidth 100 Hz to 10 kHz; locked-state
accuracy = reference accuracy / N.

Found insufficient when: reference is intermittent (FLL goes
free-running and drifts).

Why our project might still use it: **The NFC carrier IS a precision
reference (±50 ppm at the reader),** present whenever NFC mode is
active. An FLL of a free-running ring to the NFC carrier gives the
chip a precision clock, *for free*, while the field is present. When
the field disappears the FLL holds last-known cap-bank value and the
ring drifts back to its untrimmed accuracy.

This is the architecture I'd recommend for the BLE case if BLE ever
ships: NFC tap → FLL learns trim → eFuse-burns the trim word →
post-burn the chip starts up at correct frequency without needing the
NFC field.

Physics-permitted but rare? **Yes — for this specific use case.** FLLs
to the NFC carrier are rare because NFC tags are not normally
expected to provide precision LOs to other subsystems.

### E2 — Injection-locked ring to NFC carrier (`inj-lock-nfc`)

The NFC carrier (13.56 MHz) is fed weakly into a tap of a free-running
ring oscillator whose natural frequency is close to a sub-multiple
(e.g. 13.56 MHz / 1, or 27.12 MHz / 2). The ring injection-locks to
the carrier with no explicit phase detector or filter. Pull-in range
is typically ±10 % around the natural frequency for modest injection
strength.

Where used: receiver LO sub-harmonic locks in some Bluetooth designs;
older quartz-crystal-locked digital clocks.

Typical numbers: Lock time < 1 µs (very fast — much faster than FLL).
Frequency accuracy = reference accuracy when locked. Out-of-band
spurs at carrier offsets.

Found insufficient when: reference disappears (ring instantly drifts
to natural).

Why our project might still use it: **The fastest possible
"wake-up to precision-clocked" path.** Field on → 1 µs later → ring
is at 13.56 MHz with ppm-level accuracy. Combined with a coarse cap
bank for free-running operation between field events.

Physics-permitted but rare? **Yes — for NFC-tag housekeeping clocks.**

### E3 — Carrier-derived clock: "no oscillator at all" (`carrier-clk`)

Strictly speaking not an oscillator but a *receiver* — recover the
13.56 MHz carrier directly with a comparator on the antenna and use it
as the system clock. ISO14443A specifies that all tag timing is
derived from the carrier (`f_c/16 = 847.5 kHz` subcarrier,
`f_c/128 = 105.9 kHz` bit clock, `f_c/64 = 211.875 kHz` "ETU"). NFC
tags traditionally require *no* internal oscillator while the field
is present.

Where used: every passive ISO14443A tag IC ever made (NXP NTAG21x,
NXP MIFARE Ultralight, etc.).

Typical numbers: clock accuracy = reader accuracy = ±50 ppm; current
draw for the recovery comparator is part of the receiver, ~1 µA.

Found insufficient when: no field present (LED twinkle mode under Qi
or 2.4 GHz harvesting); we need timing for the LED PWM and brown-out
detector even with no NFC.

Why our project should use it: **For the NFC mode, this is mandatory
free architecture.** The internal oscillator's job is *only* to cover
the modes where no carrier is present.

Physics-permitted but rare? **No** (universally used).

## Family F — Thermal / chemical / mechanical (mostly rejected)

### F1 — MEMS resonator on die (`mems-osc`)

A resonating MEMS mass etched into the die. SiTime / Discera produce
commercial parts; the resonator is a discrete die in their case. On
a regular CMOS process like GF180MCU there are no MEMS layers
exposed.

Where used: standalone timing chips (SiTime SiT15xx).

Found insufficient when: implemented on a CMOS-only PDK without
post-processing — *which is our case.*

Why our project rejects it: GF180MCU has no MEMS layer.

Physics-permitted but rare? **Rejected.** Not physically possible in
this PDK.

### F2 — Thermal feedback oscillator (`thermal-osc`)

A heating element's thermal time constant interacts with a sensor to
form an oscillator (period set by the thermal RC). Used in RTD-based
flow sensors and similar.

Found insufficient when: the time constants are seconds (heat capacity
of die >> electrical capacitance of any reasonable cap), so frequency
is 0.01–10 Hz only. Wildly drift-prone with ambient temperature.

Why our project rejects it: too slow for any consumer except the LED
twinkle, and we have many cheaper options for that.

Physics-permitted but rare? **Yes — but legitimately dead-end.**

### F3 — Photo / ambient-light driven oscillator (`photo-osc`)

A photo-diode in feedback with a comparator, with the only timing
component being the photo-diode's small-signal RC. Frequency depends
on incident light. Used in some children's toys.

Why our project rejects it: card may be in a wallet (dark); also, NFC
mode requires phone-screen-illuminated card, which is bright but
variable.

Physics-permitted but rare? **Yes — but uncontrollable.**

### F4 — Acoustic / piezoelectric resonator (`piezo-osc`)

External quartz / ceramic resonator. **Rejected by project constraint
(no external passives).**

### F5 — Chemical oscillator (Belousov-Zhabotinsky) (`chem-osc`)

Yes, this is a valid oscillator class in physics. No, you cannot
build it in GF180MCU. **Rejected.**

## Family G — Hybrid / multi-clock architectures

### G1 — Two-tier clock: cheap-fast + slow-precise (`hybrid-2tier`)

A free-running ring (cheap, fast, drifty) handles the digital state
machines; a slow precision reference (Vbe-stabilised RC at 32 kHz, or
the carrier-derived clock) is *only* used to set the trim cap-bank
of the ring at startup. Most stdcell digital sees only the ring; the
analog reference can be turned off after trim.

Where used: power-aware MCUs (TI MSP430, NXP Kinetis low-power
modes).

Found insufficient when: digital must be re-trimmed under temperature
(Kinetis-class MCUs do periodic re-trim during sleep wakes; that's
fine).

Why our project might use it: **This is the architecture I'd
recommend for v2's primary internal clock.** It's the natural fit
when you have one always-on slow reference (32 kHz sub-threshold ring)
and one fast main clock (current-starved ring).

Physics-permitted but rare? **No** (well-established).

### G2 — Three-tier clock with NFC carrier as 2nd-tier reference
        (`hybrid-3tier-nfc`)

G1 plus the NFC carrier as the *highest-precision* reference: when
NFC is active, the FLL/IL block calibrates the trim cap bank from the
carrier; eFuse stores the trim. All other modes use the eFuse value.

This is the unique-to-this-project hybrid I'd actually advocate for.

Physics-permitted but rare? **Yes — specific to dual-mode chips with
both an RF receiver and a non-RF mode.**

## Family H — Esoteric / borderline

### H1 — Stochastic / true-random "clock" (`tr-rng-clk`)

A noise-driven divider where each cycle is set by `n` thermal-noise
events. Average frequency stable to √n; instantaneous frequency
varies wildly. Used as random-number generators, not clocks. Rejected
as clock.

### H2 — Spread-spectrum / dithered ring (`spread-clock`)

Intentionally-modulated ring osc whose centre frequency is dithered
to spread emissions for EMI compliance. *Adds* uncertainty rather than
removing it. Could be useful for the ambient-RF-harvesting mode where
we don't want our digital noise re-radiated through the harvester
tank — *yes, that is a real concern* per item (d) §"verify."

Physics-permitted but rare? **Yes — niche.**

## Family I — "No internal oscillator at all" architectures

### I1 — VGA mode: external clock (`no-osc-vga`)

VGA mode runs from `clk_PAD`, supplied by the breakout connector. No
internal oscillator needed in this mode. **Already the v1 architecture.**

### I2 — NFC mode: carrier-derived (`no-osc-nfc`)

See E3.

### I3 — LED twinkle mode: digital-only LFSR clocked by an
        NFC-tap-burned eFuse-defined slow ring (`no-osc-led-fallback`)

A degenerate case where, in *any* mode, the LED PWM is clocked by an
extremely slow ring whose period was burned at NFC programming time.
The ring is so slow (1–10 kHz) and the duty cycle so low that ±50 %
frequency error is invisible to the eye.

This is essentially the same as A1 ("raw inverter ring"), packaged
explicitly as the *only* internal oscillator with the rest delegated.

Physics-permitted but rare? **No.**

## Summary count

By family:
- A (ring): 5 distinct topologies (A1–A5)
- B (RC relax): 4 (B1–B4)
- C (LC tank): 4 (C1–C4)
- D (sub-threshold): 2 (D1–D2)
- E (mixed-signal lock / FLL): 3 (E1–E3)
- F (rejected exotic): 5 (F1–F5)
- G (hybrid): 2 (G1–G2)
- H (borderline): 2 (H1–H2)
- I (no-osc architectures): 3 (I1–I3)

Total distinct entries: **30**, of which "physics-permitted but rare
for our application" headlines: **C3 (PCB-loop tank as cold-clock),
E1 (FLL to NFC carrier), E2 (injection-lock to NFC carrier),
G2 (3-tier with NFC carrier as a reference), C4 (bondwire tank for
BLE), D2 (sub-threshold gmC clock as a temp sensor), B3 (switched-cap
relaxation for ratio-precise sub-rate generation), A4 (self-biased
ring with brown-out tracking)**.

## Comparison-readiness table (TEMPLATE.md §9 format)

| Approach | Headline performance | Area / power cost | Maturity | Best fit for | Worst fit for |
|---|---|---|---|---|---|
| `ring-raw` (A1) | f = 1/3·N·t_pd, ±50 % PVT, ~30 ps RMS jitter at 1 GHz | <100 µm², <1 µA (gated) | Trivial | LED-twinkle PWM, eFuse program timer | Anything ppm or ms-stable |
| `ring-istarve` (A2) | ±10 % untrimmed, ±2 % trimmed, μA range | ~300 µm², 0.5–10 µA | High | µW housekeeping clock at 100 kHz–10 MHz | Cold-start <50 µs |
| `ring-diff` (A3) | PSRR +20 dB, -90 dBc/Hz @ 1 MHz off 1 GHz | 5000 µm², 100–500 µA | High | BLE LO front-end (post-LC) | µW budgets |
| `ring-selfbias` (A4) | First-order V_DD cancel; graceful brown-out drift | ~500 µm², 5 µA | Medium | Brown-out-tolerant LED PWM, harvested rail | Tight-ppm spec |
| `ring-schmitt-rc` (A5) | ±20 % PVT untrimmed, simplest possible RC | <50 µm², <1 µA | Trivial | Power-up clock for eFuse readback | V_DD < 2 V |
| `rc-relax-classic` (B1) | ±1 % trimmed (clean V_DD), ±5–10 % under brown-out | ~2000 µm², 5–50 µA | Very high | MCU 8 MHz with stable rail | Brown-out-prone harvested rails |
| `rc-relax-stable` (B2) | ±0.5 % trimmed; needs Vbe bandgap | ~5000 µm², 10–50 µA | Very high | NFC tag housekeeping with margin | Cold-start <50 µs; V_DD < 2 V |
| `rc-relax-switchedcap` (B3) | Cap-ratio precise (~0.1 %); relative-freq only | <500 µm², ~1 µA | Niche | Sub-rate divider from NFC carrier | Standalone reference |
| `rc-twint` (B4) | Sinewave; THD < 0.01 %; ±5–20 % freq | ~3000 µm², ~50 µA | Legacy | Audio analog | Digital clock |
| `lc-xcouple-nmos` (C1) | -110 dBc/Hz @ 1 MHz off 2.4 GHz, ±10 % tuning | ~30 000 µm² (incl. inductor), 1 mA | High (RF) | BLE LO | Sub-GHz frequencies |
| `lc-pcb-loop` (C3) | 13.56 MHz natural lock, Q ~30–80 free | ~zero on-die (off-die L) | **Novel** for cold-clock | NFC-resonant cold clock | Modes where antenna is loaded |
| `lc-bondwire` (C4) | 1–2 GHz with 1 nH bondwire; ±50 % L spread | "free" L, ~50 000 µm² cap-bank | Legacy | BLE LO if on-die spiral too costly | Production yield |
| `subthresh-ring` (D1) | 1 kHz, 10 nW; ±50 % drift | <100 µm², 10 nW | High (ULP) | Always-on brown-out timer | Anything precision |
| `subthresh-gmc` (D2) | f = g_m/(C·V); PTAT-locked | ~300 µm², ~100 nA | Niche | Free temp sensor | Stable clock |
| `fll-locked` (E1) | ppm accuracy when locked to NFC carrier | ~5000 µm² loop + ring | Medium | Calibrated internal clock | When NFC absent forever |
| `inj-lock-nfc` (E2) | <1 µs lock; ppm when locked | ~1000 µm² + ring | Niche | NFC mode housekeeping | Field-absent operation |
| `carrier-clk` (E3) | ±50 ppm (reader-derived); 1 µA recovery | ~200 µm² | Universal in NFC | NFC active | NFC absent |
| `mems-osc` (F1) | n/a — not in PDK | n/a | Rejected | n/a | n/a |
| `thermal-osc` (F2) | 0.01–10 Hz | n/a | Rejected | n/a | n/a |
| `photo-osc` (F3) | Light-dependent | n/a | Rejected | n/a | n/a |
| `piezo-osc` (F4) | Quartz precision | n/a | Forbidden by no-passives constraint | n/a | n/a |
| `chem-osc` (F5) | Hours-period | n/a | Rejected | n/a | n/a |
| `hybrid-2tier` (G1) | Mixes A1+B2 properties | Sum of 2 | High | General µC sleep / wake | n/a |
| `hybrid-3tier-nfc` (G2) | Adds E1/E2 carrier-trim on top of G1 | Sum of 3 | **Novel** for dual-mode chips | This project's exact spec | Single-mode chips |
| `tr-rng-clk` (H1) | Average-stable, instantaneous-random | n/a | Rejected as clock | RNG | Clock |
| `spread-clock` (H2) | Spread-spectrum dithered ring | A1+small | Niche | EMI / 2.4 GHz harvest mode | Need exact-frequency timing |
| `no-osc-vga` (I1) | External `clk_PAD` 25.175 MHz | 0 | Universal | VGA mode | Other modes |
| `no-osc-nfc` (I2) | Carrier-derived | 0 | Universal | NFC mode | Field-absent |
| `no-osc-led-fallback` (I3) | A1 packaged as the only osc | A1 | Trivial | Minimal v2 | If LED needs precision |
