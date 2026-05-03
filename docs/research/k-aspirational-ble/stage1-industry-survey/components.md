# Sub-block breakdown — industry-survey angle

This file enumerates the building blocks each surveyed BLE-TX
architecture from `report.md` §3 would need on `gf180mcuD` 180 nm.
The blocks are grouped by the high-level architecture choice; many
blocks are shared across architectures.

## 0. Common to all BLE-TX architectures

| Block | Purpose | Industry reference |
|---|---|---|
| Antenna match (lumped LC) | Conjugate-match PCB IFA to PA / harvester | Tsai TSMC 0.18 µm 2009 PA paper |
| TR-switch (SPDT) | Multiplex (d) harvester input vs (k) BLE PA output on shared IFA | Talwalkar Stanford 2004; Yamamoto NTT 2001 |
| Bandgap reference | Process-stable Vref for VCO bias, brown-out, etc. | Razavi *Design of Analog CMOS ICs* |
| Brown-out detector | Inhibits TX burst when harvested rail < threshold | TI BQ25570 app note |
| LDO or switched-cap regulator | Generates the RF-clean 1.8 V / 3.3 V rails for radio | TI TPS78001 app note |
| Storage cap (MIM bank) | Sustains burst peak current; charges between bursts | Atmosic ATM3 app note (off-die µF in their kit) |
| Link-layer FSM | Handles BLE advertising state machine, channel hop 37→38→39 | Apache Mynewt-NimBLE `controller/src/ble_ll_adv.c` |
| Whitening / CRC-24 | BLE Core 5.4 §B.3.2 (whitening), §B.3.1.1 (CRC-24) | Bluetooth Core spec |
| GFSK shaping filter (Gaussian, BT = 0.5) | Pulse-shape the 1 Mbps bit stream before modulator | Bluetooth Core 5.4 §B.2.1 |
| Internal RC oscillator (existing item (a)) | Reference clock if no XO; trimmed via eFuses (item j) | shared with item (a) |

## 1. Synthesiser-specific blocks

### 1.1 Integer-N LC PLL (S1) and Fractional-N LC PLL (S2)

| Block | Notes |
|---|---|
| LC tank inductor (1.8 nH spiral) | Metal4 (Metal5 reserved for logo); Q ≈ 8–10 |
| LC tank capacitor (MIM cap bank) | switchable for VCO tuning |
| Cross-coupled NMOS pair | core oscillator devices |
| VCO buffer / ÷2 prescaler | drives charge pump and PA driver |
| PFD (3-state) | edge-aligned phase comparator |
| Charge pump | 50–500 µA programmable |
| Loop filter | 2nd-order or 3rd-order passive RC + MIM |
| ÷N divider | integer (S1) or multi-modulus + ΔΣ (S2) |
| ΔΣ modulator (S2 only) | MASH 1-1-1 typical |
| Reference XO (or RC + FLL) | 16 / 32 MHz |

### 1.2 Fractional-N ADPLL with TDC (S3)

| Block | Notes |
|---|---|
| Digitally Controlled Oscillator (DCO, LC-based) | switched-MIM cap bank with 8–12 bit resolution |
| Time-to-Digital Converter (TDC) | inverter-chain delay line, ≈ 32 stages |
| Digital loop filter (proportional + integral) | implemented in HDL |
| Frequency Command Word (FCW) | digital input that sets carrier frequency |
| Two-point modulator (digital) | adds GFSK to FCW for direct LO modulation |

### 1.3 Free-running ring DCO (S4) — *negative result, listed for completeness*

| Block | Notes |
|---|---|
| 5-stage current-starved ring | 2.4 GHz target |
| Coarse / fine current DAC | for frequency programming |
| Output buffer | drives PA driver |
| **Missing**: any locking mechanism. **Fails BLE adjacent-channel mask.** |

### 1.4 Ring DCO + FLL (S5)

| Block | Notes |
|---|---|
| Ring DCO | as S4 |
| Counter-based FLL | counts ring edges over reference period; updates DCO control |
| Reference clock (e.g. 32 MHz from item (a)) | sets target frequency |
| **Still fails BLE mask** at 1 MHz offset. |

