---
item: b
item_name: nfc-harvesting
stage: 1
angle: first-principles
researcher: claude-opus-4-7-1m (auto-mode, parallel instance 1 of 3)
status: draft
last-updated: 2026-05-03
---

## 1. Executive summary

This report derives, from first principles, the genuinely-available
DC power at a regulated harvested rail given:

- A passive PCB-trace loop antenna of credit-card dimensions (the
  business-card PCB places a 4-turn 80 × 50 mm spiral on `In1.Cu`).
- Coupling to a typical phone NFC reader (ISO/IEC 14443-2 / NFC-A
  PCD).
- Rectification, clamping, and regulation entirely on a `gf180mcuD`
  die — i.e. **no Schottky devices**, only diode-connected MOS,
  MIM capacitance, and on-die NMOS/PMOS switches.

Headline conclusions:

1. **The Faraday-law upper bound on AC power induced in the PCB
   loop is several tens of mW for typical phone coupling, and
   easily reaches the 100s of mW class once the card is within
   ~10 mm of the reader and the resonance is deliberately tuned.**
   The available DC after rectifier, regulator, and clamp losses is
   therefore set by *circuit* losses, not by the field.
2. **In `gf180mcuD`, the realistic rectifier ceiling is ~50–60 %
   end-to-end** for a passive (diode-connected) full-bridge at low
   coupling, rising to ~75–85 % for a cross-coupled active
   rectifier in good coupling once start-up has bootstrapped the
   rail. The limiting factor is the absence of Schottky diodes —
   every passive stage costs at minimum one MOS Vth (~0.67 V at
   5-V flavour, or ~0.04 V at native flavour). Greinacher /
   cross-coupled / threshold-cancelled topologies trade that loss
   for area, complexity, or start-up risk.
3. **At ~10 mm phone coupling and a moderate antenna Q (~30),
   several mW of regulated DC at 1.8–3.3 V is plausible; at 0 mm
   (card-against-reader) the open-circuit Vpk on the antenna can
   exceed 30 V, so an active shunt clamp is mandatory** to protect
   the gate oxide of even the 5 V flavour.
4. **The on-die tuning capacitance to resonate the projected loop
   inductance (~1.6 µH) at 13.56 MHz is ~86 pF.** That is in the
   tens-of-thousands of µm² range at 1.5 fF/µm² MIM density — small
   compared to the available area, so the resonance tuning is not
   the binding constraint.
5. **Brown-out is the dominant operating-life behaviour, not steady
   state.** The rectifier loses regulation before the regulator
   does, because the rectifier's threshold-loss head margin is
   ~1.4 V (two diode drops) and cannot be eliminated without either
   an active gate-driven topology or a Greinacher pump giving
   voltage gain.

This report does **not** select an architecture. It enumerates the
solution space (eight rectifier families plus one hybrid, two
regulator topologies, two tuning architectures, two clamp
topologies, two brown-out detector topologies) and hands the
comparison off to Stage 2.

Search breadth: physics, the GF180MCU PDK device files (verified
locally at `gf180mcuD/libs.tech/ngspice/`), and a handful of
quickly-checked engineering references. This is the first-
principles angle — academic-survey and industry-survey instances
run in parallel and are expected to cover the literature
exhaustively.

## 2. Requirements as understood

| # | Requirement | Source |
|---|---|---|
| R1 | Rectify the 13.56 MHz HF magnetic field induced in a PCB loop antenna into a regulated rail. | `TODO.md` §(b) goal |
| R2 | Regulated rail must run NFC core (h) and LED drivers (f). NFC tag IC budget 50–300 µW. | `TODO.md` §(b)/(h) |
| R3 | At typical phone-NFC coupling (k ≈ 0.05–0.2), expect "several mW at close range." | `TODO.md` §(b) research bullet 1 |
| R4 | Differential PCB loop, on-die tuning cap, "few µH" loop inductance. | `TODO.md` §(b) research bullet 2 |
| R5 | No Schottky in `gf180mcuD`. Quantify Vth loss and active-rectifier merit. | `TODO.md` §(b) research bullet 3 |
| R6 | LDO holds ~3.3 V from rectifier swinging 3–10 V. | `TODO.md` §(b) research bullet 4 |
| R7 | At 0 mm vs strong reader, open-circuit Vpk can exceed 30 V — must clamp. | `TODO.md` §(b) research bullet 5 |
| R8 | All passives on-die. PCB loop is the only off-die inductor allowed. | Hard cross-cutting constraints |
| R9 | Two pads, differential antenna feed, in currently-unused analog slots. | `TODO.md` §(b) execute bullet 1 |
| R10 | Existing VGA pad ring frozen; NFC pads must be additions. | `TODO.md` constraint 3 |
| R11 | Tolerate (h) load modulation: 847.5 kHz subcarrier shorts antenna periodically. | `TODO.md` §(b) verify bullet 3 |
| R12 | Brown-out: rectifier-Vth loss and regulator drop-out are both first-order. | Project brief |

