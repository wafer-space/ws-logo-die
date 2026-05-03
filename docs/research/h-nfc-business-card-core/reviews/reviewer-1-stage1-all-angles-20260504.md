---
report_under_review:
  - stage1-first-principles/
  - stage1-industry-survey/
  - stage1-academic-survey/
reviewer: reviewer-1 (claude-opus-4-7, adversarial mode)
date: 2026-05-04
verdict: revisions-requested
---

## Verdict

**revisions-requested.** All three Stage-1 reports are substantively
strong, technically careful, and impressively converge on the same
qualitative architecture (T2T + CLK-CARRIER + AC-FIXED-UID + mask-ROM
payload, with eFuse personalisation as an optional overlay). The
numerical-claim-vs-physics audit is overwhelmingly clean (15/15 spot
checks pass to within rounding). The protocol-coverage breadth meets
or exceeds the methodology floor in all three angles.

However, the reports are **not** clean enough to sign off:

1. **The academic-survey [Myny-2017-ISSCC] author list is partly
   hallucinated** — programme-wide pattern (6/6 prior reviews) holds
   in (h) too.
2. **The industry-survey "Hackaday Power-Free NFC = 3.5 mA total chip
   from 15 mW field" anchor is a misread** of the project page —
   3.5 mA is the MCU's stand-alone current draw, while 4.5 mA is the
   total budget the field can deliver. Not a 1000× error, but the
   "headroom > 10× over modulator allocation alone" derivation
   (industry §5.4) leans on this number.
3. **Suspicious convergence is present.** Industry-survey §5 and
   academic-survey §5 are explicitly framed as "we cross-check the
   first-principles sister-report's numerical claims" rather than
   independently derived numbers. The academic-survey author even
   writes "the academic angle inherits the analytical derivations of
   the parallel `stage1-first-principles/report.md` §5". This breaks
   the methodology requirement that Stage-1 angles be independent.
4. **Topology-ID collisions are largely *absent* in (h)** — Stage 2
   can ingest these tables directly. Good.
5. **Several assertions are slightly mis-scaled or mis-citation**:
   NTAG216 NDEF-max 868 vs CC-implied 872 is a documented but
   un-explained 4-byte gap; references.md mentions both 7.5 mW
   ISSCC paper while solutions.md elsewhere references a non-existent
   "[Myny-followup-2018]" paper that the report does not cite
   explicitly enough.

The corrections required are small in absolute work but would be
embarrassing if propagated into Stage-2 synthesis. Hence revisions-
requested rather than signed-off.

## Findings

### Reference verification (REQUIRED)

Six reference spot-checks via WebFetch (one over the methodology
minimum of 5):

| Citation | URL/DOI resolved? | Document matches citation? | Local cache present? | Local cache matches upstream? |
|---|---|---|---|---|
| `[Bhattacharyya-2018]` (PMC5982218, *Sensors* 18(5):1452, DOI 10.3390/s18051452) | yes | yes — 107 µW total / 36 µW analog / 0.18 µm CMOS / 1.5 × 1.5 mm / ISO 15693 all verified verbatim | no (academic survey notes "not yet cached") | N/A |
| `[Anabtawi-2016-BHI]` (PMC5502769, BHI 2016, DOI 10.1109/BHI.2016.7455973) | yes | yes — 24 µW battery-only, 47 mW charging, 14 nm CMOS verbatim from Table 1 | no | N/A |
| `[Myny-2017-ISSCC]` (IMEC repository) | yes | **partial — title and 7.5 mW headline correct, but author list in academic-survey/references.md does not match the actual paper.** Cited authors include Vicca, Furthner, A. K. Tripathi (twice), Cobb, Beenhakker, Heremans — none of these are authors. Actual authors per IMEC + Google Scholar: Myny, Lai, Papadopoulos, De Roose, Ameys, Willegems, Smout, Steudel, Dehaene, Genoe. | no | N/A |
| `[NTAG21x-DS]` cross-check via `[RFIDCard-NTAG]` | yes | yes — 144/504/888 user bytes, 50 pF tuning, 106 kbit/s confirmed | yes (`references-cache/ntag21x-datasheet/NTAG213_215_216_rev3.2.pdf`, 1.93 MB per industry-survey/references.md) | not verified by reviewer (file size matches industry-survey claim) |
| `[Hackaday-PowerFreeNFC]` (hackaday.io/project/203582) | yes | **partial — verbatim quote on the project page is "operates within the 4.5 mA power budget supplied by typical NFC readers (3.3 V/15 mW)" with "3.5 mA @ 27.12 MHz" being the MCU stand-alone current.** The industry-survey reads this as "3.5 mA total chip current from a 15 mW NFC field = 11.5 mW total". Strictly the 11.5 mW is "MCU current × supply voltage" — it is not the total system draw nor the total NFC field. | no | N/A |
| `[NfcEmu]` (github.com/0xee/NfcEmu) | yes | yes — VHDL (59 %), 8051 softcore, Saxo-Q FPGA, ISO 14443A 106 kbit/s confirmed | no | N/A |
| `[RFC6350]` (datatracker) | yes | yes — Perreault, August 2011, obsoletes 2425/2426/4770 | N/A (open standard) | N/A |
| `[Wikipedia-ISO14443]` cross-check | yes | yes — 13.56 MHz, 847.5 kHz subcarrier, 106 kbit/s, ASK + Mod-Miller / OOK + Manchester confirmed | N/A | N/A |

