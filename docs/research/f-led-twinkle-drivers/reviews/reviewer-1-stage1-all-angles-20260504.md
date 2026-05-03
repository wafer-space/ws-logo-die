---
report_under_review:
  - docs/research/f-led-twinkle-drivers/stage1-first-principles/
  - docs/research/f-led-twinkle-drivers/stage1-industry-survey/
  - docs/research/f-led-twinkle-drivers/stage1-academic-survey/
reviewer: reviewer-1 (claude-opus-4-7-1m, adversarial Stage-1 reviewer)
date: 2026-05-04
verdict: revisions-requested
---

## Verdict

**revisions-requested** — for all three angles, but with different
severities:

- **stage1-first-principles** — minor revisions. The 100× cap-area
  correction landed correctly in `report.md` but `solutions.md`
  still shows the *uncorrected* "10 nF MIM (~50k µm² @ 2 fF/µm²)"
  figure (line 20). One stale duplicate to fix. Otherwise sound.
- **stage1-industry-survey** — minor revisions. PAR1789 number
  treatment is correct, but the report has not flagged the
  Karthaus/Curty/etc. provenance issues that the academic survey
  introduced. No load-bearing arithmetic errors in this report.
- **stage1-academic-survey** — substantive revisions. Citation
  errors (Davis ≠ Greene; Karthaus 16.7 µW does not include an
  on-die LED), PAR1789 formula confusion (mixing below-90 Hz and
  above-90 Hz tiers), thin companion files self-admitted as
  partial summaries, and topology-ID re-use that *changes the
  meaning* of T2/T3/T5 from the parallel sisters.

Not "fail" — the underlying physics conclusions are mostly robust
and the FP report's T4 100× correction in CORRECTIONS.md is verified
correct. But each report has at least one defect that must be fixed
before Stage 2.

## Findings

### Reference verification (REQUIRED)

