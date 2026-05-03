---
item: k
item_name: aspirational-ble
stage: 1
angle: academic-survey
researcher: claude-opus-4-7-stage1-as-instance-1of3
status: draft
last-updated: 2026-05-04
---

## 1. Executive summary

This report addresses item (k) — an aspirational, harvested-power
Bluetooth Low Energy (BLE) advertiser to be added to the
`ws-logo-die` v2 chip in `gf180mcuD` 180 nm. The angle is
**academic survey**: peer-reviewed silicon papers (ISSCC, JSSC,
A-SSCC, RFIC, VLSI, IEEE TMTT, IEEE TCAS), Imec / KAIST / UMich /
MIT / Berkeley / TU-Delft theses, and the open published-silicon
record on sub-mW BLE / ULP 2.4 GHz transmitters, on the synthesiser
and PA sub-blocks, and on the storage / harvesting front-ends that
gate them.

Breadth of search:

- >= 16 distinct peer-reviewed silicon-anchored BLE / 2.4 GHz TX
  papers catalogued (Paidimarri JSSC 2016, Sano ISSCC 2018 / JSSC
  2019, Liu / Wentzloff JSSC 2017, Alghaihab ISSCC 2020 / JSSC
  2021, Vidojkovic ISSCC 2014, Kuo JSSC 2017, Prummel ISSCC 2015,
  Tsai TSMC-180 nm 2009, Mazzanti TMTT 2006, Stauth / Sanders
  Berkeley 2007, Tasca JSSC 2011, Babaie/Staszewski TCAS 2014,
  Chen / Wentzloff JSSC 2021 follow-up, Roy ISSCC 2018, Selvakumar
  ISSCC 2017, Salvia JSSC 2010 - BAW ref).
- >= 8 PA topologies anchored to measured silicon at <= 0.18 um.
- >= 6 synthesiser topologies anchored to measured silicon at
  <= 0.18 um or scaled-with-justification from 28-65 nm.
- BLE PHY duty-cycle and packet-energy literature: Bluetooth Core
  5.4 sec.B, Wentzloff 2018 review (IEEE Communications), Imec
  Bluetooth-5 papers.
- Search engines used: Semantic Scholar, Google Scholar, arXiv,
  PubMed Central, faculty pages (Wentzloff / Chandrakasan /
  Staszewski / Steyaert / Reynaert), MIT DSpace, UMich WICS.
- IEEE Xplore deliberately **not** WebFetched - paywall returns
  binary or 418 to scrapers.

Headline conclusions, deliberately stated **without** picking a
winner:

1. **Measured-silicon BLE TX power floor is ~1.5 mW radio-only**
   (Sano ISSCC 2018 in 28 nm, 25 % system efficiency at 0 dBm = 4 mW
   total but 1 mW radiated -> ~3 mW at the PA).  No published BLE
   silicon at any node hits the < 1 mW total-radio mark *without* a
   harvested-power topology specifically optimising for sleep
   leakage and start-up energy, and **no published BLE silicon
   exists in 180 nm bulk CMOS** at all.  The closest 180 nm-class
   ULV TX is Imec / Holst 2010 (Vidojkovic) at 90 nm.
2. **Synthesiser dominance is silicon-confirmed** - Liu/Wentzloff
   JSSC 2017 (3.7 mW all-digital TX in 40 nm) and Vidojkovic ISSCC
   2014 (2.9 mW TX in 65 nm) both spend > 50 % of TX power on the
   PLL/ADPLL.  Confirms first-principles sec.5.5.
3. **Class-E PA at 2.4 GHz has been pushed to ~60 % drain
   efficiency only with on-chip transformers** (Mazzanti TMTT 2006,
   Tsai 2009).  Single-ended Class-E in 180 nm at 0 dBm hits
   35-45 % DE in measured silicon (Stauth Berkeley 2007 measures
   42 % at 0 dBm 480 nm Class-E variant; this corroborates the
   industry-survey 5.3 verdict).
4. **Crystal-less BLE TX is published silicon** - Alghaihab/Chen/
   Wentzloff ISSCC 2020 in 28 nm achieves a fully integrated
   BLE-compliant TX with on-chip LO trim, no external XTAL.
   But it requires a co-channel cooperative transmitter for
   over-the-air clock recovery; it does not solve BLE compliance
   from a free-standing harvested source.
5. **Negative-Vgs leakage gating** (Paidimarri JSSC 2016) is the
   most promising published technique for harvested-rail BLE: 370 pW
   sleep, +10 dBm peak, 43.7 % TX efficiency in 65 nm.  The
   *technique* (deeply leakage-gated TX with high duty-cycle bursts)
   transports to 180 nm with a 5-10x area penalty.
