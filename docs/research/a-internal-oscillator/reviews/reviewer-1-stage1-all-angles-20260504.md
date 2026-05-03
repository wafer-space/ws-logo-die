---
report_under_review: docs/research/a-internal-oscillator/stage1-{first-principles,industry-survey,academic-survey}
reviewer: reviewer-1 (claude-opus-4-7-1m)
date: 2026-05-04
verdict: revisions-requested
---

## Verdict

**revisions-requested.**

All three Stage-1 reports are substantive, exceed the 5-topology floor,
include negative results, and avoid picking a winner in the executive
summary. None are "fail"-worthy. However, **all three contain at least
one defect that must be fixed before Stage 2 can build on them**. The
defects fall into three buckets:

1. **A widespread topology-ID collision** between the
   `stage1-first-principles` and `stage1-industry-survey` reports.
   Same letter+digit IDs (`B2`, `C1`, `D1`, `E1`, `G2`, `H1`, etc.)
   denote *different topologies* in each report — far worse than the
   single "G2" the orchestrator originally flagged, and **fatal for
   Stage 2 ingestion as written**. The academic survey wisely used the
   `AC-*` prefix and avoided this trap.
2. **Two independently-verifiable arithmetic errors** in
   `stage1-first-principles/report.md` §5.4 and §5.11 that materially
   change downstream conclusions (one by ~2-3x, one by ~1000x).
3. **Two citation errors** in `stage1-academic-survey` that would
   embarrass anyone trying to track the references back to source —
   one wrong author attribution, one wrong topology family
   description.

The reports collectively cover the solution space well; the breadth
is genuinely good. The defects are local, fixable, and do not warrant
restarting from scratch.

## Findings

### Reference verification

Spot-checks via WebFetch (IEEE Xplore deliberately skipped per
instructions). Eight references were checked.

| Citation | URL/DOI resolved? | Document matches citation? | Local cache present? | Local cache matches upstream? |
|---|---|---|---|---|
| `[USP-6020792]` (industry, Microchip relax-osc patent) | yes | partially — see note below | yes (`references-cache/us6020792/`) | not byte-checked, summary-only |
| `[USP-8222940]` (industry, TU Delft thermal-diffusivity) | yes | yes — abstract claims `±0.1 % from -55 to 125 °C, 7.8 mW from 5 V, 1.6 MHz` matches industry §6 / FP §rejected | yes | summary-only |
| `[USP-9344070]` (industry, TI 3-OTA) | yes | yes — patent body confirms "drift less than 0.5 % over a 100-year operating time at body core temperature" verbatim | yes | summary-only |
| `[Hsiao-2023]` PMC10361407 (academic, AC-RC-2) | yes | **NO** — see "Citation defect AS-CIT-1" below | N/A | N/A |
| `[Choi-2016]` Blaauw lab PDF (academic, AC-FLL-1) | yes (URL resolves) | partial — WebFetch returned only PDF binary stream; could not extract text. URL exists. Title/venue cross-check via search hits succeeded. | N/A | N/A |
| `[Lee-2016]` PMC4989868 (academic, AC-SUB-1) | yes | **NO** — see "Citation defect AS-CIT-2" below | N/A | N/A |
| `[QualcommNFCCDR-2013]` US9124413B2 (academic, AC-FLL-4) | yes | yes — Google Patents shows title "Clock and data recovery for NFC transceivers", assignee Qualcomm, inventor Jafar Savoj | N/A | N/A |
| `[GF180-MABRAINS]` (industry/FP) | yes | yes — repository README lists `Ring-Osc-3.3vFETs`, `Ring-Osc-5.0vFETs`, `XTAL-Osc-16M`, `XTAL-Osc-100M` exactly as described | yes (`references-cache/gf180-mabrains/`) | summary-only |

#### Note on `[USP-6020792]` content match

Industry-survey §5.4 states "USP-6,020,792 '1 ppm/C at 4 MHz' headline".
The patent's abstract and claims do **not** make a 1 ppm/°C performance
claim. The patent body discusses 1 ppm/°C as an *objective* and as an
"example benchmark" of what would constitute a desirable target,
without claiming the demonstrated implementation reaches it. The
industry-survey's framing is partially correct in calling it a
"patent-claim headline that is rarely seen in production silicon", but
the underlying patent never makes the headline claim it is being
attributed. **Industry-survey §5.4 should be reworded** to "1 ppm/°C
is named as the target in USP-6,020,792's specification but is not a
measured demonstration." Minor but the kind of detail that destroys
reviewer trust if missed.

