# Open questions (item c, Stage 1 first-principles)

## O1. Actual primary-coil current and field strength on representative Qi pads

**Question:** What is the peak magnetic-field flux density `B_pk`
at the active-area centre of (a) a typical 5 W BPP pad and (b) a
typical 15 W EPP pad, as a function of position?

**Decision:** §5.2 `V_oc` calculation and the input-clamp voltage
rating. Currently assumed 2 mT_pk → 31.5 V_pk; EPP could push
5 mT_pk → 78.7 V_pk.

**How to settle:** Calibrated B-field probe measurement, or
literature/datasheet search for a reference design's published
`I_p` combined with Biot–Savart for the primary geometry.

## O2. Coupling coefficient `k` distribution over realistic placement

**Question:** For the companion PCB's 8T 56×40 mm coil placed on a
standard A1 / MP-A11 / MP1 Qi BPP transmitter, what is the
distribution of `k` over (a) ideal centred placement, (b) lateral
5 mm displacement, (c) elevation +1 mm?

**Decision:** §5.3 power-delivery numbers; worst case `k → 0.02`
at the edge of the active area collapses `V_induced` from 8 V_RMS
to ~1 V_RMS, below passive-bridge turn-on.

**How to settle:** 3D EM simulation (FEMM / ANSYS / COMSOL) or
prototype-PCB measurement.

## O3. Quantitative FOD trip threshold across vendor pads

**Question:** What is the distribution of FOD trip thresholds
across the major Qi-pad vendors (Apple, Samsung, Anker, IKEA,
Ugreen, etc.)?

**Decision:** Maximum safe absorbed power for D2 without triggering
FOD blacklist.

**How to settle:** Empirical bench measurement on a representative
vendor pad inventory.

## O4. Native NMOS Vth at 25 °C and PVT spread

**Question:** The PDK file gives nominal `nfet_06v0_nvt_vth0 =
'-0.039'`, but native devices have large process variation. What
is the SS / TT / FF Vth at 25 °C, and how much does it shift over
−40…+125 °C?

**Decision:** Choice between FP-2 (B2 native bridge) and FP-3 /
FP-4 (active rectifier hybrid).

**How to settle:** SPICE corner sims of the diode-connected
device.

## O5. NFC coil's loading effect on Qi coil at 140 kHz

**Question:** §5.8 estimates that the NFC coil at 140 kHz looks
near-shorted (`ωL_NFC ≈ 1.2 Ω`) and via mutual coupling
`k ≈ 0.3–0.7` loads the Qi coil. How much actual power is lost?
Does the L2 NFC loop need an isolating switch during Qi mode?

**Decision:** Whether we need an explicit FET switch on the NFC
path during Qi mode.

**How to settle:** EM cosim of the two-coil PCB stackup, or an
analytic two-port circuit model with Neumann-formula M.

## O6. Storage-cap voltage rating budget

**Question:** Per §5.6, our µW-load storage cap is feasible at the
1.5 fF/µm² density (6 V tolerance). But the rectifier output rail
*before* the LDO is in the 5–6 V range under shunt-clamped
operation. Do we need the 1.0 fF/µm² (20 V) MIM and accept the
1.5× area penalty?

**Decision:** Total cap-array area allocation.

**How to settle:** Transient simulation of shunt-clamp loop step
response.

## O7. Multi-coil "free-positioning" Qi pads behaviour

**Question:** Some Qi pads (Apple's older mat designs, Samsung's
tri-coil) energise multiple primary coils. How does a free-rider
receiver behave on such pads?

**How to settle:** Empirical testing.

## O8. EPP / MPP frequency-band variants

**Question:** EPP can run 100–148 kHz (similar to BPP) and at
higher rates; MPP runs at 360 kHz. At 360 kHz our 6.2 µH coil's
`ωL_s` rises to 14 Ω from 5.5 Ω; does the rectifier and shunt
design need modifications?

## O9. Reference-verification gap on Mohan et al. spiral inductance coefficients

**Question:** §5.1 uses K1 = 2.34, K2 = 2.75 from Mohan et al.
1999. These are widely-cited but I did not personally fetch the
IEEE Xplore page.

**How to settle:** WebFetch the IEEE abstract or open-access mirror
of the Mohan paper.

## O10. NFC↔Qi coupling cap-bank on chip

**Question:** Could a switched-cap bank between the two PCB coils
be built on-die to deliberately couple/decouple them?

**Decision:** Whether to actively manage the inter-coil interaction
or just mitigate it.

## O11. Brown-out behaviour during 500 ms quiescent

**Question:** Per NR2, free-rider Qi has 19% duty cycle. During
the 500 ms idle, the storage cap must hold the rail. With
167 nF storage at 100 µA load, droop is 300 mV — design margin?

## O12. Free-positioning pad coupling drift

**Question:** Multi-coil pads change their effective k as their
controller relocates the active coil. Does our free-rider see
abrupt power drops?
