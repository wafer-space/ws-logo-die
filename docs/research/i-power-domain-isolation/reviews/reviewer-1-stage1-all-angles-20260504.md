---
report_under_review: docs/research/i-power-domain-isolation/stage1-{first-principles,industry-survey,academic-survey}/
reviewer: reviewer-1 (claude-opus-4-7-1m, adversarial)
date: 2026-05-04
verdict: revisions-requested
---

## Verdict

**revisions-requested.**

The three Stage-1 reports for item (i) are, on the *physics* and on the *PDK-internal* claims, the most rigorous package the programme has produced so far: the headline claim ("GF180MCU std-cell library has NO level-shifter / isolation / retention cells") is correct (verified by direct CDL grep — 229 SUBCKT, zero level/iso/retn matches), the brk5/D20/4 mm-snapback-clamp claims all check against the local PDK CDL/SPICE byte-for-byte, the latch-up trigger arithmetic (60–600 µA) matches first-principles bipolar physics, and the cross-leakage budget (50 nA / 50 µA = 0.1 %) is reproducible. The first-principles report in particular is exemplary: every claim is anchored in a path-and-line citation to a file on disk.

However, the academic-survey report has a **citation-author hallucination of programme-wide-pattern severity** on its single most-load-bearing reference (the "RCC 80 mV → 1.8 V at 180 nm" anchor), plus at least one further misattribution and a wrong-journal/wrong-DOI pair. The industry-survey report is structurally the weakest of the three (single file, no sister components/solutions/references/open-questions splits — that breaks the per-stage layout mandated by `METHODOLOGY.md` lines 264–288, even though `INDEX.md` apparently waives this). And the three angles' topology-ID namespaces collide *worse* than item (a): the same identifier (e.g. `D1` / `D.1`) means **different topology families** across the three reports.

Because the qualitative architectural verdicts (no PDK cells; hand-roll D-family shifter; either S2-class or S3+S4-class is the realistic v2 target; DNW-tubbed S5 is high-effort-high-reward) are robust against the citation errors, this is "revisions-requested" rather than "fail". But the citation errors must be fixed before Stage 2 ingests the academic anchors, and the topology-ID namespace collisions must be reconciled before Stage 2 can build a comparison matrix.

## Findings

### Reference verification (REQUIRED — 8 spot-checks performed)

| Citation | URL/DOI resolved? | Document matches citation? | Local cache present? | Local cache matches upstream? |
|---|---|---|---|---|
| LS-HOSS2019 (TVLSI 2019, RCC, DOI 10.1109/TVLSI.2018.2872330) | **NO** — DOI 404 | **NO** — title+authors+venue all wrong | N/A | N/A |
| LS-LUT2010 (TCAS-II 2010 Wilson) | yes | partial — title/authors/venue match; the *description* in the report mis-paraphrases the paper (silicon vs sim, 130 nm vs 90 nm, VIN-min 190 mV vs 100 mV) | N/A (no cache dir populated yet) | N/A |
| LS-HOSS2014 (TCAS-II 2014) | yes | partial — title/authors/venue match; the report's "190 mV at 130 nm, 6.5 nW @ 100 kHz" numbers are LUT2010's, not HOSS2014's | N/A | N/A |
| LS-TANG2014 (Berkeley TR EECS-2014-203) | yes (open-access landing page resolves) | yes — title, author, 1.8 V → 32 V, 8.2 ns delay all match | N/A | N/A |
| MD-SHRIV2015 (JSSC 2015, 220 mV cold-start) | yes (open-access PDF mirror at wics/umich) | yes — title, full author list, 220 mV cold-start, −14.5 dBm RF kick all match | N/A | N/A |
| PG-MUTOH1995 (JSSC 1995 MTCMOS) | yes | yes — full author list, venue, 1.7 ns / 0.3 µW/MHz/gate match Semantic-Scholar abstract verbatim | N/A | N/A |
| LU-VOLD2007 (Wiley *Latchup*) | yes (Wiley landing) | yes — ISBN 978-0470016428 matches; book is by Voldman 2007 | N/A | N/A |
| LU-CHEN2021 (IRPS 2021, naïve guard ring) | yes (Semantic Scholar) | yes — title, authors (Chen, Lee, et al.), venue (IRPS 2021), and the "guard rings *worsen* latchup immunity" finding all match | N/A | N/A |
| `sky130_fd_sc_hvl__lsbufhv2lv` (Apache-2.0 cell claim) | yes (`api.github.com/repos/google/skywater-pdk-libs-sky130_fd_sc_hvl/contents/cells`) | **yes** — `lsbufhv2lv`, `lsbufhv2lv_simple`, `lsbuflv2hv`, `lsbuflv2hv_clkiso_hlkg`, `lsbuflv2hv_isosrchvaon`, `lsbuflv2hv_symmetric`, `lsbufhv2hv_hl`, `lsbufhv2hv_lh` all present in the `cells/` directory; the repo-level Apache-2.0 license is widely documented elsewhere | N/A | N/A |