### 1.5 Injection-locked LC oscillator (S6)

| Block | Notes |
|---|---|
| LC tank w/ small NMOS pair | as S1 but smaller |
| Injection input port | from divider chain or external lock signal |
| Lock-detector | confirms injection capture |
| **Best fit for ULV BLE TX in 180 nm**; needs an external locking source which conflicts with no-XO constraint |

### 1.6 Two-point LC ADPLL (S7)

Combines S2 (fractional-N PLL) and S3 (ADPLL TDC) with a two-point
modulator that injects GFSK both directly into the DCO and into the
FCW digital path so wideband modulation passes the loop bandwidth
without distortion.

| Block | Notes |
|---|---|
| All blocks of S3 | TDC, DCO, digital loop filter |
| High-pass injection into DCO | direct modulation |
| Low-pass injection into FCW | digital modulation |
| Calibration logic | matches gains of two paths |

## 2. PA-specific blocks

### 2.1 Class A / AB / B / C linear PAs (A1–A4)

| Block | Notes |
|---|---|
| Cascode device pair (NMOS) | output stage |
| Gate bias generator | sets quiescent operating point |
| Output match network (lumped LC) | transforms 50 Ω antenna to optimal load |
| Decap | local on-PA |

### 2.2 Class D voltage-mode (A5)

| Block | Notes |
|---|---|
| Two NMOS push-pull devices | square-wave driven 180° apart |
| Gate driver | low-Z to handle drain-cap charge |
| Series-resonant LC tank to load | filters fundamental |

### 2.3 Class D current-mode (A6)

| Block | Notes |
|---|---|
| Two NMOS half-bridges | current-steered |
| LC tank in shunt | resonates drain capacitance |
| Differential transformer (off-chip ideally) | combines outputs |

### 2.4 Class E (A7)

| Block | Notes |
|---|---|
| Single NMOS switch | drain |
| Shunt drain capacitor (CD) | sets ZVS waveform |
| Series load network (LC) | pi-network typical |
| Choke inductor (RF choke) | DC feed |

### 2.5 Class E differential w/ on-chip transformer (A8)

| Block | Notes |
|---|---|
| Pair of A7 stages | π-shifted |
| On-chip 1:1 RF transformer | Metal4 spiral pair |
| Center-tapped DC feed | through transformer primary |

### 2.6 Class F / inverse F (A9)

| Block | Notes |
|---|---|
| NMOS switch | as A7 |
| Drain network with 2nd / 3rd harmonic terminations | shorts even, opens odd, or vice versa |
| Output match | as A7 |

### 2.7 Digital polar / segmented switching (A10)

| Block | Notes |
|---|---|
| Array of unit-PA cells | each can be on/off |
| Amplitude-control digital input | programs how many cells active |
| Phase modulator (PLL-side) | provides constant-envelope drive |
| Combiner | network combines unit cells |

## 3. TR-switch-specific blocks

### 3.1 Series NMOS (T1)

| Block | Notes |
|---|---|
| Series NMOS pass-gate (large W) | low Ron |
| Body-bias circuit | sometimes used for isolation |
| Gate drive level shifter | swings to harvested rail |

### 3.2 Series-shunt NMOS (T2) — recommended

| Block | Notes |
|---|---|
| Series NMOS pass-gate (path 1) | for PA → antenna |
| Series NMOS pass-gate (path 2) | for harvester → antenna |
| Shunt NMOS to ground (per OFF path) | improves isolation |
| Anti-phase gate-drive logic | non-overlapping clocks |

### 3.3 Stacked series NMOS (T3) — for high-power tolerance

| Block | Notes |
|---|---|
| Two or three NMOS in series | distributes off-state voltage |
| DC-bias network for each gate | resistor divider to keep all ON |

## 4. Modulator-specific blocks

### 4.1 Two-point GFSK modulator (M1)

| Block | Notes |
|---|---|
| Bit-stream buffer | from packet builder |
| Gaussian shaping filter (FIR) | BT = 0.5, span ≈ 4 bits |
| Direct DCO injection | high-pass path |
| FCW addition | low-pass path |