| Citation | URL/DOI resolved? | Document matches citation? | Local cache present? | Local cache matches upstream? |
|---|---|---|---|---|
| FP-V1 — Wikipedia "Flicker fusion threshold" | yes (re-fetched 2026-05-04) | yes — confirms 60 Hz photopic / 15 Hz scotopic plateaus verbatim | no | N/A |
| IND-I11 — cpldcpu 2013 candle-flicker blog | yes (re-fetched 2026-05-04) | yes — 440 Hz osc, 12 brightness levels (top), frame=32 cycles=72 ms, ≥17b state, "did not repeat for at least 4 minutes", `MAX_ATTEMPTS=4` rejection-sampling all confirmed; also confirms "1980ies technology, 1-2 µm" CMOS | no | N/A |
| IND-I13 — cpldcpu 2024 OTP-MCU candle-flicker blog | yes (re-fetched 2026-05-04) | yes — 240 µA sleep ("53mV/220Ω=240µA"), 1 MHz core clock, 125 Hz PWM, 6h-on/18h-off, ~0.5 mm² die all confirmed verbatim | no | N/A |
| IND-I17 — AzoM PAR1789 article | yes (re-fetched 2026-05-04) | yes — formulas match: below-90 NOEL=f·0.025; below-90 LR=f·0.01; above-90 NOEL=f·0.08; above-90 LR=f·0.033. **NOTE**: AzoM's *labelling* of "NOEL" vs "Low-risk" appears to be **opposite to the IEEE 1789-2015 standard convention**. Per actual IEEE 1789-2015, the *stricter* tier (NOEL — no observable effect) requires the *smaller* coefficient (0.0333 above 90 Hz, giving f≥3 kHz at 100% mod), not the larger (0.08 giving f≥1.25 kHz). The industry-survey report §5.3 has the correct interpretation despite citing AzoM. The academic-survey report §5.3 confuses tiers, see below. | no | N/A |
| IND-I20 — EP2081414A1 "Sigma delta LED driver" | yes (re-fetched 2026-05-04) | yes — title, PDM mechanism, ~40 kHz vs 400 Hz PWM, 12-bit resolution all confirmed; **note**: patent was *withdrawn 2010* (academic-survey ACAD-A correctly notes the academic anchor is stronger anyway) | no | N/A |
| ACAD REF-OA-1 — Davis 2015 *PLOS ONE* PMC4395448 | yes (fetched 2026-05-04) | **PARTIAL — author name wrong**: actual author is **Ernest Greene**, not "Davis"; title "Evaluating Letter Recognition, Flicker Fusion, and the Talbot-Plateau Law using Microsecond-Duration Flashes". Substantively, the paper does report ~2× deviation from Talbot-Plateau at 1.3 µs flashes. Quote: *"Steady intensity was about double the average flash intensity where the two conditions were perceived as being equal in brightness. This is at odds with Talbot-Plateau law, which predicts that these two values should be equal."* | no | N/A |
| ACAD REF-OA-2 — Davis 2023 *Frontiers* PMC10172486 | yes (fetched 2026-05-04) | **PARTIAL — author name wrong**: actual authors **Ernest Greene and Jack Morrison**, not "Davis". Substantively confirms TP deviations: *"the ratio of observed to expected flash intensities ... range in size from 0.85 to 1.55"* — not a clean "2×" universally; 2× is at the high end of a range. | no | N/A |
| ACAD REF-OA-3 — Hecht, Shlaer, Pirenne 1942 *J. Gen. Physiol.* | URL given as "PMC mirror available" but no specific URL; PMC URL I tried (PMC2142474) is a *different* paper (1994 porin structure). | **UNVERIFIED at the cited URL**. However, Wikipedia "Absolute threshold" article (re-fetched 2026-05-04) corroborates the 5–14 photons absorbed claim: *"the emission of only 5-14 photons could elicit visual experience"* with *"only about half of these entered the retina"*. Historical claim is widely supported in secondary lit; primary citation is correct in spirit but the URL the academic survey gives is non-locating. | no | N/A |
| ACAD REF-PW-2 — Karthaus & Fischer 2003 *JSSC* 38(10) | DOI 10.1109/JSSC.2003.817627 not directly fetched (IEEE Xplore skipped per brief); abstract verified through Google Scholar (re-fetched 2026-05-04) | **MAJOR — no on-die LED in the paper**. Abstract describes "fully integrated passive transponder IC with 4.5- or 9.25-m reading distance" in **0.5-µm CMOS** (not "0.18 µm CMOS" as the academic-survey claims), with Schottky-diode rectifier, EEPROM, PSK backscatter, PWM demod, anti-collision. **The abstract makes no mention of an LED at all.** The "16.7 µW minimum RF input power" is the receiver-sensitivity threshold of the entire RFID front-end, **not** the budget for an on-die LED indicator. The academic survey's headline §1.2 — *"Karthaus & Fischer (*JSSC* 38(10) 2003, 16.7 µW whole-tag including on-die LED indicator)"* — is unsupported by the cited source. The open question Q-AC5 honestly admits the math doesn't work but the headline still runs the false claim. | no | N/A |

**Summary**: 8 references spot-checked (≥5 required). 5 fully
verified (FP-V1, IND-I11, IND-I13, IND-I17, IND-I20). 2 partially
verified with author-name errors (Davis→Greene; affects 2 academic-
survey citations and 4 mentions of "Davis" throughout). 1 source
URL non-locating but historically corroborated (Hecht-Shlaer 1942).
**1 substantive misattribution** — Karthaus 2003 does not include
an on-die LED in its abstract, contradicting the academic survey's
headline conclusion.

### Solution-space coverage

#### stage1-first-principles
- §3 enumerates 7 driver topologies (T1–T7) including a rejected
  one (T5 boost). Meets the ≥ 5-topology bar.
- Includes naïve floor (T7 direct switch, T1 ballast), conventional
  middle (T2/T3 mirror+DAC), sophisticated (T4 bucket-dump), and
  most sophisticated (T6 tribrid). Spectrum is well represented.
- README per-item bullets covered: topology (✓), PWM (§5.3), brown-
  out (§3.2 brown-out per topology), rail-coupling (§5.6), pad
  type (briefly — only via R7), eFuse (Q7).
- **Gap**: pattern-generator algorithms are listed as gate-counts
  in §5.7 but not enumerated as distinct *algorithms* (LFSR vs
  Perlin vs brownian etc.). The README §3 explicitly asks for that
  enumeration. The industry-survey *does* enumerate PAT-1..PAT-8
  and the academic-survey adds PAT-9..PAT-10. The first-principles
  report should at minimum cross-reference, not just list gate
  counts. Minor.

#### stage1-industry-survey
- §3 enumerates T1-T7 driver topologies (5 + 1 rejected + 1
  trivial) plus 11 industry-only entries IND-A..IND-I plus 8
  pattern algorithms PAT-1..PAT-8. Massive breadth — the strongest
  Stage-1 (f) report on coverage.
