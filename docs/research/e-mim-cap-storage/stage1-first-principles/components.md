# Components — sub-block inventory (item e, Stage 1 first-principles)

## MIM cap PCells

- `cap_mim_2f0_m4m5_noshield` — 2.0 fF/µm², ≤6.6 V, M4-M5 stack
  (Option B 5LM)
- `cap_mim_1f5_m4m5_noshield` — 1.5 fF/µm², ≤10 V
- `cap_mim_1f0_m4m5_noshield` — 1.0 fF/µm², ≤20 V
- `cap_mim_*_m2m3_noshield` (Option A, 3LM only — not selectable
  on `gf180mcuD` 5LM stack)
- DRC: `mim_a.drc` / `mim_b.drc`. MIMTM.1: 1.2 µm spacing to
  unrelated M4. MIMTM.8a: ≥25 µm² minimum tile. MIMTM.8b: ≤10 000
  µm² (100×100 µm) maximum tile.

## MOS-cap PCells

- `cap_nmos_03v3` — peak 3.98 fF/µm² inversion, ≤3.6 V
- `cap_pmos_03v3` — similar
- `cap_nmos_06v0` — peak 2.18 fF/µm², ≤6.6 V
- `cap_pmos_06v0` — similar
- Body-tied `_b` flavours — smoother cap-V; same density class

## Standard-cell fillcap arrays

- `gf180mcu_fd_sc_mcu7t5v0__fillcap_{4,8,16,32,64}` — pre-built
  decoupling cells in std-cell rows
- fillcap_64: 16× nfet_05v0 W=0.82 µm L=1 µm in 35.84 × 3.92 µm
  cell ⇒ ~28.6 fF, **0.20 fF/µm² apparent density**
- Free fill in std-cell rows; LibreLane default

## Switch FETs (for S3/S4/S8 banking)

- `nfet_06v0` for high-V switch
- `pfet_06v0` for high-V isolation
- Sized for Ron at switching frequency: ~50/0.6 µm at LSB

## Charge pump (S3, S5)

- 2-stage Dickson with 10 pF MIM caps × 2 ≈ 0.02 mm² per stage
- LDMOS-class HV switch for S5 (boost MIM-1.0 to 20 V)
- Pump clock: derived from system clock or self-clocked at 1-10 MHz

## MoM-fringe (S7, hand-built)

- No PDK PCell; Metal1↔Metal5 stack of overlapping fingers
- M4↔M5 = 39.351 aF/µm²; m3↔m4 = 59.027 aF/µm² (from
  gf180mcuD.tech)
- Five-layer M1-M5 MOM stack ≈ 0.174 fF/µm² overlap + ~0.18 fF/µm²
  fringe = ~0.35 fF/µm² total
- Needs RC extraction for accurate value; no SPICE primitive

## Bottom-plate / top-plate / via routing

- M4 (bottom plate) — must be complement of logo M4 inside logo
  bbox, eroded by 1.2 µm (MIMTM.1)
- FuseTop (top plate, GDS 75/0)
- via2/3 ring contacts
- M5 (return path)

## ESD / common-node clamping

- Series-R-limiting via array
- ESD/over-V clamp at cap node

## Floorplan blocks

- `metal2_blk` density-fill exclusion under MIM banks
- `cap_mk` marker (GDS 117/5) per MIM tile

## Per-strategy cumulative

| Strategy | Primary blocks | Add'l blocks | Notes |
|---|---|---|---|
| S1 | MIM bank | none | simplest |
| S2 | MIM bank + MOS-cap fill + 2-ring PDN | none | hierarchical |
| S3 | small MIM + 2 switches per stage + clock | charge pump | small flying cap |
| S4 | MIM bank + N switches + select FSM | banking control | discontinuous loads |
| S5 | MIM-1.0 + Dickson pump + HV switches | LDMOS class switch | 20 V boost |
| S6 | MOS-cap fill + LDO + replenisher | active loop | always-on |
| S7 | MoM-fringe in inter-logo voids | RC extraction | backstop only |
| S8 | MIM bank + N switches with both-terminal isolation | banking + isolation FSM | zero-leak idle |