#### Citation defect AS-CIT-1 (academic survey, AC-RC-2 / Hsiao-2023)

The academic-survey solutions.md attributes paper PMC10361407 to
"K.-J. Hsiao, *A 254-nW 20-kHz On-Chip RC Oscillator With 21-ppm/°C
Minimum Temperature Stability and 10-ppm Long Term Stability*". The
PMC page actually shows the authors as **Nikita Mirchandani and
Aatmesh Shrivastava**, not Hsiao. The title is correct; the authorship
is wrong. The corresponding `[Hsiao-2023]` entry in references.md
inherits this error. **This is a verifiable factual mistake** —
WebFetch on the PMC URL returns the correct authors. All references
to "Hsiao" in the academic-survey reports must be replaced with
"Mirchandani / Shrivastava".

#### Citation defect AS-CIT-2 (academic survey, AC-SUB-1 / Lee-2016)

The academic-survey describes AC-SUB-1 (`[Lee-2016]`, PMC4989868) as a
*"Dynamic Leakage Suppression (DLS)"* ring oscillator, with
"sub-pW gate leakage" charging the stage capacitances. This **is not
what the paper describes.** The actual Lee/Sylvester/Blaauw 2016 JSSC
paper is titled "A Constant Energy-Per-Cycle Ring Oscillator Over a
Wide Frequency Range for Wireless Sensor Nodes" — it is a CERO design
that "avoids short-circuit current by minimizing the time spent in
the input voltage range" using back-to-back inverter stages. Energy
per cycle is constant at 0.8 pJ/cycle over 1.2 Hz to 60 MHz. **It is
not a DLS architecture.** DLS is associated with a different
Blaauw-group paper (`[LeeYang-2020]` CICC). The academic-survey
conflates two distinct topologies into one entry. AC-SUB-1's
negative-result Q-AC-1 dependency on GF180MCU 5 V thick-oxide gate
leakage is *overdrawn* — the CERO topology described in
PMC4989868 does not depend on gate leakage at all (it depends on
short-circuit-current avoidance via input-slope control).

### Solution-space coverage

