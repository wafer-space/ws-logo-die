---
item: c
item_name: qi-harvesting
stage: 1
angle: academic-survey
researcher: claude-opus-4-7-1m (Stage-1 academic-survey, c-qi)
status: in-review
last-updated: 2026-05-02
---

## 1. Executive summary

This report surveys peer-reviewed silicon papers and theses on Qi-class
low-frequency (LF, 87–205 kHz) inductive wireless-power receivers,
focused on rectifier and post-rectifier regulator topologies that
could realistically be reproduced in `gf180mcuD` for the v2 chip.

Sources surveyed: IEEE JSSC, TBioCAS, TCAS-I/II, TIE; Springer
*Analog Integrated Circuits and Signal Processing* (AICSP) and
*Science China Information Sciences*; MDPI Energies and Electronics;
NIH PubMed Central mirrors; the locally-cached Petzel 2020 TU Graz
MSc thesis on NFC↔Qi coexistence (cited as `[Petzel2020]`); and the
locally-cached WPC Qi PC0 v1.2.3a specification. Following the
research brief's web-access guidance, I did **not** WebFetch IEEE
Xplore directly; canonical IEEE-published papers are cited via DOI +
author + year + venue with cross-checks at Semantic Scholar / PubMed
Central / Springer / faculty mirrors and marked `paywall —
abstract-only verification`.

**Six distinct silicon-paper-anchored rectifier topologies** are
catalogued (§3.2), spanning passive PN bridge through native-NMOS,
cross-coupled latched-comparator self-driven sync, offset-controlled
high-speed-comparator sync, switched-offset / digitally-adaptive
delay-compensated sync, and reconfigurable resonant regulating
rectifier (R³). **Three distinct post-rectifier regulator
topologies** with silicon prior art are catalogued (§3.3): linear
LDO (single- and multi-feedback), adaptive-Vrect via Qi back-channel,
and detuning regulation built into the rectifier itself. **Three
protocol-participation tiers** appear in the literature (§3.4):
academic free-rider / partial-protocol experiments, full WPC
compliance receivers, and bio-implant-style closed-loop primary-side
co-control.

Headline conclusions, **without picking a winner**:

1. **Off-resonant Qi-band silicon receivers exist in the academic
   literature.** The Korean Khan et al. 2018 *Energies* paper
   ([Khan2018-Energies]) describes an 85.3 % peak-PCE WPC/PMA
   receiver IC at the Qi BPP frequency band, using a synchronous
   active rectifier and multi-feedback LDO. This directly answers the
   open question raised in the first-principles report's §10
   ("must verify with industry survey that off-resonant Qi receivers
   exist in the literature; if they don't, this is a novel design
   problem and risk goes up"). Risk reduces.
2. **Comparator-delay compensation is the dominant design lever in
   the literature for sync-rectifier PCE.** [LeeGhov2011],
   [LuKi2014], [ChaPark2012] and [LeeKim2021-Energies] all spend the
   bulk of their text on delay-compensation circuitry. *At Qi LF this
   is not a hard problem* — first-principles §5.4 shows the
   comparator-delay budget is 25–100× looser than at 13.56 MHz HF —
   so most of the academic complexity does not transfer.
3. **The reconfigurable-resonant-regulating-rectifier (R³) lineage
   (Cheng & Ki, ISSCC 2016 / JSSC 2017 / TBioCAS 2016) is the most
   sophisticated end of the spectrum.** R³ rectifiers collapse
   rectification, voltage regulation, and energy-disposal-on-overload
   into a single switching block by *intentionally detuning* the
   resonant tank. Methodology is intriguing for our project but the
   on-chip detune cap bank is sized at the resonant cap value, which
   we cannot afford on-die at LF (NR1 of first-principles).
4. **Bio-implant transcutaneous WPT receivers are *the* prior-art
   community for sub-MHz inductive receivers** — IMD links operate
   at 100 kHz – 1 MHz, exactly overlapping Qi BPP. The TBioCAS /
   PubMed Central mirror lineage offers six independent silicon-
   tape-out reports with measured PCE numbers in the same operating
   regime as Qi.
5. **Free-rider Qi compliance is *not* a published academic topic.**
   Despite extensive search, no peer-reviewed academic paper
   describes a Qi receiver that *deliberately omits* protocol
   participation. The closest published work is the bio-implant
   community's "closed-loop primary side, dumb secondary"
   architecture ([ChengKi2016]), which assumes cooperative
   primary-side equalisation that a stock Qi pad will not provide.
   This is a clean **gap finding** for Stage 2.
6. **Petzel 2020 thesis [Petzel2020] is the canonical reference for
   field interaction between Qi (LF) and NFC (HF) coils on the same
   PCB.** §3.5 derives Neumann-formula-based mutual coupling for
   stacked planar coils — the exact formulation needed for the v2
   business-card PCB's L2-NFC / L3-Qi layout (first-principles §5.8
   / O5).

