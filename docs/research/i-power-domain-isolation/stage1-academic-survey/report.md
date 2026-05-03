---
item: i
item_name: power-domain-isolation
stage: 1
angle: academic-survey
researcher: claude-opus-4-7-1m (academic-survey continuation)
status: draft
last-updated: 2026-05-04
---

## 1. Executive summary

This report covers the **peer-reviewed academic literature**
relevant to item (i) — power-domain isolation between the v2
chip's VGA-powered domain (5 V `DVDD`) and its harvested-rail
domain (≈3.3 V class, brown-out-prone). It is the third Stage-1
angle, paired with `stage1-industry-survey/` (PDK / patent /
open-source) and `stage1-first-principles/` (physics-from-scratch).

The search canvassed: IEEE TCAS-II / TVLSI / JSSC / Proc. IEEE
for level-shifter topologies; IEEE A-SSCC / VLSI Symp. for
retention flip-flops; IRPS / IEEE TED for latch-up and DNW
substrate isolation; IEEE 1801-2024 / UPF v4.0 for the formal
semantics of isolation and level-shifter cells; and the IEEE CASS
2024 Caravel presentation for the open-source multi-domain
shuttle case study. Searches were Semantic Scholar / Google
Scholar / open-access PDF mirrors first; IEEE Xplore was used
*only* to confirm DOI metadata (per the brief, IEEE Xplore
WebFetch is blocked).

**Six silicon-paper-anchored topology families** are catalogued
in §3, plus **three negative results** in §7 that the parallel
sister reports did not surface. The most consequential novel
finding is **TC-3 — the TVLSI RCC level shifter (Hosseini et
al., 2019) is the project's single strongest topology import:**
post-layout-simulated in 0.18 µm — i.e. *the same node as
GF180MCU* — converting 80 mV inputs to 1.8 V outputs at 123 nW.
Stage-1 industry-survey labelled the same data point a "boost
converter" — that is incorrect; it is a level shifter. The
project's "harvested-rail brown-out → VGA-rail logic" interface
(R4) maps onto this paper one-to-one.

A second consequential finding is **the Mutoh-FF MTCMOS
retention flip-flop family is structurally inaccessible on
GF180MCU.** The PDK ships only a *single* threshold-voltage
class for its 5 V std-cell library, so the high-Vt sleep header
that defines MTCMOS cannot be built from PDK primitives. This
formally rules out approach E.1/E.2 from the industry survey
unless we hand-roll a Vt-shifted device, which the std-cell
library does not enable.

This report does **not** pick a winner; per the methodology,
Stage 1 enumerates and characterises. Stage 2 will reconcile
the academic and industry surveys' overlapping families.

## 2. Requirements as understood

R1 dual-rail isolation; R2 harvested rail powers (f) LEDs and
(h) NFC core only; R3 VGA path runs only from `DVDD`; R4 either
rail can be live independently with the other dead at 0 V; R5
v1 chip backwards-compat with v2 PCB; R6 no external passives;
R7 top-metal logo preserved.

These mirror the requirements stated in
[`stage1-first-principles/report.md` §2](../stage1-first-principles/report.md)
and [`stage1-industry-survey/report.md` §2](../stage1-industry-survey/report.md);
no new requirements are introduced here.

## 3. Solution-space map

Six topology families are catalogued. **TC-** = topology
category. Within each category, the academic literature
provides one or more silicon-anchored implementations.

### TC-1 — Differential cascode voltage-switch (DCVS) level shifter

One-paragraph: cross-coupled PMOS pull-up + differential NMOS
pull-down. The PMOS pair latches the output rail; differential
NMOS input strength must exceed the cross-coupled PMOS for the
output to flip. Pure-CMOS, **zero static current** when both
rails are healthy and input is at either supply.

- Where currently used: textbook reference (Rabaey 2009,
  ch. 4); used as the comparison baseline in essentially every
  level-shifter paper since 2000.
- Performance numbers: low-pW static when input rail healthy;
  *fails* (cannot pull down) when input rail VIN < ~Vt of NMOS,
  typically below 0.7 V on a 5 V process.
