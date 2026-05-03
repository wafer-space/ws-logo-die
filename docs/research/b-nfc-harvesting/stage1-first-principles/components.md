# Components — sub-block inventory (item b, Stage 1 first-principles)

## Pad-ring components

### Differential antenna pad pair (`ant_p`, `ant_n`)
- 2 bond pads in currently-unused analog-pad slots.
- Custom RF-friendly ESD: standard pad ESD diodes (P-to-VDD,
  N-to-VSS) clamp the negative swing at ~0.7 V — unacceptable for a
  5 V_pk antenna. Options:
  - Series DC-blocking MIM cap to floor the DC level near VDD/2.
  - Custom ESD diode stack with reverse-bias to ~6 V.
  - 5-V flavour clamp transistor in normally-off configuration.
- ESD strategy is OQ-2.

## Front-end tuning bank

### (T-A) Switched-cap parallel tuning bank
- 6-bit binary-weighted MIM cap bank, total ~96 pF range.
- LSB = 1.5 pF (≈ 1000 µm² MIM at 1.5 fF/µm²).
- MSB = 48 pF (≈ 32,000 µm²).
- Switches: 5-V flavour nFETs, sized for Ron ≪ 1/(ωC_segment).
- Switch parasitic: drain-to-substrate capacitance limits effective
  Q at high segment counts.

## Rectifier components

### (R-D) Passive full-bridge — preferred topology family

Four diode-connected MOS:
- (R-D-5V) using `nfet_06v0` diode-connected: Vth ≈ 0.673 V →
  2·Vth = 1.35 V loss.
- (R-D-native) using `nfet_06v0_nvt` diode-connected: Vth ≈ 0.04 V
  → 2·Vth = 0.08 V loss. **Recommended baseline.**
- Sizing: each diode-connected device W/L ≈ 1000/0.6 µm to keep
  Ron < 100 Ω at expected currents (5 mA peak).

### (R-E) Cross-coupled CMOS bridge

- 2 NMOS (`nfet_06v0`, low side) + 2 PMOS (`pfet_06v0`, high side).
- Cross-connected gates (each gate to opposite-phase antenna node).
- W/L: NMOS ≈ 2000/0.6, PMOS ≈ 4000/0.6.
- Body diode of high-side PMOS: provides start-up seed current.

### (R-F) Active comparator-driven bridge

In addition to (R-E):
- 2 high-speed comparators, one per high-side PMOS gate.
- Topology: telescopic / 2-stage with ~30 ns total propagation.
  Bias ~10 µA each.
- Vds-sense network: 5-V flavour resistor divider sized for ~10×
  R_loop loading.
- Aux supply: native-nFET self-bias (R-A start-up) brings up
  V_AUX ≈ 1.5 V before V_REG is up.

## Voltage regulator components

### (V-A) Series LDO
- PMOS pass: `pfet_06v0` W/L ≈ 5000/0.6.
- Error amplifier: standard 2-stage opamp, ~5 µA bias.
- Bandgap reference: classic Brokaw-style; ~1 µA bias.
- Compensation: Miller cap ~5 pF MIM + nulling resistor (poly).
- Soft-start: slow ramp of bandgap reference output.

### (V-B) Shunt regulator
- Stack of 3 diode-connected `nfet_06v0` from V_REG to ground.
- V_REG ≈ 3·Vthn ≈ 2 V.
- Useful only as over-voltage clamp at V_REG.

## Over-voltage clamp components

### (C-A) Static Zener stack
- 8× diode-connected `nfet_06v0` from V_RECT to ground.
- Trip ≈ 8·Vthn = 5.4 V. W/L ≈ 200/0.6.
- Always-on stack-leakage: ~80 nA. Acceptable.

### (C-B) Active shunt clamp
- Resistor divider (poly-poly, 1:2) from V_RECT to ground.
- Comparator: ~10 µA bias, ~100 ns response.
- Shunt nFET: `nfet_06v0` W/L ≈ 5000/0.6, ~100 mA capability.
- Hysteresis: ~200 mV around 4.5 V trip.

## Brown-out detector components

### (B-A) Vth-referenced first-stage BO
- 2 diode-connected `nfet_06v0` from V_REG to ground, midpoint into
  Schmitt inverter.
- Trip at ~2·Vthn ≈ 1.35 V. Quiescent: < 100 nA.

### (B-B) Bandgap-referenced second-stage BO
- Continuous-time comparator (~1 µA bias).
- Bandgap reference (shared with LDO bandgap).
- Hysteresis: ~50 mV around 1.7 V trip.

## Bulk smoothing capacitors

### V_RECT smoothing cap
- 1 nF MIM (~0.67 mm² at 1.5 fF/µm²).
- Sized from 27.12 MHz ripple budget at 5 mA peak load.

### V_REG smoothing cap
- 6 nF MIM (~4 mm² at 1.5 fF/µm²; 3 mm² at 2 fF/µm²).
- Sized from 847.5 kHz modulation droop budget at 300 µA load.
- **Binding area constraint of the design.**

## Modulator interface (cross-cut to (h))

### Modulator transistor
- A large `nfet_06v0` across the antenna differentially.
  W/L ≈ 5000/0.6.
- Driven by (h) NFC core's digital subcarrier output.

## Power-domain crossings (cross-cut to (i))

### Level shifters
- Required at every signal crossing between V_REG and VGA rail.
- For NFC harvest: modulation enable, LED driver enables,
  brown-out indication.
- PDK level-shifter cell: TBD per (i) research (none ship).

## Layout-floorplan notes

- Differential antenna pads adjacent to minimise differential trace
  mismatch.
- Rectifier physically close to antenna pads.
- V_RECT smoothing cap close to rectifier output.
- Clamp (C-B's shunt nFET) close to antenna pads.
- V_REG smoothing cap is the largest single MIM block; benefits
  from being placed under the wafer.space logo.
- Bandgap reference is sensitive to substrate noise; place far from
  rectifier and clamp.
