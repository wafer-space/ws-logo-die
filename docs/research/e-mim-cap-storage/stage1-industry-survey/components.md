# Components — sub-block inventory (item e, Stage 1 industry-survey)

The industry-survey angle inherits its sub-block decomposition
from the first-principles sister report. See
[`../stage1-first-principles/components.md`](../stage1-first-principles/components.md)
for the canonical component list.

This file enumerates **industry-survey-specific** sub-block
findings — concrete cell names, PDK references, DRC constraints
— to augment the first-principles inventory.

## PDK-blessed cap sub-blocks

### MIM cap arrays

- **PCell**: `gf180mcu::cap_mim_2p0fF` (Magic gencell);
  `cap_mim.py` (KLayout PCell). `mim_min_l = mim_min_w = 5`,
  `mim_cap_area = 10 000 µm²` (KLayout-side area clamp at
  100×100 µm).
- **SPICE**: `sm141064_mim.ngspice` lines 252-279.
- **DRC**: `mim_b.drc` rules MIMTM.1-12; MIMTM.8a ≥ 25 µm²,
  MIMTM.8b ≤ 10 000 µm².

### MOS-cap as fill

- **Cell**: `gf180mcu_fd_sc_mcu7t5v0__fillcap_{4,8,16,32,64}`
- **Sizes**: fillcap_64 = 35.84 × 3.92 = 140.5 µm² LEF;
  ~13.1 µm² active gate area; ~28.6 fF.
- **Default**: LibreLane places these automatically in std-cell
  row gaps.

### Charge-pump building blocks

- Stage caps: 1-10 pF MIM (any of MIM_1f0/1f5/2f0).
- Switches: native NMOS or HV NMOS depending on stage voltage.
- Non-overlap clock: cross-coupled latch + delay chain (use
  std-cell library).

## Sub-blocks NOT in the PDK (must be hand-built or out of scope)

- **PIP / poly-poly capacitor**: PRIOR_CONTEXT.md confirms
  absent.
- **MOM PCell**: no `cap_mom_*` cell; designers must hand-draw
  (Cadence-style) or accept extracted-only.
- **Deep-trench capacitor**: searched all of `libs.tech/` for
  `cap_dt`, `cap_trench`, `dtc_*`. None found.
- **Ferroelectric / RRAM / MRAM**: out of scope.

## Hybrid HV-dump architecture sub-blocks (Family 8)

- **HV MIM cap** (MIM-1f0-M4M5): 1.0 fF/µm² at 20 V.
- **Level-shifter** (cross-ref item (i)): converts 20 V cap
  voltage to 5 V regulated rail. **Hand-built** in `gf180mcuD`
  (no level-shifter cell ships).
- **Comparator + reference**: trip-point sensor for cap-dump
  events. ~50 µA quiescent.
- **Cross-domain handshake**: gate-side enable signal must be
  shifted from 5 V control to 20 V switch gate. Cross-ref (i)
  TC-3 RCC (Hosseini 2019) or TC-4 (Tang 2014) topologies.

## Floorplan-level sub-blocks

- **Logo-on-all-metal constraint** (cross-ref TODO) interacts
  with cap floorplan:
  - `big_logo` uses M2 (per `Metal2_ignore_active: true`
    workaround in `librelane/config.yaml`).
  - MIM cap on M4-M5 is independent of the M2 logo geometry.
  - But MOM stack would conflict with the M3-M4-M5 logo
    visibility — so MOM is doubly excluded.

## Sub-blocks already covered by first-principles sister

- Bandgap reference (powering the comparator).
- LDO topology (powered from cap-dump rail).
- Brown-out / power-good detector.
- Cap-bank switching matrix (selective-discharge to load).
