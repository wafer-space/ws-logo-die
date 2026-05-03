---
item: c
item_name: qi-harvesting
stage: 1
angle: first-principles
researcher: agent-stage1-first-principles-c-qi-1
status: in-review
last-updated: 2026-05-03
---

## 1. Executive summary

This report addresses: how much DC power can the v2 chip
realistically extract from a Qi pad through the companion business-
card PCB's 8-turn 56 × 40 mm planar coil on layer L3, and what
on-die rectifier / regulator / protocol-participation architecture
makes that power usable. The work is conducted from first principles
— physics (Faraday, Ohm, energy conservation), the GF180MCU
`gf180mcuD` PDK device library, and a brief targeted check against
the published WPC Qi PC0 v1.2.3 specification (cached locally) to
verify protocol-timing values that cannot be derived from physics.

Headline conclusions:

1. **Available power is not the binding constraint.** Even at very
   poor coupling (`k = 0.05`), the open-circuit voltage on an 8-turn
   56 × 40 mm coil from a 5 W Qi BPP transmitter is tens of volts.
   Our load is µW–mW. The harvester is a power-throttling problem,
   not a power-availability problem.
2. **The dominant design problem is over-voltage / over-current
   protection** under loose-load conditions. A 5 W transmitter with
   a 0.5 mW load presents 4 orders of magnitude of mismatch. Without
   a shunt regulator or detuning mechanism the rectifier output will
   charge until something breaks.
3. **The Qi protocol forces power-off if no Signal Strength Packet
   arrives within `t_first ≤ 20 ms`** of a digital ping starting;
   the PTx removes the Power Signal within `t_terminate ≤ 28 ms`.
   Total ping window `t_ping = 65–70 ms`. A strictly non-compliant
   ("free-rider") receiver gets ~65–95 ms of power per ping cycle,
   then transmitter goes idle, then `t_restart = 500 ms` minimum
   before next ping. **Free-rider Qi is duty-cycled 19 % at best,
   not continuous.** This is the most important finding of the
   report — informal discussions characterise free-riding as
   continuous; it is not.
4. **At 100–205 kHz, synchronous active rectification is straight-
   forward on `gf180mcuD`.** Half-period 2.4–5 µs vs 36.8 ns at
   13.56 MHz (NFC). Comparator delays of 100 ns give ≤ 4 % dead-time
   loss at LF; the same delay at HF gives 270 % dead-time —
   physically impossible. Rectifier topology choice in (c) is not
   constrained by frequency in the way it is in (b).
5. **Five distinct rectifier+regulator topology families** are
   catalogued (passive PN bridge, native-NMOS bridge, cross-coupled
   self-driven active, voltage-doubler/Dickson, and hybrid passive+
   active start-up). **Two distinct protocol-participation
   architectures** — strict free-rider (D1) and minimum-compliance
   (D2 — just SSP) — are derived from the spec; D3/D4/D5 are full
   BPP/EPP/MPP compliance for completeness.
6. **NFC↔Qi architectural sharing is feasible only at the regulator
   + storage level.** Distinct rectifiers are required because the
   L2 NFC perimeter coil (4T 80×50 mm, ~13.56 MHz, ~1.4 µH) and the
   L3 Qi coil (8T 56×40 mm, ~140 kHz, ~6.2 µH) have ≈100× different
   impedances at their working frequencies and the resonant-cap
   sizes differ by 2100×. Downstream LDO and harvested-rail bulk-cap
   are wire-OR-able.
7. **Mutual coupling between the two PCB coils is non-trivial**
   (`k_NFC,Qi ≈ 0.3–0.7` because they share the card area with only
   ~0.27 mm separation). At 140 kHz the NFC coil looks near-shorted
   (`ωL_NFC ≈ 1.2 Ω`) and via mutual coupling severely loads the Qi
   coil unless an FET switch breaks that path during Qi mode.

## 2. Requirements as understood

- **R1.** Inductive harvester at Qi BPP/EPP frequencies (87–205 kHz
  per WPC Qi PC0 v1.2.3 §3.1.4).
- **R2.** Two-pin antenna feed to a single planar multi-turn PCB
  coil. Companion PCB freezes this as 8 turns, 56 × 40 mm, on
  `In2.Cu` (L3) of a 4-layer 1.6 mm FR4 stackup.
- **R3.** Output target: harvested-rail VDD ≈ 3.0–3.6 V (LED drivers
  + small logic).
- **R4.** No external passives. Resonance / tuning cap, rectifier,
  OV clamp, regulator, bulk storage cap all on-die.