PDK ground truth (read directly from `sm141064.ngspice` /
`sm141064_mim.ngspice`):

- 5 V nFET nominal `vth0 ≈ 0.673 V` (BSIM
  `+vth0 = '0.67314+nfet_06v0_vth0'`).
- 5 V pFET nominal `vth0 ≈ −0.898 V`
  (`pfet_06v0_vth0 = '-0.8978 + ...'`).
- 5 V **native nFET** (zero-Vth) nominal `vth0 ≈ −0.039 V`
  (`nfet_06v0_nvt_vth0 = '-0.039 + ...'`). *Closest thing to a
  Schottky behaviour available in the PDK.*
- 3.3 V nFET `vth0 ≈ 0.66–0.75 V` (process-dependent).
- MIM caps available at 1.0 / 1.5 / 2.0 fF/µm² densities (M2-M3
  sandwich).
- Process Vmax = 5 V (abs-max ≈ 6 V); no higher-voltage analog
  flavour.

These PDK numbers are used throughout §5 (sanity checks) and are
the ground truth for every Vth-loss calculation.

## 3. Solution-space map

### 3.1 Rectifier topologies — 9 distinct entries (8 families + 1 hybrid)

#### 3.1.1 (R-A) Half-wave diode-connected MOS

Single diode-connected nFET, antenna single-ended-to-ground.
Vth-loss = 1·Vth ≈ 0.67 V (5 V flavour) or 0.04 V (native).

- Headline ceiling: total η ≤ 50 % (only one half-cycle).
- Use case: as the start-up seed for active-rectifier topologies.

#### 3.1.2 (R-B) Half-wave voltage-doubler (Villard)

DC-blocking series cap + diode-to-VDD + diode-to-GND. Output ≈
2·Vpk_ant − 2·Vth.

- Vth loss: 2·Vth = ~1.35 V (5 V) or ~0.08 V (native).
- Useful regime: low Vpk_ant brown-out.

#### 3.1.3 (R-C) Greinacher / Cockcroft-Walton multi-stage charge pump

Cascade of N×(series-cap + diode pair). Output ≈ 2N·Vpk_ant −
2N·Vth.

- Sweet spot: 2.4 GHz harvesting (Vpk_ant ≪ Vth). Wrong fit for
  13.56 MHz where Vpk_ant is several volts.
- Retained for brown-out edge.

#### 3.1.4 (R-D) Full-bridge passive rectifier

Two arms × two diode-connected MOS, antenna differential. Output ≈
Vpk_ant − 2·Vth.

- η_volt at Vpk_ant=3 V, 5-V Vth: (3 − 1.35)/3 = 55 %.
- η_volt at Vpk_ant=3 V, native Vth: (3 − 0.08)/3 = 97 %.
  **Native nFET as diode is the headline story.**

#### 3.1.5 (R-E) Cross-coupled gate-driven full bridge ("CMOS bridge")

NMOS (low) + PMOS (high) cross-connected to opposite-phase antenna.
Loss is conduction (Ron·I) plus reverse-conduction near zero-
crossing.

- η ≈ 75–85 % at Vpk_ant = 3 V.
- Start-up: bootstraps via body-diode conduction in tens of µs
  (must verify on GF180).

#### 3.1.6 (R-F) Cross-coupled active rectifier with comparator-driven gates

Adds Vds-sense comparators driving high-side gates. Eliminates
reverse conduction.

- η ≈ 90 %+; cost is comparator quiescent (tens of µA).
- 73 ns half-period — comparator must respond ≪ 73 ns. fT/100 ≈
  500 MHz needed; trivial on 0.18 µm fT≈50 GHz.

#### 3.1.7 (R-G) Active rectifier with charge-pumped gate bootstrap

Adds a small charge pump to drive PMOS gates above VDD. Extends
operation toward weak fields.