**Reference-verification findings beyond the ≥5 mandate:**

1. **LS-HOSS2019 is fabricated.** WebSearch for the cited title ("A Low-Power and High-Speed Voltage Level Shifter Based on a Regulated Cross-Coupled Pull-Up Network") returns the **Kabirpour & Jalali, TCAS-II 2019, vol. 66 no. 6 pp. 909–913, DOI 10.1109/TCSII.2018.2872814** paper, not a Hosseini/Maghami/Bahmani/Bolurian/Lotfi/Sodagar TVLSI 2019 paper. The cited DOI `10.1109/TVLSI.2018.2872330` resolves to **404** (verified via `https://doi.org/10.1109/TVLSI.2018.2872330` → 404). The actual IEEE Xplore document number that the academic survey cites (8476228) corresponds to the Kabirpour & Jalali TCAS-II paper. The description in §3 of the academic-survey ("80 mV → 1.8 V, 123 nW, 23.7 ns, 0.18 µm post-layout sim, 0.4/1.8 V supplies") is a **correct paraphrase of Kabirpour & Jalali 2019**, but the **authorship and venue are wrong**. This is the same programme-wide pattern as item-(f) Davis→Greene, item-(d) Awad→Pakkirisami-Churchill, and item-(b) Sun→Godinho — author hallucination on a single load-bearing anchor.

2. **LS-LUT2010 description is wrong on three details.** The academic-survey's `§3 TC-2`, `§5 sanity-check`, `§9 Comparison readiness`, and `references.md` together claim: "silicon (130 nm)", "VIN min ≈ 190 mV at 1.2 V VDDH", "6.5 nW @ 100 kHz". WebSearch / Semantic-Scholar abstract for LUT2010 (verified 2026-05-04) gives: **simulation in 90 nm**, "operates correctly... for supply voltages from 100 mV to 1 V", "at 200 mV input, 18.4 ns delay, 6.6 nW". The 190 mV figure does not appear in the paper. The report has *also* mis-attributed silicon-measured status and the wrong process node.

3. **LS-HOSS2014 and LS-LUT2010 have been conflated.** The report assigns LUT2010's "190 mV / 130 nm / 6.5 nW" headline to itself, then says HOSS2014 "halves the contention current at sub-300-mV inputs at the cost of one more transistor per side". HOSS2014's actual headline (per Semantic-Scholar) is **0.18 µm CMOS, 0.4 V → 1.8 V, 31 ns delay, 1.16 nW static, 0.68 µW @ 1 MHz**. The academic-survey describes neither paper accurately.

4. **No `references-cache/` mirror exists.** `docs/research/i-power-domain-isolation/references-cache/` is empty (verified `ls -la`). Per `METHODOLOGY.md` lines 167–174, every reference must be mirrored locally or its source-URL SHA-256 recorded. No SHAs, no PDFs. This is acceptable for Stage 1 *if* the per-reference-cache mandate is officially Stage-2's responsibility (the first-principles report says so explicitly), but the academic-survey describes itself as having "verified" PDFs that have not in fact been cached.

### Solution-space coverage

