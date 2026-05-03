---
report_under_review: docs/research/b-nfc-harvesting/stage1-{first-principles,industry-survey,academic-survey}/{report,solutions,components,open-questions,references}.md
reviewer: claude-opus-4-7-1m (reviewer-1, adversarial pass)
date: 2026-05-04
verdict: revisions-requested
---

## Verdict

**revisions-requested** — across all three Stage-1 angles. The
qualitative architectural picture (industry default = R-CC + shunt
regulator + external bulk cap; PDK-leveraged primary = native-nFET
passive bridge or cross-coupled MOS bridge; binding area constraint
= V_REG smoothing cap) is sound and well-supported. However:

1. The (b) industry-survey contains a confirmed **2×
   cap-arithmetic error** ("12 nF in 4 mm² @ 1.5 fF/µm²" — actual
   = 6 nF) that propagates into both the academic-survey and the
   end-to-end policy table.
2. The (b) first-principles report's Faraday-law derivation
   silently treats ISO 14443-2 H-field values as **peak** when
   they are explicitly **rms** in the standard (verified locally in
   the cached PDF). Every V_pk_induced number in §5.1, §5.6 and
   §5.12 is therefore **1/√2 too low**.
3. The academic-survey reference G3 (Sun *et al.* PMC 2021) is a
   citation mismatch — the actual cached/online paper is by
   **Godinho, Yang, Dong, Gonçalves, Mendes, Wen, Li, Jiang** and
   operates at **800 Hz – 51.2 kHz**, not 13.56 MHz. It cannot
   anchor a HF-rectifier dynamic-Vth-cancellation claim.
4. Suspicious convergence on topology family coverage between FP /
   industry / academic exceeds the 70 % threshold (10/12 families
   covered by ≥ 2 reports; 5/12 covered by all 3 with near-
   identical descriptions). Stage 2 must reconcile.
5. None of the (a)-style same-label-different-meaning topology-ID
   collisions are present in (b) (FP uses `R-A…R-I`, industry uses
   `R-IND-* / R-CC / R-AC / R-BS / R-TC`, academic uses `R-PD-* /
   R-CC-academic / R-AC-* / R-TC-Kotani-* / R-GR-* / R-AC-half-
   active` — all distinct prefixes). Cross-report family unification
   *is* still required for Stage 2, but no false collisions exist
   that would corrupt Stage-2 ingestion.

The three reports are individually salvageable (no failure of
template structure, none under 5 distinct approaches, all have
non-trivial negative results), but they need a corrections-pass
before Stage 2 reads them as ground-truth.

---

## Findings

### Reference verification (REQUIRED — 5+ spot-checks via WebFetch)

Web-access constraint: **no IEEE Xplore WebFetch** per parent
guidance. Paywalled IEEE references are reported as
"DOI/abstract-only" without full-text verification.

| Citation | URL/DOI resolved? | Document matches citation? | Local cache present? | Local cache matches upstream? |
|---|---|---|---|---|
| `[USP-8326224]` NXP/Innovision US 8,326,224 | yes (patents.google.com) | **yes** — assignee = Innovision Research and Technology PLC; full bridge with active switched rectifier + passive parallel diode start-up; matches industry-survey §3.1.5 quote | N/A | N/A |
| `[AN12365]` NXP NTAG 5 EH | N/A (local cache) | **yes** — verified by `pdftotext` extraction: "...includes a shunt regulator which provides the configured regulated voltage (EH_VOUT_V_SEL) at Vout"; "If VCC goes below 1.62 V, the system reset will be triggered and NTAG 5 will reboot"; "Low Field Strength <20 mW... High Field Strength >20 mW (<50 mW)" all match industry-survey quotes | yes (`references-cache/AN12365/`) | yes (re-extracted) |
| `[ISO-14443-2]` ISO/IEC 14443-2:2010/Amd 2:2012 | N/A (local cache) | **partly mismatched** — Tables 1 & 2 confirm the *numerical* values 1.5/7.5 (Class 1), 1.5/8.5 (Class 2/3), 2.0/12 (Class 4), 2.5/14 (Class 5), 4.5/18 (Class 6) **but in A/m (rms)**. Reports use the values as if they were peak — see Numerical-claim §1 below. | yes (`references-cache/ISO-IEC-14443-2/`) | yes |
| `[Cha-Energies-2021]` MDPI Energies vol. 14 art. 8089 (D2) | DOI 10.3390/en14238089 — landing fetch returned 403 from this reviewer's pass; metadata previously verified by report author | could not verify content from this pass | not in cache | N/A |
| `[Sun-Sensors-2021]` (G3) PMC 8538867 | yes (pmc.ncbi.nlm.nih.gov) | **NO** — actual title: *"A Dynamic Threshold Cancellation Technique for a High-Power Conversion Efficiency CMOS Rectifier."* Authors are **Godinho, Yang, Dong, Gonçalves, Mendes, Wen, Li, Jiang** — not "Sun, Pan, et al." Operating frequency **800 Hz – 51.2 kHz**, not 13.56 MHz. Peak PCE 94 % at 0.6 V into 500 Ω. Citation in academic-survey/references.md G3 is therefore wrong on (a) authorship, (b) applicable frequency. | not in cache | N/A |
| `[USP-AN12365]` "1.62 V system reset" | local cache | **yes** — exact phrase verified in cached PDF | yes | yes |
| `[Karthaus-Fischer-JSSC-2003]` (C1) faculty mirror | landing 403 from this pass; URL surfaced in author's verification but I could not re-confirm content. The DOI / title / venue are uncontroversial and widely cited. | abstract-only | not yet populated | N/A |