- Spectrum well-covered from FR1001 deterministic pattern
  (simplest) to PIC12-class OTP MCU (most sophisticated).
- README bullets covered: topology (✓), PWM/perception (§5.3
  PAR1789), pattern-gen (PAT-1..PAT-8), brown-out (§3.4 T4),
  rail-coupling (§5.6 referencing FP §5.6), pad type (§3.13–§3.15
  full PDK audit; "Recommended pad cell" subsection), eFuse-
  controlled selection (open-question implicit).
- **Strength**: PDK pad-cell audit verified against local
  filesystem (gf180mcu_fd_io.cdl / .lib) — direct primary source.

#### stage1-academic-survey
- §3 lists T1-T7 driver topologies plus ACAD-A..ACAD-F academic-
  only contributions plus PAT-9..PAT-10 pattern algorithms. Bar
  cleared on count.
- However, **T5 has been silently REPURPOSED**: the academic
  survey's T5 is "Switched-cap voltage doubler" (Wens & Steyaert
  2011), but FP and industry-survey both use T5 for "boost
  converter w/ on-die L (REJECTED)". This is a topology-ID
  collision. See "Topology-ID-collision pattern" below.
- **Companion files are explicitly thin**. §10 author's-note
  admits: *"the agent's first attempt drafted report.md content
  but did not write supporting components.md / solutions.md /
  references.md / open-questions.md in full. The orchestrator
  persisted the structured return; companion files are summarised
  from the same return."* This is honest disclosure, but the
  effective Stage-1 deliverable is `report.md` only — the others
  are reconstructions. Stage-2 must treat them as such.
- **Spectrum gap**: academic survey omits the T2-equivalent
  classical current mirror (FP T2; IND T2 = TLC59xx-class) — its
  T2 slot is taken by Doutreloigne 2015 diode-MOS-as-resistor.
  Effectively, classical current-mirror has *no academic anchor
  in this survey*. Tan & Mok 2009 occupies T3 but is conference-
  paper grade only. The first-principles and industry surveys both
  rejected T2 on the *headroom + Iq* arguments specific to
  TLC59xx — those arguments are *missing from the academic
  survey*, leaving the impression that T2 is fine.

### Premature narrowing

- **stage1-first-principles**: ~7 topologies, fairly even
  paragraph budget, no single topology dominates the report.
  Headline §1 explicitly disclaims a winner. ✓
- **stage1-industry-survey**: Same. No premature narrowing. ✓
- **stage1-academic-survey**: Headline §1 has 3 conclusions, of
  which one (Talbot-Plateau correction) is presented as a
  *headline-grade* finding affecting T4 sizing. This is on the
  boundary of opinion-leaking but is technically a quantitative
  correction, not an architectural recommendation. Acceptable.

### Numerical claim verification

Recalculations performed:

#### Recalc 1 — T4 charge-pump bucket-cap area (the 100× CORRECTIONS.md fix)

```
1 nF = 1e-9 F = 1e6 fF
10 nF = 1e7 fF = 10,000,000 fF
At 2 fF/µm² density: 10,000,000 / 2 = 5,000,000 µm² = 5 mm²
```

The CORRECTIONS.md entry says the original "50 000 µm² = 0.05 mm²"
was off by 100× (correct value 5 mm²). Verified.

The CORRECTIONS.md narrative initially says the systematic error
was *1000×*, but for the (f) T4 case the multiplier is *100×*. The
log already documents this distinction (CORRECTIONS.md table line
49: `(f) | stage1-first-principles/report.md | line 352 T4 bucket
cap`). Both the magnitude (100× not 1000×) and the corrected value
(5 mm²) match my recalculation. ✓

**However**, the corrected value is still in `report.md` only.
`stage1-first-principles/solutions.md` line 20 still reads:
*"10 nF MIM (~50k µm² @ 2 fF/µm²) + 2 switches"* — the **stale
incorrect** number. This is a *missed sweep* — the correction was
applied to the report but not the solutions file.

Similarly, `stage1-industry-survey/report.md` §3.4 and §9 use
"10 nF MIM (~50k µm²)" without the correction; the
industry-survey's solutions.md and the report.md `T4` row in §9
both say "~50k µm²". These are independent of FP but inherit the
same error.

**Action**: sweep all three angles for the "~50k µm²" string in
T4 context.