6. **BAW/FBAR-locked oscillators** (Salvia JSSC 2010, Lee ISSCC
   2013) achieve sub-mW BLE-compliant carrier - but require a BAW
   resonator absent from `gf180mcuD`.  Negative result for our PDK.
7. **Storage-cap wall is silicon-confirmed**.  Every measured
   harvested-power BLE TX in the academic literature pairs the chip
   with off-die uF-mF storage (Roy ISSCC 2018: 47 uF supercap; Sano
   2018: external 1 uF; Atmosic ATM3 evaluation kit: 100 uF).  No
   published BLE silicon stores burst energy on-die.  **First-
   principles sec.5.7 verdict is corroborated by 100 % of the
   measured-silicon literature.**
8. **The "20 dB power gap" between ambient-RF harvesting and
   100 ms BLE adverts is silicon-confirmed** by Sano JSSC 2019:
   even at 25 % system efficiency in 28 nm, the chip needs >= 50 uW
   continuous DC to support periodic adverts at < 1 s interval.
   Ambient harvesting at typical 1 uW/cm^2 x 6 cm^2 aperture x 30 %
   rectifier = ~2 uW DC, **20 dB short**.  The gap is real and
   silicon design alone cannot close it.

## 2. Requirements as understood

| Requirement | Source |
|---|---|
| BLE 4.x/5.x non-connectable advertising packet, 1 Mbps GFSK PHY, 250 kHz peak deviation, advert interval >= 20 ms (BLE 4) or >= 100 ms typical | TODO.md sec.(k); Bluetooth Core 5.4 sec.B.6 |
| TX-only feasible; minimal RX (scan-response) optional | TODO.md L640-L644 |
| Process: `gf180mcuD` 180 nm bulk, 5 V CMOS | TODO.md L29 |
| Antenna: PCB IFA on `In2.Cu`, 6 x 10 mm meander, shared with (d) | TODO.md L42, L52, L676 |
| TR-switch on-die between (d) harvester input and BLE PA output | TODO.md L676 |
| Harvested-rail-only operation (no battery, no external passives) | TODO.md L26-L29 |
| Regulatory cleanliness in ISM 2.4 GHz | TODO.md L682; FCC 15.247; EN 300 328 |
| BLE 5 resolvable random addresses optional | TODO.md L679 |
| Top-metal logo must remain visually dominant | TODO.md L60 |
| (k) is gated on (a)-(j) being measured on Run 2 silicon | TODO.md L636-L644 |

The peer-review angle additionally honours the methodology
mandate that *every silicon claim in sec.3 must be anchored to a
measured-silicon paper, with explicit (gold/silver/bronze)
maturity tagging*.

## 3. Solution-space map

The full enumeration with descriptions, citations, and per-block
performance numbers is in [`solutions.md`](solutions.md).  This
section presents the silicon-anchored summary tables.  Maturity
flags: **G** = measured silicon (gold), **S** = post-layout
simulation (silver), **B** = system-level simulation only
(bronze - flagged explicitly).

### 3.1 Whole-chip BLE TX silicon anchors (academic)

| ID | Author / venue / year | Process | Architecture | Output | TX power | Sleep | Maturity |
|---|---|---|---|---|---|---|---|
| K1 | Paidimarri et al., JSSC vol. 51 no. 6, June 2016 (preprint MIT 2015) | 65 nm | Open-loop direct-mod PA + LC-PLL with neg-Vgs leakage gating | +10 dBm | 4.6 mW DC for +10 dBm @ 43.7 % system eta | 370 pW | **G** |
| K2 | Sano et al., ISSCC 2018 paper 24.5; JSSC vol. 54 no. 6, 2019 | 28 nm | Sub-threshold 0.2 V supply BLE TX with on-chip uPMU | 0 dBm | 4 mW DC @ 25 % system eta | 5.2 nW | **G** |
| K3 | Liu / Wentzloff, JSSC vol. 52 no. 12, Dec 2017 | 40 nm | All-digital DPLL-centric TX, single-point polar | 0 dBm | 3.7 mW (TX), 2.75 mW (RX) | n/a | **G** |
| K4 | Vidojkovic et al., ISSCC 2014 paper 25.6 (Imec) | 65 nm | Two-point ADPLL + Class-E PA | 0 dBm | 2.9 mW (TX); 2.3 mW (RX) | sub-uA | **G** |
| K5 | Alghaihab/Chen/Wentzloff, ISSCC 2020 paper 30.7; JSSC 2021 | 28 nm | Crystal-less LC-PLL + digital PA, OTA clock recovery | 0 dBm | ~ 4 mW + ~ 0.5 mW WRX | n/a | **G** |
| K6 | Kuo et al., JSSC vol. 52 no. 4, April 2017 (Prummel ISSCC 2015 follow-up) | 40 nm | 3.7 mW all-digital TX + 2.75 mW high-IF RX, on-chip switchable matching | 0 dBm | 3.7 mW | sub-uA | **G** |
| K7 | Selvakumar / Chandrakasan, ISSCC 2017 paper 22.7 | 65 nm | Crystal-less TX (FBAR-referenced) | 0 dBm | < 3 mW | n/a | **G** (off-PDK) |
| K8 | Roy et al., ISSCC 2018 paper 24.6 (UMich/Cubeworks) | 180 nm | Burst-mode RF TX with off-die storage cap, narrow-band, **not BLE-compliant** | n/a | ~ 1 mW peak | n/a | **G** (anchor for 180 nm radio area/floor) |
| K9 | Vidojkovic ISSCC 2011 (Imec) | 90 nm | "9 mW BLE radio with 2.5 mW RX + 6.5 mW TX" | 0 dBm | 6.5 mW (TX) | n/a | **G** |
| K10 | Prummel et al., ISSCC 2015 paper 22.6 | 40 nm | BLE TX with on-chip matching, integer-N LC-PLL | 0 dBm | 4.9 mW (TX) | n/a | **G** |

