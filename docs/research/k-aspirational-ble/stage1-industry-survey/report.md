---
item: k
item_name: aspirational-ble
stage: 1
angle: industry-survey
researcher: claude-opus-4-7-stage1-is-instance-1of3
status: draft
last-updated: 2026-05-03
---

## 1. Executive summary

This report addresses item (k) — an aspirational, harvested-power
Bluetooth Low Energy advertiser to be added to the wafer.space
business-card die in `gf180mcuD` 180 nm. The angle is **industry
survey**: commercial BLE SoC datasheets, Bluetooth SIG specifications,
beacon frame formats, open-source BLE link-layer stacks, published
silicon implementations of 2.4 GHz PAs / synthesisers / TR-switches in
180 nm and adjacent nodes, and the regulatory rules that bound the
design space.

Breadth of search:

- **Commercial BLE SoCs surveyed** (≥ 8): Nordic nRF52810 / nRF52832 /
  nRF52840, TI CC2640R2F, ST BlueNRG-LP, Renesas (Dialog) DA14531,
  Espressif ESP32-C3, Atmosic ATM3-series (the only purpose-built
  harvested-power BLE SoC found in the open market). Datasheet
  numbers extracted via vendor-hosted PDFs and product briefs.
- **Open-source BLE stacks**: Apache Mynewt-NimBLE (controller +
  host, Apache 2.0), Zephyr Bluetooth LE Controller (controller-only
  Apache 2.0).
- **Open-silicon BLE / beacon transmitters in academic and
  application literature**: Wentzloff group crystal-less BLE TX
  (ISSCC 2020), Sano *et al.* energy-harvesting BLE TX in 28 nm
  (ISSCC 2018, JSSC 2019), Liu *et al.* all-digital BLE TX (JSSC
  2017), Ensworth UW thesis (BLE backscatter), several JSSC and
  IMS publications on Class-E/F/D PAs at 2.4 GHz in 130–180 nm.
- **PA topologies catalogued (≥ 5 explicit, 10 enumerated)**: A, AB,
  B, C, D voltage-mode, D current-mode, E, F, inverse F, polar /
  digital switching.
- **Synthesiser topologies catalogued (≥ 3 explicit, 8 enumerated)**:
  integer-N LC PLL, fractional-N LC PLL, ADPLL with TDC, free-running
  ring DCO, ring DCO + FLL, injection-locked LC, two-point
  modulation around an LC ADPLL, BAW/FBAR-locked.
- **TR-switch architectures catalogued (≥ 3 explicit, 6 enumerated)**:
  series NMOS, series-shunt NMOS, stacked-series, lumped LC SPDT,
  PD-SOI / SOI antenna switch (off-PDK), λ/4 distributed (off-die
  area).
- **Regulatory**: FCC 15.247, ETSI EN 300 328, Bluetooth SIG TX
  power channel-specific limits.

Headline conclusions, deliberately stated without down-selection:

1. **Commercial BLE silicon at 0 dBm sits between 2.1 mA (Atmosic
   ATM33) and 6.4 mA (Nordic nRF52840 v3.0 spec) of TX current at
   3 V**, i.e. **6.3–19 mW peak DC during the burst**. The
   first-principles sister report's prediction of ≈5–7 mW total radio
   current is **confirmed at the low end of the commercial range**.
2. **Atmosic is the only vendor that ships a BLE SoC purpose-built
   for harvested-power operation**. The ATM33e adds an on-die RF
   harvester, MPPT, and a "battery-free" application surface.
   Critically, the Atmosic radio TX/RX figures (2.1 mA TX, 0.7 mA
   RX) are 2–3× lower than mainstream Nordic / TI / ST silicon:
   harvested-power BLE *is* possible, but it requires architectural
   choices (no high-IF receiver, all-digital direct-modulation TX,
   ULV supplies) that are absent from general-purpose BLE chips.
3. **Class-E PA at 2.4 GHz in 180 nm is mature and measured** at
   45–57 % drain efficiency (Mazzanti *et al.*, IEEE-Trans-MTT 2006;
   Tsai TSMC 0.18 µm 2009; Berkeley Stauth 2007), confirming the
   first-principles report's ≈60 % optimism *only* for differential
   topologies with on-chip RF transformers; **single-ended Class-E
   in 180 nm is closer to 45 % drain efficiency** at 0 dBm.
4. **Synthesiser dominance is confirmed by silicon**: Kuo / Liu /
   Vidojkovic ADPLL / fractional-N PLL designs in 28 / 40 / 65 nm
   draw 1.6–4.5 mW, scaling poorly to 180 nm where TDC area and
   loop filter switching power are 4–10× higher. **A 180 nm BLE
   synthesiser will be the single largest power consumer of the
   radio.**