Counts (from each report's own summary tables):

- `stage1-first-principles/`: 30 distinct entries across 9 families
  (A-I). Includes both simplest dumb (A1 raw ring) and most
  sophisticated (G2 three-tier with NFC FLL, C3 PCB-loop tank
  cold-clock).
- `stage1-industry-survey/`: 26 entries across 9 families (A-I) plus
  18 explicit rejections (J1-J18) = 44 total. Strong on the simplest
  end (A1 ATmega watchdog), reasonable on the sophisticated end
  (B3 PTAT/CTAT compensated, F1 thermal-diffusivity).
- `stage1-academic-survey/`: 15 entries across 7 families (AC-RC,
  AC-FLL, AC-SUB, AC-CHOP, AC-RES, AC-CK, AC-LC) plus 6 explicit
  rejections (AC-NEG-*). **Below the implicit "30+ entries" bar set
  by the sister reports**, but the methodology bar is "5+ distinct
  approaches", which AC easily exceeds.

#### Approaches mentioned in the per-item README that any report omitted

The README's scope explicitly lists "ring, RC relaxation, RC twin-T,
Wien bridge, LC tank, mode-locked, MEMS-on-die, self-biased,
current-starved, chopper-stabilised, sub-threshold, FBAR, and any
thermistor / temperature-compensated variants." Coverage check:

- ring — covered (all three)
- RC relaxation — covered (all three)
- RC twin-T — covered (FP B4)
- Wien bridge — covered (industry C2, academic AC-CHOP-1)
- LC tank — covered (FP C1, industry H1, academic AC-LC)
- **mode-locked** — **MISSING** in all three reports. FP §F mentions
  "mode-locked-laser-on-die" only as a rejected exotic. Mode-locked
  oscillators (e.g. mode-locked LC, harmonic mode-locking,
  superharmonic injection-locked) are not covered by any of the
  three reports as a topology family. Each individual report can
  be excused (mode-locked is exotic in 180 nm), but the *aggregate
  omission* against the README's enumerated scope is a Stage-2
  gap-analysis flag.
- MEMS-on-die — covered (industry D3, FP F1)
- self-biased — covered (FP A4)
- current-starved — covered (FP A2, industry A2)
- chopper-stabilised — covered (academic AC-CHOP)
- sub-threshold — covered (all)
- FBAR — covered (industry D2, academic AC-NEG-2)
- thermistor / temperature-compensated — covered (industry B3, AC-RES)

#### Approaches sister reports covered that this one did not (for each report)

- **stage1-first-principles missed**:
  - The Wien-bridge chopper-stabilised reference (AC-CHOP-1, Makinwa).
    FP B4 mentions Wien-bridge as legacy / rejected for being a
    sinewave; FP misses that Wien-bridge with chopping has a *different*
    profile (TC-flat, used for frequency references in published silicon
    at 87 µA / 1.8 V).
  - SOF/packet clock-recovery as a distinct industry pattern (industry
    E4). FP's E1/E2 cover injection-lock and FLL but not the
    SOF/CRS-style trim with eFuse storage, which is the most
    industry-relevant variant for our use case.
  - Pelgrom matching theory as a hard floor on trim resolution (academic
    AC-FOM-2). FP §5.9 cites "<0.1 %" cap matching from memory but
    doesn't anchor it in the canonical Pelgrom relations.
- **stage1-industry-survey missed**:
  - C3 (FP) using the NFC PCB-loop antenna's *own* LC resonance as a
    cold-clock reference. This is the headline novel finding from
    first-principles and industry didn't independently surface it.
  - Self-biased ring's V_DD-tracking as a *feature* for graceful
    brown-out (FP A4 reframed). Industry A2 covers current-starved
    rings but not the brown-out angle.
  - The Choi/Blaauw resistive FLL with sigma-delta DCO (academic
    AC-FLL-1) — industry's C1 lumps this under "RC-bridge FLL" without
    naming the silicon precedent that exactly matches the brief's
    "Sigma-Delta capacitor banks, current-DAC bias" target.
- **stage1-academic-survey missed**:
  - C3 PCB-loop cold-clock (FP).
  - C4 bondwire-tank (FP) — academic AC-LC-2 covers Ham/Hajimiri but
    only as a methodological reference, not as a serious BLE
    candidate.
  - Self-biased ring as graceful-brown-out (FP A4).
  - Switched-cap relaxation oscillator (FP B3) — academic angle
    catalogues swap-cap (AC-RC-1) but not the switched-capacitor
    "frequency = I/(C·V)" topology FP B3 describes for cap-ratio
    precision.
  - Several rejected exotics (memristor, photo, chemical) covered in
    sister reports' completeness tables.

### Premature narrowing

- `stage1-first-principles/report.md`: rough length distribution by
  topology family (sampled by line count in `solutions.md`):
  Family A ~124 lines, B ~77, C ~95, D ~38, E ~70, F ~38, G ~25,
  H ~10, I ~25. No single approach dominates >40 %. **Pass.**
- `stage1-industry-survey/report.md`: §3 paragraph-per-family and §9
  comparison table give roughly even coverage. **Pass.**
- `stage1-academic-survey/report.md`: AC-FLL-1 (Choi/Blaauw) gets
  flagged as "the closest published silicon precedent" repeatedly but
  doesn't dominate any one section. **Pass.**

#### Executive summary opinion check

- FP §1 says *"the most project-defining first-principles findings are
  C3, G2, A4."* Borderline — Stage-1 reports must not pick a
  winner. FP couches it as "headline contributions of the first-
  principles angle" rather than "the best approach", and goes on to say
  "this document does not pick a winner — that's Stage-3's job"
  explicitly. **Borderline pass.** Recommend reword "most
  project-defining" → "most distinctive contributions of this
  angle".
- FP §1 also states *"A two-physical-oscillator architecture is the
  cleanest fit"* — this *is* an opinion about which approach is best
  and **does violate the Stage-1 prohibition.** Required revision.
- Industry-survey §1 says *"B2 + E4 (or equivalently I3) as the
  dominant industry pattern that fits our use case but explicitly
  defers selection to Stage 3."* Borderline. The "dominant industry
  pattern" framing is an empirical observation rather than an opinion;
  acceptable. The phrase "fits our use case" leans into recommendation
  territory. Recommend softening.
- Academic-survey §1 says *"a three-block architecture: AC-SUB-3 …
  + AC-FLL-1 or AC-RC-4 + AC-FLL-4 … all three blocks have published
  silicon … all three are implementable."* **This is a strong opinion
  about the best architecture and does violate the Stage-1
  prohibition.** Required revision.

So **all three reports' executive summaries lean past the Stage-1
prohibition to varying degrees**; FP and academic explicitly over the
line. This is the most consistent flaw across the three.

### Numerical claim verification

Three first-principles recalculations performed by this reviewer
(math shown).

#### NCV-1: FP §5.4 — NFC PCB-loop tank `omega*L` value (FAILS)

FP §5.4 states verbatim: *"Q_intrinsic = ω·L/R = 2π·13.56e6·1.3e-6 /
3.4 ≈ 32"* and elsewhere in the same section *"ω·L = 45 Ω"* used to
set up the cross-coupled FET `g_m` requirement (`g_m ≥ 2/R_p =
2/(ω·L·Q) = 2/(45·12) ≈ 4 mA/V`).

Recalculation:

```
omega = 2*pi * 13.56e6 = 8.520e7 rad/s
omega * L = 8.520e7 * 1.3e-6 = 110.76 Ω        (NOT 45 Ω)
Q_intrinsic = 110.76 / 3.4 = 32.6              (matches "~32")
```

So Q ≈ 32 is correct, but **the intermediate value `ω·L = 45 Ω` used
two paragraphs later to derive `g_m ≥ 4 mA/V` is internally inconsistent
with the same section's L = 1.3 µH**. With the correct ω·L = 111 Ω,
R_p = ω·L·Q_loaded = 111 * 12 ≈ 1330 Ω, and g_m needed is `2/R_p ≈
1.5 mA/V`, not 4 mA/V. The FP report's downstream conclusion ("C3
needs ~500 µA, not 100 µA") may still hold qualitatively, but the
specific factor (~4× bias-current shortfall) is wrong; with corrected
math the shortfall at 100 µA bias is closer to ~1.5×. **FP §5.4 must
re-do the cross-coupled g_m calculation with the correct ω·L.**

#### NCV-2: FP §5.11 — cold-start storage cap requirement (FAILS BADLY)

FP §5.11 states: *"For I_q = 100 µA and t = 5 ms: Δv = 0.5 V·µF / C.
To keep droop below 0.5 V we need C ≥ 1 nF on the harvested rail.
Within MIM budget (1 nF is 500 × 1000 µm² at 2 fF/µm² = 0.5 mm²)."*

Recalculation:

```
delta_v = I_q * t / C
I_q * t = 100e-6 A * 5e-3 s = 5e-7 C = 0.5 uC

For C = 1 nF:
delta_v = 5e-7 / 1e-9 = 500 V               (!)

For delta_v <= 0.5 V:
C >= I*t/dV = 5e-7 / 0.5 = 1e-6 F = 1 uF    (NOT 1 nF)
```

**The FP report is off by a factor of 1000.** A 1 nF storage cap with
100 µA load and 5 ms cold-start gives 500 V of droop, not 0.5 V. The
correct requirement is 1 µF. At 2 fF/µm² that is **500 mm²** — three
orders of magnitude larger than any sane on-die budget. **The "Within
MIM budget" assertion is provably false.** This is a real conclusion-
changing error: it means the stated cold-start budget cannot be met
on-die without either (a) a much smaller I_q (e.g. sub-µA bandgap
during cold-start) or (b) an off-die smoothing cap (which violates
the no-passives constraint). FP must redo §5.11 and reconsider
whether item (e) (the smoothing-cap subsystem) requires re-scoping.

#### NCV-3: Industry §5.1 — ATmega watchdog spread (PASSES)

Industry §5.1 claims the 76–180 kHz ATmega watchdog spread (V_CC
2.7-5.5 V) is consistent with `t_pd ∝ V_DD/(V_DD - V_T)²`, ratio
factor 2.4× over the supply range with V_T ≈ 0.7 V.

Recalculation:

```
V_DD - V_T at 5.5 V = 4.8 V
V_DD - V_T at 2.7 V = 2.0 V
Ratio of (V_DD - V_T): 4.8 / 2.0 = 2.4
Observed ratio: 180 / 76 = 2.37
```

**Matches.** Industry §5.1 is correct.

#### NCV-4: Academic §5.6 — Pelgrom-floor for 8-bit current-DAC (PARTIAL)

Academic §5.6 claims "AVt = 5 mV·µm for 240/180 nm. For a current-DAC
unit cell with W·L = 1 µm² and a 1 V V_GS, σ_VT/V_GS = 0.5 %; this
maps to σ_I/I = 1 % via the saturation drain current formula."

Recalculation:

```
sigma_VT = AVt / sqrt(W*L) = 5 mV*um / sqrt(1 um^2) = 5 mV
sigma_VT / V_GS = 5 mV / 1 V = 0.5 %                        OK matches

For saturation:
sigma_I / I = 2 * sigma_VT / (V_GS - V_TH)
If V_GS = 1 V and V_TH ~= 0.5 V (a generous assumption for 5 V GF180MCU):
V_GS - V_TH = 0.5 V
sigma_I / I = 2 * 5 mV / 500 mV = 2 %                       (NOT 1 %)
```

The 1 % claim is correct only if either (a) V_GS - V_TH = 1 V (which
implies V_GS = 1.5 V, not 1 V, for a V_TH ≈ 0.5 V device), or (b) the
report meant V_GS ≈ V_overdrive directly (i.e. ignored V_TH).
**Likely author conflated V_GS with V_overdrive.** Numerically modest
discrepancy, but the academic report should distinguish V_GS from
V_overdrive explicitly.

#### Physics-floor cross-cut

No claim in any of the three reports violates kTB, Carnot, Friis, or
fT. The Choi/Blaauw 110 nW @ 70 kHz is well above the
Boltzmann/Landauer thermodynamic clock-energy bounds; sub-threshold
picowatt designs are well above the Landauer limit per cycle. The
2.4 GHz LC Q estimates (Q ≈ 3-6 on stock GF180MCU, Q ≈ 8-12 with
thick-top-metal) are consistent with the metal sheet-R, skin-depth,
and substrate-loss physics for 180 nm nodes. **No physics-violation
findings.**

### Negative results

All three reports include explicit §7 negative results:

- FP §7: 6 entries (C3 always-on collapse, sub-threshold biasing
  not automatic, on-die Q overestimate, RC ±1 % brown-out, XTAL
  rejection, bondwire-tank below 1 GHz). **Substantive.**
- Industry §7: 7 entries (1 % transferable, no PDK osc, FBAR/CMEMS
  process incompat, ambient 2.4 GHz, HOCO needs firmware, ST app-note
  fetch failures). **Substantive.**
- Academic §7: 6 entries (Jiang 2.5 ppm/C transferability,
  Wien-bridge power, gate-leakage on thick oxide, sub-threshold
  biasing on 5 V, sigma-delta limit-cycle, FLL during NFC modulation).
  **Substantive.**

All meet the "more than 'no relevant failures'" bar. **Pass.**

### Convergence with parallel reports

#### Topology-ID collision (CRITICAL FINDING)

The orchestrator originally flagged "G2" as a possible collision. The
collision is far worse than that — **almost every short ID collides**
between FP and industry-survey:

| ID | FP meaning | Industry meaning | Same concept? |
|---|---|---|---|
| `B1` | classic comparator-RC | Schmitt-RC | similar |
| `B2` | bias-stabilised RC | bandgap dual-cap RC | similar |
| `B3` | switched-cap relax | PTAT/CTAT-compensated | DIFFERENT |
| `B4` | Wien-bridge | TI 3-OTA | DIFFERENT |
| `C1` | LC cross-coupled NMOS | RC-bridge FLL | DIFFERENT |
| `C2` | LC class-C | Wien-bridge sine | DIFFERENT |
| `D1` | sub-threshold ring | Pierce XTAL | DIFFERENT |
| `D2` | gm/C sub-threshold | FBAR/BAW | DIFFERENT |
| `D3` | (none) | CMEMS | n/a |
| `E1` | FLL to slow ref | NFC carrier divider | DIFFERENT |
| `E2` | injection-lock to NFC | Qi divider | DIFFERENT |
| `E3` | carrier-clk (NFC) | ambient 2.4 GHz | DIFFERENT |
| `E4` | (none) | SOF/packet trim | n/a |
| `F1` | MEMS | thermal-diffusivity | DIFFERENT |
| `F2` | thermal | RRAM | DIFFERENT |
| `F3` | photo | PTAT-bandgap-only | DIFFERENT |
| `G1` | hybrid 2-tier | sub-threshold ring | DIFFERENT |
| `G2` | hybrid 3-tier NFC | beta-mult sub-threshold | DIFFERENT |
| `H1` | true-random clock | LC tank | DIFFERENT |
| `H2` | spread-clock | (none) | n/a |
| `I1` | no-osc-VGA | external-clock-pass | similar |
| `I2` | no-osc-NFC | multi-osc system | DIFFERENT |
| `I3` | no-osc LED-fallback | NFC-carrier + ring | DIFFERENT |

**This is fatal for Stage-2 ingestion as written.** Stage 2 will read
both reports and have no way to know whether `B3` means
switched-cap (FP) or PTAT/CTAT-compensated (industry) without
manually reading every entry. The methodology calls for "stable short
identifiers across reports"; FP and industry violate this badly.

The academic survey wisely used the `AC-*` prefix (`AC-RC-1`,
`AC-FLL-1`, `AC-SUB-1`, etc.) and provides a cross-reference table
mapping its IDs back to FP/industry IDs. This is the right pattern.

**Required revision: one of FP or industry must rename its IDs to a
non-colliding scheme (e.g. `FP-A1` / `IND-A1`).** Or both must adopt
the academic-survey's `AC-*`-style namespacing. Stage-2 cannot
proceed meaningfully without this.

#### Concept-level overlap (SAFE)

Counting concepts (not IDs) common to FP and industry-survey:

- ring osc, current-starved ring, classical RC relax, bandgap-stable
  RC, LC tank (on-die), sub-threshold ring, FLL/SOF-style trim,
  carrier-derived clock, MEMS, thermal-diffusivity / electrothermal,
  XTAL (rejected), no-osc / multi-osc / hybrid architectures.

That is roughly 12 shared concepts out of FP's 30 entries and
industry's 26 entries — about 40-50 % overlap. **Below the 70 %
"suspicious convergence" threshold.** Each report contributes
genuinely novel material:

- FP-only contributions: PCB-loop cold-clock (C3), bondwire-tank
  (C4), self-biased ring as brown-out feature (A4 reframed),
  switched-cap relaxation as ratio-precise sub-rate (B3).
- Industry-only contributions: corner-sensed ring (A3), 3-OTA native
  offset cancellation (B4), RC-bridge FLL (C1), Qi-carrier divider
  (E2), SOF/CRS-style trim (E4), thermal-diffusivity reference (F1),
  RRAM-R reference (F2), PTAT-bandgap-only LF osc (F3).
- Academic-only contributions: swap-cap offset cancellation
  (AC-RC-1), voltage-averaging-feedback (AC-RC-4),
  leakage-compensated 8.1 nW relaxation (AC-RC-5), resistive FLL
  with sigma-delta DCO (AC-FLL-1), digital FLL TC-domain
  compensation (AC-FLL-2), CERO Hz-range ring (AC-SUB-1, despite
  the misnaming defect), capacitive-discharging bandgap-free osc
  (AC-SUB-3), Pelgrom matching floor (AC-FOM-2), MOM cap mismatch
  (AC-FOM-3), NIST ring Allan-deviation (AC-FOM-4).

**The three reports are usefully complementary, not redundant.**
This is the healthy methodological state — *no* suspicious
convergence detected.

#### Detail-level convergence

Both FP and industry independently identify the *same architectural
skeleton*: NFC-carrier as the precision reference + a free-running
ring/RC for housekeeping + eFuse trim. They differ on details (FP
prefers FLL E1; industry prefers SOF/CRS E4-style trim). The academic
survey adds Choi/Blaauw AC-FLL-1 as the silicon precedent. **Triple
convergence on architecture, divergence on mechanism.** This is the
right Stage-2 input.

### Specific revisions requested

Numbered list of concrete changes required before Stage-2 can ingest:

#### Cross-cutting

1. **Adopt non-colliding topology IDs** across FP and industry-survey.
   Either use a namespace prefix (`FP-A1`, `IND-A1`) or rename one
   set entirely. Update every `solutions.md`, `report.md` §9 table,
   and `components.md` reference. Sister academic-survey already uses
   `AC-*`; mirror that pattern.

#### `stage1-first-principles/`

2. **Fix §5.4 `omega*L` arithmetic.** Use ω·L = 111 Ω (for L = 1.3 µH)
   and re-derive the cross-coupled g_m requirement; current ~4 mA/V
   number is wrong, correct is ~1.5 mA/V. Update the downstream "C3
   needs 500 µA" claim with the corrected number.
3. **Fix §5.11 cold-start cap calculation.** Required C is ~1 µF, not
   1 nF, for I_q = 100 µA / 5 ms / Δv = 0.5 V. The "Within MIM budget"
   assertion is wrong by 1000×. Either reduce the cold-start I_q
   target dramatically (sub-µA bandgap during cold-start) or
   acknowledge that on-die-only smoothing cannot meet the stated
   spec, and update item (e)'s scoping accordingly.
4. **§1 executive summary** — reword "A two-physical-oscillator
   architecture is the cleanest fit" to a non-recommendation phrasing.
   Stage-1 must not pick a winner.
5. **§5.8 (injection-lock pull-in)** — Adler's equation as written
   `Δω = ω₀ · √(I_inj/I_osc) / (2Q)` is missing a square-root
   structure for the canonical form; the standard form is
   `Δω = ω₀ · I_inj/(2·Q·I_osc)` for weak injection. Verify and
   re-derive — the qualitative conclusion (E2 needs trim within
   ±2.5 %) is plausible but the formula needs a sanity check.
6. **References §6** — only 5 references; for a first-principles
   document this is acceptable per the methodology, but the FP
   report explicitly relies on textbook-formula values (Razavi)
   without citing exact pages. At minimum, page references for the
   bandgap settling formula (R3) and the Maneatis self-biased ring
   (R6) should be added.
7. **Missing references.md file.** TEMPLATE.md mandates a separate
   `references.md` for every Stage-1 report; first-principles has the
   bibliography inline in `report.md` §6 only. Either create a
   stand-alone `references.md` (preferred for parallel-report
   alignment) or document the deliberate departure in the front
   matter.

#### `stage1-industry-survey/`

8. **§5.4 USP-6,020,792 wording** — change "1 ppm/°C at 4 MHz
   headline" to "1 ppm/°C target stated as objective in the patent
   specification, not claimed as measured silicon." The patent's
   abstract makes no such claim; the claim is rooted in the body's
   stated objectives.
9. **References table** — six entries are listed as "search-resolved
   only" (ST-AN2868, ST-AN4736, ST-AN5067, NXP-NTAG213, NXP-AN4905,
   TI-SLAA336, TI-SLAA992). The methodology requires references to
   be *verified to exist and be accessible*. WebFetch timeout is
   not "verified"; confirm via curl, web.archive.org, or
   institutional access. **Six unverified references is a real gap.**
