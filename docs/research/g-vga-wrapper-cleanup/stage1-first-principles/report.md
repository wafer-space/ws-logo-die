---
item: g
item_name: vga-wrapper-cleanup
stage: 1
angle: first-principles
researcher: claude-opus-4-7-1m — Stage-1 first-principles agent
status: draft
last-updated: 2026-05-03
---

## 1. Executive summary

`wrapped_vga` is a thin wrapper around the upstream Tiny Tapeout module
`tt_um_waferspace_vga_screensaver`. It exposes a 7-bit `inputs[6:0]`
port, but only five of those bits are *consumed*: `cfg_tile`
(`ui_in[0]`), `cfg_solid_color` (`ui_in[1]`), and three gamepad-PMOD
bits (`ui_in[6:4]`). `ui_in[2:3]` reach the macro but are absorbed by
`_unused_ok` and produce no behaviour. The wrapper additionally
hardwires `ui_in[7]=1'b0`.

This report enumerates every distinct *option* for handling the dead
bits (cleanup, repurpose, leave-and-document) and the consequences
each has for bondout stability, RTL diff size, and hardened-views
regeneration. No winner is picked (Stage-1 forbids).

Limits on the search: prior-art surveys are not appropriate for "what
to do with a dead RTL port" — the trade-offs are mechanical
(interface stability, build-flow churn). One upstream literature
reference confirms the Tiny Tapeout `ui_in[7:0]` semantics.

## 2. Requirements as understood

1. Goal (`TODO.md` §(g)): "remove dead inputs from `wrapped_vga` so
   the wrapper actually exposes only the bits the screensaver
   consumes."
