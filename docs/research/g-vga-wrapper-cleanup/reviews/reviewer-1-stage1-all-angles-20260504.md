---
report_under_review: docs/research/g-vga-wrapper-cleanup/stage1-{first-principles,industry-survey,academic-survey}/
reviewer: claude-opus-4-7-1m (Stage-1 reviewer-1, 11/11 in the wave)
date: 2026-05-04
verdict: revisions-requested
---

## Verdict

**revisions-requested.** The three Stage-1 reports for item (g) are
collectively solid and the in-tree factual claims (pin map, port
widths, wiring, slot defines, cocotb coverage) all check out cleanly.
However, the academic-survey carries the same programme-wide pattern
the prior 10 reviewers flagged: **citation-author hallucinations**.
Two of its four substantive academic references list authors that
do not match the published author lists. One (Filip et al.)
misnames the author entirely; the other (Ajayi et al. DAC 2019)
extends the actual author list with names that are not on the paper
and drops names that are. These are correctable in place; the
underlying technical conclusions still stand because the relevant
quote (Ghazy & Shalan WOSET §II "well-invested one-time effort") is
in the cached PDF and verbatim correct.

The first-principles and industry-survey reports are essentially
clean. (g) is genuinely the simplest item in the programme — the
"only ~9 options for two dead bits" framing is honest, the
re-harden verdict is mechanically sound, and both reports
appropriately resist padding.

## Findings

### Reference verification (REQUIRED)

| Citation | URL/DOI resolved? | Document matches citation? | Local cache present? | Local cache matches upstream? |
|---|---|---|---|---|
| Acad-1 Ghazy & Shalan 2020 WOSET (`https://woset-workshop.github.io/PDFs/2020/a21.pdf`) | yes (cached PDF read directly) | **yes** — title, authors (Ghazy/Efabless; Shalan/AUC), and the §II "well-invested one-time effort" quote all reproduce verbatim in pages 1-3 of the cached PDF | yes — `references-cache/Acad-1/ghazy-shalan-2020-openlane-woset.pdf` (2715477 bytes, SHA-256 `243d78506883643201f57e60a7d346da7ac95c8056cea558528c4d03720e7a52`) | n/a (upstream PDF cannot be re-fetched as text via WebFetch — binary; cache integrity confirmed by reading it back and matching the §II quote that the report cites) |
| Acad-2 Shalan & Edwards 2020 ICCAD (DOI 10.1145/3400302.3415735) | DOI metadata yes via Semantic Scholar API; ACM DL 403 to WebFetch | **yes** — title "Building OpenLANE: A 130nm OpenROAD-based Tapeout-Proven Flow : Invited Paper", authors **M. Shalan, Tim Edwards**, year 2020, venue ICCAD 2020 — all match the academic-survey citation | n/a (paywalled) | n/a |
| Acad-3 Ajayi et al. 2019 DAC (DOI 10.1145/3316781.3326334) | DOI metadata yes via Semantic Scholar API | **NO — author list materially wrong.** Actual title is "INVITED: Toward an Open-Source Digital Flow: First Learnings from the OpenROAD Project" (the academic-survey title is paraphrased but acceptable). Actual author list per Semantic Scholar: T. Ajayi, V. Chhabria, Mateus Fogaça, S. Hashemi, **Abdelrahman Hosny**, A. Kahng, Minsoo Kim, Jeongsup Lee, U. Mallappa, **Marina Neseem**, G. Pradipta, S. Reda, **Mehdi Saligane**, S. Sapatnekar, C. Sechen, **M. Shalan**, W. Swartz, Lutong Wang, **Zhehong Wang**, M. Woo, Bangqi Xu. The academic-survey's `references.md` lists fifteen names that are not on the paper (Blaauw, Chan, Cheng, Choo, Coltella, Dreslinski, Ibrahim, Li, Liang, Penzes, Rovinski, Samadi, Saul, Srinivas, Sylvester, Urquhart) and drops five that are (Hosny, Neseem, Saligane, Shalan, Zhehong Wang). | n/a | n/a |
| Acad-4 Filip et al. 2024 IEEE ESL (DOI 10.1109/LES.2023.3267341) | DOI resolves (redirects to IEEE Xplore which 418/403s; Semantic Scholar API resolves cleanly) | **NO — primary author misnamed.** Title and DOI are correct ("Vector Accelerator Unit for Caravel", IEEE Embedded Systems Letters 2024). Actual authors per Semantic Scholar: **Emilio Isaac Baungarten-Leon, Susana Ortega-Cisneros, Uriel Jaramillo-Toral, F. J. Rodriguez-Navarrete, L. Pizano-Escalante, J. J. Raygoza-Panduro**. There is no author named "Filip" on this paper. The academic-survey's "Filip, A. et al." attribution is a hallucination. | n/a | n/a |
| Acad-5 Venn 2024 SSC-M (DOI 10.1109/MSSC.2024.3418264) | metadata not directly verifiable in this review (Semantic Scholar 429-throttled, IEEE Xplore blocked, TechRxiv 403; the academic-survey itself notes all three) | partial — title/venue/year/DOI are all consistent across multiple non-fetchable secondary mentions; **author "Matthew David Venn"** is plausibly correct but not independently verified in this review pass. The academic-survey marks this entry "not fully read" which is honest. | n/a (access blocked) | n/a |