**First-principles (S1–S5, 12 sub-primitives in 5 families):**
- §3 enumerates 5 strategies + 12 sub-primitives, exhaustive within the stated scope. Both ends of spectrum present (A1 trivial RTL gating ↔ S5 DNWELL-tubbed custom-cell variant). Negative results §7 has 7 entries, several non-trivial (NR1 PDK-cell-absence, NR4 symmetric-DNWELL rejection).
- Coverage: comprehensive. No premature narrowing.

**Industry-survey (5 families A–E with 4–5 members each):**
- §3 enumerates ~17 distinct approaches across 5 families. Both ends of spectrum present (A.1 hard-split ↔ E.1/E.2 MTCMOS).
- **Structural defect**: the industry-survey is a single `report.md` with no `components.md` / `solutions.md` / `references.md` / `open-questions.md` siblings. Per `METHODOLOGY.md` lines 264–288 and `TEMPLATE.md` quality-checklist, the per-stage layout mandates these files. The brief notes "intentionally single-file per INDEX.md note; the supporting structured files are merged from first-principles sister", but: (a) this is not visible in the report itself, only in `INDEX.md`; (b) re-using the first-principles' `components.md` etc. is *exactly* the "lazy / suspicious convergence" pattern `METHODOLOGY.md` lines 89–93 warns against. A reader who lands on `stage1-industry-survey/report.md` cannot tell what is industry-derived vs first-principles-derived.

**Academic-survey (TC-1..TC-6 + TC-extra + TC-Y):**
- §3 enumerates 6 silicon-anchored families + latch-up + UPF / Caravel context. Coverage genuinely is "academic / silicon-paper-anchored" rather than re-deriving the industry survey. The TC-3 finding (RCC topology, even though the citation is wrong) is genuinely new vs the sister reports.
- 8 open questions, 5 negative results — substantive.

**Coverage findings:**
- **No silent omissions found.** Every approach the README §1–8 requested is touched somewhere in the three reports.
- **Industry-survey omits per-strategy components.md** (defect — see above).
- **The MTCMOS / retention-flop discussion is split across reports**: industry-survey says "would need custom cells", academic-survey says "structurally inaccessible (single-Vt PDK)", first-principles says "body biasing for dynamic isolation not supported (NR3)". Three angles, three different framings of the same conclusion. Stage 2 must pick one.

### Premature narrowing

- **First-principles**: §1 executive summary contains a "Recommended floorplan locating harvested-rail pad pair (provisional, subject to Stage 2)" recommendation. Stage 1 is supposed to enumerate without picking a winner. The "(provisional, subject to Stage 2)" hedge mitigates this, but the report does pre-commit to `analog[1]/analog[0]` as the harvested-rail pad pair. **Mild premature narrowing.** Acceptable because §3 still enumerates S1–S5 even-handedly, but should be flagged.
- **Industry-survey**: §1 conclusion #3 calls "minimising HARV-side pad count is the dominant lever, *not* shrinking shifter cells" — that's an *opinion*, not an enumeration. **Mild premature narrowing.** Salvageable: the §10 verdict is conditional and well-reasoned.
- **Academic-survey**: §1 paragraph 4 calls TC-3 (RCC) "the project's single strongest topology import". That is an explicit best-of-class declaration that Stage 1 is supposed to defer. **Premature narrowing.** Compounded by the fact that **the supporting citation is wrong** — the paper exists but is not by the cited authors. The verdict needs to be re-assessed against the actual paper (Kabirpour & Jalali).

None of the three reports spend > 40 % of their length on a single approach. Length budget is well-distributed.

### Numerical claim verification (3+ recalculations performed)

**Recalc 1 — per-pad RC-clamp leakage 648 nA × 8 + 1296 nA × 4 ≈ 10 µA (industry-survey §1, §10).**
- Direct PDK read of `gf180mcu_fd_io__dvdd` (lines 1326–1363 of `gf180mcu_fd_io.cdl`): the cell contains 12 ppolyf 30 kΩ resistors (R4–R15) wired in a chain DVDD→...→C3→DVSS, plus the 4 mm wide M17 snapback NFET with its gate driven by the M0–M2 PMOS chain. Worst-case static current through the polysilicon chain alone (if C3 leaked perfectly): 5 V / 360 kΩ = 13.9 µA. In normal operation the chain blocks DC via C3 and static current is dominated by the M17 sub-Vt I_off. 4 mm of W at TT/25 °C / 0.18 µm typically gives a few hundred nA per device. **648 nA per dvdd is plausible but not derived in the report.** The arithmetic identity 8×648 + 4×1296 = 10 368 nA = 10.37 µA is correct. Industry-survey should cite the source of the per-pad number (datasheet? characterisation report? simulation?). This is a Stage-2 verification task.

