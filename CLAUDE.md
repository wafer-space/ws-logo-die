# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

ASIC tapeout project for **wafer.space MPW runs** on the GlobalFoundries 180nm MCU PDK (`gf180mcuD`). The "build" produces a GDSII layout (a chip), not a software binary. RTL-to-GDS is driven by **LibreLane** (an OpenROAD-based open-source flow), invoked through a Nix flake that pins a custom LibreLane branch and a custom magic version.

The top-level design (`chip_top`) is a padring + core that integrates a small core (`chip_core`), a hardened `wrapped_vga` macro from the `vga_screensaver/` subproject, and three "decorative" IP macros that are ports-and-components-free: `gf180mcu_ws_ip__id` (chip ID/QR code, **required for tapeout**), `gf180mcu_ws_ip__logo`, and `big_logo`.

## First-time setup

```bash
git submodule update --init --recursive   # gf180mcu_as_ex_mcu7t5v0 + tt-waferspace-vga-screensaver
make clone-pdk                            # clones github.com/wafer-space/gf180mcu at $PDK_TAG (currently 1.6.4)
nix develop                               # or `nix-shell` — drops you into a shell with LibreLane/iverilog/klayout/etc.
```

All `make` targets below assume you are inside the Nix shell.

## Common commands

| Goal | Command |
|---|---|
| Run full RTL→GDS flow | `make librelane` |
| Open last run in OpenROAD GUI | `make librelane-openroad` |
| Open last run in KLayout | `make librelane-klayout` |
| Build padring only (analog flows) | `make librelane-padring` |
| Skip DRC checks (faster iteration) | `make librelane-nodrc` |
| Skip only Magic DRC / only KLayout DRC | `make librelane-klayoutdrc` / `make librelane-magicdrc` |
| Copy last successful run to `final/` | `make copy-final` |
| RTL simulation (cocotb + iverilog) | `make sim` |
| Gate-level simulation (needs `final/`) | `make sim-gl` |
| View waveforms | `make sim-view` |
| Render PNG of final layout | `make render-image` |

## Slot system (floorplan size)

The chip can be built in four pad-ring sizes selected via the `SLOT` env var: `1x1` (default), `0p5x1`, `1x0p5`, `0p5x0p5`.

```bash
SLOT=0p5x0p5 make librelane
```

Each slot has its own pad layout in `librelane/slots/slot_<SLOT>.yaml` (defines `DIE_AREA`, `CORE_AREA`, and `PAD_SOUTH`/`EAST`/`NORTH`/`WEST`). Each slot also defines a `VERILOG_DEFINES: ["SLOT_<SLOT>"]`, which selects pad counts in `src/slot_defines.svh` (`NUM_DVDD_PADS`, `NUM_DVSS_PADS`, `NUM_INPUT_PADS`, `NUM_BIDIR_PADS`, `NUM_ANALOG_PADS`). Changing pad counts requires editing both files.

To change the project default, edit `DEFAULT_SLOT` in the `Makefile`.

## Build ordering — read this before touching the top-level

`librelane/config.yaml` references `vga_screensaver/runs/latest/final/...` (gds/lef/lib/spef/etc.). That means the VGA macro **must be hardened first**, otherwise the top-level run cannot find its macro views:

```bash
cd vga_screensaver && make project    # produces runs/latest/final/...
cd .. && make librelane
```

The `gf180mcu_ws_ip__id`, `gf180mcu_ws_ip__logo`, and `big_logo` macros are **pre-built and committed** (GDS/LEF/LIB/Verilog views live under `ip/` and `big_logo/`). They are listed as abstract cells in `MAGIC_EXT_ABSTRACT_CELLS` and `LVS_FLATTEN_CELLS` because they have no electrical ports. To regenerate `big_logo.gds`, run `cd big_logo && make logo`; it shells out to `ip/gf180mcu_ws_ip__logo/script/make_gds.py`.

## Architecture — top-level integration