#### Recalc 2 — Talbot-Plateau 2× correction propagation into T4 sizing

The academic survey claims: *"T4 charge-pump 1-µs pulses need 2×
pulse rate or 2× peak current to match the perceived-brightness
budget"*.

- **2× pulse rate**: doubles average rail current. Coherent.
- **2× C_b**: doubles delivered energy/pulse. Coherent. But: with
  the 100× cap-arithmetic correction, original 5 mm² becomes
  10 mm², which exceeds even the 1×1 slot DIE_AREA (~2.25 mm²).
  *Stage-2 must inherit this constraint*, not just the FP/IND
  claim that "T4 is feasible".
- **2× peak current** (per Davis/Greene): if interpreted as "double
  I_peak with same C_b and same pulse duration", this does NOT
  double delivered LED energy — the cap dump energy is fixed at
  ½·C_b·(V_rail² − V_min²) regardless of switch I_peak. It only
  changes the *time profile*. So this interpretation is incoherent.
  The academic survey's formulation should be tightened to
  "2× pulse rate **or** 2× cap (and accept area cost) **or**
  2× ΔV (impossible — V_rail is fixed)".

#### Recalc 3 — Hecht-Shlaer threshold → LED current

Photon energy at 630 nm: E_ph = hc/λ ≈ 3.15×10⁻¹⁹ J.
Hecht-Shlaer: ~100 photons at the cornea / 100 ms ≈ 10⁻¹⁵ W
absolute threshold at the pupil.
At 1 cm card-distance, dark-adapted 7 mm pupil:
  Ω_pupil = π·(3.5e-3)²/(1e-2)² ≈ 0.385 sr
  Lambertian fraction = Ω/π ≈ 0.123
  LED radiant power required: 1e-15 / 0.123 ≈ 8e-15 W ≈ 10 fW
  At η_e = 0.20, electrical input ≈ 50 fW
  At V_f = 1.85 V, current ≈ 27 fA — vanishingly small.
At 30 cm card-distance: Ω_pupil ≈ 4.3e-4 sr, fraction ≈ 1.4e-4,
required LED current ≈ 50 pA.

The academic survey's "0.1 µA red-LED current" is **~10⁵× more
pessimistic** than my dark-adapted calculation at 30 cm
card-distance. The discrepancy is large enough that the academic
survey's *reasoning chain* between "5-14 photons" and "0.1 µA"
should be shown explicitly. Without it the number reads as
plucked. This is *not* a hard error (the academic-survey number is
in the ballpark of *ambient-lit, glance-detectable*, not strict
dark-adapted threshold), but the under-documented translation
weakens the headline §1.3 conclusion.

The first-principles report's 0.5 µA is similarly under-documented
(also ~10⁵× pessimistic vs my calc). Both reports are within an
order of magnitude of each other in the same direction
(pessimistic). If the *intent* is "what current is reliably visible
in normal indoor viewing conditions, peripheral glance, no dark
adaptation, ~30 cm card-distance, ambient ~300 lux", then 0.1–1 µA
is plausible — but that should be stated. *Both reports lose the
distinction between "absolute threshold" and "comfortably visible
in normal conditions".*

#### Recalc 4 — PAR1789 1.25 kHz / 3 kHz floors

For 100% modulation depth (PWM gating between 0 and full):
- Above 90 Hz Low-Risk: Mod% ≤ f·0.08 → f ≥ 100/0.08 = **1250 Hz**
- Above 90 Hz NOEL: Mod% ≤ f·0.0333 → f ≥ 100/0.0333 = **3003 Hz**

Industry-survey §5.3 has these correctly: *"Low-risk above 90 Hz:
f ≥ 100/0.08 = 1250 Hz. NOEL above 90 Hz: f ≥ 100/0.0333 =
3003 Hz."* ✓

**Academic-survey §5.3 has these wrong**:
- "Low-risk threshold: Mod% ≤ f · 0.025 (for f > 90 Hz)" — 0.025
  is the *below-90-Hz NOEL* coefficient (per AzoM) or the *below-
  90-Hz Low-Risk* coefficient (per actual IEEE 1789); either way
  it does not belong on an "f > 90 Hz Low-risk" line.
- "No-effect threshold: Mod% ≤ f · 0.0333 (for f > 90 Hz)" —
  0.0333 is the actual above-90-Hz NOEL coefficient. ✓