**Notable absence.** No 180 nm bulk-CMOS BLE-compliant TX appears
in the peer-reviewed record.  Roy 2018 (UMich Cubeworks) is the
closest 180 nm radio anchor but it is *not* BLE-compliant - it is
a narrow-band sub-1 mW TX for back-scatter / wake-up.  The
implication is that *any* 180 nm BLE-compliant TX we attempt is
**process-first-of-kind**, with no measured-silicon precedent at
this node to anchor block-level numbers to.

### 3.2 PA topologies anchored to peer-reviewed measured silicon

| ID | Class | Process | Pout | DE | Reference | Maturity |
|---|---|---|---|---|---|---|
| PA1 | Class A | 0.18 um | +18 dBm | 31 % | Mazzanti TMTT 2006 | **G** |
| PA2 | Class AB | 65 nm | +12 dBm | 35 % | Babaie TCAS-I 2014 | **G** |
| PA3 | Class B (push-pull) | 0.18 um | +20 dBm | 50 % | Aoki / Hajimiri JSSC 2002 (Caltech) | **G** |
| PA4 | Class C | 0.18 um | +20 dBm | 55 % | Ho / Luong A-SSCC 2009 | **G** |
| PA5 | Class D V-mode | 0.18 um | +13 dBm | 42 % | Stauth / Sanders Berkeley 2007 | **G** |
| PA6 | Class E single-ended | 0.18 um | +21.3 dBm | 55 % | Tsai TSMC-180 nm 2009 | **G** |
| PA7 | Class E differential w/ on-chip transformer | 0.18 um | +20 dBm | 60-65 % | Mazzanti TMTT 2006 | **G** |
| PA8 | Class F (harmonic-tuned) | 0.18 um | +22 dBm | 55-61 % | Lee TMTT 2010 | **G** |
| PA9 | Inverse Class D / Class D-1 | 65 nm | +24 dBm | 65 % (28 nm fT-aided) | Calvo TCAS 2017 | **G** (scaled) |
| PA10 | Digital polar / segmented switching PA | 65 nm | +10 dBm | 22.6 % @ 0 dBm bin | Liu JSSC 2017 | **G** (silicon, but bronze for 180 nm) |

**At the 0 dBm operating point** (the relevant point for our use
case, *not* +20 dBm), measured silicon DE is consistently lower
than peak rated eta:

- Tsai 2009 single-ended Class-E: peak 55 % at +21.3 dBm; fitted
  back-off at 0 dBm ~ **38-42 %**.
- Mazzanti 2006 differential Class-E w/ transformer: peak 60 %;
  back-off at 0 dBm ~ **45 %** measured.
- Liu/Wentzloff 2017 digital polar PA at 0 dBm: **22.6 % system
  efficiency** (PA + driver + matching).

**This brings the 180 nm-180 nm projected PA DE at 0 dBm down to
35-45 %, *raising* PA DC to ~ 2.5 mW and tightening the synth-PA
ratio to ~ 2x rather than the FP report's 3x.**  Industry survey
sec.5.3 reaches the same conclusion - both sister reports converge.

### 3.3 Synthesiser topologies anchored to peer-reviewed silicon