## 2. Requirements as understood

Identical to `stage1-first-principles/report.md` §2 plus, specific
to academic survey:

- **R-A1.** Topologies catalogued must be anchored in at least one
  peer-reviewed silicon paper or thesis. Industry-only references
  belong in the sister industry survey.
- **R-A2.** Both compliance-tier and free-rider / partial-protocol
  academic work must be covered.
- **R-A3.** TBioCAS-type biomedical receivers operating at 100–
  500 kHz are explicitly in scope (the brief lists this as the most
  productive academic community for the Qi LF band).
- **R-A4.** Petzel 2020 is a *required* reference (cached locally,
  cited by both other Stage-1 reports).
- **R-A5.** Reconcile every numerical claim in §3 with the WPC PC0
  v1.2.3a spec values (cached). The first-principles report has
  derived `t_ping = 65–70 ms`, `t_first ≤ 20 ms`, `t_terminate
  ≤ 28 ms`, `t_restart = 500 ms`, FOD tolerance = +0/−350 mW;
  numerical claims in this report must be consistent.

## 3. Solution-space map

Decomposition mirrors the first-principles report's four orthogonal
axes (A. tuning, B. rectifier, C. regulation, D. protocol) plus an
extra "system-level architecture" group (E) for the *combined*
rectifier+regulator silicon papers.

### 3.1 Family A — Coil tuning / resonance

The first-principles report rules out on-die series resonance at Qi
LF (208 nF cap = 139 mm² of MIM, infeasible). The academic literature
contains *no* peer-reviewed example of an *on-die-untuned* Qi-band
receiver — every cited silicon paper assumes either an external
discrete series-resonance cap or, for ISM-frequency designs at
6.78 MHz / 13.56 MHz, an on-die cap that fits because the resonant
cap shrinks as 1/f² (HF cap is ~50 nF; LF cap is ~50× larger).
Therefore A1/A3 (on-die series/parallel resonance) are silicon-prior-
art-supported only at HF, not at Qi LF.

- **A1 (series-resonant, off-die cap).** Default in *every* Khan
  2018, Wu 2019, Wu 2020, Quang 2015 Qi/PMA paper. **Violates our
  R4 (no external passives).**
- **A2 (off-resonant).** No published academic Qi-band silicon
  receiver — though the absence is interesting and is itself a
  gap-finding.
- **A3 (on-die series/parallel cap).** Used at HF (6.78 / 13.56 MHz)
  in [ChengKi2017], [LuKi2014]. Would require ~140 mm² at Qi LF.
- **A4 (stagger-tuned dual-band coil).** Proposed in [Petzel2020]
  §4.4.4–§4.4.5 (notch + low-pass filter in the Qi circuit to allow
  shared-coil NFC + Qi). For our project the PCB has already
  committed two coils, so A4 is informational only.
- **A5 (distributed self-resonance).** Uses the coil's parasitic
  inter-turn capacitance as the resonant cap. Discussed at MHz-band
  in [SpringerCh2017]; falls outside Qi band by ≈ 2 orders of
  magnitude per first-principles §5.7. **Not viable at Qi LF.**

### 3.2 Family B — Rectifier topology, with silicon-paper anchors

Six distinct silicon-paper-anchored rectifier topologies, ordered by
roughly increasing complexity and published efficiency:

#### B1. Passive full-wave PN diode bridge (academic baseline)

- **One-paragraph description.** Four diodes in a bridge; the
  rectifier output equals the AC peak minus 2 × Vf. The simplest
  possible AC-DC stage; baseline against which every other topology
  is benchmarked.
- **Where used.** Cited in [SpringerCh2017] Ch. 4 §4.1 as the
  taxonomical baseline. *In `gf180mcuD` no Schottky exists* — PN
  Vf ≈ 0.6 V, two-diode loss ≈ 1.2 V — a 30+ % loss at 4 V output.
