---
report_under_review: docs/research/d-rf-2g4-harvesting/stage1-{first-principles,industry-survey,academic-survey}/{report,solutions,components,open-questions,references}.md
reviewer: claude-opus-4-7-1m (reviewer-1, adversarial pass)
date: 2026-05-04
verdict: revisions-requested
---

## Verdict

**revisions-requested** — across all three Stage-1 angles for item
(d). The qualitative architectural picture (twinkle is feasible only
within ~1 m of an active 2.4 GHz transmitter; commercial RFEH is
cooperative-source territory; native-Vt NMOS Dickson + on-die match
+ on-die SC charge pump is the only no-external-passives path) is
sound and Friis-bounded. However:

1. **Citation-author mis-attribution (programme-wide pattern):** the
   `Awad et al. 2022 MDPI Sensors` anchor used in both
   first-principles (R2) and industry-survey (I17) does not exist
   under that author name. The actual paper at DOI
   10.3390/s22124415 is by **Pakkirisami Churchill, Ramiah, Chong,
   Chen, Mak, Martins** (verified via PMC9227311 fetched fresh in
   this review, 2026-05-04). The academic survey caught this and
   flagged it as Q1 — the FP and industry-survey reports have not.
2. **Second citation-author mis-attribution:** the academic survey
   itself attributes the MDPI Electronics 2019 DTMOS-CCDD-on-SOTB
   paper to "**Honma et al.**" five times (executive summary line
   73, §3.A.9 anchor, §5.5, §7.2, B.6 reference, S6 solution).
   Independent verification via Google Scholar in this review gives
   the authors as **T.L. Nguyen, Y. Sato, K. Ishibashi**. "Honma"
   is the wrong surname. This is the same authorship-collision
   pattern reviewer-1 caught in (b) (G3 Sun→Godinho), (f)
   (Davis→Greene), and (a) (Hsiao→Mirchandani+Shrivastava).
3. **Pinuela GSM900-vs-3G mis-attribution (academic):** the
   academic survey §1 and §5.6 state "*2G GSM900 harvester reached
   40% end-to-end efficiency at -25.4 dBm received power*". The
   actual Pinuela 2013 paper text (verified, cached PDF, p.2722)
   says the **improved 3G v2** demonstrator achieved 40% at
   -25.4 dBm. GSM900 is a different prototype with different
   numbers. **Material to the headline finding** because the
   academic survey leans on this as "the most rigorous true-ambient
   measurement in the literature".
4. **Industry-survey §5.1 internal inconsistency on EIRP:** the text
   states "Friis at 915 MHz with 20 dBm AP and 2 dBi RX antenna,
   for -12 dBm received: d ≈ 4.0 m" — this is mathematically wrong
   at 22 dBm EIRP (recalc: d = 1.31 m). The 4 m number is correct
   only at 32 dBm EIRP (1 W + 2 dBi). The same applies to the
   2.45 GHz scaling (1.5 m claim consistent with 32 dBm not
   22 dBm). The §5.1 conclusion "twinkle requires < 2 m" survives
   only if the implicit transmitter is 1 W EIRP, not the stated
   100 mW Wi-Fi class.
5. **No 1000× cap-arithmetic error present in (d).** Of the three
   reports, only (d) academic explicitly catches the µF-class
   storage-cap infeasibility (open-questions Q10 derives the
   constraint surface correctly: 50 nF cannot supply 0.16 µJ from
   1.5 V, requires re-scaling). The (d) first-principles report's
   §5.6 (1 nF → 1.125 nJ at 1.5 V) is internally consistent. The
   1000×-cap pattern from (b)/(c)/(e)/(f)/(k) does **not**
   propagate into (d). Per CORRECTIONS.md, (d) was already
   spot-checked and verified by a prior reviewer-1 pass on
   `stage1-academic-survey/components.md` line 132.
6. **Topology-ID-collision pattern from (a)/(k) IS present in (d).**
   FP uses S1-S6 / multiplier short-names (`dickson-naive-nfet`,
   `villard-half-wave`, etc.); industry uses `i-`-prefixed and
   reuses the same short-names (`dickson-pmos-cross-coupled-
   differential` is shared with FP); academic uses S1-S10 with
   numeric IDs that **collide with FP's S1-S6 by number but not
   by content**. (FP S2 = `dickson-native-pi-match`; Academic S2 =
   `native-vt-dickson-monomode`; same family, different exact
   composition.) Stage-2 must namespace these (`FP-S1...`,
   `IS-S1...`, `AC-S1...`) before any merge. This is the same
   pattern reviewer-1 flagged in (a).
