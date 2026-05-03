---
report_under_review: docs/research/e-mim-cap-storage/stage1-{first-principles,industry-survey,academic-survey}
reviewer: reviewer-1 (claude-opus-4-7-1m)
date: 2026-05-04
verdict: revisions-requested
---

## Verdict

**revisions-requested.**

The orchestrator's headline corrections (commits f54e478, 18505ee,
cadb970) on the (e) FP §5.3 and solutions.md per-consumer table are
**arithmetically sound**: I re-derived every line from C = I·dt/dV
and A = C/d, and every corrected value (4.9 / 49 / 250 / 250 000 /
500 / 600 mm²) is exact at the stated densities. The 1000× factor
that the (a)/(k) reviewer caught is fully neutralised in the per-
consumer table, the leakage-vs-bank-size mapping, and the solutions
catalogue.

However, the corrections sweep **missed three further arithmetic /
factual defects** that survived in the same family of files, plus
the academic-survey added two new citation-attribution errors that
were not caught by the original reviewer-1 sweep:

1. **F8 hybrid HV-dump in `stage1-industry-survey/solutions.md`
   §"Family 8 — Hybrid HV-dump architecture"** still contains the
   1000×-too-large absolute energy claim ("1 nF / 1000 µm² MIM_1f0
   at 20 V stores 200 nJ"). 1000 µm² × 1 fF/µm² = 1 pF (not 1 nF);
   1 pF at 20 V stores 0.2 nJ (not 200 nJ). The 4.6×
   *ratio* between the two MIM flavours is independently correct
   (verified below), so the headline survives, but the absolute
   numbers used to motivate it are off by a factor of 1000. This
   is the *same* arithmetic confusion the orchestrator's correction
   sweep was supposed to eliminate, just in a sister file that was
   not on the §5.3 / solutions.md hit-list.
2. **The G2 anchor for "no-bulk-storage implant" in academic §3 /
   §7 NA-1 is factually wrong**: the arXiv 2112.15552 abstract
   explicitly says "each implant integrates a 0.8-mm² chip, a
   6-mm² ME film, **and an energy storage capacitor**". The
   academic survey's claim that Yang JSSC 2022 demonstrates "no
   bulk storage; brown-out gate on rectified current" cannot be
   reconciled with the abstract's plain language. Since this is
   one of three anchors the academic survey uses to declare
   negative result NA-1 ("Pure on-die µF storage at 180 nm is NOT
   practiced in any peer-reviewed silicon paper"), the
   anchor-check must be redone.
3. **Two citation-author errors in the academic-survey that were
   not in the original reviewer-1 list**: G1 ("Liu *et al.*",
   *Sensors* 18:1452) is actually Bhattacharyya, Grünwald, Jansen,
   Reindl et al. — there is no Liu in the author list. G3 ("Khan
   et al.", arXiv 2602.02376) is actually Zou, Liao, Wang, Kim,
   Su, Robinson, Yang — first author is Zou, not Khan. Both
   citation errors propagated from the industry-survey, where Liu
   2018 is also misattributed.

Beyond those three, two minor presentation defects:

- FP §5.3 NFC-sub-carrier C_min derivation labels itself
  "1-cycle" but the arithmetic only matches a half-cycle
  (5 mA × 0.59 µs / 0.3 V = 9.83 nF). A "1-cycle" label
  produces 19.7 nF / 9.85 mm². Either the label or the
  number must change.
- Academic §5.4 Frenkel-Poole headline "4–50× *lower* leakage at
  1 V than at 6 V" overstates the upper bound for the stated
  β = 1–2 range. β = 1 gives 4.3×; β = 2 gives 18.2×; the 50×
  end of the range requires β ≈ 2.7. Either tighten the range to
  "4–18×" or widen the β range and cite a source.

Each of those is a minor revisions-requested item. None individually
warrant a "fail", and the breadth-of-coverage and physics-of-storage
sections are otherwise solid.

## Findings

### Reference verification (REQUIRED)

Spot-checks via WebFetch — IEEE Xplore deliberately skipped per
instructions; MDPI direct URLs uniformly returned 403.

| Citation | URL/DOI resolved? | Document matches citation? | Local cache present? | Local cache matches upstream? |
|---|---|---|---|---|
| GF180 PDK MIM-2.0 CSV (REF-4 / FP) | yes (raw.githubusercontent.com) | **yes** — confirms 2 fF/µm² (1.8–2.2), 6.6 V Vop | N/A (raw GitHub) | N/A |
| GF180 PDK MIM-1.0 CSV (REF-4 / FP) | yes | **yes** — confirms 1 fF/µm² (0.9–1.1), 20 V Vop | N/A | N/A |
| GF180 PDK MIM-1.5 CSV (REF-4 / FP) | yes | **yes** — confirms 1.5 fF/µm², 10 V Vop | N/A | N/A |
| `gf180mcu-pdk.readthedocs.io` landing | yes | partial — landing page, no MIM detail visible (work-in-progress note) | N/A | N/A |
| Yang/arXiv 2112.15552 (G2 / academic) | yes (arxiv.org/abs/2112.15552) | **NO — see RC-1 below** | N/A | N/A |
| Zou/arXiv 2602.02376 ("Khan", G3 / academic) | yes | **partial — NO on author attribution; YES on title; see RC-2** | N/A | N/A |
| Liu/Bhattacharyya Sensors 18:1452 (G1 / industry + academic) | indirect (MDPI returned 403; Google Scholar surface confirmed) | **NO on author attribution; pending on 10 µF claim — see RC-3** | N/A | N/A |
| MDPI Sensors 2018 v18 i5 paper-1452 directly | 403 (MDPI blocks WebFetch) | could not verify body text | N/A | N/A |
| Bang JSSC 2016 (E3 / academic, faculty PDF) | yes (URL resolves) | partial — PDF binary stream, text not extractable; URL valid | N/A | N/A |
| Springer Open Discover Nano 2019 ALD MIM (B2 / academic) | redirect chain to brand page; could not resolve full text | could not verify | N/A | N/A |

#### RC-1 — Yang JSSC 2022 / arXiv 2112.15552 negative-result anchor mismatch

Academic-survey §3 family G2: *"Yang et al. JSSC 2022 magnetoelectric
bio-implant. Coordinated multi-site stimulation. **No bulk storage;
brown-out gate on rectified current.** arXiv 2112.15552 + PMC9581110."*

The arXiv 2112.15552 abstract (verified 2026-05-04): *"each implant
integrates a 0.8-mm² chip, a 6-mm² ME film, **and an energy storage
capacitor**."* This explicitly contradicts "no bulk storage". The
implant has *both* an ME film *and* a discrete storage capacitor.

The academic survey then cites this as one of three anchors for its
flagship negative result NA-1 ("Pure on-die µF storage at 180 nm is
NOT practiced in any peer-reviewed silicon paper"). The anchor as
written misrepresents the source. Either:

- the survey author conflated Yang 2022 with a different
  no-bulk-storage paper (G3 Khan / Zou is more plausibly that
  paper), or
- "no *on-die* bulk storage" was meant rather than "no bulk
  storage" — but in that case the storage cap is *external* and
  the citation reinforces NA-1 by the same logic as G1, not by
  "brown-out gate on rectified current".

Either way the §3 G2 entry, §7 NA-1, and components.md AS-11 all
need to be reworded against the actual paper. The substance of NA-1
likely survives (ME-implant work overwhelmingly uses external caps),
but the prose claim "no bulk storage" is unsupported by the cited
source.

#### RC-2 — Khan / Zou citation author error (academic G3)

Academic-survey references.md G3: *"Khan et al. arXiv 2602.02376
mm-implant PMU."*

arXiv 2602.02376 verified 2026-05-04: title "An Efficient Power
Management Unit With Continuous MPPT and Energy Recycling for
Wireless Millimetric Biomedical Implants"; authors **Yiwei Zou,
Huan-Cheng Liao, Wei Wang, Wonjune Kim, Yumin Su, Jacob T. Robinson,
Kaiyuan Yang**. First author is Zou, not Khan. Replace all "Khan"
references with "Zou et al." in references.md and report.md.

#### RC-3 — Bhattacharyya / "Liu" 2018 citation author error (industry G1 + academic G1)

Industry-survey references.md LIU-2018 and academic-survey references.md
G1 both attribute *Sensors* 18(5):1452 to "Liu *et al.*". Per
Google Scholar (scholar.google.com search verified 2026-05-04), the
actual author list is **Bhattacharyya, Grünwald, Jansen, Reindl** et
al. — no author named Liu. The title and venue are otherwise correct.

The "external 10 µF" claim could not be verified directly (MDPI 403
on WebFetch). The industry-survey cites it through the chain:
Sensors 2018 → "Cst = 10 µF (external) + 5 pF on-die". Without
fulltext I cannot confirm the 10 µF and 5 pF figures, but the
**citation tag itself is wrong** — the right authors are Bhattacharyya
et al., and downstream sister-reports inherit the misattribution
unless fixed at the source.

Both errors are exactly the same kind that the (a) reviewer caught
in AC-RC-2 (Hsiao → Mirchandani/Shrivastava) and AC-SUB-1 (CERO
not DLS): a paper looked up by title-search and tagged with a
guessed first author.

### Solution-space coverage

#### Coverage summary

- FP catalogues 8 strategies (S1–S8). Spectrum: simplest
  (S1 single big bank) to most sophisticated (S8 zero-leak
  hot-swap). Pass.
- Industry catalogues 10 family entries (F1–F10). Spectrum:
  free fillcap (F4) to F8 hybrid HV-dump and F9/F10 not-in-PDK.
  Pass.
- Academic catalogues 14 strategies across families A–G
  (AS-1–AS-14). Spectrum from textbook MOS-cap to active MPPT
  replenisher. Pass.

All three exceed the 5-strategy floor. No "topology-ID
collision" pattern from item (a) — the three (e) angles use
distinct prefixes (S*, F*, AS-*). I confirm zero ID-collisions
between the three reports.

#### Coverage gaps cross-checked between sister angles

Approach in one angle but missing from sister:

- **Pelliconi cross-coupled doubler** (academic E1 / AS-5):
  industry generically lists "Dickson / Pelliconi" as F5 but
  has no Pelliconi-specific architecture detail; FP §3 lumps
  this under generic "S3 SC charge pump". The academic survey
  is the only one with a per-rail Pelliconi-vs-bulk-MIM
  recommendation table. **Not a defect** but Stage-2 must use
  the academic-side detail.
- **Hashimoto leakage-cancellation feedback (F1 / AS-10)** —
  cited only by academic. FP S8 says "exp-suppressed leakage"
  via terminal isolation; AS-10 offers active feedback as a
  *complement* to S8/F2. Stage-2 must merge both.
- **Multi-port ZCS bank-switching (F2 / AS-9, MDPI Energies
  2018)** — cited only by academic. Direct backing for FP
  S8; FP cites no academic anchor. Author's note in academic
  flags this as a "missed by sisters" finding — accurate.
- **Output-cap-less LDO (AS-12, Sensors 2024)** — cited only
  by academic.
- **MPPT continuous replenisher (AS-13, Khan/Zou 2026)** —
  cited only by academic.
- **MIM-1.0 + 20 V boost (FP S5 / industry F8 hybrid)** —
  cited only by FP and industry, not by academic. The academic
  survey misses what its own §5.5 efficiency analysis would
  motivate.
- **Capacitor multiplier (industry F6)** — listed as "useless
  for energy storage" in industry-survey. Neither sister
  catalogues it.

Aggregate: each angle catalogues approaches the others miss.
Stage-2 has a real merge to do, which is the **opposite** of
"suspicious convergence". See "Convergence" below.

#### README scope items: explicitly checked

The per-item README §"Scope of research" lists 7 items. Each
of the three reports addresses each item:

| README scope item | FP | IS | AC |
|---|---|---|---|
| 1. Capacitor families in `gf180mcuD` | ✓ §3 + §10 table | ✓ §3 (F1–F10) + family-1/2/4 detail | ✓ §3 families A–G |
| 2. Density / area cost | ✓ §1 table + §5.2 | ✓ §3 area/cost column | ✓ §3 + §9 area-power |
| 3. Energy budget vs cap size | ✓ §5.3 per-consumer | partial (delegates to FP §5) | partial (§5.2 Pelliconi) |
| 4. Floorplan strategy under logo | ✓ §5.5 + §10 (5.05 mm² inter-logo void) | ✓ open-question Q-1 | not addressed (academic-side limit) |
| 5. Density-rule interaction (Metal2_ignore_active) | ✓ §5.5 explicit | ✓ §10 author's note | not addressed |
| 6. Switched-cap / charge-pump alternatives | ✓ S3, S5 | ✓ F5, F7, F8 | ✓ AS-5, AS-6, AS-7, AS-8 |
| 7. Physics sanity check | ✓ §5.1 EOT | partial (cross-refs FP) | ✓ §5.1 + §5.4 + §5.5 |

Only "energy-budget vs cap size" (item 3) is well-covered in
FP (§5.3) and merely sketched in IS / AC. That's the right
division of labour given the FP angle's mandate, but Stage-2
should ensure no consumer slips through the cracks.

### Premature narrowing

- FP report length distribution: each strategy S1–S8 gets one
  paragraph in §3 + one row in §9. §5.3 dominates length but
  it is per-consumer, not per-strategy. **Pass.**
- IS report: §10 author's notes flag F1 / F2 / F4 as the
  default and F8 as an architectural surprise. Body §3 / §9
  table treats all 10 families evenly. **Pass.**
- AC report: §1 explicitly states "without picking a winner".
  §3 A–G families balanced. §10 frames the survey as
  "negative result first" (no on-die µF) and Pelliconi as a
  "structural answer" — the closest thing to opinion in any
  Stage-1 angle here, but it falls just short of "best
  approach" because the structural answer comes with NA-2
  ("Pelliconi & Hong cross-coupled CPs collapse below ~1 V
  V_in"). **Pass — borderline.**

No structural narrowing defect.

### Numerical-claim verification

Three+ recalculations from first principles. All math shown.

#### NV-1 — FP §5.3 per-consumer table (the corrected one)

Identity: at density d (fF/µm²), area for capacitance C is
A_mm² = C_nF / d.

| Consumer | C target | d=2.0 area | Reported | Verdict |
|---|---|---|---|---|
| NFC sub-carrier 1-cycle | 9.8 nF | 4.9 mm² | 4.9 mm² | ✓ |
| NFC sub-carrier 10-cycle | 98 nF | 49 mm² | 49 mm² | ✓ |
| LED twinkle 100 µs | 500 nF | 250 mm² | 250 mm² | ✓ |
| LED long-pulse 100 ms | 500 µF | 250 000 mm² | 250 000 mm² | ✓ |
| eFuse 100 mA × 10 µs | 1.0 µF | 500 mm² | 500 mm² | ✓ |
| BLE TX 10 mW × 200 µs | 1.2 µF | 600 mm² | 600 mm² | ✓ |

I also re-derived each C target from I·dt/dV:

- LED twinkle: 5 mA × 100 µs / 1 V = 500 nF ✓
- LED long-pulse: 5 mA × 100 ms / 1 V = 500 µF ✓
- eFuse: 100 mA × 10 µs / 1 V = 1.0 µF ✓
- BLE: (10 mW / 3.3 V) × 200 µs / 0.5 V = 1.212 µF ≈ 1.2 µF ✓
- NFC sub-carrier 1-cycle (T = 1/847.5 kHz = 1.18 µs):
  5 mA × 1.18 µs / 0.3 V = 19.67 nF — **but the report claims
  9.83 nF, which is the half-cycle value**. Either the label
  ("1-cycle") or the number is wrong. Half-cycle math: 5 mA ×
  590 ns / 0.3 V = 9.83 nF ✓. The corrected entry should
  read "NFC sub-carrier half-cycle (847.5 kHz, 5 mA, ΔV =
  0.3 V) → 9.8 nF → 4.9 mm²". This is a presentation defect,
  not a 1000× propagation defect; flagged for the next sweep.

The corrections sweep is **arithmetically sound on the µF→nF
core**. The mislabelled half-cycle entry is the lone surviving
imprecision in the FP §5.3 table.

#### NV-2 — F8 hybrid HV-dump claim (industry-survey)

Claim: "MIM_1f0 at 20 V stores 4.6× more energy/µm² than MIM_2f0
at 6.6 V" (industry §10 / §3).

Energy density U = ½ · C_area · V². With actual PDK numbers
0.987 fF/µm² @ 20 V vs 1.99 fF/µm² @ 6.6 V:

- U(MIM-1.0) = 0.5 × 0.987 × 20² = 197.4 nJ/mm²
- U(MIM-2.0) = 0.5 × 1.99 × 6.6² = 43.34 nJ/mm²
- Ratio = 197.4 / 43.34 = **4.55×** (claim "4.6×" — accurate
  to one significant figure)

The 4.6× is **correct to the precision claimed**.

But the supporting absolute numbers in industry-survey
solutions.md §"Family 8" are **wrong by 1000×**:

- Claim: "1 nF / 1000 µm² MIM_1f0 at 20 V stores 200 nJ; same
  area MIM_2f0 at 6.6 V stores ~43 nJ."
- Reality: 1000 µm² × 1.0 fF/µm² = **1 pF** (not 1 nF). 1 pF
  at 20 V stores ½ · 10⁻¹² · 400 = **0.2 nJ** (not 200 nJ).
  Same 1000 µm² at MIM-2.0 stores 2 pF; at 6.6 V that is
  **0.0436 nJ** (not 43 nJ). The 4.6× ratio survives by
  cancellation, but both absolute numbers are off by exactly
  the same 1000× the orchestrator's correction sweep was
  meant to eliminate.

The matching numbers in §"Three things others may miss" item 3
("MIM_1f0 ... stores 4.6× more energy per µm² than MIM_2f0")
are correct *if* read as a ratio per µm². The 200 nJ / 43 nJ
absolute figures are not.

**Required fix**: rewrite F8 §detail as energy-density
(nJ/mm²): "MIM_1f0 stores 197 nJ/mm² at rated 20 V vs MIM_2f0
43 nJ/mm² at rated 6.6 V — 4.6×, by V² scaling." Drop the
"1 nF / 1000 µm²" framing entirely, since 1 nF in 1000 µm² is
not achievable in any GF180 MIM.

#### NV-3 — MOS-cap-as-fillcap density discrepancy

Claim: fillcap_64 has "0.20 fF/µm² apparent density" vs
cap_nmos_06v0 peak inversion "2.18 fF/µm²".

- fillcap_64 LEF area: 35.84 × 3.92 = 140.5 µm² (matches)
- 16 transistors × W=0.82 µm × L=1 µm = 13.12 µm² of active
  gate (matches)
- 13.12 µm² × 2.18 fF/µm² = 28.60 fF (matches "~28.6 fF")
- Apparent density: 28.6 fF / 140.5 µm² = **0.2036 fF/µm²**
  (matches "0.20")

Discrepancy is **fully explained** by denominator choice:
0.20 fF/µm² is referenced to the LEF-cell footprint (active
gate is ~9.3 % of cell area); 2.18 fF/µm² is referenced to the
gate active area. Both correct, no contradiction. **Pass.**

#### NV-4 — Leakage-vs-bank-size table (FP §5.4)

At 1 pA/µm² and density 2 fF/µm², a bank of capacitance C in
mm² is:

P_leak(C, V) = (C / d) × 1e6 µm²/mm² × 1 pA/µm² × V

| Bank | Area (1/d × C) | I_leak | P_leak @ 6.6 V |
|---|---|---|---|
| 1 nF | 0.5 mm² | 0.5 µA | 3.3 µW (matches 3.3) |
| 10 nF | 5 mm² | 5 µA | 33 µW (matches 33) |
| 100 nF | 50 mm² | 50 µA | 330 µW (matches 330) |

**Pass.** The §5.4 numbers are internally consistent and
match my recalculation.

#### NV-5 — Frenkel-Poole de-rating (academic §5.4)

Claim: "ratio = exp(β·(√6 − √1)). For typical β = 1–2 V^−0.5,
this gives a 4–50× lower leakage at 1 V vs 6 V."

- √6 − √1 = 2.449 − 1.000 = 1.449
- β = 1 → exp(1.449) = **4.26×**
- β = 2 → exp(2.898) = **18.16×**
- 50× requires β ≈ 2.7 — *outside* the cited "typical 1–2"
  range.

So the *low* end of the claim ("4×") is correct; the *high*
end ("50×") overstates by ~3× (not 1000×, just a tightness
issue). Either:

- correct the range to "4–18× at typical β = 1–2", or
- if the survey author intended β up to ~2.7, cite a source
  that supports that β range.

This is a soft-spec issue that materially affects whether the
ambient-RF verdict "softens" (academic claim) by 5–20× in
practice.

#### NV-6 — EOT / E-field check (FP §5.1)

C_area = ε₀ε_r/d. For C_area = 2 mF/m²:

- SiO₂ (ε_r = 3.9): d = 8.854e-12 × 3.9 / 2e-3 = 17.27 nm
  (matches "17.3 nm")
- Si₃N₄ (ε_r = 7): d = 30.99 nm (matches "31 nm")
- E-field at 6.6 V: SiO₂ 3.82 MV/cm ✓; Si₃N₄ 2.13 MV/cm ✓.

**Pass.** Academic §5.1 (Gambino EOT) similarly verifies:
EOT = 4.87 nm, C_area = 7.09 fF/µm²; PDK 2.0 fF/µm² is
conservative. The Gambino paper itself is paywalled (IRPS
2019) and abstract-only verified, but the physics is
self-consistent.

#### NV-7 — Pelliconi continuous-power claim (academic §5.2)

P = C·f·V² with C = 10 pF, f = 100 MHz, V = 5 V:
10e-12 × 1e8 × 25 = **25 mW** ✓.
At 70 % efficiency → 17.5 mW per 10 pF flying cap.
10 pF / 2 fF/µm² = 5000 µm² ✓. Numbers self-consistent.

### Negative results

All three reports have substantive negative-result sections.
- FP §7: 7 numbered negatives (N-1..N-7), each with concrete
  detail.
- IS §7: 9 numbered negatives (N1..N9). N6 is the "Liu 2018
  external 10 µF" anchor — citation-author wrong (RC-3) but
  the *finding* (external cap) is the consensus view in the
  literature.
- AC §7: 6 numbered negatives (NA-1..NA-6). NA-1 anchor on G2
  is wrong (RC-1). NA-3 ("bank-switch off-leakage may dominate
  at fine granularity") is a real and useful counter to the
  S8 / AS-9 enthusiasm.

### Convergence with parallel reports

I compared the three (e) angles' solution-space maps approach
by approach:

- FP S1–S8 ↔ IS F1–F10 ↔ AC AS-1..AS-14: only one
  topology-ID collides? **Zero.** The three angles use
  disjoint prefixes (S, F, AS-) and disjoint family-letters.
- Coverage overlap: Native MIM, MOS-cap, Pelliconi/Dickson,
  multi-bank/hot-swap, MoM, deep-trench-not-in-PDK, and
  ferroelectric-not-in-PDK appear in all three. Strategy-
  level overlap is roughly 50 % — each angle catalogues ~5
  approaches the others miss.
- Reference overlap: Liu/Bhattacharyya 2018 cited by both IS
  and AC; Gambino 2019 cited by both IS and AC (with FP only
  citing the PDK SPICE deck). Otherwise the reference lists
  diverge sharply: FP cites only PDK files; IS adds NTAG /
  Tower / sky130 / Dickson MDPI / GAMBINO; AC adds 17 mostly-
  academic anchors. **Reference overlap is about 15 %.**
- The three reports cite each other ("see sister §2 / §5"),
  which is acceptable cross-coordination, not laziness.

**Verdict: NO suspicious convergence.** This is the opposite
of (a)/(b)/(k). Stage-2 has a genuine merge to do — there is
no way to call any of the three angles "shallow re-use of a
sister".

### Specific revisions requested

Numbered list of concrete required changes for the three
reports:

1. **(IS solutions.md §"Family 8 — Hybrid HV-dump architecture")**
   Replace "1 nF / 1000 µm² MIM_1f0 at 20 V stores 200 nJ;
   same area MIM_2f0 at 6.6 V stores ~43 nJ" with
   energy-density framing: "MIM_1f0 stores ~197 nJ/mm² at
   rated 20 V vs MIM_2f0 ~43 nJ/mm² at rated 6.6 V — a 4.6×
   advantage by V² scaling, since the V² gain (9.18×) more
   than compensates for the 2× density loss." Drop the
   physically-impossible "1 nF / 1000 µm²" cell.

2. **(FP report.md §5.3)** Relabel the NFC sub-carrier line
   from "1-cycle (847.5 kHz, 5 mA, ΔV = 0.3 V)" to
   "half-cycle" — current arithmetic only works for the half-
   cycle. Or, if "1-cycle" was intended, double C_min to
   19.7 nF and area to 9.85 mm² (still infeasible at 6.6 V —
   verdict survives).

3. **(AC report.md §3 G2 + §7 NA-1 + components.md AS-11)**
   Reword to align with arXiv 2112.15552 actual abstract: the
   Yang/Yu 2022 implant *does* integrate a storage capacitor.
   Either (a) re-classify as "external storage cap, no on-die
   bulk" in line with G1, or (b) replace the anchor with a
   different paper that genuinely demonstrates "no bulk cap,
   brown-out only" at 180 nm. NA-1's substance probably
   survives via G1 + G3 alone.

4. **(IS references.md LIU-2018 + AC references.md G1 +
   wherever cited)** Replace "Liu *et al.*" with
   "Bhattacharyya, Grünwald, Jansen, Reindl et al." in
   *Sensors* 18(5):1452 attribution. The paper's title and
   the "external 10 µF" relevance survive (subject to direct
   verification in a re-fetch attempt, since MDPI returned
   403 to my WebFetch).

5. **(AC references.md G3)** Replace "Khan et al." attribution
   for arXiv 2602.02376 with "Zou et al." Verified 2026-05-04
   directly on arXiv.

6. **(AC §5.4)** Tighten the Frenkel-Poole de-rating claim
   from "4–50×" to "4–18× for typical β = 1–2" — or cite a
   source that supports β up to 2.7 if the wider claim is
   intended.

7. **(AC §5 + components.md AS-7 / AS-8)** Add a row to
   §"Strategy-to-rail recommendations" for the F8 / S5
   HV-pumped MIM-1.0 strategy, which currently appears only
   in FP and IS. The academic survey's Pelliconi-vs-Dickson
   physics is exactly the lens needed to evaluate the
   feasibility of S5/F8.

Items 1, 2, 3, 4, 5, 6 are factual / arithmetic. Item 7 is
coverage. Stage-2 cannot ingest this trio cleanly until items
1–5 are fixed; item 6 is presentation; item 7 widens the
synthesis surface.

## Closing notes

The orchestrator's correction sweep (commits f54e478 / 18505ee
/ cadb970) is **arithmetically sound on the in-scope sites**
the (a)/(k) reviewer flagged: every entry in the corrected
(e) FP §5.3 and (e) FP solutions.md per-consumer table
re-derives correctly from C = I·dt/dV and A = C/d. The 1000×
sweep was rigorous in the headline tables.

What the sweep missed:

- The same 1000× confusion survived into the **industry-
  survey** F8 hybrid HV-dump architecture detail, in a sister
  file (solutions.md) that was not on the patch list. The
  4.6× ratio is correct, but the absolute numbers around it
  are not. This is exactly the kind of cross-file propagation
  the corrections sweep aims to eradicate; one more pass
  through every file that mentions any of "1 nF", "10 nF",
  "100 nF", "1 µF", or "10 µF" against an area would close it.
- Two new citation-author errors slipped in via the academic
  survey (Liu→Bhattacharyya, Khan→Zou), of the same kind the
  (a) reviewer caught (Hsiao→Mirchandani, DLS→CERO). Future
  reviewer sweeps should add author-attribution as a
  reflexive check on every external citation.
- One factual mismatch between an academic-survey negative-
  result anchor (G2 / Yang 2022) and the actual arXiv
  abstract — the abstract explicitly mentions a storage cap,
  the survey says "no bulk storage". This may cascade into
  the Stage-2 NA-1 anchor strength.

None of these defects flips a qualitative verdict in the
report. NA-1 (no-on-die-µF-storage at 180 nm) almost certainly
survives via G1 alone; the F8 ratio survives despite its
absolute-number error; the FP §5.3 table is now sound on the
1000× axis. But Stage-2 should not build on these three
reports until items 1–5 above are applied.

Topology-ID-collision pattern from item (a): **NOT present in
(e).** All three angles use disjoint prefixes (S*, F*, AS-*).
This is a structural improvement the (a) reviewer's
recommendations clearly informed.

Suspicious-convergence pattern from item (b): **NOT present in
(e).** Each angle catalogues ~5 approaches the others miss;
reference-list overlap is ~15 %; cross-citation between
sisters is explicit ("see sister §X") rather than uncited
parallel content.

The three (e) Stage-1 reports are, on net, the strongest
parallel-angle work I have reviewed in this programme. With
items 1–7 above applied, they pass.
