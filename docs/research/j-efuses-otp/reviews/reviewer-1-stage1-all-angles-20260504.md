---
report_under_review: docs/research/j-efuses-otp/stage1-{first-principles,industry-survey,academic-survey}/
reviewer: claude-opus-4-7-1m / reviewer-1
date: 2026-05-04
verdict: revisions-requested
---

## Verdict

**revisions-requested.**

The first-principles and industry-survey angles for (j) are
substantively correct on their headline finding — the
`gf180mcu_fd_pr__efuse` PCell ships, has DRC/LVS/SPICE support,
and the SPICE comment block does say "6V/(5V) efuse" — and both
include reasonable physics sanity checks. However the academic-
survey angle contains **multiple citation-author misattributions
of the type CORRECTIONS.md flags as a programme-wide pattern**,
plus a substantive technical error that contradicts the cached
Tonti 2008 paper. The first-principles report has one
silicide-chemistry conflation (importing Tonti 2003 WSi₂ data
into a "POLY-EFUSE-COSI2" topology bucket) that propagates from
the academic survey. None of the issues are fatal; all three
reports are salvageable with the revisions itemised below.

The Tonti 2003 25-pulse-train claim **does hold up** against the
cached PDF (verified at lines 150–166 of the extracted text) —
that is the single most load-bearing finding from the academic
survey and it is solid. So is the bunnie-cached Kothandaraman
2002 360 Ω transient claim (verified, though the academic
survey's "internal inconsistency flag" against it is itself
under-derived; see §Numerical claim verification below).

## Findings

### Reference verification (REQUIRED)

| Citation | URL/DOI resolved? | Document matches citation? | Local cache present? | Local cache matches upstream? |
|---|---|---|---|---|
| TONTI-2003-IRW (academic + FP) | yes | yes — but **silicide chemistry is WSi₂, not CoSi₂** (line 30 of cached text: "Tungsten Silicide E-Fuse (WSi₂)") | yes (`references-cache/tonti-2003-irw/`) | yes (read in full via pdftotext, 548 lines extracted) |
| TONTI-2008-SSIRI (academic + FP) | yes | yes; "1E10 Ω" test resolution claim verified at line 87; **but "one chance" programming-attempt limit at lines 87–93 contradicts academic-survey components.md `RE_PROGRAM` retry FSM state** | yes (`references-cache/tonti-2008-ssiri/`) | yes (219 lines extracted) |
| KOTHANDARAMAN-2002-EDL (academic + FP) | yes | yes — silicide is **CoSi₂** (line 90 confirms cobalt EDAX), 200 µs at 1.5 V gate, 10 mA peak, V_FS=3.3 V, 360 Ω transient verified | yes (`references-cache/kothandaraman-2002-edl/`) | yes (211 lines extracted via pdftotext) |
| TONTI-PATENT-US-7485944 (academic) | yes (Google Patents) | **FAIL — citation-author misattribution**. Patent inventors are **Kothandaraman & S. S. Iyer**, NOT W. R. Tonti. References.md attributes it to "W. R. Tonti." | n/a | n/a |
| WANG-2014-ASICON (academic) | resolves via Google Scholar | **FAIL — wrong authors AND wrong venue/year**. Title resolves to **Liu, Zheng, Sun, 2015 ISNE** (NOT Wang, 2014 ASICON). References.md says "W. Wang et al., 2014 IEEE 12th ASICON Proceedings". | n/a | n/a |
| LEE-2011-JSTS (academic) | resolves via Google Scholar | **FAIL — wrong author/venue/year**. The paper "A 32-KB standard CMOS antifuse OTP ROM embedded in a 16-bit microcontroller" is by **Cha, Yun, Kim, So, Chun, Nam, Lee in IEEE JSSC 2006** (NOT JSTS, NOT 2011, NOT "J. Lee"). | n/a | n/a |
| KIM-2007-OTPROM (academic) | resolves via Google Scholar | **FAIL — wrong author/venue/year**. The paper "Three-transistor OTP ROM cell array using standard CMOS gate-oxide antifuse" is **J. Kim & K. Lee, IEEE EDL 2003** (NOT "S.-S. Kim et al."). solutions.md additionally has internal inconsistency: cites "Kim 2007 IEEE TVLSI" in §ANTIFUSE-3T but "Kim 2007 ISCAS" in §ANTIFUSE-2T. | n/a | n/a |
| KIM-2011-JSTS (academic) | yes | yes — "J.-H. Kim, D.-H. Kim, L. Jin, P.-B. Ha, Y.-H. Kim, JSTS 11(2), 2011" verified via koreascience open access | n/a | n/a |
| SIDENSE-US-7402855 (academic) | yes | yes — Kurjanowicz et al., 2008 split-channel antifuse | n/a | n/a |
| HAN-2019-EDL (academic) | URL resolves to NASA NTRS | not verified — the WebFetch call returned a binary PDF that could not be parsed; **NEEDS NEXT REVIEWER**. The references.md notes the URL was checked in a prior pass; the document is not retrievable as text via this reviewer's tools. | n/a | n/a |
| ROBSON-2007-CICC (academic) | yes | yes — N. Robson, J. Safran, C. Kothandaraman, A. Cestero, X. Chen, R. Rajeevakumar, A. Leslie verified via Google Scholar | n/a | n/a |
| GF180MCU-PDK eFuse (FP + IS) | yes (local mirror) | yes — `libs.ref/gf180mcu_fd_pr/{gds,mag}/efuse*` and SPICE model at `libs.tech/ngspice/sm141064.ngspice:47007` verified directly. SPICE comment at line 102: "Subcircuit model for 6V/(5V) efuse". R_intact ≤ 200 Ω, R_pblow ≥ 900 Ω verified at line 47035. PLFUSE 0.18 µm × 1.26 µm verified in `efuse.drc:42-52` (rules EF.02/EF.03). Cell GDS bbox verified by parsing efuse.gds: 11.28 × 4.38 µm = 49.4 µm² (the 4.38 µm extent comes from layer 31 = EFUSE_MK marker, NOT visible in efuse_cell.mag — the .mag file alone shows 11.28 × 2.26 µm = 25.5 µm²). | yes | yes |

