# Components — sub-block inventory (item i, Stage 1 first-principles)

## S1 — Single-domain + RTL gating

- (existing) 1 × VGA DVDD pad pair `gf180mcu_ws_io__dvdd`/`__dvss`
- (existing) 1 × `gf180mcu_fd_io__cor` ESD/clamp cell
- (existing) `VDD_NETS: VDD` / `GND_NETS: VSS`
- New RTL: power-good monitor, clock-gating cells per consumer,
  reset generator that synthesises a per-block reset from a
  comparator output.

## S2 — Split-VDD, shared-VSS, no cross-signals

Adds to S1:
- 1 × harvested-rail DVDD pad (`gf180mcu_ws_io__dvdd`) at `analog[0]`.
- 1 × harvested-rail DVSS pad (`gf180mcu_ws_io__dvss`) at `analog[1]`.
- 2 × `gf180mcu_fd_io__brk5` cells, between the harv-domain pad
  pair and the rest of the io ring on either side.
- 1 × additional `gf180mcu_fd_io__cor` cell for the harv segment.
- LibreLane config delta: `VDD_NETS: [VDD_VGA, VDD_HARV]`,
  `GND_NETS: [VSS]`; `pdn_cfg.tcl` defines two `voltage_domain`
  regions.
- Floorplan partition: `chip_core` instance is split into two
  rectangular regions, each with its own filltie strategy and PDN.
- **Zero cross-domain signals** — no level shifters, no isolation
  cells. Constrains feature set: the two domains' RTL never share
  a wire.

## S3 — Split-VDD + split-VSS + D1 level shifters, no isolation cells

Adds to S2:
- A second DVSS pad pair: `harv_dvss` separate from VGA DVSS.
  Net `VDD_NETS: [VDD_VGA, VDD_HARV]`,
  `GND_NETS: [VSS_VGA, VSS_HARV]`.
- Substrate is still shared but locally tied to whichever VSS pulls
  hardest; std-cell VPW pin tied to local VSS in each region.
- N × custom D1 cross-coupled level-shifter cells, one per
  cross-domain signal:
  - 4 × pfet_06v0 (W=6 µm, L=700 nm) for cross-coupled load + buffer
  - 4 × nfet_06v0 (W=3 µm, L=700 nm) for pull-down + inverters
  - PMOS sources tied to receiving-side VDD; NMOS sources to local
    VSS.
  - Hand-laid; not synthesisable from `mcu7t5v0` because the
    cross-coupled load is a custom topology.
- Power-good detector × 2 (one per domain), to drive level-shifter
  receive-side reset.
- Brown-out detector × 2 (one per domain).

## S4 — S3 + E1/E2 isolation clamps

Adds to S3:
- N × isolation NAND/AND clamp cells, one per cross-domain signal:
  - From `mcu7t5v0__nand2_2` or `mcu7t5v0__and2_2` cells, one per
    signal that needs deterministic-state output.
  - Driven by `iso_enable_n` from the receiving-side power-good
    detector.
- 1 × cross-domain `iso_enable_n` net per direction.
- Optional: a small SR-latch retention element built from
  `mcu7t5v0__nor2`/`__nand2` cells — but loses state on its own
  rail collapse, so retention semantics are best-effort only.

## S5 — S4 + DNWELL-tubbed HARV domain

Adds to S4:
- Custom std-cell library variant for HARV-domain digital, with
  every NMOS body tied to a local VPW that is connected to a PCOMP
  guard ring inside a DNWELL.
- DNWELL guard ring around the entire HARV domain region (continuous
  PCOMP tied to substrate-VSS, then DNWELL above, then PCOMP tied
  to VSS_HARV inside the tub).
- 5.42 µm DNWELL spacing to anything else (DRC rule DN.2b).
- Estimated incremental design effort: **~3 person-months** for the
  custom library + verification.

## Cross-cutting components needed by ≥ 1 strategy

### Brown-out / power-good detector

- Compares VDD_X against a bandgap (or simpler: a poly-resistor
  divider against a Vth-referenced inverter).
- Output: `pwr_good_X` boolean.
- Lives in domain X (so it monitors its own rail with decreasing
  self-bias as the rail collapses).
- In practice cross-couple the power-good outputs:
  `pwr_good_VGA` is sourced in VGA domain, level-shifted to HARV
  domain via a D1 cell, and used inside HARV domain to decide
  isolation.

### Repurposed pad allocations (slot_1x1.yaml deltas)

- `analog[1]` → `harv_dvdd_pad` instance type
  `gf180mcu_ws_io__dvdd`.
- `analog[0]` → `harv_dvss_pad` instance type
  `gf180mcu_ws_io__dvss`.
- 2 × `gf180mcu_fd_io__brk5` insertions between harv-domain pad
  pair and adjacent bidir / analog pads.
- 1 × additional `gf180mcu_fd_io__cor` instance in the
  harv-domain segment.
- For S5: deltas only in the floorplan, not the pad ring.

## Required RTL changes (chip_top.sv)

- Replace one `analog` pad instantiation with a `dvdd` pad
  instantiation.
- Bring out two new top-level inout ports: `VDD_HARV`, `VSS_HARV`.
- Wire harv-domain modules' `VDD`/`VSS` pins to the new harv rails.
- For S3+: instantiate level-shifter cells at every cross-domain
  port; this requires the level shifter to exist as a Verilog
  module + LIB cell, both hand-written.

## Verification components

- Spice sim of the cross-coupled D1 cell at TT, FF, SS over 0 V to
  5.5 V on each rail (including VDD_A=0 with VDD_B=5).
- Substrate-aware sim of the latch-up trigger (PNP collector + NPN
  emitter parasitic, with 1–10 kΩ Rsub).
- LVS-clean test for two `cor` cells in the same IO ring.
- Test of LibreLane's multi-voltage-domain flow on a tiny
  two-domain reference design before committing to a chip-level
  flow.