7. **Suspicious convergence is moderate, not extreme.** Topology
   coverage shares ~50-60% of family identifiers across the three
   angles (e.g. all three use `dickson-pmos-cross-coupled-
   differential`, `villard-half-wave`, `transformer-coupled`).
   This is below the (b)/(k) ~70% threshold and is partly
   defensible from physics (CMOS rectifier topology space is
   small). Authentic disagreement is present (academic uniquely
   surfaces Pinuela's "did-not-build" at 2.4 GHz, the
   Awad→Churchill mis-attribution, the Yan-2024 controller
   quiescent power 66-157 nW that the sister reports treat as
   zero, and the 86%-PCE-de-rating warning).

The reports are individually salvageable: structurally sound,
each has ≥ 6 distinct topologies, all have non-trivial negative
results, and none narrow prematurely. But six specific edits are
required before sign-off.

---

## Findings

### Reference verification (REQUIRED — 5+ spot-checks via WebFetch)

Web-access constraint: no IEEE Xplore WebFetch per brief.
Paywalled IEEE references reported as DOI-resolved-abstract-matches.

| Citation | URL/DOI resolved? | Document matches citation? | Local cache present? | Local cache matches upstream? |
|---|---|---|---|---|
| Pakkirisami Churchill 2022 (PMC9227311 / DOI 10.3390/s22124415) | yes | **YES, with corrected attribution** — authors are Pakkirisami Churchill, Ramiah, Chong, Chen, Mak, Martins (NOT "Awad"). Quoted: "*sensitivity of -14.1 dBm corresponding to an output voltage Vout,RFEH of 1.25 V*"; "*peak power conversion efficiency (PCE) of 21.15%, driving a 3.3-kΩ load at an input power of 0 dBm*"; "*output power of ~423-µW*"; "*180-nm complementary metal–oxide–semiconductor (CMOS)*"; "*3 × 3 stage … differential cross-coupled (DCC) rectifier with three-stage series with three parallel stages*". | partial — academic survey lists `references-cache/pinuela-...` but Churchill 2022 is **not in `references-cache/`**. Academic B.2 says "to-be-cached for Stage-2". | N/A |
| GF180MCU PDK NVT NMOS spec page | yes | **YES** — confirmed VT0 typ -0.12 V at W/L=10/1.8, range -0.32 to +0.08 V. Verbatim verified in this review. | not cached in references-cache/ | N/A |
| Friis transmission equation (Wikipedia) | yes | **YES** — equation form `Pr/Pt = Gt·Gr·(λ/4πd)²` and `20·log10(λ/4πd)` log form confirmed verbatim. | not cached | N/A |
| Pinuela 2013 IEEE TMTT (cached PDF) | N/A (cache-direct) | **PARTIALLY** — verified by `pdftotext` extraction in this review session. Confirmed: (i) "DTV, GSM900, GSM1800, and 3G" are the four bands prototyped — Wi-Fi was identified as a band but **not built** (matches academic §5.7); (ii) 40% end-to-end efficiency at -25.4 dBm is for the **3G v2 demonstrator** (matches industry §5.2 reference), NOT the GSM900 prototype as the academic survey states. (iii) "63 µW/m² broadband-average across 680 MHz – 3.5 GHz" claim in FP §5.1 was NOT located in extracted text — Pinuela's BicoLOG range is "0.3-2.5 GHz", and I could not find a 63 µW/m² figure. **FP report's broadband-average citation needs primary-source verification.** | yes (1.39 MB) | partial — extracted to `tmp/pinuela.txt`, content matches paper title/authors/DOI; numerical specifics (63 µW/m², "Pinuela GSM900 40%") need re-verification |
| FCC 47 CFR §15.247 (Cornell LII) | yes | **YES** — confirmed: 1 W max conducted, 6 dBi antenna gain reference, 1-dB-for-1-dB power reduction above 6 dBi for non-fixed P2P. **Caveat:** industry-survey §3.F.1 line 384 says "1 dB-for-3 dB power reduction" — that is the *fixed point-to-point* exemption per 15.247(b)(4)(ii), NOT the general rule. The 1-for-1 rule is the right one for our use case. Minor citation imprecision. | not cached | N/A |
| Wiliot Wikipedia page | yes | **YES** — "powers itself by harvesting the energy from surrounding Wi-Fi, cellular and Bluetooth radio signals" verbatim confirmed. Industry survey I11 quote accurate. | not cached | N/A |
| MDPI Electronics 2019 "2.77 µW DTMOS-CCDD on 65 nm SOTB" | yes (Google Scholar via WebFetch) | **CITATION-ATTRIBUTION FAILURE** — Google Scholar returns authors **T.L. Nguyen, Y. Sato, K. Ishibashi** (2019, MDPI Electronics). Academic survey attributes the paper to "**Honma et al.**" throughout (executive summary, §3.A.9, §5.5, §7.2, S6 verdict). DOI 10.3390/electronics8101173 was verified as the right paper, but the lead author is wrong by surname. Academic survey must correct. | not cached | N/A |
| Antenova RUFA datasheet (cached) | N/A (cache-direct) | **YES** — `pdftotext` extraction in this review confirms verbatim: "Peak gain 2.1 dBi"; "Average gain -1.2 dBi"; "Average efficiency 75%"; "Maximum Return Loss -11 dB"; "Dimensions 12.8 × 3.9 × 1.1 [mm]". All three reports' RUFA citations are accurate. | yes (554 KB) | yes |