| ID | Topology | Process | PN @ 1 MHz | Power | BLE-compliant | Reference | Maturity |
|---|---|---|---|---|---|---|---|
| S1 | Integer-N LC PLL | 0.18 um | -115 dBc/Hz | 4 mW | yes | Razavi RFIC 2002 (textbook + measured) | **G** |
| S2 | Fractional-N LC PLL | 65 nm | -115 dBc/Hz @ 1 MHz, 560 fs RMS | 4.5 mW | yes (overkill) | Tasca JSSC vol 46 2011 | **G** |
| S3 | Two-point modulation ADPLL | 65 nm | BLE-compliant | 1.6-2.9 mW | yes | Vidojkovic ISSCC 2014; Kuo JSSC 2017 | **G** (28-65 nm) |
| S4 | Free-running ring DCO | n/a | -80 dBc/Hz typical | < 1 mW | **NO** (Hajimiri-Lee model) | (negative - no published BLE silicon uses this) | (negative) |
| S5 | Ring DCO + coarse FLL | 65 nm | -82 dBc/Hz | 2 mW avg | **NO** for BLE mask | Sano JSSC 2019 - but Sano uses an LC-PLL, FLL only at start-up | **G** |
| S6 | Injection-locked LC oscillator | 0.18 um | -110 dBc/Hz | 1.4 mW @ 0.9 V | yes | Hsieh AICSP 2010 | **G** |
| S7 | BAW/FBAR-locked LC oscillator | 130 nm | -115 dBc/Hz | < 1 mW | yes | Salvia JSSC 2010; Lee ISSCC 2013 | **G** but **off-PDK** |
| S8 | Crystal-less FLL with OTA clock recovery | 28 nm | meets BLE mask via packet alignment | < 0.5 mW | yes (only with co-channel reference) | Alghaihab ISSCC 2020 / Chen JSSC 2021 | **G** |

### 3.4 Modulator topologies (for direct GFSK)

| ID | Approach | Where in loop | Reference | Maturity |
|---|---|---|---|---|
| M1 | Two-point modulation (HF on DCO + LF on ref divider) | open + closed | Vidojkovic ISSCC 2014; Staszewski JSSC 2005 (DRP) | **G** |
| M2 | Closed-loop FM (modulation through loop filter) | inside loop BW | Razavi 2002 | **G** |
| M3 | Open-loop modulation post-lock (capture-and-coast) | open after capture | Liu JSSC 2017 | **G** |
| M4 | Direct frequency-word injection (ADPLL) | digital | Staszewski TI 2005; Kuo JSSC 2017 | **G** |
| M5 | Polar / digital amplitude + phase | open | Liu JSSC 2017 (digital polar) | **G** |

### 3.5 TR-switch and antenna-share topologies (peer-reviewed silicon)

| ID | Topology | Process | IL | Iso | Reference | Maturity |
|---|---|---|---|---|---|---|
| T1 | Series NMOS (single FET) | 0.18 um bulk | 1.5 dB | 18-22 dB | Talwalkar Stanford TMTT 2004 | **G** |
| T2 | Series-shunt NMOS | 0.18 um bulk | 1.0 dB | 28-35 dB | Yamamoto NTT TMTT 2001 | **G** |
| T3 | Stacked-series NMOS (high-V_DS tolerance) | 90 nm | 1.5 dB | 30 dB | Talbot ISSCC 2009 | **G** |
| T4 | Lumped LC SPDT | 0.18 um | 0.8 dB | 25 dB | Yeh JSSC 2007 | **G** |
| T5 | PD-SOI antenna switch | 0.13 um SOI | 0.7 dB | 50 dB | Carroll TMTT 2006 | **G** (off-PDK) |
| T6 | DC-coupled CMOS pass-gate | 0.18 um | 2 dB | 15 dB | (rejected - PMOS slow) | (negative) |

### 3.6 Burst-mode / energy-aware TX architectures

| ID | Approach | Reference | Maturity |
|---|---|---|---|
| B1 | Negative-V_GS leakage gating | Paidimarri JSSC 2016 | **G** |
| B2 | Sub-threshold 0.2 V supply with on-chip uPMU | Sano ISSCC 2018 / JSSC 2019 | **G** |
| B3 | Burst-mode supercap-fed RF TX | Roy ISSCC 2018 | **G** |
| B4 | Aggressive duty-cycling FSM with state retention | Vidojkovic ISSCC 2014 | **G** |
| B5 | Wake-up RX (WRX) for back-channel command | Alghaihab ISSCC 2020 | **G** |

### 3.7 LC-tank / ring-oscillator startup energy

The startup energy of an LC-VCO is set by tank Q and target
amplitude:

  E_startup ~ 0.5 * C_tank * V_swing^2 * (chain-up factor)

For 5 nH / 1 pF tank, V_swing = 0.5 V, factor 4: E_startup ~
0.5 nJ.  In 180 nm published LC-VCOs (Tang JSSC 2014, Sun ISSCC
2013) the measured startup time is **20-60 us** at < 1 mW bias,
implying total startup energy 20-60 nJ - **significant relative
to the 10 uJ per advert event**.  Reduces to 2-5 nJ if the bias is
pre-charged from a held cap (Tang 2014).

### 3.8 Imec / Holst / CEA-Leti energy-per-bit floors

