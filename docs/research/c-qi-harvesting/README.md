# (c) Qi power harvesting — research home

**Goal (from [`TODO.md`](../../../TODO.md#c-qi-power-harvesting-100205-khz-lf-two-pin-antenna-loop)):**
rectify the 100–205 kHz Qi LF magnetic field on a charging pad into the
harvested rail.

## Scope of research

1. **Qi standard families.** Qi 1.x BPP (5 W), Qi 2.x EPP / MPP
   (15 W, MagSafe-compatible). Spec-relevant: operating-frequency
   range, in-band communication (load modulation 2 kHz back-channel),
   foreign-object-detection requirements that may interfere with a
   non-compliant receiver.
2. **Coil topology** — multi-turn PCB coils, ferrite-backed coils,
   coil geometries inside the ISO 7810 ID-1 envelope. Inductance,
   self-resonance, Q.
3. **Rectifier topology** — full-bridge, voltage doubler, synchronous
   active rectifier (much easier at 100 kHz than at 13.56 MHz —
   investigate why).
4. **Receiver compliance levels** — full Qi-compliant transponder
   (with WPC-defined CEP / RPP / FOD signalling) vs simplified
   "free-rider" / "load and dump" approach where the receiver does
   not negotiate with the transmitter.
5. **Coexistence with NFC.** Both (b) and (c) want a multi-turn
   PCB coil; the companion PCB co-locates them on different inner
   layers. Investigate published designs that integrate both Qi and
   NFC reception, including how the resonant modes are kept apart.
6. **Over-voltage / FOD interaction.** A non-compliant receiver may
   trigger foreign-object-detection on some chargers and be shut
   down. What's the published guidance?
7. **Physics sanity check.** Conservation of energy vs the user-facing
   claim that "5 W from a Qi pad can dump into our caps" — the chip
   only needs µW-mW, so this is a power-throttling problem, not a
   power-availability problem. But over-voltage / heating during
   throttle is a real concern.

## Status

See [`../INDEX.md`](../INDEX.md).
