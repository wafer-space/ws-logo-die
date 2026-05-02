# (b) NFC energy harvesting — research home

**Goal (from [`TODO.md`](../../../TODO.md#b-nfc-energy-harvesting-1356-mhz-hf-two-pin-antenna-loop)):**
rectify the 13.56 MHz HF magnetic field induced in a PCB loop antenna
into a regulated rail capable of running the NFC core (h) and the
LED drivers (f).

## Scope of research

1. **Power budget** — typical reader-to-tag coupling factors (k),
   reader output powers (compliant ranges from ISO/IEC 14443 / 18092
   classes), rectifier efficiencies, expected DC at the regulator
   output for a business-card-sized PCB loop.
2. **Antenna topology** — every PCB-loop antenna geometry used in
   published 13.56 MHz tag designs, including spiral, perimeter,
   meander, and embedded-multilayer variants. Inductance, Q factor,
   self-resonance, and the resulting tuning-cap value required to
   resonate at 13.56 MHz.
3. **Rectifier topology** — every published rectifier suitable for
   13.56 MHz on a 180 nm 5 V process: half-bridge, full-bridge,
   voltage doubler, Greinacher / Cockcroft-Walton, cross-coupled
   active rectifier, gate-bias-bootstrapped active rectifier,
   threshold-cancelling. Diode-drop loss vs gate-drive complexity vs
   start-up behaviour.
4. **Regulator** — LDO topologies that can hold ~3.3 V across a
   3 V – 10 V rectified-input range without external compensation.
5. **Over-voltage protection** — how published tags handle the
   "card sat 0 mm from a strong reader" case where open-circuit Vpk
   can exceed 30 V.
6. **Brown-out detection and rail-startup behaviour.**
7. **Physics sanity check** — the Friis-equivalent for near-field
   inductive coupling at 13.56 MHz: how much DC power is genuinely
   *available*, not just claimed in datasheet typicals.
8. **PDK reality check** — `gf180mcuD` has no Schottky devices.
   Every published number that depends on Schottky behaviour must be
   re-evaluated against what the PDK actually provides
   (diode-connected NMOS / PMOS, native devices if any, ESD diodes
   used in non-standard ways).

## Status

See [`../INDEX.md`](../INDEX.md).
