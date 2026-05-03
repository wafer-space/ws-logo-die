---
item: g
item_name: vga-wrapper-cleanup
stage: 1
angle: industry-survey
researcher: claude-opus-4-7-1m (auto-mode subagent, parallel instance 1 of 2)
status: draft
last-updated: 2026-05-03
---

## 1. Executive summary

This report addresses item **(g) VGA wrapper cleanup**: the in-tree
`wrapped_vga.v` exposes a 7-bit `inputs` port to the chip-level
integrator while the upstream TinyTapeout module
`tt_um_waferspace_vga_screensaver` consumes only five of the eight
`ui_in[7:0]` bits. This report surveys what *industry practice*
(TinyTapeout community, OpenLane / LibreLane macro hardening flow,
vendor IP wrappers, SoC integration patterns) does in equivalent
situations.

Headline conclusions:

- The upstream macro reads exactly five `ui_in[…]` bits as
  functional inputs (`ui_in[0]`, `ui_in[1]`, `ui_in[4]`, `ui_in[5]`,
  `ui_in[6]`) and explicitly discards the rest with `_unused_ok =
  &{ena, ui_in[7:1], uio_in}` (line 70 of upstream RTL). The wrapper
  currently passes 7 bits of which two (`inputs[1:2]`, equivalent
  to `ui_in[2:3]`) are functionally dead.
- Industry convention is **split**: the TinyTapeout upstream culture
  treats the 8-bit `ui_in` interface as immutable and tolerates large
  numbers of unused bits, while the more general SoC-integration
  culture (vendor IP wrappers, OpenTitan, BlackParrot, LiteX) trims
  ports aggressively at every wrapper boundary. Both are valid;
  they optimise for different things.
- Eight distinct options for handling the dead bits are catalogued
  in §3.
- The hardened-LEF question has a clear verdict: **a port-list
  change on `wrapped_vga.v` requires a full LibreLane re-harden of
  that macro**. There is no in-place LEF/Lib edit path that survives
  an LVS check.

## 2. Requirements as understood

- **R1.** Remove dead inputs from `wrapped_vga.v` (TODO.md §(g)).
- **R2.** Keep cocotb smoke passing.
- **R3.** A LibreLane re-harden may be required.
- **R4.** Existing VGA pad positions are frozen at the chip-top
  level; the wrapper's port list is an *internal* interface only.
- **R5.** Do not silently drop functionality.

What is **not** required: the wrapper port width does *not* have to
equal eight. The TinyTapeout `info.yaml` "DO NOT delete or add any
pins" rule binds `tt_um_waferspace_vga_screensaver` (TT-shuttle
compatibility), not `wrapped_vga.v`.

## 3. Solution-space map

### 3.1 Family A — "Don't touch the wrapper"

- **A1. `noop-document`** — Leave wrapper as-is, document the dead
  pins. Zero RTL change. Used in industry: the upstream `info.yaml`
  empty-string entries; the TinyTapeout community pattern.
  Performance: zero churn, zero tooling impact, hardened views
  remain valid.
- **A2. `noop-tieoff`** — Keep `inputs[6:0]`, but make tie-offs
  explicit inside the wrapper. Used in industry: standard ARM AMBA
  bus-wrapper convention. Performance: minor RTL change, no
  port-list change, no re-harden.

### 3.2 Family B — "Reduce the port"

- **B1. `reduce-5bit`** — Shrink to `input [4:0] inputs`; re-pack
  inside as `.ui_in({1'b0, inputs[4:2], 2'b00, inputs[1:0]})`;
  update `chip_top.sv` slice. Used in industry: dominant pattern
  *outside* TinyTapeout — OpenTitan `comportable` blocks, LiteX
  vendor-IP wrappers, Synopsys DesignWare, Cadence Tensilica,
  Arm Cortex-M peripheral blocks. **Aligns most directly with R1.**
- **B2. `reduce-and-rename`** — As B1, but with named ports
  (`input cfg_tile, cfg_solid_color, gpad_latch, gpad_clk,
  gpad_data`). Used in industry: AXI peripherals' side-band
  signals; Wishbone slave wrappers. **More** coupled to upstream
  than B1.

