---
item: i
item_name: power-domain-isolation
stage: 1
angle: industry-survey
researcher: claude-opus-4-7-1m
status: draft
last-updated: 2026-05-03
---

## 1. Executive summary

Sources canvassed: IEEE 1801-2024 (UPF v4.0); local PDK audit of
`/home/tim/github/wafer-space/ws-logo-die/gf180mcu_pdk/gf180mcuD/libs.ref/{gf180mcu_fd_io,gf180mcu_fd_sc_mcu7t5v0,gf180mcu_fd_sc_mcu9t5v0,gf180mcu_fd_pr}/`;
SkyWater `sky130_fd_sc_hvl` cell list; OpenROAD UPF docs; OpenLane
multi-domain PDN tutorial; Caravel-OpenFrame multi-supply harness;
USPTO patents US7649214B2 (TSMC, Chen 2010), US20050133870A1,
US20190371787; TI SLYA014A app-note.

Headline conclusions:

- **GF180MCU std-cell library has NO level-shifter, NO isolation
  cell, NO retention flop.** Verified by grepping
  `gf180mcu_fd_sc_mcu7t5v0.cdl` and `gf180mcu_fd_sc_mcu9t5v0.cdl`;
  the only matches for `iso|lvl|shift|ret|pwr|always|gate|lpflow`
  are tie/hold cells. Confirmed verbatim by
  `gf180mcu-pdk.readthedocs.io/.../digital/standard_cells/standard_cells.html`.
- **5 isolation strategy families catalogued**: A physical-rail
  separation, B signal-isolation logic clamps, C level shifters
  (5 sub-primitives), D cross-domain ESD/latch-up, E power-gating
  + retention.
- **Per-pad RC-clamp leakage dominates**: ~648 nA per dvdd-clamp ×
  8 + 1296 nA per corner × 4 ≈ 10 µA static on v1 today — already
  1–2 orders larger than every level-shifter / isolation-cell
  leakage combined.
- **The IO cells have a DVDD/VDD pin pair that is currently shorted
  to a single 5 V net.** In `src/chip_top.sv` lines 52–166, every
  IO instance has `.DVDD(VDD).VDD(VDD)`. So multi-domain support
  isn't "broken" — it has *never been used*.

## 2. Requirements as understood

R1 dual-rail isolation; R2 harvested rail powers (f) LEDs and (h)
NFC core only; R3 VGA path runs only from `DVDD`; R4 either rail
can be live independently; R5 v1 chip backwards-compat with v2 PCB;
R6 no external passives; R7 top-metal logo preserved.

## 3. Solution-space map

### Family A — Physical-rail separation

- **A.1 hard-split** — Two completely separate rails, no shared
  current path. Mature in big-SoC literature.
- **A.2 AON-island** — Always-on rail island with smaller voltage
  domains powered selectively.

### Family B — Signal-isolation (logic clamps)

- **B.1 clamp-low** — AND2 + iso enable clamps output low.
- **B.2 clamp-high** — NAND2 + iso enable clamps output high.
- **B.3 clamp-latch** — Tri-state output + receiving-side latch.
- **B.4 mux-iso** — Mux to a known constant when iso asserted.

### Family C — Level shifters

- **C.1 cross-coupled DCVS** — Two cross-coupled inverter pairs;
  ≤1 nA static when input rail is dead.
- **C.2 Wilson mirror** — Reduces over-voltage stress.
- **C.3 half-latch** — Cross-coupled load + inverter pull-down.
- **C.4 level-down** (trivial here, not needed).
- **C.5 self-biased wide-range** — Adapts to input-rail voltage.

### Family D — Cross-domain ESD / latch-up

- **D.1 back-to-back GND-bridge diodes** — Allow VSS_HARV ↔ VSS_VGA
  ESD discharge but block forward current.
- **D.2 RC-triggered big-FET clamp** — Already shipped per pad in
  `gf180mcu_fd_io__dvdd`.
- **D.3 snapback GGNMOS** — IO-cell ESD strategy.
- **D.4 DNW substrate guard** — Triple-well isolation.

### Family E — Power-gating + retention

- **E.1 PMOS-header MTCMOS+RFF** — High-side power gate with
  retention flops.