**Aggregate.** 8 spot-checks; 4 fully passed (GF180MCU PDK, Friis,
Wiliot, RUFA); 4 substantively flawed:
- (a) Awad→Churchill author mis-attribution in FP+industry (caught
  by academic survey but not propagated upstream).
- (b) Honma→Nguyen author mis-attribution unique to academic survey.
- (c) Pinuela "GSM900 40%" mis-attribution in academic survey
  (actual: 3G v2).
- (d) FCC "1-for-3" mis-citation in industry survey (actual: 1-for-1
  for non-fixed P2P).

This is **the same author-attribution-error pattern** that programme-
wide reviewer-1 caught in items (a), (b), and (f) per CORRECTIONS.md.
Stage-1 agents on (d) inherited the pattern.

**Local caching status: incomplete.** Industry-survey caches 9 of
its 18 references (good ratio). FP report caches 0 of 6 (R2 cited
as cached on PMC mirror but no local copy in `references-cache/`;
explicitly notes "Not yet cached" for R1 and "verified via Semantic
Scholar" for R6). Academic survey claims 7 cached but several are
inherited from sister reports (Pinuela, Antenova, Powercast, Si Labs,
e-peas, Atmosic) and not "originally cached" by the academic agent.
**Action: cache Churchill 2022 PMC9227311, Honma/Nguyen 2019, and
Yan 2024 PDFs (or program-book equivalents) before Stage 2.**

---

### Solution-space coverage

The (d) per-item README enumerates 7 scope bullets (empirical
ambient power densities; antenna topology; rectifier topologies;
matching network; real-world receive sensitivity; Friis sanity for
100 mW APs; antenna sharing with item (k)). Coverage:

- **Empirical ambient power densities:** all three reports anchor
  on Pinuela 2013. FP also derives Friis from first principles
  (good, on-brand). Industry survey adds e-peas Tables 4 & 6 (good
  vendor cross-check). Academic uniquely surfaces that Pinuela
  *deliberately did not build* a 2.4 GHz harvester — a strictly
  more authoritative claim. **Pass.**
- **Antenna topology:** FP §5.2 calls Chu-Harrington but does not
  enumerate antenna families (defers to PCB sub-project). Industry
  §3.E enumerates 6 (`ant-pcb-ifa`, `ant-pcb-monopole`,
  `ant-pcb-loop`, `ant-chip-antenna`, `ant-pifa`,
  `i-ant-pcb-meander-dipole-differential`). Academic does not
  separately enumerate. **Industry pass; FP/academic acceptable
  by deferral.**
- **Rectifier topologies:** FP enumerates 6 (3.A.1-3.A.6). Industry
  enumerates 8 (3.A.1-3.A.8 including reconfigurable and discrete-
  two-stage). Academic enumerates 9 (3.A.1-3.A.9 including hybrid
  dual-topology and DTMOS-CCDD). All three exceed the 5-minimum.
  **Pass.**
- **Matching network:** FP §3.C enumerates 5; industry §3.C
  enumerates 5; academic §3.C enumerates 4. **Pass.**
- **Real-world receive sensitivity:** FP §5.5 ties Friis to LED
  flash energy. Industry §5.4 verifies Yan -19 dBm against Friis.
  Academic §5.5 catches the Churchill 21.15% × 1000 µW = 211.5 µW
  vs claimed 423 µW **2× discrepancy** that the sister reports do
  not flag — **a strong unique contribution** from academic.
- **Friis sanity for 100 mW APs:** all three. FP carries the
  derivation; industry and academic re-anchor against published
  numbers. **Pass.**
- **Antenna sharing with (k) BLE:** FP §5.9 derives 50 dB isolation
  requirement. Industry §3.H enumerates 3 TR-switch types.
  Academic C8 enumerates 4 TR-switch types. **Pass.**

**Both the simplest dumb (S5 villard-naive-strong-RF-only,
`dickson-naive-nfet`) and most sophisticated (Yan-2024
reconfigurable, Stoopman antenna co-design, Honma DTMOS-CCDD-on-
SOTB, hybrid-dual-topology) ends are present in all three.** Pass
on dynamic range.

**Approaches in the README that are under-represented:**
- "Threshold-cancellation tricks (DTMOS, gate-bias-bootstrapping,
  floating-gate)": FP §3.A.5 covers all three sub-flavours (good);
  industry §3.A.5 covers Kotani SVC and DTMOS; academic §3.B is the
  most thorough (4 variants). **Pass.**
