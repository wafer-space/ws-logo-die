# Open questions — academic-survey angle (item c, Stage 1)

Questions raised by the academic-survey angle that should be settled
in Stage 2 / 3. Each question states the decision it gates and what
investigation would settle it.

## OQ-A1. Does any peer-reviewed academic paper describe a Qi free-rider receiver?

- **Phrased.** Is there a published silicon paper (or a defended
  thesis) describing a Qi receiver that *deliberately omits*
  participation in the WPC v1.x protocol while still drawing power
  from a stock Qi pad?
- **Decision gated.** Whether our chosen architecture (FP-1, FP-2,
  FP-3 + D1 in first-principles) is academically novel or merely
  under-cited.
- **Settle by.** Targeted search at IEEE Xplore, ACM DL, Google
  Scholar with vocabulary "non-compliant Qi", "partial-protocol Qi
  receiver", "ping-snatch", "Qi power harvest", plus check thesis
  databases (TU Graz, KAIST, ETHZ, HKUST) for unpublished MSc /
  PhD work in the area.
- **Risk implication.** If Stage 2 confirms NR-A1 (no published
  paper), the project is in genuine novel-design territory — this
  affects both review tone and the recommended risk margin in the
  power-budget analysis.

## OQ-A2. Does the [Khan2018-Energies] receiver actually have on-die series resonance?

- **Phrased.** Khan et al. report 85.3 % peak PCE for a "fully
  integrated" Qi receiver. Does the IC include on-die resonance
  (in which case the cap-budget barrier I cite in report.md s5.3 is
  wrong, or the cap is doable somehow), or is the resonance off-die
  in their measurement setup?
- **Decision gated.** Direct portability of Khan's architecture to
  our v2 chip; specifically whether the multi-feedback LDO
  technique they document can be ported alongside the rectifier
  without external passives.
- **Settle by.** Fetch the open-access PDF of the paper (MDPI;
  free) and read s3 / s4 (their schematic and chip-photo
  sections). A reviewer should also SHA-256-verify the cached PDF.

## OQ-A3. What's the area cost of the [LeeGhov2011] / [ChaPark2012] technique on `gf180mcuD`?

- **Phrased.** [ChaPark2012] reports 0.009 mm^2 for the cross-
  coupled latched-comparator rectifier in 0.18 um CMOS. GF180MCU is
  also 0.18 um but a different vendor. What's the realistic area
  multiplier?
- **Decision gated.** Whether AS-B3 is the smallest viable Qi
  rectifier on `gf180mcuD`, and whether to choose B3 over B2
  (native-NMOS, simpler).
- **Settle by.** Stage-3 deep-dive: schematic capture of B3 in
  `gf180mcuD`, layout sketch, area extraction.

## OQ-A4. Can the R^3 detuning idea be ported to off-resonant operation at Qi LF?

- **Phrased.** [ChengKi2017] regulates the rectifier output by
  switching the resonant cap to detune the AC tank. At our LF
  on-die-no-cap operating point, can we get the same effect by
  switching a coil-shorting FET on and off in a controlled duty
  cycle? Does that achieve regulation without dissipating the
  excess power as heat?
- **Decision gated.** Whether AS-B5 is a real shortlist candidate
  for Stage 3, or just an academic curiosity.
- **Settle by.** Spice simulation of the modified topology with
  realistic transmitter source model (Qi BPP A1 primary), plus a
  literature sweep for "coil-shorting regulation" prior art.

## OQ-A5. Does the Petzel notch-filter analysis carry over to a *receiver*-side mitigation?

- **Phrased.** Petzel proposes notch / low-pass filters in the
  *Qi transmitter* path to reduce the 100 kHz field bleeding into
  the NFC reader. Can the same idea be applied on the *receiver*
  side — i.e. an on-chip filter that decouples the L2-NFC and
  L3-Qi PCB coils from each other inside our IC?
- **Decision gated.** Whether the v2 chip needs an explicit
  Qi-mode FET that disconnects the NFC path during Qi operation
  (first-principles s5.8 mitigation #2).
- **Settle by.** Read Petzel s4.4 + s3.5 in detail; size the
  required FET and compare with the simpler "live with the loss"
  strategy.

## OQ-A6. What's the upper bound on academic-published Qi receiver power efficiency?

- **Phrased.** Across all surveyed papers, what's the highest
  reported AC-to-Vbat efficiency at Qi BPP frequency? Is it
  Khan 2018's 85.3 %?
- **Decision gated.** What efficiency target our reproduction
  should aim for in Stage 5 implementation; whether to set a
  stretch target above the published-paper line.
- **Settle by.** Stage-2 synthesiser should aggregate measured
  numbers across all reported papers and produce a single curve.

## OQ-A7. Are there any bio-implant LF-WPT receiver papers that explicitly target sub-mW load?

- **Phrased.** The bio-implant lineage ([LuKi2014], [ChengKi2016])
  reports tens-to-hundreds of mW. Are there sub-mW operating-point
  papers that better match our v2 chip's load?
- **Decision gated.** Whether our microwatt load is "in the sweet
  spot of prior art" or "below the sweet spot, where reverse
  leakage and self-consumption start to dominate".
- **Settle by.** Targeted PMC search with terms "transcutaneous
  microwatt wireless power" + "100 kHz" / "200 kHz" / "1 MHz".

## OQ-A8. Are there published Qi receivers that explicitly handle a non-ferrite-backed coil?

- **Phrased.** Every Qi/PMA silicon paper assumes a ferrite-backed
  receiver coil (the standard A1 / A11 / A28 reference designs).
  Our PCB has *no* ferrite (cost, thickness, business-card form
  factor). Does any paper measure performance with a non-ferrite
  PCB-trace coil?
- **Decision gated.** Whether the Khan / Wu PCE numbers are
  achievable on our PCB, or whether the loss of ferrite causes
  a >= 10 % PCE drop that we should budget for.
- **Settle by.** Stage-2 reviewer should hunt explicitly for
  "ferrite-less Qi" / "PCB-coil only WPT" papers; this is a
  distinct community from the standard receiver-IC papers.
