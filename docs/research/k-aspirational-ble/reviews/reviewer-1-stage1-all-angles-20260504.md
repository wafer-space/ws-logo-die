---
report_under_review: docs/research/k-aspirational-ble/stage1-{first-principles,industry-survey,academic-survey}/
reviewer: claude-opus-4-7-reviewer-1
date: 2026-05-04
verdict: revisions-requested
---

## Verdict

**revisions-requested.** All three Stage-1 reports exhibit a single
catastrophic numerical error (a 250-1000x miscalculation of MIM
storage-cap area) that propagates through all three independent
angles, plus a smaller internal inconsistency (FP report's "3x
synth-vs-PA" headline contradicts its own §5.5 table at 1.76x). The
solution-space coverage is genuinely exhaustive (38+ topologies per
report across 7 families) and the qualitative conclusions (storage
infeasible, ambient gap real, no 180 nm BLE-compliant prior art) all
survive correction. But the headline numbers must be fixed before
sign-off, and the suspicious convergence on the *same wrong cap-area
arithmetic* across three "independent" angles strongly suggests at
least two of the three researchers re-used a sister report's bad
number rather than recalculating from scratch.

## Findings

### Reference verification

Spot-checks performed via WebFetch on 2026-05-04 (IEEE Xplore deliberately
skipped per brief):

| Citation | URL/DOI resolved? | Document matches citation? | Local cache present? | Local cache matches upstream? |
|---|---|---|---|---|
| A1 / R-Paidimarri (MIT DSpace 1721.1/95676) | yes | partially — title is "+10 dBm 2.4 GHz Transmitter with sub-400 pW Leakage and 43.7 % System Efficiency" (ISSCC 2015, not JSSC 2016 as the academic survey states; JSSC paper is the extended version) | no | N/A |
| R8 / C8-Atmosic ATM33 product page | yes | yes — "0.7 mA radio receiver and 2.1 mA radio transmitter power consumption" literal quote confirmed; process node NOT stated on the page (industry survey claims "22 nm" without citation) | no | N/A |
| R9 / Atmosic+Energous press release | yes | yes — "Energous' FCC-certified 1 W WattUp PowerBridge transmitter" literal quote confirmed; "approximately one quarter the power consumption of a typical Bluetooth LE beacon" literal quote confirmed | no | N/A |
| R14 / Eddystone GitHub | yes | yes — Apache 2.0, frame types UID/URL/TLM/EID confirmed; specific URL payload-byte ceiling (industry says 31 B) was not extractable from the index page itself | no | N/A |
| R18 / Silicon Labs power compliance | yes | yes — confirmed CH37 18 dBm / CH38 15.3 dBm / CH39 20 dBm with AFH; FCC 15.247 +30 dBm conducted, ETSI EN 300 328 +20 dBm EIRP | no | N/A |
| A5 / Alghaihab UMich PDF | yes (URL resolves; PDF binary-opaque to WebFetch) | yes by metadata — title and authors match | no | N/A |
| R44 / CNX-Software ATM33 | yes | partial — confirms ATM33 RX 0.7 mA but the page does not quote a TX current; only "transmit power range 0–10 dB". Industry survey's "TX 2.1 mA" comes from the Atmosic vendor page (R8), not from the CNX article. | no | N/A |

**Summary.** No reference is broken or fabricated. Two soft mismatches:
(a) the academic survey cites Paidimarri JSSC 2016 with the headline
"43.7 % efficiency, sub-400 pW leakage, 65 nm" — the MIT DSpace
abstract confirms output power and efficiency but does not name the
process node in the abstract excerpt; the academic survey states
"65 nm" without primary citation and should add one. (b) Industry
survey's claim that ATM33 is "22 nm" is not supported by either the
vendor product page or the CNX-Software coverage I could fetch — the
process node should be cited from a primary source or downgraded to
"undisclosed".

No local mirrors of any cited reference are present under
`references-cache/<citation-id>/`. METHODOLOGY.md mandates mirroring
where copyright permits and SHA-256 recording where it does not. **All
three reports defer caching to "the parent committer" — this is a
methodology violation and must be addressed before sign-off.**

### Solution-space coverage

All three reports are genuinely exhaustive on solution-space breadth:

- PA topologies: FP enumerates 10 (A1-A10); Industry 10 (A1-A10);
  Academic 10 (PA1-PA10). All cover Class A through F plus inverse-D
  plus digital-polar. **Pass.**
- Synthesiser topologies: FP 8 (S1-S8); Industry 8 (S1-S8); Academic 8
  (S1-S8). **Pass.**
- TR-switch topologies: FP 6 (T1-T6); Industry 6 (T1-T6); Academic 6
  (T1-T6). **Pass.**
- Modulator paths: FP 4 (M1-M4); Industry not separately tabulated;
  Academic 5 (M1-M5). **Pass** (industry could add a table for
  consistency).
- TX architecture: FP 3 (R0-R2); Industry 4 (R0-R3); Academic implicit.
  **Pass.**
- Beacon-frame formats: only the **industry survey** enumerates these
  (B1-B7: iBeacon, Eddystone-UID/URL/TLM, AltBeacon, NDEF, BLE Mesh).
  The FP and academic reports do not address beacon-frame formats at
  all. The TODO.md item explicitly asks "Bluetooth flavour ... iBeacon
  / Eddystone / AltBeacon ... compare phone compatibility" — so
  **frame-format coverage is a methodology hit on FP and academic**,
  though defensible (FP is by definition prior-art-blind; academic is
  scoped to peer-reviewed silicon).
- Whole-chip BLE SoCs: industry survey enumerates 8 (C1-C8) with
  vendor numbers; academic enumerates 10 (K1-K10) with measured-silicon
  citations. FP has none, by design.

Both the simplest "dumb" approach (free-running ring DCO, S3) and the
most sophisticated (ADPLL with TDC at 1.6 mW in 28 nm) are present in
all three. **Pass.**

Approaches the FP report explicitly omits but should consider in a
revision: backscatter (Ensworth UW thesis) — present in industry and
academic but FP doesn't engage even hypothetically. Defensible since
FP is prior-art-blind, but in §3 it should still appear as a topology
*family* derived from physics (modulating an incident carrier to avoid
generating one).

### Premature narrowing

None of the three reports spends > 40 % of its length on a single
approach. None of the three executive summaries picks a winner — all
three explicitly state they are not down-selecting. **Pass.**

### Numerical claim verification

I redid four of the reports' numerical claims from first principles
(see brief). Show-the-math:

#### Recalc 1: Friis link budget (FP §5.1)

```
λ = c / f = 2.998e8 / 2.44e9 = 0.123 m  (pass)
(λ/4πd)² at 1 m = 9.560e-5  (= -40.20 dB)  (pass)
Pr_needed = -90 dBm sens + 10 dB fade = -80 dBm = 1e-11 W  (pass)
Pt = Pr / (Gt · Gr · pathloss) = 1e-11 / (0.5 · 1 · 9.560e-5)
   = 2.09e-7 W = 0.209 µW = -36.79 dBm  (pass)
```

**FP §5.1 reproduces correctly.** At 5 m the recalc gives Pt = 5.23 µW
= -22.81 dBm; FP report claims 5.2 µW / -22.8 dBm: identical to two
decimal places.

#### Recalc 2: 20 dB ambient-vs-BLE gap (FP §5.8 / academic §1.8)

For the FP report's *median ambient* scenario (S = 1 µW/cm², A_eff =
6 cm² IFA, 30 % rectifier η):