**Spot-check count: 12.** Required minimum was 5. **Six failures
of various severity** found, all in the academic-survey
references.md. Three are programme-wide-pattern citation-author
misattributions (TONTI-PATENT, WANG-2014, LEE-2011, KIM-2007).
One is the Tonti 2003 silicide-chemistry mis-classification
(WSi₂ paper used as anchor for a CoSi₂ topology bucket). One is
a missing verification (HAN-2019). One contradicts a cached
paper (RE_PROGRAM retry state vs Tonti 2008 "one chance").

### Solution-space coverage

**Total distinct mechanisms catalogued across the three angles:**

- First-principles: 13 mechanisms (FUSE-POLY-SILICIDE, FUSE-METAL-EM, FUSE-LASER, ANTIFUSE-GOX, ANTIFUSE-CAP, FG-FLASH, CT-NVM, MASK-ROM, OFF-DIE-NVM, HV-PAD, TM-EXISTING-PAD, NFC-WRITE, PAD-STRAP). Per-item README scope (8 bullets) is fully covered.
- Industry-survey: 11+ topologies in §3.A–§3.G, with explicit "discarded for completeness" entries. Includes the kilopass i-fuse 1R1D and Sidense 1T-Fuse and eMemory NeoBit/NeoFuse — all real industrial topologies. The "OTP_MK without PCell" finding is a genuine and unique contribution to the cross-angle picture.
- Academic-survey: 8 silicon-paper-anchored topologies (POLY-EFUSE-COSI2/WSI2/NISI, ANTIFUSE-2T/1.5T/3T, FG-OTP-SINGLE-POLY, MIM-RUPTURE-OTP), bar of "≥ 5" exceeded.

The **simplest "dumb" extreme** (mask-ROM, PAD-STRAP) is present
in FP only — industry-survey explicitly excludes mask-ROM as
"does not satisfy post-fab" but flags the question for Stage 2;
academic-survey has nothing on mask-ROM or hard-strap. This is
acceptable scope discipline given the different angles.