- `src/chip_top.sv` — instantiates the padring (`gf180mcu_ws_io__dvdd`/`__dvss`, `gf180mcu_fd_io__in_c`/`__in_s`/`__bi_24t`/`__asig_5p0`) using `generate` loops sized by the `SLOT_*` defines, and wires those pads to `chip_core`. Also instantiates `wrapped_vga`, `chip_id`, `wafer_space_logo`, and `big_logo` with `(* keep *)` attributes so synthesis cannot prune them. **Do not change power/ground pad counts or positions** — they must match the standard breakout PCB.
- `src/chip_core.sv` — VGA-only user logic. Drives `vga_outputs[7:0]` from the chip-top `wrapped_vga` instance onto the top 8 bidir pads (`bidir[39:32]`, OE=1) and ties off the remaining bidir/input pads to a safe inactive state (`OE=0`, `IE=0`, no pulls). Only ~17 of the 56 signal pads carry useful traffic; the rest are bonded out unchanged so the breakout PCB still matches.
- `vga_screensaver/` — separate LibreLane project that hardens `wrapped_vga` from the `tt-waferspace-vga-screensaver` submodule. Has its own `config.yaml`, `Makefile`, and run directory.

## Key configuration knobs in `librelane/config.yaml`

- `MACROS:` — declares `wrapped_vga`, `gf180mcu_ws_ip__id`, `gf180mcu_ws_ip__logo`, and `big_logo`. The logo location is computed as `expr::$DIE_AREA[2] - 169.25` so it auto-anchors to the top-right corner regardless of slot size.
- `KLAYOUT_FILLER_OPTIONS: Metal2_ignore_active: true` — the design cannot meet the Metal2 minimum-density rule, so dummy metal is used for fill and the rule is ignored on Metal2 (and on adjacent layer-pair rules `DM.5_DM.7` / `DM.4_DM.6`). Dummy metal is converted to active metal during precheck. **If you change the floorplan or fill strategy, revisit this carefully.**
- `LIB` / `CELL_LEFS` / `CELL_GDS` / `CELL_VERILOG_MODELS` / `CELL_SPICE_MODELS` — pulls in the standard `gf180mcu_fd_sc_mcu7t5v0` library plus custom DFF cells from the `gf180mcu_as_ex_mcu7t5v0` submodule (Avalon Semiconductors). `EXTRA_EXCLUDED_CELLS` excludes the stock DFFs so synthesis must use the custom ones. To disable the custom DFFs, remove the block between the `# Remove everything between this comment...` and `#End` markers.
- `IGNORE_DISCONNECTED_MODULES` and `LVS_FLATTEN_CELLS` — keep `bi_24t` and the no-port macros from breaking checks.
- `MAGIC_GDS_FLATGLOB` — long list of foundry cell-name patterns that must be flattened to avoid false-positive DRC errors on contacts and 3.3V devices.

## Verification

Cocotb testbench at `cocotb/chip_top_tb.py`. Same testbench runs both RTL (`make sim`) and gate-level (`make sim-gl`, requires `make copy-final` first) — switched via the `GL=1` env var inside the script. Waveforms are written to `cocotb/sim_build/chip_top.fst`.

For manufacturability sign-off, run [gf180mcu-precheck](https://github.com/wafer-space/gf180mcu-precheck) against the final GDS.

## CI

`.github/workflows/ci.yml` builds with the Nix flake and runs the full flow (`make sim` → `make librelane` → `make copy-final` → `make render-image` → `make sim-gl`) per slot. Only the upstream repo (`wafer-space/gf180mcu-project-template`) builds all four slots in matrix; forks build a single `default` slot.

## Submodules

- `gf180mcu_as_ex_mcu7t5v0/` — custom standard cells (DFFs) from Avalon Semiconductors, integrated via the `LIB`/`CELL_*` settings in `librelane/config.yaml`.
- `vga_screensaver/tt-waferspace-vga-screensaver/` — TinyTapeout VGA screensaver source, hardened by `vga_screensaver/config.yaml`.

## Generated/ignored paths

`runs/`, `final/`, `img/`, `sim_build/`, `gf180mcu_pdk/`, `*.lyrdb`, `chip_top.gds`, `__pycache__/` are all gitignored. `librelane/runs/<RUN_TAG>/` is the canonical output of each LibreLane invocation; `make copy-final` snapshots the latest into `final/` for downstream consumers (sim-gl, precheck, render-image).