- **R5.** µW–mW load. Worst-case sustained ≤ 30 mW.
- **R6.** Coexistence with NFC (item b, L2 80×50 mm 13.56 MHz coil)
  and 2.4 GHz IFA (item d) on same L3 layer.
- **R7.** Top-metal logo preserved.
- **R8.** Backwards-compatible: v1 die has no Qi pads; on v2 PCB
  the Qi coil's two terminals will be wire-bonded to currently-
  unused v1 pads.

## 3. Solution-space map

The Qi-harvester architecture decomposes into four orthogonal
dimensions: **A. resonance/tuning, B. rectifier topology,
C. post-rectifier regulation, D. protocol participation.**

### 3.1 Family A — coil tuning / resonance

- **A1. Series-resonant matching (canonical).** Single `C_s` on-die
  in series with coil; `C_s = 208 nF` for 6.2 µH at 140 kHz.
  **Infeasible on-die** — 139 mm² of MIM (chip is ~1 mm²).
  R4 violation. **The single largest forcing function in the
  architecture.**
- **A2. Off-resonant (untuned) coupling.** No on-die series cap.
  Rectifier sees the coil's open-circuit AC voltage `V_oc = ωMI_p`
  directly. No `Q_s` step-up. With 8 turns at typical Qi fields,
  `V_oc` is several volts.
- **A3. Parallel-resonant (tank) matching.** Same A1 cap problem —
  infeasible.
- **A4. Stagger-tuned dual resonance** — same cap problem; rejected
  by R4 plus geometric reality.
- **A5. Distributed self-resonance.** Coil's inter-turn parasitic
  capacitance falls in the 3–30 MHz range — far above Qi band.
- **A6. Receiver-side detuning as regulation.** Belongs in §3.3
  (C5).

### 3.2 Family B — rectifier topology

- **B1. Passive diode bridge.** PN junctions: Vf ≈ 0.6–0.4 V. Two
  diode drops/cycle = 0.8–1.2 V loss. Best fit: start-up.
- **B2. Diode-connected NMOS / PMOS, with native-NMOS option.**
  `nfet_06v0_nvt` (native NMOS, Vth ≈ 0.1 V or less). Diode-
  connected: Vf ≈ 0.1–0.2 V — **6× reduction in conduction loss vs
  PN-bridge** without any control logic.
- **B3. Synchronous active rectifier — cross-coupled self-driven.**
  Two cross-coupled NMOS pairs (or NMOS-low + PMOS-high). AC input
  itself provides gate drive. Loss dominated by `I²R_on`. R_on ≈ 1 Ω
  → 0.9 mW for 30 mA RMS — order of magnitude lower than B1.
- **B4. Voltage doubler / Dickson voltage multiplier.** Per-stage
  cap at 140 kHz: `C ≥ 71 nF` — infeasible on-die. (At 13.56 MHz
  the cap shrinks 200× to 0.74 nF.)
- **B5. Hybrid: passive bridge for start-up, active for steady-
  state.** Used in essentially every modern commercial Qi receiver
  IC.

### 3.3 Family C — post-rectifier regulation

- **C1. Linear LDO.** Series-pass PMOS or NMOS to 3.3 V. Iq 1–10 µA
  achievable. **Must be preceded by a shunt regulator** (every GF180
  5 V device breaks below 7 V Vds, but unregulated input can hit
  30 V).
- **C2. Switching buck.** ~1 µH on-die inductor needed; practically
  infeasible. Off-chip forbidden by R4. **Ruled out.**
- **C3. Shunt regulator.** Bandgap-referenced comparator driving a
  large NMOS shunt. **Required** for our problem. Worst-case 5 W
  BPP burst for 65 ms = 325 mJ per ping cycle.
- **C4. Switched-capacitor (SC) DC–DC converter.** Useful for
  integer-ratio conversion.
- **C5. Receiver-side detuning regulation.** Switchable on-die `C_s`
  bank that intentionally detunes the receiver. Energy is reflected,
  not dissipated.
- **C6. Charge-redirection regulator.** Excess current steered into
  LED storage cap, the LED itself, or a charge-storage MIM array.

### 3.4 Family D — protocol participation

**The most subtle dimension.** Per WPC PC0 v1.2.3 §5.1.2.2 the
receiver must send an SSP within `t_first ≤ 20 ms` of digital ping
start; otherwise the PTx terminates within `t_terminate ≤ 28 ms`.
Total ping window `t_ping = 65–70 ms`. Without an SSP, energy
delivery per ping cycle is bounded by:

`E_per_ping = P_tx × (t_ping + t_terminate) ≤ 5 W × 95 ms = 475 mJ`