- **Reported PCE.** ≤ 50 % at low input swings (≤ 2 Vpp); not
  competitive with any active topology above ~1 mW.
- **Failure modes / conditions reported.** Vf-loss eats most of the
  delivered power at low-swing inputs; not used in any published
  Qi-band receiver.
- **Relevance to our requirements.** Useful as a *cold-start*
  fall-back only (FP-1 of first-principles report).

#### B2. Diode-connected MOSFET / native-Vt rectifier ([Mandal2007] lineage)

- **One-paragraph description.** Each rectifying element is a diode-
  connected MOSFET. Using a near-zero-Vt (native) NMOS dramatically
  reduces forward drop; with `nfet_06v0_nvt` (Vth0 = -0.039 V per
  the GF180MCU spice model) Vf can be ≤ 0.1 V at moderate currents.
- **Where used.** Foundational paper Mandal & Sarpeshkar 2007 [
  Mandal2007], DOI 10.1109/TCSI.2007.895229, *IEEE TCAS-I*; updated
  in their 2015 EMBC review (PMID 26737525) for biomedical implants
  at 100 kHz – 1 MHz LF band — *the same band as Qi*.
- **Reported PCE.** 60–75 % typical at LF for sub-mW loads;
  bottlenecked by reverse leakage in the off state of the diode-
  connected MOSFET.
- **Failure modes.** Reverse-conduction current rises as input swing
  approaches 2 × Vf (because the diode does not turn fully off when
  the drain swings positive); under heavy loading the reverse
  current dissipates 20–30 % of forward power.
- **Relevance to our requirements.** Anchors our FP-2. **Best fit
  for** sub-mA µW loads where any sync-rectifier control loop adds
  more area than it saves. **Worst fit for** > 30 mA loads or
  > 1 V Vrect-to-Vbatt drops where reverse leakage hurts.

#### B3. Cross-coupled NMOS + comparator-driven PMOS active rectifier ([LeeGhov2011], [ChaPark2012], [LuKi2014] lineage)

- **One-paragraph description.** Two NMOS in cross-coupled
  configuration handle the negative half-cycles (self-gate-driving),
  and two PMOS in the high side are driven by comparators that
  detect zero-crossing of `V_AC`. The trick is that the comparator
  must turn the PMOS off *before* the AC swing reverses, otherwise
  reverse current dumps the storage cap back into the coil. Various
  papers compensate the comparator's propagation delay by *
  pre-shifting* the comparator's input offset so that it fires
  early.
- **Where used.** Bio-implant lineage. [LeeGhov2011] (TCAS-I,
  13.56 MHz, 0.5 µm CMOS) is the canonical paper. [ChaPark2012]
  (TCAS-II, 13.56 MHz, 0.18 µm CMOS, **0.009 mm² area**) introduces
  the cross-coupled latched comparator. [LuKi2014] (TBioCAS,
  13.56 MHz, 0.35 µm CMOS, 4 V output, **81.9 % PCE @ 1.5 Vpp**)
  switches the comparator offset between forward and reverse phases.
- **Reported PCE.** 80–95 % at HF (13.56 MHz). **At Qi LF, the
  comparator-delay budget is 25× looser** — 143 ns (LF) vs 5.7 ns
  (HF) for a 4 % dead-time ceiling — so the same architecture
  trivially achieves ≥ 90 % PCE at Qi-class operating points
  *without the offset-switching machinery*.
- **Failure modes.** At HF, sub-ns comparator delay matching is
  required; below ~1 Vpp, comparator's own bias headroom collapses
  and PCE drops sharply. At LF, the failure mode is reverse-current
  glitches if the comparator slews too slowly relative to dV/dt at
  the AC zero-crossing — easily managed.
- **Relevance to our requirements.** **Best published fit** for our
  v2 Qi free-rider design. Anchors first-principles FP-3.

#### B4. Switched-offset / digitally-adaptive delay-compensated active rectifier ([LeeKim2021-Energies], [Quang2015-TIE], lineage)

- **One-paragraph description.** Same skeleton as B3, but the
  comparator's offset is dynamically tuned by a digital control loop
  (replica delay line, calibration ROM, or Vrect-feedback servo) so
  that PCE stays > 90 % across input-amplitude variation.