2. Frozen bondout (`TODO.md` §"Hard cross-cutting constraints" #3):
   VGA pad positions and types may not move. Constraint binds at the
   *physical pad ring* — RTL-internal wiring between pad output and
   macro instance is unconstrained.
3. Unused-pad tie-off pattern in `chip_core` (`src/chip_core.sv:51-57`)
   must be preserved.
4. Backwards compatibility (`TODO.md`
   §"Backwards-compatibility acceptance criteria") binds the v1 *die*
   on the v2 *PCB*; no constraint on the v2 RTL beyond
   "input[6]/input[7] must not become required for VGA operation".
5. Verify step asks whether `vga_screensaver/runs/latest/final/`
   LEF/Lib must regenerate when port width changes.

## Pin map (cited)

Confirmed via reading
`vga_screensaver/tt-waferspace-vga-screensaver/src/tt_um_waferspace_vga_screensaver.v`
and `vga_screensaver/wrapped_vga.v`:

| `wrapped_vga.inputs` | Macro `ui_in` | Top pad | Status in upstream |
|---|---|---|---|
| `inputs[0]` | `ui_in[0]` | `input[4]` | live — `cfg_tile` (line 37) |
| `inputs[1]` | `ui_in[1]` | `input[5]` | live — `cfg_solid_color` (line 38) |
| `inputs[2]` | `ui_in[2]` | `input[6]` | **dead** — only consumed by `_unused_ok = &{ena, ui_in[7:1], uio_in}` (line 70) |
| `inputs[3]` | `ui_in[3]` | `input[7]` | **dead** — only `_unused_ok` (line 70) |
| `inputs[4]` | `ui_in[4]` | `input[8]` | live — `gamepad.pmod_latch` (line 54) |
| `inputs[5]` | `ui_in[5]` | `input[9]` | live — `gamepad.pmod_clk` (line 53) |
| `inputs[6]` | `ui_in[6]` | `input[10]` | live — `gamepad.pmod_data` (line 52) |
| (n/a) | `ui_in[7]` | (not bonded) | wrapper hardwires `1'b0` at `wrapped_vga.v:15` (`.ui_in({1'b0, inputs})`) |

Wiring at `src/chip_top.sv:213` is `.inputs(input_PAD2CORE[10:4])` —
7 bits.

## 3. Solution-space map

### Family A — Strict cleanup (no functional change)

**G1 — Reduce wrapper to 5 bits, fix dead pads at constants.**
`wrapped_vga.inputs` becomes `[4:0]`. `chip_top.sv` selects only the
five live pad outputs (`input[4]`, `input[5]`, `input[8]`,
`input[9]`, `input[10]`). Pads `input[6]` and `input[7]` join
`chip_core`'s "bonded but unused" set. Smallest exposed-interface
change; biggest re-harden delta because the LEF/Lib abstract
changes.

**G2 — Leave wrapper unchanged; document `ui_in[2:3]` as dead.**
Zero RTL change; README pinout updated. Hardened views remain
valid; no re-harden. Wrapper continues to *misrepresent* its
surface area, contradicting "cleanup."

### Family B — Repurpose the dead bits productively

**G3 — Route `chip_core` debug/status outputs into `ui_in[2:3]`.**
Two bits become inputs to the macro from `chip_core` (e.g. palette
index, frame counter LSBs, brown-out flag). Macro itself still
discards them via `_unused_ok` *unless* upstream `tt_um_*` is forked
to consume them. Without a fork, this is repainted G2.

**G4 — Pre-allocate dead pads as eFuse-control inputs (item j).**
Item (j) needs program-enable, sense-amp strobe, and clock pins.
Today (j) has no committed pin spec, so this is a placeholder.
Risks mismatch with whatever (j) actually wants.

**G5 — Repurpose dead pads as harvested-power monitoring outputs.**
*Infeasible*: `input[6:7]` use the `gf180mcu_fd_io__in_c` input-only
pad cell (`src/chip_top.sv:92-105, 110`). Driving outputs requires
`bi_24t` or similar; cell swap at fixed (x,y) violates the frozen-
bondout constraint at cell-type granularity (different keep-out,
ESD, bondwire impedance).

**G6 — Tie dead bits to deterministic test pattern (LFSR / counter
/ chip-ID stamp).** Useful only if the macro consumes those bits —
see G3. Without consumption, observable behaviour is identical to
G2.

### Family C — Silly but listable

**G7 — Wire dead bits to (f)'s LED-twinkle LFSR as debug input.**
External pattern injection via bonded pads. Requires (f) to exist
and (i) cross-domain isolation, since `input[6:7]` are on the VGA
rail and the LED LFSR runs on the harvested rail.

**G8 — Hardwire dead bits at constants *inside* the wrapper, keep
the 7-bit port.** Internal cleanup only; LEF/Lib unchanged → no
re-harden. Wrapper surface still *looks* 7-bit. G2-with-internal-
tidiness.

**G9 — Mux dead bits post-fab via eFuses (j) into one of {0, 1,
ext-pad, status}.** Maximally flexible; massively over-engineered
for two bits. Item-(j)-driven feature, not item-(g) cleanup.

### Considered and discarded without a slot

- **Remove the pads entirely** — eliminated by frozen-bondout.
- **Swap input[6:7] to Schmitt-trigger** — out of scope; doesn't
  address dead-bit cleanup.

## 4. Sub-block breakdown

What changes per option:

| Option | `wrapped_vga.v` | `chip_top.sv` | `chip_core.sv` | `pin_order.cfg` | hardened views | cocotb tb | upstream `tt_um_*` |
|---|---|---|---|---|---|---|---|
| G1 | port + instance | wire selection | unused agg. | width match | **regenerate** | minor update | unchanged |
| G2 | none | none | none | none | reuse | unchanged | unchanged |
| G3 | new internal wire | export from `chip_core` | new debug output | possibly | regenerate | extend | **fork required** |
| G4 | depends on (j) | depends on (j) | depends on (j) | depends on (j) | regenerate | extend | unchanged or fork |
| G5 | blocked | blocked | blocked | n/a | n/a | n/a | n/a |
| G6 | new logic | unchanged | unchanged | unchanged | regenerate | unchanged | depends on G3 |
| G7 | debug-input wires | cross-domain wiring | new debug output | unchanged | regenerate | extend | unchanged or fork |
| G8 | internal logic only | unchanged | unchanged | unchanged | **reuse** | unchanged | unchanged |
| G9 | huge | depends on (j) | depends on (j) | unchanged | regenerate | extend | unchanged |

Practical distinction: **G1/G3/G4/G6/G7/G9 change the visible port
set and force a re-harden; G2 and G8 leave the port set intact.**

## 5. First-principles sanity checks

**5.1 Re-harden cost.** LibreLane on the existing config
(CLOCK_PERIOD 20 ns, DIE_AREA 500×500 µm, `vga_screensaver/config.yaml`)
runs end-to-end. The macro's logic is modest (128-pixel logo bitmap
ROM, palette LUT, sync generator, gamepad debouncer, two FSMs) —
synthesis + P&R for a sub-mm² macro on `gf180mcuD` is single-digit
minutes. Existing successful run via `make project` in
`vga_screensaver/Makefile` confirms feasibility.