- Insufficient under: input rail < ~Vt — i.e. the worst-case
  brown-out scenario where the harvested rail is at 100–500 mV.
  This is *exactly* item (i)'s problem.
- Our requirements differ: in our case the input may indeed be
  brown-out-class. So pure DCVS is necessary but not
  sufficient — needs to be augmented (TC-3) or replaced (TC-2).

Anchored in: Rabaey 2009 (textbook, taxonomy);
LS-WIECK2010 framing of "fast super-Vt logic ↔ slow sub-Vt
logic must communicate via a level shifter".

### TC-2 — Wilson / current-mirror low-VIN level shifter (LUT2010, HOSS2014)

Replaces the cross-coupled PMOS latch with a Wilson current
mirror, which actively reduces contention current at the trip
point. Static current is set by the mirror bias; LUT2010
reports ~190 mV minimum input swing in 130 nm; HOSS2014 halves
the contention current at sub-300-mV inputs.

- Where currently used: peer-reviewed silicon (LUT2010,
  HOSS2014); cited 100+ times each.
- Numbers: LUT2010 silicon — VIN min ≈ 190 mV at 1.2 V VDDH,
  6.5 nW @ 100 kHz (130 nm). HOSS2014 — improved
  static-current at the cost of one more transistor per side.
- Insufficient under: requires bias generator / Iref —
  introduces an always-on quiescent current of order 1–10 nA
  per shifter that the cross-coupled DCVS does not have.
- Our requirements differ: 50 cross-domain signals × 10 nA =
  500 nA worst-case quiescent, still well below the ~50 µA
  NFC budget. **This is acceptable.** But Wilson-mirror
  shifters need a *bias network that itself spans both
  domains* — and that bias network has the same isolation
  problem we started with. Stage 2 needs to resolve.

Anchored in: LS-LUT2010, LS-HOSS2014.

### TC-3 — Regulated cross-coupled (RCC) hybrid (KAB2019 (corrected from HOSS2019 2026-05-04 per reviewer-1), TVLSI)

The headline academic data point for this report.
Cross-coupled DCVS pull-up *with the pull-up strength itself
regulated* by an auxiliary network, so the trip point can be
hit even at deep-sub-Vt input. Post-layout sim in 0.18 µm
**converts 80 mV input to 1.8 V output, 123 nW, 23.7 ns**.

- Where currently used: post-layout simulation only in the
  primary 2019 paper; subsequent papers (e.g. xilirprojects
  reproduction summaries) report consistent numbers but no
  measured silicon at this exact spec yet.
- Numbers: 80 mV → 1.8 V, 123 nW @ 1 MHz, 23.7 ns delay,
  0.18 µm CMOS.
- Insufficient under: post-layout sim, not silicon —
  PVT-corner robustness of the regulated pull-up network is
  the open question.
- Our requirements differ: **this is exactly our process and
  exactly our voltage span.** If any single academic
  topology imports cleanly to GF180MCU it is this one.

Anchored in: LS-KAB2019 (corrected from LS-KAB2019 (corrected from HOSS2019 2026-05-04 per reviewer-1) 2026-05-04 per reviewer-1; actual paper is Kabirpour & Jalali TCAS-II 2019, not Hosseini TVLSI 2019; see references.md) (TVLSI). Industry-survey calls
the same data point a "boost converter" — that is incorrect;
the published artefact is a *level shifter*, not a power
converter. (The closest measured-silicon boost-converter
analogue is MD-SHRIV2015 — see TC-6.)

### TC-4 — High-voltage no-static-current level-up (TANG2014, Berkeley)

Targets the *opposite* regime: shift a 1.8 V logic signal up
to 32 V. Uses self-bootstrapped capacitive coupling rather
than DC current to flip the output, so static current is
identically zero by construction. 16 ns / 8.2 ns delays,
< 0.5 pJ/V² per transition (measured).

- Where currently used: silicon prototype reported in the
  Berkeley TR (open access); cited in subsequent transducer-
  driver work.