- "Native / zero-Vt devices in `gf180mcuD`": all three cover the
  native-Vt 6 V NMOS angle; **none** explicitly explore the 3.3 V
  flavour `nfet_03v3_nvt` as a separate device option. README does
  not require it but the PDK exposes both flavours.

**Approaches the parallel reports cover that one of them does not:**
- `i-reconfigurable-rectifier` (Yan 2024) is enumerated in industry
  §3.A.7 and academic §3.A.7. The FP report does not list a
  "reconfigurable rectifier" topology family — this is consistent
  with FP's prior-art-blind angle but should be derivable from
  physics (multi-mode rectifiers exist in the abstract sense).
  Minor.
- `transformer-coupled` (3.A.6 in all three) appears with subtly
  different reasoning per report. Acceptable.
- `hybrid-dual-topology-2023` is unique to academic §3.A.8. Should
  appear (or be explicitly rejected) in industry too.

---

### Premature narrowing

- FP report length: ~378 lines. Largest topology block:
  §3.A.5 (DTMOS / Kotani) at ~9 lines. ~2.4% of length —
  comfortably below 40% threshold. **Pass.**
- Industry report length: ~614 lines. Largest topology block:
  §3.A.7 reconfigurable + §3.D PMU (combined ~50 lines). ~8%.
  **Pass.**
- Academic report length: ~540 lines. Largest topology block:
  §3.A.5 Kotani SVC (~30 lines including dual anchor +
  precursor). ~5.6%. **Pass.**
- None of the three executive summaries picks a winner. All three
  explicitly state Stage-2 is where the choice happens.
  **Pass.**

---

### Numerical claim verification

I redid five of the reports' numerical claims from first
principles. Show-the-math:

#### Recalc 1: Friis link budget (FP §5.1)

```
λ = c/f = 2.998e8 / 2.45e9 = 0.12237 m  (FP says 0.1224 m — pass)
At 1 m, 100 mW EIRP (Pt+Gt = 20 dBm), Grx = 2 dBi:
FSPL = 20*log10(4π·1/0.12237) = 40.23 dB  (FP says 40.23 dB — pass)
P_rx = 22 - 40.23 = -18.23 dBm = 15.03 µW  (FP says -18.23 dBm,
                                              15.0 µW — pass)
At 5 m: FSPL = 54.21 dB, P_rx = -32.21 dBm = 0.60 µW (FP — pass)
At 10 m: FSPL = 60.23 dB, P_rx = -38.23 dBm = 0.15 µW (FP — pass)
At 0.5 m: FSPL = 34.21 dB, P_rx = -12.21 dBm = 60.1 µW (FP — pass)
Power density at 1 m, 100 mW iso = 0.1/(4π·1²) =
                                    7.96 mW/m² = 0.80 µW/cm² (FP — pass)
```

**FP §5.1 reproduces correctly to 3 significant figures across the
entire distance table. The Friis derivation is solid.**

#### Recalc 2: Yan 2024 -19 dBm sensitivity → distance (Industry §5.4 + Academic §5.1)

