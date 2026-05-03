# Internal-oscillator -- Stage-1 academic-survey: open questions

These are the concrete unanswered questions surfaced by the
academic-survey angle. Each is phrased so that an engineer can
work it as a discrete sub-task in Stage 2 / Stage 3.

Question IDs use the `Q-AC-N` prefix to disambiguate from the
sister reports' `Q1`/`Q2`/etc. naming.

---

## Q-AC-1 -- Does GF180MCU 5 V thick-oxide gate-leakage support the DLS / sub-pW ring topology?

**Decision blocked by:** whether AC-SUB-1 (Lee 2016 / Lee-Yang
2020) and AC-SUB-2 (Lin 2007) -- which all rely on
gate-leakage-as-current-source -- run at all on a 5 V GF180MCU
flow.

**Why this matters:** the Hz-range "always-on brown-out timer"
is the most attractive low-power solution in the academic
catalogue. If GF180MCU 5 V thick-oxide gate-leakage is too
small (likely -- thick-oxide leakage scales as
exp(-A * t_ox)), the DLS technique gives essentially zero
ring frequency.

**Settled by:** SPICE simulation of a single DLS stage on
GF180MCU 5 V devices, comparing predicted gate-leakage current
against the per-stage cap discharge requirement at the target
Hz range. ~2 hours of work in Stage 2.

**Fallback:** AC-SUB-3 (Hsieh capacitive-discharging) which uses
sub-threshold drain current rather than gate leakage; should
work fine on GF180MCU 5 V.

---

## Q-AC-2 -- What is the GF180MCU MIM cap absolute-value PVT spread?

**Decision blocked by:** the trim range required of the
AC-FLL-1 / AC-RC-1 cap-bank.

**Why this matters:** Klootwijk-2014 (AC-FOM-3) gives 180 nm
*matching* numbers, not absolute-value spread. The Stage-1
first-principles report estimates ~20 % absolute spread, but
this is uncited and uncertain. If absolute spread is closer to
~30 %, the cap-bank needs ~10 bits not ~8 bits, with
corresponding area cost.

**Settled by:** PDK datasheet study + Monte-Carlo Spice over
process corners. ~1 hour of work in Stage 2.

---

## Q-AC-3 -- Sigma-delta cap-bank stability at GF180MCU mismatch floor

**Decision blocked by:** whether AC-FLL-1's sigma-delta DCO
trim word converges cleanly at the 5 mV.um Pelgrom floor, or
exhibits limit-cycle oscillation at the LSB.

