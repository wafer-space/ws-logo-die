---
item: a
item_name: internal-oscillator
stage: 1
angle: industry-survey
researcher: claude-opus-4-7-1m (industry-survey instance 1/3)
status: draft
last-updated: 2026-05-03
---

# Open questions -- Stage-1 industry-survey, item (a) Internal oscillator

This file is the structured backing data for Sec 8 of `report.md`.
Each question is concrete, has a downstream decision or work item that
depends on it, and has a guess at what kind of investigation would
settle it.

Tags applied per question:
- **[DECIDE]** -- a project decision is required (Stage 2 / 3 input).
- **[INVESTIGATE]** -- a research / measurement / sim activity is
  required to gather more information.
- **[VERIFY]** -- a citation or claim needs reviewer / second-pass
  verification.
- **[CROSS-ITEM]** -- depends on a sibling work item (b/c/d/e/f/h/i/j/k).

The Q-numbers are stable. Open-questions.md from the
[`stage1-first-principles`](../stage1-first-principles/report.md) sister
report uses overlapping numbering deliberately so that Stage-2 can
trivially merge them; where the same Q-number appears in both files,
the questions are coordinated (the industry-survey angle adds
*industry-grounded* context; the first-principles angle adds *physics-
grounded* context).

## Q1 -- Does the chip really run osc-free in NFC mode? [INVESTIGATE]

**Question.** ISO/IEC 14443-A specifies tag timing as integer divisions
of the 13.56 MHz reader carrier. Industry tag ICs (NTAG / MIFARE / ST25)
universally implement this with a counter on the carrier. Does our
NFC core (item h) need any *additional* internal-oscillator coverage
during NFC operation -- e.g. for a sub-microsecond cold-start before
the carrier-recovery comparator is biased?

**Why it matters.** If the answer is "no", topology I3 in
[`solutions.md`](./solutions.md) becomes the canonical answer for
items (a) + (h) jointly. If the answer is "yes" but only sub-us, then
a tiny A1 ring suffices as a cold-start. If "yes for milliseconds",
then a B2 oscillator must run during NFC mode.

**Guess at investigation.** (a) Read NXP NTAG application note
NDA-free white papers on tag wake-up sequencing; (b) cross-reference
with the academic-survey angle's reading of relevant ISSCC NFC tag
papers; (c) ultimately confirm with a SPICE sim of the
carrier-recovery comparator's bias-up time on GF180MCU.

**Industry evidence so far:** Universal industry pattern is "no
internal RC during NFC" -- E1/I3 in solutions.md, citing
`[NXP-NTAG213]` / `[ISO14443-A]`.

**Cross-references:** First-principles sister report Q1 (same number,
same topic, complementary physics analysis).

## Q2 -- Trim resolution available at test time [INVESTIGATE / DECIDE]

**Question.** Industry B2 oscillators reach +/-1 % at 25 C with 5-8 bit
trim DACs and a per-die test-time calibration sweep. What trim
resolution can we realistically deploy?
- 4-bit trim (16 steps, ~3 % per LSB): cheap, gives +/-3 %.
- 8-bit trim (256 steps, ~0.3 % per LSB, mirrors STM HSI): standard.
- 12-bit trim (4096 steps, ~0.02 % per LSB): unusual, would need a
  more elaborate trim scheme.

**Why it matters.** Determines the realistic accuracy ceiling of
Architecture II / III. Per `[ST-AN5067]`, ~0.3 % per LSB is industry
standard.

**Guess at investigation.** (a) Determine eFuse bit budget allocated
to oscillator trim by item (j); (b) decide whether trim happens in HDL
state machine or on a tester (post-fab probe-card); (c) prototype on
the Mabrains ring-osc cells.

**Cross-item dependency:** **[CROSS-ITEM]** item (j) eFuse bit budget.

## Q3 -- Mabrains ring-osc cell re-use viability [INVESTIGATE]