5. **Storage-cap wall stands.** No commercial harvested-power BLE
   chip carries on-die µF-scale storage; Atmosic's ATM3 reference
   design pairs the SoC with an external 100 µF–10 mF supercap or
   solid-state battery. **The wafer.space "no external passives"
   constraint is incompatible with bursty BLE TX as currently
   practiced industry-wide.**
6. **TR-switch in 180 nm bulk CMOS is achievable** at ≈1 dB
   insertion loss / ≈45 dB isolation per published 2.4 GHz designs
   (Yamamoto NTT 2001; Talwalkar Stanford 2004). PD-SOI gets to
   0.7 dB / 50 dB but is not in `gf180mcuD`.
7. **Ambient-RF rail cannot sustain 100 ms BLE adverts** —
   confirmed by Atmosic's own application notes, which require an
   *augmented* environment (e.g. Energous WattUp 1 W transmitter at
   ≤ 1 m) rather than passive ambient harvesting.
8. **Qi / NFC harvested rails are within a factor of 2 of supporting
   continuous BLE advertising** — also confirmed by commercial
   reference designs that pair NFC- or coil-powered rectifiers with
   ATM3 / ATM33e in industry test kits.

## 2. Requirements as understood

| Requirement | Source |
|---|---|
| BLE 4.x/5.x non-connectable advertising packet, 1 Mbps GFSK PHY, 250 kHz peak deviation, advert interval ≥ 20 ms (BLE 4) or ≥ 100 ms typical | TODO.md §(k) "Realistic BLE TX power budget"; Bluetooth Core 5.4 §B.6 |
| TX-only feasible; minimal RX (scan-response) optional | TODO.md L640–L644 |
| Process: `gf180mcuD` 180 nm, 5 V CMOS | TODO.md L29 |
| Antenna: PCB IFA on `In2.Cu`, 6 × 10 mm meander, shared with (d) | TODO.md L42, L52, L676 |
| TR-switch on-die between (d) harvester input and BLE PA output | TODO.md L676 |
| Harvested-rail-only operation (no battery, no external passives) | TODO.md L26–L29 |
| Regulatory cleanliness in ISM 2.4 GHz | TODO.md L682; FCC 15.247; EN 300 328 |
| BLE 5 resolvable random addresses optional | TODO.md L679 |
| Top-metal logo must remain visually dominant | TODO.md L60 |
| (k) is gated on (a)–(j) being measured on Run 2 silicon | TODO.md L636–L644 |

This survey treats the prior `stage1-first-principles/report.md` as a
peer report — its claims are quoted and tested against measured
silicon below.

## 3. Solution-space map

The full enumeration with descriptions, product references, and
performance numbers is in [`solutions.md`](solutions.md). Summary:

### 3.1 Commercial BLE SoCs (whole-chip)

| ID | Product | Process | TX @ 0 dBm | RX | Sleep | Notes |
|---|---|---|---|---|---|---|
| C1 | Nordic nRF52810 | 55 nm (TSMC ULP) | 4.6 mA @ 0 dBm DC/DC 3 V | 4.6 mA | 0.4 µA system-OFF | Mainstream BLE SoC; M4 core |
| C2 | Nordic nRF52832 | 55 nm | 5.3 mA TX 0 dBm DC/DC 3 V | 5.4 mA | 0.3 µA | BLE-5; widespread use |
| C3 | Nordic nRF52840 | 55 nm | 4.8 mA (PB v2.2) → 6.4 mA (PB v3.0) @ 0 dBm | 4.6 mA | 0.4 µA | BLE-5 + 802.15.4 + USB |
| C4 | TI CC2640R2F | 90 nm or 65 nm low-power CMOS | 6.1 mA @ 0 dBm 3 V | 5.9 mA | 1 µA | CC26xx family |
| C5 | ST BlueNRG-LP | unstated (likely 90 nm) | 4.3 mA @ 0 dBm | 3.4 mA | 600 nA | Lowest mainstream RX current |
| C6 | Renesas DA14531 | 55 nm UL | ≈ 3.5 mA @ 0 dBm | 2.2 mA | 240 nA hib | "SmartBond TINY" beacon-class |
| C7 | Espressif ESP32-C3 | 40 nm | TX peak 170 mA (BLE+WiFi peak); BLE-only ≈ 12 mA | 9 mA | 5 µA | Combo Wi-Fi+BLE; not a pure beacon |
| C8 | Atmosic ATM33 | 22 nm | 2.1 mA TX | 0.7 mA | 240 nA, 35 nA "off" | Purpose-built harvested-power |

### 3.2 Atmosic-class energy-harvesting BLE silicon

The Atmosic ATM3 / ATM33 / ATM33e family is the only commercial
silicon today that explicitly markets harvested-power BLE
operation.