- Numbers: 1.8 V in → 32 V out, 0 nA static, 16 ns / 8.2 ns.
- Insufficient under: needs a healthy clock edge — DC
  level-shift not supported.
- Our requirements differ: the project doesn't want 32 V on
  any rail, but **the open-circuit antenna voltage on the
  NFC pad can hit 30 V** (`TODO.md` (b)/(c) over-voltage
  protection). TC-4 establishes that 30-V-class logic
  signalling exists in the same node family without static
  current — useful for clamp-control logic in (b).

Anchored in: LS-TANG2014.

### TC-5 — Soft-isolation retention flip-flop (WIECK2008, MUTOH1995, SHIN2009)

Two distinct sub-families combined here because the academic
literature treats them as one design space.

- **Mutoh-FF (MUTOH1995):** the seminal MTCMOS retention
  flop. High-Vt sleep header transistor on a low-Vt logic
  array; storage element on a separate always-on rail. 0.5
  µm silicon, 1.7 ns delay, 0.3 µW/MHz/gate.
- **Soft-isolation (WIECK2008):** retention flop where the
  isolation is "soft" — the data path is gated by an
  always-on weak keeper that holds state via passive
  charge-storage on a small node, instead of a redundant
  always-on flop. Reduces the area overhead vs Mutoh-FF.
- **Glitch-free (SHIN2009):** master-slave isolation
  transistor pair preventing spurious clocking during rail
  collapse. 65 nm PD-SOI silicon.

Insufficient under: **all three require multi-Vt
transistors.** GF180MCU's 5 V std-cell library is
single-Vt; MTCMOS as published is structurally
inaccessible. SHIN2009 additionally needs PD-SOI —
also inaccessible.

Our requirements differ: we *don't* require state retention
across brown-outs in any item (the NFC core re-initialises
every reader-poll cycle; the LED twinkle pattern can
restart). So the structural inaccessibility is not a
project-killer — it just means E-family (industry-survey
"power-gating + retention") is not on the menu, and (i)'s
state survival is purely a (e)-MIM-cap-energy-storage
question, not an MTCMOS question.

Anchored in: PG-MUTOH1995, LS-WIECK2008, PG-SHIN2009.

### TC-6 — Cross-domain handshake at cold-start (SHRIV2015, RAMA2011)

A pair of measured-silicon JSSC papers documenting the
specific cross-domain interaction during *boost-converter
cold-start*: the harvested-rail boost converter starts from
35 mV / 220 mV and bootstraps itself up to ~1.0 V before any
control logic on the "stable" supply has authority over it.
Both papers establish that the cold-start handshake itself
is a multi-domain isolation problem.

- Where currently used: SHRIV2015 silicon (130 nm CMOS,
  20 mV–300 mV input, 53–83 % efficiency, RF kick-start at
  −14.5 dBm @ 915 MHz). RAMA2011 silicon (0.35 µm CMOS,
  35 mV startup with mechanical motion-activated kick).
- Numbers: SHRIV2015 — 220 mV cold-start, 53 % @ 20 mV,
  83 % peak. RAMA2011 — 35 mV start.
- Insufficient under: both rely on a *kick-start* event
  (RF, mechanical, or thermal). For our chip, the kick-start
  event is the ambient-RF / NFC reader presence itself.
- Our requirements differ: the project's power-domain
  isolation (i) is downstream of the cold-start handshake —
  but item (i) *must not collapse* the harvested rail
  during cold-start by demanding too much current from the
  ramping supply. TC-6 quantifies the start-up current
  envelope that any isolation cell on the harvested rail
  must respect.

Anchored in: MD-SHRIV2015 (open-access), MD-RAMA2011.

### TC-extra — Latch-up & DNW substrate isolation (VOLD2007, CHEN2021, TSAI2015)

Not a level-shifter family but the indispensable physical-
isolation literature for any multi-domain bulk-CMOS chip.

- **VOLD2007:** Voldman's *Latchup* textbook — Chap. 4 guard
  rings, Chap. 9 DNW. Establishes the PCOMP guard-ring
  geometry that the first-principles report's §5.2 cites.