Findings:
- The **`[Myny-2017-ISSCC]` author hallucination** is the most
  significant defect; matches the programme-wide 6/6 pattern.
- The first-principles report's §6 R9 entry says "Howes et al.,
  *vCard MIME Directory Profile*, RFC 2426 (vCard 3.0), 1998" —
  RFC 2426 is by Dawson and Howes, not "Howes et al." The
  *primary* author per RFC 2426 is Frank Dawson (Lotus); Tim Howes
  (Netscape) is co-author. The "Howes et al." attribution is
  technically defensible but mildly inaccurate — best practice is
  to cite as "Dawson and Howes". Industry-survey/references.md
  reverses this correctly ("F. Dawson and T. Howes"). FP and
  academic-survey both have the citation order slightly off.
- The academic-survey lists `[RFC2425]/[RFC2426]` as "vCard 2.1 /
  3.0" — but **RFC 2425 is the parent MIME-directory profile**,
  not vCard 2.1 (vCard 2.1 is an Internet Mail Consortium spec
  from 1996, not an IETF RFC). RFC 2426 is vCard 3.0. The
  industry-survey gets this right ("vCard 2.1 / 3.0 lineage" via
  Wikipedia + RFC 6350); first-principles also gets it right (R9
  cites the IMC vCard 2.1 spec separately). Academic survey's
  conflation of RFC 2425 with "vCard 2.1" is wrong and should be
  fixed.

### Solution-space coverage

#### Per-item-README scope coverage (cross-referenced against `README.md`)

The README lists nine scope items. Coverage by angle:

| Scope item | First-principles | Industry-survey | Academic-survey |
|---|---|---|---|
| 1. Tag-type selection T1/T2/T4/T5 + 14443B | five candidates | seven candidates incl. T3T + T4T-B | six candidates incl. T2T-flex |
| 2. Modulation OOK/BPSK/Manchester/Miller | three combos | six combos | six combos |
| 3. Anticollision incl. single-tag-only feasibility | four options, AC-NONE eliminated empirically | four options, eliminated via TI-SLOA136 | four options |
| 4. NDEF mapping for vCard | tier table | per-variant memory map | size-bound only |
| 5. Open-source reference designs | minimal | Proxmark3, ChameleonMini, libnfc, NFCpy, NfcEmu, Hackaday | NfcEmu-VHDL + sister-survey delegation |
| 6. Power budget | §5.2 | §5.4 cross-check | §5.1 cross-check |
| 7. Fixed vs programmable | five PAY-* options | five STORE-* options | five STORE-* options |
| 8. Self-clocking vs internal osc | §5.7 | §3.5 | §3.5 + §7.4 |
| 9. Phone reader compatibility | §5.9 5×5 table | §3.7 6×4 table | §3.7 says "no peer-reviewed matrix exists" |

Approaches mentioned in README that the reports omitted: **none**.

Approaches a parallel sister covered that another did not:

- **T3T (FeliCa)** — only the industry-survey enumerates this with a
  dedicated row; FP and academic-survey both lump it into "Asia-only,
  out of scope". This is defensible, since our brief is global, and
  FP correctly identifies "we have not surveyed Asian-language
  theses" as a stated limit.
