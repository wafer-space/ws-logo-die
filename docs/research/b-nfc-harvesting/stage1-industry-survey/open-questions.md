# Open questions (industry-survey angle)

Questions that this Stage-1 industry-survey raised but cannot answer
within the survey scope. Each is phrased so that the dependent
downstream decision is explicit and a settling-investigation is
proposed.

## OQ-IND-1. What does the industry's "5 mA at 2 V" actually mean for a phone vs a bench reader?

**The question:** NXP NT3H2x11 datasheet says *"typically 5 mA at
2 V on the VOUT pin with an NFC Phone"*; ams AS3955 says *"up to
5 mA at 4.5 V"* (presumably at strong-coupling bench reader);
NTAG 5 says *"up to 50 mW high-field"*. Which of these is the right
**design target** for a *typical phone tap* on a *credit-card-sized
PCB loop* (our actual use case)?

**Why it matters:** sets the (f) LED twinkle current budget and the
(h) NFC core's modulation duty cycle. Difference between "few mW"
(NT3H2x11) and "tens of mW" (NTAG 5) is the difference between
"twinkle dimly" and "drive RGB LEDs at full brightness".

**Settling investigation:** measurement on a real phone with the
existing v1 die's pad ring instrumented for inducted-V measurement,
or careful EM co-sim of the actual companion-PCB antenna against
a calibrated phone-class reader model.

## OQ-IND-2. Can we omit the trim-cap bank in v2 and still hit resonance?

**The question:** Industry trim-cap banks (T-IND-Trim) compensate
for ±5 % PCB-inductance tolerance. For a *one-off business-card*
production run with hand-tuned PCB inlays, can we ship a fixed
on-die Cic and let the PCB designer adjust trace width to land on
13.56 MHz?

**Why it matters:** trim bank costs ~24 pF MIM (negligible) plus
4–8 eFuse bits (notable — depends on (j) eFuse infrastructure
maturity). Skipping it simplifies (j) and shortens the BOM, but
loses tolerance margin against PCB-batch variation.

**Settling investigation:** confirm with the PCB team what
production tolerance they can hold on the loop antenna inductance.
If ≤ ±10 %, fixed Cic is plausible; if > ±10 %, trim bank is
required.

## OQ-IND-3. Will reusing the (h) load-modulator NMOS as an OV clamp create a fault-mode trap?

**The question:** Industry patent literature (NXP US 8,326,224)
re-uses the cross-coupled-rectifier NMOS arms as both rectifier
and clamp. We propose extending this to also re-use the (h) NFC
core's modulator NMOS as an emergency clamp. *Does this create a
spurious-modulation hazard* in the over-voltage corner — i.e. can
the reader misinterpret a clamp event as a load-modulation
subcarrier?

**Why it matters:** if yes, the reader will see the tag emit
phantom subcarrier during peak-voltage events, breaking the
ISO 14443 anticollision protocol. If no, we save 0.05–0.1 mm² of
modulator NMOS area.

**Settling investigation:** spectral-content sim of the antenna
voltage with a reader receiver model during over-voltage clamp
events. Stage-2 / Stage-4 spice work.

## OQ-IND-4. Is the 5.1 ms NFC Forum polling-gap requirement a hard limit for our chip?

**The question:** NFC Forum Activity spec (referenced by NT3H2x11
datasheet §8.6) requires the reader to insert ≥ 5.1 ms Field-Off
gaps between polling cycles. **Without** the external 220 nF cap,
our on-die ~12 nF cap cannot ride this gap. Can we (h) negotiate
with the reader (using a non-standard tag-type advertising) to
extend the Field-On time, or do we just accept brown-out?

**Why it matters:** if we must accept brown-out, the digital state
of the (h) NFC core resets every 5.1 ms — i.e. the chip must
re-anticollision and re-respond to commands in every cycle, which
breaks any session-based protocol (NFC Type 4 session, NDEF write
state, etc.). Type-2 read-only tag emulation may still be viable
because it's stateless per command.

**Settling investigation:** read the NFC Forum Activity spec in
detail (not in the cached ISO 14443-2 PDF — separate document);
identify which tag types tolerate brown-out gracefully; align with
(h) decision on tag-type targeting.

## OQ-IND-5. Is the native nFET (`nfet_06v0_nvt`) usable for the rectifier or only as start-up seed?

**The question:** the first-principles report leans heavily on the
native nFET as a low-Vth replacement for Schottky. Industry
*doesn't* use natives this way (industry uses R-CC instead). Why?