Then `t_restart = 500 ms` before next ping. **Average power into a
non-compliant receiver is therefore at most 475 mJ / 500 ms =
0.95 W** — a 5× reduction vs nominal 5 W class rating.

- **D1. Strict free-rider** (no PTx-RX modulation at all). Fixed
  load impedance. Effective duty cycle ≤ 19 % (95 ms / 500 ms).
- **D2. Minimum-compliance "ping responder."** Implements SSP only.
  Best-case duty: 25 %. FOD risk increased.
- **D3. Full-compliance Qi 1.x BPP receiver.** Sustained 5 W BPP
  after handshake. ~5–20 kgates digital. **Absurd over-engineering
  for µW load** but the only way to guarantee multi-pad
  compatibility.
- **D4. Full-compliance Qi 2.x EPP receiver.** Out of scope —
  rejected.
- **D5. Qi 2.x MPP** (MagSafe-class, 360 kHz). Different operating
  frequency. Out of scope.

### 3.5 Over-voltage / shunt — central hard problem

Energy conservation: 5 W transmitter, 0.5 mW absorbing receiver →
5 W minus 0.5 mW of unwanted energy per ping cycle. Three fates:

1. **Reflect** (A6/C5): energy returned to transmitter coil. Best
   for our chip.
2. **Dissipate as heat** (C3): bounded by chip's thermal capacity.
3. **Self-protect by clamping**: Zener stack of diode-connected
   FETs. Always present as a backstop because (1) detune and (2)
   shunt control loops have finite response time.

**Open-circuit rail voltage** with no load and no shunt: per §5.2,
`V_oc = ωMI_p ≈ 30–80 V`. After full-bridge rectification → 42–112
V DC. **Every GF180 5 V device breaks below 6.5 V Vds.** Without a
clamp, the chip dies in the first ping.

### 3.6 Viable combinations for our requirements

Since A1/A3/A4 are infeasible by R4, all viable architectures use
A2 (off-resonant). Combined with the shunt-regulator imperative:

| # | A | B | C | D | Notes |
|---|---|---|---|---|---|
| FP-1 | A2 | B1 | C3+C1 | D1 | Simplest: PN bridge + Zener stack + LDO |
| FP-2 | A2 | B2(native) | C3+C1 | D1 | Native-NMOS diodes — 6× efficiency over (1) |
| FP-3 | A2 | B3 | C3+C5 | D1 | Active rectifier + detuning regulator; cool die |
| FP-4 | A2 | B5 | C3+C1+C6 | D2 | Hybrid bridge + charge-redirect to LEDs |
| FP-5 | A2 | B5 | C3+C1+C6 | D3 | Full Qi BPP compliance — over-engineered reference |

## 4. Sub-block breakdown

See [`components.md`](components.md).

## 5. First-principles sanity checks

### 5.1 Coil inductance estimate (8T 56 × 40 mm rectangular spiral)

Modified-Wheeler approximation: `L ≈ K_1 μ_0 n² d_avg / (1 + K_2 ρ)`
with K_1=2.34, K_2=2.75, n=8, d_avg=42.65 mm, ρ=0.109.

`L ≈ 2.34 × 1.2566×10⁻⁶ × 64 × 0.04265 / 1.300 = 6.18 µH ≈ 6.2 µH`

Cross-check vs Qi-class coil rule-of-thumb 5–20 µH. ✓

### 5.2 Open-circuit voltage `V_oc`

Faraday: `V_oc_pk = n × A × ω × B_pk`. n=8, A=2.24×10⁻³ m²,
ω=2π×140 kHz=8.80×10⁵ rad/s.

For B_pk = 2 mT_pk (representative Qi BPP at 5 W active-area
centre): `V_oc_pk = 31.5 V`.

For EPP (~5 mT_pk): `V_oc_pk = 78.7 V`.

This is the *open-circuit* voltage. Once a load draws current, the
coil's series resistance and rectifier on-state pull the rail down.
But unloaded rail genuinely exceeds device breakdown by 5–10×,
confirming §3.5's hard requirement for a clamp.

### 5.3 Available short-circuit current and power into our load

Coupling coefficient k between an 8T 56×40 mm receiver coil and a
typical Qi BPP "A1" primary (24 µH, 28 mm dia.) at 0–4 mm vertical
separation: published values for similar geometries put
`k = 0.20–0.45`. Take `k = 0.15` as middling.

`M = k √(L_p L_s) = 1.83 µH`

Reflected impedance `Z_refl = ω²M²/Z_s ≈ 0.0155 Ω` — tiny.
**Receiver is essentially invisible to the transmitter at low load**
— exactly the regime that makes free-riding work.