- **T2T+UWB upper-bound** — only the academic-survey (`[Pelissier-
  2011-ISSCC]`) lists this. FP and industry-survey both omit
  upstream-UWB hybrids. Methodology requires "spectrum extremes",
  and the academic survey rightly catches this; the absence in
  industry-survey is forgivable (industry doesn't ship UWB-uplink
  passive tags), but FP could have flagged it as a "what physics
  permits but no one builds" first-principles entry.
- **T1T as live candidate** — all three angles agree it is being
  phased out, but only industry-survey ships a §7.7 "T1T fading
  from production, eliminated" negative result. FP eliminates T1T
  implicitly (in the comparison-readiness table); academic-survey
  eliminates by "academic silence". Different evidentiary anchors,
  but consistent verdict.

Net: solution-space coverage is **acceptable to good** in all three
angles. No README scope item silently dropped. Spectrum extremes
are represented (T1T/RAW lower bound; T2T+UWB and ISO 15693-implant
upper bound).

### Premature narrowing

- **First-principles report.** §1 expresses opinions ("most
  surprising finding: dropping anticollision is not safe", "the
  carrier-derived clock proposition is much stronger than I
  expected") but does **not** pick a winner. Comparison-readiness
  table at §9 lists 7 distinct stacks. **No premature narrowing.**
- **Industry-survey report.** §10 author's notes lean toward "T2T +
  mask-ROM = done", but §1 ("Headline conclusions, *without*
  picking a winner") and §9 (7-stack comparison) are properly
  Stage-1-shaped. **Borderline; would push to revisions if any
  other Stage-1 issue were also present.**
- **Academic-survey report.** §9 properly lists 8 candidates including
  the T2T+UWB upper bound and a T2T-flex demonstration. §10 says
  "T2T is strictly easier" — borderline opinion in a Stage-1 report.
  Stays the right side of the line.

None of the three reports spends > 40 % of length on a single
approach. T2T discussion is the largest in all three but is mirrored
by full-length T1T, T4T-A, T4T-B, T5T, RAW (and T3T in industry,
T2T+UWB in academic) treatments.

### Numerical claim verification

I redid 15 numerical claims from first principles. **All 15 pass to
within rounding.** Highlights:

1. **FDT_PICC = 1172 / fc**: 1172 / 13.56 MHz = 86.43 µs. Reports
   claim 86.4 µs. **MATCH.**
2. **fc/16 subcarrier**: 13.56 MHz / 16 = 847.500 kHz. Reports claim
   847.5 kHz. **MATCH.**
3. **fc/32 (T5T low subcarrier)**: 13.56 MHz / 32 = 423.750 kHz.
   Reports claim 423.75 kHz. **MATCH.**
4. **fc/28 (T5T FSK high tone)**: 13.56 MHz / 28 = 484.286 kHz.
   Reports claim 484.28 kHz. **MATCH.**
5. **1-of-256 PPM bit rate**: 256 × (32/fc) = 4.833 ms per symbol;
   8 bits/symbol → 1.655 kbit/s. Reports claim 1.65 kbit/s.
   **MATCH.**
6. **1-of-4 PPM bit rate**: 1024 / fc = 75.5 µs per symbol;
   2 bits/symbol → 26.48 kbit/s. Reports claim 26.48 kbit/s. **MATCH.**
7. **50 pF MIM cap area at 1.5 fF/µm²**: 33 333 µm² = 0.033 mm².
   Reports claim 25 000–50 000 µm² (1–2 fF/µm²). **MATCH** (this is
   a programme-wide cap-arithmetic spot-check; (h) is clean — see
   CORRECTIONS.md row "(h) industry-survey/open-questions.md
   line 143 verified").
8. **C for resonance with L=2.5 µH at 13.56 MHz**: 1/(ω²L) = 55.10 pF.
   Industry-survey claims 55.1 pF. **MATCH.**
9. **ω·L_ant = 2π·13.56e6·2.5e-6 = 213.0 Ω**. FP claims 213 Ω.
   **MATCH.** (Note: this is *not* the (a)/(b) ω·L slip from
   CORRECTIONS.md — that was 13.56 vs 2.4 GHz confusion. (h) has
   ω·L correctly at 13.56 MHz.)
10. **Faraday V_pk per turn**: A·µ₀·ω·H = 4e-3 m² × 4πe-7 × 2π·13.56e6
    × 5 A/m = 2.141 V. FP claims 2.14 V/turn. **MATCH.** Similarly
    8.6 V total at 4 turns. **MATCH.**
11. **Q with R_mod = 100 Ω parallel**: Q = ωL / (R_ant + (ωL)²/R_par)
    = 213/(1+454) = 0.468. FP claims Q drops to 0.47. **MATCH.**
12. **Q with R_mod = 2 kΩ parallel**: Q = 213/(1+22.7) = 8.99. FP
    claims Q drops to ~9. **MATCH.**
13. **P_mod_on at V_clamp_pk = 3 V, R = 2 kΩ**: V²/(2R) = 9/4000 =
    2.25 mW. FP claims 2.25 mW. **MATCH.** (FP §5.2 also claims
    R=100 Ω → 45 mW; computed: 9/200 = 45 mW. **MATCH.**)
14. **CRC-A polynomial 0x1021 = CRC-CCITT** (x¹⁶+x¹²+x⁵+1).
    Standard. **MATCH.**
15. **NTAG21x CC bytes**: 0x12·8 = 144 (NTAG213); 0x3E·8 = 496
    (NTAG215); 0x6D·8 = 872 (NTAG216). Industry-survey/components.md
    claims these exactly. **MATCH.** Note: industry-survey/report.md
    §3.6 also claims NTAG216 NDEF-max = 868 B vs CC-implied 872 —
    the 4-byte gap is the NDEF wrapper overhead but is **not stated
    explicitly**. Minor cosmetic clarification needed.

#### Numerical claims I did *not* re-derive but flag for follow-up

- **Sister-report SNR margin claim** (FP §5.6, 38 dB BER margin at
  14 mV sideband / 100 µV/√Hz over 1 MHz). This is a hand-wavy
  reader LNA noise model — the 100 µV/√Hz is plausible for an NFC
  reader chip but is not cited. Margin is so wide that getting the
  noise floor 10× wrong still leaves 18 dB of margin, so this is
  not load-bearing. Flag for Stage 2.
- **Modulator R_mod ≈ 2 kΩ as commercial-default.** Industry-survey
  §3.5 cites NTAG21x and "commercial tag ICs cluster here" but
  doesn't quote a specific R_mod value from a datasheet (NXP keeps
  this proprietary). The figure is plausible-by-engineering-judgment
  but **not anchored in a primary datasheet**. Academic-survey
  Q-as-5 explicitly flags this gap. Acceptable; not a defect.

#### Numerical-claim-physics check verdict

**No physics violations found.** Friis, Faraday, kTB, PDK MIM
density, ISO 14443-2 H_min/H_max, ISO 14443-3 FDT_PICC, fc
divider arithmetic, MIM cap area, Q derivations, modulator
dissipation — all check.

### Negative results

- **First-principles**: 7 named negative results (§7.1–7.7), all
  with concrete failure-mode + actionable detail. Strong.
- **Industry-survey**: 8 named negative results (§7.1–7.8) including
  "Toshiba TB1106GBG not found" and "ISSCC silicon paper for 180 nm
  T2T not surfaced from industry channels" (deferred to academic
  angle). Strong.