```
P_RF intercepted = 1 µW/cm² · 6 cm² = 6 µW
P_DC after rectifier = 6 µW · 0.3 = 1.8 µW
BLE demand at 100 ms interval (10 µJ/event) = 100 µW
gap = 100 / 1.8 = 55.6× = 17.4 dB  ≈ 20 dB (within rounding)
```

The 20 dB headline holds for the *median ambient* scenario the FP
report defined.

For the *brief's* stricter scenario (4 dBm AP at 2 m, 1 cm² rx):

```
S at 2 m, isotropic, 4 dBm AP = 2.51 mW / (4π·4 m²) = 0.005 µW/cm²
P_int = 0.005 µW/cm² · 1 cm² = 0.005 µW
P_DC = 0.005 · 0.3 = 0.0015 µW
gap = 100 / 0.0015 = 67000× = 48 dB  -- much worse
```

So the headline "20 dB gap" is only true for the FP report's chosen
ambient-flux band (1 µW/cm², which is *high-end* indoor). For the
brief's stricter "single AP at 4 dBm, 2 m" the gap is 48 dB. The
industry survey's cross-check via Atmosic+Energous (1 W cooperative
transmitter at 1 m, ~48 µW intercepted into 6 cm², ~15-25 µW DC)
arrives at the same range as the FP "ambient" upper bound — so the
*qualitative* gap conclusion is robust, but the **"20 dB" headline
should be tagged as scenario-dependent** (16-48 dB depending on
ambient-flux assumption). Pass with annotation request.