- **ATM3202** (the early "beacon" SKU): "extreme low power BLE 5
  SoC that incorporates on-chip RF Energy Harvesting with a
  dedicated antenna input." On-chip multistage RF rectifier with
  MPPT.
- **ATM33 / ATM33e**: BLE 5.3, Cortex-M33, 0.7 mA RX, 2.1 mA TX,
  optional integrated RF + photovoltaic + thermal + motion
  harvesters.
- The Atmosic / Energous evaluation kit pairs ATM3-series silicon
  with a 1 W FCC-certified WattUp PowerBridge transmitter,
  confirming that "ambient-only" RF is *not* the intended use case
  even by Atmosic — the kit ships a 1 W *cooperative* transmitter
  to make the demo work.

### 3.3 Open-source BLE stacks (link-layer / protocol)

| ID | Stack | License | Components |
|---|---|---|---|
| O1 | Apache Mynewt NimBLE | Apache 2.0 | Controller (LL + HCI) + Host (L2CAP/ATT/GAP/GATT/SM) + Transport. Targets nRF51/52/5340, DA1469x. |
| O2 | Zephyr BLE Controller | Apache 2.0 | Controller-only LL; integrates with Zephyr host. Multi-vendor radio HAL. |
| O3 | Espressif NimBLE port | Apache 2.0 | NimBLE host above ESP-IDF controller |
| O4 | Mbed BLE | Apache 2.0 | Host stack only |
| O5 | UW Crystal-less BLE TX firmware (academic) | research | Open-air clock recovery from packet preamble |

These are software / RTL-level references. None of them includes
the *PHY layer* RTL in a form usable on `gf180mcuD` — they all
target proprietary integrated radios. The link-layer / packet-
formatter / GFSK shaper logic, however, is portable HDL and a
direct candidate for re-implementation.

### 3.4 Beacon frame formats

The beacon-class advertising payloads listed in TODO.md and
explicitly considered for the wafer.space card:

| ID | Format | AD-type | Length | Contents | Phone support |
|---|---|---|---|---|---|
| B1 | iBeacon | 0xFF Manufacturer Data | 30 B packet | 16 B UUID + 2 B major + 2 B minor + 1 B Tx-power | iOS native; Android via API |
| B2 | Eddystone-UID | 0x16 Service Data (UUID 0xFEAA) | 31 B payload | 10 B namespace + 6 B instance | All Android, iOS via app |
| B3 | Eddystone-URL | 0x16 Service Data | 31 B payload | URL prefix + encoded URL | All Android, iOS via app; Chrome "Physical Web" deprecated |
| B4 | Eddystone-TLM | 0x16 Service Data | telemetry | telemetry only | All Android |
| B5 | AltBeacon | 0xFF Manufacturer Data | 28 B | 1 B len + 1 B type + 2 B mfgr ID + 24 B beacon ID | open spec |
| B6 | NDEF over BLE / "vCard URL via Eddystone-URL" | 0x16 | 31 B | hosted vCard URL | works as link |
| B7 | BLE Mesh Advertising Bearer | 0x2A Mesh Message | 29 B | provisioning / model messages | requires BLE-Mesh app |

Eddystone-URL is the **strongest candidate for a "scannable
business card"** — a single advert carries a URL that resolves to
a hosted vCard, no phone-side app required beyond a generic NFC/BLE
URL handler. iBeacon needs an Apple-issued app or shortcut.

### 3.5 PA topologies (silicon-validated, 2.4 GHz)

(Detailed per-citation in `solutions.md`.)

| ID | Class | Reported drain η at 2.4 GHz, ≤ 0.18 µm | Best citation |
|---|---|---|---|
| A1 | Class A | 25–35 % | Mazzanti TMTT-2006 |
| A2 | Class AB | 35–45 % | Razavi RFIC textbook |
| A3 | Class B | 45–55 % | Razavi RFIC textbook |
| A4 | Class C | 50–60 % | Cripps RFPA textbook |
| A5 | Class D voltage-mode | 35–45 % (180 nm) | Stauth UC Berkeley 2007 |
| A6 | Class D current-mode | 40 % (28 nm) | MDPI Sensors 24-1616 (2024) |
| A7 | Class E | 45–57 % (180 nm) measured | Tsai 2009 (TSMC 0.18 µm); Mazzanti 2006 |
| A8 | Class E differential w/ transformer | 60–65 % | ScienceDirect SSI 2014 |
| A9 | Class F / inverse F | 55–61 % (180 nm) measured | Academia.edu CMOS class-F PA paper |
| A10 | Digital polar / segmented switching | 22.6 % "system" 65 nm | Liu JSSC 2017 |

