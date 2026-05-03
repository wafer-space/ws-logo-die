# Solutions enumeration - academic angle

This file enumerates every distinct architecture / topology
considered, with a short description and the strongest measured-
silicon citation (or explicit "negative" / "off-PDK" tag).
Stable IDs match `report.md` sec.3.

Maturity legend (per METHODOLOGY rules):
- **G** measured silicon
- **S** post-layout simulation only
- **B** system-level simulation only

## 1. Whole-chip BLE / 2.4 GHz TX silicon anchors

### K1. Paidimarri / Ickes / Chandrakasan, +10 dBm BLE TX with sub-400 pW leakage
- Process: 65 nm CMOS (MIT)
- Architecture: open-loop direct-mod PA fed from a low-bandwidth
  integer-N LC-PLL; **negative-V_GS biasing** of all RF transistors
  during sleep delivers 370 pW total leakage (about 7e7x on:off
  ratio).
- Measured: +10.9 dBm peak, 43.7 % total TX system efficiency,
  370 pW leakage, 4.6 mW DC at +10 dBm.
- Cite: Paidimarri, Ickes, Chandrakasan, JSSC vol. 51 no. 6, June
  2016, pp. 1331-1346. Preprint: ISSCC 2015 paper 13.7. MIT
  DSpace 1721.1/95676.  Maturity **G**.
- Relevance: the *technique* (deeply leakage-gated TX with
  high-duty-cycle bursts) is the closest in the literature to what
  a harvested-rail 180 nm BLE TX needs.  The 65 nm leakage numbers
  port to ~ 100 nW in 180 nm.

### K2. Sano et al., 0.2 V energy-harvesting BLE TX in 28 nm
- Process: 28 nm CMOS
- Architecture: sub-threshold logic, 0.2 V supply, on-chip
  micro-power manager, integer-N LC-PLL with FLL coarse trim,
  Class-E PA.
- Measured: 25 % system efficiency at 0 dBm output, 5.2 nW sleep,
  0.53 mm^2 active area, supply tolerance down to 0.2 V.
- Cite: Sano et al., ISSCC 2018 paper 24.5; Sano et al., "A 0.2-V
  Energy-Harvesting BLE Transmitter With a Micropower Manager
  Achieving 25 % System Efficiency at 0-dBm Output and 5.2-nW
  Sleep Power in 28-nm CMOS," JSSC vol. 54 no. 6, June 2019,
  pp. 1693-1706.  Maturity **G**.
- Relevance: closest published harvested-power BLE TX.  Confirms
  that 4 mW system DC at 0 dBm is the *floor* even at 28 nm.

### K3. Liu / Wentzloff DPLL-centric BLE transceiver in 40 nm
- Process: 40 nm CMOS
- Architecture: all-digital DPLL with single-point polar
  modulator; PA digital polar; "TX/RX switchable on-chip matching
  network."
- Measured: 3.7 mW TX @ 0 dBm, 2.75 mW RX, BLE-spec compliant.
- Cite: Liu et al., "A Bluetooth Low-Energy Transceiver With
  3.7-mW All-Digital Transmitter, 2.75-mW High-IF Discrete-Time
  Receiver, and TX/RX Switchable On-Chip Matching Network," JSSC
  vol. 52 no. 12, Dec 2017, pp. 3274-3286 (Kuo / Ferreira /
  Babaie / Staszewski / Liu et al., TU Delft + Wentzloff
  collaboration).  Maturity **G**.
- Relevance: anchors the digital-polar / DPLL-centric design point;
  silicon proof that all-digital BLE TX can hit < 4 mW at 40 nm.

### K4. Vidojkovic et al. (Imec) two-point ADPLL BLE 5 transceiver
- Process: 65 nm CMOS
- Architecture: two-point modulation in-loop ADPLL + Class-E PA;
  flexible BLE / 802.15.4 / proprietary.
- Measured: 2.9 mW TX @ 0 dBm (BLE), 2.3 mW RX.
- Cite: Vidojkovic et al., "A 0.33 nJ/b IEEE 802.15.4 / 2 Mbps
  proprietary / Bluetooth Low Energy multi-standard radio in
  65 nm," ISSCC 2014 paper 25.6 / dig. tech. papers; also Imec
  Holst Centre 2014.  Maturity **G**.