#### Recalc 3: Storage-cap area (FP §5.7, industry §5.6, academic §5.5) — CRITICAL FAIL

```
1 µF in fF: 1e-6 F / 1e-15 F/fF = 1e9 fF
At 2 fF/µm² MIM: area = 1e9 fF / 2 fF/µm² = 5e8 µm²
Convert: 1 mm² = 1e6 µm², so area = 500 mm² per µF
```

**FP report claims:** "1 µF = 0.5 mm² at 2 fF/µm² MIM density".
**Recalc says:** 1 µF = **500 mm² per µF**, off by **1000×**.

**FP §5.7 table:** "4 µF → 8.6 mm²" — recalc: 4 µF → **2000 mm²**, off
by ~250×.

**Industry §5.6:** "100 µF at 2 fF/µm² is 50 mm² die area" — recalc:
100 µF → **50,000 mm²** (5000 cm²), off by 1000×.

**Academic §5.5:** "Our die area constraint cannot host even 1 µF
on-die at MIM density 2 fF/µm² (would need 0.5 mm² just for cap)" —
recalc: 1 µF → **500 mm²**, off by 1000×.

**The brief's recalc instruction was prescient: "4 µF burst at
1.5 fF/µm² = 2.67 mm² MIM" — recalc: 4 µF / 1.5 fF/µm² = 2.67e9 µm² =
2670 mm² (not 2.67 mm²).** The brief's "2.67 mm²" itself appears to
have inherited the 1000× error from the reports.

The unit-conversion error: confusing **fF per µm²** with **fF per
mm²** when computing area. (Or equivalently: dropping 1e6 in the
mm²↔µm² conversion: 1 mm² = 1e6 µm², not 1e3.)

**This is the same arithmetic error in three "independent" reports.**
The mistake is so specific (a 10⁶ unit-conversion blunder, not a
plausible parameter-band disagreement) that *it could not have been
made independently three times*. At least two of the three reports
re-used a sister's number without re-deriving from
energy-and-density. This is a methodology-level finding (see also
"convergence" below).

**Operationally, the storage-cap-wall conclusion (on-die µF storage
infeasible) gets *more* robust under correction — the gap to die area
grows from "2.25 mm² die vs 8 mm² needed" (3.5×) to "2.25 mm² die vs
2000 mm² needed" (~900×). So the qualitative direction is unchanged
but the magnitude is dramatically understated.**

#### Recalc 4: Synthesiser-dominates-PA ratio (FP §5.5)

The FP report's executive summary states three times that "synth
dominates total event energy by ~3× over the PA itself". Its own §5.5
table:

```
PA (Class E, η=60 %)          : 1.7 mW
LC-VCO + buffer               : 2.0 mW
PFD/CP/divider/loop filter    : 1.0 mW
Modulator + GFSK shaper       : 0.3 mW
TR switch driver              : 0.1 mW
Sum                           : 5.1 mW
```

Synth (LC-VCO + buffer + PFD/CP/divider) = 3.0 mW. PA = 1.7 mW. Ratio
= **1.76×**, not 3×.

Even if "synth-block" includes the modulator (0.3) and the buffer
chain rolled in, the most generous reading is (2.0 + 1.0 + 0.3) / 1.7
= 1.94× ≈ 2×.