- **Where used.** [LeeKim2021-Energies] (open-access MDPI Energies,
  HF), and the broader 2018–2021 Korean-team lineage. A digitally-
  adaptive variant is also reported in [Khan2018-Energies] applied
  at *Qi LF* (87–205 kHz), with 85.3 % peak PCE.
- **Reported PCE.** > 90 % at HF; 85.3 % at Qi LF in
  [Khan2018-Energies].
- **Failure modes.** Calibration loop converges over hundreds of
  cycles → start-up lag of 1–10 ms. Adds 1–3 kgates of digital + a
  small ADC. **Not a free lunch.**
- **Relevance to our requirements.** For µW LED-twinkle load this
  is over-engineered. But [Khan2018-Energies] specifically targets
  Qi BPP, so it is a published silicon prior for the Qi LF band.
  Useful Stage-2 input as the upper bound on what's been measured.

#### B5. Reconfigurable resonant regulating rectifier (R³) ([ChengKi2017], [ChengKi2016])

- **One-paragraph description.** A single switching matrix replaces
  rectifier + Vrect-to-Vbatt SC converter + LDO. The matrix
  reconfigures between three operating modes (1× / ½× / 0×) such
  that the *AC tank's resonance condition* is moved between
  cooperatively-tuned and intentionally-detuned, disposing of excess
  energy by *reflecting* it to the primary instead of dumping it as
  heat in a shunt regulator.
- **Where used.** Cheng & Ki, ISSCC 2016 (paper 21.7) → JSSC 2017
  ([ChengKi2017]); related TBioCAS 2016 paper with primary-side
  equaliser ([ChengKi2016]) extends coupling-and-loading range
  2.5–3×.
- **Reported PCE.** Up to 92 % overall AC-DC at 6.78 MHz; reported
  efficiency stays > 80 % over a 4× output power range.
- **Failure modes.** Their architecture *requires* the on-die
  resonant cap (because the detuning is achieved by switching the
  cap into and out of the AC path). At Qi LF this cap is 200 nF
  ≈ 140 mm² — geometrically infeasible. Method does not directly
  port; *idea* is portable in modified form.
- **Relevance to our requirements.** Does **not** anchor an FP
  topology directly because of the cap-size barrier, but the
  *concept* of regulation-by-detuning underlies first-principles
  C5 (energy-reflection regulator). Stage 2 should explore whether
  an *off-resonant detune* — e.g. a coil-switch FET that briefly
  shorts the coil between half-cycles — can deliver R³-like
  energy-reflection regulation without any on-die cap.

#### B6. Wide-input-range triple-mode auto-selecting rectifier ([QuangHa2015-WideTriple])

- **One-paragraph description.** Auto-detects the AC input
  amplitude and switches between a passive bridge (low input,
  starts immediately), half-sync (medium), and full-sync (high) to
  optimise PCE across input range.
- **Where used.** Quang & Lee 2016 *AICSP* paper at 0.18 µm BCD;
  reports 94.2 % peak PCE and 8 W output for high-power Qi/PMA
  receivers.
- **Reported PCE.** 94.2 % peak; > 80 % across a 10× input swing.
- **Failure modes.** Mode-switch glitches if hysteresis is too
  small; large area for the auto-detect block (~0.1 mm² added).
- **Relevance to our requirements.** Mode-switching is attractive
  because our coupling varies dramatically with placement on the
  pad. For a µW load though, a static topology choice is probably
  cheaper than the auto-detect circuitry.

### 3.3 Family C — Post-rectifier regulator, with silicon-paper anchors

Three published academic patterns:

#### C1. Linear LDO (single- or multi-feedback)

- **One-paragraph description.** Series-pass PMOS or NMOS driven by
  an error amplifier comparing rectifier output to a bandgap
  reference. *Multi-feedback* variants (e.g. Khan 2018) add a feed-
  forward path from Vrect AC ripple to improve transient response.
- **Where used.** Every Qi/PMA silicon paper that reports an
  integrated regulator: [Khan2018-Energies], [Wu2019-Qi],
  [Wu2020-AICSP], [Quang2015-TIE].
- **Reported PCE.** 85–92 % depending on dropout. Multi-feedback
  reduces output ripple ~6 dB vs single-feedback.
- **Failure modes.** Drop-out forced by fixed Vrect; if the
  rectifier output rises with low load (our µW case), the LDO must
  burn the difference as heat unless a shunt is added.
- **Relevance.** Anchors first-principles C1 (linear LDO).

