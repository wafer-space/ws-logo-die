---
item: k
item_name: aspirational-ble
stage: 1
angle: first-principles
researcher: claude-opus-4-7-stage1-fp-instance-1of3
status: draft
last-updated: 2026-05-03
---

## 1. Executive summary

This report addresses whether and how a low-power Bluetooth Low
Energy (BLE) advertising-only transmitter can be integrated on the
`ws-logo-die` v2 chip, in `gf180mcuD` 180 nm CMOS, sharing the
business-card PCB's 6 × 10 mm 2.4 GHz IFA antenna with the (d)
ambient RF harvester. The work is gated on (a)–(j) shipping; the
*research* must inform the v2 floorplan today.

The search was performed almost entirely from physical and
information-theoretic first principles, using only the `gf180mcuD`
ngspice model card for device specs, the Bluetooth Core 5.x
advertising-channel PHY definitions for packet and spectral mask
numbers, and Friis / Hajimiri-Lee / Cripps for radio-link and PA
expressions.

**Headline conclusions** (deliberately stated without
down-selection):

1. **Friis says the PA is small.** A phone receiver with −90 dBm
   sensitivity at 1 m, behind a −3 dBi IFA and 10 dB fade margin,
   needs only 0.21 µW (−37 dBm) at the antenna. At 5 m the same
   budget needs 5.2 µW (−23 dBm). **Driving a sub-0 dBm PA is
   comfortably inside what 180 nm can do.**
2. **Transistors are fast enough.** `nfet_03v3` at L = 0.28 µm has
   fT ≈ 41 GHz at Vov = 0.5 V (≈17× the carrier); `nfet_06v0` at
   L = 0.7 µm gives fT ≈ 13 GHz (≈5×). The 6 V PA stage is just in
   spec, the 3 V signal-path is comfortably clear. PMOS is slow
   (fT ≈ 7–12 GHz) — keep PA NMOS-only.
3. **GFSK is constant-envelope, so high-η switching PAs apply.**
   Class E ≈ 60 % drain efficiency is realistic; Class F 65 %;
   Class C 55 %. Class A is unnecessarily wasteful for adverts.
4. **The PA is *not* the bottleneck — the synthesiser is.** A
   2.4 GHz PA delivering 0 dBm at 60 % drain efficiency burns
   ≈1.7 mW DC. A 180 nm integer-N PLL plus a divide-by-2 final
   stage typically burns 3–5 mW. Add modulator and buffer: total
   radio current ≈6–7 mW peak. **Synthesiser power dominates total
   event energy by ~1.8× over the PA in 180 nm**, declining to
   ~1× at 28 nm where digital-PLL synthesis costs much less.

   > **Correction 2026-05-04** (reviewer-1): the prior version
   > of this point said "~3× over the PA". The §5.5 table this
   > headline summarises actually shows 1.7 mW PA + 3.0 mW synth
   > = 4.7 mW total radio with 1.76× ratio (synth/PA), not 3×.
   > The industry-survey honestly reports ≈ 2× (commit-time
   > self-correction), and academic-survey Sano-2018 anchor in
   > 28 nm gives parity. Updated to "~1.8× in 180 nm, ~1× in
   > 28 nm".
5. **A free-running ring DCO will *not* meet the BLE adjacent-
   channel mask** (≥−20 dBc at ±2 MHz). A free-running 2.4 GHz
   ring osc has typical SSB phase noise ≈−80 dBc/Hz at 1 MHz; the
   spec requires roughly −90 dBc/Hz integrated. A locked loop is
   mandatory.
6. **Harvested-rail verdict.** Best-case (d) ambient harvester at
   1 µW/cm² delivers **at most ≈3 µW DC** through a 6 cm² effective
   area IFA after rectifier loss. That **caps the sustainable BLE
   advert rate at ≈1 advert per 10–60 s** depending on PA-topology
   choice and synth sleep behaviour. **NFC (b) and Qi (c) harvested
   rails carry vastly more power (mW class) and do support
   continuous BLE advertising at 100 ms interval.** The
   *aspirational* nature of (k) is correctly identified: ambient-
   only operation is impossible at honest BLE intervals, but Qi-
   pad / NFC-reader operation is plausible.
