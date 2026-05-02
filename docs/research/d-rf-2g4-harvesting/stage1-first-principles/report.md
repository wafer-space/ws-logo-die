---
item: d
item_name: rf-2g4-harvesting
stage: 1
angle: first-principles
researcher: claude-opus-4-7-1m — Stage-1 first-principles agent
status: draft
last-updated: 2026-05-03
---

## 1. Executive summary

This report derives, from RF physics and the GF180MCU PDK
constraints alone, the achievable behaviour of a single-pin
2.4 GHz ambient-RF harvester powering an LED on a credit-card-
sized PCB business card. The angle is deliberately first-
principles: brief literature anchors are cited only to confirm
physical-limit derivations are not absurdly off; the numerical
core is derived independently.

Headline results:

- **Friis-equation power available to a 2 dBi PCB IFA in front of
  a 100 mW EIRP Wi-Fi access point: 15 µW at 1 m, 0.6 µW at 5 m,
  0.15 µW at 10 m** (free-space, line-of-sight, lossless,
  polarization-matched — i.e. an upper bound). With realistic
  small-antenna gain (-3 dBi at 6 × 10 mm) the figure drops by a
  factor of ~3.
- A naïve "stack of `gf180mcuD` diode-connected NFETs" Dickson
  multiplier needs RF input swings of order 200 mV peak to reach
  1 V DC after ~10 stages with native-Vt devices, and is
  essentially non-functional below ~50 mV peak (-30 dBm raw,
  -16 dBm after a Q ≈ 5 matching network).
- Even at 100% rectifier efficiency, **the available DC power at
  5 m from a household AP (~0.6 µW antenna-terminal) is below
  what a deliberately-dim LED needs for a perceptible flash** (we
  derive 0.04–0.16 µJ per dim flash; replenishment time at
  realistic 0.01 µW DC at 5 m is ~16 s for a 1.6 µJ visible
  flash).
- At 1 m from a strong AP (15 µW received), with a 5–10%
  efficient rectifier, **a ~0.75–1.5 µW DC budget is feasible**.
  This is enough for visible but austere LED twinkle (~one
  1.6 µJ visible flash per 1–2 s, or many sub-microjoule dim
  flashes per second).
- **Honest verdict: "twinkle the LEDs from ambient Wi-Fi" is not
  achievable in arbitrary indoor conditions.** It is only
  achievable when the card is essentially co-located (≤1–2 m
  line-of-sight) with a continuously transmitting transmitter.
  The marketing-friendly framing should be relaxed to "if the
  card is held within ~1 m of an active Wi-Fi AP it may twinkle
  dimly".

The single-pin antenna constraint is workable if the bondwire is
short and ground-bonds are redundant, but is fragile: a 2 nH
bondwire at 2.45 GHz is 31 Ω of inductive reactance and dominates
rectifier-input impedance. This is a packaging requirement that
must be co-engineered with the PCB team.

## 2. Requirements as understood

From `TODO.md` section (d): "Scavenge enough µW from background
Wi-Fi / Bluetooth to run the LED drivers (only) when neither Qi
nor NFC is available."

Constraints inherited:

- **One bond pad** for the antenna feed; package + on-die return
  as ground reference (TODO §(d) bullet 2; PCB sub-project's
  `In2.Cu` IFA meander 6 × 10 mm).
- Process is **`gf180mcuD`** (GF 0.18 µm 5 V MCU, open-source
  PDK).
- Output drives **LED twinkle (item (f)) only** — not NFC core
  (h) or BLE PA (k).
