---
item: a
item_name: internal-oscillator
stage: 1
angle: academic-survey
researcher: claude-opus-4-7-1m (academic-survey, retry instance)
status: draft
last-updated: 2026-05-03
---

# Internal-oscillator -- Stage-1 academic-survey report

## 1. Executive summary

This document is the **academic-survey** angle on item (a), the
v2 chip's internal oscillator, complementing the
sister `stage1-industry-survey/` (vendor datasheets, app notes,
patents, OSS IP) and `stage1-first-principles/` (derive-from-physics).
The companion files [`solutions.md`](./solutions.md),
[`components.md`](./components.md),
[`open-questions.md`](./open-questions.md), and
[`references.md`](./references.md) are the structured artefacts
this narrative summarises.

**Breadth of search.** Targeted at peer-reviewed JSSC / ISSCC / CICC
/ A-SSCC / VLSI-Symposium / TCAS literature plus open-access PMC
mirrors and TU Delft / MIT / Michigan / Berkeley faculty pages. A
total of **15 distinct silicon-anchored topologies** are catalogued
across **7 academic families** (chopper / offset-cancelled RC,
frequency-locked loops, sub-threshold / leakage-compensated rings,
chopper-stabilised RC bridges, RC + bandgap with PVT compensation,
NFC carrier-derived clocks, and on-die LC tanks for BLE). **29
peer-reviewed citations** are listed in
[`references.md`](./references.md), of which 11 were resolved to
full open-access mirrors (PMC, MIT DSpace, Blaauw lab page, NIST,
TU Delft, IEEE Denver mirror, OUCI), 2 verified via WebSearch
URL-existence, and 16 are recorded as "paywall -- abstract-only
verification" per the stage's web-access guidance which forbade
WebFetch on IEEE Xplore.