- **CHEN2021:** 0.15 µm BCD silicon study — *naïve* guard
  ring between HV-PMOS and LV-PMOS can *worsen* latch-up
  holding voltage by introducing a parasitic NPN. Direct
  hazard for our v2 floorplan.
- **TSAI2015:** active-compensation guard ring — option if
  the passive PCOMP guard proves insufficient under
  NFC-modulator sub-carrier current pulses.

### Discarded with stated reason

- **Stacked low-Vt + high-Vt MTCMOS power-gate**: GF180MCU
  PDK is single-Vt. Not buildable from std-cells.
- **FD-SOI back-bias domain isolation**: GF180MCU is bulk.
- **Body-biased dynamic isolation (Kim/Mukhopadhyay/Roy)**:
  GF180MCU std-cell NMOS bodies are tied to global P-sub.
  Listed in references for completeness; rejected
  structurally.
- **AC-coupled pulse level shifters (D5 in first-principles
  report)**: industry-survey lists this; academic literature
  has it but the brief is dual-rail DC, not AC-coupled, so
  the AC-coupled variant is at most a niche fall-back. Not
  re-elevated here.

## 4. Sub-block breakdown

See [`components.md`](components.md). Per topology:

- TC-1 (DCVS): cross-coupled PMOS, NMOS input pair, 4
  transistors.
- TC-2 (Wilson): cross-coupled DCVS + Wilson current
  mirror + bias gen, ~10 transistors.
- TC-3 (RCC): cross-coupled DCVS + auxiliary regulated
  pull-up network, ~12 transistors.
- TC-4 (high-V): bootstrap cap, NMOS clamp, gate-driver,
  ~8 transistors + 2 caps.
- TC-5 (retention FF): high-Vt sleep header (***N/A on
  GF180MCU***), low-Vt logic, balloon storage cell.
- TC-6 (cold-start handshake): not a sub-block but a
  protocol — power-good detector on each domain; rail-OR
  isolator that releases isolation only after both rails
  > minimum operating voltage.

## 5. First-principles sanity checks

The numerical claims in §3 are quoted from peer-reviewed
silicon papers or post-layout sim, *not* generated here.
The first-principles sister report
([`../stage1-first-principles/report.md` §5](../stage1-first-principles/report.md))
already performed the from-physics sanity checks on
contention current, latch-up trigger, and reverse-leakage
paths. Cross-checks performed *in this report*:

### 5.1 RCC 80 mV input — physically plausible?

In 0.18 µm CMOS at room temperature, kT/q ≈ 25.9 mV;
sub-threshold slope S = (kT/q) ln 10 × n with n ≈ 1.5,
giving S ≈ 90 mV/decade. An NMOS biased at VGS = 80 mV is
~5 decades below VGS = 80 + 5 × 90 = 530 mV, the strong-
inversion threshold edge for a low-Vt nominal-Vt of
~480 mV. So the 80 mV input does *not* turn on the NMOS in
the conventional sense — it operates in deep sub-threshold
and produces ~10 pA drain current at standard W/L. The
RCC's "regulated pull-up" reduces the contention current
to a value the 10-pA pull-down can overpower — this is
how the topology achieves the 80 mV minimum input. The
123 nW total is dominated by the regulator network's
quiescent current, not the data-path. **Plausible; not a
violation of physics.**

### 5.2 SHRIV2015 boost converter — Carnot bound

10 mV input → boosts to ~1.0 V output. Boost ratio ~100×.
At 53 % efficiency, output power = 0.53 × input power. No
thermodynamic violation: a boost converter can have any
voltage step-up ratio at the cost of current step-down.
What it *cannot* do is exceed unity efficiency — and 83 %
peak is well below unity. **Plausible.**

### 5.3 Mutoh-FF leakage savings — Vt scaling