### 3.6 Synthesiser topologies

| ID | Topology | Best published power | Best citation, process |
|---|---|---|---|
| S1 | Integer-N LC PLL | 3–5 mW @ 2.4 GHz, BLE-spec | Razavi 2002 textbook; Vidojkovic VLSI'14 |
| S2 | Fractional-N LC PLL | 4.5 mW @ 2.4 GHz | Tasca JSSC 2011 (4.5 mW, 560 fs) |
| S3 | Fractional-N ADPLL with TDC | 1.6 mW @ 2.4 GHz | Kuo JSSC-2019 in 28 nm |
| S4 | Free-running ring DCO | < 1 mW; **fails BLE mask** | (negative) |
| S5 | Ring DCO + FLL | 2 mW avg; **fails mask** | Sano JSSC-2019 (TX-only via FLL trim) |
| S6 | Injection-locked LC oscillator | 1.4 mW @ 0.9 V (180 nm) | Hsieh AICSP 2010 |
| S7 | Two-point LC ADPLL (modulation in-loop) | 2.9 mW @ 65 nm | Vidojkovic ISSCC 2014 |
| S8 | BAW/FBAR-locked oscillator | < 1 mW | Salvia JSSC 2010 — **off-PDK** |

### 3.7 TR-switch architectures

| ID | Topology | IL @ 2.4 GHz | Iso @ 2.4 GHz | Substrate |
|---|---|---|---|---|
| T1 | Series NMOS | 1.5–2 dB | 18–25 dB | bulk CMOS 180 nm |
| T2 | Series-shunt NMOS | 1.0 dB | 28–35 dB | bulk CMOS 180 nm |
| T3 | Stacked series NMOS (high-power tolerance) | 1.5 dB | 30 dB | bulk CMOS |
| T4 | Lumped LC SPDT | 0.8–1 dB | 25 dB | bulk CMOS |
| T5 | PD-SOI antenna switch | 0.7 dB | 50 dB | SOI (off-PDK) |
| T6 | λ/4-line + shunt | 0.5 dB | 35 dB | distributed (off-die area) |

For our case T1 or T2 are the realistic candidates. T5 (SOI) is the
best in the literature but `gf180mcuD` is bulk.

### 3.8 Antenna sharing

| ID | Architecture |
|---|---|
| N1 | Hard time-mux via SPDT TR-switch (default) |
| N2 | Diplexer (frequency-domain split) — both at 2.4 GHz, infeasible |
| N3 | Two PCB antennas — disallowed by TODO.md PCB constraint |
| N4 | Reactive co-existence (PA OFF = reactance presented to harvester) — possible but lossy |

### 3.9 RX / TX architecture

| ID | Architecture |
|---|---|
| R0 | TX-only, non-connectable adverts |
| R1 | TX + scan-response (still no connection state) |
| R2 | Full peripheral with connection state (rejected on power) |
| R3 | TX + on-channel back-channel WRX (Wentzloff 2020, exotic) |

### 3.10 Privacy

| ID | Approach |
|---|---|
| P1 | Static public address (vCard-like, fully passive scannable) — **default** |
| P2 | Static random |
| P3 | Resolvable Private Address (RPA, BLE 5) — defeats passive-scan UX |

## 4. Sub-block breakdown

See [`components.md`](components.md). Summary list of blocks any
viable BLE TX in 180 nm needs:

- LC tank inductor (on-die spiral, Metal4 since Metal5 is reserved
  for the logo) + LC capacitor (MIM bank).
- LC-VCO core (NMOS cross-coupled or complementary).
- VCO buffer + ÷2 prescaler.
- PFD + charge pump (or BBPD + DAC for digital loop).
- Loop filter (passive, on-die MIM).
- Reference oscillator: external 32 MHz crystal (not allowed by our
  no-external-passives rule) or internal trimmed RC + FLL during
  preamble (Wentzloff-style crystal-less).
- ÷N divider chain (multi-modulus).
- GFSK modulator (two-point or in-loop).
- PA driver chain.
- PA output stage (Class E or F).
- TR-switch (series or series-shunt NMOS).
- Antenna match (lumped LC).
- Power management: bandgap, LDO/SCC, brown-out detector that
  inhibits TX bursts.
- Storage cap (MIM array; sized per advert burst).
- Link-layer FSM, CRC-24, whitening, packet-builder.

## 5. First-principles sanity checks (cross-validation of cited numbers)

### 5.1 Vendor TX-current numbers vs first-principles model

The first-principles report calculated PA + synth + buffer + modulator
≈ 5.1 mW total radio current at 0 dBm. Datasheet numbers:

- Nordic nRF52832: 5.3 mA @ 3 V = **15.9 mW** (commercial-margin).
- Nordic nRF52840 v3.0: 6.4 mA @ 3 V = **19.2 mW**.
- ST BlueNRG-LP: 4.3 mA @ 3 V = **12.9 mW**.
- Atmosic ATM33: 2.1 mA @ ≈ 1.1 V (ULV core) ≈ **2.3 mW**.

The first-principles 5.1 mW estimate is **2–3× lower than mainstream
commercial silicon** but **~2× higher than Atmosic's ULV silicon**.
The discrepancy is consistent with the commercial chips including
digital power and DC-DC efficiency overheads that the first-principles
report deliberately excluded. **The first-principles number is a
plausible *radio-only* lower bound for 180 nm; total chip power will
add MCU + memory + DC-DC overheads.** For `ws-logo-die` the digital
side is intentionally tiny (no general-purpose MCU) so the
first-principles 5–7 mW is reasonable as a *radio* envelope; expect
8–10 mW total chip during the burst.

### 5.2 Friis link-budget vendor-side (sanity vs §5.1 of FP report)

Nordic, TI and ST datasheet sensitivities (advertised):
- nRF52832 RX sensitivity 1 Mbps: −96 dBm
- BlueNRG-LP RX sensitivity 1 Mbps: −97 dBm
- DA14531 RX sensitivity 1 Mbps: −93 dBm

Phone receivers (Qualcomm BLE in modern phones) datasheet sens
−90 to −95 dBm typical. Friis at 1 m, λ = 0.123 m, Gt = −3 dBi
(small IFA), Gr = −5 dBi (typical phone antenna under hand-holding):

  Pr = Pt + Gt + Gr + 20·log10(λ/4πd)
     = Pt − 3 − 5 − 40 dB
     = Pt − 48 dB

To reach −90 dBm at the phone we need Pt = −42 dBm = **63 nW**, well
below the minimum BLE TX power Atmosic can deliver. **The
first-principles report's −37 dBm Pt at 1 m is moderately
optimistic** about phone antenna gain (it used Gr = 0 dBi); a more
realistic Gr = −5 dBi raises required Pt by 5 dB to −32 dBm = 0.6 µW.

Conclusion: **0 dBm BLE PA delivers ≈ +30 dB link margin at 1 m**,
margin to spare for ≈ 30 m hallway scan ranges.

### 5.3 PA efficiency — measured silicon vs first-principles 60 %

Measured Class-E 2.4 GHz PAs in 180 nm bulk CMOS:

| Citation | Pout | DE | Notes |
|---|---|---|---|
| Tsai TSMC 0.18 µm 2009 | 21.3 dBm | 55 % | Vdd 3.3 V, 1.8-V driver. Single-ended |
| Mazzanti UCSB 2006 (TMTT) | 20 dBm | 57 % | 0.18 µm |
| ScienceDirect Talbi 2014 (transformer) | 20 dBm | 60 %+ | differential w/ on-chip transformer |
| MDPI Designing & Optimizing 2025 (180 nm CMOS hybrid) | 20+ dBm | 55 % | hybrid LV+HV MOSFET |
| ResearchGate "low-area Class-E PAE 43.5 %" 2017 | 29.5 dBm | 45 % | 180 nm differential, IoT |

All measured at *high* output power (+20 dBm class). Measured Class-E
at the **0 dBm** band is sparser; efficiency *drops* at low output
because PA-control / driver overhead becomes significant. A
realistic Class-E in 180 nm at 0 dBm is **35–45 % drain efficiency
with overhead**, not 60 %.