- **Academic-survey**: 7 named negative results (§7.1–7.7) including
  "no peer-reviewed phone-compat matrix" and "vCard 2.1 vs 4.0
  comparison absent from peer-reviewed literature". Strong.

All three angles meet the methodology's "expected to have content"
floor for §7. **No defect.**

### Convergence with parallel reports

This is the most concerning area for (h).

#### Topology-ID collisions: largely absent (good)

Cross-tabulating short-name overlap across angles:

| Family | FP IDs | IS IDs | AC IDs | Collision? |
|---|---|---|---|---|
| Tag protocols | T1T/T2T/T4T/T5T/RAW | T1T/T2T/T4T-A/T4T-B/T3T/T5T/RAW | T1T/T2T/T2T-flex/T4T-A/T4T-B/T3T/T5T-medical/T5T-glucose/T5T-glucose-2/T2T+UWB/RAW | **Same labels, same meaning. No collision.** Good. |
| Modulation | MOD-OOK-MAN/MOD-OOK-MIL/MOD-BPSK/MOD-1OF256/MOD-1OF4 | MOD-A-MIL-MAN/MOD-A-MIL-BPSK/MOD-B-NRZ-BPSK/MOD-F-MAN/MOD-V-1OF256/MOD-V-1OF4 | MOD-A-MIL-MAN/MOD-A-MIL-BPSK/MOD-B-NRZ-BPSK/MOD-V-1OF256/MOD-V-1OF4/MOD-LSK | **Different namespaces (FP shorter, IS/AC longer).** Stage 2 must reconcile but the rename is mechanical and unambiguous. Mild. |
| Payload | PAY-MASKROM/PAY-EFUSE/PAY-EFUSE-PARTIAL/PAY-RAM-RW/PAY-RAM-RW-AUTH | STORE-EEPROM/STORE-MASKROM/STORE-OTP-EFUSE/STORE-SRAM-RW/STORE-FLASH-MCU | STORE-MASKROM/STORE-EEPROM/STORE-OTP-EFUSE/STORE-SRAM-RW/STORE-FLASH-MCU | **PAY-* vs STORE-* prefix split.** Mechanical Stage-2 rename. |
| Clocking | CLK-CARRIER/CLK-INT/CLK-HYBRID | CLK-CARRIER/CLK-INT/CLK-HYBRID | CLK-CARRIER/CLK-INT/CLK-HYBRID | **Identical labels, identical meanings, no collision.** Excellent. |
| Anticollision | AC-NONE/AC-FIXED-UID/AC-EFUSE-UID/AC-FULL | AC-A-7B/AC-A-4B/AC-A-10B/AC-V-SLOTS | AC-A-7B/AC-A-4B/AC-V-SLOTS/AC-NONE | **FP uses functional-property names; IS/AC use protocol-cascade-level names.** Stage 2 must crosswalk. Different from (a)'s ID-collision pattern: in (h) the same letter ('AC-FIXED-UID' vs 'AC-A-7B') maps unambiguously to "single hard-wired UID with full handshake", just with different attribute focus. Manageable. |