**Recalc 2 — academic-survey §5.1 RCC 80 mV input subthreshold-slope physics.**
- kT/q at 300 K = 25.85 mV; n = 1.5 (typical bulk-CMOS); S = (kT/q)·ln(10)·n = **89.28 mV/decade**. Report says "≈ 90 mV/dec" — within rounding. With Vt_low ≈ 480 mV, 80 mV input is (480 − 80)/89.28 = **4.48 decades below Vt** — close to the report's "~5 decades". Sub-Vt drain current at 4.48 decades below Vt at typical W/L gives ~1–10 pA, matching the report's "~10 pA drain current". **Physics checks out.**

**Recalc 3 — first-principles §5.2 latch-up trigger 60–600 µA.**
- I_trig = V_be / R_sub = 0.6 V / (1 kΩ to 10 kΩ) = **600 µA to 60 µA**. Report says "60–600 µA". **Matches exactly.**

**Recalc 4 — first-principles §5.1 cross-leakage 50 nA / 50 µA = ≪ 1 %.**
- 50 cells × 1 nA / cell = 50 nA; 50 nA / 50 000 nA = **0.1 %**. Report says "≪ 1 %". **Matches.**

**Recalc 5 — DRC DN.2b spacing 5.42 µm.**
- Direct read of `dnwell.drc` line 41 confirms "Rule DN.2b: Min. DNWELL Space (Different potential) is 5.42µm". **Matches exactly.**

**Recalc 6 — `brk5` cell 5 µm × 350 µm with VSS port on M3/M4/M5 only.**
- Direct read of `gf180mcu_fd_io__brk5.lef`: SIZE 5.000 BY 350.000 (line 9); VSS port on Metal3, Metal4, Metal5 (lines 16–62); Metal2 is in OBS (lines 67–68, *not* a port). **Matches first-principles claim exactly.**

**No physics violations found.** All numerical claims either reproduce or have minor (<10 %) rounding-level differences with first-principles re-derivation.

### Negative results

All three reports contain non-trivial negative-result sections:
- **First-principles §7**: 7 NRs, several load-bearing (NR1 PDK-cell-absence; NR2 hard-wired D20; NR4 symmetric-DNWELL rejection; NR7 pad-cell-type swap rejection).
- **Industry-survey §7**: 3 NRs, including the verifiable "sky130 has level-shifters; gf180mcuD does not" counter-example.
- **Academic-survey §7**: 5 NRs, including NR2 ("post-2015 retention literature is FinFET-only") and NR4 ("Caravel reveals what GF180MCU is missing").

**No empty / vacuous negative-result sections.** This is a strength.

### Convergence with parallel reports

**Headline conclusions agree across all three angles:**
1. GF180MCU std-cell library has no level-shifter / isolation / retention cells — *all three angles independently arrive at this*. Verified by direct CDL read.
2. Hand-rolled D-family cross-coupled DCVS is the recommended starting point.
3. DNW-tubbed full isolation is the high-effort high-reward path.
4. Latch-up via NFC-modulator substrate transients is the realistic risk.

**Topology-ID namespace collisions (severe):**
- First-principles uses `D1, D2, ... E1, E2, ...` (single letter+digit).
- Industry-survey uses `D.1, D.2, ... E.1, E.2, ...` (letter.digit).
- Academic-survey uses `TC-1, TC-2, ... TC-X-1, TC-Y-1` (TC-prefix; cleanly namespaced).

