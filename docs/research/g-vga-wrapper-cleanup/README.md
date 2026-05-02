# (g) VGA wrapper cleanup — research home

**Goal (from [`TODO.md`](../../../TODO.md#g-clean-up-the-vga-wrapper)):**
remove dead inputs from `wrapped_vga` so the wrapper exposes only the
bits the screensaver actually consumes.

## Scope of research

This is the *smallest* item in the programme by a wide margin. It is
mostly an HDL-edit task with no real research load. The Stage-1
research (single round, single angle is acceptable) should still
cover:

1. **What ports the upstream `tt_um_waferspace_vga_screensaver`
   module actually uses** — already known from the in-tree analysis
   (cfg_tile, cfg_solid_color, two dead-end bits, three gamepad-
   PMOD bits).
2. **What hardened views (`vga_screensaver/runs/latest/final/`)
   would need to be re-generated** if `wrapped_vga.v`'s port list
   changes — a hardened LEF / Lib pins-down the abstract interface,
   so a width change forces a re-harden. Confirm.
3. **Whether the dead-end bits could be productively repurposed at
   the wrapper level** — e.g. routed back out of the macro as
   `chip_core` test points rather than dropped.

This item has a relatively narrow research load and a single-stage
methodology may be sufficient. The decision to skip Stage 2/3 must
itself be justified.

## Status

See [`../INDEX.md`](../INDEX.md).