- **No external passives** (TODO §"Hard cross-cutting
  constraints" #2).
- **Top metal stays the wafer.space logo** — limits area
  available for on-die spiral inductors used in matching.
- **Antenna shared with item (k) BLE** via on-die T/R muxing;
  harvest mode is default.

Implicit success metric: at least one *visually perceptible*
flash per second, sustained, when the card is in a *plausibly
typical* location relative to a 2.4 GHz transmitter. "A few
millivolts on a storage capacitor" is *not* visible LED twinkle.

## 3. Solution-space map

The architectural space factors into three orthogonal axes:
multiplier topology (§3.A), threshold-loss reduction (§3.B), and
matching/step-up network (§3.C).

### 3.A Multiplier / rectifier topologies

**3.A.1 `dickson-naive-nfet` — Naïve Dickson, diode-connected
NFETs.** Textbook charge pump; each stage is a diode-connected
NMOS plus coupling cap. Per-stage DC gain ≈ V_in_pk − V_th. With
standard Vth ≈ 0.5 V GF180 NMOS, fails below ~0.5 V input swing —
guaranteed inadequate at our power levels. Listed for
completeness as the spectrum's "simplest dumb" end.

**3.A.2 `dickson-native-nfet` — Dickson with native-Vt NMOS.**
GF180MCU provides native-Vt flavours (`nfet_06v0_nvt`,
`nfet_03v3_nvt`); PDK datasheet specifies VT0 = -0.32 V min /
-0.12 V typ / +0.08 V max for the 6 V native NMOS. Near zero,
slightly negative — depletion-like at typical corner. Effective
Vth at our currents (sub-µA) is ~0–100 mV; per-stage gain becomes
V_in_pk − ~100 mV. Penalty: high off-state leakage shorts stored
charge stage-to-stage. The classic "low-Vth helps turn-on, hurts
hold" tradeoff.

**3.A.3 `dickson-pmos-cross-coupled-differential` — Cross-coupled
differential rectifier.** Each "diode" is a CMOS pair gated by
the opposite-phase RF. Effective Vth → 0 at strong drive.
**Conflict with single-pin antenna constraint:** requires
differential feed or an external balun (forbidden) or an on-die
balun (=transformer, see 3.A.6). Mature in NFC; not directly
applicable here without the transformer wrap.

**3.A.4 `villard-half-wave` — Villard cascade (asymmetric).**
Alternating diodes between DC return and climbing rail. Lower
component count, slightly worse efficiency than full Dickson,
naturally fits single-ended drive.

**3.A.5 `dynamic-vth-cancellation` — DTMOS / aux-bias /
floating-gate.** Threshold cancelled by separately-generated
bias. Sub-flavours: (a) DTMOS body-tied gate — needs SOI or deep-
n-well isolation, GF180MCU bulk is unsuitable for the NMOS half.
(b) Aux-DC-bias chain (Kotani-style) — chicken-and-egg startup,
solved by a self-starting first stage. (c) Floating-gate trim —
needs OTP infrastructure (item (j) overlap), large effort,
marginal gain at this frequency.

**3.A.6 `transformer-coupled` / on-die-balun rectifier.** On-die
transformer steps up antenna voltage and provides differential
drive. At 2.45 GHz GF180 transformers have Q ~5–8, IL 1–3 dB,
voltage step-up 2–3×. Compatible with single-ended primary and
differential secondary. Solves §3.A.3's differential-feed problem
at ~0.06 mm² area cost.

### 3.B Threshold-loss-reduction techniques (combinable with §3.A)

- `vth-low` — use native-Vt (already in 3.A.2).
- `vth-aux-bias` — static gate bias = expected Vth.
- `vth-bootstrap` — cold-start naïve, warm-mode aux-biased.
- `body-tied-DTMOS` — see 3.A.5; bulk-CMOS limited.
- `floating-gate-trim` — OTP-programmed gate offset.

### 3.C Matching / step-up network options

- `match-LC-pi` — standard pi-network, on-die L 5–10 nH at
  Q 5–8, voltage gain ~4.5×.
- `match-LC-series` — single series-L plus shunt-C; simpler,
  lower Q.
- `match-transformer` — uses §3.A.6 transformer for both
  impedance match and voltage step-up.
- `match-bondwire-only` — uses bondwire's L as matching element.
  Cheap but uncontrolled (±20% L tolerance).
- `match-none` — direct connection. Loses 10–13 dB to mismatch;
  not a real option.

### 3.D Alternative architectural angles (rejected)

- `direct-thermoelectric` — RF-to-heat-to-thermopile.
  Catastrophic efficiency.
- `mechanical-resonator` — no MEMS in PDK.
- `sub-harmonic-rectifier` — interferer-tolerant but lower
  fundamental capture.
- `digital-injection-locked-rectifier` — power budget too tight
  for the active oscillator.

## 4. Sub-block breakdown

See [`components.md`](components.md).

## 5. First-principles sanity checks

### 5.1 Friis transmission equation

λ = c/f = (2.998 × 10⁸ m/s)/(2.45 × 10⁹ Hz) = **122.4 mm**.

Friis: P_rx/P_tx = G_tx · G_rx · (λ/4πd)²; in log form
P_rx[dBm] = P_tx[dBm] + G_tx[dBi] + G_rx[dBi] − 20log₁₀(4πd/λ).

For 100 mW EIRP AP (P_tx + G_tx = 20 dBm), G_rx = 2 dBi (textbook
IFA):

| d (m) | FSPL (dB) | P_rx (dBm) | P_rx (µW) |
|---:|---:|---:|---:|
| 0.10 | 20.23 | +1.77 | 1503 |
| 0.50 | 34.21 | -12.21 | 60.1 |
| 1.00 | 40.23 | -18.23 | 15.0 |
| 2.00 | 46.25 | -24.25 | 3.76 |
| 5.00 | 54.21 | -32.21 | 0.60 |
| 10.0 | 60.23 | -38.23 | 0.15 |
| 20.0 | 66.25 | -44.25 | 0.038 |

Power-density cross-check at 1 m from a 100 mW isotropic source:
S = P/(4πd²) = **7.96 mW/m² = 0.80 µW/cm²** — consistent with
literature anchor below.

Literature anchor (Pinuela 2013 IEEE TMTT, central London):
ambient density -60 to -14.5 dBm/m² (1 nW/m² to 35 µW/m²),
broadband-average ≈ 63 µW/m² across 680 MHz–3.5 GHz. With
G = +2 dBi, A_e = 18.9 cm², that gives ~1.2 nW total broadband
and ~0.1 nW within just the 2.4 GHz channel. **Conclusion:
ambient RF without a clearly-identifiable nearby AP is
essentially nil.** Our scheme depends on being close to *one
specific* transmitter, not on "ambient soup".

### 5.2 Effective aperture and Chu-Harrington limit

A_e = G·λ²/(4π).

Chu-Harrington limit on small antennas:
Q_min ≥ 1/(ka) + 1/(ka)³ where ka = 2π·a/λ. For a 10 mm IFA on a
50 × 80 mm card, ka ≈ 0.26, Q_min ≈ 60 — narrow bandwidth,
sensitive to detuning. Real-world gain of a 6 × 10 mm IFA on
this PCB is realistically **-3 to 0 dBi**, not 2 dBi.

### 5.3 Boltzmann noise floor

kT at T = 290 K = -174 dBm/Hz. kTB at B = 20 MHz Wi-Fi channel
= **-101 dBm = 80 fW**. Friis-derived signal at 5 m from 100 mW
AP is -32 dBm = **69 dB above kTB** — signal-rich, fine for
rectification. No "extract-from-thermal-noise" perpetual-motion
path is viable.

### 5.4 RF-to-DC efficiency lower bound

Empirical anchor (Awad et al., MDPI Sensors 2022, verified):
**peak η = 21.15% at 0 dBm (1 mW) input**, output 423 µW.
At -20 to -30 dBm η falls dramatically. Derived scaling
η ∝ P_in (sub-threshold-driven regime), anchored at the 21%
peak:

| P_in (dBm) | P_in (µW) | Realistic η | P_dc (µW) |
|---:|---:|---:|---:|
| 0 | 1000 | 20% | 200 |
| -10 | 100 | 10% | 10 |
| -20 | 10 | 5% | 0.5 |
| -30 | 1 | 1% | 0.01 |
| -40 | 0.1 | <0.1% | <1 nW |

### 5.5 LED visible-flash energy

| Current | Vf | Duration | Energy | Visibility |
|---:|---:|---:|---:|---|
| 0.5 mA | 1.6 V | 50 µs | 0.04 µJ | dim, dark only |
| 1.0 mA | 1.6 V | 100 µs | 0.16 µJ | dim, indoor |
| 1.0 mA | 1.6 V | 1 ms | 1.6 µJ | clearly visible |
| 5.0 mA | 2.0 V | 1 ms | 10 µJ | unmistakable |

Honest combined verdict at the Friis-derived P_rx values:

- **1 m, 100 mW AP, η=5%: P_dc ≈ 0.75 µW** → ~1 dim flash every
  2 ms or one 1.6 µJ visible flash every ~2 s. **OK, this is
  "twinkle".**
- **5 m, η=1%: P_dc ≈ 6 nW** → one 0.16 µJ flash per 27 s, one
  1.6 µJ flash per 270 s. **Not perceptible.**
- **10 m, η=0.1%: P_dc ≈ 0.15 nW** → flash per 1100 s.
  **Indistinguishable from broken.**

### 5.6 Storage cap charge time

E = ½CV² to 1.5 V: 1 nF → 1.125 nJ; 10 nF → 11.25 nJ.

First-flash latency at 5 m, 0.01 µW, 10 nF storage: **>1 second**
— uncomfortably slow.

### 5.7 Bondwire impedance at 2.45 GHz

Standard 1 nH/mm; 2 mm bondwire = 2 nH; |Z| = 2πfL = **30.8 Ω**.
With ±20% length tolerance, Z varies 25–37 Ω — comparable to the
source impedance. Single ground bond at 30 Ω is **not a low-
impedance ground**. **Multiple ground bonds distributed around
the antenna pad are mandatory.** Either budget the bondwire as a
known matching element, or parallel 4 wires for ~0.5 nH.

### 5.8 RF voltage at antenna terminal

V_pk = √(2·P·R) at matched 50 Ω.

| P_in (dBm) | V_pk @50Ω (mV) | After Q=5 step-up (mV) |
|---:|---:|---:|
| 0 | 316 | 1581 |
| -10 | 100 | 500 |
| -20 | 32 | 158 |
| -30 | 10 | 50 |
| -40 | 3.2 | 16 |

At -20 dBm with Q=5 we have ~158 mV peak at the rectifier —
usable by native-Vt NMOS. Below -30 dBm even with Q=5 we're at
~50 mV, where rectification efficiency collapses.

### 5.9 Antenna sharing with item (k) BLE — TR-switch isolation

In TX mode, item (k)'s PA puts up to 0 dBm (1 mW) on the antenna
pad — ~316 mV peak. Setting V_TX_leak < 1 V across the
harvester's gate-oxide requires **isolation X > 50 dB**. Series-
NFET switch alone gives ~20 dB; T-network + matched-network
detuning combo achieves ~50 dB at ~2 dB harvest-mode insertion
loss.

### 5.10 Self-emission / spurious response

The harvester is a **tuned receiver at 2.45 GHz**. Other on-chip
clocks produce harmonics that couple via PDN/substrate/re-
radiation:

- 25.175 MHz × 97 = 2441.97 MHz — within Wi-Fi channel 6.
- 13.56 MHz × 181 = 2454 MHz — also within Wi-Fi.

For a square-wave fundamental at ~100 mV pk on the PDN, the 97th
harmonic is ~40 dB below = ~1 mV pk — *larger* than what we're
trying to harvest at 5 m. **Implication: gate the harvester off
in VGA-active mode.**

## 6. References

See [`references.md`](references.md).

## 7. Negative results

1. **Naïve diode-connected NMOS Dickson cannot rectify at our
   ambient power levels.** Standard Vth ~0.5 V incompatible with
   sub-100 mV input swings even after Q=5 step-up at -30 dBm.
2. **DTMOS in pure bulk CMOS is not directly portable** —
   GF180MCU has no SOI; deep-n-well isolates PMOS-in-NWELL but
   not NMOS-in-PWELL.
3. **Single-bondwire antenna ground at 2.45 GHz fails physics.**
   30 Ω of inductive reactance is not a ground.
4. **A dedicated PCB balun for differential rectification is
   forbidden** by the no-external-passives rule.
5. **The 97th harmonic of the 25.175 MHz pixel clock falls in
   Wi-Fi channel 6.** Self-interference in VGA-active mode.
6. **At 5 m from a household AP the LED simply does not
   twinkle.** No rectifier topology recovers power that physics
   never delivers.

## 8. Open questions

See [`open-questions.md`](open-questions.md).

## 9. Comparison readiness

| Approach | Headline performance | Area / power cost | Maturity | Best fit for | Worst fit for |
|---|---|---|---|---|---|
| `dickson-naive-nfet` | Fails below ~0.5 V_pk_in | 0.005 mm², ~0 quiescent | Trivial | Strong-RF "tap on AP" demo | Anything sub-100 mV input |
| `dickson-native-nfet` | ~5–10% η at -20 dBm; 1–3% at -30 dBm | 0.005 mm² + 0.025 mm² caps | High in literature | Single-pin asymmetric drive at moderate Q | Sub-30 mV inputs |
| `dickson-pmos-cross-coupled-differential` | ~10–15% η at -20 dBm | 0.01 mm² | Mature in NFC | Differential-feed antennas | Single-pin (needs balun) |
| `villard-half-wave-native` | ~3–7% η at -20 dBm | Lowest area | Mature | Single-pin, lowest-area | Highest efficiency targets |
| `dynamic-vth-cancellation` (aux-bias) | ~10–20% η at -20 dBm | 0.02 mm² + bias quiescent | Published, complex | Best-effort efficiency | Cold-start without aux rail |
| `transformer-coupled` | ~12–18% η at -20 dBm | 0.06–0.10 mm² | Mature for RFID | Single-pin → on-die differential | Tight area budget |

Stage-2 question for synthesis: given Friis says "twinkle only
works close to a transmitter", does the project ship an honestly-
characterised harvester or formally relax the goal to "occasional
flashes when energy is plentiful"?

## 10. Author's notes

Produced *deliberately ignoring* the parallel academic and
industry surveys; reasoned from physics + GF180 PDK alone. Anchor
checks against literature (MDPI 2022, Pinuela 2013 IEEE TMTT,
GF180 PDK datasheet) only verify that physical-limit derivations
are not absurdly off. The numerical core (Friis, kTB, η ∝ P_in
scaling, charge-time arithmetic) is original to this report.

Process honesty flag: 2 of 6 web fetches failed (Imperial PDF
binary unreadable in transit; Wikipedia 403 first attempt —
succeeded on retry). The Pinuela 2013 numbers are from search-
result snippets, not the original PDF; flagged as "verification
incomplete" in `references.md`.

Dominant source of pessimism: **not** topology choice — it's the
Friis equation. No clever circuit recovers power that physics
never delivers. That is the load-bearing finding.
