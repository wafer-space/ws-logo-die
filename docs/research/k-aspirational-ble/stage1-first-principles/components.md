# Components — sub-block inventory (item k, Stage 1 first-principles)

## C1. PA core (any class A1–A10)

- **Pre-driver / buffer.** Translates synth output (≈100 mV swing)
  to PA input drive (≈Vdd_PA swing). 1–2 stages, ≈0.05 mm².
- **Output matching network.** On-die L (spiral, 0.5–5 nH;
  Q ≈ 8–15 on Metal4) + on-die C (MIM, 0.1–5 pF) → 50 Ω at
  antenna pad.
- **Bondwire model.** ≈1 nH/mm; must be in match calculation.
- **ESD protection at antenna pad.** Sub-pF effective.
- **Bias control.** Bandgap + current mirror; only relevant for
  class A/AB/B/C.
- **Gate-drive supply.** Decoupled rail (~10–50 pF MIM local
  decap).
- **Drain choke (RFC) for Class E/F.** On-die spiral, 5–20 nH.

## C2. Synthesiser core (S5 LC-VCO + integer-N PLL, default)

- **LC tank.** Spiral L ≈ 4–6 nH (Metal4) + MIM C ≈ 0.6–1.2 pF.
  Tank Q ≈ 8–12.
- **Cross-coupled negative-Gm pair.** `nfet_03v3`, low Vov,
  fT ≈ 41 GHz.
- **Tail current source + bias.** ≈1 mA.
- **Channel-select cap-bank.** 3-position switched-cap for channels
  37/38/39.
- **Modulating varactor.** cap_nmos_03v3 / MIM-based switched
  binary-weighted segment for GFSK ±250 kHz.
- **/2 divider (CML latch pair).** 2.4 GHz → 1.2 GHz internal LO.
- **Multi-modulus divider** (programmable N).
- **Phase-frequency detector + charge pump.** CP current
  50–500 µA programmable.
- **Loop filter.** On-die R + C; 2nd or 3rd order. Loop BW
  ≈300 kHz.
- **Reference path.** From (a) internal oscillator, ÷ or × to
  bring to 1–24 MHz reference.

## C3. Modulator (GFSK)

- **Gaussian shaping filter.** BT = 0.5 per BLE spec. Digital FIR
  (4–8 tap) → ΣΔ DAC.
- **±250 kHz peak frequency deviation control word.** 8–10 bit DAC
  driving modulating varactor.
- **Two-point injection driver (M1 only).** ΣΔ on reference side
  + analog summing on VCO varactor side.
- **Whitening LFSR.** Per BLE Core 5.x §3.2.
- **CRC-24 generator.** Per BLE Core 5.x.

## C4. TR switch (default T2 series-shunt for >35 dB)

- **Series NMOS** in PA→antenna path. nfet_06v0, W ≈ 200 µm.
  R_on ≈ 5 Ω.
- **Shunt NMOS** to ground in antenna→harvester path during TX.
- **Body bias / well bias.**
- **Gate driver with level shifter.**
- **DC-blocking caps.** ≈10 pF MIM on each switch port.

## C5. Storage / decoupling capacitance

- **MIM-cap bank.** cap_mim_2f0fF density 2 fF/µm². Sized per §5.7.
- **Local PA-rail decap.** ≈100 pF MIM near PA drain.
- **Synth-rail decap.** ≈50 pF MIM near VCO tail.
- **MOS-cap fill.** `cap_nmos_03v3` wherever there is unused
  logic-fill area.

## C6. Digital LL controller (R0 TX-only)

- **Advert state machine.** Idle → setup → ADV_TX(37) →
  ADV_TX(38) → ADV_TX(39) → idle.
- **Header / address packet builder.**
- **Whitening + CRC engines.**
- **Inter-frame timer.** 32 kHz tick from (a).
- **Power-management interface.** Brown-out detect.

## C7. Digital LL controller (R1 TX + SCAN_RSP)

Adds to C6:
- **150 µs scan window after each ADV_IND.** RX path enabled.
- **Address filter.**
- **SCAN_RSP packet builder.** Static payload.
- **Frame sync detector.** 32-bit access address match.

## C8. RX path (R1 only)

- **LNA.** Cascode `nfet_03v3` input, 1.5 mA bias for NF ≈ 5–8 dB.
- **Mixer (Gilbert cell).**
- **Channel filter.** On-die low-pass; corner ≈500 kHz for 1 Mbps
  GFSK.
- **GFSK demodulator.** Limiter + frequency discriminator.
- **Frame sync + address match.**

## C9. eFuse-backed configuration

- **MAC address (6 B).**
- **PLL trim (8 b).**
- **PA bias trim (8 b).**
- **Channel-cap-bank trim (4 b).**
- **Misc identity / serial (32–64 b).**
- **Total ≈ 80–120 b.** Negligible vs (j)'s likely 256+ b budget.

## C10. Power-management hooks

- **Brown-out detector** on harvested rail.
- **TX-deferral controller.** When V_rail < V_BO, BLE state machine
  waits.
- **Storage-cap top-up gate.**
- **Inter-domain interlock.** Per (i) — BLE TX must run only off
  harvested rail; level shifters on every cross-domain signal.

## Summary area / power budget (R0 TX-only)

| Block | Area (mm²) | Avg power @ 100 ms (µW) | Peak power (mW) |
|---|---|---|---|
| PA + match + RFC | 0.05 | 25 | 1.7 |
| LC-VCO + tank | 0.18 | 30 | 2.0 |
| PFD/CP/divider/LF | 0.10 | 15 | 1.0 |
| Modulator | 0.02 | 5 | 0.3 |
| TR switch | 0.01 | <1 | <0.1 |
| Digital LL (R0) | 0.05 | <2 | <0.3 |
| Storage cap (1.5 µF target) | **3.0** | n/a | n/a |
| **Total radio (excl. cap)** | **0.41** | **78** | **5.4** |
| **Total incl. burst cap** | **3.4** | **78** | **5.4** |

Burst-cap area dominates → see open-questions Q1.
