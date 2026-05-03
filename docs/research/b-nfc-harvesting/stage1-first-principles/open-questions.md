# Open questions (item b, Stage 1 first-principles)

## OQ-1 — Is the native nFET (zero-Vth) device exposed as a pcell-instantiable element in `gf180mcuD`?

The whole §5.12 brown-out argument hinges on a diode-connected
`nfet_06v0_nvt` providing ~0.04 V drop instead of ~0.67 V. If the
device is BSIM-modeled (which we confirmed via `sm141064.ngspice`)
but not exposed as a layout pcell with extracted parasitics, the
design effort is much higher.

**Decision impact.** If yes → R-D-native becomes the leading
architecture. If no → forced toward the R-E / R-F active rectifier
path (with all its quiescent / start-up costs).

**How to settle.** Audit `libs.tech/klayout/pymacros/` for native-
nFET pcells; build a small test layout in xschem; run extraction.
1–2 hours of work, can be done in Stage 2.

## OQ-2 — What is the actual ESD strategy at the antenna pads?

Standard pad ESD diodes will forward-conduct on the negative AC
swing once it goes more than ~0.7 V below VSS. For typical Vpk_ant
of 3–10 V, that's catastrophic.

**Decision impact.** Drives whether we need a custom ESD structure,
a series DC-block cap, or a deliberately-floored pad design.

**How to settle.** Discuss with PDK / pad-frame owners. Survey
published RF-friendly ESD strategies for 0.18 µm 5 V processes.
Stage-3 / Stage-4 task.

## OQ-3 — What are the exact Hmin and Hmax values in ISO/IEC 14443-2?

The brown-out boundary derivation in §5.12 uses Hmin = 1.5 A/m. If
the actual standard says 1.2 or 2.0 A/m, the boundary moves and the
R-D-5V vs R-D-native choice can flip.

**Decision impact.** Setting the right power-budget targets for
Stage 4 sims.

**How to settle.** Obtain ISO/IEC 14443-2:2020 (paywalled).
Alternatively, the sister Stage-1 industry-survey instance is
expected to verify against vendor compliance test reports.

## OQ-4 — Does the (h) NFC modulator's 847.5 kHz subcarrier short the antenna fully or partially?

§5.7 sized the V_REG cap assuming a full short for ~1 µs. If the
modulator is high-impedance load modulation (more typical for
Type 4 tags), the V_REG cap can be smaller, freeing area.

**Decision impact.** V_REG cap size — could swing between 6 nF
(full short) and 1 nF (load modulation only).

**How to settle.** Cross-reference (h) research as it opens. Until
then, design conservatively for full short.

## OQ-5 — What is the bond-wire inductance from antenna pad to PCB loop, and does it shift the resonance?

Typical bond wire ~1 nH/mm; path is ~2 mm: ~2 nH series. Compared
to the loop's 1.6 µH, this is a 0.1 % perturbation. But Q is a
sensitive function of perturbation, and mis-tuning can drop loaded
Q by half.

**Decision impact.** Whether the switched-cap tuning bank's range
needs to absorb additional bond-wire-induced detuning.

**How to settle.** Spice corner sim with a simple wire-bond
inductance model. Probably 1 hour at Stage 4.

## OQ-6 — Is closed-loop tuning during operation feasible, or do we need at-test trim via (j) eFuses?

Closed-loop trim during operation handles PCB-to-PCB variation and
hand-near-card detuning automatically. At-test trim via eFuses is
simpler but locks in the tuning at first power-up.

**Decision impact.** Whether (b) drives a hard requirement on (j)
eFuse availability.

**How to settle.** Stage 4 trade-off study.

## OQ-7 — At what coupling factor k does R-F's quiescent overhead break even with R-D-native's Vth loss?

The architectural question: simple (R-D-native) vs efficient-but-
power-hungry (R-F). The break-even point in k dictates which is
"the right answer" across our typical operating range.

**Decision impact.** Stage-2 shortlisting and Stage-4 deep-dive
prioritisation.

**How to settle.** Spice sim sweeping k from 0.05 to 0.3, comparing
the two topologies' net DC output. ~4 hours at Stage 4.

## OQ-8 — Can we drive the LEDs (f) directly from V_RECT, saving the LDO overhead?

LEDs are tolerant of supply variation; the LDO costs 20 % of the
harvested power and ~0.5 V of headroom. If LEDs run from V_RECT
directly, the LDO only needs to feed the digital NFC core.

**Decision impact.** Could shrink the LDO and the V_REG smoothing
cap.

**How to settle.** Cross-reference (f) research as it opens.

## OQ-9 — Does the cross-coupled R-E topology start-up reliably on `gf180mcuD`?

R-E's body-diode bootstrap during start-up has been known to fail
in process variants with weak body-source breakdown or high body-
diode forward voltage.

**Decision impact.** Whether R-E qualifies for Stage 4 deep-dive.

**How to settle.** Spice transient sim from V_RECT = 0 with
realistic ramp on Vpk_ant. ~2 hours at Stage 4.

## OQ-10 — How does the (i) power-domain isolation interact with the harvester start-up?

When V_REG is up but V_VGA is down, level shifters across the
boundary must not leak current backward into the dead VGA rail.

**Decision impact.** Brown-out state machine design.

**How to settle.** Cross-reference (i) research.

## OQ-11 — What is the realistic V_RECT ripple at peak harvest, including the modulator?

§5.5 sized V_RECT cap for steady-state 27.12 MHz ripple at 5 mA.
The modulator's 847.5 kHz square-wave periodically dumps energy;
V_RECT cap may need to be larger.

**Decision impact.** V_RECT cap size; could push from 1 nF up to
several nF.

**How to settle.** Spice sim with the modulator profile from (h).

## OQ-12 — Does the wafer.space logo's metal-layer usage leave room for ~4 mm² of MIM?

§5.7 said V_REG cap is the binding constraint at ~4 mm². The logo
uses all metal layers per `TODO.md` constraint 1; MIM is metal-
pair-stacked. Whether the logo's actual draw on the relevant metal
pairs leaves room is item (e)'s research question.

**Decision impact.** Whether (b) can deliver V_REG cap on the
required scale.

**How to settle.** Item (e) research output.