Aggregate: 4 spot-checks fully passed (USP-8326224, AN12365 quotes,
ISO numerical values, AN12365 1.62 V reset), 1 spot-check **failed**
(G3 — citation mismatch), 2 inconclusive due to 403/redirect to
IEEE Xplore which the parent guidance forbids fetching.

**Action required:** academic-survey/references.md must (a) replace
G3's authorship/title with the true Godinho-et-al. citation **or**
remove G3 (because the actual paper is at sub-MHz and is not a HF
rectifier dynamic-Vth-cancellation anchor) and find a different
HF-applicable Vth-cancellation citation; (b) populate the empty
`references-cache/Lu-JSSC-2014/` directory or annotate "intentionally
empty due to paywall, abstract-only verification" in the references
file (currently the empty directory is misleading).

---

### Solution-space coverage

Per-item README required:

- (1) Power-budget — **all 3 reports cover**.
- (2) Antenna topology — FP covers; industry-survey covers
  Cic-as-tuning-cap with full vendor table; academic skips antenna
  catalog (correctly defers to industry-survey).
- (3) Rectifier topology — **all 3 reports list ≥ 8 distinct
  topologies**, more than the README's enumerated set.
- (4) Regulator — FP lists 2 (V-A series LDO, V-B shunt);
  industry-survey lists 3 (V-IND-Sh, V-IND-Series, V-IND-Switched);
  academic-survey defers to industry. **Acceptable** — the README's
  "LDO topologies that can hold ~3.3 V across 3–10 V V_RECT range
  without external compensation" is covered with the explicit
  industry-vs-FP divergence flagged (industry prefers shunt; FP
  defaults to series LDO).
- (5) Over-voltage protection — **all 3 reports cover**, with FP
  coining (C-A) static stack + (C-B) active shunt, industry adding
  (C-IND-LoadModulator) modulator-as-clamp dual-use as a meaningful
  extra finding from patent literature.
- (6) Brown-out detection — **all 3 reports cover**, all 3 list
  Vth-referenced + bandgap-referenced as primary; industry adds the
  power-check current-detection arbitration.
- (7) Physics sanity check — present in all 3 reports' §5; see
  numerical-claim discussion below for issues.
- (8) PDK reality check (no Schottky) — **all 3 reports cover**
  with the same `nfet_06v0_nvt` Vth ≈ −0.039 V verification from
  `sm141064.ngspice` line 119, all three quoting the same line.

**Approaches catalogued by some reports but not others:**

- Single-stage HF Greinacher (R-GR-HF-1stage) is in academic-survey
  only; FP's R-B + R-C cover it as Villard / Greinacher families
  with the verdict "marginal at HF" — no factual disagreement, but
  Stage 2 should retain academic's MDPI Electronics 2023 [I1]
  silicon datapoint.
- Half-active hybrid (R-AC-half-active / R-I) is in FP and academic
  but not industry-survey (industry never reports a shipping
  half-active tag IC). Stage 2 retains it as a risk-mitigated
  fallback.
- Schottky bridge (R-IND-1) is the industry baseline; FP doesn't
  catalog it because PDK has no Schottky. Academic mentions it as
  C1 anchor. Acceptable asymmetry.
- Threshold-cancellation (R-H / R-TC / R-TC-Kotani) is in all three
  but academic alone supplies measured silicon η for the HF-
  applicable Hashemi 2012 [B5] (87 % at 13.56 MHz, 0.13 µm).
  Industry's "rare in commercial 13.56 MHz HF silicon" is consistent
  with academic's "more measured data than industry datasheets
  reveal".

**No README-required topology was silently dropped.**

---

### Premature narrowing