**The "3×" claim in the FP exec summary, §10 author notes, and the
academic survey's "synth dominates" framing is *not supported* by the
FP report's own table.** The industry survey self-corrects this to
"≈ 2× rather than 3×" after honest 40 % PA efficiency lifts PA DC to
2.5 mW (giving 3.0/2.5 = 1.2× — *parity-ish*). The academic survey
even arrives at "P_synth ~ P_PA at 28 nm, 0.2 V supply" via Sano 2018
(parity, not 3:1) and "2:1 at 180 nm" (not 3:1).

**The headline "3× synth-vs-PA" should be revised to "2× at best,
parity at the well-optimised 28 nm point" with the §5.5 numbers
re-stated.**

#### Other numerical spot-checks

- fT for nfet_03v3 (L=0.28 µm, Vov=0.5 V, µ=0.04): **40.6 GHz** —
  matches FP §5.2. Pass. (Caveat: µ=0.04 m²/V·s is generous for 180 nm
  NMOS surface mobility under bias. Razavi quotes ~350 cm²/V·s = 0.035
  m²/V·s; 0.04 is the upper bound. fT ~30-40 GHz is the realistic
  range. Conclusion (fT/f >> 1 at 2.4 GHz) is robust.)
- BLE adjacent-channel mask: FP §5.4 says "−20 dBc in 1 MHz BW at
  ±2 MHz, requires SSB phase noise = −80 dBc/Hz with margin to
  −90 dBc/Hz". This is correct — the integration over 1 MHz BW gives
  60 dB ratio, so for −20 dBc in 1 MHz, SSB target is
  −80 dBc/Hz at the offset. **Pass.**
- TR-switch off-state isolation: |Z_off| = 1/(2π · 2.4 GHz · 50 fF) =
  1326 Ω. Isolation at 50 Ω ≈ 20·log10((1326+50)/50) = 28.8 dB,
  matching FP. **Pass.**

#### Cross-cutting physics check

- Friis: not violated. Recalc 1 reproduces.
- Faraday: not invoked.
- kTB: not directly invoked but BLE phase-noise budget is consistent
  with kTB-bounded LC-VCO Q.
- Carnot: not relevant.

**No physical-law violations.** The two arithmetic errors (storage cap,
synth ratio) are unit/extraction errors, not physics violations.

#### Roy ISSCC 2018 anchor-claim check (academic §3.1)

The academic survey (and academic §10 author note) claims **Roy
ISSCC 2018 is the only 180 nm BLE-related radio anchor in the
peer-reviewed record, and is not BLE-compliant**. I could not directly
verify Roy 2018 via WebFetch (no open mirror found beyond the IEEE
Xplore landing page, which I was instructed not to fetch). Indirect
evidence: industry survey's R37 (MDPI Electronics 11(7) 2022) cites a
180 nm 2.4 GHz PLL at 21.3 mW — but that is a synthesiser-only paper,
not a complete BLE TX, so it doesn't contradict the academic survey's
claim. The claim is plausible and consistent with the absence of any
180 nm BLE TX papers I have seen elsewhere in the BLE / ULP literature
(the published-silicon BLE TXs cluster at 90 nm and below: Vidojkovic
90 nm, Liu 40 nm, Sano 28 nm, Wentzloff/Alghaihab 28-65 nm). **Mark
as DOI-resolved-abstract-matches per the brief, and recommend the
academic survey add a primary citation (preferably ResearchGate or
Cubeworks faculty page) confirming Roy 2018's narrowband / not-BLE-
compliant nature.**

### Negative results

All three reports have substantial negative-results sections:

- FP: 7.1-7.8 (8 negatives)
- Industry: 7.1-7.11 (11 negatives)
- Academic: 7.1-7.11 (11 negatives)

Coverage is good. Notably present:
- Free-running ring DCO fails BLE mask (all three)
- BAW/FBAR off-PDK (all three)
- ADPLL only viable at 28-65 nm (industry, academic)
- Backscatter requires cooperative transmitter (industry, academic)
- RPA defeats passive-scan UX (all three)
- Atmosic ATM3 cannot do "true ambient" without WattUp (industry,
  academic)