7. **TR switch is achievable.** A series 5 V NMOS in 180 nm gives
   R_on ≈ 3–10 Ω and Coff ≈ 50 fF, yielding ≈28 dB isolation at
   2.4 GHz unaided.
8. **Storage cap is the dominating area cost.** Sustaining a
   1.5 ms /10 µJ advert burst across a 3.3 V → 2.5 V droop demands
   ≈4 µF. At gf180mcuD MIM density 2 fF/µm² that is **≈500 mm² of
   die per µF**, i.e. ≈2000 mm² of dedicated MIM-cap. **The chip
   is not even close to big enough — the burst storage cap alone
   exceeds the die area by ~900×.**

   > **Correction 2026-05-04** (reviewer-1 finding): the prior
   > version of this point quoted "≈2 mm² of die per µF" and
   > "≈8 mm² of dedicated MIM-cap". Those numbers were 1000×
   > too small (treating µF as 10⁶ fF when correct is 10⁹ fF).
   > The qualitative verdict is unchanged ("the chip is not big
   > enough") but the magnitude is dramatically larger; this
   > argument applies regardless of architectural choices and
   > therefore strengthens the (k) infeasibility verdict.

## 2. Requirements as understood

| Requirement | Source |
|---|---|
| BLE 4.x non-connectable advertising packet, 47 byte max PDU, 1 Mbps GFSK, 250 kHz deviation, ≥20 ms advert interval | Bluetooth Core 5.x §B.2.1.2; TODO.md §(k) |
| TX-only is acceptable; minimal RX (scan-response) optional | TODO.md L640–L644 |
| Process: `gf180mcuD` 180 nm 5 V CMOS | PDK file `sm141064.ngspice` |
| Antenna: PCB IFA on `In2.Cu`, 6 × 10 mm meander | TODO.md L42 |
| Antenna shared with (d) ambient RF harvester via on-die TR switch | TODO.md L52, L676 |
| Harvested-rail-only operation; no battery, no external regulator/cap | TODO.md L26–L29 |
| ISM-band conducted-emission cleanliness; PSD limits respected | TODO.md L682 |
| BLE 5 resolvable random addresses optional | TODO.md L679 |
| Top-metal logo must remain visually dominant | TODO.md L60 |

## 3. Solution-space map

(See `solutions.md` for the full enumeration. Summary follows.)

PA topologies enumerated: A1 Class A, A2 Class AB, A3 Class B, A4
Class C, A5 Class D voltage-mode, A6 Class E, A7 Class F /
inverse F, A8 inverse Class D, A9 digital polar / segmented
switching, A10 cascode A/B with stacked devices.

Synthesiser topologies enumerated: S1 integer-N PLL, S2
fractional-N PLL, S3 free-running ring DCO, S4 ring + FLL, S5
LC-VCO + integer-N PLL (default candidate), S6 injection-locked
from LC sub-harmonic, S7 ADPLL (rejected on area in 180 nm), S8
BAW/FBAR-referenced (rejected: not in PDK).

TR-switch topologies enumerated: T1 series NMOS, T2 series-shunt,
T3 stacked series, T4 lumped LC SPDT, T5 λ/4 + shunt (rejected —
not on-die feasible at 2.4 GHz), T6 CMOS pass-gate (rejected —
PMOS too slow).

Modulator paths: M1 two-point, M2 closed-loop, M3 open-loop post-
lock, M4 ADPLL frequency-word direct.

TX architecture: R0 TX-only, R1 TX + SCAN_RSP, R2 full peripheral
(rejected on power).

Crypto/privacy: P1 static public, P2 static random, P3 RPA
(rejected).

Antenna sharing: N1 hard time-mux via TR switch (default), N2
frequency-domain split (rejected), N3 diplexer, N4 two PCB
antennas (rejected — PCB constraint).

## 4. Sub-block breakdown

(See [`components.md`](components.md).)

## 5. First-principles sanity checks

### 5.1 Friis link budget

Pr = Pt · Gt · Gr · (λ/4πd)². At f = 2.44 GHz, λ = 0.123 m. At 1 m:
(λ/4πd)² = 9.57e−5.

Required Pr at phone = sensitivity + fade margin = −90 dBm + 10 dB
= −80 dBm = 1e−11 W. With Gt = −3 dBi (small IFA), Gr = 0 dBi:

  Pt = 1e−11 / (0.5·1·9.57e−5) = **0.21 µW = −36.8 dBm**.

At 5 m: Pt = 5.2 µW = −22.8 dBm. At 10 m: 21 µW = −16.8 dBm.

**Conclusion: PA output target = −10 to 0 dBm.**

### 5.2 fT for `gf180mcuD` devices

Long-channel: fT ≈ μ·Vov / (2π·L²).

| Device | L (µm) | Vov (V) | μ (m²/V·s) | fT (GHz) |
|---|---|---|---|---|
| nfet_03v3 | 0.28 | 0.5 | 0.04 | **40.6** |
| nfet_03v3 | 0.28 | 1.0 | 0.04 | 81 |
| nfet_06v0 | 0.70 | 1.0 | 0.04 | **13.0** |
| nfet_06v0 | 0.70 | 2.0 | 0.04 | 26 |
| pfet_03v3 | 0.28 | 0.5 | 0.012 | 12 |
| pfet_06v0 | 0.50 | 1.0 | 0.012 | 7.6 |

**Verdict.** At 2.4 GHz, fT/f ≈ 17× for nfet_03v3 → comfortable.
fT/f ≈ 5× for nfet_06v0 → marginal but usable as PA output device.
PMOS too slow for 2.4 GHz signal path.

### 5.3 Current density / electromigration

PA at 0 dBm into 50 Ω: V_pk = 0.316 V_pk; I_pk = 6.3 mA_pk =
4.5 mA_rms. Metal4 EM rule ≈1 mA/µm: 5 µm wire — trivial. Active
device: nfet_06v0 ID_sat ≈ 300 µA/µm at Vgs = 5 V → W = 20 µm.

### 5.4 BLE adjacent-channel mask vs free-running ring

BLE Core 5.x §3.3: power in 1 MHz BW at ±2 MHz from carrier ≤
−20 dBc; at ±3 MHz ≤ −40 dBc.

Required SSB phase noise (with safety) = −20 dBc − 10·log₁₀(1 MHz)
= **−80 dBc/Hz at 2 MHz**, plus margin → **−90 dBc/Hz target**.

Free-running 2.4 GHz ring osc (Hajimiri-Lee, Q ≈ 1, P_dc =
1.5 mW): L(1 MHz) ≈ −75 dBc/Hz. **Misses by ≈10 dB after margin.**

LC-VCO with Q = 10 at 2.4 GHz: L(1 MHz) ≈ −115 to −125 dBc/Hz →
trivially compliant.

### 5.5 Energy per advert event

3-channel advert (max payload):
- 47 B × 8 / 1 Mbps = 376 µs per packet.
- 3 packets + 2 × 150 µs channel switch = ≈ **1.43 ms on-air**.
- Plus per-channel PLL relock 3 × 30 µs = 90 µs.
- Plus initial PLL startup ~100 µs.

P_RF total at 0 dBm output:

| Block | mW |
|---|---|
| PA (Class E, η_practical = 60 %) | 1.7 |
| LC-VCO + buffer | 2.0 |
| PFD/CP/divider/loop filter | 1.0 |
| Modulator + GFSK shaper | 0.3 |
| TR switch driver | 0.1 |
| **Sum** | **5.1** |

E_event = 6.5 mW × 1.5 ms ≈ **10 µJ per 3-channel advert event**.
Single-channel: ≈3.5 µJ.

### 5.6 Average power vs advert interval

| Advert interval | Avg P, 3-ch (µW) | Avg P, 1-ch (µW) |
|---|---|---|
| 20 ms (BLE 4 minimum) | 538 | 180 |
| 100 ms (typical) | 108 | 36 |
| 1 s | 10.8 | 3.6 |
| 10 s | 1.08 | 0.36 |
| 60 s | 0.18 | 0.06 |

### 5.7 Storage cap requirements

E = ½ C (V₁² − V₂²); 3.3 V → 2.5 V droop.

| Burst E | Required C | Area at MIM-2.0 (corrected) |
|---|---|---|
| 1 µJ | 0.43 µF | **215 mm²** |
| 5 µJ | 2.16 µF | **1080 mm²** |
| 10 µJ | 4.31 µF | **2155 mm²** |

At MIM density 2 fF/µm²: 1 µF = **500 mm²**; 4.3 µF = **2155 mm²**.

**Pessimism required.** ws-logo-die v2 die is ≤2.25 mm² total.
Even a single-channel 1-packet burst (3.5 µJ → 1.5 µF →
**~750 mm²**) exceeds the die by ≈330×.

> **Correction 2026-05-04** (reviewer-1 finding): the table
> previously gave 0.5 mm² / 8.6 mm² / 3 mm² respectively — all
> 1000× too small (µF treated as 10⁶ fF; correct is 10⁹ fF).
> The architectural conclusion ("die not big enough") survives
> and is dramatically reinforced.

### 5.8 Harvested-rail capability vs BLE demand

A_eff = G·λ²/(4π) = 0.5 · 0.123² / (4π) = **6.0 cm²**.

Ambient flux S ∈ [0.1, 10] µW/cm² → P_RF ∈ [0.6, 60] µW
intercepted. After 2.4 GHz Dickson rectifier η ≈ 30–50 %:
P_DC ∈ [0.2, 30] µW.

Sustainable advert rate = P_DC / E_event_3ch:

| P_DC | Rate | Equivalent advert period |
|---|---|---|
| 0.2 µW (worst) | 0.019 Hz | **53 s** |
| 1 µW (median ambient) | 0.093 Hz | 11 s |
| 10 µW (good ambient) | 0.93 Hz | 1.1 s |
| 100 µW (Qi class) | 9.3 Hz | 110 ms |

**Verdict (honest pessimism).** Ambient-RF harvesting (d) **cannot
sustain BLE adverts at the 100 ms rate users expect**. It can
sustain ≈1 advert per 10 s in median ambient. **Qi pad and NFC
reader proximity are the only modes where BLE is practically useful
for a "phone discovers card" UX.**

Margin to bridge to "100 ms in ambient" = 100 µW vs 1 µW =
**20 dB**. Cannot be closed by chip design alone.

### 5.9 TR-switch isolation

Series NMOS off-state: |Z_off| = 1 / (2π·f·Coff). At Coff = 50 fF:
|Z_off| = 1326 Ω at 2.4 GHz. Isolation at 50 Ω ≈ **29 dB**.

Required: 10 dB to keep harvester safe. Met by single FET. T2
series-shunt available if 35 dB+ needed.

### 5.10 Regulatory / PSD

ISM 2.4 GHz: FCC 15.249 / ETSI EN 300 328 allow EIRP up to
+20 dBm. Our PA ≤0 dBm into −3 dBi IFA → EIRP −3 dBm: well under
any limit.

### 5.11 Where pessimism applies

- η_PA at 60 % is optimistic for Class E in 180 nm at 2.4 GHz.
  Real: ≈45 % → 2.2 mW PA, ≈7 mW radio total.
- Synthesiser at 3 mW assumes a careful first design.
- MIM density assumes cap_mim_2f0fF top-stack.

## 6. References

See [`references.md`](references.md).

## 7. Negative results

### 7.1 Free-running ring DCO at 2.4 GHz fails BLE adjacent-channel mask
Calculated L(1 MHz) ≈ −75 dBc/Hz vs spec target ≈−90 dBc/Hz. Fails
by 10 dB. Locking mandatory.

### 7.2 PMOS in the 2.4 GHz signal path
fT(pfet_06v0) ≈ 7.6 GHz, fT/f ≈ 3× — too low for stable gain.

### 7.3 On-die LC tank conflicts with top-metal logo
5 nH spiral on Metal5 ≈ 300×300 µm; Metal5 reserved for the
wafer.space logo. Mitigation: site spiral on Metal4 with ~1.5×
lower Q.

### 7.4 Bursty TX from a 4 µF storage cap is not feasible on-die
4 µF / 2 fF/µm² = **2000 mm²** die area (corrected 2026-05-04 —
was 8 mm² with 1000× cap-arithmetic error). Total v2 area
≤2.25 mm². Implies single-channel single-packet adverts (1.5 µF
→ **~750 mm²** — *still* far too much), or no burst at all. The
gap is ~900× per µF, not ~3.5× as the prior version implied.

### 7.5 ADPLL fails on area in 180 nm
TDC area in 180 nm is ≈10× a 65 nm equivalent.

### 7.6 BAW/FBAR reference — not in PDK
gf180mcuD has no BAW/FBAR option.

### 7.7 Resolvable-private-address (P3) defeats use case
Card identity rotates every 15 min; phones not paired to the IRK
cannot resolve. The entire "passive scan-me" use case breaks.

### 7.8 Frequency-domain antenna split with (d) is not viable
Both share the 2.4 GHz IFA. No useful sub-band separation.

## 8. Open questions

(See [`open-questions.md`](open-questions.md).)

## 9. Comparison readiness

| PA Approach | η @ 0 dBm | DC | Maturity | Best fit | Worst fit |
|---|---|---|---|---|---|
| A1 Class A | 30 % | 3.3 mW | very mature | linear back-off | const-env BLE |
| A2 Class AB | 45 % | 2.2 mW | very mature | OFDM/QAM | const-env BLE |
| A3 Class B | 55 % | 1.8 mW | mature | const-env GFSK | non-const env |
| A4 Class C | 55 % | 1.8 mW | mature | const-env, hard drive | linear |
| A5 Class D (V-mode) | 55 % | 1.8 mW | moderate | const-env | high-f, high-Cp |
| A6 Class E | 60 % | 1.7 mW | moderate | **default candidate** | load-pull-sensitive |
| A7 Class F | 65 % | 1.5 mW | moderate | area-rich const-env | small area |
| A8 Inverse Class D | 60 % | 1.7 mW | moderate | high V_DD stack | low V_DD |
| A9 Digital polar | 50 % | unit array | maturing | polar mod | 180 nm area |
| A10 Cascode A/B | 40 % | 2.5 mW | mature | high V_DD rail | strict η |

| Synth | PN @ 1 MHz | Power | Area | BLE-compliant | Best fit |
|---|---|---|---|---|---|
| S1 Integer-N (LC) | −115 dBc/Hz | 4 mW | 0.3 mm² | yes | reference |
| S2 Fractional-N | −115 dBc/Hz | 5 mW | 0.4 mm² | yes (overkill) | multi-band |
| S3 Free ring DCO | −80 dBc/Hz | 1.5 mW | 0.05 mm² | **no** | none |
| S4 Ring + FLL | −80 dBc/Hz | 2 mW avg | 0.1 mm² | **no** | sub-spec |
| S5 LC-VCO + int-N | −120 dBc/Hz | 4 mW | 0.3 mm² | yes | **default** |
| S6 ILO from LC | −110 dBc/Hz | 3 mW | 0.25 mm² | yes | exotic |
| S7 ADPLL | −110 dBc/Hz | 3 mW | 0.5 mm² | yes | ≤65 nm only |
| S8 BAW-ref | n/a | n/a | n/a | n/a | not in PDK |

## 10. Author's notes

- Single most useful insight: **at 0 dBm BLE, the synthesiser
  dominates total event energy ~1.8× over the PA in 180 nm**
  (corrected 2026-05-04 from "~3×" per reviewer-1; see also §1
  point 4 and §5.5 table). This inverts the intuition from
  higher-power TX designs and means PA-class optimisation has
  ≈half *less* leverage than synth-power optimisation in
  180 nm. At 28 nm the synth/PA ratio drops to ~1× (parity per
  Sano-2018 measurements).
- The **storage-cap wall** (§5.7, §7.4) is a genuinely hard
  constraint not mentioned in the TODO.md brief.
- The "antenna shared with (d)" requirement is harmless from
  switch-isolation physics but introduces a matching-network
  co-design problem.
- I deliberately kept this report agnostic on TX-only vs
  TX+SCAN_RSP. Both fit harvester budget at Qi-class power.
- One reviewer concern: this report uses textbook PA efficiency
  numbers scaled by a generic "180 nm derate". The academic-survey
  instance should back these with measured-silicon citations.