The **most sophisticated extreme** (Sidense 1T split-channel; FG
single-poly with FN injector; antifuse 3T with block transistor)
is present in industry-survey and academic-survey but absent from
FP. That's also acceptable — FP correctly notes that any
non-PDK cell is a Stage-4 design exercise.

**Approaches the per-item README mentioned that were omitted by
all three reports:**

- **Floating-gate / flash-like as a multi-time-programmable**
  family — README §2 lists this as a research bullet. FP §3.6
  eliminates by PDK availability (correct), industry-survey §3.D
  treats it as discarded turnkey, academic-survey §FG-OTP-SINGLE-POLY
  retains it as a backup. Coverage is OK across the three.
- **"Fuse-cap / capacitor-rupture"** is in README §2 as "less
  common but interesting"; all three angles eliminate by physics
  (V_BD ≈ 30 V on `gf180mcuD` MIM stack ≈ 30–40 nm). Coverage OK.
- **ECC, redundant cells, voted reads** — README §7 explicitly
  asks. FP touches it lightly in components.md table; industry-
  survey mentions in passing; academic-survey has the most depth
  (§5.7, components.md "ECC vs redundancy"). The academic
  recommendation of "3-fuse vote on critical bits, single fuse
  on payload" is the right answer for our bit count and is
  novel-to-the-set. Coverage uneven but covered.
- **"Has anyone published an OTP block targeting GF180MCU
  specifically?"** — README §8 explicit. None of the three
  angles answers this directly; FP §Q-J3 flags it as an open
  question; industry-survey explicitly searched Caravel /
  efabless / OpenFASOC and found nothing definitive. Reasonable
  to flag as "no published implementation" — but the answer
  should be in the report body, not just open-questions.

**Approaches the parallel sister reports covered that this one
did not:**

| Approach | FP | IS | AC | Notes |
|---|---|---|---|---|
| Mask-ROM (zero programmability extreme) | yes | excluded | no | FP only — that's the right scope split |
| Pad-strap (1 bit per pad) | yes | no | no | FP only |
| Kilopass i-fuse 1R1D (7.5 mA) | no | yes | no | IS only |
| eMemory NeoFuse/NeoBit | no | yes | no | IS only |
| NSCore PermSRAM HCI | no | yes | no | IS only |
| Sidense 1T-Fuse (split-channel) | mentioned | yes | yes | IS+AC |
| Differential-paired sense (Kim 2011) | no | briefly | yes | AC only |
| FG-OTP single-poly (Holleman, Hasler) | no | FG generic | yes | AC only |
| OTP_MK marker layer in PDK | no | yes | yes (refs IS) | IS unique discovery, AC propagates |
| Pulse-train programming (Tonti Fig 5a) | mentioned | no | deep | AC has the depth |
| 25 × 10 µs as baseline schedule | alt only | no | yes | AC unique recommendation |
| Read-disturb asymmetry (eFuse vs antifuse) | no | no | yes | AC unique |

The **academic-survey's top-3 self-identified findings** —
pulse-train, read-disturb asymmetry, differential-paired sensing
— are *all genuinely missed by the sister reports*, and the
self-assessment is honest about that. **This is a strong
academic survey on substance**; the citation defects do not
overturn the technical content.

### Premature narrowing

- **First-principles**: §3 is structured fairly across 13
  mechanisms. The "13 distinct mechanisms catalogued" prose is
  honest. Author's notes do not pre-pick a winner. Pass.
- **Industry-survey**: §3 has 11+ approaches. §10 "Author's
  notes" expresses an opinion ("polyfuse PCell is *drawn but
  not characterised* in the open PDK — treating it as a finished
  IP block is a category error") which is *factual* not
  recommendation. Pass — but the "burn at probe-test only"
  pronouncement in §10 line 280 is borderline winner-picking
  for a Stage-1 angle. Soft flag.
