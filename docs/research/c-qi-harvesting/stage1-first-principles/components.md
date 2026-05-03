# Components — sub-block inventory (item c, Stage 1 first-principles)

## Common to all five Qi-harvester architectures

| Block | Spec | GF180 device(s) | Estimated area | Estimated power |
|---|---|---|---|---|
| Antenna pad pair | 2 bond pads, ESD-rated ≥ 100 V transient | Custom IO pad with primary diode + secondary clamp | 80×80 µm × 2 = 12 800 µm² | static 0; ESD event ~1 µJ |
| Series ESD diodes | NMOS source-bulk stack to rail and GND, 5 A surge | nfet_06v0_nvt | ~5 000 µm² | ~10 nA leakage |
| Input AC clamp | Diode-connected stack across antenna; clamp ≈ 6 V | 5× nfet_06v0_nvt diode-connected | ~3 000 µm² | ~10 nA leakage off; up to 5 W during transient |
| Bandgap reference | 1.2 V reference; Iq < 1 µA; PVT ±2% | Standard CTAT+PTAT, pfet_03v3 + npn_05p00 | ~10 000 µm² | ~3 µA |
| Rail comparator | Compares rectified rail to BG; 100 ns delay | Diff-pair pfet_03v3 + nfet_03v3 | ~5 000 µm² | ~1 µA |
| Active shunt FET | Sinks up to 1 A peak / 100 mA continuous | nfet_06v0 (W = 5 000 µm) with thermal-limit detect | ~50 000 µm² | static 0; up to 5 W when active |
| LDO pass PMOS | 30 mA max @ 0.2 V dropout; 3.3 V output | pfet_05v0 (W = 1 000 µm) | ~5 000 µm² | up to 6 mW |
| LDO error amp | 60 dB DC; 100 kHz BW | Two-stage op-amp | ~8 000 µm² | ~5 µA |
| Bulk storage cap | 167 nF (µW load through 500 ms idle) | cap_mim_1f5fF | 0.11 mm² | n/a |
| Pre-LDO storage cap | 10 nF on rectified rail | cap_mim_1f0fF (20 V tol.) | 10 000 µm² | n/a |
| Brown-out detector | Trips when harvested-rail VDD < 2.7 V | Comparator with hysteresis | ~3 000 µm² | ~0.2 µA |

**Subtotal common: ≈ 0.23 mm²**, dominated by the bulk storage cap.

## FP-1 (passive PN bridge, free-rider)

| Block | Spec | Device(s) | Area |
|---|---|---|---|
| 4× PN-junction rectifier diodes | 1 A_pk surge each | nfet_06v0_nvt diode-connected, W=1 000 µm | 4 × 1 000 µm² = 4 000 µm² |

**Total FP-1 architecture-specific area: ≈ 4 000 µm² ≈ 0.004 mm².**

## FP-2 (native-NMOS bridge, free-rider)

Same as FP-1 but using native NMOS as the diode body — same area
budget; same architecture-specific area ≈ 0.004 mm². The "win" is
that conduction loss drops from ~36 mW to ~6 mW under 30 mA load.

## FP-3 (active rectifier with detuning regulation)

| Block | Spec | Area |
|---|---|---|
| 4× sync-rect FETs (cross-coupled) | R_on ≈ 0.5 Ω; W = 2 000 µm each | 4 × 2 000 = 8 000 µm² |
| Reverse-conduction comparator | 50 ns delay | 4 000 µm² |
| Detune cap bank (4 × C, switch-selectable) | 4-bit binary-weighted; total ≤ 50 pF | 25 000 µm² |
| Detune controller (small FSM) | Hysteretic; 1 kHz update | 1 500 µm² |

**Total FP-3 architecture-specific area: ≈ 38 500 µm² ≈ 0.04 mm².**

## FP-4 (hybrid bridge, minimum-compliance D2)

Adds (over FP-3):
| Block | Spec | Area |
|---|---|---|
| Cold-start passive bridge | 4× nfet_06v0_nvt diode-connected (small) | 800 µm² |
| ASK load modulator | NMOS shunt across antenna | 1 000 µm² |
| Modulator gate driver | Drives 4 pF in 1 µs | 200 µm² |
| Qi packet framer (HDL) | Manchester encode + CRC-8 + bit-stuff | ~2 kgates synth → 30 000 µm² |
| Qi PT timing reference | LF clock (~10 kHz, ±10 %) | 5 000 µm² |
| LED-charge redirection switch | nfet_05v0 W=200 µm | 200 µm² |
| Charge storage for LED PWM | 50 nF | 25 000 µm² |

**Total FP-4 architecture-specific area: ≈ 100 700 µm² ≈ 0.10 mm².**

## FP-5 (full Qi BPP compliance D3)

Adds (over FP-4):
| Block | Spec | Area |
|---|---|---|
| Full Qi state machine (HDL) | All 6 phases, error handling | ~10 kgates → 150 000 µm² |
| Q-factor measurement | Coil ring-down measurement; 8-bit ADC | 50 000 µm² |
| Calibrated power-loss accounting | P_received calc; 12-bit MAC | 30 000 µm² |
| Identification / Configuration ROM | 256 bits | 5 000 µm² |
| Control Error Packet (CEP) periodic timer | 250 ms timer | 3 000 µm² |

**Total FP-5 architecture-specific area: ≈ 240 000 µm² ≈ 0.24 mm².**

## Cumulative die area estimates

| Architecture | Architecture area | + common | Total Qi-block area |
|---|---|---|---|
| FP-1 | 0.004 | 0.23 | **0.23 mm²** |
| FP-2 | 0.004 | 0.23 | **0.23 mm²** |
| FP-3 | 0.04 | 0.23 | **0.27 mm²** |
| FP-4 | 0.10 | 0.23 | **0.33 mm²** |
| FP-5 | 0.34 | 0.23 | **0.57 mm²** |

For a 1 mm × 1 mm die, FP-1 / FP-2 / FP-3 leave ample budget for
NFC, LED drivers, oscillator, eFuse, and core. **FP-5 leaves
~0.4 mm²** — tight if NFC harvester (b) and (h) NFC core also need
significant area. **FP-4 is a sweet spot.**

## Pad-frame impact

Two new bond pads (the Qi coil's two terminals).

- Compatibility: must align with currently-unused v1 pads. Per
  `TODO.md` R8, this is a placement constraint; circuit design is
  unchanged.
- Pad spec: differential AC-input pads with primary clamp,
  secondary clamp, and ESD bus connections to a dedicated
  harvested-rail ESD ring.