**Question.** `[GF180-MABRAINS]` ships `Ring-Osc-3.3vFETs` and
`Ring-Osc-5.0vFETs` cells as Apache-2.0 licensed open-source IPs on
GF180MCU. Can these be dropped into our project unchanged, or do they
need re-layout / re-characterisation for our specific operating
points?

**Why it matters.** Determines schedule. If unchanged drop-in works,
we save weeks of layout work for Architecture I-class needs. If
significant rework is required, we should plan accordingly.

**Guess at investigation.** (a) Inspect the Mabrains GitHub repo's
ring-osc layout; (b) run DRC against our PDK 1.6.3 (the Mabrains work
may have been done against an earlier PDK release); (c) characterise
in ngspice with our SPICE deck.

**Status:** README confirmed clean DRC/LVS/PEX as of the Caravel-GFMPW1
shuttle date. Compatibility with PDK 1.6.3 not yet verified.

## Q4 -- Bandgap reference characterisation on GF180MCU [INVESTIGATE]

**Question.** Multiple topologies (A2, A3, B2, B3, C1, F3) require a
bandgap reference. The PDK supplies the PNP and resistor primitives
but not a foundry bandgap macro. What's the practical PSRR / accuracy
/ start-up time of a textbook Razavi-style bandgap on GF180MCU?

**Why it matters.** Bandgap quality bounds oscillator quality. PSRR
under harvested-rail ripple conditions is the single most important
spec; Razavi-style bandgaps typically achieve 50-70 dB at low
frequencies but degrade to 20-40 dB at hundreds of kHz -- which is
the noise band of our harvested rail.

**Guess at investigation.** (a) Synthesise a Razavi-style bandgap
schematic; (b) ngspice corner sims of PSRR vs frequency; (c) check
existing Caravel / Mabrains GF180MCU bandgap designs for reusable
prior art.

**Cross-references:** Sister report Q3 (bandgap cold-start under
brown-out).

## Q5 -- Bandgap reuse plan [DECIDE / CROSS-ITEM]

**Question.** Should the chip have one bandgap shared across (b/c)
rectifier reference, (i) brown-out detector, (j) eFuse program
voltage detect, and (a) oscillator? Or per-block bandgaps?

**Why it matters.** A single shared bandgap saves ~3000 um^2 *and*
~50 uW of static current -- significant fractions of the chip's total
budget. But it forces all consumers to live in the same
power domain (or to tolerate a level-shifted bandgap output).

**Guess at investigation.** Architecture decision; needs input from
items (b)/(c)/(i)/(j) authors. Default: shared bandgap, with per-block
SB-PWR-GATE on the bandgap.

**Cross-item dependency:** [CROSS-ITEM] (b), (c), (i), (j).

## Q6 -- Carrier-trim accuracy floor [INVESTIGATE]

**Question.** When the NFC carrier (13.56 MHz +/- 50 ppm reader spec)
is used as the trim reference for a B2 oscillator (architecture III /
topology E4), what's the achievable post-trim accuracy? Bound by
carrier jitter, edge-detector jitter, counter resolution, and
trim-DAC step size.

**Why it matters.** Determines whether Architecture III gets us to
+/-50 ppm (carrier-spec-equivalent) or only to +/-2500 ppm (USB-style).

**Guess at investigation.** (a) Read `[NXP-AN4905]` (Kinetis
crystal-less USB) for a reference implementation's measured-accuracy
spec; (b) ngspice + cocotb co-sim of the trim loop; (c) check whether
the academic-survey angle's papers report measured numbers.

**Industry reference point:** USB SOF trim hits +/-2500 ppm. NFC frame
edges are coarser (9.4 us per bit vs 1 ms per SOF frame), but carrier
zero-crossings are much faster -- could be much tighter.

## Q7 -- Harvested-rail ripple spectrum [INVESTIGATE / CROSS-ITEM]