- **Academic-survey**: §3 is a balanced 8-topology survey, but
  ~30 % of report.md (lines 60–128, the executive summary) is
  spent on POLY-EFUSE-COSI2 implications. This is below the 40 %
  bar. Pass.

### Numerical claim verification

#### Claim 1: First-principles §5.1 thermal-energy ratio (25 000×)

FP claims:
- Neck volume V = 0.18 × 1.26 × 0.05 µm³ = 1.13 × 10⁻²⁰ m³
- WSi₂ ρ = 9300 kg/m³, c = 250 J/kg-K (matches handbook values; CoSi₂ would be ~5300 kg/m³)
- ΔT = 25 → 2200 °C → ΔT = 2175 K
- E_heat = ρ V c ΔT = 9300 × 1.13e-20 × 250 × 2175 = **57 pJ** (FP claim: 54 pJ, within rounding)
- E_pulse = I²R × t = (5e-3)² × 200 × 250e-6 = **1.25 µJ**
- Ratio = 1.25e-6 / 5.7e-11 = **22 000×** (FP claim: 25 000×, within rounding)

**Sanity check passes.** Note: ρ=9300 is **WSi₂'s density**;
for CoSi₂ the density is 4950 kg/m³ and the calculation drops
to ~30 pJ → ratio ~42 000×. Either way the conclusion holds —
the pulse delivers vastly more than adiabatic-heat energy.
**No revision required.**

#### Claim 2: Academic-survey §5.5 antifuse breakdown V_prog = 9 V

AC claims:
- E_BD (fast pulse, <1 ms) = 12 MV/cm
- t_ox = 7.5 nm (3.3 V GF180MCU device)
- V_prog = 12e6 V/cm × 7.5e-7 cm = 9 V

This matches the FP §5.4 calculation (8 V intrinsic, 5.6 V at
TDDB-accelerated 70 % field) and is the standard
gate-oxide-breakdown number. The "9 V via TDDB pulse" vs
"7 V intrinsic DC" distinction is correctly cited (Lombardo
2005). **No revision required.**

#### Claim 3: Academic-survey §5.4 sense-amp differential output 1.713 V

AC claims at I_read = 10 µA, V_DD = 1.8 V, R_pull-up = 500 kΩ:
- Intact node V = 1.8 × 500 / (500 + 0.2) ≈ 1.7993 V
- Programmed node V = 1.8 × 500 / (500 + 10 000) ≈ 0.0857 V
- Differential = 1.7993 − 0.0857 = **1.7136 V**

But this is **not a current-mode sense** — at I_read = 10 µA
through a 500 kΩ pull-up, the pull-up itself drops 10 µA × 500 kΩ =
5 V, which exceeds V_DD. **The math conflates a voltage divider
with a current source.** The realistic value: at V_DD = 1.8 V
the maximum current through the pull-up to a 200 Ω fuse is
1.8 V / (500 kΩ + 200 Ω) ≈ 3.6 µA, NOT 10 µA. So the I_read
spec and the pull-up sizing are inconsistent.

**Real differential output**: with R_pull = 500 kΩ and V_DD =
1.8 V, intact-fuse node = 1.8 × 200 / 500 200 = 0.72 mV,
programmed node = 1.8 × 10 000 000 / 10 500 000 ≈ 1.71 V →
differential ≈ 1.71 V. **Same magnitude, but the calculation
shown in the report is wrong** — the "10 µA" current claim is
inconsistent with the pull-up size, and the 1.799 V intermediate
result is meaningless. The conclusion (margin is huge, sense-amp
is easy at 1.8 V rail) survives the recalculation. **Revision
required**: re-derive §5.4 with consistent current/voltage/R_pull
sizing.

#### Claim 4: First-principles §5.6 bit-budget area at 1130 bits

FP claims: 1130 bits × 79 µm²/bit = 89 000 µm² ≈ 0.089 mm².

- 79 µm²/bit comes from 49.4 µm² PDK PCell bare + ~30 µm²
  programming-NMOS / sense overhead, ~1.6× total. Plausible.