**Net: (h) has no genuine same-label-different-thing collisions.**
Compared to (a)'s nightmare collision pattern documented in
CORRECTIONS.md, (h)'s name-spaces are well-separated and the
mappings are clear. **Stage-2 synthesiser can ingest the three
tables with mechanical renaming.**

#### Suspicious convergence: present in §5 cross-checks

The methodology says "if two parallel Stage-1 reports come back too
similar — same references, same architecture preferences, same
omissions — that means at least one of them was lazy. Both go back
to the field."

Symptoms in (h):

1. **Industry-survey §5 says explicitly**: "*The industry-survey
   angle inherits its first-principles physics from the parallel
   sister report (`stage1-first-principles/report.md`) §5.*" Then
   §5.1–5.5 are framed as "where industry data lets us cross-check
   those numbers, we do so here."
2. **Academic-survey §5 says explicitly**: "*The academic angle
   inherits the analytical derivations of the parallel
   `stage1-first-principles/report.md` §5.*" Then §5.1–5.7 are
   "where peer-reviewed silicon publishes a measured number for
   the same quantity, we cross-check here."
3. The §5 sub-section *titles* are essentially identical between
   industry-survey and academic-survey (cap; bit rate / subcarrier;
   FDT timing; power budget; payload sizing; self-clocking;
   programmability multiplier).
4. Both sister reports cite the FP report's §5.X numbers and then
   "confirm" them with a single industry / academic data point
   that **does not, in fact, contradict** anything.

This is a **deliberate cross-citing design choice** — the orchestrator
clearly intended the three angles to **share a common physics layer**
and only contribute *evidence* on top — and that's a reasonable
research methodology, but it is **not what the project's METHODOLOGY.md
asks for**. Methodology says: "*A red flag. If two parallel Stage-1
reports come back too similar — same references, same architecture
preferences, same omissions — that means at least one of them was
lazy.*"

In (h), the three angles agree on:
- Tag-type winner: **T2T (all three)**.
- Clocking strategy: **CLK-CARRIER (all three)**.
- Anticollision: **AC-FIXED-UID / AC-A-7B (all three)**.
- Eliminations: **T1T phased out, T4T-B patchy, T5T iOS 11/12
  excluded (all three)**.