**Question.** What is the actual ripple spectrum of the harvested rail
under each operating mode (NFC / Qi / ambient RF)? This determines the
PSRR specification each oscillator topology must meet.

**Why it matters.** B2's headline +/-1 % accuracy assumes a quasi-DC
V_DD. Our rail will ripple at 1 kHz (LED), 100-205 kHz (Qi), 847.5 kHz
(NFC subcarrier). The ripple amplitude at each frequency, multiplied
by the oscillator's PSRR rejection at that frequency, is the rail-
contributed accuracy term.

**Guess at investigation.** (a) Wait for items (b/c/d/e) to publish
their rectifier and storage-cap designs; (b) co-sim the rail under
realistic load profiles.

**Cross-item dependency:** [CROSS-ITEM] (b), (c), (d), (e).

## Q8 -- Patent-clearance status [VERIFY]

**Question.** USP-6,020,792 (Microchip), USP-9,344,070 (TI), and
USP-8,222,940 (TU Delft) are cited in `solutions.md`. The first two
are still within patent-life (granted 2000 and 2016 respectively); the
third is similar (granted 2012). Does our use of the underlying
topologies need patent clearance?

**Why it matters.** Open-source / Apache-2.0 hardware ICs must be
patent-clean. If we implement B3 (USP-6020792's PTAT/CTAT topology),
we may need either a license or a sufficiently-different
implementation.

**Guess at investigation.** (a) Read the patent claims (not just
abstracts); (b) check whether the PTAT/CTAT-current technique
predates the patent (it does -- Widlar/bandgap literature from the
1970s); (c) consult with project legal lead.

**Industry note:** USP-6020792's claim language tends to be specific
to *Microchip's exact embodiment* (specific cap/comparator topology,
specific trim scheme). Generic relaxation oscillators with
PTAT-biased current sources are very widely deployed and likely not
infringing of the specific claims, but **this is a legal opinion and
should not be substituted for one**.

## Q9 -- HOCO firmware-correction adaptability [INVESTIGATE]

**Question.** Renesas HOCO `[RENESAS-RL78G23-HOCO]` achieves +/-0.1 %
via on-die-temperature-sensor-fed firmware correction. The
wafer.space chip has no firmware. Can a pure-HDL state machine
implement enough correction to get within +/-1 %?

**Why it matters.** If yes, our accuracy ceiling moves from B2's
+/-2 % to roughly +/-0.5-1 %, narrowing the gap to industry's tight
end. If no, we accept B2's ceiling.

**Guess at investigation.** (a) Read the Renesas HOCO algorithm
description; (b) write a minimal HDL state machine that does
linear-extrapolation correction of an oscillator-trim word against an
on-die temperature sensor; (c) cocotb-simulate to confirm reasonable
effective accuracy.

**Industry caveat:** The Renesas mechanism is patent-protected and
the algorithm is partly proprietary. We may need a clean-room
implementation.

## Q10 -- ST app-note PDF retrieval [VERIFY]

**Question.** Three ST app notes (AN2868, AN4736, AN5067) failed to
mirror via direct WebFetch (slow CDN). Should we retry via curl /
Wayback / direct st.com?

**Why it matters.** These app notes contain numeric details (trim step
size, PVT envelope, CRS algorithm) that strengthen the comparison vs
B2-class oscillators.

**Guess at investigation.** Reviewer retry via `curl -O` or
web.archive.org. URL existence is confirmed via search index.

**Status:** [VERIFY] -- in `references.md` "Failed-fetch" table.

## Q11 -- Should items (a) and (h) be designed jointly? [DECIDE]

**Question.** Architecture III (I3 + E4) treats item (a) and item (h)
as a *single integrated subsystem* that shares the carrier-divide path
and the FLL trim path. Does this conflict with the project's per-item
research / design split?

**Why it matters.** If yes (joint design), we get a smaller / cleaner /
more accurate chip but item (a) and (h) reviewers must coordinate. If
no (independent design), each item ships its own oscillator and we
miss the carrier-trim benefit.