- 1130 × 79 = **89 270 µm²** ≈ 0.089 mm²
- 0.089 mm² × 100 / 5 mm² (assumed 1×1 mm² die ≥ 5 % core area
  budget?) — this 5 % bound is asserted not derived. The chip
  is 1×1 mm² i.e. 1 mm² total area; 0.089 / 1 = 8.9 % of die.
  "Below 5 % of core area" is **wrong**: the actual fraction is
  closer to 9 %, and "core area" is smaller than die so the
  fraction is even larger. Still well within the project's
  area budget (the 1130-bit case with full per-die NFC payload
  is acknowledged as a stretch goal). **Soft revision**: clarify
  what "5 % of core area" is referenced against.

#### Claim 5: Academic-survey §5.1 Kothandaraman 360 Ω inconsistency

AC §5.1 flags: "I = 10 mA × 360 Ω = 3.6 V > V_FS = 3.3 V →
inconsistent."

Cached PDF (Fig. 5 caption + body text lines 110–125): the
measurement circuit has a **10 Ω series resistor at FS** plus
the NFET in series, plus a **1 MΩ scope input impedance at the
intermediate node V₁**. The AC flag does not account for the
NFET drop. With NFET in deep triode at V_GS = 1.5 V, V_DS small,
the fuse sees ~3.0 V → R_fuse = 300 Ω, comfortably consistent
with the reported 360 Ω. AC's own resolution ("the most likely
correct interpretation") is right but framed as "the paper has
an internal inconsistency" — the inconsistency is only apparent
if one assumes V_NFET = 0, which the paper never claims. AC's
reading is **uncharitable** and should be softened. **Revision
requested**: rewrite §5.1 as "Kothandaraman's 360 Ω requires
the NFET in deep triode (paper says 'limited largely by the size
of the NFET'); first-principles confirms this interpretation"
rather than "internal inconsistency flagged."

### Negative results

- **First-principles §7**: 6 negative results (FG-flash by
  PDK; MIM-cap by physics; metal-EM by current; laser by
  flow; Tonti E-Fuse A failure; in-field NFC). Pass.
- **Industry-survey §7**: 8 negative results, including the
  unique "OTP_MK rules without PCell" gap and the sky130
  "ReRAM ≠ antifuse" correction. Pass.
- **Academic-survey §7**: 8 negative results including
  "ECC over-engineering at 100-bit class" (correctly
  pre-flagged as the most-likely Stage-2 objection point).
  Pass.

All three angles have substantive negative-results sections.

### Convergence with parallel reports

**Topology-ID collisions**:

- FP uses `FUSE-POLY-SILICIDE`, `FUSE-METAL-EM`, `ANTIFUSE-GOX`,
  `MASK-ROM`, etc.
- Industry-survey uses `gf180mcu-poly-efuse-pdk`, `sidense-1t-fuse`,
  `metal-electromigration-fuse`, `mim-cap-rupture`, etc.
- Academic-survey uses `POLY-EFUSE-COSI2`, `POLY-EFUSE-WSI2`,
  `ANTIFUSE-2T`, `ANTIFUSE-3T`, `FG-OTP-SINGLE-POLY`, etc.

**No collisions** — each angle uses its own namespace style.
This is **better than (a) and (k)**, where collisions required
mechanical re-namespacing in CORRECTIONS.md. **The (j) reports
do not need ID-namespace fix.**

**Suspicious convergence**: low. The three angles arrive at
"PDK eFuse is the right primary" by **different routes** —
FP from PDK file inspection, IS from foundry-blessing
audit, AC from peer-reviewed silicon. Each contributes
non-overlapping content (FP: thermal sanity check; IS: Sidense /
Kilopass / NSCore industry context; AC: pulse-train / read-disturb
/ differential sensing). **This is healthy parallel coverage.**

**Cross-citation pattern**: AC §10 explicitly compares its three
findings against "sister reports" — that's reading the sister
reports, not converging from a shared shallow source. FP
references the IS in §3.10 (HV-PAD) but doesn't re-derive the
IS finding. **No suspicious cross-citation cascade.**

The (j) item passes the convergence check that (b) and (k)
failed. Item-level rating: **independent parallel coverage.**

### Specific revisions requested

In priority order:

1. **[academic-survey/references.md] Fix four citation-author
   misattributions:**
   - **TONTI-PATENT-US-7485944**: inventors are Kothandaraman & S. S.
     Iyer (verified via Google Patents free full text), NOT Tonti.
     Either re-attribute or replace with an actual Tonti patent.
   - **WANG-2014-ASICON**: title resolves on Google Scholar to
     **Liu, Zheng, Sun**, **2015 ISNE** (NOT Wang, 2014 ASICON).
     Either replace the citation or find the correct paper Wang et
     al. did publish on TSMC 90 nm antifuse OTP.
   - **LEE-2011-JSTS**: the paper "32-KB standard CMOS antifuse
     OTP ROM in a 16-bit MCU" is **Cha, Yun, Kim, So, Chun, Nam,
     Lee in IEEE JSSC 2006** (NOT JSTS, NOT 2011, NOT "Lee").
     Re-attribute to Cha et al. JSSC 2006.
   - **KIM-2007-OTPROM**: the paper "Three-transistor OTP ROM
     cell array using standard CMOS gate-oxide antifuse" is
     **J. Kim & K. Lee, IEEE EDL 2003** (NOT 2007, NOT
     TVLSI/ISCAS, NOT "S.-S. Kim et al.").

   This is the same systematic-attribution-error pattern flagged
   programme-wide in CORRECTIONS.md (Hsiao→Mirchandani; Awad→
   Pakkirisami Churchill; Honma→Nguyen; Davis→Greene; Sun/Pan→
   Godinho). The (j) academic-survey adds **four more** to the
   list. Stage-2 must inherit corrections, not the original
   citations.

2. **[academic-survey/solutions.md POLY-EFUSE-COSI2]** —
   the topology-bucket is mislabelled. Tonti 2003 IRW is a
   **WSi₂** paper (line 30 of the cached PDF: "Tungsten Silicide
   E-Fuse"), not CoSi₂. Either:
   - rename the topology bucket to POLY-EFUSE-SILICIDE-EM
     (silicide-agnostic) with both Tonti 2003 (WSi₂) and
     Kothandaraman 2002 (CoSi₂) listed as anchors; or
   - split into POLY-EFUSE-COSI2 anchored only on Kothandaraman
     2002 / Tian 2006 (which IS CoSi₂) and POLY-EFUSE-WSI2
     anchored on Tonti 2003.
   The current solutions.md does both inconsistently — the
   COSI2 entry cites Tonti 2003 but the WSI2 entry also cites
   Tonti 2003. **Resolve.**

3. **[academic-survey/components.md "Programming-control FSM
   states"]** — the `RE_PROGRAM` state ("any fuse that doesn't
   sense as programmed gets a second train") **directly
   contradicts Tonti 2008 SSIRI** (cached lines 87–93): "eFuse
   programming is limited to 'one chance', or a single attempt.
   If in programming the fuses one terminates the programming
   logic early so that the fuse resistance is between the
   unprogrammed and programmed values it becomes impossible to
   supplement programming as an intermediate eFuse resistance
   limits the current that subsequent CMOS program logic can
   deliver." This is the cached paper the academic survey itself
   relies on. Either:
   - drop the RE_PROGRAM state and replace with "yield-recovery
     by binning"; or
   - explicitly note that re-programming is only possible if the
     first attempt ended *before* any silicide migration, and
     cite Tonti 2008 as the constraint (the safe re-program window
     is essentially "fuse never reached programming temperature";
     once partial migration starts, the path is one-way).

4. **[academic-survey/report.md §5.4]** — re-derive the
   sense-amp differential output with internally consistent
   I_read / V_DD / R_pull-up. As written, "I_read = 10 µA into a
   1.8 V rail through a 500 kΩ pull-up" is over-constrained — at
   500 kΩ the actual current is 3.6 µA (intact fuse), not 10 µA.
   The qualitative conclusion (margin is large, sense at 1.8 V
   trivially works) survives, but the equation chain is wrong
   and Stage-2 will copy it.

5. **[academic-survey/report.md §5.1]** — soften the
   "Kothandaraman 2002 internal inconsistency" framing. The
   apparent V_FS = 3.3 V vs V_fuse = 3.6 V mismatch is **not** an
   inconsistency in the paper; it requires assuming V_NFET = 0,
   which the paper explicitly does not. The paper says
   "limited largely by the size of the NFET" (meaning the NFET
   in deep triode shares the V_FS budget). Reframe as "Kothandaraman
   correctly identifies the NFET as deep-triode current-share —
   first-principles confirms" rather than "inconsistency flagged."

6. **[first-principles/report.md §3.1, solutions.md
   FUSE-POLY-SILICIDE]** — clarify that the GF180MCU eFuse's
   silicide chemistry is **not specified in the open PDK files**
   (no public statement of CoSi₂ vs NiSi vs WSi₂ on the
   `gf180mcu_fd_pr` cell). The "Tonti 2003 / replicated in our
   PDK" wording in §3.1 implicitly imports the WSi₂ chemistry of
   Tonti 2003 onto the GF180MCU cell, which is unverified.
   Either:
   - state "silicide chemistry not disclosed in PDK; physics
     applies regardless" and remove the implicit chemistry claim;
     or
   - add an open question: "Q-J11. What silicide is on the
     GF180MCU eFuse? PDK does not say."

7. **[first-principles/report.md §5.6]** — the "below 5% of core
   area" assertion needs a reference. Core area on a 1×1 mm²
   slot is < 1 mm², so 0.089 mm² (1130-bit case) is closer to
   ~10 % of core, not 5 %. Recompute against the actual core
   area of the chosen slot.

8. **[academic-survey/references.md HAN-2019-EDL]** — the cached
   verification status was "WebFetch verified 2026-05-04" but the
   NTRS-NASA URL returns a binary PDF that cannot be confirmed
   to match the citation by current tooling. Either re-verify
   with a text-extracting tool or downgrade verification status
   to "URL-resolves-only".

9. **[industry-survey/§10]** — soften "burn at probe-test only"
   from a recommendation to a "current best evidence suggests"
   tone. Stage-1 angles should not pre-empt Stage-3
   architectural decisions.

10. **[industry-survey/§5.1, §5.2]** — programming envelope of
    "12 mA × 2 V × 200 µs = 4.8 µJ/bit" is internally consistent
    but sits between the FP-cited "5 mA × 4.7 V × 250 µs =
    5.9 µJ" and Tonti's actual "5 mA × 4.7 V across whole macro
    × 250 µs". The IS is using the IBM patent's "10–15 mA × 200 µs"
    envelope (which the FP cites as a separate path) and treating
    them as equivalent without reconciling. **Stage-2 must
    reconcile** the 5 mA-Tonti vs 10–15 mA-IBM-patent envelopes
    (likely process-version split: Tonti 2003 was 0.14 µm, the
    patent was a later filing with refined parameters).

## Closing notes

**The Tonti 2003 25-pulse-train claim — the headline academic
finding — holds up.** Verified line-by-line against the cached
PDF (lines 150–166). Tonti explicitly observed that "a given
pulse train is more effective than a fixed pulse in developing a
high yield E-Fuse," with 25 × 10 µs at 4.7 V outperforming a
single 250 µs at the same total energy of 1.25 µJ. The first-
principles thermal-cycling argument the academic survey offers
in §5.3 is plausible but is the survey's own derivation, not
Tonti's. Stage-4 should treat the pulse-train as the safe
default, not because the academic survey says so but because the
cached primary source says so.

**Programme-wide pattern alert.** The (j) academic-survey
contributes **four new entries** to the Stage-1 citation-author
misattribution log: TONTI-PATENT (→ Kothandaraman & Iyer);
WANG-2014-ASICON (→ Liu/Zheng/Sun, ISNE 2015); LEE-2011-JSTS (→
Cha et al., JSSC 2006); KIM-2007-OTPROM (→ Kim & Lee, EDL 2003).
This brings the project-wide count to ~10 known misattributions
(see CORRECTIONS.md for prior items). **Stage-2 should treat
*every* AI-generated academic citation in this programme as
suspect-until-verified.** The pattern is now confirmed across
~9 of 11 items.

**Topology-ID collisions are not present in (j).** Each angle
uses its own naming style; no mechanical re-namespacing required.
This is one place where the (j) cluster is *better*-disciplined
than (a)/(k).

**Suspicious convergence is low.** The three angles arrive at
the headline finding (PDK eFuse is the right primary) via
*different* routes — file inspection, foundry audit, peer-
reviewed silicon — and contribute distinct value (thermal
sanity, OTP_MK gap, pulse-train + differential sensing
respectively). The academic survey reads the sister reports and
calls out three things they missed; that's the right behaviour
for the angle, not lazy convergence.

**Footprint claim verification.** The PDK eFuse cell footprint
of 49.4 µm² (11.28 × 4.38 µm) is **correct as drawn in the GDS**
— but the .mag file alone shows 25.5 µm² (11.28 × 2.26 µm); the
extra height comes from the EFUSE_MK marker layer (GDS layer 31)
which is not represented in the magic file. Future reviewers
checking via Magic alone may reproduce the 25.5 µm² number
without realising it's missing the keep-out marker. Worth a
note in Stage 2.

**Read-disturb asymmetry verification.** The academic-survey's
claim that "read-disturb is real for antifuse but not for poly-
silicide eFuse" is correct in direction. Quantitatively: AC §7.5
computes "10 µA / (0.18 × 0.05 µm²) = 1.1×10⁵ A/cm²" — recheck:
0.18 × 0.05 = 0.009 µm² = 9e-14 m² = 9e-10 cm²; 10 µA / 9e-10 cm²
= 1.11e4 A/cm² (i.e. **10⁴ A/cm²**, NOT 10⁵). AC reports 10⁵; the
correct value is 10⁴, **three orders of magnitude below** the
Kothandaraman EM threshold of 10⁷ A/cm² rather than two. The
direction-of-claim is unchanged (read-disturb is not a concern)
but **the numerical margin is even larger** than AC stated.
Soft revision suggested. Antifuse read-disturb concern via
Stathis 2001 IRPS percolation-path ageing is correctly identified
qualitatively (no quantitative claim made there).

**Programmable from existing 5 V DVDD without charge pump
verification.** The SPICE comment "Subcircuit model for 6V/(5V)
efuse" verified at line 102 of `sm141064.ngspice`. R_intact ≤ 200
Ω with a 4.7 V programming supply gives I_max = 4.7/200 = 23.5 mA
(open-circuit-NFET case); with a 5 V NMOS pass switch in deep
triode (V_GS=5, V_DS small), the I_sat is ~150 µA/µm × 33 µm =
4.95 mA, matching the Tonti 5 mA target. The "programmable from
DVDD" claim is plausible given the SPICE-tag wording but is
**not directly confirmed** by the ngspice deck — the deck only
captures static R_intact / R_blow values, not the programming
window. **The qualitative finding is correct; the
quantitative envelope (12 mA × 200 µs vs 5 mA × 250 µs) needs
Stage-2 reconciliation**, see revision item 10 above.

**Unverified at this review.** HAN-2019-EDL (NASA NTRS PDF
returned binary). CHOI-2007-IRPS (IEEE Xplore — paywalled, per
brief). LOMBARDO-2005-JAP (AIP returned 403). Three of the
academic survey's "P" / paywalled-only citations remain
abstract-verified. Fine for Stage-1; Stage-2 should re-attempt.

**Final verdict: revisions-requested.** All three reports are
salvageable with the listed revisions. None of the issues
overturn the core architectural finding (FUSE-POLY-SILICIDE via
PDK PCell, programmed at 5 V DVDD with 25-pulse train, no
charge pump needed, ~0.01 mm² for 100-bit array). The errors
are at the citation/derivation-detail layer, not the conclusion
layer.