- Modulator R_mod: **2 kΩ (FP analytically; IS/AC defer)**.
- Payload: **mask-ROM + optional eFuse personalisation (all three)**.

That is **>80 % qualitative-architecture overlap, with explicit
cross-citation between sister reports**. By the methodology's own
red-flag rule, this should trigger "**Stage-2 must treat at least
one of these reports as derivative**" and either commission an
additional truly-independent angle or accept that two of the three
are physics-evidence layers on top of FP rather than independent
first-pass surveys.

**This matches the (b) item's pattern documented in CORRECTIONS.md**:
"⚠ flagged by reviewer-1: 83 % topology overlap across the 3 angles;
FP and academic explicitly cross-cite. Stage-2 must treat (b) FP as
a shared physics layer rather than a third independent angle."

The (h) pattern is *worse* than (b) because the cross-citation is
explicit in two angles' §5, and because the orchestrator
deliberately structured industry-survey and academic-survey as
"corroboration angles" rather than independent surveys.

**Recommendation**: Stage 2 must explicitly note that (h)'s
academic-survey and industry-survey are *evidence layers* on top
of (h)'s first-principles, not three independent surveys. The
qualitative verdict is robust *because* of the convergence, not
*despite* it — but the methodology requires this be flagged.

#### Programme-wide pattern checks

**1. Cap-arithmetic prefix slips (1000× / 100× / 2×)**: **Clean.**
The only cap-arithmetic in (h) is the 50 pF NFC tuning cap and
the 1–10 nF storage caps — both spot-checked against
CORRECTIONS.md's existing audit (h) line 143 = ✓ verified
correct. No new cap-arithmetic errors found.

**2. Citation-author hallucinations**: **Found one.**
`[Myny-2017-ISSCC]` in academic-survey/references.md. Listed authors
include Vicca, Furthner, A. K. Tripathi (twice), B. Cobb,
M. Beenhakker, P. Heremans — none of whom co-authored this paper.
Actual authors per Google Scholar and IMEC repository: Myny, Lai,
Papadopoulos, De Roose, Ameys, Willegems, Smout, Steudel, Dehaene,
Genoe. **This continues the programme-wide 6/6 pattern: every
Stage-1 academic angle has at least one citation-author misattribution.**

**3. Topology-ID collisions across angles**: **Largely absent in
(h)** — see table above. Mild prefix splits (PAY-* vs STORE-*,
MOD-OOK-MAN vs MOD-A-MIL-MAN) are mechanical-rename, not
genuine same-label-different-thing collisions.

**4. Suspicious convergence with cross-citation between sister
angles**: **Present** — see above. >80 % qualitative architectural
overlap with explicit cross-citation. (h) flag is comparable to
(b)'s pattern, possibly slightly worse because the cross-citation
is structural (industry §5 and academic §5 are both framed as
"cross-check FP §5" rather than independent derivations).

#### Item-specific stress-tests from the brief

**a. Myny 2017 ISSCC as canonical CLK-CARRIER precedent — third
independent confirmation that CLK-INT is dead for NFC modems.**

Verified. The paper's headline title literally is "...with direct
clock division circuit from 13.56 MHz carrier" — the cited "headline
contribution" framing in academic-survey §3.5 and §5.3 is accurate
*on the technical claim*. The flexible-TFT-substrate-Vth-variation-
worse-than-CMOS framing is also defensible: TFT processes routinely
have 50–100 % Vth spread, vs ~2 % for GF180MCU. **The "if TFT can
do this, CMOS trivially can" inference is sound.**

**The only defect is the author list itself** — see above.

**b. iOS 11/12 reach killer for T5T compliance — implantable-tag
literature converges on T5T precisely BECAUSE it kills iOS 11/12 reach.**

The implantable-tag-T5T-convergence story holds up technically.
Three peer-reviewed papers cited (Bhattacharyya 2018, Dehennis 2016,
Anabtawi 2016) all use ISO 15693, all for biomedical implants, all
sub-mW total. The reasoning in academic-survey §7.1 is correct: T5T
buys long-range / through-tissue / sub-mW operation, and **none** of
those advantages applies to a flat business card. The "iOS 11/12
reach killer" framing — that implant designers don't care about
phone reach because doctors use dedicated readers — is consistent
with what the implant-IC literature reports. **Story holds up.**