**Net:** two of five spot-checks have author-attribution defects.
Per CORRECTIONS.md the programme-wide pattern is now 11/11.

### Solution-space coverage

The three angles together catalogue these distinct approaches. I
list them once with the union of the parallel reports' option IDs
to flag any silent omissions:

- Wrapper-shrink (G1 / B1 / B-Acad-1): **all three** angles cover.
- Document-only (G2 / A1 / A-Acad-1): **all three** angles cover.
- Internal const tieoff, port-stable (G8 / A2 / C-Acad-2): **all three** angles cover.
- Repurpose dead bits as DFT/test (G3, G6 / C1 / C-Acad-1): **all three** angles cover.
- eFuse / OTP repurpose tied to (j) (G4, G9 / C2 / C-Acad-3): **all three** angles cover.
- Repurpose as analog/power-monitor at chip-top — refuted (G5 / C3 / D-Acad-1): **all three** angles cover.
- Cross-domain LFSR debug input (G7): **only first-principles** covers. Industry- and academic-surveys do not enumerate this. Acceptable: it is a "silly but listable" leaf in family C, and it depends on items (f) and (i). Not a defect.
- Renamed-port shrink (B2 "reduce-and-rename"): **only industry-survey** covers. The first-principles report skips this; it is a sub-variant of G1 with different cosmetics. Worth a single-line nod in first-principles' G1 description but not load-bearing.
- Hybrid pad reassignment to (b) (D1): **only industry-survey** covers; academic-survey explicitly maps to D-Acad-1 and refutes via PDK; first-principles does not list it. Acceptable: it depends on (b) Stage-1 outputs.

Both ends of the spectrum are represented (G2 / A1 "do nothing" at
one end; G9 "post-fab eFuse mux per bit" at the other). The
per-item README's three explicit prompts are all addressed:

1. "What ports the upstream module actually uses" → §5.1 of all three reports, with line-number citations. ✓
2. "What hardened views would need re-generation" → §5.2 first-principles, §5.2 industry-survey, §5.1 academic-survey. ✓
3. "Whether dead bits could be productively repurposed" → families B/C (G3-G6, C1-C3, C-Acad-1) of all three. ✓

No silent omissions detected against the README scope.

### Premature narrowing

- **First-principles**: 9 options across 3 families. Longest single
  option (G5 negative result) is roughly 6 % of the report.
  Executive summary explicitly says "no winner is picked." ✓ no
  premature narrowing.
- **Industry-survey**: 8 options across 4 families. Single longest
  (B1) about 8 % of the report; A1 / A2 / C1 / C2 each comparable
  shares. Executive summary lists the conclusions without picking.
  ✓
- **Academic-survey**: deliberately defers to parallel reports'
  enumeration and instead documents the academic *positions* on
  each. This is methodologically defensible for a thin-literature
  item per the per-item README's permission. The executive summary
  identifies B-Acad-1 as "the most directly applicable academic
  position located" — borderline picking-a-winner language. The
  report immediately walks it back: "The survey does not pick a
  winner. Stage 1 forbids it." Acceptable but the wording is
  asymmetric (B-Acad-1 gets "most directly applicable", others do
  not get a comparable label).