```
P_rx = -19 dBm. At 100 mW EIRP (22 dBm) and 2 dBi rx, Grx in budget:
FSPL_budget = 20 + 2 - (-19) = 41 dB
d = 10^(41/20) · λ / (4π) = 112.2 · 0.12237 / 12.566 = 1.093 m
                                           (industry says 1.1 m — pass)
At Grx = -1 dBi: FSPL_budget = 38 dB
d = 10^(38/20) · 0.12237/12.566 = 79.4 · 0.00974 = 0.774 m
                  (industry §5.4 says 0.6 m — recalc 0.77 m, mismatch)
At Grx = -1.2 dBi (Antenova average):
FSPL_budget = 37.8 dB → d = 0.756 m
```

**Industry §5.4 "≈ 0.6 m at -1 dBi IFA gain" is wrong.** Recalc
gives 0.77 m at -1 dBi or 0.76 m at -1.2 dBi. Off by ~22-25%
(0.6 → 0.77). The "doubling of range" framing relative to a
naïve-Dickson should still hold qualitatively. Stage-2 should
correct the 0.6 m to 0.76-0.77 m and re-quote.

#### Recalc 3: Powercast P2110B "-12 dBm threshold → 4 m at 915 MHz" (Industry §5.1)

```
At 915 MHz, λ = 0.328 m. Industry text:
"P_rx[dBm] = 20 + 0 + 2 - 20·log₁₀(4π·d/λ)"  (i.e. 22 dBm EIRP)
For -12 dBm: 22 - FSPL = -12 → FSPL = 34 dB
d = 10^(34/20) · 0.328 / (4π) = 50.12 · 0.0261 = 1.31 m
                                  (industry claims d ≈ 4.0 m — FAIL)
```

The 4.0 m number is correct only if Pt + Gt = 32 dBm (1 W + 2 dBi),
not 22 dBm:

```
At 32 dBm EIRP: FSPL_budget = 32 - (-12) = 44 dB
d = 10^(44/20) · 0.328 / (4π) = 158.5 · 0.0261 = 4.14 m  (matches 4 m)
```

**Industry §5.1 has an internal contradiction.** The recipe says
20 dBm AP + 2 dBi rx (so 22 dBm EIRP), but the d ≈ 4 m number
requires 32 dBm EIRP. Same inconsistency for the 2.45 GHz scaling
("d ≈ 1.5 m" claim — only matches at 32 dBm, not 22 dBm). The
qualitative §5.1 conclusion ("twinkle requires < 2 m") survives if
the implicit transmitter is 1 W EIRP cooperative (e.g. Powercast
TX91501), but **the prose claims 100 mW Wi-Fi and the math
implicitly assumes 1 W**. This must be reconciled.

#### Recalc 4: Storage-cap arithmetic (Academic open-questions Q10)

```
At V0 = 1.5 V, C = 50 nF, E_flash = 0.16 µJ:
V_low² = V0² - 2E/C = 1.5² - 2·1.6e-7/5e-8 = 2.25 - 6.4 = -4.15
V_low = √(-4.15) = imaginary
```

**Confirms academic Q10 verbatim:** 50 nF cannot supply 0.16 µJ
from 1.5 V. The pull-down would drop the rail to imaginary —
i.e. cap empties before flash energy delivered.

```
Min C for 0.16 µJ from 1.5 V → 1.0 V:
C = 2·E / (V0² - V_low²) = 2·1.6e-7 / (2.25 - 1.0) = 256 nF
At 2 fF/µm² MIM density: 256 nF = 2.56e8 fF / 2 = 1.28e8 µm² = 128 mm²
                                  — too big to fit on a small die
```

```
For 1.6 µJ (clearly visible flash): C = 2.56 µF, area = 1280 mm²
                                  — also infeasible on-die
```

**The academic survey's open-questions Q10 is correct: even
moderate-flash energy demands µF-class storage that exceeds on-
die budget at 2 fF/µm² MIM. This contradicts the FP §5.6 chart
which suggests "10 nF storage at 5 m, 0.01 µW = 1 second first-
flash latency" — the 10 nF is too small to support a 1.6 µJ
visible flash. Stage-2 must reconcile: either flash energy scales
to ≤ 0.04 µJ class, or storage cap must be off-die, or visible
flashes are not feasible from Wi-Fi-only ambient.**

**No 1000× cap-arithmetic error in (d).** This is a pleasant
exception to the (b)/(c)/(e)/(f)/(k) pattern. CORRECTIONS.md
already records (d) academic-survey/components.md line 132 as
verified-correct. My re-derivation reproduces the academic-survey
arithmetic.

#### Recalc 5: Pinuela's "broadband 63 µW/m² across 680 MHz – 3.5 GHz" (FP §5.1)

