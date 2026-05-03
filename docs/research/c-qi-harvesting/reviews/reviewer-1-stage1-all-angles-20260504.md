---
report_under_review: docs/research/c-qi-harvesting/stage1-{first-principles,industry-survey,academic-survey}/
reviewer: claude-opus-4-7-1m (independent reviewer agent #1, item c, all three angles)
date: 2026-05-04
verdict: revisions-requested
---

## Verdict

**revisions-requested.** All three Stage-1 reports are *substantively
sound* — the headline architectural conclusions (off-resonant A2
forced by R4, native-NMOS bridge as best µW–mW free-rider candidate,
≤19 % free-rider duty cycle, distinct-rectifier / shared-LDO sharing
model) survive scrutiny and the WPC timing constants, Infineon FOD
margins, and Petzel-thesis hazards verify against the locally cached
authoritative sources. **However** there are three classes of
significant defect that block sign-off:

1. **Multiple academic-survey citation hallucinations** (programme-
   wide pattern continues — 8/8 items now). The pattern is now
   *systematic*: every item Stage-1 academic-survey reviewer has
   visited has misattributed at least one DOI/author tuple.
2. **An incomplete §5.6 cap-arithmetic correction** in the first-
   principles report. The `0.11 mm² → 111 mm²` area scale-up
   (commit 18505ee per CORRECTIONS.md) was applied but the
   *capacitance value labels* (1.67 µF, 167 nF) are still 1000×
   smaller than the load currents would require. The infeasibility
   verdict is reinforced — but the report is now internally
   inconsistent in the wrong direction.
3. **The 5-file split of the industry-survey** (commit 2c85e79)
   was advertised as "content unchanged" but added 5 new reference
   rows (D3, D6, W9, W10, W11) and dropped one (A5 — Cha et al.
   MDPI Energies). Mechanical sweep needed.

None of these warrants a redo-from-scratch *fail*; all are
mechanical fixes that can be made in place, after which I would
sign off the (c) Stage-1 set.

## Findings

### Reference verification (REQUIRED)

Spot-checks performed (≥5 per REVIEWER.md):

| Citation | URL/DOI resolved? | Document matches citation? | Local cache present? | Local cache matches upstream? |
|---|---|---|---|---|
| WPC PC0 v1.2.3a (FP, IS, AC) | yes | **yes** — Table 8 (line 2500–2509) confirms `t_ping = 65.0–70.0 ms`, `t_terminate ≤ 28.0 ms`, `t_first ≤ 20.0 ms`, `t_expire ≤ 90 ms`; §5.1.2.6 (line 3275) confirms `t_restart = 500 ms` — **with caveat** (see "Specific revisions" #3) | yes (`wpc-qi-pc0-v1.2.3a/`) | yes (PDF SHA-256 in references.md, verified 3 906 798 bytes) |
| Infineon AN234970 FOD (IS) | yes | **yes** — line 1080 confirms BPP power-loss FOD threshold default 325 mW; line 1093 confirms hard-latch threshold 1000 mW; line 1151 confirms 15W EPP threshold 750 mW. Industry-survey claim verbatim. | yes (`infineon-fod-tuning/`) | yes (PDF + extracted txt) |
| Petzel 2020 TU Graz §3.6.4 (IS, AC) | yes | **yes** — §3.6.4 (line 4142+) explicitly derives both over-voltage failure (peak-IC voltage ≈ 3× induced voltage from L–C overshoot) and over-current failure (≈ 0.67 A through limiter vs ~30 mA absolute max for typical NFC IC). Industry-survey's "either over-V or over-I" framing is correct. | yes (`petzel-2018-thesis/`) | yes |
| Vinod-Tanur ATtiny13A repo (IS) | yes | **partial** — repo at `github.com/vinodstanur/qi_wireless_receiver_attiny13` exists (created 2019-04-01, 59 stars). `main.c` is **130 lines of C**, not the implied "~500 gates" of an HDL design. The repo sends Ping Response Packet (0x01), Control Error Packet (0x03), and Received Power Packet (0x04). It does **not** send Identification Packet (0x07) or Configuration Packet (0x51). The "~500 gates" gate-count claim is therefore an extrapolation, not a measured number, and should be tagged as such. | n/a | n/a |
| LeeGhov2011 PMC mirror (AC) | yes (PMC3235652) | yes — title, authors, year, journal, technique all match the citation | n/a (copyright-restricted) | N/A |
| LuKi2014 (AC) | yes (DOI 10.1109/TBCAS.2013.2270177) | yes — Yan Lu, Wing-Hung Ki, 2014, TBioCAS, 13.56 MHz CMOS Active Rectifier With Switched-Offset and Compensated Biasing | n/a | N/A |
| ChaPark2012 (AC) | yes (DOI 10.1109/TCSII.2012.2198977) | yes — Hyouk-Kyu Cha, Woo-Tae Park, Minkyu Je, 2012, TCAS-II | n/a | N/A |
| Mandal2007 (AC) | yes (DOI 10.1109/TCSI.2007.895229) | yes — Soumyajit Mandal, Rahul Sarpeshkar, 2007, TCAS-I | n/a | N/A |
| Khan2018-Energies (AC) | yes (DOI 10.3390/en11030479) | yes — full author list and title match | n/a | N/A |
| Wu2019-Qi (AC) | yes (DOI 10.1007/s11432-018-9584-4) | yes — 4 authors match; note the journal date is 2018 online / 2019 print | n/a | N/A |
| Wu2020-AICSP (AC) | yes (DOI 10.1007/s10470-019-01582-z) | yes — Chubin Wu, Zhang Zhang, Xin Cheng, Guangjun Xie | n/a | N/A |
| **ChengKi2017 R³ (AC)** | **partial** — cited DOI 10.1109/JSSC.2017.**2658942** is **broken (404)**. Correct DOI is 10.1109/JSSC.2017.**2657603** (per dblp; authors Lin Cheng, Wing-Hung Ki, Chi-Ying Tsui, JSSC vol 52 no 5 2017). Title and authors match the citation; only the DOI digit-string is wrong. | n/a | N/A |
| **ChengKi2016 (TBioCAS) primary-equaliser (AC)** | **NO** — cited DOI 10.1109/TBCAS.2015.**2480060** is **broken (404)**. The actual TBioCAS paper "Reconfigurable Resonant Regulating Rectifier With Primary Equalization for Extended Coupling- and Loading-Range in Bio-Implant Wireless Power Transfer" has DOI 10.1109/TBCAS.2015.**2503418** (vol 10 no 3 2016). **Authors are Xing Li, Xiaodong Meng, Chi-Ying Tsui, Wing-Hung Ki — NOT** "Cheng, L., Ki, W.-H., Lu, Y., and Yim, T.-S." as cited. **Citation hallucination.** | n/a | N/A |
| **QuangHa2015-WideTriple (AC)** | partial — cited DOI 10.1007/s10470-015-0650-8 resolves to "A design of wide input range triple-mode active rectifier with peak efficiency of 94.2 % and maximum output power of 8 W for wireless power receiver in 0.18 µM BCD" with first author **Young-Jun Park** (11 authors total). **Authors cited as "Quang, P. H. and Lee, J.-W. (2016)" are not on this paper at all** — Quang Phu Ho Van's work is the *related* TIE 2015 paper, not this AICSP one. **Citation–paper mismatch.** | n/a | N/A |
| **Quang2015-TIE (AC)** | partial — cited DOI 10.1109/TIE.2014.**2334658** is **broken (404)**. Correct DOI is 10.1109/TIE.2014.**2336618** (per dblp). Authors are Phu Ho Van Quang, Thanh Tien Ha, Jong-Wook Lee — match. Only the DOI digit-string is wrong. | n/a | N/A |
| **LeeKim2021-Energies (AC)** | partial — cited DOI 10.3390/en14238089 resolves, but to "A CMOS Active Rectifier with Efficiency-Improving and Digitally Adaptive Delay Compensation for Wireless Power Transfer Systems" by **Yichen Zhang, Junye Ma, Xian Tang** — *not* "Lee, J. and Kim, M." as cited. **Citation hallucination.** | n/a | N/A |
| ISSCC 2016 conference version of R³ (AC) | broken — cited as 10.1109/ISSCC.2016.**7418071** which resolves to a Butz et al. paper on "neural stimulators" (paper 22.6), not Cheng et al. (paper 21.7). Correct DOI is 10.1109/ISSCC.2016.**7418064**. | n/a | N/A |

**Citation-hallucination tally for item (c) academic-survey: 4
distinct misattributions (ChengKi2016, QuangHa2015-WideTriple,
LeeKim2021-Energies, ISSCC 2016 conference version of R³) plus 2
broken-DOI-with-correct-author cases (ChengKi2017, Quang2015-TIE).**
This continues the 7/7 prior-pattern → **8/8 with this item**.

### Solution-space coverage

§3 of each report is genuinely exhaustive within its stated scope:
- **First-principles** decomposes A/B/C/D axes with 5 / 5 / 6 / 5
  alternatives respectively, including A6 (receiver-side detuning,
  later merged into C5) which is a less-obvious option. ✓
- **Industry-survey** lists 5 rectifier × 3 regulator × 3
  protocol-participation × 3 system-architecture variants. ✓
- **Academic-survey** lists 6 silicon-paper-anchored rectifier
  topologies (B1–B6) plus 3 regulator topologies (C1–C3) plus 3
  protocol-tier topologies (D1–D3) plus a 5-paper system-level
  group (E1–E5). ✓ At ≥ 5 distinct families this clears the
  TEMPLATE.md §3 quality bar.

Approaches mentioned in the per-item README that any report
omitted: README §1 (Qi 2.x EPP / MPP) is partially covered (FP-D4
/D5 explicit reject; IS V3 and academic-survey AS-D4 also explicit
reject) — covered, no gap. README §6 (over-voltage / FOD)
extensively covered in all three. README §5 (NFC↔Qi coexistence)
covered well in all three.

Approaches that the *parallel sister reports* covered that this
one did not:

- First-principles introduces "B2 native-NMOS bridge with
  unique-LF advantage" verbatim; **academic-survey's NR-A3
  honestly admits "no published academic Qi-band native-NMOS
  rectifier"** — the report does the right thing here (gap-finding
  rather than over-claiming); ✓
- Industry-survey introduces V3 (multi-mode receiver across
  Qi BPP + EPP + MPP + PMA); first-principles does not.
- Academic-survey introduces AS-B6 (triple-mode auto-select)
  uniquely.

The three reports are **complementary**, not redundant. Each
adds material the others lack.

### Premature narrowing

- First-principles spends ~430 lines, ≤30 % on any one architecture
  (§3.6 table presents 5 viable architectures with comparable
  treatment in §9). ✓
- Industry-survey spends ≤25 % on any one (the bq51013B is the
  most-named anchor but only as an example). ✓
- Academic-survey spends roughly equal length on B3, B4, B5;
  Khan2018 is the most-cited anchor but the report explicitly
  flags it as "the single most relevant paper" *with reasoning*,
  not as a pre-judged winner. ✓

No executive summary picks a winner. ✓ Stage-1 hygiene preserved.

### Numerical claim verification

Three independent recalculations performed (plus extras):

#### Recalc-1: §5.1 Wheeler inductance estimate (FP)

Report: `L = 6.18 µH` from K₁=2.34, K₂=2.75, n=8, d_avg=42.65 mm,
ρ=0.109. Modified-Wheeler formula:
`L = K₁ μ₀ n² d_avg / (1 + K₂ ρ)`.

My recompute: `L = 2.34 × 1.2566e-6 × 64 × 0.04265 / (1 + 2.75×0.109)
= 6.175 µH`. **Match. ✓**

#### Recalc-2: §5.2 Open-circuit voltage (FP)

Report: `V_oc_pk = n A ω B_pk = 8 × 2.24e-3 × 2π·140 kHz × 2 mT
= 31.5 V_pk`.

My recompute: `8 × 0.00224 × 8.80e5 × 0.002 = 31.53 V_pk`. **Match. ✓**

EPP at 5 mT: report 78.7 V_pk; my 78.82 V_pk. **Match. ✓**

#### Recalc-3: §5.4 Synchronous-rectifier dead-time budget (FP)

Half-period at 140 kHz: my 3 571 ns; report 3.57 µs. **Match. ✓**
Half-period at 13.56 MHz: my 36.87 ns; report 36.8 ns. **Match. ✓**
4 % dead-time at 140 kHz: my 142.9 ns; report 143 ns. **Match. ✓**
4 % dead-time at 13.56 MHz: my 1.47 ns; report 1.5 ns. **Match. ✓**

#### Recalc-4 (DEFECT FOUND): §5.6 storage-cap arithmetic (FP)

This is the area flagged in CORRECTIONS.md as already-corrected
(commit 18505ee). The fix is **incomplete**.

The report currently reads:

> "1 mA load: C = 1.67 µF → 1110 mm² — infeasible (corrected
> 2026-05-04 — was '1.11 mm²' with 1000× cap-arithmetic error)."

