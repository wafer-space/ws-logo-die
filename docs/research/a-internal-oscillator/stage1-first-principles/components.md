---
item: a
item_name: internal-oscillator
stage: 1
angle: first-principles
researcher: stage1-first-principles agent (parallel instance 1 of 3)
status: draft
last-updated: 2026-05-02
---

# Components — sub-blocks for the chosen-topology family

This file enumerates the sub-blocks that *any* family in
[`solutions.md`](./solutions.md) would need, organised so the same
block can be cross-referenced from multiple solution candidates. The
intent is that a downstream architect sizing the v2 chip can read this
file in isolation to estimate area and power without re-deriving the
hierarchy each time.

For each sub-block we record:

- Function — what it does
- GF180MCU implementation — which PDK device(s)
- Approximate cost (area / power)
- Which solution families need it

## Bias / reference sub-blocks

### Bias-001 — Vbe bandgap reference

Function: Generates a temperature-stable reference voltage (~1.2 V) by
summing a Vbe (CTAT) and a `n·V_T·ln(N)` (PTAT) term. This is the
canonical reference for any "precision" oscillator (B2, A2, A4, G1,
G2).

GF180MCU implementation: PNP devices (`pnp_05p00x05p00`,
`pnp_10p00x10p00`) are available; resistor pair from ppolyf_u_1k or
2k. The GF180 PDK does **not** include a pre-built bandgap IP block,
so this is a custom block.