- Cost: extra start-up step plus pump caps.

#### 3.1.8 (R-H) Threshold-cancellation rectifier

Static / capacitively-coupled / floating-gate bias adds an
"anti-Vth" offset on each gate.

- Effective Vth ≈ 0.
- Cost: leakage hit from the bias arrangement; ~70–80 % typical.

#### 3.1.9 (R-I) Hybrid: active high-side, passive low-side ("half-active")

Compromise between R-D and R-F.

- η ≈ 70 %, 1·Vthn loss only, one comparator only, easy start-up.
  Useful risk-mitigated fallback for R-F.

#### 3.1.10 Considered and discarded

- Synchronous rectifier driven by on-die oscillator (a) — chicken-
  and-egg start-up.
- Class-D resonant self-rectifier — wrong loss-dominance regime at
  13.56 MHz.
- Mechanical / piezoelectric augmentation — out of scope.

### 3.2 Tuning network topologies — 2 distinct entries

#### 3.2.1 (T-A) Parallel tank (cap differentially across the loop)

`C_tune = 1 / (ω² L)`. For ω = 2π·13.56 MHz and L = 1.6 µH:
**C_tune ≈ 86 pF**.

- Q ceiling: PCB-loop AC resistance + MIM cap ESR.
  R_ac ≈ 1.5–2 Ω → Q_unloaded ≈ 50–80, Q_loaded ≈ 20–40.

#### 3.2.2 (T-B) Series-tuned (cap in series with the loop)

Current-source-like into the rectifier; useful for some active-
rectifier variants. Less natural for our voltage-mode bridges.

### 3.3 Voltage regulator topologies — 2 distinct entries

#### 3.3.1 (V-A) Series LDO (PMOS pass + bandgap + error amp)

Drop-out ≈ 0.4 V at 100 µA. PSRR at 27 MHz is poor (~−10 dB) —
relies on V_RECT smoothing cap.

#### 3.3.2 (V-B) Shunt regulator (diode-connected nFET stack)

V_REG = N·Vthn. No feedback loop. Wastes power at light load.

### 3.4 Over-voltage clamp topologies — 2 distinct entries

#### 3.4.1 (C-A) Static Zener-equivalent (stacked diode-connected MOS)

Always-on. Stack-leakage tax in the comfortable corner; tens of mW
dissipation in over-voltage.

#### 3.4.2 (C-B) Active-shunt clamp

Sense + comparator + large nFET shunt. Two-stage (C-A clamps at 6 V
hard, C-B trims at 4.5 V) is the realistic answer.

### 3.5 Brown-out detection — 2 distinct entries

#### 3.5.1 (B-A) Vth-referenced detector

Coarse, near-zero quiescent. First-stage enable.

#### 3.5.2 (B-B) Bandgap-referenced detector

Precise, sub-µA quiescent. Second-stage enable for the digital
domain.

## 4. Sub-block breakdown

See [`components.md`](components.md).

## 5. First-principles sanity checks

### 5.1 Faraday's law: induced voltage in the PCB loop

`V_induced(t) = -dΦ/dt = -μ₀·A·N·dH/dt`. For sinusoidal field:
`V_pk_induced = ω · μ₀ · A · N · H_pk`.

Parameters: N=4, A = 4×10⁻³ m², ω = 8.52×10⁷ rad/s,
μ₀ = 1.257×10⁻⁶ T·m/A.

ISO/IEC 14443-2 Hmin = 1.5 A/m, Hmax = 7.5 A/m (per widely-quoted
app-note consensus; see OQ-3).

- At Hmin = 1.5 A/m: V_pk_induced ≈ **2.57 V**.
- At Hmax = 7.5 A/m: V_pk_induced ≈ **12.85 V**.

These are open-circuit, **untuned**. With Q_loaded = 30 voltage
gain, V_pk_tank reaches 77 V at Hmin or 386 V at Hmax — physically
capped by clamp activation, but the calculation says the clamp must
be **always active**, even at compliance Hmin.

### 5.2 Inductance of the PCB loop

Mohan-modified-Wheeler for 80 × 50 mm, 4-turn rectangular spiral,
2 mm pitch:

- d_outer ≈ 80 mm, d_inner ≈ 64 mm, d_avg ≈ 72 mm.
- ρ = 0.111.
- L ≈ 2.34 · μ₀ · 16 · 0.072 / 1.305 ≈ **2.6 µH** (square-spiral
  approximation).