The one nuance: academic-survey §7.1 says "*ISO 15693 is the
academic implant-tag default precisely because it kills iOS 11/12
readership*" — this is a misstatement of causality. T5T was *adopted*
for implants because (a) lower data rate → lower power, (b) longer
range. The iOS 11/12 reach loss is a *consequence*, not the
*cause*, of T5T adoption. The text should be reworded to:
"*The implant-tag literature adopts T5T for sub-mW operation and
through-tissue range; this choice carries the side effect of
losing iOS 11/12 readership, which our brief cannot afford*". Minor.

**c. No peer-reviewed phone-compatibility matrix exists — verify by
trying to find one.**

Confirmed. I did a structured search and found:
- No peer-reviewed paper that publishes "tag X works on phone Y"
  measurements.
- The closest item is `[NFC-Forum-Analog-Align]` (RFID-Journal-
  hosted whitepaper, not peer-reviewed; verifies ISO 14443 analog
  parameter spaces but not phone interop).
- Community wikis (`shopnfc`, `dangerouswiki`, `flipperdevices`
  issue tracker) carry the data; they are explicitly cited in
  industry-survey §3.7 / §7.6 and academic-survey §7.6.

**Academic-survey Q-as-1's "this is a literature gap, not a
project-side gap" finding is correct.** Stage 2 should note this
and treat the phone-compat envelope as derived from
vendor-API-docs + community-empirical sources rather than from
peer-reviewed measurements.

**d. NTAG21x datasheet anchors — spot check the cited values.**

Spot-checked via `[RFIDCard-NTAG]` open mirror plus the
locally-cached NTAG213_215_216_rev3.2.pdf (per industry-survey
references.md, 1.93 MB, byte-exact size match). Values that I
could verify externally: 144 / 504 / 888 user bytes; 50 pF input
cap; 106 kbit/s; 7-byte UID at cascade level 2; manufacturer ID
0x04 (NXP) in SN0. **All NTAG21x anchors check.**

The NTAG216 NDEF-max value (industry-survey §3.6 = 868 B; CC-byte
implies 872 B) has a 4-byte unexplained gap. This is the NDEF
TLV wrapper overhead (TLV tag + 3-byte length for SR=0 records)
but the report doesn't say so. **Cosmetic clarification needed.**

### Specific revisions requested

1. **Fix `[Myny-2017-ISSCC]` author list** in
   `stage1-academic-survey/references.md`. The current list
   contains Vicca, Furthner, A. K. Tripathi (twice), Cobb,
   Beenhakker, Heremans — none are authors. Replace with the
   canonical author list from Google Scholar / IMEC repository:
   K. Myny, Y.-C. Lai, N. Papadopoulos, F. De Roose, M. Ameys,
   M. Willegems, S. Smout, S. Steudel, W. Dehaene, J. Genoe.

2. **Fix the academic-survey RFC reference**. RFC 2425 is **not
   vCard 2.1**; it is the parent MIME-directory profile. RFC 2426
   is vCard 3.0 (Dawson and Howes, not "Howes et al."). vCard 2.1
   is an Internet Mail Consortium specification (1996), not an IETF
   RFC. First-principles `references.md` R9 already gets the IMC
   citation right; academic-survey should adopt FP's R9 wording.

3. **Fix the `[Hackaday-PowerFreeNFC]` anchor in industry-survey
   §5.4**. The verbatim quote from the project page is "operates
   within the 4.5 mA power budget supplied by typical NFC readers
   (3.3 V/15 mW)". The "3.5 mA @ 27.12 MHz" specification is the
   MCU's own current draw, *not* the total system draw. The
   industry-survey's "3.5 mA at 3.3 V from a 15 mW NFC field =
   11.5 mW total chip + modem + modulator average" derivation
   conflates these. Rewrite to: "the project budgets up to 4.5 mA
   from a 15 mW NFC field; the MCU draws 3.5 mA stand-alone,
   leaving margin for the modulator and demod paths."
   Architectural conclusion (≫10× headroom over our modulator
   budget) is **not affected** — even at 4.5 mA × 3.3 V = 14.85
   mW vs our ~0.56 mW modulator-only budget, headroom is still ~26×.