- **E.2 NMOS-footer** — Low-side power gate.

### Discarded with stated reason

- Optical, capacitive, transformer isolation (off-chip).
- On-die LDO instead of split rails (cap-density violation).
- FD-SOI body bias (process is bulk).
- 1.8 V/5 V mixed-Vt flow (PDK has only 5 V transistors).

## 4. Sub-block breakdown

### gf180mcuD-disclosed iso/lvlshift cell list

**There are no isolation cells, no level shifters, no retention
flops, no MTCMOS headers/footers in gf180mcuD.** The complete list
of multi-domain-relevant cells the PDK *does* ship:

- `gf180mcu_fd_sc_mcu7t5v0__tieh` — tie-to-VDD via transistor
- `gf180mcu_fd_sc_mcu7t5v0__tiel` — tie-to-VSS
- `gf180mcu_fd_sc_mcu7t5v0__filltie` — tap fill cell
- `gf180mcu_fd_sc_mcu7t5v0__hold` — input keeper
- (Same four exist in `_mcu9t5v0`)
- `gf180mcu_fd_io__dvdd`/`__dvss` — IO power pad **with embedded
  RC-triggered 4-mm-wide nMOS ESD clamp** (verified in
  `gf180mcu_fd_io.spice`: clamp `X17 ... w=4e-3 nf=80.0`,
  ppolyf 30 kΩ × 12-stage RC chain, `cap_nmos_06v0 m=8.0`)
- `gf180mcu_ws_io__dvdd`/`__dvss` — wafer-space variant, same
  clamp topology
- `gf180mcu_fd_io__cor` — corner cell with **2 ESD circuits =
  1296 nA static** per corner
- `gf180mcu_fd_io__brk2`/`__brk5` — break cells (potential D.1
  diode-bridge insertion sites)
- `gf180mcu_fd_io__asig_5p0` — analog pad with diode_nd2ps +
  diode_pd2nw
- IO cells use `pfet_06v0` / `nfet_06v0` (5 V devices); `_06v0`
  `diode_nd2ps`/`diode_pd2nw` are available primitives in
  `gf180mcu_fd_pr` for hand-rolled D.1 bridges.

The 5v00 stdcell timing libs map `voltage_map(VDD, 5)` —
`DVDD == VDD` in characterisation. Lower-voltage `.lib` files (1v80,
3v30) are recharacterisations of the *same* 5 V transistors, not a
separate device flavour.

## 5. First-principles sanity checks

(See sister `stage1-first-principles/report.md` for primary
derivations. This survey only cross-checks the per-pad RC-clamp
leakage numbers against the SPICE in `gf180mcu_fd_io.spice`.)

## 6. References

- IEEE 1801-2024 (UPF v4.0)
- gf180mcuD PDK source at `gf180mcu_pdk/gf180mcuD/libs.ref/`
- `gf180mcu_fd_io.spice` (clamp topology verified)
- SkyWater sky130 `sky130_fd_sc_hvl` cell list (for comparison)
- OpenROAD UPF documentation
- OpenLane multi-domain PDN tutorial
- Caravel openframe multi-supply harness
- USPTO US7649214B2 (TSMC, Chen 2010)
- USPTO US20050133870A1
- USPTO US20190371787
- TI SLYA014A app-note

## 7. Negative results

- **`sky130_fd_sc_hvl` HAS level-shifter and isolation cells; gf180mcuD
  does NOT.** Direct counter-example showing the design space is a
  PDK-level shortfall, not a fundamental constraint.
- **The dvdd cell's hardwired D20 ESD diode** (DVSS to DVDD) cannot
  be stripped — bounds VDD swing to ≥ −0.7 V on every domain.
- **`gf180mcu_fd_sc_mcu7t5v0__filltie`** is the only cell that
  bridges VDD/VSS — useful for tie cells but not for level
  shifting.

## 8. Open questions

1. **VDD_HARV target voltage** (Q1) — blocks Family C choice (5/5V
   class shifters need different design from 3.3/5V).
2. **Cross-domain signal count** (Q2) — drives total LS cell area.
3. **Whether VGA-DVDD ∨ HARV-DVDD diode-OR can replace a 3rd AON
   pad pair** (Q3).