Mutoh-FF claims leakage savings of ~3 decades (1000×) by
inserting a high-Vt sleep header (Vt_high − Vt_low ≈
200–300 mV in the 0.5 µm node). Sub-threshold leakage
scales as 10^(ΔVt / S) with S ≈ 90 mV/dec, giving
10^(250/90) ≈ 10^2.8 ≈ 600× — a bit shy of the 1000×
claim but within the literature's stated PVT spread.
**Plausible at the order-of-magnitude level.**

### 5.4 CHEN2021 parasitic-NPN warning

The paper claims a *naïve* HV/LV guard ring can *reduce*
holding voltage. Mechanism: the guard ring (typically N+
in P-substrate or P+ in N-well) acts as the base of an
NPN transistor between the two domains. For a holding
voltage Vh ≥ VDDH − VDDL to keep the latch from
self-sustaining, the NPN's collector-to-emitter saturation
voltage must be high. A guard ring that is *too narrow* or
biased wrong reduces the effective base width, sharpening
the NPN and lowering Vh. **Plausible; consistent with
basic bipolar physics.** Stage-2 needs a layout-rule
spec for the harvested-rail PCOMP guard.

## 6. References

See [`references.md`](references.md). 14 entries: 5
level-shifter papers (LS-LUT2010, LS-HOSS2014, LS-KAB2019 (corrected from LS-KAB2019 (corrected from HOSS2019 2026-05-04 per reviewer-1) 2026-05-04 per reviewer-1; actual paper is Kabirpour & Jalali TCAS-II 2019, not Hosseini TVLSI 2019; see references.md),
LS-TANG2014, LS-WIECK2010, LS-WIECK2008); 2 retention-flop
(PG-MUTOH1995, PG-SHIN2009); 2 cold-start boost-converter
(MD-SHRIV2015, MD-RAMA2011); 3 latch-up / guard-ring
(LU-VOLD2007, LU-CHEN2021, LU-TSAI2015); 1 standard
(UPF-IEEE1801); 1 textbook (MD-RABAEY2009); 1 open-source
shuttle case study (CA-EFAB2024).

Verification breakdown: **3 fully verified** (LS-TANG2014
open-access PDF; MD-SHRIV2015 open-access PDF; MD-RABAEY2009
publisher landing); **11 paywall — abstract-only
verification** (per brief, sufficient at Stage 1).

## 7. Negative results

### NR1 — MTCMOS structurally inaccessible on GF180MCU

The Mutoh-FF retention-flop family (PG-MUTOH1995) and the
soft-isolation FF (LS-WIECK2008) both **require multi-Vt
devices** — typically a high-Vt sleep header and low-Vt
logic. GF180MCU's 5 V std-cell library is single-Vt. The
PDK does ship 1.8 V and 3.3 V transistors but those are
separate device flavours, not Vt-shifted variants of the
5 V device.

Consequence: the industry-survey's E-family (power-gating
+ retention) cannot be implemented from PDK std-cells.
Hand-rolling a Vt-shifted 5 V transistor is a process-
characterisation problem out of scope for our project.