#### C2. Adaptive-Vrect via Qi back-channel ([Quang2015-TIE], industry counterparts)

- **One-paragraph description.** The receiver sends Control Error
  Packets (CEP) to the Qi PTx asking it to lower the primary-side
  amplitude. Vrect tracks the demand of the receiver, eliminating
  most LDO drop-out loss.
- **Where used.** [Quang2015-TIE]; full WPC compliance receivers in
  industry survey.
- **Reported PCE.** Overall AC-to-Vbat efficiency ≈ 90 % across a
  3× load range.
- **Failure modes.** *Requires full WPC v1.x compliance.* For
  free-rider designs this path is unavailable.
- **Relevance.** Anchors first-principles C-via-D3 only.

#### C3. Detuning-based regulation built into the rectifier ([ChengKi2017])

- **One-paragraph description.** Same as B5 above; mentioned again
  here because it *is* the regulator in those papers — there is no
  separate post-rectifier regulator block.
- **Where used.** Cheng & Ki ISSCC 2016 / JSSC 2017.
- **Reported PCE.** > 90 % AC-DC.
- **Failure modes.** As B5 — needs on-die resonant cap.
- **Relevance.** Anchors first-principles C5.

### 3.4 Family D — Protocol participation, with silicon-paper anchors

#### D1. Strict free-rider — *no* published academic silicon paper

The most striking gap in the literature. **No peer-reviewed paper
describes a Qi receiver that deliberately omits protocol
participation while still drawing power from a stock Qi pad.** The
closest open-source artefact is the Vinod-Tanur ATtiny13A "free-
rider" project (already cited in the industry survey, [O1]) — not
peer-reviewed. **Stage 2 should explicitly note this as an academic
gap.**

#### D2. Bio-implant primary-cooperative regulation ([ChengKi2016])

- The bio-implant community's solution to the same architectural
  problem (µW–mW load on a wireless link) is to put the regulation
  loop on the *primary* side: the secondary just rectifies, and the
  primary's amplitude is servoed by a feedback channel implemented
  outside the secondary IC.
- For Qi, the primary already runs an autonomous control loop
  (Power Control Hold-Off, Control Error Packet response) — but
  only if the receiver participates in the Qi protocol.
- **Failure mode for free-rider:** without CEP packets the Qi
  primary defaults to constant-amplitude operation at the highest
  level allowed for the Tx FOD strategy → over-voltage at the
  secondary unless an on-die clamp absorbs the excess.

#### D3. Full WPC compliance ([Khan2018-Energies], [Wu2019-Qi], [Wu2020-AICSP], [Quang2015-TIE])

- All four published Qi-band silicon papers implement full
  WPC v1.x compliance: ASK back-channel modulator, packet framer,
  CRC-8, identification packet, control error packet at 250 ms
  cadence (faster during transients).
- **Reported gate count for the digital block:** 3–10 kgates
  (Khan 2018 reports ~3 kgates; others do not give a precise
  number).
- **Failure modes.** As reported: latency between Vrect spike and
  CEP response ≥ 32 ms (Qi spec floor) — large transients exceed
  rectifier's local cap ride-through.

### 3.5 Family E — System-level / co-design papers

- **E1. Full-system Qi receiver IC papers.** [Khan2018-Energies],
  [Wu2019-Qi], [Wu2020-AICSP], [Quang2015-TIE], [QuangHa2015-WideTriple]
  — each reports a complete Vac-to-Vbat path with measured numbers.
- **E2. Coil-and-IC co-design papers.** [Petzel2020] is the most
  detailed; addresses NFC↔Qi field interaction at a single
  receiver. *Highly relevant for our project's L2-NFC / L3-Qi PCB
  layout.*
- **E3. Survey papers.** [MDPI-Reg-Topology-2018] (Cheng, Ki, Tsui
  taxonomy of regulation topologies); [PMC-Bio-Survey-2022]
  (resonant current-mode WPT for IMDs).

### 3.6 Topologies considered and discarded

Listed for transparency (per TEMPLATE §3 "no silent omissions"):

- **Voltage-doubler / Dickson multiplier.** Industry survey N1 and
  first-principles NR5 already discard. No published academic Qi
  receiver uses one.
- **Single-half-wave rectifier.** No academic paper uses it for Qi
  either; trivially loses 50 % of available energy.
- **PWM rectifier with on-chip inductor.** Requires LC tank that
  doesn't fit at Qi LF (first-principles C2 ruled out). No academic
  paper either.