- "High-risk above: Mod% > f · 0.08" — 0.08 is the above-90-Hz
  Low-Risk *boundary* (modulations below it are low-risk; above
  it are higher-risk). Calling it "high-risk above" is on the
  boundary of correct.

**Mixing-of-tiers** error in academic survey §5.3. Net result: the
"40 Hz very loose" floor the academic-survey computes from f≥1/0.025
is *applying the wrong tier*. Should be: at 100% mod, low-risk
f ≥ 1.25 kHz (matching industry-survey), not f ≥ 40 Hz.

The academic-survey's §1.4 conclusion "1.25 kHz / 3 kHz floor
based on aggregated clinical data" arrives at the right answer in
prose despite the wrong formula in §5.3. So the *net headline* is
not contradicted, but §5.3 needs a rewrite.

### Negative results

- **stage1-first-principles**: §7 has 5 negative results (N1
  boost-rejection, N2 current-mirror-as-primary, N3 PWM-not-an-
  efficiency-win, N4 long-PWM-pulse-rail-dip, N5 visible-current-
  threshold-floor). All have actionable conditions and applicability
  flags. ✓ Strong negative-results section.
- **stage1-industry-survey**: §7 has 7 negative results (N1
  TLC59xx-Iq-too-high, N2 boost-rejection, N3 asig_5p0-ESD-cross-
  domain, N4 no-OS-twinkle-IP, N5 FR1001-deterministic-period-too-
  short, N6 sine-LUT-wrong-shape, N7 PAR1789-kills-sub-1kHz). All
  with conditions. ✓ Strongest negative-results section of the
  three.