### Numerical claim verification

This item is HDL/build-flow with very few numbers. The claims
worth checking:

**1. "Five ui_in bits used, two dead, plus ui_in[7]."** Verified
against `vga_screensaver/tt-waferspace-vga-screensaver/src/tt_um_waferspace_vga_screensaver.v`:

- `ui_in[0]` line 37: `wire cfg_tile = ui_in[0];` — used ✓
- `ui_in[1]` line 38: `wire cfg_solid_color = ui_in[1];` — used ✓
- `ui_in[2]` only in `_unused_ok = &{ena, ui_in[7:1], uio_in}` line 70 — dead ✓
- `ui_in[3]` only in `_unused_ok` line 70 — dead ✓
- `ui_in[4]` line 54: `.pmod_latch(ui_in[4])` — used ✓
- `ui_in[5]` line 53: `.pmod_clk(ui_in[5])` — used ✓
- `ui_in[6]` line 52: `.pmod_data(ui_in[6])` — used ✓
- `ui_in[7]` only in `_unused_ok` line 70 — wrapper hardwires `1'b0` at `wrapped_vga.v:15` (`.ui_in({1'b0, inputs})`) — confirmed dead ✓

Used count = 5. All three reports correctly identify {0, 1, 4, 5, 6}.

**2. "wrapped_vga.inputs[2:3] are the dead bits."** Verified by the
concatenation `.ui_in({1'b0, inputs})` in `wrapped_vga.v:15`: with
`inputs[6:0]` becoming `ui_in[6:0]`, indices line up identically.
So `wrapped_vga.inputs[2]` ↔ `ui_in[2]` and `wrapped_vga.inputs[3]`
↔ `ui_in[3]`. ✓

**3. "ui_in[2:3] correspond to chip-top input pads input[6:7]."**
Verified at `src/chip_top.sv:213`: `.inputs(input_PAD2CORE[10:4])`.
With the wrapper's `inputs[6:0]` mapped from `input_PAD2CORE[10:4]`,
`inputs[2]` ↔ `input_PAD2CORE[6]` and `inputs[3]` ↔
`input_PAD2CORE[7]`. ✓ The first-principles pin-map table is
correct.

**4. "Smaller slots have only 4 input pads."** Verified at
`src/slot_defines.svh`: SLOT_1X1 has `NUM_INPUT_PADS = 12`;
SLOT_0P5X1, SLOT_1X0P5, SLOT_0P5X0P5 each have `NUM_INPUT_PADS =
4`. The first-principles open-question Q5's observation that the
7-bit `wrapped_vga.inputs` cannot fit on smaller slots is correct
— `input_PAD2CORE[10:4]` would index out of a 4-pad array. ✓

**5. "DIE_AREA 500×500 µm = 0.25 mm²."** Trivial: 500 × 500 =
250 000 µm² = 0.25 mm². ✓ (Industry-survey §5.4.)

**6. "8 options for handling the dead bits" claim in the brief.**
The brief asks reviewers to verify "the report claims `ui_in[2:3]`
are dead bits with 8 options for handling them." The
first-principles report enumerates 9 options (G1–G9), not 8;
industry-survey enumerates 8 (A1, A2, B1, B2, C1, C2, C3, D1);
academic-survey maps academic positions to 8 short names (A-Acad-1,
A-Acad-2, B-Acad-1, B-Acad-2, C-Acad-1, C-Acad-2, C-Acad-3,
D-Acad-1). The brief's "8 options" is approximately right but is a
per-angle count rather than a unified count; nothing wrong with the
reports.

**7. "LEF re-harden mandatory for any port-width change."**
Per first-principles §5.2 and academic-survey §5.1: LEF MACRO
blocks enumerate `PIN <name>` per signal with no bus-parameter
syntax; Liberty .lib enumerates `pin (...)` blocks per port. Both
are correct mechanical claims about LEF/Lib syntax. The
first-principles report flags its reference [2] as
NOT-independently-fetched, which is honest. The academic-survey
corroborates via Ghazy & Shalan 2020 §III + Fig. 1. **Verdict
holds.** No physics violation; the verdict is by construction
(LEF/Lib are line-level enumerations of ports, no port-shrink
in-place edit can be both syntactically valid and consistent with
chip-top LVS).