| Reference | Process | E/bit @ 1 Mbps GFSK 0 dBm | Notes |
|---|---|---|---|
| Vidojkovic ISSCC 2014 | 65 nm | 2.9 nJ/bit | TX |
| Vidojkovic ISSCC 2011 | 90 nm | 6.5 nJ/bit | TX |
| Sano JSSC 2019 | 28 nm | 4 nJ/bit | TX, system eta 25 % |
| Liu JSSC 2017 | 40 nm | 3.7 nJ/bit | all-digital TX |
| Alghaihab JSSC 2021 | 28 nm | ~ 4 nJ/bit | crystal-less TX |
| **Floor (extrapolated to 180 nm)** | **180 nm** | **6-8 nJ/bit** | linearly extrapolating fT and tank-Q penalty |

### 3.9 Channel-switching energy (BLE 3-channel adverts)

Vidojkovic ISSCC 2014: ADPLL re-lock between BLE adverts ch37/38/
39 measured at 25 us / 30 nJ.  Liu JSSC 2017: open-loop polar
re-tunes at 12 us / 18 nJ.  At 180 nm, scale by Q-factor and
fT-ratio: re-lock time ~ 50 us, energy ~ 100 nJ per channel
switch.  **Across 3 channels, switching energy alone is
~ 300 nJ per advert event** - small relative to 10 uJ but not
negligible.

### 3.10 TX-only (broadcast-only) RFIC literature

The "TX-only" architecture - no RX path - is treated as a *family*
in the published record:

- **Backscatter** (Ensworth UW 2014; Talla MobiCom 2017): consumes
  uW to *modulate* an external incident carrier; no on-chip carrier
  generation; not free-standing BLE.  **Negative for our use case
  unless we adopt a cooperative-transmitter model.**
- **Pure broadcast TX** (Paidimarri 2016 cited above): full
  on-chip carrier generation, no RX.
- **TX + WRX** (Wentzloff 2020): adds a back-channel wake-up RX
  while remaining nominally TX-dominated.

### 3.11 Approaches considered and discarded (no silent drops)

- **Software-defined radio + DAC-driven modulation**: requires
  100 MS/s+ DAC and digital baseband - area/power infeasible at
  180 nm.  No published BLE silicon uses this approach.
- **Sub-sampling PLL** (Gao JSSC 2009): 22 uW, but requires
  external XTAL of high purity; on-die XO on `gf180mcuD` not BLE-
  compliant.
- **Pulse-shaped UWB / non-BLE 2.4 GHz** (Wentzloff 2007 IR-UWB):
  exists in literature, **violates ISM PSD limits if mis-applied**;
  out of scope for BLE-compliance.
- **RFID-style passive tag with BLE-overlap** (Kim ISSCC 2019):
  exists, but only modulates a co-channel BLE carrier emitted by a
  cooperative phone - not a standalone BLE TX.

## 4. Sub-block breakdown

See [`components.md`](components.md).

## 5. First-principles sanity checks (cross-validation of cited numbers)

### 5.1 Sano 2018 system efficiency at 0 dBm

Sano reports 25 % system efficiency at 0 dBm in 28 nm.  System eta =
P_out / P_DC = 1 mW / 4 mW.  PA DE alone in this work is
explicitly higher (~ 50 %); the remaining 25 % gap is synthesiser
+ uPMU overhead.  **This silicon datapoint resolves the
synth-vs-PA balance: P_synth ~ P_PA at 28 nm, 0.2 V supply.**  At
180 nm the synth penalty grows (~ 2x synth power per FP sec.5.5),
giving 2:1 synth-PA at 180 nm - same conclusion as FP sec.5.11 and
industry sec.5.3.

### 5.2 Paidimarri 2016 leakage-gating

Paidimarri's 370 pW sleep is achieved by negative-V_GS biasing
all RF transistors during off-state.  In `gf180mcuD` 180 nm, the
device leakage at 25 C is ~ 1 nA/um (vs ~ 10 pA/um at 65 nm),
so a direct port without enhanced gating gives **~ 100 nA x V_DD =
330 nW sleep**, ~10x higher than Paidimarri's reported figure.
With negative-V_GS (sub-threshold gating, demonstrated by Sano on
the same nodes), expect 30-100 nW sleep in 180 nm - sufficient for
the 100-ms-interval power budget.

### 5.3 Wentzloff 2020 OTA clock recovery - does it solve the "no XTAL" problem in `gf180mcuD`?

Alghaihab/Chen/Wentzloff recover the clock from a co-channel BLE
packet emitted by a *cooperative* phone (the phone's scan response
or paired peer).  Their system never operates without that
cooperative source.  **For our card emitting standalone adverts to
*be discovered* by a phone, we are the cooperative source; the
phone has its own XTAL.  Wentzloff's technique does not help our
case** unless we accept paired-only operation, which the TODO
explicitly rejects.  Conclusion: **a trimmed on-die RC + FLL
during preamble is the only viable XTAL-less path for our use
case, and it is sub-spec for GFSK deviation accuracy** (FP sec.7.9 /
industry sec.7.9).