**5.2 LEF macro abstract pin enumeration.** LEF requires explicit
`PIN <name>` blocks per signal crossing the macro boundary; the
abstract is *not* parameterised. Each bit of a vector is a
separate `PIN inputs[0]` … `PIN inputs[6]` block carrying
direction, layer, geometry, USE class. Liberty (.lib) is similarly
per-pin: each `pin (...)` block carries timing arcs, function,
capacitance. **Therefore any width change in `wrapped_vga.inputs`
necessarily changes the LEF and Lib at the line level — PIN blocks
added/removed, geometry rectangles for removed pin metal stubs
disappear, `outputs[7:0]` PINs likely re-pack, timing arcs drop. No
in-place edit preserves a well-formed LEF/Lib while shrinking the
port; a re-harden is required.**

**5.3 Re-hardening does not perturb pad placement.** The macro is
hardened *separately* from `chip_top` (fixed-position GDS dropped
into chip-top P&R per `librelane/slots/slot_1x1.yaml`). Chip-top
pad-frame floorplan is independent of macro internal port set. As
long as `chip_top.sv` keeps instantiating the same set of pad cells
at the same positions, bondout is preserved.

**5.4 No physics limit applies.** No Carnot/Friis/Shannon/Faraday
claim in this item. Section included for template compliance.

## 6. References

See [`references.md`](references.md). Two references; both are
interface-semantics rather than performance numbers.

## 7. Negative results

**7.1 Pre-allocation to (j) eFuse control (G4) doesn't work today.**
Tried to write a concrete G4 sub-spec (which control bits, which
order, which polarity). Abandoned because (j) has no Stage-1
output yet (per `docs/research/INDEX.md`); pre-allocating bits
without a named consumer is methodology-prohibited guesswork.
Parked as Stage-3 candidate for after (j) Stage-1 lands.

**7.2 G5 is fundamentally infeasible.** `input[6:7]` use
`gf180mcu_fd_io__in_c` input-only cells. Driving outputs requires a
different cell; cell-type swap at fixed (x,y) violates the
frozen-bondout constraint at cell-type granularity (changes
keep-out, layer stack, ESD design, bondwire impedance).
Eliminated.

**7.3 G2 is rhetorically tempting but fails the goal definitionally.**
TODO.md goal is "remove dead inputs from `wrapped_vga` so the
wrapper actually exposes only the bits the screensaver consumes."
G2 leaves the wrapper exposing 7 bits while only 5 are consumed;
satisfies the Verify step (no re-harden) but not the Goal.
Rejected on definitional grounds, not technical.

## 8. Open questions

See [`open-questions.md`](open-questions.md).

## 9. Comparison readiness

| Approach | Headline behaviour | Re-harden? | RTL diff | Bondout impact | Best fit | Worst fit |
|---|---|---|---|---|---|---|
| G1 | dead bits removed, pads stay bonded-but-unused | **yes** | small (~10 lines) | none | "honest interface" | "minimum churn" |
| G2 | no change | no | zero | none | "minimum churn" | "honest interface" — fails goal as written |
| G3 | dead bits become observability inputs | yes | medium; **fork required** | none | "use the silicon" + fork OK | "no-fork" priority |
| G4 | pre-allocate for (j) | yes (when (j) lands) | unknown | none | "Phase-1 dovetail" | today (no (j)) |
| G5 | infeasible at `input[6:7]` | n/a | n/a | **violates frozen-bondout** | n/a | n/a |
| G6 | building block under G3 | yes | trivial | none | as G3 sub-component | standalone |
| G7 | cross-domain debug feature | yes | medium-large | none if (i) handles | future-proofing | today |
| G8 | port-stable internal cleanup | **no** | small | none | "stable LEF/Lib" priority | "honest interface" priority |
| G9 | post-fab configurable per-bit | yes | large | none | "showcase (j)" | "two bits don't justify it" |

**Property:** no option *both* satisfies the literal cleanup goal
*and* avoids re-hardening, except G8 (which preserves the port at
the cost of a still-misleading surface). G2 satisfies neither. G1
satisfies the goal at the cost of a re-harden.

## 10. Author's notes

- The easy recommendation would be "do G1, it's what the TODO
  already drafts." The brief forbids picking — enumerate and stop.
- G3, G6 and G9 converge on *unused bits in a hardened macro's port
  are an opportunity, not garbage*. Whether to take it depends on
  Stage-3 criteria not specified in the brief.
- The frozen-bondout constraint kills every "use these as outputs"
  option. Narrows the solution space drastically — appropriate,
  since the constraint is the entire point of bonding compatibility.
