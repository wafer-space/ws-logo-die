# (i) Power-domain isolation between VGA and harvested rails — research home

**Goal (from [`TODO.md`](../../../TODO.md#i-power-domain-isolation-between-vga-and-harvested-rails)):**
two independent power islands. The VGA pixel pump runs only from the
existing `DVDD` pads (driven by the monitor when plugged in); LEDs
and NFC core run only from the harvested rail. Either domain can be
live while the other is off.

## Scope of research

1. **GF180MCU multi-domain support.** PDK level: power-pad cell
   options, isolation-cell availability, level-shifter cells, retention
   flops, body-bias / well-isolation requirements. LibreLane-level
   handling: `VDD_NETS` / `GND_NETS`, multi-power-domain flow.
2. **Level-shifter topologies.** Differential, single-ended,
   self-biased, bidirectional. Quiescent leakage, propagation delay,
   max VDD-A vs VDD-B ratio.
3. **Isolation cells.** "Always-on" tie-cells, output-clamp cells.
   What does the PDK provide, and what would have to be hand-rolled?
4. **Pad-frame floorplan.** The existing VGA pads are frozen; new
   harvested-rail VDD/VSS pads must come from currently-unused
   positions. Investigate the pad-frame cells available
   (`gf180mcu_ws_io__dvdd` / `__dvss`) and whether a *quiet* version
   exists for sensitive analog domains.
5. **Brown-out / ramp-sequencing.** Power-on order, behaviour when
   one rail collapses while the other is at nominal. What guards
   against latch-up via ESD diodes that bridge the domains?
6. **Domain crossings around the seal ring.** Seal-ring rules vs
   multi-supply chips. Investigate published examples of multi-domain
   chips on GF180MCU specifically.
7. **`big_logo` interaction.** The logo is currently drawn across all
   metal layers; the PDN must coexist. Investigate whether multi-domain
   PDNs can route through the logo region and what that costs.
8. **Backwards-compatibility boundary.** The existing v1 chip has a
   single domain. The v2 chip's VGA domain *must* electrically
   present the same way to the PCB so a v1 die works on the v2 PCB.
   Investigate any pin-level signal that would be different.

## Status

See [`../INDEX.md`](../INDEX.md).