- Relevance: lowest published TX power at 0 dBm in a BLE-compliant
  design.  TDC area in 65 nm doesn't transport to 180 nm.

### K5. Alghaihab / Chen / Wentzloff crystal-less BLE TX
- Process: 28 nm CMOS
- Architecture: dual on-chip LC-PLL (PLL2 generates LO2),
  digital PA, GFSK modulator open-loop, back-channel WRX at
  -86 dBm sensitivity, **OTA clock recovery from incident
  GFSK-modulated BLE packets**.
- Measured: BLE-spec compliant carrier accuracy, no external
  XTAL, ~ 4 mW TX + ~ 0.5 mW WRX.
- Cite: Alghaihab, Chen, Shi, Truesdell, Calhoun, Wentzloff, "A
  Crystal-Less BLE Transmitter with -86 dBm Frequency-Hopping
  Back-Channel WRX and Over-the-Air Clock Recovery from a
  GFSK-Modulated BLE Packet," ISSCC 2020 paper 30.7; extended in
  Chen et al., "A Crystal-Less BLE Transmitter With Clock
  Recovery From GFSK-Modulated BLE Packets," JSSC 2021.
  Open-access PDF on UMich WICS faculty page.  Maturity **G**.
- Relevance: the literature's strongest crystal-less BLE
  anchor.  Critically, it requires a co-channel cooperative TX -
  does *not* solve the XTAL-less problem for standalone advertisers.

### K6. Kuo / Babaie / Staszewski - Bluetooth Low Energy DPLL TX
- Process: 40 nm CMOS
- Architecture: ADPLL-centric BLE transceiver with hybrid-loop
  receiver; 2.9 mW polar TX (single-point).
- Cite: Kuo et al., "An ADPLL-Centric Bluetooth Low-Energy
  Transceiver With 2.3 mW Interference-Tolerant Hybrid-Loop
  Receiver and 2.9 mW Single-Point Polar Transmitter in 65 nm
  CMOS," ISSCC 2017 / JSSC vol. 52 no. 4 April 2017.  Maturity
  **G**.
- Relevance: corroborates K3 architecture; anchors 2.3 mW RX
  number for downstream comparison.

### K7. Selvakumar / Chandrakasan, FBAR-referenced BLE TX
- Process: 65 nm with FBAR module
- Architecture: BLE TX using bulk-acoustic-wave (FBAR) reference
  resonator instead of a quartz XTAL.
- Cite: Selvakumar / Anantha Chandrakasan, ISSCC 2017 paper
  22.7.  Maturity **G** but **off-PDK**.
- Relevance: best XTAL-less alternative if BAW is available;
  `gf180mcuD` has no BAW.

### K8. Roy et al. (UMich Cubeworks) burst-mode RF TX in 180 nm
- Process: 180 nm CMOS (one of the very few 180-nm radio
  anchors)
- Architecture: narrow-band burst-mode TX fed from a 47 uF off-
  die supercap; sub-1 mW peak; not BLE-compliant (no GFSK
  shaping, narrow channel).
- Cite: Roy et al., ISSCC 2018 paper 24.6; Cubeworks UMich.
  Maturity **G** for *radio area / power floor* in 180 nm; not a
  BLE anchor.
- Relevance: the *only* 180 nm radio anchor in the BLE-related
  silicon literature - and it is *not* BLE-compliant.  This pins
  the conclusion that any 180 nm BLE-compliant TX is process-
  first-of-kind.

### K9. Vidojkovic et al. (Imec / Holst) BLE 9 mW radio
- Process: 90 nm CMOS
- Architecture: full BLE radio (TX + RX); LC-PLL + Class-E PA.
- Measured: 9 mW total radio (2.5 mW RX + 6.5 mW TX).
- Cite: Vidojkovic et al., ISSCC 2011 paper 25.5 / extended JSSC
  vol. 47 no. 7 July 2012.  Maturity **G**.
- Relevance: closest-in-process predecessor; corroborates 6.5 mW
  TX at 0 dBm in 90 nm.

### K10. Prummel et al. - 10 mW BLE transceiver with on-chip matching
- Process: 40 nm CMOS
- Architecture: integer-N LC PLL + Class-E PA, on-chip antenna
  match network, low-IF RX.