- **stage1-academic-survey**: §7 has 5 negative results. N1, N2
  are minor (sigma-delta-was-patent-only; TRNG-overkill); N3
  (LC-tank-doesn't-help) is correct but a re-statement of FP §5.5.
  N4 (Talbot-Plateau-is-approximate) and N5 (Hecht-Shlaer-may-make-
  card-dark) are the substantive new negative results. Acceptable
  but lighter than sisters.

### Convergence with parallel reports

**Topology family overlap**:

- FP↔IND: T1, T4, T5(rej), T6, T7 align by topology *and* ID; T2
  and T3 align by ID with mild definition drift (FP T2 = "classical
  current mirror"; IND T2 = "TLC59xx-class current sink with ref"
  — same family, different industry framing). Overlap ≈ 85%.
- FP↔ACAD: T1, T4, T6, T7 align. T2/T3/T5 do *not* align in
  topology (only in ID — see ID-collision section). Overlap on
  topology ≈ 55%.
- IND↔ACAD: same as FP↔ACAD ≈ 55%.

**70% threshold for "suspicious convergence"**: FP↔IND exceeds
this. *However*, the reports have *complementary* evidence bases:
FP derives from physics; IND adds 11 industry-only entries
(IND-A..IND-I), 8 pattern algorithms, full PDK pad audit; the only
*shared* content is the T1-T7 topology family. **This is not
the (a)/(k)-style suspicious convergence pattern** — the angles
demonstrate distinct work products despite overlapping topology
families.

**For (f), the suspicious-convergence verdict is: NO** — each
angle's evidentiary base is distinguishable. The high topology-
family overlap is justified because the topology space is small
(7 driver families exist; physics demands all three angles surface
the same families).

**Topology-ID-collision pattern (a-style): YES, present in (f).**
- T2 IDs the same character across all three but the *underlying
  topology differs*: FP="current mirror"; IND="constant-current
  sink with internal Iref"; ACAD="diode-connected MOS-as-resistor".
- T3: FP="DAC + PWM"; IND="DAC + PWM (BC/DC)"; ACAD="current mirror
  with bandgap" (which is FP's T2).
- T5: FP="boost converter (REJECTED)"; IND="boost converter
  (REJECTED)"; ACAD="switched-cap voltage doubler (NOT rejected)".
  This is the **most damaging** collision — Stage 2, ingesting
  these tables, would conclude that T5 is sometimes-rejected and
  sometimes-the-blue/white-LED-rescue, *because the ID has been
  reused for two entirely different topologies*.

CORRECTIONS.md (a) topology-ID-collision section says: *"Stage 2
cannot ingest these as written. Fix path is to re-namespace FP
topology IDs as `FP-*` and industry-survey topology IDs as `IS-*`,
preserving academic-survey's `AC-*`."*

For (f), recommended fix is the same pattern: rename topology IDs
across all three angles to `FP-T*`, `IS-T*`, `AC-T*` so Stage 2 can
disambiguate. The academic-survey's existing ACAD-A..ACAD-F naming
is fine; the offenders are T1-T7 in all three angles.

### Specific revisions requested

#### stage1-first-principles
1. Update `solutions.md` line 20 (T4 row): replace "10 nF MIM
   (~50k µm² @ 2 fF/µm²) + 2 switches" with "10 nF MIM (~5 mm² @
   2 fF/µm²) + 2 switches — exceeds 1×1 slot DIE_AREA, must shrink
   to ≤4 nF or accept off-die" matching the corrected wording
   already in `report.md` §9 row T4.
2. Cross-reference pattern-algorithm enumeration: §5.7 should at
   minimum state "PAT-1..PAT-10 see industry-survey §3.18 and
   academic-survey §3" so Stage 2 doesn't think FP omitted them.
3. Optional: rename T1-T7 → FP-T1..FP-T7 to disambiguate from the
   academic-survey's redefined T2/T3/T5.

#### stage1-industry-survey
4. Sweep `report.md` §3.4 and §9 T4 row, plus `solutions.md` and
   `components.md`, for "~50k µm²" and similar variants of the
   pre-correction T4 cap-area number. Apply the same 100×
   correction the FP report received.
5. Optional: rename T1-T7 → IS-T1..IS-T7 for ID disambiguation.

#### stage1-academic-survey
6. **Author-name correction**: replace all 4 instances of
   "Davis 2015" with "Greene 2015" and "Davis 2023" with "Greene &
   Morrison 2023" across `report.md`, `solutions.md`,
   `components.md`, `references.md`, `open-questions.md`. Original
   correct citations:
   - Greene, E. (2015) "Evaluating Letter Recognition, Flicker
     Fusion, and the Talbot-Plateau Law using Microsecond-Duration
     Flashes." *PLOS ONE* 10(4): e0123458, PMC4395448.
   - Greene, E. & Morrison, J. (2023) "Evaluating the Talbot-Plateau
     law." *Frontiers in Neuroscience*, PMC10172486.
7. **Karthaus 2003 LED claim**: §1.2 conclusion *"16.7 µW
   whole-tag including on-die LED indicator"* is unsupported. The
   abstract describes a 0.5-µm CMOS RFID transponder with *no
   mention of an LED*. Two options:
   - Retract the claim entirely (most honest).
   - Replace with a paper that *does* report measured on-die LED
     indicator current at sub-mW total budget (search for "passive
     RFID LED indicator JSSC"; possibilities include Curty 2005,
     but verify against the actual abstract before re-citing).
8. **CMOS node correction**: Karthaus 2003 is **0.5 µm** CMOS, not
   "0.18 µm CMOS" as `report.md` §1.2 and `components.md` claim.
9. **PAR1789 §5.3 formula tier-mixing**: rewrite the bullet list
   to match IEEE 1789-2015 actual conventions:
   - Below 90 Hz NOEL: Mod% ≤ f·0.01.
   - Below 90 Hz Low-Risk: Mod% ≤ f·0.025.
   - Above 90 Hz NOEL: Mod% ≤ f·0.0333.
   - Above 90 Hz Low-Risk: Mod% ≤ f·0.08.
   At 100% mod: low-risk ≥ 1.25 kHz; NOEL ≥ 3 kHz. Stop using
   "f ≥ 1/0.025 = 40 Hz" as a derived number.
10. **T5 topology-ID disambiguation**: either retire the T5 ID or
    rename to AC-T5 = "Switched-cap voltage doubler", explicitly
    distinct from FP/IS T5 (rejected boost). Add an explicit
    statement: "AC-T5 ≠ FP-T5 = IS-T5 (boost-converter, rejected
    on energy-density grounds — see FP §5.5 / IS §5.1)." Otherwise
    Stage 2 will silently merge incompatible rows.
11. **Talbot-Plateau "2× peak current" interpretation**: §1.1 and
    §5.1 list "2× peak current" as one of two corrective options.
    This is incoherent if the cap energy ½·C_b·ΔV² is fixed;
    raising peak current with same cap delivers the same total
    energy in less time. Replace with "2× pulse rate **or** 2× C_b
    (with stated area cost — see (f) §3.5)".