### 3.3 Family C — "Repurpose the dead bits"

- **C1. `repurpose-test`** — Route dead bits to test/DFT outputs.
  Used in industry: every commercial SoC. Cost: scope creep into
  DFT.
- **C2. `repurpose-efuse`** — Connect dead bits to/from a future
  eFuse OTP block (item (j)). Standard for ASICs with OTP. Cross-
  phase dependency = no for v2.
- **C3. `repurpose-power-monitor`** — Use the dead chip-top *pads*
  as analog test points. Conflates pad-level and macro-level —
  doesn't address (g)'s scope.

### 3.4 Family D — "Hybrid"

- **D1. `hybrid-reduce-and-bond`** — Shrink wrapper (B1) *and*
  reassign the freed chip-top `input_PAD[6]`/`input_PAD[7]` to other
  purposes (e.g. NFC differential antenna feed). Pad-frame
  compaction is *normal* on ASIC respins.

### 3.5 Approaches considered and discarded

- **`physical-only`** (delete the pads at chip-top): wrong layer —
  TODO.md constraint 3 freezes pad positions.
- **`use-uio`** (route dead `ui_in` via the wrapper's `uio_in`):
  upstream module already discards `uio_in` (line 70). Lateral
  shuffle, no progress.
- **`add-config-pins`** (more config bits beyond the five upstream
  consumes): impossible without modifying foreign IP.
- **`software-only`** (handle in firmware): this die has no firmware.

## 4. Sub-block breakdown

| Option | `wrapped_vga.v` | `chip_top.sv` | hardened views | cocotb tb |
|---|---|---|---|---|
| A1 | comments only | none | reuse | unchanged |
| A2 | small RTL change | none | reuse | unchanged |
| B1 | port + instance | wire selection | **regenerate** | minor update |
| B2 | + pin names | + pin_order.cfg | regenerate | unchanged |
| C1 | new test mux | + test enable | regenerate | extend |
| C2 | depends on (j) | depends on (j) | regenerate | extend |
| C3 | n/a (chip-top pad change) | pad-cell type change | regenerate | unchanged |
| D1 | as B1 | + slot YAML edit | regenerate | minor update |

## 5. First-principles sanity checks

### 5.1 "5 bits, not 7"

From `tt_um_waferspace_vga_screensaver.v`:

- `ui_in[0]` — line 37: `wire cfg_tile = ui_in[0];` — **used.**
- `ui_in[1]` — line 38: `wire cfg_solid_color = ui_in[1];` — **used.**
- `ui_in[2]` — only inside `_unused_ok` (line 70). **Unused.**
- `ui_in[3]` — same. **Unused.**
- `ui_in[4]` — line 54: `.pmod_latch(ui_in[4])` — **used.**
- `ui_in[5]` — line 53: `.pmod_clk(ui_in[5])` — **used.**
- `ui_in[6]` — line 52: `.pmod_data(ui_in[6])` — **used.**
- `ui_in[7]` — only inside discard at line 70. **Unused.**

Used = {0, 1, 4, 5, 6}, count = **5**.

### 5.2 "Re-harden required if port list changes"

A LibreLane Classic-flow harden produces, in `runs/<tag>/final/`,
a LEF (abstract pin geometry), Lib (timing arcs pin-to-pin),
gate-level netlists (`*.nl.v` / `*.pnl.v`, with explicit module
port list), GDS, and SPEF. Every artefact carries the port list.

There is no in-place edit path for any of those that survives LVS
at chip-top integration. **Conclusion: a re-harden is required.**

### 5.3 "Hardened-LEF exposes the input port"

LibreLane Classic-flow's Magic-based LEF extraction always emits
every top-level RTL port as a LEF `PIN` definition. There is no
flag suppressing port-list emission. **Conclusion: yes, a 7→5
width change shows up in the LEF and Lib.**

### 5.4 "DIE_AREA is small enough that re-harden cost is in minutes"

`config.yaml` line 12: `DIE_AREA: [0, 0, 500, 500]` — 0.25 mm². At
gf180mcuD densities, a few thousand standard-cell instances;
LibreLane Classic on a modest workstation hardens this in low
single-digit minutes.

## 6. References

See [`references.md`](references.md). Mostly in-tree files with
exact line numbers; the per-item README explicitly notes that this
small item has a light reference load.

## 7. Negative results

- **TinyTapeout pin convention does not transfer to non-TT
  wrappers.** The "DO NOT delete or add any pins" rule binds
  `tt_um_waferspace_vga_screensaver`, not `wrapped_vga.v`.
- **The dead-bit "repurpose as DFT" pattern is widespread but a
  poor fit here** — no DFT requirement, scope creep into (i)/(j).
- **"Just do nothing" is harder to defend than it looks** — A1
  ships a wrapper whose hardened LEF advertises seven input pins
  while only five are functional; vendor IP libraries treat *the
  LEF as a contract*.
- **Renaming ports (B2) couples to upstream meanings.** When
  upstream `tt_um_…` is bumped to a future revision that reassigns
  `ui_in[0]` from `cfg_tile` to e.g. `cfg_invert`, the wrapper's
  named-pin `cfg_tile` would silently become wrong.
- **Hybrid bond reassignment (D1) cannot ship inside (g).** It
  depends on item (b) NFC antenna research; at best a *follow-on
  note*.

## 8. Open questions

| # | Question | Settles via |
|---|---|---|
| Q1 | Does the LibreLane Classic-flow LEF for this design currently exist anywhere outside this checkout? | `find ~ -name "wrapped_vga.lef" -path "*runs*"` |
| Q2 | If we shrink to 5-bit, which 5 chip-level `input_PAD[…]` indices stay live? | floorplan review; arbitrarily fine for v1-compat |
| Q3 | Does any future TODO item (a..k) need the two freed pads? | (b) explicitly plans to take "currently unused pads" — (g)'s freeing is *helpful* to (b) |
| Q4 | Should the wrapper expose the upstream's `uio_*` bits as `inout` ports? | upstream macro never drives `uio_out` non-zero; **no** for this revision |
| Q5 | Cocotb test coverage of the dead bits? | check whether existing cocotb test exercises `ui_in[2:3]` |

## 9. Comparison readiness

| Approach | Re-harden? | RTL diff | Bondout impact | Best fit |
|---|---|---|---|---|
| A1 `noop-document` | no | zero | none | minimum-risk; matches TT-culture |
| A2 `noop-tieoff` | no | small | none | preserving binary compat |
| B1 `reduce-5bit` | **yes** | small (~10 lines) | none | "honest interface" — matches brief |
| B2 `reduce-and-rename` | yes | small + naming | none | downstream re-use |
| C1 `repurpose-test` | yes | medium + DFT | none | DFT-equipped chip |
| C2 `repurpose-efuse` | yes (when (j) lands) | depends | none | "Phase-1 dovetail" |
| C3 `repurpose-power-monitor` | n/a (chip-top change) | n/a | violates frozen-bondout if cell type changes | bring-up of analog die |
| D1 `hybrid-reduce-and-bond` | yes | as B1 + slot YAML | none if (b) takes pads | v2 floorplan |

## 10. Author's notes

- The per-item README rightly flags this is a small item; most of
  this report's "industry survey" content is about *not* over-
  engineering it.
- The most valuable single output is §5.1 (bit-level confirmation
  that exactly five `ui_in` bits are functional, with line numbers)
  and §5.2 (the LEF re-harden verdict).
- I deliberately resisted picking a winner. The parallel
  `stage1-first-principles/` report is expected to come at the
  same problem from a "what do physics + the PDK + the requirements
  say" angle.
- One concern about methodology fit: this report references almost
  entirely in-tree files. METHODOLOGY.md §"Reference verification"
  is tuned to *external* citations. For an item this small, in-
  tree references are the honest answer; padding §6 with
  WebFetch'd ARM IP datasheets would be the "lazy performative-
  thoroughness" METHODOLOGY.md §"Calibration" warns against.