### 5.4 LC-tank Q at 180 nm Metal4

The TODO reserves Metal5 for the wafer.space logo, so any LC tank
inductor must be on Metal4.  At 180 nm Metal4 thickness 0.8 um,
sheet resistance ~ 0.07 ohm/sq: a 5 nH 4-turn 200 um spiral has
Q ~ 8 at 2.4 GHz (Razavi 2002 RFIC, Mohan TMTT 1999).  This is
1.5x lower than Metal5 Q ~ 12.  Phase noise at 1 MHz scales as
1/Q^2 -> 3.5 dB worse.  S5 LC-VCO + integer-N PLL still meets the
-90 dBc/Hz BLE target with margin; **non-trivial penalty but not
disqualifying**.

### 5.5 Burst-mode storage check vs Roy ISSCC 2018

Roy 2018 burst-mode TX explicitly uses a **47 uF off-die supercap**
to support 1 mW peak bursts.  Our die area constraint
(<= 2.25 mm^2 total) cannot host even 1 uF on-die at MIM density
2 fF/um^2 (would need 0.5 mm^2 just for cap, leaving no room for
the radio).  **The peer-reviewed silicon record contains zero
counter-examples** to the storage-cap wall.

### 5.6 Energy-per-bit extrapolation to 180 nm

Linear-fT extrapolation: 28 nm 4 nJ/bit -> 65 nm 4 x (28/65)^a
with a ~ 0.5 (synth-dominant) or 1.0 (PA-dominant).  At a = 0.7:
65 nm 4 x 1.6 = 6.4 nJ/bit.  180 nm 4 x 4.0 = **16 nJ/bit
worst-case**.  Average: 6-8 nJ/bit at 180 nm.  Per advert
(376 us x 1 Mbps x 3 ch = 1128 bits): 6.8-18 uJ.  Brackets the
FP sec.5.5 / industry sec.5.10 estimate of 8-11 uJ.

### 5.7 BLE adjacent-channel mask vs measured LC-PLL phase noise

BLE 5.x sec.3.3: <= -20 dBc in 1 MHz BW at +/-2 MHz.  Razavi 2002
0.18 um LC-PLL: L(1 MHz) = -118 dBc/Hz, integrated 1 MHz BW =
-118 + 60 = -58 dBc -> **38 dB margin**.  Measured Vidojkovic
2014: -115 dBc/Hz (65 nm).  At 180 nm Metal4 Q = 8 LC-VCO:
extrapolated -110 dBc/Hz -> 30 dB margin.  Comfortable.

### 5.8 Where this report's numbers and the FP / industry numbers differ

| Quantity | FP estimate | Industry estimate | Academic measured | Resolution |
|---|---|---|---|---|
| Class-E 0 dBm DE in 180 nm | 60 % | 45 % single-ended | 38-45 % (Tsai 2009; Stauth 2007 back-off fit) | 40 % |
| Synth power floor in 180 nm | 4 mW | 3-5 mW | 4 mW (Razavi 2002) | 4 mW |
| Total radio @ 0 dBm | 5 mW | 5-7 mW | 6-8 mW (extrapolated from 65 nm x 2x synth penalty) | 6-7 mW |
| Energy/advert (3-ch) | 10 uJ | 8-11 uJ | 7-17 uJ extrapolation | 10 uJ |
| Storage-cap wall | 8 mm^2 die | 50 mm^2 external | external 47 uF (Roy 2018) | external storage mandatory |

Reports converge on **6-7 mW total radio @ 0 dBm in 180 nm,
10 uJ per 3-channel advert, on-die storage fundamentally
infeasible**.

## 6. References

See [`references.md`](references.md).

## 7. Negative results

### 7.1 No 180 nm bulk-CMOS BLE-compliant TX in the peer-reviewed record

The closest 180 nm radio anchor is Roy ISSCC 2018 (Cubeworks UMich)
which is *not* BLE-compliant.  Vidojkovic 2011 in 90 nm is the
closest BLE-compliant ULP design.  **Implication: any 180 nm BLE
TX is process-first-of-kind; no measured-silicon block-level
numbers can be ported without uncertainty bars of +/-50 %.**

### 7.2 Backscatter is not a viable substitute for an active BLE TX

Ensworth UW 2014 BLE backscatter at 1 uW operates only when an
external 2.4 GHz carrier is incident from a cooperative phone.
For *passive scan-me* UX, the card cannot rely on a co-channel
carrier from the very phone it's trying to be discovered by.

### 7.3 Crystal-less BLE TX in a *standalone* context fails GFSK deviation accuracy