Induced EMF (RMS): `V_induced = ω M I_p = 8.05 V`

Power into load: `P_load ≈ 388 mW`. After rectifier loss (~36 mW)
and coil resistive loss (~5–10 mW): **net DC into storage cap ≈
350 mW** — 700× our µW load.

### 5.4 Synchronous-rectifier dead-time at 100–205 kHz vs 13.56 MHz

Half-period at 140 kHz: 3.57 µs. Half-period at 13.56 MHz: 36.8 ns.

For < 4 % dead-time:
- Qi (140 kHz): comparator delay ≤ 143 ns. **Trivially achievable**.
- NFC (13.56 MHz): comparator delay ≤ 1.5 ns. **Borderline-
  impossible**.

**Conclusion:** at LF, every aspect of synchronous rectification
is relaxed by 2 orders of magnitude vs HF. This is the principal
reason to choose B3 or B5 over a passive bridge for Qi.

### 5.5 FOD trip via power-loss accounting

Per WPC PC0 v1.2.3 §11.2: receiver reports `P_received` such that
`P_received - 350 mW ≤ P_PR ≤ P_received`. Threshold is
implementation-defined; industry-survey territory puts it at
150–500 mW for typical commercial pads.

For our µW-load free-rider:
- D1 (no `P_received` packet at all): transmitter cannot compute
  power loss; falls back to ping-timeout-only rejection.
- D2 lying with `P_received = 0`: instant FOD trip and 10 s
  blacklist.
- D2 truthful with `P_received ≈ P_tx_estimated − 100 mW`: physics
  permits this lie within the spec's 350 mW reporting tolerance.

**A receiver that absorbs < 350 mW and reports `P_received` within
+0/−350 mW spec tolerance is invisible to standard FOD.**

### 5.6 On-die capacitance feasibility

`gf180mcuD` MIM cap densities: 1.0 / 1.5 / 2.0 fF/µm².

**Resonant tuning cap (A1/A3):** `C = 1/(ω²L) = 208 nF`. Area at
1.5 fF/µm² = **139 mm²**. Chip is ~1 mm². **139× the chip.** A1/A3
infeasible.

**Bulk storage cap (rail filter):** holding µW load through 500 ms
ping-off at < 10 % droop:
- 1 mA load: `C = 1.67 µF` → 1.11 mm² — infeasible.
- 100 µA average load: `C = 167 nF` → 0.11 mm². **Feasible**.

### 5.7 PCB coil self-resonance

Inter-turn capacitance, FR4 εr ≈ 4.3, prepreg 0.1 mm, perimeter
~0.18 m, thickness 50 µm, pitch 0.6 mm:
`C_turn-pair ≈ 0.6 pF`. Total spiral parasitic 2–10 pF.

`f_SRF = 1/(2π√(6.2 µH × 5 pF)) ≈ 28 MHz` — far above Qi band.
Coil presents clean inductive impedance throughout 100–205 kHz. ✓

### 5.8 NFC↔Qi mutual coupling

L2 NFC perimeter (4T 80×50 mm) and L3 Qi (8T 56×40 mm), separated
~0.27 mm. Order-of-magnitude k via Neumann-formula scaling:
`k_NFC,Qi ≈ 0.3–0.7` — uncomfortably high.

At Qi frequency (140 kHz), NFC coil L_NFC ≈ 1.4 µH (Wheeler),
ωL_NFC = 1.23 Ω — **near-short**. Via mutual coupling severely
loads the Qi coil at LF unless deliberately broken.

Mitigations (open-question O5):
1. Series cap on NFC path that high-passes NFC away from LF (cap
   budget already exhausted).
2. FET switch on NFC path that opens during Qi mode (~1 Ω extra
   resistance during NFC mode).
3. Live with the loss; needs simulation to size.

### 5.9 Comparison with NFC harvester (b)

| Quantity | NFC (b) | Qi (c) | Ratio |
|---|---|---|---|
| Operating frequency | 13.56 MHz | 100–205 kHz | ~100× |
| Max transmitter power | 1–4 W | 5 W BPP / 15 W EPP | similar |
| Coil | 4T 80×50 mm, ~1.4 µH | 8T 56×40 mm, ~6.2 µH | 4.4× L |
| Resonant cap on-die | ~99 pF | ~208 nF | 2100× |
| Resonant cap area at 1.5 fF/µm² | ~0.07 mm² | ~139 mm² (infeasible) | 2100× |
| Half-period | 36.8 ns | 3.57 µs | 100× |
| Synchronous rectifier feasibility | Hard (B3 only) | Trivial | n/a |
| Open-circuit V at coil | ~30 V_pk close | 30–80 V_pk | comparable |
| FOD-equivalent in protocol | n/a | Power-loss accounting; 350 mW band | n/a |
| Sustained on-chip power | 1–10 mW typical | up to 350 mW (FOD-limited) | 30× |
| Architectural sharing point | Storage cap, LDO, load | same | downstream |
| Architectural divergence point | Rectifier (HF), tuning cap | LF — passive or active | upstream |