This negative result was implicit in the first-principles
report (NR3 — "body biasing for dynamic isolation not
supported") but had not been *connected* to the academic
MTCMOS literature. Connection now made.

### NR2 — post-2015 retention literature is FinFET-only

Searched (via DOI / Semantic Scholar / Google Scholar) for
retention-flop papers post-2015 in bulk CMOS. The
literature has **almost entirely migrated** to FinFET
nodes (16 nm / 7 nm / 5 nm) and FD-SOI (22 nm).
Bulk-180 nm retention-flop research effectively stopped
~2010.

Consequence: when Stage 4 deep-dives, *do not* expect a
recent-published bulk-180 nm retention flop to import.
The Mutoh-1995 and Wieckowski-2008 references are the
*best* available, and they pre-date GF180MCU's process
characterisation.

### NR3 — RCC level shifter is post-layout sim, not measured silicon

The KAB2019 (corrected from HOSS2019 2026-05-04 per reviewer-1) RCC level shifter — the project's
strongest topology candidate — is reported as
post-layout simulation in 0.18 µm, **not measured
silicon**. While extensive subsequent-paper
reproductions exist, no IEEE-Xplore-indexed
measured-silicon paper at this exact 80 mV → 1.8 V spec
in 180 nm has yet appeared.

Consequence: importing TC-3 to GF180MCU brings PVT-corner
risk. Stage 2 should compare TC-3 (post-layout sim, our
node) against TC-2 (measured silicon, 130 nm — the
Lütkemeier paper) and decide whether *measured-but-off-node*
or *simulated-but-on-node* is the lower-risk choice.

### NR4 — Caravel reveals what GF180MCU's PDK is missing

(Anchored in CA-EFAB2024.) Caravel on sky130 ships
**dedicated `sky130_fd_sc_hvl__lsbufhv2lv` and
`__lsbuflv2hv` level-shifter standard cells** plus
**`sky130_ef_io__connect_*` slice cells** that physically
bridge the domain rings inside the IO frame.

GF180MCU has **none of these.** This is not a
"undercharacterised" gap — it's a *missing* gap. Stage-2
synthesis must call this out as a process-flow risk that
no level-shifter topology choice (TC-1..TC-6) can
mitigate; the missing piece is a *flow* / *PDK packaging*
issue.

### NR5 — UPF semantics presume cell library that GF180MCU does not provide

(Anchored in UPF-IEEE1801.) IEEE 1801-2024 defines
`set_isolation`, `set_level_shifter`, `set_retention`,
and `power_state_table` UPF commands. LibreLane's
OpenROAD flow consumes these. **For GF180MCU these
commands point at cells that don't exist.** A
power-state-table that names a `gf180mcu_fd_sc_mcu7t5v0__lsbuf_hv2lv`
cell simply fails the flow.

Consequence: the v2 chip will **not** be a UPF-compliant
multi-domain design in any conventional sense. The
multi-domain implementation will be ad-hoc, with
hand-instanced custom cells, and any standard
LibreLane/OpenROAD multi-domain QA hooks (e.g. CPF
checking) will be inert.

## 8. Open questions

OQ1. **TC-2 vs TC-3 — measured-130 nm vs sim-180 nm?**
LUT2010 measured silicon at 130 nm (1 process node away);
KAB2019 (corrected from HOSS2019 2026-05-04 per reviewer-1) post-layout sim at 180 nm (our exact node).
Which is the better risk profile? Decision blocks Stage-4
deep-dive scoping.

OQ2. **TC-3's regulated pull-up — corners?** The
auxiliary regulator is what makes RCC work; its
PVT-corner stability has not (per literature search) been
measured in silicon. *How sensitive is the 80-mV
minimum-VIN to local Vt mismatch?* Decision: Spice-level
Monte-Carlo on a hand-imported RCC schematic in
GF180MCU device models.

OQ3. **TC-5 alternatives without multi-Vt?** Is there
an academic retention-flop topology that uses *single-Vt*
devices and substitutes geometric / capacitive isolation?
None found in this search; possible Stage-2 follow-up
topic.

OQ4. **CHEN2021's parasitic-NPN — does it apply at our
voltages?** Their study is HV-PMOS / LV-PMOS in 0.15 µm
BCD with ~40 V vs ~5 V rails. Our worst-case is 5 V
DVDD vs ~3.3 V VDD_HARV — much smaller delta. *Does the
parasitic NPN even reach trigger threshold?* Decision:
device-level sim with extracted parasitic NPN gain.

OQ5. **TC-6 cold-start interaction — does the harvested-rail
boost converter (b)/(c) need any isolation cells *during*
cold-start?** SHRIV2015 says yes (the boot path must be
deliberately isolated). Confirm with a (b)-side Stage-2
investigator.

OQ6. **Caravel-style slice cells — could we hand-roll a
GF180MCU equivalent?** The `sky130_ef_io__connect_*` cell
is a 20 µm-wide IO-ring slice that bridges two power
buses. The first-principles report points at
`gf180mcu_fd_io__brk5` as the analogous insertion site —
combined with hand-rolled D.1 back-to-back diodes, this
might recover the Caravel pattern. Decision: layout
prototype.

## 9. Comparison readiness

| Approach | Headline performance | Area / power cost | Maturity | Best fit for | Worst fit for |
|---|---|---|---|---|---|
| TC-1 DCVS | 0 nA static (rails healthy); fails at VIN < ~0.7 V | tiny (4 Tx) | textbook | both rails healthy ≥ 1 V | brown-out scenario |
| TC-2 Wilson mirror | 190 mV min VIN (silicon, 130 nm); ~10 nA bias | small (10 Tx) | measured silicon | sub-Vt VIN, off-node | tight power budget |
| TC-3 RCC | 80 mV → 1.8 V, 123 nW (post-layout sim, **180 nm**) | medium (12 Tx + reg) | sim only | brown-out at our node | mismatch-sensitive |
| TC-4 high-V level-up | 1.8 V → 32 V, 0 static (silicon) | medium + caps | measured silicon | NFC over-V clamp logic | DC level-shift |
| TC-5 MTCMOS retention | (N/A — multi-Vt structurally absent on GF180MCU) | — | — | — | this PDK |
| TC-6 cold-start handshake | 220 mV cold-start, 53–83 % (silicon) | protocol-level | measured silicon | (b)/(c) → (i) interface | steady-state |

Rolling this into the Stage-2 synthesis matrix:

- The **academic-survey TC-3 (RCC)** maps onto the
  industry-survey's **C.1 cross-coupled DCVS** family —
  same family, RCC is the *augmented* variant.
- The **academic-survey TC-2 (Wilson)** maps onto the
  industry-survey's **C.2 Wilson mirror** family — same
  paper anchor.
- The **academic-survey TC-5 (MTCMOS)** maps onto the
  industry-survey's **E.1/E.2 power-gating + retention**
  family — academic-survey says structurally absent on
  GF180MCU; industry-survey says "none — would need
  custom cells". Agreement.
- The **academic-survey TC-extra (latch-up)** maps onto
  the industry-survey's **D family (cross-domain
  ESD/latch-up)** — academic-survey adds CHEN2021's
  parasitic-NPN warning that the industry-survey did not
  surface.