The FP report quotes "Pinuela 2013 broadband-average ≈ 63 µW/m²
across 680 MHz – 3.5 GHz". I extracted the cached Pinuela PDF in
this review and could not find this number. Pinuela's BicoLOG
antenna covers "0.3 – 2.5 GHz" (verified verbatim line 86 of
extraction); the "broadband-average -12 dBm/m² → ~63 µW/m²" claim
in FP needs a primary-source citation. The qualitative point
("broadband ambient yields nW total") survives because the four
prototyped harvesters each output single-µW-class DC at -25 dBm-
class input, but the headline number itself is unverified.

**Stage-2 action:** either FP cites the exact Pinuela section /
table that gives 63 µW/m², or revises the headline to a
verified-from-Pinuela number.

#### Cross-cutting physics

- Friis: not violated; recalc 1 reproduces.
- Faraday: not invoked here (this is far-field; Faraday is item (b)).
- Boltzmann / kTB: FP §5.3 says kTB at 20 MHz Wi-Fi BW =
  -101 dBm = 80 fW (recalc: -174 + 73 = -101 dBm = 79 fW — pass).
- Chu-Harrington Q ≥ 1/(ka) + 1/(ka)³: at ka = 0.26 (FP §5.2),
  Q_min = 3.85 + 56.9 = 60.7 (FP says 60 — pass).

**No physical-law violations.** All three reports' numerical
claims are within physics. The errors are arithmetic / citation
attribution, not physics violations.

---

### Negative results

All three reports have substantial negative-result sections:

- FP §7: 6 itemised negatives (naïve Dickson; DTMOS bulk-CMOS;
  single-bondwire ground; PCB balun forbidden; pixel-clock
  harmonic; 5 m verdict).
- Industry §7: 6 itemised negatives (no 2.4 GHz commercial RFEH;
  Atmosic ≠ 2.4 GHz rectifier; no TT precedent; AN930.2 family
  forbidden; BQ25504 cold-start exceeds budget; single-bondwire
  pathological).
- Academic §7: 7 itemised negatives (Pinuela non-result;
  DTMOS-bulk-CMOS de-rate; Awad→Churchill mis-attribution;
  86%-PCE-is-900-MHz; BQ25504-class boost forbidden; floating-
  gate trim cost; Stoopman antenna co-design impedance unknown).

Coverage is **good across the board**, with the academic survey
contributing the most analytically valuable findings (mis-
attribution, frequency de-rate, antenna co-design dependency).

---

### Convergence with parallel reports

**Topology-key convergence (~50-60% overlap on family identifiers):**
- All three reports use `dickson-naive-nfet`, `dickson-native-nfet`,
  `dickson-pmos-cross-coupled-differential`, `villard-half-wave`,
  `dynamic-vth-cancellation`, `transformer-coupled` as the core six
  rectifier families. This **is** consistent with the small CMOS
  rectifier topology space, partially defensible from physics.
- All three derive Friis to ~1-2 m feasibility distance, all three
  flag the µF storage problem (with academic surfacing the
  flash-energy mismatch most clearly), all three identify the
  bondwire as part of the matching network.

This is below the (b) ~83% / (k) ~70% topology-name-convergence
threshold. **Lower convergence than (b) and (k) — and authentic
disagreement is more visible:**

- **Awad→Churchill discovery:** academic survey alone catches that
  the "Awad 2022 MDPI" anchor used in FP+industry doesn't exist
  under that author name, and re-anchors to Pakkirisami Churchill
  2022. **Strong unique academic finding.**
- **Yan 2024 controller quiescent power:** academic alone surfaces
  that Yan-2024's MPPT controller draws 66-157 nW continuous,
  which exceeds harvested DC at 5 m. **Strong unique academic
  finding.**
- **86% PCE de-rate:** academic alone calls out that the 86%-PCE
  Sadagopan-class numbers cited by industry are 900 MHz, not
  2.4 GHz, and lose 25-35% PCE on the same node at the higher
  band. **Strong unique academic finding.**
- **Pinuela non-result:** academic alone re-reads Pinuela in
  context to surface that the 2.4 GHz harvester was deliberately
  *not* built. The other two reports treat Pinuela as a generic
  "ambient is sub-µW" anchor. **Strong unique academic finding.**
- **Industry-survey EIRP confusion** (recalc 3 above): industry
  alone makes the 22-vs-32 dBm slip; FP is internally consistent
  on 100 mW EIRP throughout.

