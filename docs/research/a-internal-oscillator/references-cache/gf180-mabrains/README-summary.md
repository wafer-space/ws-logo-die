# Cached summary — mabrains/gf180mcu_riscv_soc

**Source URL:** https://github.com/mabrains/gf180mcu_riscv_soc
**Fetched:** 2026-05-02 via WebFetch
**Cited as:** [GF180-MABRAINS]

## Summary

GlobalFoundries 180 nm MCU RISC-V SoC for the Caravel-GFMPW1 shuttle
(Google + GlobalFoundries open MPW programme, taped out in late 2022).

The repository's analog-IPs table lists, with DRC / LVS / PEX status
all marked passed:

| IP | Notes |
|---|---|
| `Ring-Osc-3.3vFETs` | Ring oscillator using the 3.3 V FET flavour. |
| `Ring-Osc-5.0vFETs` | Ring oscillator using the 5 V FET flavour. |
| `XTAL-Osc-16M` | Pierce-style crystal-driver targeted at a 16 MHz off-chip crystal. |
| `XTAL-Osc-100M` | Crystal-driver targeted at 100 MHz. |
| (LDO, BGR, amplifiers) | Supporting analog IPs. |

The README does **not** include measured-silicon performance numbers —
the IPs are characterised at simulation level only, with the layout
released under Apache-2.0.

## Significance for item (a)

This is the **closest known prior art on the actual target PDK**. Two
ring-osc layouts already exist (one on each device flavour), pre-DRC /
LVS / PEX clean. They can be lifted directly into a v2-chip floorplan
provided the licence is honoured. The crystal-osc drivers are
independently useful precedent for items (b)/(h)'s NFC carrier path,
should a Pierce-style amplifier ever be needed.

**No measured frequency or accuracy is reported.** Reviewer should add a
"Stage-4 deep-dive" item to actually simulate these in spectre/ngspice
on each PVT corner before relying on them.

## Caution

The Caravel-GFMPW1 chip went to silicon in 2022 but **post-silicon
characterisation results for these specific IPs are not in the
repository as of 2026-05-02**. Reviewer should hunt for any measurement
write-ups in the Mabrains org's other repos before treating the IP as
"silicon-proven".