**Guess at investigation.** Architectural decision; project-owner
input.

**Recommendation (placeholder for Stage-2 to address):** joint design
is the industry pattern (every NFC tag IC ships this way) and we
should adopt it.

## Q12 -- Process-corner sensing area / power overhead [INVESTIGATE]

**Question.** A3 (process-corner-sensing compensated ring) reports
22 ppm/C measured silicon. What's the *area / power* overhead of the
process-probe vs an A2 baseline?

**Why it matters.** If the overhead is small (say <500 um^2 / <10 uW),
A3 is a strict upgrade over A2 and should be the default. If large,
A3 is a niche option.

**Guess at investigation.** Read the cited STM community thread
`[STM-RC-COMMUNITY]` and any cited published designs;
academic-survey angle should follow up with the Liu/Bowers
0.18 um JSSC papers.

## Q13 -- F1 thermal-diffusivity reference burst-mode feasibility [INVESTIGATE]

**Question.** F1 (`[USP-8222940]`) is the most novel commercial-adjacent
oscillator architecture. Its 7.8 mW continuous power is unaffordable.
Could it run in burst mode (1 % duty cycle, 80 uW average) to trim a
B2 oscillator at chip start-up only, with eFuse-stored result?

**Why it matters.** Would let the wafer.space chip *demonstrate* the
F1 architecture as a public engineering portfolio piece without paying
the continuous-power cost.

**Guess at investigation.** (a) Read the patent's start-up / settling
characterisation; (b) check whether the academic literature reports
1 %-duty thermal-diff implementations.

## Q14 -- Trim margin to budget for B2 on harvested rail [DECIDE]

**Question.** Per N1 in `report.md` and N4 in the first-principles
sister report, B2's textbook +/-1 % becomes ~+/-5 % under harvested-
rail ripple. How much trim range do we budget?

**Why it matters.** Determines OSCCAL bit-width. +/-5 % over PVT plus
+/-20 % R/C absolute tolerance means trim range needs to cover at
least +/-25 %; with 0.3 % per LSB that's 167 steps, so 8 bits
(256 steps) is right.

**Guess at investigation.** Architectural decision based on
item (b)/(c)/(d)/(e) ripple budget.

**Recommendation (placeholder for Stage-2):** 8-bit trim, mirroring
the industry-default ST HSI16 / Microchip OSCCAL.

## Q15 -- Should the chip have a dedicated *wake-up* oscillator? [DECIDE]

**Question.** Industry pattern (I2) splits LFRC (always-on, very
low-power, drift-tolerant) from HFINT (on-demand, high-frequency,
trimmed). G2 (sub-threshold beta-mult, ~10 nW) is a perfect LFRC for
us. Do we want this split, or can a single oscillator do both?

**Why it matters.** A single B2 oscillator cannot run as a
brown-out timer because B2 needs a bandgap that itself doesn't run
below ~2 V V_DD; the chip would be blind to whether the rail has
recovered if no separate sub-V_BG-floor osc exists.

**Guess at investigation.** Decision: yes, follow the I2 industry
pattern. (Architecture II / III in `components.md` Sec 3 already
assumes this.)

## Q16 -- BLE LO topology cap-bank trim resolution [INVESTIGATE]

**Question.** H1 (LC tank with on-die spiral) is the only viable BLE LO
topology. What cap-bank trim resolution (number of switched MIM caps
across the tank) is needed to cover the BLE channel grid (40 channels
at 2 MHz spacing) plus PVT?

**Why it matters.** Defers to item (k). Listed here so item (a)
research's BLE-readiness is captured.

**Guess at investigation.** Standard PLL VCO design problem; defer
to (k) deep-dive.

**Cross-item dependency:** [CROSS-ITEM] (k).

## Q17 -- Tiny Tapeout cell re-use beyond ring osc [INVESTIGATE]