- No 180 nm bulk-CMOS BLE-compliant TX exists in published silicon
  (academic only — **this is a stronger finding than the sister
  reports flagged**, and it should propagate up to the executive
  summary of the eventual Stage-2 synthesis).

### Convergence with parallel reports

This is where I have the most adversarial finding.

**Topology-key convergence (>70 % overlap on stable IDs):**
- PA: All three reports use **A1-A10 / PA1-PA10** with the same
  family ordering (Class A, AB, B, C, D V-mode, D current-mode, E,
  E-differential, F, digital polar). Even the discarded approaches
  (Doherty, ET, LINC) appear in the same order in FP and industry.
- Synthesiser: All three use **S1-S8** with substantially overlapping
  assignments (S1=Integer-N LC, S2=Fractional-N LC, S5=LC+integer-N
  as default in FP and industry, S7-or-S8 = BAW). Academic differs
  on S3 binding (uses S3 for ADPLL instead of ring-DCO).
- TR-switch: All three use **T1-T6** with identical family ordering.

This is *not* the convergence pattern of three independent
researchers. Independent researchers naming things from scratch would
disagree at minimum on the labels; they would also have small but
visible disagreements on which Class-D variant is "default" or which
is "rejected first". The fact that all three reports use the *same
labels* applied to the *same ordering* of the *same approaches*
strongly suggests they were written by the same model with the same
in-context prompt rather than by genuinely parallel investigators.
**This is suspicious convergence per the methodology brief.**

**Numerical-error convergence:**
The storage-cap area calculation is wrong by exactly the same factor
(1000×) in all three reports — the FP report's "0.5 mm²/µF", the
industry's "50 mm² for 100 µF", and the academic's "0.5 mm² for
1 µF" all derive from the same identical unit-conversion blunder.
Independent first-principles recalculation by three researchers
*would not produce the same wrong answer*. **At least two of the
three reports re-used a sister number without re-deriving.**

**Authentic disagreement, where present:**
- PA efficiency at 0 dBm: FP optimistic 60 %, industry honestly
  corrects to 45 % (single-ended), academic corroborates 35-45 %
  via Stauth/Tsai back-off fits. **This *is* a healthy disagreement,
  with industry and academic correcting FP — exactly what parallel
  reports are supposed to do.**
- LC-tank Q on Metal4: only academic flags this (Q≈8 vs Metal5
  Q≈12, 3.5 dB phase-noise penalty), neither sister report addresses.
  **Authentic finding unique to academic. Pass.**
- Crystal-less BLE TX viability: only academic notes Wentzloff's
  technique requires a co-channel cooperative transmitter and so does
  *not* solve the standalone XTAL-less problem for our use case.
  **Critical finding unique to academic. Pass.**
- Roy ISSCC 2018 process-first-of-kind framing: only academic flags
  that no 180 nm BLE-compliant TX exists in the published record;
  industry hints at it in §10 author's note but does not promote it
  to a finding. **Strong finding unique to academic. Pass.**

So there IS authentic disagreement and unique academic content — the
problem is that the disagreement is concentrated on the PA-efficiency
correction and 1-2 academic-only findings, while the topology-name
ordering and the storage-cap arithmetic show ~70 % shared scaffolding.

### Specific revisions requested

1. **(All three reports.) Recompute storage-cap area from scratch and
   correct the §5.7 (FP), §5.6 (industry), §5.5 (academic) tables.**
   The error is unit-conversion (µm² ↔ mm²): 1 µF at 2 fF/µm² needs
   500 mm², not 0.5 mm². Update the numbers, the conclusions, and any
   downstream-budget area assignments. The qualitative "infeasible"
   verdict stands; the magnitude needs to be re-quoted (it's far
   worse than reported, ~1000× worse).

2. **(FP.)** The exec-summary "synth dominates PA by ~3×" is
   inconsistent with FP's own §5.5 table (1.76×). Either rerun the
   table to support 3× or correct the headline to "≈ 2×". Then
   propagate the correction to §10 author notes.

3. **(FP.)** The "20 dB gap" headline is scenario-dependent (16 dB
   median ambient, 27 dB low ambient, 48 dB for the brief's strict
   "+4 dBm AP at 2 m / 1 cm² rx"). Tag it with the specific ambient
   flux assumption.