**Hypothesis 1:** native nFETs leak too much in reverse to be
practical (manageable in Stage-4 sim).
**Hypothesis 2:** industry foundries don't always offer a native
flavour, so vendors stay portable by using R-CC.
**Hypothesis 3:** R-CC is just enough better that the native
gain isn't worth the design risk.

**Why it matters:** if natives ARE workable as the main rectifier
device, we could ship a much simpler topology (R-IND-2 with
natives) than industry's R-CC and still get 88 % efficiency.

**Settling investigation:** Stage-4 spice sim of native-nFET-only
bridge with realistic reverse-leakage extraction across PVT.

## OQ-IND-6. Can we rely on the rectifier-output MIM cap to also serve as the V_REG bulk cap?

**The question:** industry separates the V_RECT smoothing cap (1 nF
class, smooths carrier ripple) from the V_REG bulk cap (220 nF class,
holds rail through events). On our area-constrained die, can we
collapse them into a single ~12 nF cap on V_REG with no separate
smoothing cap?

**Why it matters:** doubles the effective bulk cap. The trade-off
is that V_RECT then carries the full carrier ripple (~10 %) into
the regulator's input, which the regulator must reject. PSRR at
27 MHz is poor for series LDOs — but for shunt regulators it
matters less (the shunt absorbs ripple as part of normal operation).

**Settling investigation:** Stage-4 spice sim of V_RECT ripple at
the shunt regulator output without an upstream smoothing cap.

## OQ-IND-7. What is the right Vout target — 1.8, 2.4, or 3.3 V?

**The question:** NTAG 5 lets firmware pick 1.8 / 2.4 / 3.0 V.
Industry favours lower Vout to reduce shunt dissipation; LED Vf
favours higher Vout (red/green ~2.0 V, blue/white ~3.0 V); digital
core favours lower Vout (less leakage). What's our target?

**Why it matters:** sets the digital library (5 V vs 1.8 V flow),
the LED colour choice (item (f) constraint), and the shunt-
regulator power dissipation budget.

**Settling investigation:** combined item (f) (LED colour) + item
(i) (power domain) trade-study. Default plan: 3.3 V to support both
red+green and blue+white LEDs, accept higher shunt dissipation.

## OQ-IND-8. Does our die need a separate "field-detect" pin like industry?

**The question:** every commercial tag IC exposes a field-detect
output (NXP "FD", TI "INTO") so the host MCU can wake on NFC
presence. We have no MCU. Do we need this *internally* (as a
trigger for the (f) LED twinkle pattern generator) or is the
B-IND-Powercheck output sufficient?

**Why it matters:** field-detect is a much earlier signal than
power-check (FD ≈ "field exists at all"; power-check ≈ "field can
support load current"). A two-stage signal chain may be useful for
LED behaviour design (twinkle starts as soon as field exists, gets
brighter once power-check confirms enough current).

**Settling investigation:** (f) LED twinkle architecture design.

## OQ-IND-9. Has any commercial NFC tag IC ever shipped without external Vout cap?

**The question:** every commercial tag we surveyed mandates an
external 100–220 nF cap. Has *any* shipping silicon dropped this
requirement? If so, how?

**Why it matters:** would change our "we are the first" framing
and expose prior-art techniques we could borrow.

**Settling investigation:** literature search for "fully integrated
passive RFID" / "single-chip NFC tag" with attention to whether
the chip is *truly* standalone or whether the antenna inlay still
includes a discrete cap.

## OQ-IND-10. Does the ISO 14443 "Class 1" Hmin = 1.5 A/m apply to *our* form factor?

**The question:** ISO/IEC 14443-2:2010/Amd.2:2012 Table 2 specifies
Hmin per PICC class (1, 2, 3, 4, 5, 6) based on PICC physical
size. Our 80 × 50 mm card sits between Class 1 (largest credit
card) and Class 5 (small inlay). Which Hmin do we design to?

**Why it matters:** sets the brown-out boundary and the (b)
sub-system's H-field operating range. Class 1 (1.5 A/m) is the
permissive case; Class 5 (2.5 A/m) is more demanding.

**Settling investigation:** measure card vs ISO 10373-6 Reference
PICC outlines (the ISO 14443-1 dimensional spec). The 80 × 50 mm
form factor likely fits within Class 1 or Class 2, giving Hmin =
1.5 A/m. Confirm in Stage 2.