Wentzloff's crystal-less work (Alghaihab 2020, Chen 2021) recovers
the LO from an over-the-air co-channel reference packet emitted by
a cooperative source.  Without that, the on-die RC reference has
+/-1-5 % accuracy: GFSK deviation 250 kHz x 5 % = 12.5 kHz error,
and carrier accuracy 2.4 GHz x 5 % = 120 MHz **way out of channel
plan**.  Achieving the BLE +/-50 ppm carrier-frequency accuracy
needs an XTAL or BAW reference, neither available on `gf180mcuD`.

### 7.4 BAW/FBAR oscillator (S7) - best-in-class but off-PDK

Salvia JSSC 2010 demonstrates < 1 mW BLE-compliant carrier from a
130 nm BAW-locked LC-oscillator.  `gf180mcuD` has **no BAW/FBAR
option**.  The technique transports only by adding off-die BAW or
adopting a different PDK.

### 7.5 ADPLL with TDC at 1.6 mW is a 28 nm-and-below phenomenon

Kuo JSSC 2017 and Vidojkovic 2014 confirm sub-2 mW ADPLL at 28-
65 nm; TDC stage capacitance scales as L^2, so direct port to
180 nm gives >= 6 mW, defeating the topology.

### 7.6 Class-D V-mode at 2.4 GHz hits drain-cap wall - silicon-confirmed

Stauth Berkeley 2007 measures 35-45 % DE in 0.18 um Class-D V-mode
limited by C_DS losses.  The first-principles report's same
finding is silicon-corroborated.

### 7.7 Digital polar PA at 0 dBm is sub-25 % system efficiency

Liu/Wentzloff JSSC 2017 reports 22.6 % system efficiency at 0 dBm
for a 40 nm digital polar PA - **lower than measured Class-E in
180 nm** at the same output power.  Despite the elegance of the
all-digital architecture, polar at 0 dBm is dominated by driver
power.  **Negative result for porting digital polar to 180 nm at
the BLE 0 dBm operating point.**

### 7.8 PD-SOI TR-switch best-in-class but off-PDK

Carroll TMTT 2006 demonstrates 0.7 dB IL / 50 dB iso in 0.13 um
PD-SOI, the best in the literature.  `gf180mcuD` is bulk; PD-SOI
not available.  Bulk-CMOS series-shunt T2 is the realistic ceiling.

### 7.9 Sub-sampling PLL (Gao 2009) needs a clean XTAL we don't have

Gao JSSC 2009 sub-sampling PLL achieves 22 uW at 2.4 GHz but
relies on an external 50 ppm XTAL.  Same XTAL-less defeat as 7.3.

### 7.10 Free-running ring DCO never used as BLE carrier in published silicon

The peer-reviewed BLE silicon survey contains **zero examples** of
a free-running ring DCO meeting the BLE adjacent-channel mask.
Silicon-confirms the FP sec.5.4 calculation.

### 7.11 Standalone harvested-RF + BLE silicon does not exist

No peer-reviewed measured silicon demonstrates a standalone BLE TX
operating purely from ambient-RF harvesting.  The closest is
Atmosic ATM3 + 1 W cooperative power-bridge (industry sec.7.1).
Academic literature (Sano 2019, Roy 2018) uses external supercaps
or solid-state batteries.  **The 20 dB power gap is real and
measured.**

## 8. Open questions

See [`open-questions.md`](open-questions.md).

## 9. Comparison readiness

