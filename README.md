# ws-logo-die — wafer.space Logo Die

> **WSLG · Slot 1×1 · GF180MCU · wafer.space Run 1**
>
> *"Die with a big wafer.space logo on it!"*

A 1×1 slot tapeout for [wafer.space](https://wafer.space/) Run 1 (shuttle G801,
GlobalFoundries 180nm MCU). The core of the die is a giant wafer.space logo
drawn directly into the back-end-of-line metal stack, surrounded by a fully
populated I/O pad ring. The star of the show is the logo itself; the live
circuitry is a hardened wafer.space VGA screensaver macro that you can
poke with `input[10:4]` and observe on `bidir[39:32]`.

<div align="center">
  <img src="wslg_wafer_photo.png" width="70%" alt="WSLG die visible on the fabricated GF180MCU wafer"/>
  <br/><sub>The fabricated WSLG die — the rocket-and-rings logo is clearly visible<br/>on the silicon, on the wafer.space Run 1 GF180MCU wafer.</sub>
</div>

<br/>

<div align="center">
<table width="100%">
<tr>
<td width="50%" align="center">
  <img src="wslg_die_render.png" width="95%" alt="WSLG GDS render — wafer.space two-tone style"/>
  <br/><sub>GDS render in the wafer.space two-tone style<br/>(Metal5 in yellow, Pad layer in dark red)</sub>
</td>
<td width="50%" align="center">
  <img src="https://raw.githubusercontent.com/mithro/wafer-space-die-pad-diagrams/main/diagrams/WSLG_chip_top_10_2.png" width="95%" alt="WSLG annotated pad diagram"/>
  <br/><sub>Pad diagram from <a href="https://github.com/mithro/wafer-space-die-pad-diagrams">mithro/wafer-space-die-pad-diagrams</a><br/>(74 labelled pads, 3932 × 5122 µm)</sub>
</td>
</tr>
</table>
</div>

The chip is project **WSLG** on the [ws-run1 reticle](https://github.com/wafer-space/ws-run1).

## What's on the die

| Macro | Role |
|---|---|
| `big_logo` | The wafer.space logo, drawn across **all metal layers** (`Metal1`–`Metal5` plus contacts/vias). Dominates the core area. Generated from `big_logo/wafer_space_logo.png` via `ip/gf180mcu_ws_ip__logo/script/make_gds.py`. |
| `gf180mcu_ws_ip__id` | Chip ID / QR code stamp — required for tapeout, in the SW corner. |
| `gf180mcu_ws_ip__logo` | Smaller wafer.space logo template cell — auto-anchored to the NE corner via `expr::$DIE_AREA[2] - 169.25`. |
| `wrapped_vga` | Hardened VGA screensaver macro from [TinyTapeout/tt-waferspace-vga-screensaver](https://github.com/TinyTapeout/tt-waferspace-vga-screensaver), built separately under `vga_screensaver/`. |
| `chip_core` | Glue logic that drives `vga_outputs[7:0]` from `wrapped_vga` onto `bidir[39:32]` and ties off the remaining bidir/input pads to a safe inactive state. |

## Pinout (1×1 slot)

The pad ring is fully populated for the wafer.space breakout PCB, but
**only 17 of the 56 signal pads** are actually wired to the live design
— this is a "decorative" die, not a peripheral-rich one. Most bidir and
input pads are bonded out unchanged for breakout-PCB compatibility but
have no internal connection.

### Useful pads (17 of 56 signal pads)

| Pad | Signal | Notes |
|---|---|---|
| `clk_PAD` | Chip clock | Schmitt-trigger input (`gf180mcu_fd_io__in_s`) |
| `rst_n_PAD` | Active-low reset | Plain CMOS input (`gf180mcu_fd_io__in_c`); resets the VGA macro |
| `input[10:4]` | `wrapped_vga.inputs[6:0]` | 7-bit control input to the screensaver (7 pads) |
| `bidir[39:32]` | `vga_outputs[7:0]` | 8-bit VGA output. OE forced high, IE off (8 pads) |

### Bonded but unused (39 of 56 signal pads)

These pads exist on the package and pad ring (so the bondout matches the
standard breakout PCB and the `(* keep *)`-marked pad-frame instances in
[`src/chip_top.sv`](src/chip_top.sv)) but `chip_core` ties them to a safe
inactive state:

| Pad(s) | Count | State |
|---|---|---|
| `bidir[31:0]` | 32 | Output disabled (`OE=0`), input buffer disabled (`IE=0`), no pull-up or pull-down. `bidir_out` driven to 0 for safety. |
| `input[3:0]`, `input[11]` | 5 | Pulled up by default (`PU=1`, `PD=0`); value not consumed |
| `analog[1:0]` | 2 | The two `asig_5p0` pads on the north edge are declared in `chip_core`'s port list but not driven or read |

Power/ground pads (8 × DVDD, 10 × DVSS) are unchanged.

Exact pad placement is in [`librelane/slots/slot_1x1.yaml`](librelane/slots/slot_1x1.yaml);
the bidir/input/analog/power-pad counts in [`src/slot_defines.svh`](src/slot_defines.svh)
are keyed off the `SLOT_1X1` Verilog define.

## Build

This repo is a Nix-driven LibreLane flow pinned to a custom branch
(`leo/gf180mcu`) and the wafer-space fork of the GF180MCU PDK.

```bash
git submodule update --init --recursive
make clone-pdk          # clones github.com/wafer-space/gf180mcu @ $PDK_TAG
nix develop             # drops you into a shell with LibreLane / iverilog / klayout / magic
cd vga_screensaver && make project && cd ..   # harden the VGA macro first
make librelane          # full RTL → GDSII flow for chip_top
make copy-final         # snapshot last run into final/
```

To rebuild the `big_logo.gds` from the source PNG:

```bash
cd big_logo && make logo drc
```

See [`CLAUDE.md`](CLAUDE.md) for a deeper tour of the build system, the slot
selector, and the various non-obvious LibreLane configuration knobs (notably
the Metal2 density workaround and the custom DFF cell library overrides).

## Other slot sizes

The repo also supports `0p5x1`, `1x0p5`, and `0p5x0p5`:

```bash
SLOT=0p5x0p5 make librelane
```

The 1×1 slot is the variant that actually shipped on Run 1.

## Verification

A cocotb / Icarus testbench at [`cocotb/chip_top_tb.py`](cocotb/chip_top_tb.py)
covers both RTL (`make sim`) and gate-level (`make sim-gl`, requires
`make copy-final` first) simulation. Waveforms drop into
`cocotb/sim_build/chip_top.fst`; view with `make sim-view`.

Manufacturability sign-off: run [gf180mcu-precheck](https://github.com/wafer-space/gf180mcu-precheck) against `final/gds/chip_top.gds`.

## Related repositories

- [wafer-space/ws-run1](https://github.com/wafer-space/ws-run1) — the full Run 1 reticle this die ships on
- [wafer-space/gf180mcu](https://github.com/wafer-space/gf180mcu) — the custom GF180MCU PDK fork
- [librelane/librelane @ leo/gf180mcu](https://github.com/librelane/librelane/tree/leo/gf180mcu) — the LibreLane branch this flow is pinned to
- [mithro/wafer-space-die-pad-diagrams](https://github.com/mithro/wafer-space-die-pad-diagrams) — generates the annotated pad diagram shown above
- [89Mods/ws-logo-die](https://github.com/89Mods/ws-logo-die) — origin of this design

## License

Apache License 2.0 — see [`LICENSE`](LICENSE) and [`AUTHORS.md`](AUTHORS.md).
