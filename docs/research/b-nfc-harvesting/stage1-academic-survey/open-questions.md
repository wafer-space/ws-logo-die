---
item: b
item_name: nfc-harvesting
stage: 1
angle: academic-survey
researcher: claude-opus-4-7-1m (auto-mode, parallel instance 3 of 3, retry pass)
status: draft
last-invariant: 2026-05-03
---

# Open questions — academic survey

Each question is phrased as a question, with the decision /
downstream work that depends on the answer, plus a guess at the
investigation that would settle it.

---

## OQ-1. Does `nfet_06v0_nvt` qualify for steady-state rectifier duty?

**Question.** GF180MCU `nfet_06v0_nvt` (native, Vth0 ≈ −0.039 V)
is the closest PDK device to a Schottky in efficiency terms. The
device-models file (`sm141064.ngspice`) provides BSIM parameters,
but no academic paper measures *this specific device* in a
13.56 MHz HF rectifier under realistic load and sustained
conduction. Does it actually reach the η ≈ 88 % the sister
first-principles report computes, or does reverse-leakage push η
below 80 %?

- **Decision depended on:** Whether R-PD-native (§2 in
  `solutions.md`) is a viable production choice or only a
  start-up seed.
- **Investigation:** Stage 4 spice deep-dive (mandatory).
  Optionally: tape-out a comparator-bench die with native-nFET
  bridge instrumented for Iout-vs-Vpk-ant.

## OQ-2. What is the comparator latency floor on `gf180mcuD` in 0.18 µm at the harvested-rail voltage?

**Question.** The headline papers Lu–Ki 2016 [D1] and Ma 2020 [A3]
report sub-3-ns comparator response, but at well-controlled supply
voltages (1.8 V regulated). Our active rectifier must run with
V_RECT swinging from 1.8 V (just above brown-out) to 5 V (clamp
threshold) — does the comparator hold its < 5 ns response across
this 3:1 swing?

- **Decision:** Whether R-AC-adaptive-delay (§6) or R-AC-SAR-Ma2020
  (§7) can ship as the primary topology, or whether
  R-AC-LeeMok-switched-offset (§5) — which has more robust offset
  behaviour — is the safer choice.
- **Investigation:** Spice with PVT corners, supply ramp, and the
  847.5 kHz subcarrier load step.

## OQ-3. Does the gf180mcuD MIM cap have enough Q at 13.56 MHz for the V_RECT smoothing role?

**Question.** PDK characterisation in the gf180 docs is
unambiguously DC + low-frequency. Above ~10 MHz the cap-ESR /
cap-Q is normally a vendor-supplied microwave model — *gf180mcuD
does not provide this in `sm141064_mim.ngspice` directly.* If the
MIM cap Q at 13.56 MHz is < 30, the V_RECT cap will dissipate
non-trivial power.

- **Decision:** Cap technology selection (MIM vs MOS-cap vs
  poly-poly augmentation) for V_RECT specifically.
- **Investigation:** Y-parameter extraction from the cap layout
  using OpenROAD's RC tool, or a PEX run on a test layout.

## OQ-4. Threshold-cancellation in 0.18 µm with PDK-ordinary bias arrangement: what is the practical η?

**Question.** Kotani 2007 [B1] used a static gate-bias scheme that
needs *two* DC bias points per stage (one on each gate of the
diode-connected pair). The bias is generated from the *adjacent*
DC output node. In gf180mcuD, can this be implemented with PDK-
ordinary devices and reach Hashemi 2012's [B5] 87 % at HF, or does
the 0.18 µm leakage-tax dominate?

- **Decision:** Whether R-TC-Kotani-self-Vth (§8) is competitive
  with R-PD-native (§2) for the brown-out edge regime.
- **Investigation:** Spice corner sweep at low Vpk_ant.

## OQ-5. Is there a published silicon paper that delivers ≥ 5 mW DC into a load while clamping a 0-mm reader-coupled antenna?

**Question.** All of A1–A5, B5, D1–D2, I1 papers report PCE under
*controlled* input amplitude (≤ 5 V_pp). None — that I found in
this search — explicitly reports performance with the antenna
exposed to the over-voltage corner where Vpk_ant > 30 V on the
input side and the on-die clamp is dissipating > 100 mW. *This is
exactly our 0-mm-from-reader corner case.*

- **Decision:** Stage 4 deep-dive prioritisation — clamp and
  thermal sizing.