**Verdict on convergence:** moderate. Below the (b)/(k) threshold;
authentic disagreement and unique findings are visible. **Not
suspicious enough to require redo.** Stage-2 should reconcile, not
the Stage-1 angles.

**Topology-ID-collision pattern (a-style):** present at the level
of S-IDs (FP S1-S6 vs Industry S-* via prefix vs Academic S1-S10).
FP-S2 (`dickson-native-pi-match`) and Academic-S2
(`native-vt-dickson-monomode`) are the same family at the topology
level but different exact compositions. Stage-2 must namespace
before merge. **This is the same FP-S* / IS-S* / AC-S* pattern
flagged in (a).**

---

### Specific revisions requested

1. **(All three.) Awad → Pakkirisami Churchill citation correction.**
   Replace every "Awad 2022 MDPI Sensors" reference with the
   verified attribution: Pakkirisami Churchill, Ramiah, Chong,
   Chen, Mak, Martins, "A Fully-Integrated Ambient RF Energy
   Harvesting System with 423-µW Output Power", *Sensors* 22(12),
   4415, 2022. DOI 10.3390/s22124415. PMC9227311. Cache the PMC
   PDF locally under `references-cache/churchill-2022/` with
   SHA-256 recorded.

2. **(Academic.) Honma → Nguyen citation correction.** Replace
   every "Honma et al." reference to the MDPI Electronics 2019
   DTMOS-CCDD-on-SOTB paper (DOI 10.3390/electronics8101173)
   with the verified authors: T.L. Nguyen, Y. Sato, K. Ishibashi.
   Affects: report.md executive summary (line 73), §3.A.9, §5.5,
   §7.2; references.md B.6; solutions.md S6; open-questions.md
   Q5. Cache locally with SHA-256.

3. **(Academic.) Pinuela GSM900 → 3G v2 citation correction.**
   The "2G GSM900 harvester reached 40% end-to-end efficiency at
   -25.4 dBm" in §1 and §5.6 must be revised to "the **3G v2
   demonstrator** reached 40% end-to-end efficiency at -25.4 dBm
   input" per Pinuela 2013 p.2722 verbatim. The downstream
   conclusion ("most rigorous true-ambient measurement") still
   holds — only the band attribution changes.

4. **(Industry.) §5.1 EIRP-vs-distance reconciliation.** The text
   says "Wi-Fi-class TX at 915 MHz with 20 dBm AP + 2 dBi rx" but
   then the 4 m distance computation requires 32 dBm EIRP (1 W +
   2 dBi), not 22 dBm. Either: (a) restate as "1 W cooperative
   transmitter (Powercast TX91501-class)" and hold the 4 m
   number, or (b) hold the 100 mW Wi-Fi assumption and recompute
   d ≈ 1.31 m at 915 MHz, d ≈ 0.49 m at 2.45 GHz. Same fix
   applies to "1.5 m at 2.45 GHz" claim. The qualitative §5.1
   conclusion ("twinkle requires < 2 m") needs scenario tagging.

5. **(Industry.) §5.4 Yan 2024 sensitivity-distance recalc.** "≈
   0.6 m at -1 dBi IFA gain" is wrong by ~25%. Correct value is
   0.77 m at -1 dBi or 0.76 m at -1.2 dBi (Antenova average).
   Update the §5.4 number; the "doubling of range vs naïve
   Dickson" qualitative framing survives.

6. **(Industry.) §3.F.1 FCC 1-for-1 vs 1-for-3 reduction.** The
   text says "1 dB-for-3 dB power reduction" — that is the *fixed
   point-to-point* exemption. The general rule for non-fixed
   systems (which is what consumer Wi-Fi APs are) is 1-for-1
   reduction above 6 dBi. Minor citation imprecision; correct
   for accuracy.

7. **(FP.) Pinuela 63 µW/m² claim primary-source verification.**
   The "broadband-average ≈ 63 µW/m² across 680 MHz – 3.5 GHz"
   number in §5.1 was not located in the cached Pinuela PDF
   text-extraction in this review. FP must either provide the
   exact section/table reference, or revise to a Pinuela-verified
   figure. The qualitative point ("broadband ambient is sub-µW")
   survives but the headline number is unanchored.

8. **(All three.) Topology-ID namespacing.** Before Stage-2 merge,
   prefix the S-IDs: `FP-S1...FP-S6` for first-principles,
   `IS-S1...IS-S8` for industry survey, `AC-S1...AC-S10` for
   academic survey. This is a mechanical edit that prevents the
   (a)-style ingestion collision.