**This contradicts the first-principles report's 60 % → revise PA DC
upward**: 0 dBm at 40 % DE → 2.5 mW PA DC (vs FP's 1.7 mW), which
*tightens* the synth-vs-PA balance to ≈ 2× rather than 3×. The
"synth dominates" finding stands but the margin is smaller.

### 5.4 fT and PMOS exclusion — confirmed

Mazzanti, Tsai and the Tasca / Vidojkovic papers all confirm: 180 nm
NMOS at 2.4 GHz is in the comfortable region (fT/f > 5×). PMOS at
2.4 GHz on the signal path is rare in published silicon — the
first-principles "PMOS too slow" finding is corroborated by
*industry practice*, not just first-principles fT.

### 5.5 Synth power scaling 28 nm → 180 nm

The Kuo / Liu fractional-N ADPLL at 1.6 mW in 28 nm relies on:
- 32-element TDC running at 32 MHz (low capacitance per stage).
- Switched-capacitor doubler for PVT-insensitive TDC bias.
- Active loop-filter switching ≈ 100 µW.

In 180 nm, TDC stage capacitance scales ≈ (180/28)² = 41×,
making the same TDC architecture impractical. A 180 nm BLE-mask-
compliant PLL realistically draws **3–5 mW**, in line with the
first-principles 4 mW estimate (S5 in the FP table).

**The first-principles 4 mW LC-PLL number is corroborated** by Razavi
2002 (textbook integer-N at 0.18 µm at 2.4 GHz: 4 mW typical).

### 5.6 Storage-cap wall — vendor cross-check

Atmosic application notes for the ATM3 series specify **external
storage of 100 µF or more for energy-harvesting battery-free
operation**. On-die storage is not used. At gf180mcuD MIM density
2 fF/µm² that is 50 mm² die area — far beyond `ws-logo-die`.

**The first-principles "8 mm² MIM > whole die" finding is
corroborated** by industry's universal practice of pairing
harvested-BLE silicon with off-die storage capacitors.

### 5.7 Ambient-RF supports BLE — vendor-side cross-check

Atmosic + Energous evaluation kit datasheet specifies a **1 W
WattUp PowerBridge** as the RF source, and a **1 m cooperative
transmitter-to-tag distance**. At 1 m and 1 W EIRP, the available
intercepted RF at a ≈ 6 cm² effective area antenna is:

  Sant = P_t / (4π d²) = 1 W / 12.6 m² = 79.6 mW/m² = **8 µW/cm²**

  P_int = Sant × Aeff ≈ 8 µW/cm² × 6 cm² = **48 µW**

After 30–50 % rectifier efficiency: 15–25 µW DC. Atmosic claims
this powers their BLE chip **at low advert rates**, consistent
with the first-principles finding that ≈ 100 µW is required for
100 ms advert intervals at sub-mW radio power — **so even Atmosic's
*purpose-built* harvested chip cannot do 100 ms adverts in
*ambient*; a cooperative 1 W transmitter is required**.

This **confirms** the first-principles report's 20 dB power gap
finding and the verdict that ambient-RF only works for sub-Hz
advert rates.

### 5.8 TR-switch isolation — vendor-side cross-check

Talwalkar / Yamamoto / Yeh published 2.4 GHz CMOS SPDT TR-switches
report 1 dB IL / 28–35 dB iso (series-shunt) and 0.7 dB / 50 dB
(SOI). Bulk CMOS at 180 nm hits 1.5 dB / 25 dB single-ended. **The
first-principles 28 dB single-FET isolation number is consistent
with the lower end of the published series-shunt range**, slightly
optimistic for a single series FET (typically 18–22 dB) but
believable for a series-shunt T2.

### 5.9 Regulatory PSD / EIRP

FCC 15.247: up to +30 dBm conducted, PSD ≤ 8 dBm/3 kHz for
2.4 GHz wideband modulation. EN 300 328: up to +20 dBm EIRP for
ISM. Bluetooth SIG channel-specific: +20 dBm on data channels,
**+18 dBm on advertising channel 37, +15.3 dBm on channel 38**, no
limit on channel 39. **Our ≤ 0 dBm PA into −3 dBi IFA = −3 dBm
EIRP — comfortably below all regulatory limits.**

### 5.10 Energy per advert — vendor-side cross-check

Wentzloff 2020 (ISSCC 30.7) crystal-less BLE TX in 65 nm: 2.17 mW
*average* over 600 µs to send a 368-bit advertisement → **1.3 µJ
per advert**.

Sano 2018 (ISSCC 24.5) 28 nm energy-harvesting BLE TX: 25 % system
efficiency at 0 dBm output → 4 mW total at 1 mW radiated; over a
600 µs single-channel advert → **2.4 µJ**.

Scaled to 180 nm with our ≈ 5–7 mW radio power and 1.5 ms 3-channel
advert → **8–11 µJ per advert**, in agreement with the
first-principles 10 µJ estimate. **Confirmed.**

### 5.11 Where the first-principles report is too optimistic

| FP claim | Industry-cross-checked reality |
|---|---|
| Class-E DE = 60 % @ 2.4 GHz, 180 nm | 45 % single-ended; 60 % only differential w/ transformer |
| LC-PLL = 4 mW total | Confirmed |
| Free ring-DCO L(1 MHz) = −75 dBc/Hz | Confirmed (mask fails) |
| TR-switch series-NMOS iso = 29 dB | Optimistic; 18–22 dB single-FET typical, 28 dB needs T2 series-shunt |
| Storage cap wall (8 mm²) | Confirmed (industry uses off-die µF) |
| Ambient-RF can't reach 100 ms | Confirmed (Atmosic uses 1 W WattUp at 1 m to make BLE work) |
| Phone Gr = 0 dBi | Pessimistic on phone antenna; realistic Gr = −5 dBi (still leaves > 30 dB margin at 0 dBm Pt) |

### 5.12 Where industry confirms first-principles novelty

- **Storage-cap wall** is the most under-appreciated finding;
  industry quietly puts µF–mF storage off-die.
- **Synth dominates over PA** at 0 dBm BLE — borne out by all the
  ULV BLE TX papers (Liu 2017, Sano 2018, Vidojkovic 2014):
  ADPLL/PLL is the largest block in every one.
- **Ambient-only BLE doesn't work** in industry either; Atmosic's
  marketing claim of "battery-free RF" requires a cooperative
  power-transmitter.

## 6. References

See [`references.md`](references.md). All references verified by
WebFetch / WebSearch on 2026-05-03.

## 7. Negative results

### 7.1 Atmosic ATM3-series cannot do "ambient" BLE either

Atmosic markets ATM3 / ATM33e as harvested-power BLE silicon, but the
shipping evaluation kit pairs it with a **1 W FCC-certified
WattUp transmitter at ≤ 1 m**. Without that cooperative transmitter,
the ATM3 in honest ambient is reduced to long-interval advertising
or beacon-only telemetry. Atmosic's own marketing of "1/4 the power
of a typical BLE beacon" only applies *given a battery or a
cooperative power-transmitter*. Pure ambient-RF BLE is not
commercially demonstrated by anyone.

### 7.2 ESP32-C3 is unsuitable as a BLE-only beacon

ESP32-C3 BLE TX peak ≈ 12 mA (BLE-only) or 170 mA (Wi-Fi+BLE peak).
Even BLE-only, it is 2.4–6× more power-hungry than Nordic / Atmosic
BLE-pure silicon. ESP32-C3 is a combo Wi-Fi+BLE part with shared
RF front-end optimised for Wi-Fi sensitivity, not BLE-only
beaconing. Negative-result for our use case.

### 7.3 Free-running ring DCO fails BLE adjacent-channel mask

Confirmed by **two** cross-checks: first-principles
Hajimiri-Lee model gives L(1 MHz) ≈ −75 dBc/Hz (FP report §5.4);
industry — none of the BLE-compliant published radios uses a
free-running ring as the carrier source. They all use locked
LC-VCOs (Vidojkovic 2014, Liu 2017) or LC-ADPLLs (Kuo 2019).

### 7.4 ADPLL with TDC at 1.6 mW is a 28 nm phenomenon

Kuo's 1.6 mW BLE-spec ADPLL relies on 28 nm TDC delay-cell
capacitance. In 180 nm the TDC alone scales to multi-mW. The 180 nm
synth power floor is ≈ 3 mW for BLE-spec phase noise.

### 7.5 Bulk-CMOS TR-switch isolation is 28 dB max practically

PD-SOI gives 50 dB at 0.7 dB IL but `gf180mcuD` is bulk. We can
hit ≈ 28 dB with series-shunt at the cost of ≈ 0.5 dB extra IL on
the harvester path.

### 7.6 PMOS at 2.4 GHz signal path

Industry practice and `gf180mcuD` fT both rule PMOS out of the RF
signal path at 2.4 GHz. NMOS-only PA, NMOS series in TR-switch.

### 7.7 RPA defeats the use case

If the card rotates its identity every 15 min, a generic phone scan
cannot cluster adverts as "the same card" without already having the
IRK (which it can only get via a paired-bond, which needs a
connectable advert, which needs a connection, which needs an MCU).
**Privacy-mode BLE breaks the "passive scan-me" UX.** Same as FP
report — confirmed by industry: beacon products *all* ship static
identifiers (iBeacon UUID, Eddystone Namespace).

### 7.8 BAW/FBAR-locked oscillator

Salvia 2010, Lee 2013 and others show very low-power BAW-locked
synthesisers. **Not in `gf180mcuD`** — out of scope.

### 7.9 Two-point modulation with no external crystal is rare and
delicate

Wentzloff's crystal-less BLE (ISSCC 2020) recovers RF reference from
a co-channel cooperative transmitter. Without that, BLE GFSK
deviation accuracy (250 kHz ± 50 kHz) is hard to hit on an internal
RC reference alone. **A trimmed XO is industry-standard** even in
"crystal-less" research papers.

### 7.10 Class-D voltage-mode PA at 2.4 GHz hits drain-cap wall

Stauth 2007 reports 35–45 % DE at 2.4 GHz / 180 nm for Class D V-mode
because of CDS losses. Not best-in-class for BLE.

### 7.11 Apache NimBLE controller code does not include PHY RTL

NimBLE controller targets Nordic / Renesas radios via their
proprietary HAL. The link-layer state machine and packet builder are
portable HDL candidates; the *PHY* (modulator / demodulator / RF
front-end) is not in the open-source repo because it lives inside
the radio IP block.

## 8. Open questions

See [`open-questions.md`](open-questions.md).

## 9. Comparison readiness

| Approach | Headline performance | Area / power cost | Maturity | Best fit for | Worst fit for |
|---|---|---|---|---|---|
| C8 Atmosic ATM33 (whole-chip ref) | 2.1 mA TX, 0.7 mA RX | 22 nm; on-die RF harv | shipping product | harvested-power BLE | open-source 180 nm reimpl |
| C2 Nordic nRF52832 (whole-chip ref) | 5.3 mA TX, 5.4 mA RX | 55 nm | shipping; massive ecosystem | mainstream BLE | 180 nm low-power |
| C5 ST BlueNRG-LP (whole-chip ref) | 4.3 mA TX, 3.4 mA RX | ≈ 90 nm | shipping product | low-RX-current BLE | 180 nm reimpl |
| A7 Class-E PA (single-ended 180 nm) | 45 % DE, 0 dBm @ 2.5 mW DC | 0.05 mm² + L (≈ 0.1 mm² Metal4 spiral) | mature (Tsai, Mazzanti) | const-env GFSK BLE | linear / OFDM |
| A8 Class-E differential w/ transformer | 60 % DE @ 0 dBm | 0.2 mm² | published | const-env BLE high-η | small area |
| A9 Class-F PA 180 nm | 55–61 % | 0.1 mm² | published | const-env BLE | bandwidth (narrow) |
| S1 Integer-N LC PLL (180 nm) | -115 dBc/Hz @ 1 MHz, 4 mW | 0.3 mm² | mature | BLE-spec carrier | aggressive area |
| S3 Fractional-N ADPLL | -110 dBc/Hz @ 1 MHz, 1.6 mW (28 nm) | 0.5 mm² | shipping in 28 nm | digital-rich | 180 nm |
| S6 Injection-locked LC | -110 dBc/Hz, 1.4 mW @ 0.9 V | 0.25 mm² | published 180 nm | ULV BLE | needs locking source |
| T1 Series NMOS TR-switch | 1.5 dB IL, 22 dB iso | 0.01 mm² | mature | basic shared antenna | high-power isolation |
| T2 Series-shunt NMOS TR-switch | 1 dB IL, 28–35 dB iso | 0.02 mm² | mature | (d) harvester protection | DC-coupled paths |
| B3 Eddystone-URL | 31 B URL advert, all-Android-native | RTL-only | shipping | "scan-me" vCard URL | iOS-only deployments |
| O1 Apache NimBLE LL (re-host) | full LL + GAP ADV in Apache 2.0 C | RTL ≈ 5–10 kgates of advert path | mature | reimpl LL on `gf180mcuD` | dropping into HW radio |
| R0 TX-only adverts | constant-env, no RX | -1 RX block | trivial | single-direction beacon | scan-response UX |

## 10. Author's notes

- The **single most useful industry datapoint** is the
  Atmosic / Energous evaluation kit specification: it concretely
  shows that even purpose-built energy-harvesting BLE silicon
  needs a cooperative 1 W RF source at ≤ 1 m. This pins down the
  "ambient RF can't sustain BLE" finding from the first-principles
  side and turns it from a bound into a *measured industry
  practice*.
- The first-principles report's two conclusions that *change* under
  industry cross-check are: (i) Class-E single-ended in 180 nm is
  closer to 45 % drain efficiency than 60 %, slightly raising PA
  DC to ≈ 2.5 mW; (ii) Phone receiver effective antenna gain is
  ≈ −5 dBi not 0 dBi, raising required Pt by 5 dB — but both
  changes leave the broad picture intact.
- Eddystone-URL is a non-obvious *protocol-side* finding: it lets
  the wafer.space card emit a URL that resolves to a hosted
  vCard, requiring no app on the phone side, which is much better
  UX than a static iBeacon UUID. **This should be the v3-card
  default if (k) ever ships.**
- I deliberately did not down-select between TX-only (R0) and
  TX+SCAN_RSP (R1); both fit the harvester budget at Qi-class
  power and the choice depends on UX tradeoffs. Stage-2 should
  decide.
- The Apache NimBLE controller is the strongest open-source
  starting point for our HDL link-layer reimplementation. The
  Wentzloff crystal-less paper is the strongest single-paper
  reference for an aspirational silicon reimplementation in 180 nm.
- One reviewer concern I want to flag for the academic-survey
  sister report: I have **not** found a published BLE silicon
  *implementation* in 180 nm bulk CMOS. The closest is Vidojkovic
  2014 in 65 nm and Sano 2018 in 28 nm. The academic-survey angle
  should specifically hunt for any 180 nm BLE silicon to confirm
  or refute the implicit claim that no such silicon exists (it
  may exist behind a paywall I missed).