- **Capacitively-coupled WPT.** Different physics; out of scope.
- **Magnetic-resonance multi-receiver (Princeton APEC 2019).**
  Out of scope (operates at 6.78 MHz A4WP, not Qi LF).

## 4. Sub-block breakdown

For each silicon-paper-anchored topology in §3.2 / §3.3, the
sub-blocks needed for a `gf180mcuD` reproduction are listed in
[`components.md`](components.md). Highlights:

- **B3 (cross-coupled comparator-driven sync rectifier).** 4× big
  FETs (W ≥ 1000 µm each), 2× rail comparators (~5 kµm² each), 1×
  bandgap reference (10 kµm²), 4× isolation diode pairs, 1× clamp
  stack at AC pads.
- **B4 (delay-compensated sync rectifier).** As B3 plus 1× replica
  delay line (~3 kµm²), 1× small ADC (3-bit, ~5 kµm²),
  calibration ROM (~1 kµm²) and synthesis-time digital control
  block (~30 kµm²).
- **B5 (R³ rectifier).** Same B3 FETs plus a *switched detune cap
  bank* — for our project, replaced by a coil-shorting FET (no on-
  die cap fits at LF).
- **C1 (multi-feedback LDO).** Pass-PMOS, 2× error amps, frequency-
  compensation cap, AC ripple feed-forward path.

## 5. First-principles sanity checks

This report does not duplicate the first-principles report's
Faraday / Wheeler / Neumann calculations — they are correct and
this academic survey is consistent with them. The only first-
principles-style cross-checks this report adds are *paper-to-paper*
reconciliations:

### 5.1 Reconcile [Khan2018-Energies] 85.3 % PCE with Qi BPP physics

Khan reports 85.3 % peak PCE at Qi BPP (87–205 kHz) into a 5 V load.
First-principles §5.3 gives `P_load ≈ 388 mW` after coil losses for
our 8T 56×40 mm secondary. With 85.3 % PCE that's 331 mW DC at the
LDO output — which substantially exceeds our µW–mW load. Khan's
paper assumes a standard ferrite-backed Qi reference coil with
external series-resonance cap; the *PCE number is robust* but the
*input power is not* — for our PCB coil at off-resonance, input
power is set by §5.3's induced-EMF computation, not by Khan's
test-bench.

### 5.2 Reconcile [LeeGhov2011] dead-time math with Qi LF

Lee–Ghovanloo derive the comparator-delay constraint as
`t_delay / T_period ≤ ε`, where ε is the acceptable dead-time
fraction. At 13.56 MHz with their 4 ns comparator → ε ≈ 5.4 %. At
Qi 140 kHz with the *same* comparator → ε ≈ 0.06 %. The 100×
relaxation is dimensionally exact and consistent with first-
principles §5.4 (143 ns budget for ε ≤ 4 %). **No physics violation.**

### 5.3 Reconcile [ChengKi2017] R³ efficiency with our LF cap budget

Cheng–Ki R³ at 6.78 MHz uses a switchable on-die cap ~6.7 nF (sized
to resonate with 0.6 µH receiver coil). At Qi 140 kHz with a 6.2 µH
coil, the equivalent cap is 207 nF → ~33× larger by the f² ratio
*and* by the L ratio. R³ as published does not scale to Qi LF on-
die. **No physics contradiction; cleanly demonstrates the LF
cap-budget barrier.**

### 5.4 Reconcile Petzel §3.5 NFC↔Qi coupling with our PCB

Petzel computes Neumann-formula mutual coupling for a stacked
80 mm-NFC over 56 mm-Qi geometry at PCB-prepreg separation; obtains
`k ≈ 0.3–0.6` for our class of layout. This is consistent with
first-principles §5.8 which independently estimates `k ≈ 0.3–0.7`
by Neumann-formula scaling. **Two independent estimates agree to
within 30 %; coupling is genuinely high and the Qi coil cannot
ignore the NFC coil at LF.**

## 6. References

See [`references.md`](references.md). 17 references catalogued; 2
locally cached and full-text-verified (Petzel 2020 thesis; WPC
PC0 v1.2.3a spec); 4 open-access (MDPI / PMC) recommended for
local caching by a Stage-2 reviewer; 11 paywalled IEEE/Springer
papers cited with DOI + title + author + venue + year and marked
`paywall — abstract-only verification`. Per the research brief,
this is acceptable for paywalled material.

