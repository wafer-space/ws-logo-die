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
| (f) | `stage1-first-principles/report.md` | line 352 T4 bucket cap | ✓ corrected (this commit) |
| (b) | `stage1-first-principles/components.md` | line 19, 97, 101 | ✓ verified correct (no fix) |
| (b) | `stage1-first-principles/report.md` | §5 (~57k µm² tuning cap, ~4 mm² storage) | ✓ verified correct |
| (b) | `stage1-industry-survey/report.md` | line 564, 858 | ⚠ minor 2× discrepancy on 12 nF claim (4 mm² vs 8 mm²); pending |
| (d) | `stage1-academic-survey/components.md` | line 132 | pending audit |
| (h) | various | pending audit |
| (i) | various | pending audit |
| (j) | various | pending audit |

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