> "100 µA average load: C = 167 nF → 111 mm². INFEASIBLE on-die
> (corrected 2026-05-04 — was '0.11 mm² Feasible'; same 1000×
> error)."

**The area numbers are arithmetically correct for the stated
capacitance values** (1.67 µF = 1.67e9 fF / 1.5 fF/µm² = 1.11e9 µm²
= 1110 mm²; 167 nF = 1.67e8 fF / 1.5 fF/µm² = 1.11e8 µm² = 111 mm²).
**The capacitance values themselves are wrong by 1000×.**

For 1 mA load over 500 ms holdup at 0.3 V droop (10 % of a 3 V
rail): C = I·dt/dV = 1e-3 × 0.5 / 0.3 = **1.67 mF**, not 1.67 µF.
At 1.5 fF/µm² that is 1.11×10⁹ µm² × 1000 = **1.11×10⁶ mm²**, i.e.
~1.1 m². Verdict (infeasible) is unchanged but the magnitude is
now 1000× *more* infeasible than the corrected report shows.

For 100 µA load over 500 ms at 0.3 V droop:
C = 1e-4 × 0.5 / 0.3 = **167 µF**, not 167 nF. At 1.5 fF/µm² that
is **111 000 mm²**, again 1000× the report's 111 mm².

The 5 ms / 1.67 nF / 1.1 mm² alternative bullet ("e.g. 5 ms,
giving C ≥ 1.67 nF → 1.1 mm² — still tight but feasible") is
*also* internally inconsistent: at 1 mA over 5 ms with 0.3 V droop
C = 16.7 nF (not 1.67 nF); the 1.67 nF value would only support
~100 nA load, not the 1 mA earlier in the same paragraph.

**This is a 1000× underestimate of cap-area infeasibility — the
*opposite direction* of the CORRECTIONS.md sweep.** Stage-2 must
not propagate the 1110 mm² figure; the correct figure for "store
1 mA × 500 ms with 10 % droop on 3 V" is ~10⁶ mm² (off-die
mandatory), or — if on-die required — drop the load to ~µA-class
or shorten the holdup window to ~ms.

