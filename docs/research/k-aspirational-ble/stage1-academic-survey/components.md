# Sub-block / component breakdown - academic angle

For each architecture in `solutions.md`, this file lists the
sub-blocks that an implementation would need on `gf180mcuD`
180 nm bulk CMOS, with measured-silicon precedent and an explicit
note where the 180 nm port is non-trivial.

## 1. RF front-end

### 1.1 Antenna match (lumped LC pi or T)
- 1.5-3 nH series + 0.5-1 pF shunt; sized to 50 ohm.
- Spirals on Metal4 (Metal5 reserved for logo) - 1.5x lower Q than
  Metal5; phase noise penalty ~ 3 dB.
- Reference: Razavi RFIC 2002; Mohan TMTT 1999 (spiral inductor
  models).

### 1.2 TR switch (T2 series-shunt NMOS)
- 5 V NMOS (gf180mcuD nfet_06v0) for V_DS rating.
- W ~ 100 um; R_on ~ 3 ohm; C_off ~ 80 fF.
- Reference: Yamamoto TMTT 2001.

### 1.3 ESD / pad
- Standard pad cell; SCR-based ESD for the antenna pin (handled
  by gf180mcu_fd_io library).

## 2. Power amplifier (Class-E single-ended baseline)

### 2.1 Switch transistor
- nfet_06v0, W ~ 200 um, L = 0.7 um.
- ID_sat ~ 60 mA; supports 0 dBm with margin.
- Cite: Tsai TSMC 0.18 um 2009.

### 2.2 Drain choke inductor
- 4 nH on Metal4 spiral (~ 0.05 mm^2).
- Q ~ 8 at 2.4 GHz.

### 2.3 Drain shunt cap
- 0.5-1 pF MIM, low-loss.

### 2.4 Series tank (load network)
- 1.5 nH + 1.5 pF tuned to 2.4 GHz.

### 2.5 Driver chain
- Tapered inverter stack from 0.5 um -> 5 um -> 50 um.
- Cite: Paidimarri JSSC 2016 (gating technique).

### 2.6 Sleep gating (negative-V_GS bias generator)
- Charge pump generates -V_th_n during off-state.
- Cite: Paidimarri JSSC 2016.

## 3. Frequency synthesiser (S1 integer-N LC PLL baseline)

### 3.1 LC tank
- 5 nH spiral on Metal4 (Q ~ 8); 1 pF MIM trim bank (8 bits).
- Cite: Razavi 2002; Mohan TMTT 1999.

### 3.2 VCO core
- NMOS cross-coupled pair, 4-bit C-bank trim, 0.5 mA tail bias.
- Cite: Hajimiri-Lee phase-noise theory.

### 3.3 Buffer + divide-by-2 prescaler
- CML / dynamic divider; 0.3 mA at 2.4 GHz.

### 3.4 PFD + charge pump
- Dead-zone-free PFD; 100 uA CP.

### 3.5 Loop filter (passive)
- 100 pF + 5 kohm + 10 nF (off-die or large on-die MIM).
- 10 nF on-die @ 2 fF/um^2 -> 5000 um^2 = 0.005 mm^2.

### 3.6 Multi-modulus divider
- /N divider for BLE channels 37/38/39 (/940 / /941 / /942).

### 3.7 Reference oscillator
- **Open problem.**  No XTAL allowed.  On-die RC + FLL during
  preamble has +/-1-5 % tolerance (sub-spec for BLE +/- 50 ppm).
- Cite: Alghaihab 2020 (only via cooperative co-channel ref).

## 4. Modulator (M1 two-point baseline)

### 4.1 GFSK shaper
- Digital BT = 0.5 Gaussian filter; 4-bit DAC into VCO trim bank.

### 4.2 LF path
- Reference-divider modulation through loop filter.

### 4.3 HF path
- Direct DCO control word.

## 5. Storage cap and PMU

### 5.1 Storage cap
- **Off-die mandatory.**  No published BLE silicon stores burst
  energy on-die.
- Required: 1-4 uF off-die ceramic.
- Cite: Roy ISSCC 2018 (47 uF supercap).

### 5.2 LDO / bandgap / brown-out detector
- gf180mcu_fd_ip blocks (or custom).

### 5.3 Wake-up FSM with state retention
- Ultra-low-power wake-up timer + advert-burst FSM.
- Cite: Vidojkovic 2014.

## 6. Digital baseband

### 6.1 Link-layer FSM
- BLE adv FSM (CONNECT_REQ unsupported in TX-only mode).

### 6.2 CRC-24 + whitening + packet builder
- Standard combinational logic; ~ 5-10 kgates.
- Cite: Apache NimBLE controller (Apache 2.0).

### 6.3 Wake-up timer
- 32 kHz LF oscillator (ULP RC; +/-2 % accuracy acceptable for
  100-ms-interval timing but not BLE PHY).

## 7. Optional minimal RX (R1)

### 7.1 LNA + envelope detector
- Cite: Pletcher 52 uW WRX (Pletcher JSSC 2009).

### 7.2 Demodulator
- Simple differential GFSK demod for SCAN_RSP.

## 8. Test / debug

### 8.1 Internal scan chain.
### 8.2 Spectrum-out test pad (TR-switched).

## Notes on 180 nm porting

Every sub-block above carries a *port-uncertainty* tag because
**no measured-silicon precedent exists at 180 nm** for the BLE-
compliant integration of these blocks.  Specifically:

- Synth: 4 mW figure ports from Razavi 2002 textbook 0.18 um
  measured PLLs; well-anchored.
- PA: 40 % DE at 0 dBm ports from Stauth 2007 / Tsai 2009 back-off
  fits; well-anchored.
- TR switch: T2 series-shunt 28 dB iso ports from Yamamoto 2001;
  well-anchored.
- **Whole-chip integration in 180 nm: process-first-of-kind.**
