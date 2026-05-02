# Open questions (item g, Stage 1 first-principles)

1. **Does cocotb exercise dead bits?** — read
   `cocotb/chip_top_tb.py`. *Decides:* verification diff size
   under G1/G3/G4/G6/G7/G9.
2. **Hardened views committed or regenerated?** — `find` for
   `runs/latest/final` returned nothing in this tree, suggesting
   regen-on-demand. Confirm via `.gitignore` / git history.
3. **Out-of-repo LEF/Lib consumers?** — grep
   `wafer-space/ws-run1` reticle for `wrapped_vga`. *Decides:*
   blast radius of port-width changes.
4. **Is `ui_in[7]=1'b0` deliberate?** — git blame on
   `wrapped_vga.v`. *Decides:* whether to also clean up the
   hardcoded zero.
5. **Smaller-slot variants force a port change?** —
   `src/slot_defines.svh` shows `0p5x1`, `1x0p5`, `0p5x0p5` have
   only 4 input pads, so 7-bit `wrapped_vga.inputs` cannot fit.
   Today moot; changes the framing if those slots ship later.
6. **Does the upstream Tiny Tapeout module's coding style permit
   selective port-tie patterns** like `.ui_in({1'b0,
   internal_status[1:0], inputs[4:0]})` *without* a fork? Yes —
   `ui_in` is a pure input port with no positional contract; the
   wrapper can mux freely. *Decides:* feasibility of G3/G6
   *without* a fork (route status into the wrapper's `ui_in[2:3]`
   slot, where the upstream still discards them via `_unused_ok`
   — a no-op observable behaviour-wise unless the fork happens).