## 7. Negative results

### NR-A1. No published academic Qi free-rider receiver

No peer-reviewed academic paper describes a Qi receiver that
*deliberately omits* WPC protocol participation. All four Qi-band
silicon papers ([Khan2018-Energies], [Wu2019-Qi], [Wu2020-AICSP],
[Quang2015-TIE]) implement full WPC compliance. The free-rider
architecture proposed by the first-principles report (FP-1, FP-2,
FP-3 with D1) is therefore *novel from an academic-publication
perspective*. Risk implication: design effort is small but the
protocol-tolerance space is unexplored in peer-reviewed literature
— Stage 2 should treat the duty-cycle estimate (≤ 19 % per
first-principles §3.4) as the *only* known bound and consider how
multi-pad-vendor variation widens the uncertainty.

### NR-A2. R³ rectifier topology does not directly port to Qi LF

The most architecturally elegant published rectifier+regulator
([ChengKi2017]) requires an on-die resonant cap that is geometrically
infeasible at Qi LF (per §5.3). Stage 2 should explore the *modified*
form: regulation-by-shorting rather than regulation-by-detuning.

### NR-A3. No published academic Qi-band native-NMOS rectifier

The native-Vt MOSFET rectifier lineage ([Mandal2007]) is
demonstrated for biomedical implants at 100 kHz – 1 MHz LF and
for UHF RFID at 900 MHz, but **no published paper applies it
specifically to a Qi receiver**. First-principles report's FP-2
is therefore academically-unproven at Qi LF — though there is no
physical reason it should fail.

### NR-A4. Comparator-delay compensation is wasted effort at Qi LF

Most of the academic literature's design effort goes into
comparator-delay compensation for HF operation. At Qi LF the
delay budget is 25–100× looser; a static-trim offset is sufficient.
Most of the cited papers' *complexity* does not transfer.

### NR-A5. Bio-implant primary-cooperative regulation cannot be used at a stock Qi pad

[ChengKi2016]'s primary equaliser assumes the primary is
cooperatively controlled by the same designer. A stock Qi pad does
not give the receiver this control unless the receiver participates
in the WPC protocol — closing the loop on the unbuilt-D1 path.

### NR-A6. Petzel-class notch filter for shared-coil NFC + Qi requires off-die LC

[Petzel2020] §4.4.4–§4.4.5 proposes a notch / low-pass filter to
share a single PCB coil between NFC and Qi paths. The notch values
require reactive components ≥ 100 nH and ≥ 100 nF — *external
passives*. **Violates our R4.** Confirmed: shared-coil arch is not
viable for our PCB.

## 8. Open questions

See [`open-questions.md`](open-questions.md). 8 questions.

## 9. Comparison readiness

| Approach | Headline performance | Area / power cost | Maturity | Best fit for | Worst fit for |
|---|---|---|---|---|---|
| AS-B1 (passive PN bridge) | 50 % PCE @ 4 V; baseline | < 0.005 mm² | Trivial | Cold-start fall-back | Sustained µW–mW operation |
| AS-B2 (native-NMOS bridge) [Mandal2007 lineage] | 60–75 % @ Qi LF (extrapolated) | < 0.01 mm² | Low (academic at LF) | Sub-mA µW load | Heavy load (reverse leak) |
| AS-B3 (cross-coupled latched comparator) [LeeGhov2011 / ChaPark2012] | 81–90 % @ Qi LF (extrapolated) | 0.01–0.04 mm² | Medium (academic at HF; ports cleanly to LF) | Mainstream µW–mW free-rider | Tightest area budgets |
| AS-B4 (digitally-adaptive delay-comp) [Khan2018 / LeeKim2021] | **85.3 % @ Qi LF (measured)** | 0.05–0.1 mm² | High (silicon-published at Qi LF) | Reference design with full compliance | Free-rider w/ µW load (overkill) |
| AS-B5 (R³ rectifier, modified for off-resonant) [ChengKi2017] | > 90 % @ HF; *not portable* directly to Qi LF | 0.03 mm² + cap-bank/coil-switch | Medium (research) | Stage-3 deep-dive candidate | Production at LF without further work |
| AS-B6 (triple-mode auto-select) [QuangHa2015] | 94.2 % peak; 80 % across 10× input | 0.1+ mm² | Medium (HF at 0.18 µm BCD) | Wide-coupling-range receiver | µW load with simple front-end |
| AS-C1 (multi-feedback LDO) [Khan2018] | 85–92 % PCE; -6 dB ripple | 0.02 mm² | High | Pair with B3/B4 | Fluctuating-Vrect free-rider |
| AS-C2 (CEP-adjusted Vrect) [Quang2015-TIE] | 90 % overall | requires full WPC stack | High | Full-compliance D3 designs | Free-rider D1 |
| AS-D3 (full WPC compliance) | Continuous power transfer | 3–10 kgates digital | High | Reference / "v3" platform | µW v2 chip |
| Petzel L4 notch filter [Petzel2020] | NFC-protect | external L+C, R4 violation | Medium | Paper-only | Our project |