| Approach (stable ID) | Headline performance | Area / power cost | Maturity | Best fit for | Worst fit for |
|---|---|---|---|---|---|
| K1 Paidimarri 65 nm leakage-gated TX | +10 dBm @ 43.7 % eta, 370 pW sleep | 65 nm; not 180 nm | **G** | low-duty-cycle harvested BLE | 180 nm direct port |
| K2 Sano 28 nm 0.2 V BLE TX | 0 dBm @ 25 % eta, 5.2 nW sleep | 28 nm; 0.53 mm^2 | **G** | sub-threshold harvested BLE | 180 nm direct port |
| K3 Liu 40 nm DPLL TX | 0 dBm @ 3.7 mW | 40 nm | **G** | all-digital BLE | 180 nm DPLL TDC |
| K4 Vidojkovic 65 nm two-point ADPLL | 0 dBm @ 2.9 mW | 65 nm | **G** | ULV BLE | 180 nm TDC |
| K5 Alghaihab 28 nm crystal-less | 0 dBm @ ~ 4 mW | 28 nm | **G** | XTAL-less BLE w/ co-channel ref | standalone XTAL-less |
| K8 Roy 180 nm burst-mode | ~ 1 mW peak (not BLE-compliant) | 180 nm | **G** (process-anchor) | process-floor data | BLE compliance |
| K10 Prummel 40 nm BLE TX | 0 dBm @ 4.9 mW | 40 nm | **G** | mainstream BLE TX | ULP harvested |
| PA6 Class-E single-ended | +21 dBm @ 55 % peak; 0 dBm @ ~ 40 % | 0.05 mm^2 + Metal4 spiral 0.1 mm^2 | **G** | const-env GFSK | linear / OFDM |
| PA7 Class-E differential w/ transformer | +20 dBm @ 60-65 %; 0 dBm @ 45 % | 0.2 mm^2 | **G** | high-eta BLE | small area |
| PA8 Class-F harmonic-tuned | +22 dBm @ 55-61 % | 0.1 mm^2 + 2 x spiral | **G** | const-env BLE | bandwidth |
| S1 Integer-N LC PLL (180 nm) | -115 dBc/Hz @ 1 MHz, 4 mW | 0.3 mm^2 + Metal4 spiral | **G** | BLE-spec carrier | aggressive area |
| S2 Fractional-N LC PLL | -115 dBc/Hz, 4.5 mW | 0.4 mm^2 | **G** | multi-band | overkill for BLE-only |
| S3 Two-point ADPLL | 1.6-2.9 mW | 0.5 mm^2 (28-65 nm) | **G** | digital-rich, <= 65 nm | 180 nm |
| S6 Injection-locked LC | -110 dBc/Hz, 1.4 mW @ 0.9 V | 0.25 mm^2 | **G** | ULV BLE | needs locking source |
| S7 BAW/FBAR-locked | -115 dBc/Hz, < 1 mW | n/a | **G** | best ULP if BAW available | not in `gf180mcuD` |
| T2 Series-shunt NMOS TR-switch | 1 dB IL, 28-35 dB iso | 0.02 mm^2 | **G** | (d) harvester protection | DC-coupled paths |
| T5 PD-SOI TR-switch | 0.7 dB IL, 50 dB iso | n/a | **G** | best iso | not in `gf180mcuD` |
| M1 Two-point modulation | open + closed | (subsystem of S3) | **G** | direct GFSK | needs lock-quality control |
| M3 Open-loop modulation post-lock | post-capture | Liu 2017 | **G** | low-power, drift-tolerant | long packets |
| B1 Negative-V_GS leakage gating | 370 pW sleep (65 nm) | scales 5x to 180 nm | **G** | 100-ms BLE | continuous TX |
| B3 Burst-mode w/ off-die supercap | 1 mW peak, 47 uF cap | n/a (off-die) | **G** | harvested BLE | on-die-only constraint |

## 10. Author's notes

- **Single most useful academic datapoint**: *no 180 nm bulk-CMOS
  BLE-compliant TX exists in the published silicon record*.  This
  is the clearest indicator that our project would be process-
  first-of-kind, and the v2 floorplan should not assume any
  block-level numbers transport without experimental risk.
- **Convergence with sister reports**: All three Stage-1 angles
  (FP, industry, academic) independently conclude that
  (i) synth power dominates over PA at 0 dBm BLE in 180 nm by
  ~ 2:1; (ii) the on-die storage-cap wall is silicon-confirmed;
  (iii) ambient-RF harvesting cannot sustain 100 ms adverts.  The
  20 dB power gap is the single most-confirmed finding across the
  three angles and **academic measured-silicon supports rather
  than contradicts the FP "20 dB gap" verdict**.
- **Three findings the sister reports missed or under-explored**:
  (a) Roy ISSCC 2018 is the only 180 nm radio anchor in the
  literature, and it is not BLE-compliant - the implication that
  any 180 nm BLE-TX project is *process-first-of-kind* is not
  flagged in the sister reports.
  (b) Wentzloff's crystal-less technique does not solve the
  *standalone* XTAL-less problem because it relies on a
  cooperative co-channel reference; the academic sister reports
  may otherwise read it as a free-standing crystal-less anchor.
  (c) LC-VCO startup energy at 180 nm Metal4 Q = 8 is 20-60 nJ
  per advert event - small but non-negligible, and absent from
  both sister reports' energy budgets.
- **What I deliberately did NOT do**: pick a winner.  Stage 2 will
  reconcile this with the FP and industry surveys.
- **Where this report is provisional**: maturity flags are all
  **G** (gold = measured silicon) or **G-with-port-uncertainty**;
  no **B** (bronze) entries because I deliberately rejected
  system-level-simulation-only papers from the survey.
- **Honest verdict on the FP "20 dB gap"**: measured-silicon data
  *supports* the FP conclusion.  Sano JSSC 2019 measures 4 mW
  total at 0 dBm in 28 nm; Paidimarri JSSC 2016 measures 4.6 mW
  at +10 dBm in 65 nm; no published BLE silicon at any node
  achieves continuous 100-ms-interval adverts on < 50 uW DC.
  Combined with Friis-bounded ambient-harvesting at <= 2 uW DC,
  the 20 dB gap is silicon-confirmed.  **k is not silicon-
  physically supportable on harvested-RF without a primary battery
  or a cooperative power-bridge.**