No numbers violate physics. No "too good to be true" red flags.

### Negative results

- First-principles §7: three negative results (G4 blocked on (j)
  Stage-1 absence, G5 blocked on cell-type swap, G2 fails the goal
  definitionally). Each gives the failure mode and condition. ✓
- Industry-survey §7: five negative-results-style observations,
  including the "TT pin convention does not transfer to non-TT
  wrappers" / "renaming silently goes wrong on upstream bumps"
  pattern. ✓
- Academic-survey §7: four findings (no academic paper on dead-bit
  handling, IEEE Xplore hostile to LLM, TechRxiv 403, ResearchGate
  403). The first is genuinely a research finding; the other three
  are methodology limits, which is borderline padding but
  legitimate to record. ✓

All three reports have actionable negative-results sections.
None is a "no relevant failures found" stub.

### Convergence with parallel reports

Convergence on G1 / B1 / B-Acad-1 (wrapper-shrink-and-re-harden)
is high — all three converge on this as the headline option. The
academic-survey explicitly cross-cites the first-principles report
in §5.1 ("This corroborates the parallel first-principles report's
§5.2 derivation"). This is acceptable here because the per-item
README explicitly anticipates a small research load and the
academic-survey honestly reports literature thinness rather than
inventing references to fill the gap.

The convergence is **expected, not suspicious**. The three reports
do reach the same headline by different paths:

- First-principles: derives the LEF-line-level re-emission claim
  from LEF syntax knowledge.
- Industry-survey: derives the same from "every artefact carries
  the port list — there is no in-place edit path that survives
  LVS at chip-top integration."
- Academic-survey: cites Ghazy & Shalan §II + §III and treats
  re-harden as the literature's endorsed pattern.

These three derivations are independently sound; the agreement
strengthens the conclusion.

The G3 / C1 / C-Acad-1 family (DFT repurpose) is similarly covered
by all three but with each angle giving a different verdict
flavour: first-principles says "useful only if upstream forks
to consume the bits"; industry-survey says "scope creep into DFT";
academic-survey says "literature silent." No suspicious wording
overlap.

I do **not** flag suspicious convergence on (g). For an item
this small, three angles arriving at the same answer is the
correct outcome.

### Specific revisions requested

1. **Academic-survey `references.md` Acad-4 (Filip → Baungarten-Leon):**
   replace "Filip, A. et al. (2024)" with the actual lead author
   "Baungarten-Leon, E. I. et al. (2024)". Per Semantic Scholar API
   query of DOI 10.1109/LES.2023.3267341, the full author list is
   Baungarten-Leon, Ortega-Cisneros, Jaramillo-Toral,
   Rodriguez-Navarrete, Pizano-Escalante, Raygoza-Panduro. There is
   no "Filip" on this paper. The academic-survey's `solutions.md`
   line 67 reference must be propagated through (same fix; same
   citation).

2. **Academic-survey `references.md` Acad-3 (OpenROAD DAC 2019 author list):**
   the current cited list has 31 names of which fifteen
   (Blaauw, Chan, Cheng, Choo, Coltella, Dreslinski, Ibrahim, Li,
   Liang, Penzes, Rovinski, Samadi, Saul, Srinivas, Sylvester,
   Urquhart) are not on the published paper, and drops five that
   are (Hosny, Neseem, Saligane, Shalan, Zhehong Wang). The
   author list traceability footnote ("quoted above is from
   Acad-1's reference list — independently reproducible") is
   defective. Replace with the Semantic Scholar / DAC proceedings
   author list:
   "Ajayi, T., Chhabria, V. A., Fogaça, M., Hashemi, S., Hosny,
   A., Kahng, A. B., Kim, M., Lee, J., Mallappa, U., Neseem, M.,
   Pradipta, G., Reda, S., Saligane, M., Sapatnekar, S.,
   Sechen, C., Shalan, M., Swartz, W., Wang, L., Wang, Z.,
   Woo, M., Xu, B."

3. **Academic-survey `report.md` §1 ¶3 wording.** "The most directly
   applicable academic position located is from Ghazy & Shalan 2020
   (WOSET), which … endorses option G1 / B1 (shrink-and-re-harden)
   on academic grounds." This is borderline picking-a-winner
   language for a Stage-1 report. Recommend rewording to "Ghazy &
   Shalan 2020 (WOSET) speaks to the cost / mechanism of re-
   hardening but does not opine on the cleanup-vs-leave call,
   which Stage 2 must resolve."

4. **First-principles `references.md` ref [2] (LEF/DEF Language
   Reference):** marked "NOT independently fetched in this Stage-1
   pass." Honest, but downstream Stage-2 review should cache it
   (the document is open-redistribution per the report's own note)
   and verify SHA-256. Not blocking for this Stage-1 sign-off but
   should be tracked in the corrections sweep.

5. **Academic-survey `references.md` Acad-5 (Venn TT SSC-M):**
   the report concedes the paper text was not read (IEEE Xplore /
   TechRxiv blocks). The cited author "Matthew David Venn" was
   not independently verified in this review pass either (Semantic
   Scholar API throttled at 429 during my checks). Stage 2 should
   re-verify the author attribution, at minimum via SSCS Magazine
   table-of-contents page or the IEEE Xplore document landing
   page metadata (which is reachable as a non-PDF URL even when
   PDFs 418).

6. **First-principles `report.md` §3 G2 description.** "Wrapper
   continues to *misrepresent* its surface area, contradicting
   'cleanup.'" This is a value judgement not a Stage-1 finding;
   recommend rewording to "Wrapper exposes 7 bits while the
   functional surface is 5; whether this matters depends on
   downstream consumers (Stage-2 call)." Same effect, less
   editorial.

None of these revisions change the technical conclusions. The
underlying engineering verdict (G1 = wrapper-shrink-with-re-harden
is the most direct fit; G2 = do-nothing is the cheapest; G8 =
internal-const-tieoff is the only option that satisfies neither
"honest interface" nor allows zero-churn re-harden, which is why
all three angles list it as a leaf) is robust.

## Closing notes

**Did the simplest-item-in-programme assumption hold?** Mostly,
yes. The first-principles and industry-survey reports are crisp
and short (12 KB and 11 KB respectively); the academic-survey
report is somewhat longer (15 KB) because the agent reasonably
spent effort documenting the literature gap rather than inventing
references — that is exactly what the per-item README invited.
Total Stage-1 footprint is ~50 KB across the three angles, vs.
roughly 200-400 KB for the analog-heavy items in the programme.
The cleanup verdict (G1 + re-harden) is well-supported and the
re-harden-mandatory-for-port-width-change conclusion is robust.

**The unexpected complexity** in (g) is not technical but
methodological: the academic-survey is the only Stage-1 angle
where I found defects in this review pass, and the defects fit
the programme-wide pattern (citation-author errors in 11/11
reviewed items now). The cached PDF for Acad-1 is genuinely
useful — it directly verifies the most load-bearing quote in
the academic-survey ("well-invested one-time effort") — and its
existence on disk is a model for how the programme should treat
its downloadable references. The non-cached references (Acad-2,
Acad-3, Acad-4) are exactly where the author-attribution errors
crept in.

**For Stage 2:** the option-comparison table can ingest the
union of G1-G9 / A1-D1 / A-Acad-* / B-Acad-* / C-Acad-* /
D-Acad-* without renaming, since the three angles use disjoint
short-name namespaces (`G*`, `A*-D*`, `*-Acad-*`). This is
better than the (a)-style topology-ID collision pattern flagged
in CORRECTIONS.md.

**For the orchestrator** (commit step): once the academic-survey
fixes are in, the verdict can be upgraded to signed-off without
a full re-review — the first-principles and industry-survey
reports are already at signed-off quality.

---

Reviewer: claude-opus-4-7-1m, Stage-1 reviewer-1, item (g),
2026-05-04. Final reviewer in the 11/11 Stage-1 review wave.