9. **(All three.) Reference caching completeness.** Cache
   Churchill 2022 (PMC9227311 PDF), Nguyen 2019 (MDPI Electronics
   PDF — open-access), Yan 2024 program-book PDF (academic
   already has this), Stoopman 2014 (TU Delft mirror), Kotani
   2007/2009 (open-access faculty page if available) under
   `references-cache/` with SHA-256 recorded for each. Currently
   half the cited papers are "deferred to Stage-2 reviewer" —
   that's not the methodology's division of labour.

10. **(Industry §3.E.2 / §3.E.5 / §3.E.6.) Antenna gain-aperture
    sanity.** The brief asks for a gain-vs-aperture cross-check.
    Industry currently quotes Antenova RUFA peak +2.1 dBi /
    average -1.2 dBi (verified) but does not derive A_eff. For
    completeness: A_eff = G·λ²/(4π); at G = 2 dBi linear (1.585),
    λ = 0.122 m: A_eff = 1.585 · 0.01497/12.566 = 1.89 cm². At
    average G = -1.2 dBi (0.76 linear): A_eff = 0.91 cm². The
    "6 cm² IFA aperture" assumption that appears in the brief's
    cross-checks (and in (k)'s 20-dB-gap recalc) is **larger
    than physics permits** for a 2.45 GHz IFA without a peak-
    aligned line-of-sight orientation. This should be tagged in
    (d) Stage-2 if (k) is going to lean on it.

---

## Closing notes

- The (d) Stage-1 reports are **structurally sounder than (b) or
  (k)**. There is no 1000× cap-arithmetic error; the topology
  convergence is moderate not extreme; the authentic-disagreement
  density is higher (academic alone catches Awad→Churchill,
  Pinuela-non-result, 86%-de-rate). This reflects either a more
  careful researcher or a less-explored solution space (RFEH at
  2.4 GHz on 180 nm bulk has fewer published anchors than NFC at
  13.56 MHz, leaving less room for parallel laziness).
- The **Awad→Churchill mis-attribution propagating from FP into
  industry-survey but caught by academic** is the most
  diagnostic finding: it shows that two of the three "independent"
  agents took a sister's name and ran with it. The academic
  survey doing the work to triangulate via PMC search is exactly
  what parallel-angle methodology is supposed to deliver.
- **For Stage-2 synthesis:** the Churchill 21.15% PCE @ 0 dBm ×
  1000 µW = 211.5 µW vs claimed 423 µW DC output (academic §5.3
  catch) is the single biggest open numerical contradiction.
  Stage-2 must resolve whether the published PCE definition is
  pre- or post-matching-network — this affects every "Stage-2
  port to GF180MCU" calculation.
- **For Stage-2 synthesis:** the bondwire-as-matching-element
  observation (FP §5.7, industry §3.C.4, academic C1.c) is
  consistent and correct, but **bondwire L tolerance is ±20%**
  and Q ≈ 30 fixed — this means an on-chip trimmable cap bank
  is *not optional* for the matching network, regardless of which
  S-X topology Stage-2 picks. This should be elevated from "open
  question" to a load-bearing constraint.
- **For Stage-2 synthesis:** if (k) BLE is to share the antenna,
  the (d) harvester must tolerate at least +1 dBm in-band
  leakage during TX bursts. FP §5.9 requires 50 dB isolation at
  ~2 dB harvest IL. This is achievable per published TR-switches
  but **non-trivial in 180 nm bulk** — flag for early Stage-3
  feasibility check.
- **Topology-ID-collision pattern (a-style) IS present in (d)**
  at the S-* level but NOT at the prefix level (FP doesn't use
  the same prefix as industry). Stage-2 namespacing fixes this
  mechanically.
- **Suspicious convergence in (d):** moderate, not extreme.
  Below the (b)/(k) threshold. Acceptable with the corrections
  above.
- **Reviewer self-rating:** I performed 8 WebFetches (Churchill
  PMC9227311, MDPI Electronics 8/10/1173 [403], Semantic Scholar
  Honma search, GF180MCU PDK NVT spec page, Wikipedia Friis,
  Wikipedia Wiliot, FCC §15.247 Cornell LII, Honma DOI redirect),
  plus 1 Google Scholar redirect probe. 5 numerical
  recalculations (Friis distance, Yan -19 dBm sensitivity, P2110
  -12 dBm distance, storage-cap energy budget,
  Pinuela-verbatim PDF extraction). Within the brief's 10-WebFetch
  ceiling. No IEEE Xplore fetches.