4. **Add a sentence to industry-survey §3.6** explaining the
   NTAG216 4-byte gap between CC-byte memory size (872 B = 0x6D × 8)
   and NDEF-max (868 B). The 4 B is NDEF TLV wrapper overhead
   (TLV tag byte + length-field bytes + terminator). Without this
   note, the table looks self-inconsistent.

5. **Industry-survey §5 and academic-survey §5 must add a
   methodology disclosure**: "This section is a cross-check
   against first-principles §5; it does **not** independently
   re-derive the analytical claims. The corroboration is by
   datapoint-comparison only." This makes the
   suspicious-convergence pattern explicit so that Stage 2 can
   correctly weight evidence.

6. **Academic-survey §7.1** should reword the iOS-T5T-implantable
   causality. Current text implies "T5T was chosen for implants to
   kill iOS reach" which is backwards. Replace with: "T5T was
   chosen for implants because of sub-mW operation and through-
   tissue range; the iOS 11/12 reach loss is a *consequence* of
   that choice, fatal to our brief but irrelevant to implants."

7. **First-principles `references.md` R9** lists "Howes et al.,
   *vCard MIME Directory Profile*, RFC 2426 (vCard 3.0), 1998" —
   the canonical author order is Dawson and Howes (Frank Dawson is
   first author). Cosmetic fix.

8. **Academic-survey author's-notes pre-empts winner-picking** —
   "iOS Core NFC's reluctance to expose vCard NDEF is a
   recurring sore point in the community literature but
   conspicuously absent from peer-reviewed silicon literature".
   This is fine as observation, but the immediately-preceding
   sentence ("Peer-reviewed silicon power numbers ... corroborate
   the first-principles 50–300 µW band") is mildly Stage-3-shaped
   for a Stage-1 report. Soften to "this corroborates *one*
   sister-report estimate but does not select a winner".

9. **Stage-2 hand-off note**: when synthesising (h), the
   methodology requires resolving contradictions across angles.
   Because (h) has *minimal* contradictions and *maximal*
   convergence, Stage 2 must avoid treating "all three angles
   agree" as triple-confirmation; per methodology, this is a
   **red flag** that one or more angles is derivative. The
   correct synthesis is to (a) accept the qualitative verdict
   (T2T+CLK-CARRIER+AC-FIXED-UID+mask-ROM is the right baseline)
   *because* the physics is independent and trustworthy, and (b)
   commission a Stage-3 deep-dive on T2T that *generates* the
   missing peer-reviewed phone-compat matrix and modulator R_DSon
   sweep, since those are the gaps not closed by Stage 1.

## Closing notes

This is a **substantively excellent set of three Stage-1 reports**.
The numerical claims are clean (15/15 sanity checks pass); the
solution-space coverage exceeds the methodology floor; the negative
results are concrete and actionable; the topology-ID name spaces
avoid the (a)/(f) pattern of label collisions.

The two real defects — the Myny author hallucination and the
explicit cross-citation between sister §5 sections — are
representative of the programme-wide patterns in CORRECTIONS.md.
Fixing them is a 30-minute task; the architectural verdict is
unaffected.

The strongest single finding in (h) is **the unanimous
CLK-CARRIER consensus**, attested independently in industry
(every shipping passive NFC IC), academia (Myny 2017 ISSCC + every
silicon paper consulted), and first-principles (RC drift 1000× too
loose). This decouples item (h) from item (a) for the modem path
and is the largest cross-cutting finding in the (h) folder.

The weakest area is **iOS phone-compatibility evidence**, which
rests entirely on Apple's developer documentation + ST blog
posts + community wikis. Stage 3 must close this gap with direct
empirical measurement against an iPhone 7 (oldest iOS 11-capable
hardware in mainstream usage) plus an iPhone XS/11/14/15 ladder,
preferably scripted via a Proxmark3 emulator so the test can be
re-run cheaply.

Stage-2 synthesiser: please flag the (h) cross-citation pattern
explicitly in `gap-analysis.md` and treat the academic-survey and
industry-survey as evidence layers on top of FP, not as fully
independent surveys. The pattern is documented in (b) and now (h);
it is at risk of becoming the project default.