10. **Mabrains ring-osc cells** — the report cites
    `Ring-Osc-3.3vFETs` and `Ring-Osc-5.0vFETs` as Apache-2.0 layouts
    with "no measured-silicon numbers." The Mabrains repo's IP is
    open; consider including an actual frequency-vs-PVT extraction
    via SPICE in Stage 4 (deferred). For Stage 1 this is fine;
    flagged for Stage-4 deep-dive if industry path is shortlisted.
11. **§1 executive summary** — soften "B2 + E4 (or equivalently I3) as
    the dominant industry pattern that fits our use case" to remove
    the implicit recommendation. Stage-1 must not pick a winner.

#### `stage1-academic-survey/`

12. **AC-RC-2 / [Hsiao-2023] author correction.** The PMC10361407 paper
    is by Mirchandani and Shrivastava, not Hsiao. Fix authorship in
    `solutions.md`, `references.md`, `report.md` §5.4, and the
    comparison table. **This is the most embarrassing single defect
    across the three reports.**
13. **AC-SUB-1 / [Lee-2016] topology correction.** The Lee/Sylvester/
    Blaauw 2016 JSSC paper at PMC4989868 is the **CERO** (Constant
    Energy-per-Cycle Ring Oscillator) topology, not Dynamic Leakage
    Suppression. DLS is the Lee/Yang 2020 CICC paper (`[LeeYang-
    2020]`) — distinct architecture. Fix the description; merge AC-
    SUB-1 with AC-SUB-2 if appropriate, or split into two distinct
    entries. The negative-result NA-3 ("gate leakage doesn't transfer
    to thick oxide") applies to AC-SUB-2 (Lin 2007) only, not to
    AC-SUB-1 (Lee 2016 CERO).
14. **§1 executive summary** — the "three-block architecture: AC-SUB-3
    + AC-FLL-1 or AC-RC-4 + AC-FLL-4" framing crosses into Stage-3
    territory. Reword as a candidate composite for Stage-3 evaluation
    rather than as the integrated recommendation.
15. **AC-FLL-4 attribution** — the academic survey labels Yao 2009
    (UHF, 900 MHz) and Park 2009 (HF, 13.56 MHz) both as AC-FLL-4
    components. Yao 2009 is UHF (Trans IE, not JSSC) and is *not* a
    direct precedent for HF NFC; only Park 2009 and Yu 2010 are
    relevant to the wafer.space NFC mode. Either split AC-FLL-4 into
    HF/UHF entries or remove the Yao 2009 cross-reference.
16. **Pelgrom σ_I/I derivation in §5.6** — the 1 % claim assumes
    V_GS = V_overdrive (V_GS - V_TH). For typical 5 V GF180MCU
    devices, V_TH ~0.5-0.7 V means V_overdrive at V_GS = 1 V is
    only 0.3-0.5 V; corrected σ_I/I is ~2 %, not 1 %. Re-derive with
    an explicit V_overdrive value for the target device.
17. **components.md / open-questions.md content audit** —
    the academic survey's `components.md` and `open-questions.md`
    are heavier on cross-references to sister reports than on
    standalone substance. For Stage 1 to be considered
    research-complete in itself, both files should add silicon-
    referenced content. (Reviewer did not deeply audit these two
    files; flagging for the next reviewer.)

#### Stage-2 prep

18. **Mode-locked oscillators are not covered** in any of the three
    reports as a topology family, despite being named in the README's
    Stage-1 scope. Either add a mode-locked entry to one of the
    surveys, or amend the README to acknowledge mode-locked is
    out-of-scope for Stage 1 with explicit reasoning.

## Closing notes

### Research-completeness vs DoD

By the METHODOLOGY definition-of-done for Stage 1 ("at least three
Stage-1 surveys (industry, academic, first-principles) exist and have
been signed off by a reviewer"), the three reports collectively
constitute a Stage-1 set, **but none is sign-off ready**. Required
revisions (above) must land before Stage 2 can begin. Re-review on
revised reports is required.

The reports' aggregate breadth is genuinely good — across the three,
~50 distinct topology entries are catalogued spanning ring, RC, LC,
sub-threshold, chopper, FLL, carrier-derived, hybrid, and exotic
families, with explicit rejections of off-PDK and forbidden options.
The *quality* of each individual report's solution-space coverage
exceeds the methodology's "5 distinct approaches" minimum by an
order of magnitude.

### What worked well

- **Each report fills a distinct niche.** FP brings physics-derived
  novelties (C3 PCB-loop, A4 brown-out reframing). Industry brings
  the canonical commercial archetypes and explicit rejection
  taxonomy. Academic brings silicon-anchored ULP papers that neither
  sister cites (Choi/Blaauw, Tokairin VAFB, Pelgrom).
- **Convergence on the NFC-carrier architecture skeleton from three
  independent angles is the strongest single Stage-2 input.** All
  three reports independently arrive at "use the carrier as the
  precision reference, free-run a ring otherwise" without prompting.
  This is the methodology's gold-standard convergence pattern.
- **Negative results are present and substantive in all three.**
- **No suspicious convergence detected** — concept-level overlap
  between FP and industry is ~40-50 %, well below the 70 % laziness
  threshold. Academic uses non-colliding `AC-*` IDs and a
  cross-reference table back to sister reports — exactly the right
  pattern.

### What didn't

- **Topology-ID collisions** between FP and industry are the single
  biggest impediment to Stage-2 ingestion. The orchestrator's
  early flag was correct in spirit but understated; the collision
  affects almost every shared letter+digit ID, not just `G2`.
  Reviewers should track this closely on subsequent items.
- **Two academic-survey citation errors** (wrong author for Hsiao-2023,
  wrong topology for Lee-2016). Both verifiable in seconds via the
  open-access PMC URLs the report itself cites. This is the kind of
  defect that creeps in when an agent surveys ~30 abstracts in
  parallel; reviewers should always spot-check the open-access ones.
- **First-principles arithmetic errors** (§5.4 ω·L, §5.11
  cold-start cap by 1000×). Both reproducible by hand in a minute.
  The §5.11 error is conclusion-changing.
- **All three executive summaries lean into Stage-3 territory** to
  varying degrees. The academic and FP reports cross the line.
- **Industry survey has six unverified references** (timed-out
  ST/NXP/TI PDFs). Methodology requires *verification of existence
  and accessibility*; URL-resolve-via-search-snippet is weaker than
  the methodology's bar.
- **Mode-locked oscillators are absent from all three reports**
  despite being named in the per-item README's scope.

### For future reviewers

- The reference-spot-check routine (5+ WebFetch calls on
  open-access surrogates) caught two citation errors that any agent
  reading abstracts at speed would miss. Recommend it as standard
  practice.
- The first-principles math-recalc routine (3+ recalculations from
  scratch) caught two arithmetic errors. Both of these errors
  *passed* the report's own self-review. Self-review is not
  sufficient for first-principles math.
- Topology-ID collision detection should be standardised: build the
  cross-report ID-vs-concept matrix as a routine pre-Stage-2 step.
  Treat any collision as an automatic revisions-requested.
