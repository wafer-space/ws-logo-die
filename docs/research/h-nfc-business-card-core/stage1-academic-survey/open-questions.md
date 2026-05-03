# Open questions -- academic angle

Concrete unanswered questions surfaced by the academic survey.
Each is phrased as a question, with a downstream consequence and
a guess at the kind of investigation that would settle it. The
`Q-as-` prefix distinguishes academic-survey questions from sister
reports' `Q-fp-` (first-principles) and `Q-is-` (industry).

## Q-as-1 -- Phone-compatibility matrix peer-reviewed measurement

**Question.** Is there a peer-reviewed academic measurement
study that publishes "tag X works on phone Y" results across
the major Android NFC controllers (Broadcom BCM20795, NXP
PN553/PN557, Samsung S3FWRN5/S3NRN, MTK MT6605/MT6631) and the
iOS Core NFC stack (iPhone 7, X, 11, 12, 13, 14, 15)?

**Why it matters.** Sister industry survey 3.7 collates the
compatibility envelope from vendor docs and community wikis.
None of those sources is peer-reviewed. The sister-report claim
that "T2T = ubiquitous, T5T = iOS 13+ only" is consistent across
all consulted secondary sources, but a single peer-reviewed
measurement paper would convert this from "industry consensus" to
"empirically substantiated."

**How to settle.** Two routes: (1) keyword search Google Scholar
for "NFC tag compatibility measurement" or "NDEF reader interop"
and follow citations; (2) if no such paper exists, a Stage-3 or
Stage-4 deep-dive *generates* the data using the v1 chip + a
borrowed phone library.

**Status.** No such paper found in the search budget allocated.
Logged as a gap in the academic literature, not a project gap.

## Q-as-2 -- Published gate-count delta for SRAM-buffered RAM-RW T2T

**Question.** Has any peer-reviewed academic silicon paper
published a synthesis-quality gate-count breakdown for a T2T
PICC with reader-writable user memory (NTAG21x-class RAM-RW),
specifically distinguishing the SRAM-macro contribution from the
flop-array contribution?

**Why it matters.** Sister first-principles report 5.8 estimates
~2.4x digital-area multiplier for RAM-RW without an SRAM macro,
~1.5x with one. This is currently a sister-report analytical
estimate. A peer-reviewed cross-check would validate or
contradict the planning assumption that drives item (j)
sizing.

**How to settle.** Search ResearchGate / Semantic Scholar for
"NTAG-style EEPROM" or "passive 14443A RAM tag" with explicit
gate-count tables; failing that, generate the data ourselves in
Stage-4 by synthesising both variants on `gf180mcuD`.

**Status.** No published gate-count breakdown found. `[Lu-2016]`
and `[Bhattacharyya-2018]` report transistor counts at the
chip level, not by RTL block.

## Q-as-3 -- Peer-reviewed vCard 2.1 vs 4.0 NFC-tag comparison

**Question.** Has a peer-reviewed paper benchmarked
vCard 2.1 vs vCard 3.0 vs vCard 4.0 on NFC tags for
*reader-side compatibility* and *minimum payload size*?

**Why it matters.** Sister industry survey claims "vCard 2.1
wins ~30 B over vCard 4.0 for the same semantic content." That
is from the sister researcher's RFC reading, not from a
peer-reviewed comparison study. A 30 B saving is decisive when
fitting a vCard into a 144 B NTAG213-equivalent user memory.

**How to settle.** Google Scholar / IEEE Xplore search for
"vCard NDEF NFC" with peer-reviewed filter. Likely answer: no
such paper exists, in which case a Stage-3 deep dive resolves
the question via direct measurement.

**Status.** No such paper found.

## Q-as-4 -- TBioCAS / JSSC paper on a *non-implant* T2T

**Question.** Is there a TBioCAS, JSSC, or other journal-level
paper on a 14443A T2T PICC that is *not* aimed at biomedical
implants -- i.e. for general consumer use?

**Why it matters.** The journal-grade peer-reviewed literature
on T2T silicon we found is heavily weighted toward implants
(`[Dehennis-2016-TBioCAS]`, `[Anabtawi-2016-BHI]`). Conference
papers (`[Lu-2016]`, `[Myny-2017-ISSCC]`) are the closer fit but
are conference rather than journal grade. A non-implant
journal-grade reference would strengthen the deep-dive citation
chain.

**How to settle.** JSSC / TBioCAS Web of Science search for
"NFC tag IC NDEF" or "NTAG silicon implementation."

**Status.** Not exhaustively searched within the WebFetch
budget. Highest-priority follow-up for a Stage-2 reviewer.

## Q-as-5 -- Modulator R_DSon optimum: published silicon datapoint

**Question.** Does a peer-reviewed silicon paper publish a
sweep of modulator R_DSon vs measured reader-side sideband
amplitude on a passive HF tag IC?

**Why it matters.** Sister first-principles report 5.2
analytically derives R_mod = 2 kOhm as the optimum balancing
modulation depth against modulator-on dissipation. Empirical
silicon data would either validate or revise this number.

**How to settle.** Targeted search of `[Lu-2016]`,
`[Bhattacharyya-2018]`, and other 0.18 um tag-IC papers for
explicit R_DSon vs sideband-amplitude tables. Likely behind
paywall in conference papers.

