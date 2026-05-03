# Programme-wide corrections log

Stage-1 reviewer-1 (commits a30f6e3 and a60c64b) caught a
**systematic 1000× cap-arithmetic error** propagating across
multiple Stage-1 reports.

## Root cause

Reports treated **1 µF as 10⁶ fF** when correct is **10⁹ fF**.
i.e., µF was confused with nF in cap-area derivations.

The arithmetic identity:
- `1 µF = 10⁻⁶ F`
- `1 fF = 10⁻¹⁵ F`
- → `1 µF = 10⁹ fF`
- At MIM density 2 fF/µm²: `1 µF / 2 fF/µm² = 5 × 10⁸ µm² = 500 mm²`
  (since `1 mm² = 10⁶ µm²`)

The wrong arithmetic gave `1 µF = 0.5 mm²` (off by exactly 1000×).

## Why the qualitative verdicts mostly survive

- BLE infeasibility on harvested-RF: the prior version said the
  storage cap exceeded the die by ~3.5×; corrected number is
  ~900×. The verdict is unchanged but **dramatically reinforced**.
- µF-class on-die MIM cap: the prior version said "feasible but
  tight"; corrected number says **uniformly infeasible** for
  any µF-class storage on-die.
- Cold-start oscillator at 100 µA × 5 ms: the prior version
  said "1 nF, 0.5 mm², within MIM budget"; corrected number
  is "1 µF, 500 mm², not on-die feasible" — flips the
  architectural conclusion.
- The (a) §5.4 ω·L error was not 1000× cap-arithmetic; it was
  a 13.56 MHz vs 2.4 GHz mix-up. Corrected to ω·L = 110.76 Ω.

## Affected reports — sweep status