**Key sharing conclusion:** NFC and Qi rectifier outputs can be
wire-OR'd onto same shunt + LDO + storage cap **but the rectifiers
must be distinct.**

## 6. References

See [`references.md`](references.md). The WPC Qi PC0 v1.2.3a spec
PDF was fetched and pdftotext'd; cached locally at
`references-cache/wpc-qi-pc0-v1.2.3a/`.

## 7. Negative results

### NR1. On-die series-resonant tuning is impossible at Qi BPP

208 nF resonant cap requires ≈ 139 mm² of MIM. **Forces architecture
A2 (off-resonant)**, costing the `Q_s` voltage step-up.

### NR2. Qi `t_restart = 500 ms` strictly bounds free-rider duty cycle

Free-rider Qi has been informally characterised as "continuous"
power. **It is not.** Per §3.4 / §5 derivation, max duty cycle for
non-compliant receivers is ≈ 19 % (95 ms / 500 ms). Some pads use
longer inter-ping intervals (1–5 s) → 2–10 % duty.

### NR3. Switching buck regulator infeasible without external L

Post-rectifier regulation must be linear (LDO), shunt, or switched-
capacitor.

### NR4. Stagger-tuned dual-band coil sharing rejected

PCB has already committed two physically distinct coils.

### NR5. Voltage-doubler / Dickson is wrong tool at LF

Per-stage cap at 140 kHz is 71 nF for 1 mA load — infeasible.

### NR6. Qi 2.x EPP / MPP authentication tree is out-of-scope

EPP > 5 W requires WPC X.509 PUC authentication chain.

## 8. Open questions

See [`open-questions.md`](open-questions.md). 12 questions; top
priority: O1 actual primary-coil B-field magnitude; O2 coupling-
coefficient distribution over realistic placement; O3 quantitative
FOD trip threshold across vendor pads; O5 NFC-coil loading effect
on Qi at 140 kHz; O7 multi-coil free-positioning pad behaviour.

## 9. Comparison readiness

| Approach | Headline performance | Area / power cost | Maturity | Best fit for | Worst fit for |
|---|---|---|---|---|---|
| FP-1: A2+B1+C3+C1+D1 | ~350 mW pk during ping; ~95 mJ/cycle; 19 % duty | Smallest area | Trivial | Sub-mA µW loads; cold-start fall-back tier | Continuous tens-of-mA needs |
| FP-2: A2+B2(native)+C3+C1+D1 | Same delivery, ~6× lower rectifier loss | Slightly larger NMOS | Low-risk | µW–mW; LED twinkle | Cases where native Vth bound is uncertain |
| FP-3: A2+B3+C3+C5+D1 | ~400 mW into rail; cool die because regulation by reflection | Comparator + bandgap + cap-bank | Moderate | Production-quality free-rider | Ultra-low-area test chip |
| FP-4: A2+B5+C3+C1+C6+D2 | Same delivery as FP-3; +25 % duty thanks to SSP | + ASK modulator + ~3 kgates | Moderate | Mid-product, multi-charger | Tight size budgets |
| FP-5: A2+B5+C3+C1+C6+D3 | Continuous up to 350 mW (FOD-limited); full BPP compliance | Full Qi BPP modem + ~10 kgates | High effort | Reference platform | µW chip; over-engineering |

## 10. Author's notes

Two surprises:

1. **The 500 ms restart interval was the single biggest finding.**
   I assumed going in that "free-rider Qi gets continuous power,
   just wasted." Reading §5.1.2.2 of WPC PC0 v1.2.3 reveals that
   the transmitter actively shuts down within 28 ms of a missing
   SSP and waits 500+ ms before retrying. Radically changes
   storage-cap sizing and LED-twinkle timing for free-rider
   designs.
2. **The on-die capacitance ceiling rules out canonical resonant
   tuning entirely.** Every commercial Qi receiver IC datasheet
   shows a 100–250 nF series-resonance cap in the application
   schematic. Our no-external-passives constraint means we cannot
   do that at 140 kHz. The off-resonant architecture is therefore
   *forced* — and that's not a typical Qi receiver topology.
   Stage-2 must verify with the industry survey that off-resonant
   Qi receivers exist in the literature; if they don't, this is
   a novel design problem and risk goes up.