### 4.2 Closed-loop modulation (M2)

GFSK injected only at FCW; loop bandwidth must be > 500 kHz.
Usually fails BLE mask without compensation. Largely abandoned.

### 4.3 Open-loop post-lock modulation (M3)

PLL locks then opens; DCO modulated directly. Frequency drift over
modulation interval is the failure mode.

### 4.4 ADPLL FCW direct (M4)

Bit stream directly added to integer FCW input. Simplest digital
implementation but suffers from loop-bandwidth distortion.

## 5. Power-management blocks

| Block | Notes |
|---|---|
| Bandgap reference | 1.2 V Vref |
| LDO (3.3 V → 1.8 V) | feeds VCO + buffer |
| Switched-cap charge pump | optional, generates ULV rail (≤ 1 V) for ULV synth |
| Brown-out detector | hysteretic comparator vs Vref / 2 |
| Burst sequencer | charges storage cap, fires advert burst, discharges |
| Sleep / off-state controller | gates all radio blocks except RC oscillator |

## 6. Storage-cap subsystem (item (e) co-design)

| Block | Notes |
|---|---|
| MIM cap array (under logo where Metal5 free) | bulk storage |
| MOS-cap fill in core | decoupling |
| Reverse-leak diode | prevents back-flow into harvester |
| **Required external cap if BLE bursts mandatory** | **NOT compatible with no-passives constraint** |

## 7. Link-layer / packet-builder blocks (HDL)

| Block | Notes |
|---|---|
| ADV_NONCONN_IND PDU builder | builds 47-byte advert PDU |
| Header builder | preamble (1 B), access-address (4 B = 0x8E89BED6 for ADV), header (2 B) |
| CRC-24 generator | polynomial 0x65B (BLE Core 5.4 §B.3.1.1) |
| Whitening LFSR (7-bit, channel-seeded) | per-bit XOR |
| Channel sequencer (37 → 38 → 39) | with 150 µs IFS |
| GFSK shaping (FIR) | 4-bit precision, 16× oversample |
| Bit-stream serialiser (1 Mbps) | clocked from synth |
| Optional SCAN_RSP path | if R1 chosen |

All of these are RTL and exist in Apache Mynewt-NimBLE C source as a
reference (`controller/src/ble_ll_*.c`). A `gf180mcuD` reimplementation
is straightforward HDL.

## 8. Cross-block integration costs

Estimated area (very rough, scaled from published silicon):

| Block | Area in 180 nm |
|---|---|
| LC tank (Metal4 spiral, 5–8 nH) | 0.2 mm² |
| LC-VCO core + buffers | 0.05 mm² |
| Integer-N PLL (sans tank) | 0.1 mm² |
| Class-E PA core | 0.05 mm² |
| TR-switch (T2) | 0.02 mm² |
| Antenna match | 0.05 mm² |
| Bandgap + LDO + brown-out | 0.05 mm² |
| Link-layer HDL (synthesised) | 0.05 mm² (low gate count) |
| Storage cap (per µF MIM) | 0.5 mm² / µF |
| **Subtotal w/o storage** | ≈ **0.55 mm²** |
| **w/ even 1 µF on-die storage** | ≈ **1.05 mm²** |
| **w/ 4 µF on-die storage** | ≈ **2.55 mm²** (exceeds full die) |

## 9. Block-level open-source IP availability

| Block | Open-source IP available? |
|---|---|
| Link-layer / packet builder | YES (Apache NimBLE, Apache 2.0) |
| GFSK shaping FIR | YES (any DSP textbook; trivial) |
| CRC-24 / whitening | YES (NimBLE) |
| LC-VCO (180 nm) | partial (academic schematics; no clean RTL) |
| PLL | partial (Skywater 130 nm has analog cells; 180 nm is sparser) |
| PA | NO open silicon; academic schematics available |
| TR-switch | NO open IP; trivial schematic |
| MIM-cap bank | NO open IP; layout per PDK |
| Bandgap | partial (some open analog libraries) |