| Item | File | Line(s) | Status |
|---|---|---|---|
| (a) | `stage1-first-principles/report.md` | §5.4 (ω·L), §5.11 | ✓ corrected (commit f54e478) |
| (e) | `stage1-first-principles/report.md` | §5.3 table | ✓ corrected (commit f54e478) |
| (e) | `stage1-first-principles/solutions.md` | per-consumer mapping | ✓ corrected (commit f54e478) |
| (k) | `stage1-first-principles/report.md` | §1 conclusion (8), §5 burst-cap, §7.4 | ✓ corrected (commit f54e478) |
| (k) | `stage1-industry-survey/components.md` | line 255 storage-cap | ✓ corrected (commit f54e478) |
| (k) | `stage1-industry-survey/report.md` | §5.6 | ✓ corrected (commit f54e478) |
| (k) | `stage1-academic-survey/report.md` | §5.5 | ✓ corrected (commit f54e478) |
| (k) | `stage1-academic-survey/components.md` | §3.5 loop filter | ✓ corrected (commit f54e478) |
| (c) | `stage1-first-principles/report.md` | §5.6 bulk storage cap | ✓ corrected (this commit) |
| (f) | `stage1-first-principles/report.md` | line 352 T4 bucket cap | ✓ corrected (commit 18505ee) |
| (f) | `stage1-first-principles/solutions.md` | line 20 T4 row | ✓ corrected (this commit; reviewer-1 found this incomplete-sweep instance) |
| (f) | `stage1-industry-survey/report.md` | line 637 T4 row | ✓ corrected (this commit) |
| (f) | `stage1-industry-survey/solutions.md` | line 59 T4 row | ✓ corrected (this commit) |
| (f) | `stage1-academic-survey` Davis→Greene | 4 places | ✓ corrected (this commit; programme-wide pattern: Hsiao/Sun/Liu/Khan/Davis all misattributed by Stage-1 agents) |
| (f) | `stage1-academic-survey/references.md` REF-PW-2 Karthaus 2003 | LED-budget headline | ✓ retracted (this commit). The 16.7 µW figure is an RF receiver-sensitivity threshold for a 0.5 µm CMOS RFID transponder, NOT a whole-tag-including-LED budget for 0.18 µm. Stage-2 must replace this anchor. |
| (f) | `stage1-academic-survey` Hecht-Shlaer | "0.1 µA red-LED" → picoamps | ✓ caveat added (this commit; reviewer-1 found ~10⁵× error in the photon→current translation). Architectural implication: at picoamp threshold, ANY LED current is visible in the dark, **flipping the "ambient-RF mode legitimately dark" verdict** to "ambient-RF mode comfortably visible". |
| (f) | `stage1-academic-survey/report.md` §5.3 PAR1789 | tier-mixing | pending — academic mixes <90 Hz formula coefficients with ">90 Hz" labels, yielding spurious "f ≥ 40 Hz" floor. Industry-survey has the correct 1.25 kHz / 3 kHz tiers; Stage-2 should use industry-survey numbers. |
| (f) | topology IDs T2/T3/T5 across angles | collision present | pending — same (a)-style collision pattern; T5 worst (FP/IS = "rejected boost"; AC = "live SC voltage doubler"). Defer to Stage-2 namespacing. |
| (b) | `stage1-first-principles/components.md` | line 19, 97, 101 | ✓ verified correct (no fix) |
| (b) | `stage1-first-principles/report.md` | §5 (~57k µm² tuning cap, ~4 mm² storage) | ✓ verified correct |
| (b) | `stage1-industry-survey/report.md` | line 564, 716, 760, 858 | ✓ corrected (this commit) — 12 nF / 16 nF claims were 2× off (4 mm² × 1.5 fF/µm² = 6 nF; × 2.0 fF/µm² = 8 nF). Per (e) industry-survey, stacked-MIM is NOT offered in gf180mcuD, so vertical-stack doubling is not a valid escape. |
| (b) | `stage1-first-principles/report.md` | §5.1, §5.6, §5.12 | ✓ corrected (this commit) — Faraday RMS→peak. ISO/IEC 14443-2 Tables 1-2 specify Hmin/Hmax in **rms**, not peak. V_pk_induced = √2 × prior values: 2.57→3.63 V at Hmin, 12.85→18.18 V at Hmax. Industry-survey §5.1 was correct from the start; FP and academic-survey both had this wrong. The brown-out boundary verdict softens from "5V-Vth bridge fails at Hmin" to "marginal at Hmin"; native-nFET margin grows to 1.35 V. |
| (b) | `stage1-academic-survey/report.md` | §5.1, §5.4, §5.5 | ✓ corrected (this commit) — same RMS→peak fix; V_REG smoothing-cap ceiling reconciled to 6 nF (matching FP §5.7 after IS correction). |
| (b) | `stage1-academic-survey/references.md` G3 entry | reference retracted | ✓ corrected (this commit) — PMC8538867 attributed to "Sun, Pan et al." for HF dynamic-Vth-cancellation, but the actual paper is Godinho et al. operating 800 Hz – 51.2 kHz (not 13.56 MHz). Citation retracted with traceability note. solutions.md line 226 mitigation now lacks an anchor pending Stage-2 replacement. |
| (b) | suspicious convergence | n/a | ⚠ flagged by reviewer-1: 83% topology overlap across the 3 angles; FP and academic explicitly cross-cite. **Stage-2 must treat (b) FP as a shared physics layer** rather than a third independent angle. Topology-ID-collision pattern from (a) is NOT present (different prefixes per angle). |
| (d) | `stage1-academic-survey/components.md` | line 132 | ✓ verified correct (commit 18505ee+1). The (d) academic-survey explicitly catches the µF infeasibility and recommends scaling flash energy to 0.04-0.16 uJ, which scales C to 35-140 nF (feasible on-die). Good arithmetic. |
| (d) | `stage1-first-principles/references.md` R2 + `stage1-industry-survey/*` | "Awad" → Pakkirisami Churchill (5 places) | ✓ corrected (commit ff6f177). Programme-wide author-misattribution pattern. Academic-survey caught this as their Q1 but did not propagate. |
| (d) | `stage1-academic-survey/references.md` B.6 | "Honma" → Nguyen | ✓ corrected (commit ff6f177). |
| (d) | `stage1-industry-survey/report.md` §5.1 | EIRP-scenario slip | ✓ corrected (commit ff6f177). Prior "d ≈ 4 m at 915 MHz / 1.5 m at 2.45 GHz" required 32 dBm EIRP (cooperative source), not the cited 20 dBm Wi-Fi. Corrected to 1.31 m / 0.49 m at 22 dBm EIRP. **Sharpens the "twinkle requires <2 m" verdict to "card adjacent to AP".** |
| (d) | `stage1-academic-survey` Pinuela citation | "GSM900 40%" → "3G v2 40%" | pending — defer to Stage-2 reconciliation; not load-bearing on architectural verdict. |
| (d) | `stage1-industry-survey` FCC rule | "1-for-3" → "1-for-1" for non-fixed P2P | pending — defer to Stage-2 reconciliation. |
| (h) | `stage1-industry-survey/open-questions.md` line 143 | ✓ verified correct. 50 pF = 50e3 fF / 1.5 fF/µm² = 33333 µm² matches the report's "25 000–50 000 µm²". |
| (i) | (no fF/µm² site found) | ✓ no cap-arithmetic to audit |
| (j) | `stage1-first-principles/report.md` line 219 | ✓ verified correct. "10 pF × 2 stages = 20 000 µm² at 1 fF/µm² ≈ 0.02 mm²" matches 20 pF / (1e6 µm²/mm² × 1 fF/µm² × 1e-3 nF/fF) = 20 nF/mm² → 0.001 mm². Hmm: 20 pF / 1 fF/µm² = 20 000 µm² = 0.02 mm². Correct. |