The collision is **worse than item (a)'s** because:
- FP-D = level-shifter family (D1=cross-coupled CMOS, D2=current-mirror, ...).
- IS-D = cross-domain ESD/latch-up family (D.1=back-to-back diodes, D.2=RC clamp, ...).
- *Same letter-prefix, completely different family meaning.*
- FP-E = isolation-cell family (E1=clamp-high, E2=clamp-low, ...).
- IS-E = power-gating + retention family (E.1=PMOS-header MTCMOS, E.2=NMOS-footer).
- *Same letter-prefix, again completely different family meaning.*

The academic-survey's `solutions.md` cross-walk table (lines 50–62) attempts to reconcile by mapping IS-family to TC-prefix, but the FP-family namespace is not in the cross-walk at all. **A Stage-2 synthesiser ingesting these three reports as written will silently confuse "level shifter D1" with "ESD bridge D.1".** This is a Stage-1 defect that propagates downstream identically to item-(a)'s.

**Convergence percentage estimate:** ~65 % topology-family overlap (DCVS / Wilson / brown-out / latch-up guard ring all appear in 3/3 angles; MTCMOS retention appears in 2/3 with the same "structurally absent" verdict; AC-coupled and HV level-up are in only 1–2 angles each). **Below the 70 % "suspicious convergence" threshold.** No cross-citation between FP and academic-survey detected (academic-survey explicitly says "First-principles sister report already performed the from-physics sanity checks ... Cross-checks performed *in this report*: ..." which is good independent-derivation framing). **The reports do *not* exhibit the (b)-style suspicious convergence — but they do exhibit the (a)-style topology-ID collision.**

### Specific revisions requested

1. **Fix the LS-HOSS2019 author/DOI/venue error** in `stage1-academic-survey/report.md` §1, §3 TC-3, §5.1, §10 conclusion #1; `stage1-academic-survey/references.md` LS-LUO2018/LS-HOSS2019 entry; `stage1-academic-survey/solutions.md` TC-3 row. The correct citation is **F. Kabirpour and S. Jalali, "A Low-Power and High-Speed Voltage Level Shifter Based on a Regulated Cross-Coupled Pull-Up Network," IEEE Trans. Circuits Syst. II: Express Briefs, vol. 66, no. 6, pp. 909–913, Jun. 2019. DOI: 10.1109/TCSII.2018.2872814.** Note this is **TCAS-II, not TVLSI**. The headline numbers (80 mV → 1.8 V, 0.18 µm post-layout sim, 123 nW @ 1 MHz, 23.7 ns) are correct for *this* paper. The architectural verdict ("strongest topology import for our project") survives the re-attribution because the paper's *content* matches.

2. **Reconcile LS-LUT2010 vs LS-HOSS2014 descriptions.** The academic-survey conflates the two papers. LUT2010 is **simulation in 90 nm, 100 mV–1 V, 18.4 ns at 200 mV input, 6.6 nW**. HOSS2014 is **0.18 µm post-layout sim, 0.4 V → 1.8 V, 31 ns, 1.16 nW static, 0.68 µW @ 1 MHz**. Neither paper has a "190 mV at 130 nm silicon" headline. Re-write `§3 TC-2`, the §9 comparison-readiness row, and the references.md entries to reflect the actual paper content.

3. **Re-namespace the topology IDs across all three reports**:
   - First-principles: re-prefix to `FP-A1, FP-B1, FP-D1, FP-E1, ...`.
   - Industry-survey: re-prefix to `IS-A1, IS-B1, IS-D1, IS-E1, ...`.
   - Academic-survey: keep `TC-...` (already cleanly namespaced).
   - Add a cross-walk table to each report mapping its IDs to the others.
   - **This is the same fix as item (a) and item (k)** — apply mechanically.

4. **Add components.md / solutions.md / references.md / open-questions.md to `stage1-industry-survey/`** *or* explicitly document, in the report itself (not just in INDEX.md), that these are merged with first-principles. Per `METHODOLOGY.md` lines 264–288 the per-stage file split is a hard requirement. If the project owner decides to waive it, the waiver should be visible to a reader of the report, not buried in INDEX.md.

