---
item: g
item_name: vga-wrapper-cleanup
stage: 1
angle: academic-survey
researcher: claude-opus-4-7-1m Stage-1 academic-survey agent
status: draft
last-updated: 2026-05-02
---

# Components / Sub-blocks

This is item (g) "VGA wrapper cleanup" — purely an HDL / build-flow
item. There are no analog or RF circuit sub-blocks.

The "components" (i.e. the artefacts and tools that participate in
each candidate approach) decompose along these axes:

## RTL artefacts touched

- `vga_screensaver/wrapped_vga.v` — the wrapper module under study.
  Currently exposes a 7-bit `inputs` port; only 5 bits reach
  functional logic in the upstream `tt_um_*`.
- `vga_screensaver/tt-waferspace-vga-screensaver/src/tt_um_waferspace_vga_screensaver.v` —
  upstream Tiny Tapeout module. Bound by the TinyTapeout shuttle
  pin convention (Venn et al., SSC-M 2024); pins `ui_in[7:0]`,
  `uo_out[7:0]`, `uio_*[7:0]`, `ena`, `clk`, `rst_n` are immutable.
  This file is not edited by item (g).
- `src/chip_top.sv` — chip-top integrator. Wires pad outputs
  `input_PAD2CORE[10:4]` into `wrapped_vga.inputs`. The chip-top
  wiring slice changes if the wrapper port narrows.
- `src/chip_core.sv` — aggregates "bonded but unused" pads via the
  `&{...}` discard pattern. If pads `input[6]` and `input[7]` get
  reassigned from the wrapper to chip_core's unused-set, chip_core
  changes.

## Hardened-macro artefacts (LibreLane outputs)

The OpenLANE flow (Ghazy & Shalan, WOSET 2020, Fig. 1) emits each of
these at the end of every macro hardening run. Any RTL port-list
change forces all of them to regenerate:

- `vga_screensaver/runs/latest/final/lef/wrapped_vga.lef` —
  abstract pin geometry; one `PIN <name> ... END <name>` block per
  RTL port. Per-bit for vector ports (i.e. `inputs[0]` ...
  `inputs[6]` are seven separate `PIN` blocks today).
- `vga_screensaver/runs/latest/final/lib/wrapped_vga__*.lib` —
  Liberty timing arcs; one `pin (...) {...}` block per port with
  `direction`, `function`, `timing(...)` arcs.
- `vga_screensaver/runs/latest/final/nl/wrapped_vga.nl.v` and
  `wrapped_vga.pnl.v` — gate-level netlists with explicit module
  port list.
- `vga_screensaver/runs/latest/final/gds/wrapped_vga.gds` — masked
  layout; pin geometry on the macro abstract is emitted from this.
- `vga_screensaver/runs/latest/final/spef/wrapped_vga.spef` —
  parasitic extraction; per-port capacitance values.

## Build-flow artefacts

- `vga_screensaver/config.yaml` — LibreLane configuration. Sets
  `DIE_AREA: [0, 0, 500, 500]`, `CLOCK_PERIOD: 20` (ns), pin-order
  config. Touched only if pin placement strategy changes.
- `vga_screensaver/Makefile` — invokes LibreLane via
  `make project`. Invocation unchanged regardless of which option
  is taken.
- `librelane/slots/slot_1x1.yaml` — chip-top floorplan slot for
  the macro. Independent of macro internal port set per
  Ghazy & Shalan 2020 §III "Recommended Hierarchy".
- `pin_order.cfg` — pin-side / pin-position constraints for the
  macro abstract. Likely needs a width-matching update on B-Acad-1
  (re-harden) options.

## Verification artefacts

- `vga_screensaver/test/` — cocotb testbench. Drives the wrapper's
  `inputs` port; if width changes, the testbench's signal
  declarations must follow.
- Top-level cocotb / Verilog smoke at `tests/` (if present) —
  exercises chip_top wiring; must remain green after any change.
- LVS run scripts (LibreLane builtin) — magic + netgen. Per
  Ghazy & Shalan 2020 §II.D, run automatically post-route. Each
  re-harden runs them.

## Tools (academic citations)

- **Yosys + abc** — synthesis (Wolf & Glaser 2013, cited in
  Ghazy & Shalan 2020 ref [4]). Runs every harden.
- **OpenROAD** — placement, CTS, routing (Ajayi et al., DAC 2019,
  doi:10.1145/3316781.3326334). Runs every harden.
- **Magic** — LEF/GDS extraction (Ghazy & Shalan 2020 ref [13]).
  Emits the `PIN` blocks that change when the port width changes.
- **Netgen** — LVS (Ghazy & Shalan 2020 ref [14]). Verifies the
  re-hardened macro matches its (new) RTL.
- **OpenSTA** — STA (Ghazy & Shalan 2020 ref [8]). Re-runs against
  new Liberty arcs.
- **SPEF_EXTRACTOR** — parasitic extraction (Ghazy & Shalan 2020
  ref [15]). Re-runs.

## What does NOT need to change in any option

- Pad-frame floorplan (`librelane/slots/*`) — pad positions are
  frozen by `TODO.md` constraint #3; chip-top floorplan is
  independent of macro internal ports per Ghazy & Shalan 2020 §III.
- `gf180mcu_fd_io__in_c` pad-cell instantiations — even if pads
  `input[6]/input[7]` become "bonded but unused", the *cell type*
  at fixed (x,y) remains the same.
- Upstream `tt_um_waferspace_vga_screensaver.v` — bound by Tiny
  Tapeout shuttle convention; not edited by item (g).