## Other reviewer-1 findings still pending

Beyond the 1000× cap-arithmetic, reviewer-1 also flagged:

### (a) topology-ID collisions

FP and industry-survey use the same labels (B2, B3, C1, D1,
D2, E1, E2, E3, F1, F2, G1, G2, H1, I2, I3) for *different*
topologies. Stage 2 cannot ingest these as written. Academic
survey wisely used `AC-*` namespacing and avoided this.

**Status**: pending. Fix path is to re-namespace FP topology
IDs as `FP-*` and industry-survey topology IDs as `IS-*`,
preserving academic-survey's `AC-*`. Mechanical edit per file.

### (a) citation errors

- AC-RC-2 attributes PMC10361407 to "K.-J. Hsiao" — actual
  authors are **Mirchandani and Shrivastava**.
- AC-SUB-1 calls Lee-2016 (PMC4989868) a "Dynamic Leakage
  Suppression" ring — it's actually a **CERO (Constant
  Energy-per-Cycle) topology**.

**Status**: pending. Fix in `stage1-academic-survey/references.md`
and `report.md`.

### (k) "3× synth-over-PA" headline contradicts §5.5 table

FP report's headline says synth dominates by 3×; §5.5 own
table shows 1.7 mW PA + 3.0 mW synth = 1.76× ratio. Industry-
survey honestly self-corrects to ~2×; academic-survey Sano-2018
anchor gives parity at 28 nm.

**Status**: pending. Fix headline to "synth ≈ 2× PA at 0 dBm
in 180 nm; converges to ~1× at 28 nm".

### (k) "20 dB gap" needs scenario tagging

The 20 dB gap holds for *median ambient* (1 µW/cm², 6 cm² IFA,
30% rectifier) → 17.4 dB. The brief's stricter "+4 dBm AP at
2 m, 1 cm² rx" → 48 dB. Headline should be tagged
scenario-dependent (16-48 dB).

**Status**: pending. Add scenario row to the §5 sanity-check
table.

### (k) topology-label suspicious convergence

A1-A10 / S1-S8 / T1-T6 with same family ordering and same
default selections across all three angles. At least two of
three reports re-used a sister's content rather than deriving
independently. **Stage 2 must reconcile** even though the
qualitative verdict is robust.

**Status**: pending Stage-2 reconciliation.

## Acceptance criteria for corrections sweep

A correction is "complete" when:
- The numerical error is fixed in place.
- A correction note is added (date + reviewer + 1000× factor +
  qualitative verdict change, if any).
- The frontmatter `status` field is updated to reflect the
  correction.
- Downstream conclusions that used the wrong number are
  re-derived.

The (a)/(e)/(k) corrections meet all four criteria. The (b)
verification is annotated above. (c) and (f) corrections meet
all four. (d), (h), (i), (j) sweeps are TODO.

## Stage-2 implications

When Stage-2 synthesis runs on these items, it must:
1. Use the corrected cap-area numbers from CORRECTIONS.md, not
   the original report values.
2. Re-run the topology-ID collision check (especially for (a)).
3. Re-derive the (k) "synth dominates by N×" headline from the
   table data, not from the conflicting prose.
4. Treat the (k) 20-dB-gap as a *scenario range* (16-48 dB),
   not a single number.