- **Investigation:** Stage 2 should search the *reader IC* literature
  (PN5180, ST25R3911B) where over-voltage handling is more directly
  reported, and fold that into the tag-side decision.

## OQ-6. How does the 847.5 kHz load-modulator transient interact with the active-rectifier comparator's calibration loop?

**Question.** Mandal 2009 [C3] proposes dual-use of the load-
modulator FET as part of the rectifier path, but most academic
papers test the rectifier *without* concurrent load modulation.
When the load modulator briefly shorts the antenna (each subcarrier
half-cycle), the comparator detects an "early zero crossing" and
the calibration loop drifts *toward* mistuning. Does the loop
stabilise during the subcarrier-pause windows, or does it
accumulate error?

- **Decision:** Whether the active-rectifier topologies need a
  *gating signal* from the (h) NFC core to disable calibration
  during modulation pauses — and what gating-signal latency is
  acceptable.
- **Investigation:** Stage 4 cosim with the (h) NFC core's
  modulator timing.

## OQ-7. Floating-gate Vth cancellation (Le 2008 [B3]) — definitive ruling on gf180mcuD compatibility?

**Question.** Le–Mayaram–Fiez 2008 [B3] reports very low minimum-
input rectification (50 mV) using floating-gate transistors. Can
this be replicated with the gf180mcuD EEPROM cell as the floating-
gate source, or is the EEPROM bit-cell unsuited to "always-on"
floating-gate biasing?

- **Decision:** Whether the floating-gate variant is permanently
  excluded or remains a Stage 4 option.
- **Investigation:** Read the gf180 EEPROM datasheet
  (`gf180mcu_otp_*` cells in `libs.ref/`) and check for a
  "floating-gate hold-time" specification at our operating
  conditions. Also coordinate with item (j) eFuse/OTP plan.

## OQ-8. Are there *measured* numbers for thermal performance of an active-rectifier IC under sustained over-voltage clamp?

**Question.** All published 13.56 MHz active-rectifier silicon
papers operate the rectifier at its Mpe operating point
(Vpk_ant ≈ 1.5–3 V). None reports thermal data with the antenna
clamped at 6 V continuously, dumping ~100s of mW into the on-die
shunt. Our card-on-reader corner sustains exactly this condition.

- **Decision:** On-die shunt-clamp transistor sizing, thermal-via
  count.
- **Investigation:** Read NTAG21x and ST25DV datasheets'
  *thermal-resistance* sections (in references-cache) — these are
  the only sources I know of with the relevant numbers, and they
  *don't* derive from peer-reviewed papers but from datasheet
  thermal envelope tables.

## OQ-9. Is there a published "harvest-while-modulating" architecture that decouples the modulator from the rectifier path?

**Question.** Industry's NTAG 5 and similar tags already do
"harvest-while-modulating" via an internal V_RECT-V_REG split (the
modulator only shorts the rail downstream of V_REG). Has any peer-
reviewed academic paper measured this architecture's PCE
penalty?

- **Decision:** Whether to keep the (h) NFC modulator on the LA/LB
  pads (industry default) or move it to a downstream node (would
  isolate harvester from modulation).
- **Investigation:** Stage 4 deep-dive.

## OQ-10. Body-bias control for native-nFET in gf180mcuD?

**Question.** The native-nFET advantage assumes Vth ≈ −0.04 V,
which holds for *zero* body-source voltage. In a bridge topology,
the source moves with the AC waveform — body-bias modulation will
shift Vth dynamically. Does the gf180mcuD `nfet_06v0_nvt` model
capture this, and does the resulting Vth-modulation-loss outweigh
the static benefit?

- **Decision:** Same as OQ-1 — production viability of R-PD-native.
- **Investigation:** Read the `nfet_06v0_nvt` BSIM γ (body-effect
  coefficient) parameter from `sm141064.ngspice`, and run
  spice with a 13.56 MHz drive on the source.

---

## Summary

Of these 10 open questions, the *most-binding* for Stage 2 / Stage
4 are:

- **OQ-1, OQ-10:** Native-nFET bridge production viability — gates
  the entire passive-bridge production path.
- **OQ-2, OQ-6:** Comparator latency and modulator-interaction —
  gates the active-rectifier production path.
- **OQ-3:** MIM-cap Q at HF — gates the smoothing-cap floor for
  *all* topologies.

The remaining (OQ-4, OQ-5, OQ-7, OQ-8, OQ-9) are second-order and
can be deferred to Stage 4 deep-dives without delaying Stage 2.