4. **(All three.)** The "70 % topology-name convergence" is suspicious.
   At least one of the three (preferably FP, since it is supposed to
   be prior-art-blind) should re-emit its solution-space map with
   *different* labels and ordering, derived without consulting the
   sister reports. If the convergence is robust to relabeling, that's
   evidence of physics-driven taxonomy; if not, it confirms shared
   scaffolding.

5. **(Industry.)** Cite a primary source for ATM33's process node
   (claim is "22 nm"). Neither the Atmosic product page nor the
   CNX-Software coverage I could fetch states the node. If no primary
   source, downgrade to "undisclosed".

6. **(Academic.)** Cite a primary source for the Paidimarri 2016
   process node ("65 nm"). The MIT DSpace landing-page abstract
   confirms output power (+10 dBm) and efficiency (43.7 %) but does
   not name the node in the excerpt I retrieved. (The 65 nm claim
   may well be correct from the JSSC paper proper, but it needs a
   primary citation.)

7. **(All three.)** Mirror the open-access subset of references under
   `references-cache/<citation-id>/`. Three reports declaring "local
   caching deferred to the parent committer" is not the methodology's
   division of labour. Atmosic product pages, Energous press release,
   Eddystone GitHub, ETSI EN 300 328 PDF, FCC eCFR section,
   Silicon Labs compliance page, Paidimarri MIT DSpace landing page,
   Apache NimBLE README, Zephyr docs, Alghaihab UMich PDF — all of
   these are open-access and trivially mirrorable. Record SHA-256 of
   each, including IEEE Xplore landing-page HTML where possible.

8. **(FP.)** Add a §3-level entry for *backscatter* even if you reject
   it — it's a topology family derivable from physics ("modulate an
   incident carrier rather than generate one") and so is in scope for
   the prior-art-blind angle. Currently FP omits backscatter entirely.

## Closing notes

- The three reports' qualitative conclusions (storage infeasible,
  synth-dominant-or-parity, ambient-RF gap large, no BLE-compliant
  180 nm prior art) are robust under independent recalculation — the
  *direction* of every claim survives. The reports' value lies in the
  topology enumeration (genuinely exhaustive) and in the academic
  survey's measured-silicon anchoring (3-5 unique findings the sister
  reports missed). The defects are concentrated in: (a) the
  1000×-wrong cap-area arithmetic that all three repeat; (b) the FP
  report's "3× synth-vs-PA" headline that contradicts its own table;
  (c) suspicious convergence on topology labels; (d) wholesale
  deferral of reference caching.
- **Net: revisions-requested, not fail.** The structural bones are
  sound; six specific edits make them sign-off-ready.
- **For Stage-2 synthesis:** the academic survey's "process-first-of-
  kind" finding (no published 180 nm BLE-compliant TX) is the single
  most actionable input for the v2 floorplan decision. It means *any*
  block-level number ported from 65 nm or below carries a ±50 % port
  uncertainty. Stage 2 should treat this as the dominant risk axis,
  not the storage-cap wall (which is a known constraint with a clear
  off-die mitigation).
- **For Stage-2 synthesis:** the corrected storage-cap area of
  ~500 mm²/µF makes the case for off-die storage *unambiguous* —
  there is no aggressive density assumption that makes on-die µF-class
  storage feasible in 180 nm. The brief should drop "is it 8 mm² or
  is it 2.67 mm²" as a question and pivot to "what's the smallest
  off-die cap that meets a 100-ms-or-slower advert cadence in
  Qi-class harvesting?".
- **Reviewer self-rating:** I performed 6 WebFetches (Paidimarri MIT
  DSpace; Atmosic ATM33; Atmosic+Energous press release; Eddystone
  GitHub; Silicon Labs compliance; CNX-Software ATM33; one additional
  attempt at the Alghaihab UMich PDF and one Semantic Scholar search
  that returned no content), 4 numerical recalculations
  (Friis link, 20 dB gap, storage-cap area, synth-vs-PA ratio), plus
  fT/isolation/mask spot-checks. Within the brief's 10-WebFetch
  ceiling.
