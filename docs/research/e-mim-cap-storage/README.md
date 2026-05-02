# (e) On-die MIM cap arrays for energy storage — research home

**Goal (from [`TODO.md`](../../../TODO.md#e-on-die-mim-cap-arrays-for-energy-storage)):**
provide the bulk capacitance that smooths the harvested rails and
sustains brief LED-twinkle / NFC-modulation current pulses. No
external capacitors permitted.

## Scope of research

1. **Capacitor families available in `gf180mcuD`.** MIM (single,
   double, triple metal-pair stack), MOM / fringe / MoM-like
   inter-metal, MOS cap (accumulation, inversion, depletion mode),
   poly-poly, deep-trench, ferroelectric (if any). Per-PDK numbers:
   F/µm², voltage rating, leakage, voltage coefficient, temperature
   coefficient.
2. **Density and area cost.** What's the realistic area for 1 nF,
   10 nF, 100 nF, 1 µF on `gf180mcuD`? Cross-check at least two
   sources (PDK docs, published design papers using the same
   process).
3. **Energy budget vs cap size.** Sanity: how much actually-needed
   bulk capacitance survives once the harvested current keeps
   replenishing? Calculate for each consumer (LED twinkle pulse, NFC
   modulation cycle, eFuse-program peak, BLE TX burst).
4. **Floorplan strategy.** The logo (`big_logo`) is currently drawn
   across all metal layers. Audit which metal-layer pairs are
   actually used, and which are *effectively free* for MIM stacks.
   Investigate placing MIM caps under the logo, the seal ring, and
   the pad ring.
5. **Density-rule interaction.** The current chip already has the
   `KLAYOUT_FILLER_OPTIONS: Metal2_ignore_active: true` workaround
   because it cannot meet Metal2 density. Adding large MIM arrays
   shifts metal-density distributions — investigate whether MIM
   counts as active or filler under GF180MCU rules.
6. **Switched-cap / charge-pump alternatives.** Storing energy as
   "voltage on a small cap, periodically pumped" rather than "lots of
   cap at fixed voltage" is a real architecture choice. Survey both.
7. **Physics sanity check.** ε₀ε_r/d gives an upper bound on cap
   density; published claims that exceed it are wrong. Verify any
   "high-density" claim is consistent with the dielectric thicknesses
   and constants in the PDK.

## Status

See [`../INDEX.md`](../INDEX.md).