A non-square correction lands the estimate at **L ≈ 1.5–2.5 µH**.
Working number: L = 1.6 µH (chosen to give a round-number tuning
cap; ±30 % uncertainty must be absorbed by the switched-cap bank).

### 5.3 PCB-loop AC resistance and unloaded Q

Skin depth at 13.56 MHz in copper: `δ ≈ 17.7 µm`.

For 0.5 mm × 35 µm trace, total length ~1.04 m: R_dc ≈ 1 Ω. Skin
effect ~1× (since δ ≈ t/2). Proximity effect ~1.5–2×:
**R_ac ≈ 1.5–2 Ω**.

`Q_0 = ω·L/R_ac ≈ 68`. Loaded Q with rectifier+regulator (~few-kΩ
load): **Q_loaded ≈ 20–40**.

### 5.4 Tuning cap value

`C_tune = 1 / (ω²·L) = 1 / (7.26e15 · 1.6e-6) ≈ 86 pF`.

At 1.5 fF/µm² MIM: A_MIM ≈ 57,300 µm² (~240 µm square). At
2.0 fF/µm²: ~43,000 µm². Switched bank covering ±30 %: 6× = under
1 mm². **Tuning capacitance is not an area constraint.**

Switch Ron requirement per segment: Ron ≪ 1/(ωC_segment). For
LSB = 1.5 pF: Ron ≪ 7.8 kΩ — easy.

### 5.5 V_RECT smoothing cap

Ripple frequency = 27.12 MHz (full-bridge doubles). Budget:
ΔV < 100 mV at I_load = 5 mA peak.

`C ≥ I_load / (2π·f_ripple·ΔV) ≈ 0.29 nF`. Round up to **1 nF**
(~670,000 µm² ≈ 0.67 mm² MIM).

### 5.6 0 mm coupling — the over-voltage corner

H_pk at tag ≤ 7.5 A/m (ISO Hmax). V_pk_open ≤ 12.85 V. With
Q_loaded = 30 and no clamp, V_pk_tank ≈ 386 V — process-fatal.

The clamp must dissipate ~100s of mW continuously to keep V_RECT
below ~6 V abs-max. **Two-stage clamp required**: passive C-A at
6 V (hard limit) + active C-B at 4.5 V (efficiency at moderate
fields).

### 5.7 V_REG smoothing cap during 847.5 kHz load modulation

Modulator shorts antenna for ~1 µs per subcarrier half-cycle. With
I_load = 300 µA and droop ΔV = 50 mV:

`C_REG ≥ I·Δt/ΔV = 6 nF`.

At 1.5 fF/µm²: **4 mm² of MIM**. **This is the binding area
constraint of the design** (not the tuning cap). Item (e) MIM-cap
research must confirm fit under the logo.

### 5.8 Power transfer from reader to tag

Phone-class reader: P_reader ≈ 0.5–2 W. Coupling: k ≈ 0.05–0.2
typical phone-tap, up to 0.3+ at 0 mm.

Working point (P_reader = 1 W, k = 0.15, η_match = 0.7):
- `P_coupled ≈ k²·P_reader·η_match ≈ 16 mW`.
- With η_rect = 60 % (passive bridge native nFET) and η_LDO = 80 %:
  `P_DC_avail ≈ 7.7 mW`.

Marginal corner (k = 0.05): `P_DC_avail ≈ 0.84 mW`. Still
comfortably above 50–300 µW NFC core budget; tight if LEDs also
draw a few mA peak.

### 5.9 Rectifier η in `gf180mcuD` units

`η_rect ≈ (Vpk_ant − 2·Vth)/Vpk_ant · η_cond`. η_cond ≈ 0.9 typical.

| Topology | Vth source | Vpk_ant=3 V | Vpk_ant=5 V |
|---|---|---|---|
| R-D | 5 V flavour, Vth=0.673 V | **50 %** | 66 % |
| R-D | native, Vth=0.04 V | **88 %** | 92 % |
| R-E | none (Ron only) | ~85 % | ~85 % |
| R-F | none + comp loss | ~90 % | ~90 % |

**Native nFET as the diode element is the single most important
PDK-leverage decision in this subsystem.**

### 5.10 Vendor "tens of mW" claims diverge from ours