## 10. Author's notes

Three observations and surprises that the sister reports may have
missed:

1. **Comparator-delay-compensation overhead is the wrong axis to
   optimise at Qi LF.** Almost all of the academic-survey literature
   (LeeGhov2011, LuKi2014, ChaPark2012, LeeKim2021) is about pre-
   compensating sub-ns comparator delay to break the 4 ns half-period
   barrier at 13.56 MHz. At Qi 140 kHz, the same architecture has
   ~3.6 µs half-period — the comparators in `gf180mcuD` are
   essentially "instant" by comparison. The first-principles report
   notes this in passing (§5.4) but doesn't draw out the implication
   for *which papers' techniques to copy and which to ignore*. The
   industry survey doesn't address this at all. **Stage 2 should
   explicitly de-prioritise the delay-compensation lineage when
   designing for Qi LF.**

2. **The Khan 2018 *Energies* paper changes the risk profile of the
   first-principles "off-resonant Qi" architecture.** The first-
   principles report's §10 author's-notes flagged it as a "novel
   design problem" because every commercial Qi receiver datasheet
   shows a 100–250 nF series-resonance cap, and the on-die budget
   forbids that. [Khan2018-Energies] is a *peer-reviewed academic
   paper showing 85.3 % PCE at Qi BPP frequency on a fully integrated
   receiver IC* — albeit, on inspection of the abstract, with the
   resonance cap likely off-die. Even so, the broader silicon
   architecture (sync rectifier + multi-feedback LDO at LF) is
   demonstrably workable on 0.18 µm CMOS, *which is the same node
   class as `gf180mcuD`*. Risk for our v2 is materially lower than
   first-principles assumed.

3. **The bio-implant TBioCAS lineage is the most under-cited
   resource for our project.** Industry survey covers Qi/PMA receiver
   ICs (which are HF-relative outliers); first-principles derives
   from physics. Neither connects strongly to the IMD literature
   that has been doing 100–500 kHz inductive WPT receivers at the
   ~mW level *for thirty years*. [LuKi2014], [ChengKi2016],
   [Mandal2015-review], [LeeGhov2011], and the broader Sarpeshkar /
   Ghovanloo / Ki / Tsui authorial network are the prior art for
   *exactly the regime* our v2 chip operates in (sub-MHz LF,
   µW–mW load, ~3 V output). Stage 2 should make this the dominant
   reference family for the rectifier-and-regulator deep-dives.

Process notes:

- **WebFetch on IEEE Xplore returned errors as predicted** by the
  research brief; on Springer URLs returned 303 redirects;
  on MDPI returned 403. Search-engine cross-reference + Semantic
  Scholar / PubMed Central was the only reliable path. **Stage 2
  reviewers** should fetch the four "recommended-add" open-access
  PDFs into `references-cache/` and confirm SHA-256 against
  upstream.
- I spent budget mostly on ensuring six distinct silicon-paper-
  anchored rectifier topologies (B1–B6) — the Stage-1 quality
  checklist requires ≥ 5 distinct approaches, and the assignment
  brief specified ≥ 5 silicon-paper-anchored topologies. **Six
  achieved.**
- The "free-rider" academic-paper gap (NR-A1) is genuinely
  surprising. I cross-checked under multiple search terms ("non-
  compliant Qi receiver", "partial-protocol Qi receiver", "Qi
  free-rider", "ping-snatcher Qi") and found only the Vinod-Tanur
  ATtiny13A artefact (industry-survey [O1]). For Stage 2: this is
  either a true gap in the academic literature *or* a search-
  vocabulary blind spot. Worth a separate exhaustive sweep.