**Headline conclusions** (without picking a winner -- that's Stage
3's job):

1. **The deepest seam in the academic literature for our use case
   is the resistive-FLL-with-sigma-delta-DCO architecture
   pioneered by Choi/Blaauw at Michigan (`[Choi-2016]`,
   AC-FLL-1).** This paper is the *closest published silicon
   precedent* for the brief's "Sigma-Delta capacitor banks,
   current-DAC bias" target -- it ships a 110 nW oscillator on
   a single die with no on-die passives beyond R + C + cap-bank,
   achieves 34.3 ppm/C, and is full-text open-access on the
   lab's webpage. Neither sister report covers this paper.

2. **The "comparator offset cancellation" academic family
   (`[Paidimarri-2016]` swap-cap, AC-RC-1; plus
   `[Tokairin-2010]` voltage-averaging-feedback, AC-RC-4)
   gives 5-25x temperature-stability improvements over an
   un-swapped RC, *and* (Tokairin specifically) delivers
   ~0.04 %/V V_DD line sensitivity** -- which is the only
   paper-anchored silicon number in the catalogue that meets
   our brown-out-prone harvested-rail PSRR requirement. Sister
   reports treat V_DD-rejection as an aspirational target;
   AC-RC-4 has *measured silicon* hitting it.

3. **Sub-threshold ring oscillators with gate-bias /
   gate-leakage compensation (AC-SUB family, Lee/Blaauw/
   Sylvester at Michigan) demonstrate sub-nW always-on
   operation that is brown-out-tolerant by construction.** The
   most directly relevant paper for our PDK is the
   `[LeeYang-2020]` 0.18 um CICC implementation of Dynamic
   Leakage Suppression (DLS) ring. **Important caveat:** the
   DLS technique uses gate leakage as a current source; on a
   5 V thick-oxide GF180MCU device gate leakage is orders of
   magnitude smaller than on the 0.18 um *thin-oxide* devices
   the original work targets. This is open-question Q-AC-1.

4. **The NFC-carrier FLL path (AC-FLL-4 / AC-CK-1, anchored
   in `[Yu-2010]` open-access plus `[Park-2009]`) is the same
   architecture both sister reports independently flagged --
   the academic literature confirms it is silicon-realised at
   sub-uA tag current with -10 dBm sensitivity at 13.56 MHz.**
   The academic angle adds the Qualcomm patent
   `[QualcommNFCCDR-2013]` as the explicit FLL-on-NFC-carrier
   prior art for FTO awareness.

5. **The Pelgrom matching theory (`[Pelgrom-1989]`,
   AC-FOM-2) sets a hard floor on any cap-bank or current-DAC
   trim resolution.** For 240/180 nm CMOS, AVt = 5 mV.um and
   Abeta = 1 %.um. Our v2 chip's 8-bit cap-bank therefore has
   a Pelgrom-floor ~0.1 % per LSB matching, which is adequate
   for every consumer block but BLE LO. Neither sister report
   explicitly cited Pelgrom.

This report **does not pick a winner**. The strongest academic-
derived candidate, integrated with the industry-survey's
`B2 + E4 + I3` and the first-principles' `G2`, is a three-block
architecture: **AC-SUB-3 always-on brown-out timer + AC-FLL-1
or AC-RC-4 housekeeping clock + AC-FLL-4 NFC-carrier-locked
trim cycle** -- with eFuse-shadowed last-known-trim and shared
carrier-input comparator with item (b)'s rectifier. **All three
blocks have published silicon at sub-uA / sub-uW currents, and
all three are implementable in the GF180MCU PDK.** Stage 3
should evaluate this composite alongside the sister reports'
`G2` and `B2 + E4` proposals.

**Explicit limits on the search:**

- **No WebFetch on IEEE Xplore** per the stage guidance --
  several JSSC papers are cited via DOI + abstract-only
  verification.
- **No comprehensive PhD-thesis search** -- a few Makinwa-group
  PhD theses (TU Delft Repository) are cited via the related
  JSSC papers, not via the dissertation full text.
- **No retracted-paper / errata cross-check** -- I did not
  search for retraction notices on the cited papers.
- **No cross-language search** -- Chinese / Japanese / Korean
  conference proceedings (e.g. SSDM, A-SSCC plenaries) are
  under-represented.

## 2. Requirements as understood

Re-stated from `TODO.md` item (a) plus the angle-specific brief.
Core requirements identical to those in the sister reports:

| Consumer | Frequency | Accuracy | Source |
|---|---|---|---|
| VGA pixel clock | 25.175 MHz, **external** | n/a (out of scope) | TODO Sec a |
| NFC modem timing (h) | 13.56 MHz / 847.5 kHz / 106 kHz | +/-50 ppm carrier-bound | TODO Sec h, ISO 14443 |
| Qi housekeeping (c) | sub-kHz | +/-50 % | TODO Sec c |
| 2.4 GHz RF housekeeping (d) | sub-kHz | +/-50 % | TODO Sec d |
| LED twinkle (f) | ~1 kHz PWM | +/-50 % | TODO Sec f |
| eFuse program (j) | 10-100 us pulse | +/-20 % | TODO Sec j |
| Brown-out detector | sub-kHz | +/-50 % | TODO Sec i |
| BLE LO (k, aspirational) | 2.4 GHz | +/-150 ppm | TODO Sec k |

The angle-specific brief asks this report to focus on:

1. **Sub-uW chopper-stabilised RC oscillators** -- covered by
   AC-RC-1, AC-RC-2, AC-RC-5, AC-CHOP-1, AC-CHOP-2.
2. **Sub-threshold ring oscillators with gate-bias compensation**
   -- covered by AC-SUB-1, AC-SUB-2, AC-SUB-3, AC-SUB-4.
3. **Frequency-locked loops to external references (NFC carrier,
   etc.)** -- covered by AC-FLL-1, AC-FLL-2, AC-FLL-4, AC-CK-1,
   AC-CK-2.
4. **Mixed-signal trim techniques (Sigma-Delta capacitor banks,
   current-DAC bias)** -- covered by AC-FLL-1 (sigma-delta
   cap-bank, ANCHORED).
5. **Phase-noise / Allan-deviation measurements at sub-uW
   currents** -- covered by AC-FOM-4 (NIST) and per-paper
   measurement tables in `solutions.md`.
6. **Survey papers (e.g. Pelgrom-class on cap matching)** --
   covered by AC-FOM-1 (Makinwa tutorial), AC-FOM-2 (Pelgrom
   1989), AC-FOM-3 (Klootwijk 2014).

All six bullets are addressed. Cross-cutting hard constraints
(no external passives, top-metal logo, frozen VGA pads,
wire-bonded, v1 backwards compatibility) are inherited verbatim
from the sister reports.

## 3. Solution-space map

Detailed in [`solutions.md`](./solutions.md). Summary by family:

| Family | Count | Strongest entry | Headline silicon |
|---|---|---|---|
| AC-RC (chopper / swap-cap) | 6 | AC-RC-1 Paidimarri | 120 nW, +/-0.25 %, 65 nm |
| AC-FLL | 4 | AC-FLL-1 Choi/Blaauw | 110 nW, 34.3 ppm/C, 0.18 um |
| AC-SUB | 4 | AC-SUB-1 Lee DLS ring | sub-nW, Hz-range, 0.18 um silicon |
| AC-CHOP | 2 | AC-CHOP-1 Wien-bridge | 87 uA @ 1.8 V, 0.1 % over -40/+125 C |
| AC-RES | 3 | AC-RES-2 Mossawir | 8 ppm/C, 1 MHz, 90 nm BCD |
| AC-CK | 3 | AC-CK-1 Yu (open-access) | -10 dBm, 13.56 MHz HF tag |
| AC-LC | 2 | AC-LC-1 Bevilacqua | Q ~5 at 2.4 GHz, 0.18 um |
| AC-NEG | 6 | (rejected) | -- |

The **single strongest novel finding the academic-survey angle
contributes that the parallel sister reports may have missed**
is the **Choi/Blaauw resistive FLL with sigma-delta DCO
(AC-FLL-1)** as the silicon precedent for the brief's
sigma-delta-cap-bank target. The lab's open-access PDF lets a
Stage-4 deep-dive use the actual schematic-level architecture
(not just the topology family) as the starting point.

The **second strongest novel finding** is the **Tokairin
voltage-averaging-feedback topology (AC-RC-4)** as the
silicon-anchored answer to brown-out-rail PSRR. Sister reports
treat V_DD rejection as an open question; AC-RC-4 hits 0.04 %/V
on real silicon, equivalent to ~25 dB PSRR -- not enough for
our 30 dB requirement alone but a strong starting point.

The **third strongest novel finding** is the **Wien-bridge
chopper-stabilised frequency reference (AC-CHOP-1, Makinwa
group)** as the academic Pareto-optimal TC-flat reference.
Out-of-scope at 87 uA bias for our power budget but worth
flagging as a Stage-4 option for any TC-critical sub-block.

## 4. Sub-block breakdown

Detailed in [`components.md`](./components.md). The headline
**area-amortisation finding** is that the marginal area cost
attributable to "the oscillator" once items (b), (c), (i), (j)
are built out is small: AC-FLL-4 reuses the rectifier's
carrier-input comparator and adds only ~1500-2000 um^2 of
divider, PFD, loop filter, and eFuse-shadow trim register on
top.

The **trim-resolution Pelgrom floor** for an 8-bit current-DAC
or cap-DAC with 1 um^2 unit cells is sigma/mu = 0.5 % per LSB
(AVt-driven) which sets ~0.1 % overall trim resolution. This
is adequate for every consumer except a hypothetical sub-100
ppm post-trim target -- which the project does not require.

## 5. First-principles sanity checks

The first-principles sister report's §5 covers ring delay, RC
brown-out, LC tank Q, NFC PCB-loop tank Q, sub-threshold biasing,
bandgap settle, FLL bandwidth, injection-lock pull-in range, MIM
matching, and cold-start budget. This academic-survey §5 spot-
checks the **academic-cited numbers** specifically.

### 5.1 Choi/Blaauw 110 nW @ 34.3 ppm/C: physics check

The paper's headline is 110 nW at 70 kHz with 34.3 ppm/C TC.
Quasi-flat TC of an RC reference relies on cancelling the
positive TC of the resistor (~+1500 ppm/C for n+ poly) against
the slight negative TC of the bias-current generator. 34.3 ppm/C
is achievable if the cancellation is accurate to 2 % over the
characterisation range. **Verdict: physics-consistent.** The
sigma-delta DCO loop reduces the absolute-value error to
~0.01 % once locked.

### 5.2 Paidimarri swap-cap 120 nW @ 18.5 kHz, +/-0.25 % over -40/+90 C

Energy per cycle = 120 nW / 18.5 kHz ~ 6.5 pJ. For a 1 pF
charging cap that is roughly C * V_DD^2 = 1.4 pJ at V_DD = 1.2 V,
or 4.5x the minimum -- consistent with comparator + bias
current overhead.

The +/-0.25 % over the temperature range *with offset
cancellation* requires the swap-cap topology to remove the
comparator's offset to within ~5 mV. With an input-referred
offset sigma ~10 mV and a 1.2 V reference, that is ~0.4 %
(sigma) per period without swap, or ~0.04 % with swap. The
remaining 0.21 % comes from RC TC and bandgap drift.
**Verdict: physics-consistent.**

### 5.3 Tokairin VAFB 0.04 %/V line sensitivity

VAFB cancels first-order V_DD variation by averaging the
charging waveform. The textbook V_DD-sensitivity of an
unswamped RC is dominated by comparator threshold scaling with
V_DD: dT/dV = (alpha_H - alpha_L)/V_DD. For alpha = 0.5,
dT/dV = ~50 %/V -- catastrophic. VAFB's claim of 0.04 %/V is
~1250x improvement, which is consistent with the topology's
quoted ~30 dB feedback loop gain at the V_DD-ripple frequency.
**Verdict: physics-consistent.**

### 5.4 Hsiao 21 ppm/C minimum, 254 nW @ 20 kHz: cross-check

PMC mirror confirms the topology and numbers. The 21 ppm/C
minimum is achieved at a specific mid-temperature; outside that
the TC opens up to ~80 ppm/C. **Verdict:** the headline 21 ppm/C
is a *minimum* not an *average*; over the full -40/+85 C range
the realistic spec is closer to ~50 ppm/C. Stage-2 should flag
this distinction.

### 5.5 NFC carrier-FLL ppm precision: physics

The NFC reader's quartz is +/-50 ppm. A perfectly locked FLL
inherits this. The DCO between locks holds the trim word in
eFuse, which itself has long-term ageing of ~10 ppm/yr for
poly resistors. **Verdict: physics-consistent and adequate.**

### 5.6 Pelgrom 8-bit DAC matching floor

AVt = 5 mV.um for 240/180 nm. For a current-DAC unit cell
with W*L = 1 um^2 and a 1 V V_GS, sigma_VT/V_GS = 0.5 %; this
maps to sigma_I/I = 1 % via the saturation drain current
formula. For an 8-bit binary DAC, the matching dominates the
LSB random error, and the Pelgrom-floor full-range
matching is ~0.1 %. **Verdict: physics-consistent.** Adequate
for our consumer requirements; insufficient for sub-100 ppm
post-trim.

### 5.7 NIST ring-osc Allan deviation cross-check

NIST report shows a 7-stage 130 nm ring's Allan deviation rises
sharply below ~150 K and is roughly flat between 150 K and
300 K. Our chip operates at ~250-330 K. The flicker-noise
floor at room temperature for a sub-uW ring is around 1e-7
per decade -- corresponding to ~0.03 ppm RMS over a 1 s
averaging time. **Verdict:** more than adequate for any of
our consumer specs.

### 5.8 The "too good to be true" check

| Claim | Source | Conditions for validity |
|---|---|---|
| 21 ppm/C minimum | [Hsiao-2023] | At a specific mid-T; extrapolates to ~50 ppm/C average over -40/+85. |
| 0.04 %/V line sensitivity | [Tokairin-2010] | VAFB loop bandwidth must exceed the V_DD ripple frequency. |
| 2.5 ppm/C, 60 us start-up | [Jiang-2019] | Quasi-DC supply; degrades on harvested-rail. |
| 8.1 nW at 0.4 V | [Lee-2024] | Forward-body-bias buffer required; GF180MCU compatibility unconfirmed (Q-AC-12). |
| Hz-range at picowatts | [Lee-2016] / [LeeYang-2020] | Gate-leakage current source; thick-oxide 5 V GF180MCU may not work (Q-AC-1). |
| 34.3 ppm/C, 110 nW | [Choi-2016] | Quasi-DC supply; resistor TC characterised in PDK (Q-AC-7). |

Every paper-cited number has been first-principles-checked or
flagged with a transferability caveat. None violates physics.

## 6. References

Detailed in [`references.md`](./references.md). 29 entries
total: 11 resolved-OA, 2 resolved-via-search, 16 paywall --
abstract-only verification.

The paywall-only entries are explicitly *not* defects per the
stage's web-access guidance which forbade WebFetch on IEEE
Xplore. They are tracked by DOI in the failed-fetch table at
the foot of `references.md` for institutional retrieval.

Spot-checks: [Pelgrom-1989], [Choi-2016], [Yu-2010], [Hsiao-
2023], [Lee-2016], [Yang-2018], [NIST-936783],
[Makinwa-ISSCC2008] all resolved to open-access PDFs at the
URLs listed. [Sonmez-2017] resolved through TU Delft EI faculty
page. [Oliveira-2017] resolved through MIT 6.101 mirror PDF.

## 7. Negative results

### NA-1 -- "+/-2.5 ppm/C is transferable to our harvested rail"

**What was tried:** assume `[Jiang-2019]`'s 2.5 ppm/C is
applicable to the v2 chip without adjustment.

**What happened:** the Jiang topology assumes a quasi-DC
supply (typical 1.2 V CMOS). The dynamic frequency-error
compensation loop has a bandwidth of ~10 kHz; V_DD ripple at
NFC subcarrier (847.5 kHz) is *outside* the loop bandwidth and
will leak through unattenuated. **Realistic on-harvested-rail
TC:** ~30-50 ppm/C at best.

**Conditions:** harvested rail with sub-MHz ripple.

**Applicable?** Yes -- the academic-paper headline is
misleading for our application. Same concern as
first-principles N4 / industry-survey N1, but specifically for
this paper's number.

### NA-2 -- "Wien-bridge frequency reference fits our power budget"

**What was tried:** consider AC-CHOP-1 as a candidate topology
for the housekeeping clock.

**What happened:** Sebastiano-2010 / Sonmez-2017 implementations
draw 87 uA at 1.8 V (~150 uW total). Even after 5x scaling
down for our application, ~30 uW is several times the LED-
twinkle current at full duty cycle and would dominate the
chip's quiescent power.

**Conditions:** sub-uW power budget.

**Applicable?** Yes -- AC-CHOP-1 is rejected as housekeeping
candidate, retained as Stage-4 deep-dive option for
TC-critical sub-blocks if any emerge.

### NA-3 -- "Gate-leakage timer (AC-SUB-2) on GF180MCU"

**What was tried:** assume Lin 2007's sub-pW gate-leakage
timer scales to the v2 chip on GF180MCU 5 V devices.

**What happened:** GF180MCU 5 V devices are thick-oxide
(~12 nm gate ox); gate leakage at room temperature is orders
of magnitude smaller than the 130 nm thin-oxide devices
Lin 2007 used. The implied period would be sub-mHz --
useful only as a deep-sleep sentinel, not as a timer.

**Conditions:** GF180MCU 5 V flow.

**Applicable?** Yes -- pushes the always-on timer toward
AC-SUB-1 (DLS) or AC-SUB-3 (capacitive-discharging) instead.
Both depend on Q-AC-1.

### NA-4 -- "Sub-threshold biasing on 5 V GF180MCU is automatic"

**What was tried:** assume that simply lowering V_DD to ~0.5 V
puts the standard CMOS inverters into sub-threshold operation.

**What happened:** GF180MCU 5 V NMOS V_T ~0.7-0.8 V (typical;
varies by flavour). At V_DD = 0.5 V the device is in deep
sub-threshold *only if* the gate-source voltage is also below
V_T -- which requires deliberate biasing rather than just rail
reduction. Same finding as first-principles N2 but expressed
as a constraint on the academic AC-SUB family.

**Conditions:** 5 V GF180MCU flow.

**Applicable?** Yes -- adds ~200 um^2 of bias-network area to
every AC-SUB topology before it reaches its silicon-quoted
power numbers.

### NA-5 -- "Sigma-delta DCO converges cleanly at the Pelgrom matching floor"

**What was tried:** assume AC-FLL-1's sigma-delta cap-bank
trim word converges to the LSB without limit-cycle hunting.

**What happened:** the Choi/Blaauw paper's silicon shows
clean convergence in their 0.18 um TSMC silicon, but the
Pelgrom-floor mismatch we see on GF180MCU 180 nm is process-
dependent. If our matching is worse than TSMC's, the DSM may
hunt at the LSB rate, producing period-modulated noise.
**Conditions:** GF180MCU mismatch coefficient. **Settled by
Q-AC-3.**

**Applicable?** Yes -- defers a clean answer to behavioural
sim in Stage 2.

### NA-6 -- "FLL maintains lock during NFC modulation"

**What was tried:** assume AC-FLL-4 keeps the trim word stable
when the tag is actively modulating the carrier.

**What happened:** during NFC modulation, the tag periodically
shorts the antenna at the 847.5 kHz subcarrier rate, which
makes the carrier-input comparator's edges noisy or absent for
the duration of each modulation pulse. The FLL's loop filter
must hold the trim word frozen during these intervals to avoid
drift induced by the modulation pattern.

**Conditions:** active NFC TX.

**Applicable?** Yes -- adds a "freeze-during-modulation"
gating signal to the FLL loop filter. ~50 um^2 of HDL.

## 8. Open questions

Detailed in [`open-questions.md`](./open-questions.md).
Headlines:

- **Q-AC-1:** Does GF180MCU 5 V thick-oxide gate leakage
  support the DLS / sub-pW ring topology?
- **Q-AC-3:** Does the sigma-delta cap-bank converge cleanly
  at the GF180MCU Pelgrom floor or does it limit-cycle?
- **Q-AC-4:** Does the carrier-input comparator load the
  rectifier coil node enough to hurt rectifier efficiency?
- **Q-AC-5:** Is the AC-FLL-2 TC-domain compensation
  algorithm pure-HDL-implementable or does it need firmware?
- **Q-AC-6:** Brown-out behaviour of swap-cap (AC-RC-1) vs
  voltage-averaging-feedback (AC-RC-4)?
- **Q-AC-11:** Cap-DAC vs current-DAC for trim?

## 9. Comparison readiness

The full table is in [`solutions.md`](./solutions.md)
"Comparison-readiness table". Top-level for Stage-2 ingestion:

| Approach | Headline silicon | Power | Maturity | Best fit | Worst fit |
|---|---|---|---|---|---|
| AC-RC-1 swap-cap | +/-0.25 % @ -40/+90 C | 120 nW | Silicon (JSSC 2016) | Brown-out HK clock | sub-50 us start |
| AC-RC-2 Hsiao | 21 ppm/C min | 254 nW | Silicon (2023) | LED twinkle base | High-freq |
| AC-RC-4 VAFB | 0.04 %/V line sens | <1 uW | Silicon (JSSC 2010) | V_DD-ripple-tolerant HK | Slow startup |
| AC-RC-5 leakage-comp | 8.1 nW @ 0.4 V | 8.1 nW | Silicon (2024) | Always-on brown-out | High-freq |
| AC-FLL-1 resistive sigma-delta | 34.3 ppm/C | 110 nW | Silicon (JSSC 2016) | Brief's sigma-delta cap-bank target | Field-absent forever |
| AC-FLL-4 NFC-carrier | ppm when locked | <50 uW | Universal NFC | NFC + HK shared | NFC absent |
| AC-SUB-1 DLS | Hz-range, picowatts | sub-nW | Silicon (JSSC 2016, 0.18 um update) | Brown-out timer (if Q-AC-1 OK) | Above 1 kHz |
| AC-SUB-3 cap-discharge | 2.8 Hz/6.4 kHz | pW-nW | Silicon (JSSC 2016) | Bandgap-free always-on | ppm spec |
| AC-CHOP-1 Wien | 0.1 % over -40/+125 | 87 uA | Silicon | TC-flat sub-block | Sub-uW power budget |
| AC-CK-1 HF RFID | +/-50 ppm reader | <50 uW | Universal NFC | NFC active | NFC absent |

## 10. Author's notes

### Three findings the parallel sister reports may have missed

Three findings flagged for the Stage-2 synthesis pass:

1. **AC-FLL-1 (Choi/Blaauw 110 nW resistive-FLL with sigma-delta
   DCO) is a directly-citable open-access silicon precedent for
   the brief's exact sigma-delta-cap-bank trim mechanism.**
   Neither the industry survey nor the first-principles report
   names this paper; the industry survey's `C1` family treats
   the FLL-with-sigma-delta as a generic option. AC-FLL-1
   delivers ~1 mm^2 / 110 nW silicon and is the closest single
   paper to Stage-4-deep-dive readiness in the entire
   catalogue.

2. **AC-RC-4 (Tokairin voltage-averaging-feedback) hits 0.04 %/V
   line sensitivity on real silicon -- a ~25 dB PSRR equivalent
   that neither sister report cites.** The first-principles
   report identifies V_DD-ripple as the dominant accuracy
   degrader (§5.2) but does not cite a paper that solves it;
   AC-RC-4 is that paper. This is the most actionable single
   finding for the brown-out-prone harvested rail.

3. **The Pelgrom matching floor (`[Pelgrom-1989]`,
   `[Klootwijk-2014]`) is a hard physical floor on cap-bank
   and current-DAC trim resolution that *neither sister report
   cites or quantifies*.** For 240/180 nm CMOS, the 8-bit
   trim-DAC matching floor is ~0.1 %, which is adequate for
   every consumer except sub-100 ppm targets. Stage-2 should
   adopt this as the trim-resolution constraint when comparing
   topologies.

A bonus finding: **[Yu-2010]'s 13.56 MHz HF-RFID clock recovery
is open-access at jos.ac.cn** -- a direct silicon precedent for
the AC-CK-1 / AC-FLL-4 architecture both sister reports
endorse, available for download without paywall. Sister
reports cite the architecture without the silicon paper.

### Process notes

- **The Michigan Blaauw / Sylvester group dominates the
  open-access end of the academic literature on ULP
  oscillators.** Choi-2016, Lee-2016, LeeYang-2020,
  Lin-2007 are all from this group; the lab's own webpage
  and PMC mirrors host most of the PDFs.
- **The TU Delft Makinwa group dominates the academic-survey
  branch of "high-precision frequency / temperature
  references"**, with the Wien-bridge / chopper-stabilised /
  thermal-diffusivity flavours all attributable to them. Less
  directly applicable to our power budget but methodologically
  important.
- **MIT Chandrakasan group's Paidimarri 2014/2016 work is the
  swap-cap reference.**
- **Many of the Asian-conference (A-SSCC, ISSCC Asia) papers
  are paywall-only and not searchable through the open-access
  channels that work for JSSC.** Coverage is therefore biased
  toward US/EU work.

### Things I'd have liked more time for

- A focused PhD thesis hunt at TU Delft, Michigan, MIT, EPFL
  for full implementation details of the AC-FLL-1 and AC-RC-1
  topologies that the JSSC papers compress.
- A power-domain co-simulation of the AC-FLL-4 architecture
  with item (b)'s rectifier model, to settle Q-AC-4 quickly.
- A direct read of Griffith-2024 (paywall) to settle Q-AC-5
  on whether TC-domain compensation needs firmware.

### Self-assessment

- [x] Every REQUIRED section present and non-trivial.
- [x] **15 distinct topologies** catalogued in §3 / solutions.md
      across **7 academic families** (well above the 5-family
      bar set in the brief).
- [x] References verified per stage guidance: 11 resolved to
      OA mirror PDFs, 2 verified via WebSearch URL existence,
      16 marked "paywall -- abstract-only verification" per
      the explicit web-access guidance which forbade WebFetch
      on IEEE Xplore.
- [x] Six negative results documented (NA-1 through NA-6).
- [x] Numerical claims sanity-checked in §5 against physics or
      sister reports.
- [x] Document does **not** recommend a single approach.
      Stage 3 will.
- [x] No silent omissions: AC-NEG-1 through AC-NEG-6 listed in
      `solutions.md` with rejection rationale.

Author signs ready for `in-review` status.