**Why this matters:** if the LSB of the cap-bank corresponds to
a frequency step that is close to the random matching error,
the DSM will hunt and produce period-modulated noise around the
target frequency. This is academic-survey-specific (the industry
survey doesn't cover sigma-delta DCOs at our power budget).

**Settled by:** behavioural simulation of the loop filter +
DCO + DSM at the matching-coefficient extracted in Q-AC-2.
~3 hours of work in Stage 2.

---

## Q-AC-4 -- Carrier-input comparator at -10 dBm: ringing-margin on the rectifier coil node

**Decision blocked by:** whether AC-CK-1 / AC-FLL-4's
carrier-input comparator can be shared with the rectifier
without stealing too much rectifier efficiency. The rectifier
coil node is a high-impedance resonant node; loading it with a
comparator tap can reduce rectifier Q by a few percent.

**Why this matters:** if the comparator load is non-trivial,
it changes the rectifier design and therefore the energy budget
for items (b)/(c).

**Settled by:** small-signal Spice of the antenna + rectifier +
comparator-tap network at 13.56 MHz. ~2 hours.

---

## Q-AC-5 -- TC-domain compensation in pure HDL: does AC-FLL-2 work without firmware?

**Decision blocked by:** whether the Griffith 2024 TC-domain
correction algorithm can be implemented as a pure-HDL state
machine on the v2 chip (we have no on-die CPU).

**Why this matters:** if the algorithm requires an iterative
solve (e.g. Newton iteration to fit a quadratic), it may not
fit in pure HDL within reasonable area. If it's a closed-form
multiply-add, it does.

**Settled by:** reading the Griffith 2024 paper full text
(currently paywall -- abstract-only verification) and either
demonstrating the closed-form expression or noting that the
algorithm needs firmware. **Reviewer institutional access
required.**

---

## Q-AC-6 -- Brown-out behaviour of the AC-RC-1 swap-cap topology vs AC-RC-4 VAFB

**Decision blocked by:** which has better V_DD-immunity under
~5-20 % rail droop at 100 kHz - 1 MHz.

**Why this matters:** the project's harvested rail ripples at
NFC subcarrier (847.5 kHz), Qi switching (100-205 kHz), and
LED PWM (~1 kHz). The first-principles report's §5.2 estimates
±5 % real-world accuracy for an unswapped RC topology under
these conditions. Swap-cap helps with offset, not directly
with V_DD ripple. AC-RC-4 VAFB *directly* targets V_DD
sensitivity (0.045 %/V).

**Settled by:** explicit V_DD-noise-injection Spice on both
topologies. ~4 hours in Stage 4.

---

## Q-AC-7 -- Resistor TC and matching for the AC-FLL-1 / AC-FLL-4 RC reference

**Decision blocked by:** whether `nplus_u` / `pplus_u` / `nwell`
resistor TCs are well enough characterised in the GF180MCU PDK
for the Choi/Blaauw resistive FLL to hit 34.3 ppm/C on this
node.

**Why this matters:** the AC-FLL-1 design's headline 34.3 ppm/C
relies on careful resistor selection. If GF180MCU's resistor
TCs are not well characterised or are far from the
TSMC65/40-nm assumptions of the original work, our v2 chip's
TC will be worse.

**Settled by:** reading the GF180MCU resistor characterisation
docs. Open-access -- ~2 hours.

---

## Q-AC-8 -- Allan deviation expected at sub-uW currents

**Decision blocked by:** the floor on long-term frequency
stability we can expect.

**Why this matters:** the AC-FOM-4 NIST report shows ring-osc
Allan deviation rises sharply below ~150 K, but our chip
operates at room temperature. The 1/f flicker-noise floor at
sub-uW bias currents is the relevant floor.

**Settled by:** computing the flicker-noise spectral density
from GF180MCU device noise models, projecting to Allan
deviation via the standard Hadamard / Allan integral. ~3 hours.

---

## Q-AC-9 -- Wien-bridge resistor self-heating

**Decision blocked by:** whether AC-CHOP-1 (Wien-bridge
frequency reference) can be operated at our uA-scale current
budget without the resistor self-heating dominating its TC.

**Why this matters:** Sebastiano-2010's 87 uA bias is heavy
relative to our budget. Below ~5 uA, resistor self-heating
becomes negligible -- but at 5 uA the bridge's signal-to-noise
ratio also drops. The Pareto-frontier graph is what AC-FOM-1
attempts to characterise.

**Settled by:** thermal-electrical co-sim of the bridge at
1 uA and 5 uA. ~4 hours.

---

## Q-AC-10 -- NFC carrier presence handover: how long before the FLL freezes?

**Decision blocked by:** the AC-FLL-4 architecture's
field-absent recovery time.

**Why this matters:** when the NFC carrier disappears (user
walks away from the reader), the FLL must (i) detect the
disappearance, (ii) freeze the trim word, and (iii) shadow it
to eFuse if not already there. This handover can produce a
brief frequency excursion that affects downstream consumers.

**Settled by:** academic literature search for "FLL hold-time"
or "FLL flywheel mode" papers. Likely a Stage-4 question.

---

## Q-AC-11 -- Trim DAC current-DAC vs cap-DAC choice

**Decision blocked by:** which DAC topology -- current-DAC bias
trim of a current-starved ring vs MIM cap-bank trim of an RC
oscillator -- gives lower power per LSB on GF180MCU.

**Why this matters:** the brief explicitly calls out "Σ∆
capacitor banks, current-DAC bias" as a research focus. Both
have published silicon precedents (AC-FLL-1 uses cap-DAC; many
industry-survey topologies use current-DAC). They have
different brown-out behaviours: cap-DAC is V_DD-rejection-
friendly because the swap timing is digital; current-DAC is
sensitive to bandgap drift.

**Settled by:** a side-by-side comparison in Stage 3.

---

## Q-AC-12 -- Forward-body-bias compatibility on GF180MCU

**Decision blocked by:** whether AC-RC-5's forward-body-bias
buffer is implementable on GF180MCU.

**Why this matters:** AC-RC-5 (Lee 2024) reaches V_DD = 0.4 V
operation by FBB'ing the comparator buffer. GF180MCU's standard
flow probably doesn't expose the well biasing for FBB.

**Settled by:** reading GF180MCU PDK design rules + checking
N-well contact accessibility. ~2 hours.

---

## Q-AC-13 -- Should the Wien-bridge frequency reference (AC-CHOP-1) be a Stage-4 deep-dive option?

**Decision blocked by:** whether the Pareto frontier between
"area-minimising" (AC-FLL-4) and "TC-minimising"
(AC-CHOP-1 or AC-RES-2) crosses our requirement region.

**Why this matters:** if the Stage-3 shortlist commits to
"AC-FLL-4 plus AC-RC-5 fallback" as the sole oscillator
architecture, we lose the option to add a Wien-bridge as a
TC anchor for the LED-twinkle clock. AC-CHOP-1 deserves at
least a short Stage-4 deep-dive to confirm its area / power
cost on GF180MCU.

**Settled by:** Stage-3 shortlist decision.

---

## Q-AC-14 -- Long-term ageing of poly resistors used as the RC reference

**Decision blocked by:** whether the 10 ppm long-term stability
in AC-RC-2 is reproducible on GF180MCU.

**Why this matters:** the LED-twinkle frequency is irrelevant
to long-term ageing (10 % drift over 10 years is fine for
twinkle), but the eFuse-stored NFC trim word *will* drift if
the poly resistor's value changes over time. The trim word
needs to be valid for the chip's full lifetime.

**Settled by:** reading the PDK reliability docs (GF180MCU
process is mature; ageing data should exist). ~2 hours.

---

## Headline open-questions (to flag for Stage 2 first)

| ID | Title | Settles whether... |
|---|---|---|
| Q-AC-1 | DLS gate-leakage on 5 V GF180MCU | AC-SUB-1 is in or out as the always-on timer. |
| Q-AC-3 | Sigma-delta cap-bank limit-cycle | AC-FLL-1 trim is clean or noisy. |
| Q-AC-4 | Carrier-comparator antenna loading | AC-FLL-4 area-amortisation actually works. |
| Q-AC-5 | TC-domain compensation in pure HDL | AC-FLL-2 is transferable to firmware-free chips. |
| Q-AC-6 | Brown-out behaviour swap-cap vs VAFB | Which AC-RC topology to deep-dive. |
| Q-AC-11 | Trim DAC: cap vs current | Architectural choice for trim mechanism. |

These six are the highest-value Stage-2 questions.