**Status.** Not resolved -- abstracts do not publish the
R-sweep; full-text behind paywall.

## Q-as-6 -- Academic ISO 14443-2 conformance study

**Question.** Is there a peer-reviewed paper that measures
ISO/IEC 10373-6 PICC analog-test conformance across multiple
academic / commercial tag silicon designs?

**Why it matters.** Once we tape out, we will need to claim
ISO 14443-A conformance. The closest open-access reference we
found is `[NFC-Forum-Analog-Align]` (industry whitepaper). A
peer-reviewed comparison paper would tell us how academic
silicon typically falls short of conformance and where the
margin actually goes.

**How to settle.** Google Scholar for "ISO 10373-6 PICC test
results" or "NFC tag analog conformance measurement."

**Status.** Not found.

## Q-as-7 -- Italian / IMEC academic NFC research follow-ups

**Question.** What is the state of follow-on academic research
to `[Myny-2017-ISSCC]`? Has the IMEC group published a fully-
NFC-Forum-compliant *NDEF-bearing* flexible tag (rather than a
128-b "barcode" tag)?

**Why it matters.** If a follow-on paper exists, its 14443-A
state-machine RTL is the closest published academic gateware to
what we need.

**How to settle.** Search Semantic Scholar for `Myny` papers
post-2017 / `Genoe` / `Heremans` Holst Center on NFC.

**Status.** Search budget exhausted before this could be fully
resolved. Stage-2 reviewer should pick up.

## Q-as-8 -- Self-clocking startup transient: published silicon data

**Question.** What is the *measured* power-on-to-first-response
latency in academic 0.18 um HF passive tag ICs, vs the
analytical sub-microsecond rectifier-ramp + brown-out-release
budget in sister first-principles 5.5?

**Why it matters.** Cross-checks the sister-report assumption
that we comfortably hit the < ~5 ms reader scan cadence.

**How to settle.** Sister-report cross-cited `[Lu-2016]` and
`[Bhattacharyya-2018]` to publish startup oscilloscope plots --
behind paywall.

**Status.** Not resolved within the search budget.

## Q-as-9 -- Carrier-derived clock duty-cycle / phase-noise budget

**Question.** Does any academic paper analyze the
phase-noise / duty-cycle budget of an fc-divider chain off a
rectified 13.56 MHz carrier *as a clock*?

**Why it matters.** Sister-report 5.3 argues qualitatively that
a divide-by-N preserves ppm; in practice, rectifier-induced
edge jitter at the divider input contributes phase noise at the
modem clock. If the contribution is large, it might affect
modulator-edge alignment.

**How to settle.** Look in `[Myny-2017-ISSCC]` follow-up
journal papers or in textbook material on RFID clock recovery.

**Status.** Open. Probably resolvable in Stage-3 deep dive
with a Spice-level simulation.

## Q-as-10 -- Power-on-reset behaviour during modulator-induced antenna shorts

**Question.** What is the worst-case rail droop in a
peer-reviewed silicon design when the modulator is shorting the
antenna at the 847.5 kHz subcarrier rate?

**Why it matters.** The harvester (sister item (b)) must
sustain the rail through these intentional shorts. Sister-
report (b) flags this as a co-design concern; a peer-reviewed
silicon datapoint would constrain the storage-cap requirement
(sister item (e)).

**How to settle.** Targeted full-text reading of `[Lu-2016]`
and `[Bhattacharyya-2018]` -- behind paywall.

**Status.** Open.

## Q-as-11 -- Academic anticollision-handshake gate-count breakdown

**Question.** Does any peer-reviewed paper publish a gate-by-
gate breakdown of an ISO 14443-3 cascade-level-2 anticollision
state machine?

**Why it matters.** Sister first-principles 5.3 derives
~150 gates analytically. A peer-reviewed cross-check would
validate or revise this.

**How to settle.** Search for "ISO 14443-3 anticollision
synthesis" or look at `NfcEmu-VHDL` synthesis reports.

**Status.** Open.

## Q-as-12 -- Manufacturer-ID byte selection guidance

**Question.** Is there an academic / standardisation paper
that documents safe manufacturer-ID-byte allocations for
masquerading-as-conformant-but-not-vendor-cloning T2T tags?

**Why it matters.** Sister industry survey Q-is-4 raises this.
Picking the wrong manufacturer ID byte SN0 risks colliding with
NXP/ST/Infineon allocated codes.

**How to settle.** ISO 7816-6 has the IIN allocation rules;
verify which subset is "research / experimental" vs "vendor."

**Status.** Open. Cross-cuts with sister industry survey.

## Priority for Stage-2 synthesis

The three highest-value academic-side gaps for a Stage-2 reviewer
to chase are:

1. **Q-as-4** (journal-grade T2T silicon paper, non-implant) --
   strengthens the deep-dive citation chain.
2. **Q-as-1** (peer-reviewed phone-compatibility matrix) --
   converts our reach claim from community-consensus to
   empirically-substantiated.
3. **Q-as-5** (modulator R_DSon optimum from published silicon) --
   quantitatively backs the 2 kOhm choice with a measured
   datapoint rather than analytical only.

The remaining nine questions are useful but secondary; most of
them are answerable only behind IEEE Xplore paywall and so were
deliberately deferred per the brief's WebFetch guidance.