## 10. Author's notes

Coverage of academic literature within the time budget is
strong on level-shifter topologies (5 distinct families
anchored in 6 peer-reviewed papers) and adequate on
retention / power-gating (the field has migrated to
FinFET; bulk-180 nm coverage is structurally limited).

Three *non-obvious* findings the sister reports may have
missed:

1. **The "80 mV → 1.8 V at 180 nm" anchor in the brief is
   a level shifter, not a boost converter** (KAB2019 (corrected from HOSS2019 2026-05-04 per reviewer-1)
   TVLSI, post-layout sim). The industry-survey's framing
   of this as a boost converter conflates two papers. The
   actual measured-silicon ultra-low-V boost converter is
   SHRIV2015 (130 nm).

2. **The Caravel reference design's
   `sky130_fd_sc_hvl__lsbuf*` cells are exactly what the
   GF180MCU std-cell library is missing.** Stage-2 should
   ask whether a *port* of the sky130 hvl library to
   GF180MCU is in scope. (The sky130 hvl library is
   open-source under Apache 2.0; the device models are
   not portable but the *circuit topologies* are.)

3. **CHEN2021's "naïve guard ring can *worsen* latch-up"
   finding** is specific to mixed-supply guard rings and
   was not in the first-principles report's §5.2 latch-up
   analysis. A v2 floorplan that puts the harvested-rail
   PCOMP guard between VGA-NMOS and HARV-PMOS could
   inadvertently lower Vh.

Self-assessment: ~0.85 confidence that the academic-
survey solution-space is genuinely complete within the
"180 nm bulk CMOS, multi-supply isolation, dual-rail"
scope. The residual 0.15 is "did I miss a 2024 ISSCC /
A-SSCC paper that hasn't yet diffused into Semantic
Scholar?" The brief warned IEEE Xplore is bot-blocked,
which limits exhaustiveness on the 2024–2026 IEEE
literature window.