- Measured: 4.9 mW TX @ 0 dBm, 4.5 mW RX, BLE-compliant.
- Cite: Prummel et al., "A 10 mW Bluetooth Low-Energy Transceiver
  with On-Chip Matching," ISSCC 2015 paper 22.6 / JSSC vol. 50
  no. 12 Dec 2015.  Maturity **G**.
- Relevance: cleanest reference design at 40 nm; on-chip matching
  network technique transports to 180 nm with 5x area penalty.

## 2. PA topologies (silicon-anchored)

### PA1. Class A
- Reference: Mazzanti TMTT 2006 / Cripps RFPA textbook.
- Measured 180 nm: 25-35 % DE peak; 15-20 % at 0 dBm back-off.
- **Negative for our use case** (constant-envelope GFSK does not
  need linearity; class A is wasteful).

### PA2. Class AB
- Reference: Babaie TCAS-I 2014 (65 nm 2.4 GHz Class-AB).
- Same back-off DE problem at 0 dBm as Class A.

### PA3. Class B push-pull
- Reference: Aoki / Hajimiri JSSC 2002 distributed active
  transformer (Caltech).
- Measured: 50 % DE at +20 dBm in 0.18 um.
- Useful at 0 dBm only with strong drive.

### PA4. Class C
- Reference: Ho / Luong A-SSCC 2009.
- Measured: 55 % DE at +20 dBm; 0 dBm back-off ~ 35 %.
- Hard-driven Class C is a candidate for sub-0 dBm constant-env BLE.