#### Recalc-5: §3.4 free-rider duty-cycle derivation (FP)

Report claims "max duty cycle for non-compliant receivers is
≈ 19 % (95 ms / 500 ms)".

My recompute against the WPC spec: per Table 8, `t_ping =
65–70 ms` and `t_terminate ≤ 28 ms`. After `t_first` (= 20 ms,
embedded *within* `t_ping`), if no SSP arrives the PTx must
terminate within `t_terminate`. Total worst-case
power-applied window = `t_ping_max + t_terminate_max ≈
70 + 28 = 98 ms`. The report uses 95 ms — within rounding.

Then `t_restart = 500 ms` minimum before next ping. Duty cycle
= 98/500 = 19.6 %. **Report's 19 % verifies arithmetically. ✓**

**However** (see Specific revisions #3): `t_restart = 500 ms`
appears in the spec **only in the §5.1.2.6 path triggered by an
End Power Transfer Packet with code 0x0B (Restart Power
Transfer)**. A free-rider that never sends EPT/0x0B does not
necessarily trigger the 500 ms-restart timer; what governs the
inter-ping interval in the *no-receiver-detected* path is the
unspecified PTx implementation policy (typically 0.4–5 s on
commercial pads). The report's industry-survey [W1] correctly
notes that "the TX simply removes the Power Signal within ~90 ms
(analog ping duration) and goes back to selection" — but
selection-phase inter-ping cadence is *not specified by the
WPC spec at PC0 v1.2.3*. The 19 % number is therefore an
*upper bound under the most-aggressive plausible PTx*, not a
spec-mandated number for the free-rider case. The report should
clarify this.

### Negative results

All three reports include substantive negative results:

- **First-principles**: 6 NRs (NR1–NR6), each with conditions and
  failure-mode detail.
- **Industry-survey**: 5 NRs (N1–N5), each anchored in a
  specific source (Petzel, no commercial Qi-IC voltage doublers,
  PMA EOL, etc.).
- **Academic-survey**: 6 NRs (NR-A1–NR-A6), each with explicit
  source and operating-regime context. NR-A1 ("no published
  academic Qi free-rider receiver") is a particularly clean
  gap-finding.

All three reports clear TEMPLATE §7. ✓

### Convergence with parallel reports

Pairwise topology-overlap (rough):

| Pair | Shared rectifier topologies | Shared regulator topologies | Shared protocol tiers | Overlap % |
|---|---|---|---|---|
| FP ↔ IS | B1=A1, B2=A4, B3=A3, B4=A2, B5=A5 | C1=B1, (FP)C3,C5,C6 unique to FP | D1=C2/C3, D2 unique, D3=C1 | ~70 % |
| FP ↔ AC | B1=AS-B1, B2=AS-B2, B3=AS-B3, B4=AS-B4 (rough), B5=AS-B5 | C1=AS-C1, C5=AS-C3 (R³) | D1 vs AS-D1 same gap; D3=AS-D3 | ~75 % |
| IS ↔ AC | A1=AS-B1, A3=AS-B3 (∪ AS-B4), A4=AS-B2 | B1=AS-C1 | C1=AS-D3, C2=AS-D1 | ~70 % |

**Suspicious convergence flag: borderline.** Three independent
researchers all converged on (B1/A1) passive-bridge / (B2/A4)
diode-MOS / (B3/A3) cross-coupled / (B4/A2) doubler / (B5/A5)
hybrid as the rectifier taxonomy. Given that this is the
textbook-standard taxonomy of CMOS rectifiers (per Cheng & Ki
SpringerCh2017), 70 %+ overlap is *expected* for this domain;
unlike (b) and (k), the angles each contribute substantive
non-overlapping material:

- FP uniquely contributes the on-die-cap-budget physics (§5.6),
  the half-period dead-time scaling (§5.4), the NFC↔Qi mutual
  coupling (§5.8), and the architectural-sharing matrix.
- IS uniquely contributes the Vinod-Tanur free-rider exhibit,
  the Infineon AN234970 FOD numbers (325 / 1000 mW), the
  bq51013B "20 V Vrect guarantee does not apply to non-compliant
  receivers" gotcha, and the Petzel-thesis NFC-IC failure modes.
- AC uniquely contributes the Khan2018 "off-resonant Qi
  receivers exist in the silicon literature at LF" risk-reducing
  finding, the bio-implant TBioCAS lineage, and the explicit
  "no peer-reviewed Qi free-rider paper" gap-finding.

Topology-ID collisions are *minor* in (c):

- All three angles use B1, B2, B3, ... but with slightly
  different family assignments (e.g. FP-B5 = "hybrid passive +
  active" vs IS-A5 = "P9221-R3 hybrid adaptive-delay" vs AS-B5
  = "R³ reconfigurable resonant regulating rectifier"). The
  collision is mostly orthogonal — different concepts under the
  same letter. Stage-2 must namespace as `FP-*`, `IS-*`, `AS-*`
  (academic-survey already uses `AS-*`; FP and IS need
  re-namespacing).
- Industry-survey's V1/V2/V3 system-architecture-variant IDs
  collide with FP's V1/V2 nowhere, since FP doesn't use V*-style
  IDs. ✓

This is much milder than (a)/(k) topology-ID collision.

### Specific revisions requested

1. **Fix academic-survey citation hallucinations** (highest priority,
   programme-wide pattern). Edits needed to
   `stage1-academic-survey/references.md`:
   - **[ChengKi2016]**: replace authorship "Cheng, L., Ki, W.-H.,
     Lu, Y., and Yim, T.-S." with **"Li, X., Meng, X., Tsui, C.-Y.,
     and Ki, W.-H."**. Replace DOI 10.1109/TBCAS.2015.**2480060**
     with **10.1109/TBCAS.2015.2503418**. Update PMID claim too
     (claimed 26742141; needs verification — I did not check this
     PubMed ID directly). Rename citation key to `[LiKi2016]` for
     consistency.
   - **[QuangHa2015-WideTriple]**: replace authorship "Quang, P. H.
     and Lee, J.-W." with the actual 11-author list led by
     **Young-Jun Park** (and including Kang-Yoon Lee as last
     author). The Quang TIE-2015 paper and this AICSP-2016
     paper share Korean-team membership but have *different first
     authors* — the academic-survey conflated them.
   - **[Quang2015-TIE]**: fix DOI from 10.1109/TIE.2014.**2334658**
     (broken) to **10.1109/TIE.2014.2336618**.
   - **[ChengKi2017]**: fix DOI from 10.1109/JSSC.2017.**2658942**
     (broken) to **10.1109/JSSC.2017.2657603**. Authors are
     correct (Lin Cheng, Wing-Hung Ki, Chi-Ying Tsui).
   - **[LeeKim2021-Energies]**: replace authorship "Lee, J. and
     Kim, M." with **"Zhang, Y., Ma, J., and Tang, X."** (DOI
     10.3390/en14238089 is correct; only the authors are wrong).
     Rename key to `[ZhangMa2021-Energies]`.
   - **ISSCC 2016 conference cite**: fix DOI from
     10.1109/ISSCC.2016.**7418071** (which is paper 22.6, Butz et
     al. neural stimulator) to **10.1109/ISSCC.2016.7418064**
     (paper 21.7, the actual Cheng/Ki/Wong/Yim/Tsui R³ ISSCC
     paper). Update the verification line that quotes "21.7 A
     6.78 MHz 6 W wireless power receiver…" — this title is
     correct but the DOI digit-string was wrong.

2. **Fix incomplete §5.6 cap-arithmetic correction** in
   `stage1-first-principles/report.md`:
   - Either: scale the *capacitance values* up 1000× (1.67 µF →
     1.67 mF; 167 nF → 167 µF; 1.67 nF → 1.67 µF), keeping the
     load currents 1 mA / 100 µA / 1 mA. The areas then become
     1.11×10⁶ mm² / 1.11×10⁵ mm² / 1.11×10³ mm² respectively,
     all infeasible on-die.
   - Or: scale the *load currents* down 1000× (1 mA → 1 µA;
     100 µA → 100 nA), keeping the capacitance values. The areas
     stay as currently shown.
   - Either way, add a note: *"Storage-cap survival of the 500 ms
     ping-off window at any sustained load above ~1 µA is
     off-die-mandatory; on-die storage is only viable for
     burst-discharge of µA-class loads over ms-scale holdup
     windows."*
   The current state is internally inconsistent and propagates
   the wrong number to Stage 2.

3. **Tag `t_restart = 500 ms` as scenario-conditional** in FP §3.4
   and §5 / industry-survey N. The 500 ms value comes from
   §5.1.2.6 of WPC PC0 v1.2.3 only after a Restart Power Transfer
   EPT (code 0x0B). For the free-rider path (no SSP, no EPT),
   the *selection-phase* inter-ping cadence is implementation-
   defined (industry-survey already cites typical 0.4–5 s).
   First-principles' "duty cycle ≤ 19 %" should be re-tagged
   "duty cycle ≤ 19 % under aggressive PTx (500 ms inter-ping);
   2–10 % is more typical".

4. **Fix Vinod-Tanur free-rider gate-count claim** (industry-
   survey). The implementation is ~130 lines of C on an ATtiny13A
   (MCU, not synthesised hardware); the "~500 gates" figure is a
   later extrapolation, not a measured number, and the actual
   packets sent are *Ping Response Packet (0x01)*, *Control Error
   Packet (0x03)*, and *Received Power Packet (0x04)* — **not** a
   Signal Strength Packet (0x01 SSP per WPC §6) despite the
   coincident packet-header byte. This distinction matters:
   "minimum-viable WPC v1 packet sequence" is **not** what the
   ATtiny13A code does — it sends SSP-equivalent + CEP + RP only,
   without Identification or Configuration. Industry-survey
   should either: (a) drop the "~500 gates and minimum-viable WPC
   v1 packet sequence" framing and re-anchor in the actual sent-
   packet list; or (b) flag the gate-count number as
   "extrapolated, not measured" and the packet-list as
   "incomplete vs WPC v1.x §5.1.3 sequence".

5. **Repair the 5-file split**. Commit 2c85e79 was advertised as
   "Content unchanged — pure structural split". Audit shows 5
   reference-list rows were *added* (D3, D6, W9, W10, W11 — these
   are reasonable additions but should be flagged as net-new
   research, not split-out content) and 1 row was *dropped* (A5,
   "Lee & Mok 2012 IEEE TBioCAS active rectifier" — present in
   the pre-split report.md, absent from references.md).
   Additionally, open-questions.md grew from 6 to 8 questions
   (Q-7 AC-clamp area cost and Q-8 Qi-pad TX whitelist appear to
   be new). The added open-questions are reasonable extensions;
   the lost A5 reference and the unflagged new D3/D6/W9/W10/W11
   references should be either reinstated/removed or
   acknowledged as additions in a follow-up commit.

6. **Verify the [Khan2018-Energies] resonance-cap claim** more
   carefully (academic-survey OQ-A2 raises this). The report
   says the Khan paper achieves 85.3 % at Qi BPP; OQ-A2 then
   asks whether the resonance cap is on-die. The MDPI PDF is
   freely available — Stage-2 should fetch and verify whether
   Khan's IC is genuinely *on-die-cap* free or whether the
   85.3 % number assumes an external series-resonance cap (in
   which case the architecture is *not* directly portable to
   our R4-constrained design and the academic-survey's "risk
   reduces" conclusion needs softening).

7. **Stage-2 should re-derive the 0.95 W headline** carefully.
   First-principles §3.4 computes "average power into a non-
   compliant receiver is therefore at most 475 mJ / 500 ms =
   0.95 W". This **assumes the PTx delivers full 5 W during the
   ping window**, which is *not* true on commercial pads — the
   Digital Ping is at low-power (typically 50–500 mW) until the
   receiver responds. The 0.95 W is an order-of-magnitude over-
   estimate of free-rider average power. The qualitative
   conclusion ("19 % duty") is unchanged but the absolute power
   number is not load-bearing.

## Closing notes

The Stage-1 (c) trio is *substantively* the strongest of the
items I have reviewed. The first-principles report's identification
of the 500 ms-inter-ping behaviour as the binding constraint, the
industry-survey's discovery of the Petzel thesis as a load-bearing
single-document anchor, and the academic-survey's risk-reducing
identification of the Khan2018-Energies prior — these are
genuinely useful research findings that Stage-2 can build on. The
defects flagged above are mechanical, not architectural.

The academic-survey citation hallucinations (item 1 above) are
the most worrying finding because they continue an *exact*
programme-wide pattern: every Stage-1 academic-survey on every
item visited so far has misattributed at least one DOI/author
tuple, and the misattributions look *systematically* like
hallucinated-from-context-clue rather than typos. The pattern is
strong enough that Stage-2 should treat *every* academic-survey
citation as suspect-until-DOI-verified, and the orchestrator
should consider building a CI check that pings Crossref / dblp
for every cited DOI as part of the per-commit hook.

Sign-off conditional on items 1, 2, and 3 being addressed; items
4, 5, 6, 7 are nice-to-haves but should land before Stage-2 to
avoid propagating bad anchors downstream.