Cost: ~6000 µm² active (two PNPs, three resistors, op-amp), 5–20 µA
quiescent. Settling time 50–500 µs from cold (the dominant
contributor to `rc-relax-stable`'s slow start-up).

Used by: A2, A4, B1, B2, B3, C2, G1, G2.

Note: PSRR of the bandgap is the *limiting* PSRR of the entire
oscillator if its reference is the dominant noise source. A
brown-out-prone harvested rail demands a bandgap with at least 60 dB
PSRR at low frequencies. Stock textbook bandgaps deliver 30–50 dB;
ours needs a cascoded current mirror in the output branch.

### Bias-002 — Beta-multiplier (constant-gm) bias

Function: Generates a current that produces a transistor `g_m`
inversely proportional to a single resistor R. Frequency-stable
when used to bias current-starved rings.

GF180MCU implementation: PMOS-NMOS mirror pair plus one resistor
(ppolyf_u_2k). Self-starting requires a startup pull-up
(`gf180mcu_fd_sc_mcu7t5v0__inv_4` works as the pull-up).

Cost: ~1000 µm² active, 1–5 µA quiescent. Start-up *much* faster
than bandgap (1–10 µs).

Used by: A2, A4, D1, D2, G1.

### Bias-003 — PTAT bias (sub-threshold)

Function: Current proportional to absolute temperature. Used as the
bias for sub-threshold oscillators where the goal is `f ∝ T`
(temperature sensing, D2) or as the PTAT half of a bandgap.

GF180MCU implementation: two NMOS in sub-threshold with a forced
size ratio, one resistor. Trivial.

Cost: ~200 µm², ~100 nA, 100 µs settle.

Used by: D1, D2, Bias-001.

## Oscillator-core sub-blocks

### Core-101 — Inverter chain (ring core)

Function: The actual ring of digital inverters that produces the
oscillation.

GF180MCU implementation: chains of `gf180mcu_fd_sc_mcu7t5v0__inv_2`
or `inv_4`, optionally current-starved by series PMOS/NMOS sized to
deliver the bias current. For frequencies above ~100 MHz, custom
inverters with smaller W/L than stdcell are preferable to reduce
self-loading.

Cost (per stage): 5–20 µm² stdcell; 10–50 fF input cap. A 7-stage
ring with starve transistors is ~150 µm².

Used by: A1, A2, A3, A4, A5, D1, E1, E2, G1, G2.

### Core-102 — Schmitt-trigger comparator

Function: Hysteretic comparator that triggers the relaxation
recharge phase. Hysteresis must exceed expected noise on the input
node and below the available signal swing.

GF180MCU implementation: 6-T Schmitt cell exists in
`gf180mcu_fd_sc_mcu7t5v0__schmitt*`. Hysteresis ~0.7 V at 5 V V_DD.
For analog Schmitt, a custom version with a capacitor-matched load
gives narrower hysteresis (~50 mV) at the cost of bias current.

Cost: ~50 µm² stdcell; 5–20 µA for the analog version.

Used by: A5, B1, B2, B3.

### Core-103 — Continuous-time comparator (precision)

Function: Compares the relaxation cap voltage against a divider
fraction of V_DD. Offset is the dominant accuracy limit.

GF180MCU implementation: differential pair (3.3 V or 6 V NMOS, your
choice — 6 V if input common-mode is high) with a current-mirror
load and a class-AB output stage. Auto-zeroing reduces offset from
~5 mV to ~0.5 mV at the cost of one extra clock-phase pair.

Cost: ~3000 µm², 5–20 µA.

Used by: B1, B2.

### Core-104 — Cap charging current source

Function: A fixed current charging the relaxation capacitor at a
known rate. Frequency = `I/(C·ΔV)`.

GF180MCU implementation: Cascoded PMOS (6 V) with the gate biased by
Bias-001 or Bias-002. Output impedance > 10 MΩ over the swing range.

Cost: ~500 µm², 1–10 µA.

Used by: B2, B3.

### Core-105 — Spiral inductor

Function: The L of an LC tank.

GF180MCU implementation: The PDK does **not** include a pre-built
inductor IP. Inductors must be hand-drawn as octagonal spirals on
the top metal pair (Metal4 + Metal5 for a 5-metal flow, or Metal3 +
Metal4 for the 4-metal Run 1 stack-up). Q at 2.4 GHz is bounded by
the metal sheet resistance and substrate loss; expect Q ≈ 8–12.

Cost: 100×100 µm² to 200×200 µm² for 1–5 nH; **conflicts with the
"top metal stays the wafer.space logo" hard constraint** unless the
inductor footprint is incorporated into the logo's design.

Used by: C1, C2, C4 (cap bank only — no on-die inductor).

### Core-106 — Bondwire inductor

Function: The L of an LC tank, formed by a pair of bondwires.

GF180MCU implementation: ~1 nH/mm of bondwire. A 2 nH inductor is
two 2 mm bondwires in parallel (one to V_DD, one to a common-mode
node). No silicon area — just a pad pair allocated.

Cost: 2 bond pads (~200 × 200 µm² each in the pad ring), zero core
silicon.

Used by: C4.

### Core-107 — PCB-loop inductor (off-die)

Function: The 4-turn 80×50 mm NFC PCB loop, ~1–4 µH at 13.56 MHz.

GF180MCU implementation: comes for free with the v2 PCB. Two bond
pads (already specified in item (b)) for the differential antenna
feed.

Cost: zero on-die.

Used by: C3 only.

### Core-108 — Cap bank with eFuse trim

Function: Tunable capacitance for tank tuning (LC) or RC trim
(relaxation). N-bit binary-weighted MIM caps, switched in via NMOS
switches gated by eFuse-stored bits.

GF180MCU implementation: `cap_mim_2f0fF` for ≤6V applications,
`cap_mim_1f0fF` for ≤20 V applications (the harvested rail can
exceed 5 V transiently; the 1.0 fF cap is safer there). Switches:
`mcu7t5v0__inv_4`-class FETs.

Cost (8-bit, 1 fF LSB to 256 fF FS): ~500 µm² for the caps,
~100 µm² for the switches, ~50 µm² for the eFuse readout latches.

Used by: A2, A4, B1, B2, C1, C3, C4.

## Lock / control-loop sub-blocks

### Loop-201 — FLL phase / frequency detector

Function: Compares the divided-down ring frequency against a slow
reference; produces an up/down or BBPD-style error signal.

GF180MCU implementation: digital phase-frequency detector
(D-flip-flop AND-gate skewed-edge structure), implementable in stdcell
once a gold-reference clock is available. Trivial.

Cost: ~200 µm² stdcell, leakage-only power when locked.

Used by: E1, G2.

### Loop-202 — Charge pump + integration cap (analog)

Function: PFD-output integrator. Smooths the up/down pulses into a
control voltage on a varactor.

GF180MCU implementation: matched current sources, MIM integration
cap (1 nF integrated cap is 500 × 1000 µm² at 2 fF/µm² — large but
feasible).

Cost: 1000–500 000 µm² depending on loop bandwidth, 1–10 µA.

Used by: E1 (analog version).

### Loop-203 — Digital integrator (DLF)

Function: Replaces the charge pump and analog cap with an N-bit
counter accumulating the PFD pulses. Output drives Core-108 cap
bank's switches via a thermometer or binary code. Vastly smaller
area and much more flexible than analog.

GF180MCU implementation: pure stdcell.

Cost: ~500 µm² for an 8-bit accumulator.

Used by: E1 (preferred), G2.

### Loop-204 — Injection coupling network

Function: Couples the carrier-band signal weakly into the ring core
to lock the ring's phase. A series 1–10 fF cap from the antenna
buffer to a ring node, plus a controlled-strength buffer, suffices.

GF180MCU implementation: small MIM cap + an inverter from the
antenna comparator.

Cost: <50 µm².

Used by: E2.

### Loop-205 — Carrier comparator / clock recovery

Function: Recovers a digital clock from the analog antenna signal at
13.56 MHz. A simple AC-coupled inverter with self-bias is enough at
NFC carrier amplitudes (>200 mV swing).

GF180MCU implementation: AC-coupled `inv_4`, one MIM cap (10 fF),
one bias resistor.

Cost: ~50 µm², ~1 µA.

Used by: E1, E2, E3.

## Power / supply-management sub-blocks

### Power-301 — Brown-out detector

Function: Asserts a "rail OK" signal when V_DD exceeds a programmable
threshold. Required to gate oscillator startup so the ring doesn't
free-run with a comparator that has no headroom.

GF180MCU implementation: divider from V_DD into a comparator against
the bandgap reference; ~10 mV hysteresis.

Cost: ~500 µm², 1 µA.

Used by: ALL families when running off the harvested rail.

### Power-302 — Linear regulator (LDO) for the oscillator core

Function: De-couples the oscillator from harvested-rail noise.
Required if PSRR of the oscillator topology itself is below ~30 dB.

GF180MCU implementation: PMOS pass with op-amp feedback to a Vbe
reference. Drop-out 100 mV; PSRR 60 dB at low frequency, 30 dB at
1 MHz.

Cost: ~5000 µm², 5 µA quiescent (ignore the load current — that's
the oscillator's own draw).

Used by: A2, A3, B1, B2, C1.

### Power-303 — Switched MOS-cap decoupling

Function: Adds local bypass to the oscillator's local rail. Less
effective than an LDO but free if the floor area is otherwise dead.

GF180MCU implementation: cap_nmos_06v0 (5 fF/µm² at the operating
voltage). 1 nF bypass = 200 × 1000 µm² — needs to fit somewhere
under the logo (item (e)'s territory).

Cost: pure area; zero quiescent power.

Used by: ALL.

### Power-304 — Voltage doubler / charge pump (for sub-threshold)

Function: Boosts a low harvested-rail voltage (e.g. 1.5 V from
ambient-RF mode) to a level where the oscillator core can operate.

GF180MCU implementation: Dickson 2-stage with MIM caps and
diode-connected NMOS. Output impedance is high; only useful for the
oscillator's bias networks, not for digital loads.

Cost: ~2000 µm², 100 nA standby, ramps slow (10 µs to settle).

Used by: D1 only when even the sub-threshold ring's V_DD floor is
below the harvested rail's worst case.

## Output / divider sub-blocks

### Out-401 — Frequency divider chain

Function: Divide the high-frequency core to consumer-rate clocks.
Standard ÷2 flip-flop chain.

GF180MCU implementation: `mcu7t5v0__dffq_2` chain. To divide
1 GHz → 1 kHz (LED PWM) needs ~20 stages.

Cost: ~500 µm², leakage-only when disabled.

Used by: ALL.

### Out-402 — Clock buffer / level shifter

Function: Drives the ring's small-amplitude output up to full V_DD
swing for the digital. Some topologies (LC, sub-threshold) have
small-signal swing.

GF180MCU implementation: chain of `inv_2` → `inv_4` → `inv_8` for
fanout. For sub-1V swing → 5V output, a self-biased CMOS inverter
chain works because the 6V devices have V_T ≈ 0.7 V.

Cost: ~100 µm², dynamic power scales with output frequency.

Used by: A1–A5, C1–C4, D1, D2.

### Out-403 — Domain-crossing level shifter (5 V → 3.3 V or vice
        versa)

Function: Bridges between the two power domains in item (i). The
oscillator may live in one domain and feed the other.

GF180MCU implementation: standard cross-coupled level shifter from
the 5 V → 3.3 V flavour. PDK has these in the IO library.

Cost: ~50 µm², leakage only.

Used by: ALL when crossing domains.

## eFuse / trim sub-blocks (depends on item (j))

### Trim-501 — eFuse readout latch

Function: Stores the eFuse-programmed trim word into volatile flops
on power-up, so the eFuses can be powered off during normal ops.

GF180MCU implementation: One latch per bit + a sense amplifier
(comparator at half-V_DD) per bit. Sequenced with the brown-out
detector.

Cost: ~50 µm² per bit.

Used by: A2, A4, B1, B2, C1, C3, C4, E1, G1, G2.

### Trim-502 — eFuse programming controller

Function: Generates the timing pulses required to blow an eFuse
during chip test. Out of scope for the oscillator block itself but
called out because the trim path is shared.

GF180MCU implementation: state machine clocked by the *internal*
oscillator (chicken-and-egg note: the oscillator must be functional
*before* trim is programmed, so the un-trimmed osc must be accurate
enough to generate the eFuse program pulse — typically 1–10 µs at
±20 % is fine).

Cost: ~200 µm² stdcell.

Used by: trim infrastructure (j), not the oscillator directly.

## Block-level totals for representative architectures

These are first-principles estimates aggregated from the per-block
costs above. Use as area/power budgets for solution candidates.

### Architecture α: "Minimum" — A1 alone

- A1 ring: ~150 µm², <1 µA
- Out-401 divider: ~500 µm²
- **Total: ~650 µm², <1 µA**

Inadequate for any block needing better than ±50 % accuracy.

### Architecture β: "Plausible" — G1 (A2 + B2 with brown-out)

- A2 ring (current-starved, 8-bit cap-bank trim): 800 µm², 5 µA
- Bias-002 (constant-gm): 1000 µm², 5 µA
- Trim-501 (8 bits): 400 µm²
- Power-301 (brown-out): 500 µm², 1 µA
- Out-401 + Out-402: 600 µm²
- **Total: ~3300 µm², ~11 µA**

Hits ±2 % trimmed, fast (<10 µs) start-up, brown-out aware.

### Architecture γ: "Best for this project" — G2 (β + NFC-locked
       FLL)

- All of β: 3300 µm², 11 µA
- Loop-205 (carrier comparator): 50 µm², 1 µA (only when NFC
  active)
- Loop-201 (PFD): 200 µm²
- Loop-203 (digital integrator): 500 µm²
- **Total: ~4050 µm², ~12 µA**

Hits ppm accuracy when NFC field is present; falls back to ±2 %
when not. The extra ~750 µm² over β is a very cheap upgrade for
the precision-when-locked feature.

### Architecture δ: "BLE-ready" — γ + LC tank for 2.4 GHz

- All of γ: 4050 µm², 12 µA
- C1 LC core (xcoupled NMOS): 500 µm² + Core-105 spiral
  (30 000 µm² — **logo conflict**), 1 mA when running
- Cap-bank for tuning (Core-108 ×8 bits with 50 fF LSB): ~500 µm²
- **Total: ~35 000 µm², ~1 mA when transmitting** (else 12 µA)

The 30 000 µm² spiral is the elephant in the room. Even though the
power is gated to TX bursts, the *area* is permanent. This is the
single biggest argument for the bondwire-tank C4 alternative when
BLE is finally attempted.