12. **References**: 5 OA + 8 paywalled is below the methodology's
    "every reference verified accessible and mirrored" bar.
    Specifically:
    - REF-OA-3 Hecht-Shlaer: provide a working PMC URL or
      JGP archive URL. The paper *is* OA on
      https://rupress.org/jgp/article-pdf/25/6/819/1239876/819.pdf
      (please verify and add).
    - 8 paywalled references should each have an alternate-mirror
      attempt (preprint server, author homepage, ResearchGate-PDF)
      noted, with a clear "not found" if none exists. Per
      methodology §6 "If a paper is paywalled, this is recorded
      and an open-access alternative or pre-print is sought."
13. **Companion files**: §10 admits `solutions.md`,
    `components.md`, `open-questions.md` are reconstructions, not
    independent products. Either:
    - Re-do Stage 1 academic-survey *fully* (committing the agent
      to its own ≥ 5 distinct topologies in `solutions.md`,
      genuine sub-block lists in `components.md`, and concrete
      open questions in `open-questions.md`); or
    - Mark the angle as "in-review/partial" status and treat the
      handoff to Stage 2 as text-only.

#### Cross-cutting
14. CORRECTIONS.md table — confirm the (f) row for `report.md`
    line 352 is closed; add a *new* row tracking the
    `solutions.md` line 20 follow-up correction.
15. Add cross-reference pointers between the three reports.
    Currently each angle stands somewhat alone; the academic-
    survey *does* cross-cite FP/IND, but FP and IND do not
    cross-cite each other or the academic survey. A bidirectional
    "see sister §X" pattern would help Stage 2 reconciliation.

## Closing notes

**Most important finding**: the Karthaus 2003 misattribution. The
academic survey's headline §1.2 — that Karthaus & Fischer's
16.7 µW figure includes an on-die LED — is not supported by the
paper's abstract. The "16.7 µW" is an RF receiver-sensitivity
threshold for a 0.5-µm CMOS RFID transponder. There is no LED in
the paper. Open question Q-AC5 even *admits* the math doesn't
work, but the headline conclusion runs the false claim anyway.
Stage 2 must not propagate this.

**Second-most-important**: the topology-ID-collision pattern from
(a) is unambiguously present in (f). T5 is the worst — it labels
both "rejected boost" (FP/IS) and "live SC voltage doubler" (AC).
Without explicit namespacing, Stage 2 will produce nonsense rows.

**Third**: the 100× T4 cap-area correction in CORRECTIONS.md is
verified correct, but the sweep is incomplete. `solutions.md` and
`components.md` files in two of three angles still carry the old
~50k µm² number. CORRECTIONS.md table needs a follow-up row
opened.

**Talbot-Plateau and Hecht-Shlaer headline claims**: the
*qualitative* findings hold up.
- Greene 2015 (incorrectly cited as "Davis") does report ~2× TP
  deviation at 1.3 µs flashes — directly supports the academic-
  survey's qualitative claim. The "2×" is a high-end value of a
  range Greene-Morrison 2023 reports as 0.85-1.55, so the
  propagation factor into T4 design should be a *range-based
  margin*, not a clean 2× multiplier.
- Hecht-Shlaer 1942's 5-14 photons-absorbed result is historically
  accurate per multiple corroborations (Wikipedia, secondary
  textbooks). The translation from photons to "0.1 µA red-LED
  current" is **under-documented** — my recalculation puts the
  dark-adapted threshold at picoamp scale at typical card-
  distance, ~10⁵× tighter than the academic-survey number. The
  academic-survey number is plausibly the *ambient-lit casual-
  glance* threshold, but should be labelled as such.

**Suspicious-convergence verdict for (f): NO.** The three angles
have distinct evidence bases despite ~85% topology-family overlap
between FP and IND. Each angle adds genuinely original content
(physics in FP, PDK+industrial RE in IND, vision-perception
primary lit in AC). This is not the (k)-style "lazy
copy-from-sister" pattern.

**Topology-ID-collision pattern for (f): YES.** Three independent
collisions (T2, T3, T5) across the three angles. Stage 2 cannot
merge these tables without renaming.

**Companion files for the academic-survey angle are partial
reconstructions**, openly admitted in the report's author's-notes.
Stage 2 should treat this angle's `solutions.md` /
`components.md` / `open-questions.md` as "summaries from the
agent's structured return", not as independent Stage-1 work
products. Either redo or annotate accordingly.