**Question.** `[TT-MV-ANALOG-RINGOSC]` (mattvenn 265 ring oscillators
PUF/sensor) and `[TT04-ROTEMP]` (Munoz ring-osc-temp-sensor) are
adjacent designs that solve the same "characterise a ring's PVT"
problem we'd need for an A3-class compensated ring. Are these reusable?

**Why it matters.** Could short-cut the design effort for A3 if the
underlying methodology can be lifted.

**Guess at investigation.** Inspect the Tiny Tapeout repos; check
licensing; assess whether the PUF / temperature-sensor data extraction
is generalisable to a clock-correction loop.

## Q18 -- Self-clocked NFC modulation under brown-out [INVESTIGATE / CROSS-ITEM]

**Question.** When the NFC carrier dips during load-modulation events,
does the chip's E1 carrier-divider lose lock? Industry NTAG tags
seemingly tolerate this, but the mechanism is not publicly documented.

**Why it matters.** If the carrier-divider must "ride through"
modulation gaps, additional logic (a free-running ring as cold-clock
during gaps, with phase resync on carrier return) is needed.

**Guess at investigation.** Read NTAG / MIFARE technical white papers;
sim with realistic carrier waveform during load-modulation pull.

**Cross-item dependency:** [CROSS-ITEM] (h) NFC core.

## Q19 -- LDR / power-on-reset interaction [INVESTIGATE]

**Question.** Industry parts pair the internal RC with a brown-out /
power-on-reset block; our item (i) covers the BOR. Does the BOR's
hysteresis interact with the oscillator's start-up sequence in a way
that requires careful design?

**Guess at investigation.** Architectural review; defer to item (i).

**Cross-item dependency:** [CROSS-ITEM] (i).

## Q20 -- Output skew / clock-distribution to consumers [INVESTIGATE]

**Question.** Industry datasheets typically don't characterise the
skew between an internal RC's output and the consumers' clock inputs.
On our chip, the harvested-mode consumers (LED twinkle, NFC, eFuse
program) are physically distributed -- what's the skew budget?

**Why it matters.** Probably negligible at our frequencies (sub-MHz),
but worth confirming. CTS (clock-tree synthesis) usually handles it
for us via OpenROAD.

**Guess at investigation.** Standard OpenROAD CTS pass; defer to
implementation.

## Summary of question types

| Type | Count | Main blockers |
|---|---|---|
| [DECIDE] | 6 | Q2 (overlap), Q5, Q11, Q14, Q15 + Q2 |
| [INVESTIGATE] | 13 | Q1, Q3, Q4, Q6, Q9, Q12, Q13, Q16, Q17, Q18, Q19, Q20, Q2 |
| [VERIFY] | 2 | Q8, Q10 |
| [CROSS-ITEM] | 6 | Q2 (j), Q5 (b/c/i/j), Q7 (b/c/d/e), Q11 (h), Q16 (k), Q18 (h), Q19 (i) |

(Some questions have multiple tags.)

## Stage-2 hand-off priorities

The Stage-2 synthesiser should take, in priority order:

1. **Q1, Q11** -- the joint (a)+(h) architecture decision is the
   single most consequential design choice. Industry evidence and
   first-principles agree: yes, treat them jointly.
2. **Q14, Q2** -- trim-budget decisions feed into the OSCCAL design
   for B2.
3. **Q5** -- bandgap reuse drives the chip's analog-block area
   amortisation.
4. **Q4, Q7** -- bandgap PSRR vs harvested-rail ripple is the
   constraint that makes or breaks B2-class accuracy in our use
   case.
5. **Q9** -- if the answer is "yes, an HDL state machine can do enough
   HOCO-class correction without firmware", the accuracy ceiling
   moves; if "no", we accept B2.
6. **Q3** -- the Mabrains drop-in viability gates schedule.
7. The remainder -- Stage-3 / Stage-4 deep-dive territory.