- FP's report §1 enumerates "8 rectifier families plus one hybrid,
  two regulator topologies, two tuning architectures, two clamp
  topologies, two brown-out detector topologies" without picking a
  winner; **§10 author's notes** say "Native-nFET (`nfet_06v0_nvt`)
  recovers most of the Schottky-η story for free" and "Passive
  bridge with native nFETs is competitive with active comparator-
  driven bridges at our power level — and far simpler." This **edges
  toward an opinion** but is properly hedged ("competitive ... at
  our power level"). Borderline acceptable for Stage 1.
- FP's `solutions.md` §"Architectural recommendations to Stage 2
  (without picking a winner)" then lists three combinations as
  Stage-4 deep-dive candidates and explicitly disclaims winner
  selection — this is good discipline.
- Industry-survey's report §1 conclusion **does** opine ("Every
  shipping commercial NFC tag IC ... uses a *cross-coupled (gate-
  driven) active CMOS bridge*"). This is a *factual claim about
  industry*, not a recommendation. Acceptable.
- Industry-survey §10 author's notes #1 says "Stage 2 should
  *probably* pick the same architecture but **must** independently
  re-engineer the energy-storage layer". The "should probably pick"
  is a recommendation expressed as a contingent suggestion. **Borderline
  premature narrowing for Stage 1; soften to "Stage 2 should evaluate
  whether to follow the industry-converged architecture or diverge,
  given that the external-cap assumption built into every commercial
  design is forbidden here."**
- Academic §10 author's notes say "Stage 2 should treat them as one
  design family with a calibration-mechanism axis, not as separate
  options" — this is a **structural recommendation for Stage-2
  ingestion**, not architecture selection. Acceptable.
- No report spends > 40 % of its length on a single approach.
  Length distribution across rectifier families is reasonable.

---

### Numerical claim verification (REQUIRED — 3+ recalculations)

#### 1. **CRITICAL: ISO 14443-2 H-field values are A/m rms, not peak — FP §5.1, §5.6, §5.12 silently treat them as peak**

ISO/IEC 14443-2:2010/Amd.2:2012 Tables 1 & 2 explicitly label the
field-strength column **"A/m (rms)"** — verified by `pdftotext`
extraction of the cached PDF
(`references-cache/ISO-IEC-14443-2/ISO-IEC-14443-2-2010-Amd-2-2012.pdf`):

```
                                 PCD
                       Hmin                Hmax
                      A/m (rms)          A/m (rms)
   PICC 1 (Class 1)      1,5                 7,5
   PICC 2                1,5                 8,5
   ...
```

FP §5.1 plugs `H_pk = 1.5 A/m` and `H_pk = 7.5 A/m` directly into
`V_pk_induced = ω·µ₀·A·N·H_pk`, getting 2.57 V and 12.85 V. Correct
calculation:

```
H_pk = H_rms · √2
H_pk @ Hmin = 1.5 · √2 = 2.121 A/m
H_pk @ Hmax = 7.5 · √2 = 10.607 A/m
V_pk_induced @ Hmin = ω·µ₀·A·N·H_pk = (8.52e7)·(1.257e-6)·(4e-3)·4·2.121
                    = 3.63 V  (FP says 2.57 V; 1.41× too low)
V_pk_induced @ Hmax = (same) · 10.607 = 18.18 V  (FP says 12.85 V)
```

Industry-survey §5.1 **does** correctly multiply by √2 ("(4.3 × √2)")
when using AN11578 Class-5 numbers, so industry-survey is internally
consistent on this point. The disagreement between FP §5.1
(treats RMS as peak) and industry-survey §5.1 (correctly converts
RMS → peak) is itself a Stage-2 contradiction the synthesis must
resolve.

**Downstream impact:**
- §5.6 over-voltage corner: `V_pk_tank @ Q=30 = 12.85·30 = 386 V`
  is currently quoted; corrected = 18.18·30 = **545 V** open-circuit
  (with no clamp). The clamp requirement is *more* strenuous than
  reported, not less. Conclusion ("two-stage clamp mandatory")
  unchanged.
- §5.12 brown-out boundary: `R-D-5V Vpk_ant_min = 3.55 V > Hmin
  V_pk_induced = 2.57 V → fails at compliance Hmin` becomes
  `3.55 V vs 3.63 V → marginal at compliance Hmin (works with no
  margin)`. **The qualitative verdict (5 V Vth Vth bridge fails at
  Hmin) becomes (5 V Vth bridge marginal at Hmin)**. The native-
  nFET path still wins (boundary 2.28 V vs available 3.63 V — easy)
  but the gap is less dramatic than reported.
- §5.10 marginal corner P_DC numbers do **not** depend on V_pk
  (they are k²·P_reader-based). Unchanged.

**Action:** FP §5.1, §5.6, §5.12 must be re-derived with H_pk = H_rms·√2.

#### 2. **CONFIRMED: Industry-survey "12 nF on-die at 1.5 fF/µm² in 4 mm²" is 2× too high**

Industry-survey/report.md line 564:
> Realistic on-die cap ceiling (assume 20 % of a 4 mm² die for the
> storage cap) is **~12 nF at 1.5 fF/µm²**. With the higher 2.0 fF/
> µm² MIM (also available per `sm141064_mim.ngspice` line 68),
> ~16 nF.

Recalculation (units: 1 nF = 1e-9 F = 1e6 fF):
```
4 mm² × 1.5 fF/µm²:
  area = 4 mm² · (1e6 µm² / mm²) = 4e6 µm²
  C    = 4e6 µm² · 1.5 fF/µm² = 6e6 fF = 6 nF  ← report says 12 nF (2× off)
4 mm² × 2.0 fF/µm² = 8 nF  ← report says 16 nF (2× off)
```

The "20 % of 4 mm²" qualification (= 0.8 mm²) makes it worse:
0.8 mm² × 1.5 fF/µm² = 1.2 nF, not 12 nF.

Possible explanations the report might have intended:
- 8 mm² of die, not 4 mm² (factor-2 area mistake)
- Stacking M2-M3 (1.5 fF/µm²) AND M3-M4 (1.5 fF/µm²) in the same
  area gives effective 3.0 fF/µm² — would yield 4 mm² × 3 = 12 nF.
  This is *plausible* for the gf180mcuD MIM stack but **needs to
  be explicitly stated** with verification that the PDK rules allow
  vertical stacking. The first-principles `references.md` does
  list both M2-M3 and M3-M4 1.5 fF/µm² caps, so this is a feasible
  reading — but the industry-survey text doesn't actually say this.

**This is the same 2× discrepancy CORRECTIONS.md flagged as
"pending; not 1000×".** The arithmetic is genuinely 2× off in the
plain reading. The 12 nF / 16 nF numbers further propagate into:

- Industry-survey §5.5: "On-die 12 nF MIM cap holds rail for 1 µs at
  5 mA" — should read 6 nF holds for 0.5 µs at 5 mA. *More
  pessimistic*; verdict "fails at >0.1 mA" sustained, gets stricter.
- Industry-survey §9 comparison table line 858: `~12 nF achievable`
  — should read `~6 nF achievable` (or the stacking explanation
  must be added).
- Industry-survey/solutions.md line 265: "the on-die ceiling is
  ~12 nF in 4 mm²" — same fix.
- **Academic-survey/report.md §5.5 line 246:** *"Sister
  industry-survey §5.5: an on-die 12 nF MIM cap holds the rail for
  1 µs at 5 mA load"* — this is the propagation noted in the
  CORRECTIONS.md sweep. Academic-survey accepted the 12 nF number
  uncritically and now repeats it. Once industry-survey is fixed,
  academic-survey must follow.

**Verdict:** the qualitative conclusion ("on-die bulk-cap budget is
3 orders of magnitude below the 220 nF industry external cap")
holds — 6 nF on-die vs 220 nF external is still ~37×, well within
"orders of magnitude". The verdict is unchanged; the headline number
needs a 2× downward correction.

**Action:** industry-survey/report.md §3.6.2, §5.5, §5.7, §9 line 858;
industry-survey/solutions.md §6 E-IND-OnDie; academic-survey/report.md
§5.5 — fix in place to 6 nF or annotate explicit M2-M3 + M3-M4
stacking justification.

#### 3. V_REG smoothing cap area in FP §5.7 — **CORRECT**

Recalculation:
```
I = 300 µA, Δt = 1 µs (one half-cycle of 847.5 kHz subcarrier),
ΔV = 50 mV
C = I·Δt/ΔV = (300e-6 · 1e-6) / 50e-3 = 6e-9 F = 6 nF  ✓
6 nF / 1.5 fF/µm² = 6e6 fF / 1.5 fF/µm² = 4e6 µm² = 4 mm²  ✓
```

**FP §5.7's binding-area-constraint claim ("~4 mm² MIM at 1.5 fF/µm²")
is arithmetically correct.** This is the well-derived V_REG cap;
the industry-survey 12 nF / 4 mm² claim is a *different* (and 2×
broken) statement about *available* cap area, not *required* cap
size for the modulation pause.

The two reports' numbers are then consistent under the right
reading: FP says we *need* 6 nF (= 4 mm²), industry-survey says we
can *fit* 6 nF (= 4 mm²) — i.e. **just enough, no margin**. This
is exactly the kind of finding that warrants Stage-2 attention —
once the industry-survey 2× error is corrected, the two reports
agree that the design is feasible only if every µm² of the
storage-cap budget is used. There is no slack in the storage cap.

#### 4. Faraday-law power transfer in FP §5.8 — **CORRECT** (within model)

```
P_coupled = k² · P_reader · η_match
          = (0.15)² · 1 W · 0.7
          = 0.01575 W = 15.75 mW  ≈ 16 mW  ✓
P_DC_avail = P_coupled · η_rect · η_LDO
           = 0.01575 · 0.6 · 0.8 = 7.56 mW  (claimed 7.7 mW; small
                                              rounding)
```

The Friis-equivalent for inductive coupling is `P = k²·P_reader`
times the antenna-match factor; this is the standard
power-transfer-formula for resonant LC links, and **does not
violate Faraday/Friis/kTB**. The k = 0.05–0.2 range is consistent
with published phone-tap measurements (Finkenzeller, Fischer-
Karthaus, NXP AN11578 Class-5 at H = 4.3 A/m → ~10 mW at the
rectifier output, which inverts to k² ≈ 0.024, k ≈ 0.15 — agrees
to within engineering tolerance).

**Faraday-violation check:** at H = 7.5 A/m (rms; pk = 10.6 A/m),
N = 4, A = 4e-3 m², ω = 8.52e7 rad/s, the open-circuit AC available
power into a matched load is bounded by `P = V² / 4·ω·L_loop`
(matched-load power on a series tank). At V_pk = 18.2 V and ω·L =
136 Ω, P_max ≈ V_pk²/(8·ω·L) = 304 mW. The claimed 50 mW DC
high-field number from NTAG 5 is well under this bound. ✓

#### 5. Tuning cap value in FP §5.4 — **CORRECT**

```
ω = 2π · 13.56 MHz = 8.52e7 rad/s
ω² = 7.26e15 rad²/s²
C = 1 / (ω²·L) = 1 / (7.26e15 · 1.6e-6) = 8.6e-11 F = 86 pF  ✓
86 pF / 1.5 fF/µm² = 86 000 fF / 1.5 = 57 333 µm²  ✓
```

#### 6. Skin depth in FP §5.3 — **CORRECT**

```
δ = √(2 / (ω·µ·σ))  where σ_Cu = 5.96e7 S/m
  = √(2 / (8.52e7 · 1.257e-6 · 5.96e7))
  = √(2 / 6.382e9)
  = 1.77e-5 m = 17.7 µm  ✓
```

#### 7. PCB-loop unloaded Q in FP §5.3 — needs annotation, not wrong

FP claims `R_ac ≈ 1.5–2 Ω → Q_0 = ω·L/R_ac ≈ 68`. With ω·L =
8.52e7 · 1.6e-6 = 136 Ω, Q_0 = 91 at R = 1.5 Ω, **68 at R = 2.0 Ω**.
The "≈ 68" is therefore the upper-R end of the band. FP should
annotate that the 68 figure assumes R_ac = 2.0 Ω (worst-case
proximity-effect estimate). Not an error — just under-specified.

#### 8. Industry-survey §5.1 "easily reaches 50 V_pk *open*" — **suspicious low**

Industry-survey §5.1 says: "After a Q-loaded tank (Q ≈ 20–30) the
differential antenna voltage easily reaches 50 V_pk *open*..."
Recalculate: at H = 4.3 A/m (rms; the AN11578 anchor), V_pk_open
on a 30 cm² · 4-turn antenna = 7.82 V. With Q = 25, V_tank ≈
**195 V**, not 50 V. The "50 V" figure is ~4× too low. The
qualitative point ("clamp must be active") survives, but the number
is sloppy.

#### 9. Inductance estimate FP §5.2 — **internally inconsistent**

The Mohan-modified-Wheeler formula with the exact constants gives
**L = 2.60 µH** for the 80×50 mm 4-turn rectangular spiral,
matching the report's own derivation arithmetic. FP then says
"working number: L = 1.6 µH (chosen to give a round-number tuning
cap)". The 1.6 µH number is **arbitrary** (the Mohan derivation
gives 2.6 µH; the "non-square correction" hand-wave to 1.5–2.5 µH
is reasonable but doesn't reach 1.6). The actual loop inductance
for the project's 4-turn 80×50 mm spiral is likely closer to
2 µH, not 1.6 µH. Tuning-cap target should be 1/(ω²·2.0e-6) =
**69 pF**, not 86 pF. This affects sizing but not architectural
choice.

**Action:** FP §5.2 should keep the working number at 2.0 µH
(Mohan-derived, conservative non-square correction) and update the
86 pF nominal target accordingly.

#### 10. Faraday/Friis/kTB sweep — **no violations**

- 50 mW high-field harvest claimed by NTAG 5 (industry-survey §5.2)
  is at the Faraday limit but not over it ✓.
- AS3955 22.5 mW (industry-survey §5.3) consistent ✓.
- Carrier 13.56 MHz vs 0.18 µm fT ≈ 50 GHz — no fT problem ✓.
- 92.6 % Ma 2020 PCE — under Carnot trivially ✓.

---

### Negative results

- FP/report.md §7: 7 negative results (NR-1 through NR-7), all
  actionable with conditions. ✓
- Industry-survey/report.md §7: 10 negative results (NR-1 through
  NR-10), with explicit "where it shipped / why it cannot port"
  per item. ✓
- Academic-survey/report.md §7: 10 negative results (NR-1 through
  NR-10), each anchored to a specific paper or first-principles
  fact. ✓

All three reports clear the "≥ 1 negative result with actionable
detail" bar. None say "no relevant failures found".

---

### Convergence with parallel reports — **suspicious convergence flagged**

Reviewer concern from parent agent: ">70 % topology overlap → flag".

Quantitative cross-report family map:

| Family | FP | Industry | Academic |
|---|---|---|---|
| Half-wave | R-A | — | — |
| Villard / 1-stage doubler | R-B | R-IND-3 | (deferred to FP) |
| Multi-stage CW | R-C | R-IND-4 | (rejected list) |
| Schottky bridge | (not applicable) | R-IND-1 | (in C1 anchor) |
| Passive MOS bridge (5 V Vth) | R-D-5V | R-IND-2 | R-PD-baseline |
| Passive MOS bridge (native nFET) | R-D-native | R-IND-2 (variant) | R-PD-native |
| Cross-coupled gate-driven | R-E | R-CC | R-CC-academic |
| Active comparator-driven | R-F | R-AC | R-AC-LeeMok / adaptive / SAR (3 sub-variants) |
| Gate-bootstrap (charge-pump) | R-G | R-BS | (UHF-only note) |
| Vth-cancellation | R-H | R-TC | R-TC-Kotani-self-Vth |
| Half-active hybrid | R-I | — | R-AC-half-active |
| Single-stage HF Greinacher | (R-B/R-C cover it) | (subsumed in R-IND-3) | R-GR-HF-1stage |

**Convergence statistics:**

- 12 distinct families catalogued across the three reports.
- 5/12 (42 %) covered by **all three** reports — passive MOS bridge,
  cross-coupled, active comparator-driven, threshold-cancellation,
  the native-nFET variant.
- 10/12 (83 %) covered by **at least two** reports.
- Reviewer threshold for suspicious convergence: > 70 % overlap.

The 83 % "covered by ≥ 2" overshoots the threshold. The
mitigating factor is that the underlying solution space genuinely
*is* small — published HF NFC rectifier silicon converges on a
narrow set of topologies (NXP, ST, TI, ams all use R-CC + V-Sh,
academic literature is dominated by the HKUST Lu/Mok line). When
the field is genuinely converged, parallel surveys *should* cover
the same set.

**However**, three angles produced reports that:
- All cite the same `nfet_06v0_nvt` Vth ≈ −0.039 V quote at
  `sm141064.ngspice` line 119;
- All quote MIM 1.5 fF/µm² density with reference to
  `sm141064_mim.ngspice` line 14 / line 12;
- All converge on "native-nFET passive bridge is the project-
  specific innovation" finding (this is FP's contribution; industry-
  survey and academic-survey both flag it as "first-principles
  insight not paralleled in shipped silicon or published academic
  papers");
- All adopt the same V-IND-Sh shunt-regulator architectural
  language as preferred regulator topology;
- All quote the same Lu, Li *et al.* ISCAS 2016 0.18 µm 75 % PCE
  number in slightly different framings.

**This degree of cross-citation across the angles is itself
suspicious**, even though no single report demonstrably copied
another. The first-principles report **explicitly says** the
academic-survey and industry-survey were running in parallel,
suggesting the three agents shared draft state at some point. The
academic-survey report **also cites the sister first-principles
report multiple times** in §5 (`Sister first-principles §5.1, §5.8
derives ...`), which is fine for cross-reference but means the
"three independent angles" framing is partially aspirational.

**Recommendation to Stage 2:** treat the three angles as **two
distinct viewpoints** (industry-survey-with-PDK-grounding vs
academic-survey-with-PDK-grounding), with the first-principles
report functioning as a **shared physics layer** rather than a
fully independent third angle. That isn't a defect of the work —
the FP report does add real value, especially the 88 % native-nFET
extrapolation and the 4 mm² V_REG-cap binding-constraint derivation
— but it is not the structurally-independent third angle the
methodology requires. Stage 2 should not double-count its
agreement with the other two as evidence of convergent confirmation.

**Topology-ID collision check (the (a) reviewer's pattern):**

- FP labels: `R-A`, `R-B`, `R-C`, `R-D` (with `-5V` / `-native`
  variants), `R-E`, `R-F`, `R-G`, `R-H`, `R-I`.
- Industry labels: `R-IND-1`, `R-IND-2`, `R-IND-3`, `R-IND-4`,
  `R-CC`, `R-AC`, `R-BS`, `R-TC`.
- Academic labels: `R-PD-baseline`, `R-PD-native`, `R-GR-HF-1stage`,
  `R-CC-academic`, `R-AC-LeeMok-switched-offset`,
  `R-AC-adaptive-delay`, `R-AC-SAR-Ma2020`, `R-TC-Kotani-self-Vth`,
  `R-AC-half-active`.

**No same-label-different-topology collisions** — all three angles
use distinct prefixes. The (a) reviewer's exact concern (same
label `B2`, `B3`, `C1`, `D1`, ... mapping to different topologies
across angles) **does not occur in (b)**. Stage-2 ingestion can
proceed without re-namespacing. The only thing Stage 2 must do is
produce a unification table mapping FP `R-D` → industry `R-IND-2`
→ academic `R-PD-baseline` (etc.), which the academic-survey
already provides in `solutions.md`'s "Cross-cutting comparison vs
the industry-survey sister report" table.

---

### Specific revisions requested

#### To `stage1-first-principles/report.md`:

1. **§5.1, §5.6, §5.12 — Faraday-law RMS-to-peak correction.**
   Multiply every Hmin/Hmax-derived voltage by √2. Re-derive
   §5.12's brown-out boundary with the corrected V_pk_induced ≈
   3.63 V at compliance Hmin. The native-nFET-wins verdict survives
   with a wider margin; the 5 V-Vth-fails-at-Hmin verdict softens
   to "marginal at compliance Hmin (no margin)".
2. **§5.2 — Mohan-derived inductance.** The formula gives 2.6 µH
   for the 80×50 mm 4-turn spiral; the "working number 1.6 µH" is
   arbitrary. Adopt 2.0 µH as the working number with explicit
   "Mohan-square-spiral approximation 2.6 µH; non-square / corner-
   rounding correction yields ~2.0 µH" annotation. Update §5.4 to
   C_tune = 69 pF nominal at L = 2.0 µH.
3. **§5.3 — Q_0 calculation.** Annotate which R_ac value (1.5 vs
   2.0 Ω) produces the quoted Q_0 ≈ 68. Math is consistent at
   R_ac = 2.0 Ω; report should say so.

#### To `stage1-industry-survey/report.md`:

1. **§3.6.2 / §5.5 / §9 line 858 — 12 nF on-die in 4 mm² is a 2×
   error.** At 1.5 fF/µm², 4 mm² = 6 nF, not 12 nF. At 2.0 fF/µm²,
   4 mm² = 8 nF, not 16 nF. Fix to the actual numerical answer
   (6 nF / 8 nF) **or** add an explicit "we assume vertical stacking
   of M2-M3 (1.5 fF/µm²) + M3-M4 (1.5 fF/µm²) MIM, doubling
   effective density to 3.0 fF/µm²" justification with PDK-rule
   citation.
2. **§5.1 "easily reaches 50 V_pk *open*"** — recalculate as ~195 V
   open (V_pk_open · Q ≈ 7.8 V · 25 = 195 V). The 50 V figure is
   ~4× too low.
3. **§10 author's notes #1** — soften "Stage 2 should *probably*
   pick the same architecture" to "Stage 2 should evaluate
   whether to follow the industry-converged architecture or
   diverge". Stage-1 reports must not pre-empt Stage-2/3 decisions.

#### To `stage1-industry-survey/solutions.md`:

1. **§6 E-IND-OnDie (line 265)** — "the on-die ceiling is ~12 nF in
   4 mm²" — fix the 2× arithmetic per item (1) above.

#### To `stage1-academic-survey/references.md`:

1. **G3 Sun-Sensors-2021 citation** — the actual paper at PMC
   8538867 is by **Godinho, Yang, Dong, Gonçalves, Mendes, Wen,
   Li, Jiang** (not Sun et al.) and operates at **800 Hz – 51.2
   kHz** (not 13.56 MHz). Either:
   - (a) Replace with the correct Godinho-et-al. citation **and**
     re-classify it as a low-frequency dynamic-Vth-cancellation
     reference (not the HF anchor it was intended to be), or
   - (b) Find a different HF-applicable dynamic-Vth-cancellation
     citation to replace G3.
2. **Lu-JSSC-2014 cache directory** is empty (`ls -la
   references-cache/Lu-JSSC-2014/` shows only `.` and `..`). Either
   populate with the open-access mirror referenced for A1 (TBioCAS
   2014), or annotate "intentionally empty: paywall-only, abstract
   verified via Semantic Scholar". Currently the empty directory is
   misleading.
3. **A4 (Lu–Ki JSSC 2014) attribution** — the academic-survey
   `references.md` lists A4 with the *same title* as A1 ("A 13.56
   MHz CMOS Active Rectifier With Switched-Offset and Compensated
   Biasing for Biomedical Wireless Power Transfer Systems"). Verify
   that A1 (TBioCAS) and A4 (JSSC) are genuinely two *different*
   peer-reviewed publications and not the same paper double-cited.
   If they are the same, drop A4. If they are different, the title
   field for at least one is wrong and must be corrected.

#### To `stage1-academic-survey/report.md`:

1. **§5.5** — "Sister industry-survey §5.5: an on-die 12 nF MIM cap
   holds the rail for 1 µs at 5 mA load" — propagate the industry-
   survey 2× fix (6 nF, 0.5 µs at 5 mA). The qualitative finding
   ("research gap: no paper measured PCE with on-die-only cap budget")
   is unaffected.

#### Cross-cutting:

1. **All three reports cite the same `sm141064.ngspice` line 119
   in identical form**, suggesting the three agents either copied
   from each other or were given the same shared cheat-sheet.
   Stage 2 should treat the FP report as a "shared physics layer"
   rather than a third independent angle.
2. **Stage-2 synthesis must do its own PDK reading independently**
   to confirm the `nfet_06v0_nvt` Vth ≈ −0.039 V claim (already
   documented but worth a fourth verification).
3. **The 6 nF V_REG cap = 4 mm² figure is the binding area
   constraint of the design.** Once the industry-survey 2× error
   is corrected, FP and industry-survey converge on this. Stage 2
   should pick this up as the load-bearing cross-item constraint
   for (b) ↔ (e) ↔ (f).

---

## Closing notes

**Pattern this review establishes for future (b) reviewers:**

- The "1000× cap arithmetic" pattern from CORRECTIONS.md does *not*
  recur in (b) — but a **2× cap arithmetic** error does, in
  exactly the spot CORRECTIONS.md flagged as pending. Reviewers
  should not assume the simple verification "cap-area numbers
  appear OK" without explicitly recomputing both `nF / fF·µm⁻² →
  µm²` and `mm² × fF·µm⁻² → nF`.
- A subtle **RMS-vs-peak** error in the Faraday law derivation
  cuts every induced-voltage number by √2. ISO/IEC 14443-2's H-
  field tables are explicitly labelled `A/m (rms)`; reviewers must
  verify against the cached PDF, not the report's prose.
- Where a paywalled IEEE reference is cited "abstract-only" per
  parent guidance, that is acceptable — but **open-access
  citations** (PMC, MDPI, DOAJ) are *not* exempted from
  full-content verification. The G3 PMC mismatch demonstrates that
  an "open-access verified" annotation can still hide a citation
  error if the reviewer trusts the previous report author's claim
  rather than re-fetching.
- The (b) item has unusually deep PDK-shared content across all
  three angles, weakening the "three independent angles" guarantee.
  This is an *architecture* of the research, not a defect of any
  one report; future items where the PDK ground truth is also load-
  bearing should be aware of this pattern.

**Items I did NOT exhaustively check:**

- Lu-JSSC-2014 (A4) full content — paywalled IEEE Xplore, parent
  guidance forbids fetch.
- Karthaus-Fischer JSSC 2003 (C1) faculty mirror — landing returned
  403 from this pass; previously verified by report author.
- Mandal-Sarpeshkar TCAS-I 2007 (C2) and 2009 (C3) — paywalled.
- Hashemi-Sawan-Savaria TBioCAS 2012 (B5) — paywalled. The 87 %
  PCE at 13.56 MHz figure is widely cited; no obvious reason to
  doubt, but a future reviewer with institutional access should
  spot-check.
- Cha-MDPI-Energies-2021 (D2) DOI 10.3390/en14238089 — landing
  return 403 from this pass; previously verified by report author.

These are flagged in the references-verification table at the top
of this review. None individually invalidates the work; collectively
they are the predictable consequence of the parent agent's
"≤ 10 WebFetch / no IEEE Xplore" budget.

**Verdict reaffirmed:** revisions-requested on all three reports,
with the FP Faraday RMS-to-peak fix and the industry-survey 2×
cap arithmetic fix as the two highest-priority corrections. Once
these are addressed, the reports are ready for Stage-2 synthesis.