4. **LibreLane/OpenROAD multi-domain LVS soundness** with
   `MAGIC_EXT_UNIQUE: notopports` (Q4).
5. **`big_logo` PDN coexistence with two core rings** (Q5).
6. **D.1 diode physical placement in `brk5` slots** (Q6).
7. **v1-die-on-v2-PCB benign-injection sim** (Q7).
8. **RC-clamp non-trigger on slow harvested-rail ramps** (Q8).

## 9. Comparison readiness

| Family | Approach | gf180mcuD PDK support | Static leakage | Best fit |
|---|---|---|---|---|
| A.1 | hard-split rails | partial — pads via `brk5` | 0 (no bridge) | when no cross-domain signals |
| A.2 | AON-island | partial — needs hand-rolled | LS-dependent | when always-on logic exists |
| B.1–B.4 | logic clamps | none — hand-rolled | LS-dependent | clean ramp-up behaviour |
| C.1 | cross-coupled DCVS | none — hand-rolled | ≤1 nA/cell | digital cross-domain |
| C.5 | self-biased wide-range | none — hand-rolled | ~10 nA/cell | wide V_HARV range |
| D.1 | back-to-back diodes | available primitives | 0 forward | ESD bridge between domains |
| D.2 | RC-triggered clamp | shipped in dvdd cell | 648 nA/clamp | ESD per pad |
| D.4 | DNW substrate guard | available (DRC DN.2b 5.42 µm) | 0 (passive) | substrate-isolated HARV |
| E.1/E.2 | MTCMOS power-gating | none — would need custom cells | gate-dependent | rare-use blocks |

## Three things others may miss

1. **Per-pad RC-clamp leakage dominates.** 648 nA per dvdd-clamp ×
   8 + 1296 nA per corner × 4 ≈ 10 µA static on v1 today — already
   1–2 orders larger than every level-shifter / isolation-cell
   leakage combined. A 4-pad HARV addition costs another 2.6 µA.
   Versus a ~10 µA NFC budget at 5 V (50 µW PRIOR_CONTEXT figure)
   this is a budget-killer; **minimising HARV-side pad count is the
   dominant lever**, *not* shrinking shifter cells.
2. **The IO cells have a DVDD/VDD pin pair that is currently
   shorted to a single 5 V net.** Multi-domain support isn't
   "broken" — it has *never been used*. The IO cells were never
   *characterised* with DVDD ≠ VDD, so static timing of IO output
   drivers in a HARV ring is technically unspecified — flag for
   Stage-2.
3. **The `gf180mcu_fd_io__cor` extraction-bug** (referenced in
   `open_pdks-1.0` history): *"A 'permanent' fix… involved directly
   editing the GDS to duplicate the isolated substrate layer in the
   ESD_CLAMP_COR cell"*. If a second corner ring is added for the
   HARV domain, this LVS pothole reappears.

Plus: a v1 die on a v2 PCB will see harvested-rail voltage on what
its `asig_5p0` cells believe are ASIG5V pads; the
`gf180mcu_fd_io__asig_5p0` SPICE shows `D3 ASIG5V→DVDD` (area
150 µm², perim 106 µm) — that diode forward-conducts, *power-
injecting v1 DVDD from the harvested rail* when both are present.
Harmless, but worth documenting.

## 10. Backwards-compat verdict

**PASS, conditional.** The v1 chip on the v2 PCB will drive VGA
correctly *iff*:

- All v1 pads on south/east/west edges of `librelane/slots/slot_1x1.yaml`
  are preserved at the same physical positions.
- HARV-rail VDD/VSS pads come from net-new positions or the unused
  `analog[0..1]` pad sites (north edge). The v1 die's `asig_5p0`
  ESD diodes turn into benign clamps in that case.
- New NFC/Qi/2.4 GHz antenna pads are net-new and not bonded on a
  v1 die.

Minimum HARV pad count: 2 (1× DVDD_HARV, 1× DVSS_HARV); recommended:
4 (decoupled analog/digital halves). Existing free pads available:
2 (`analog[0..1]`). **Net-new pad budget: ≥ 2 pads needed on the
v2 floorplan.**
