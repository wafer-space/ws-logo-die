# Cached summary — hadirkhan10/sky130nm-oscillator

**Source URL:** https://github.com/hadirkhan10/sky130nm-oscillator
**Fetched:** 2026-05-02 via WebFetch
**Cited as:** [SKY130-RINGOSC-HK]

## Summary (extracted from WebFetch return)

Seven-stage ring oscillator implemented manually on the SkyWater 130 nm
open-source PDK.

- Composition: 6 inverters + 1 NAND gate (enable input "EN") + 2:1 mux
  (selectable tap "SEL") between the second stage or the last stage,
  giving a high/low frequency option from the same physical chain.
- Cells: all sourced from the SkyWater 130 nm standard cell library
  (`sky130_fd_sc_hd`).
- Layout: cells abutted vertically to save area; M1 for power/ground,
  M1+M2 for signal routing.
- Simulation: digital with IRSIM; analog with ngspice from extracted
  SPICE netlists.
- **Measured frequency: not reported in the README.** Layout-only
  reference design.

## Significance for item (a) industry survey

Confirms the canonical "minimum-viable on-die oscillator" pattern: an
odd number of inverters plus a NAND-gate enable. This pattern is
identical for sky130, gf180mcu, ihp130, and any other CMOS PDK; the
absolute frequency is whatever the inverter gate-delay × 2 × stages
produces under the local PVT.

The README does not provide a measured frequency, which is **typical of
this class of open-source design**: ring oscillators are routinely used
as "cheap and uncalibrated" clocks; nobody calibrates them because
calibration costs more than the rest of the IP put together.

The same author (Hadir Khan) also documents a parametric Python script
to scale the design to N stages.