5. **Populate `references-cache/`.** At minimum, mirror or SHA-256 the four open-access-verifiable references: TANG2014 Berkeley TR PDF, SHRIV2015 wics/umich PDF, MUTOH1995 Semantic-Scholar abstract, the sky130 hvl GitHub `cells/` directory listing. The other refs are paywalled and per the brief get "DOI resolved, abstract matches" without SHA.

6. **Soften the §1 executive-summary recommendations** in all three reports to avoid premature narrowing. First-principles' "Recommended floorplan ... analog[1]/analog[0]" should move to §8 open questions until Stage 2; industry-survey's "minimising HARV-side pad count is the dominant lever" should be flagged as a *hypothesis* requiring Stage-2 reconciliation; academic-survey's "TC-3 is the strongest topology import" should be replaced with "TC-3 is the only topology with measured/sim data at our exact node, and is therefore a Stage-2 import candidate; the citation needs the fix in revision #1 first".

7. **Add a sanity-check on the per-pad RC-clamp leakage source.** The industry-survey's "648 nA per dvdd-clamp" and "1296 nA per corner" are the load-bearing numbers behind the "10 µA static on v1 today" budget claim, and that claim is the load-bearing input to the "minimising HARV-side pad count is the dominant lever" recommendation. The number does not appear in the cited PDK CDL/SPICE files — it appears to be a SPICE-simulation result not documented in the report. Cite the source (or run the SPICE).

## Closing notes

The first-principles report is the strongest product of the three. Every PDK-internal claim is anchored in a path-and-line citation, the topology family / strategy taxonomy is internally consistent, and the §5 sanity checks are derived from first principles rather than copied from a literature anchor. The author's-notes self-assessment ("~0.8 confidence") is appropriately calibrated.

The industry-survey is the weakest. The single-file structure is a defect, and the "industry" angle ends up being mostly a re-statement of the PDK audit (which is already first-principles' job) plus three USPTO patents and two app-notes that aren't deeply discussed. Whether the "industry-survey" angle has anything materially different to say from "first-principles + a list of PDK files" needs interrogation. If not, merge the two; if so, expand the patent / open-source-IP / commercial-multi-domain-SoC content.

The academic-survey is the most ambitious of the three. The novel finding (RCC topology is the right family, even if the citation is wrong) is genuinely valuable. The Caravel sky130-hvl-cell port idea (§NR4, OQ-A6, OQ-A7) is a high-leverage Stage-2 work item: the sky130 hvl `lsbufhv2lv` / `lsbuflv2hv` cells **do exist** under Apache 2.0 and are *circuit-portable* to GF180MCU even if the device models aren't. **The CHEN2021 parasitic-NPN warning** (§5.4, §TC-extra) is a real finding that the first-principles analysis missed — Stage 2 should propagate this to (b) NFC harvester floorplan and (h) NFC core floorplan, since both will share substrate with the harvested-rail PCOMP guard.

**Programme-wide pattern continued: this is now item-(i) in addition to (a)/(b)/(d)/(f) where a Stage-1 academic-survey agent has hallucinated authorship for a load-bearing citation.** 8/8 prior reviews caught this; now 9/9. The pattern is *systematic* — at this point, every Stage-1 academic-survey reviewer should automatically WebSearch every cited author + title combination as a default check. A list of misattributions to date:
- (a) AC-RC-2 — "Hsiao" → Mirchandani & Shrivastava
- (a) AC-SUB-1 — "Lee 2016 DLS ring" → CERO topology
- (b) G3 — "Sun, Pan et al." → Godinho et al.
- (d) R2 — "Awad" → Pakkirisami Churchill
- (d) B.6 — "Honma" → Nguyen
- (f) — "Davis" → Greene
- (i) LS-HOSS2019 — "Hosseini, Maghami, Bahmani, Bolurian, Lotfi, Sodagar" → Kabirpour & Jalali (also TVLSI → TCAS-II, also DOI 404)
- (plus HOSS2014 / LUT2010 description-conflation in (i))

Each new item adds one or two more. There is no good reason to accept an academic-survey for any future item without a default WebSearch / Semantic-Scholar verification of every author-title combination. The Stage-2 synthesiser should treat any un-verified academic citation as suspect by default.