### PA5. Class D voltage-mode
- Reference: Stauth / Sanders, Berkeley 2007 (Stauth thesis "PA
  techniques for switching-mode CMOS RF PAs").
- Measured: 35-45 % DE in 0.18 um at 2.4 GHz, **C_DS-loss
  limited**.
- **Negative**: drain-cap wall makes Class-D V-mode sub-Class-E
  in 180 nm.

### PA6. Class E single-ended
- Reference: Tsai TSMC 0.18 um 2009 (TMTT); Mazzanti TMTT 2006.
- Measured: 55 % DE at +21 dBm (Tsai 2009).  Back-off at 0 dBm
  ~ 38-42 %.
- **Default candidate** for 180 nm BLE Class-E.

### PA7. Class E differential w/ on-chip transformer
- Reference: Mazzanti TMTT 2006; Talbi 2014 (ScienceDirect).
- Measured: 60-65 % DE at +20 dBm; back-off at 0 dBm ~ 45 %.
- Best published efficiency in 180 nm Class-E family but consumes
  ~ 0.2 mm^2 (transformer footprint).

### PA8. Class F / inverse F
- Reference: Lee et al., TMTT 2010 0.18 um Class-F PA.
- Measured: 55-61 % DE at +22 dBm.
- Requires multiple harmonic-tuned LC traps; area-rich.

### PA9. Inverse Class D / Class D-1
- Reference: Calvo TCAS 2017 (65 nm); Reynaert/Steyaert family
  (KU Leuven).
- Measured: 65 % DE at +24 dBm in 65 nm.
- 180 nm port limited by V_DS rating; needs cascode stacking.

### PA10. Digital polar / segmented switching PA
- Reference: Liu/Wentzloff JSSC 2017 (40 nm).
- Measured: 22.6 % system efficiency at 0 dBm.
- **Negative for 180 nm 0 dBm**: driver power dominates at
  back-off.

## 3. Synthesiser topologies (silicon-anchored)

### S1. Integer-N LC PLL
- Reference: Razavi RFIC 2002 textbook + many measured designs.
- 180 nm at 2.4 GHz: 4 mW typical, -115 dBc/Hz at 1 MHz (Metal5
  spiral).
- **Default candidate** for our use case at Metal4 Q ~ 8 -> -110
  dBc/Hz (still 30 dB BLE margin).

### S2. Fractional-N LC PLL
- Reference: Tasca JSSC 46 2011 ("4.5 mW 0.5 GHz to 9 GHz Fractional-N
  PLL with 560 fs RMS jitter").
- Measured 65 nm: 4.5 mW, 560 fs.
- BLE-only does not need fractional-N; overkill.

### S3. Two-point modulation ADPLL
- Reference: Vidojkovic ISSCC 2014; Kuo JSSC 2017; Staszewski
  DRP-1 JSSC 2005.
- 28-65 nm: 1.6-2.9 mW.
- **Does not transport to 180 nm** without massive TDC area
  penalty.

### S4. Free-running ring DCO
- Reference: (negative).  No BLE-compliant published silicon uses
  this.  Hajimiri-Lee bound at -75 dBc/Hz at 1 MHz makes BLE
  mask infeasible.

### S5. Ring DCO + coarse FLL
- Reference: Sano JSSC 2019 uses an LC-PLL but with FLL coarse
  trim during start-up.
- Pure ring + FLL still misses BLE mask.

### S6. Injection-locked LC oscillator
- Reference: Hsieh AICSP 2010 (180 nm 0.9 V 1.4 mW ILO).
- Measured: -110 dBc/Hz at 1 MHz.
- Useful for ULV-supply rails but needs a clean injection
  source.

### S7. BAW/FBAR-locked LC oscillator
- Reference: Salvia JSSC 2010; Lee ISSCC 2013.
- Measured: < 1 mW BLE-compliant carrier.
- **Off-PDK**.

### S8. Crystal-less FLL with OTA clock recovery
- Reference: Alghaihab ISSCC 2020 (cited above).
- BLE-compliant only with cooperative co-channel reference.
- Standalone XTAL-less fails BLE +/- 50 ppm spec.

## 4. Modulator topologies

### M1. Two-point modulation
- Splits modulation HF (DCO direct) and LF (reference divider)
  paths.
- Reference: Staszewski DRP-1 JSSC 2005; Vidojkovic ISSCC 2014.
- Most flexible, used in K3, K4, K6.

### M2. Closed-loop FM
- Modulation through loop filter; bandwidth-limited.
- Reference: Razavi 2002.

### M3. Open-loop modulation post-lock
- Capture LO frequency, open loop, modulate with DCO bank.
- Reference: Liu JSSC 2017.
- Most efficient at low power; risks drift over packet.

### M4. Direct frequency-word injection (ADPLL)
- Digital control word adds GFSK deviation directly.
- Reference: Staszewski TI DRP-1 JSSC 2005; Kuo JSSC 2017.

### M5. Polar / digital amplitude + phase
- Digital polar TX architecture.
- Reference: Liu JSSC 2017 (40 nm digital polar).

## 5. TR-switch topologies

### T1. Series NMOS (single FET)
- Reference: Talwalkar Stanford TMTT 2004.
- 180 nm bulk: 1.5 dB IL, 18-22 dB iso.

### T2. Series-shunt NMOS
- Reference: Yamamoto NTT TMTT 2001.
- 180 nm bulk: 1 dB IL, 28-35 dB iso.

### T3. Stacked-series NMOS
- Reference: Talbot ISSCC 2009.
- For high-V_DS handling on PA-side.

### T4. Lumped LC SPDT
- Reference: Yeh JSSC 2007.
- Off-area expensive (two on-die spirals).

### T5. PD-SOI antenna switch
- Reference: Carroll TMTT 2006.
- **Off-PDK**.

### T6. DC-coupled CMOS pass-gate
- **Negative**: PMOS too slow at 2.4 GHz.

## 6. Burst-mode / energy-aware architectures

### B1. Negative-V_GS leakage gating (Paidimarri JSSC 2016)
### B2. Sub-threshold 0.2 V supply (Sano JSSC 2019)
### B3. Burst-mode supercap-fed (Roy ISSCC 2018)
### B4. State-retention duty-cycling FSM (Vidojkovic 2014)
### B5. Wake-up RX back-channel (Alghaihab 2020)

## 7. Approaches considered and discarded (no silent drops)

- **Software-defined radio + DAC modulation**: 100 MS/s+ DAC
  area infeasible at 180 nm.  No published BLE silicon uses it.
- **Sub-sampling PLL** (Gao JSSC 2009): 22 uW best-in-class but
  XTAL-required.
- **IR-UWB / pulse-shaped non-BLE 2.4 GHz** (Wentzloff 2007):
  violates ISM PSD if mis-applied.
- **Backscatter BLE** (Ensworth UW 2014): cooperative source
  required; not standalone.
- **Passive RFID / LF carrier**: not BLE-compliant.