Vendor app notes assume desktop readers (5 W), near-perfect
coupling (k ≈ 0.3), and Schottky η ~85 %. We have phone class
(1 W), realistic phone coupling (k ≈ 0.05–0.15), and GF180 native-
nFET ~88 % or 5-V-Vth ~50 %.

**Realistic GF180 phone-tap range: 0.8–10 mW DC.**

### 5.11 fT / bandwidth feasibility

GF180 fT ≈ 50 GHz. Carrier at 13.56 MHz = fT/4000; comparator
~30 ns ≈ fT/100. **No topology rejected on fT grounds.**

### 5.12 Brown-out boundary derivation

V_REG_min = 1.8 V (lowest sensible digital rail). LDO drop-out =
0.4 V → V_RECT_min = 2.2 V.

- (R-D-native): Vpk_ant_min = 2.2 + 0.08 = **2.28 V** ← below
  Hmin V_pk_induced = 2.57 V. ✓ works at compliance Hmin.
- (R-D-5V): Vpk_ant_min = 2.2 + 1.35 = **3.55 V** ← above Hmin
  V_pk_induced = 2.57 V. ✗ fails at compliance Hmin.

**This is the strongest first-principles argument for native-nFET
rectification.** It is the difference between "works at 1.5 A/m
compliance" and "doesn't."

## 6. References

See [`references.md`](references.md).

## 7. Negative results

- **NR-1:** Half-wave rectification (R-A) is unusable as a stand-
  alone harvester at our power budget. Retained only as start-up
  seed.
- **NR-2:** Greinacher / CW (R-C) is a worse fit at 13.56 MHz than
  2.4 GHz — wastes 2N·Vth without need for voltage gain.
- **NR-3:** Schottky-bridge architectures from the literature do
  not port: no Schottky in `gf180mcuD`. Native nFET is the
  substitute.
- **NR-4:** Passive rectifier with no clamp fails at 0 mm coupling.
  ESD-diodes-only protection is unacceptable.
- **NR-5:** Switched-cap LDO directly fed from the rectifier —
  start-up chicken-and-egg.
- **NR-6:** "Just use ESD diodes for the rectifier" — pad ESD
  diodes are sized for one-shot events, not steady state.
- **NR-7:** Single-ended antenna feed — drops common-mode
  rejection; differential is the right call.

## 8. Open questions

See [`open-questions.md`](open-questions.md).

## 9. Comparison readiness

| Approach | η at Vpk_ant=3V | Vth-loss in `gf180mcuD` | Quiescent overhead | Start-up | Best fit | Worst fit |
|---|---|---|---|---|---|---|
| R-A (half-wave) | ≤ 50 % | 1·Vth | none | trivial | start-up seed | primary harvest |
| R-B (Villard) | ≤ 50–55 % | 2·Vth | none | trivial | low-Vpk_ant brown-out | high-power steady state |
| R-C (Greinacher) | per-stage formula | 2N·Vth | none | trivial | sub-V Vpk_ant (2.4 GHz) | NFC steady state |
| R-D (passive bridge) | 50 % (5V) / 88 % (native) | 2·Vth | none | trivial | simple, robust | low-Vpk_ant edges |
| R-E (cross-coupled) | 75–85 % | none (Ron only) | none | body-diode bootstrap | mid power | very low Vpk_ant |
| R-F (active comparator) | 90 %+ | none | tens of µA per comparator | needs aux supply | high-eff steady state | sub-mW total |
| R-G (bootstrap) | 85–90 % at low Vpk | none | small charge pump | extra start-up | low-Vpk edge | strong field |
| R-H (Vth-cancellation) | 70–80 % | "zero" (subject to leakage) | leakage hit | varies | brown-out edge | mid-to-high power |
| R-I (half-active) | ~70 % | 1·Vthn | one comparator | easy | risk-mitigated R-F | high-eff peak |

## 10. Author's notes

Surprises:

1. **Native nFET (`nfet_06v0_nvt`) recovers most of the Schottky-η
   story for free.** Passive bridge with native nFETs is competitive
   with active comparator-driven bridges at our power level — and
   far simpler.
2. **The binding area constraint is the V_REG smoothing cap (~4 mm²
   MIM at 1.5 fF/µm²) — not the tuning cap (~57k µm²).** Take this
   number to item (e).
3. **Active-rectifier comparator quiescent isn't free.** At marginal
   coupling P_DC ≈ 800 µW, a 30 µA comparator = 100 µW = 12 % of
   the budget. The naive intuition "active rectifier always wins"
   is wrong here.
