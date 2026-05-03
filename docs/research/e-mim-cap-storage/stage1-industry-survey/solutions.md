# Solutions catalogue (item e, Stage 1 industry-survey)

10 cap-storage families surveyed across the GF180MCU device
library, sky130 comparable PDK, commercial 180 nm-class foundry
briefs, and academic/industrial NFC-RFID-tag IC reference designs.

## Family inventory

| ID | Family | PDK availability | Density (peak) | Stage-2 verdict |
|---|---|---|---|---|
| F1 | Native MIM in `gf180mcuD` (3 density tiers × 2 metal-pair stacks) | ✓ blessed | 2.0 fF/µm² (MIM_2f0) | **Primary storage** |
| F2 | MOS-cap (gate-oxide capacitance) | ✓ blessed in `cap_nmos_03v3` / `cap_nmos_06v0` | 3.98 fF/µm² (3.3 V), 2.18 fF/µm² (6 V) | **Strong supplement** for std-cell fill |
| F3 | MOM / vertical-fringe / inter-metal | ✗ no PCell, hand-built only | ~0.35 fF/µm² (M1-M5 stack) | **Discard for storage** — 6× worse than MIM and consumes all metals |
| F4 | Standard-cell fill cap arrays (`fillcap_*`) | ✓ blessed (`fillcap_{4,8,16,32,64}`) | 0.20 fF/µm² apparent | **Free fill** — LibreLane default |
| F5 | Switched-cap charge pump / Dickson | Built from F1 | 1-10 pF stage caps | Useful for rectification + boost; **not bulk storage** |
| F6 | Capacitor multiplier (Miller) | Built from F1 + amp | Multiplies effective C only | **Useless for energy storage** — doesn't multiply stored energy |
| F7 | Switched-cap DC-DC | Built from F1 + control | Trades cap area for f_sw | ~70% efficiency at 180 nm (vs >90% deep-sub-µm) |
| F8 | **Hybrid: small high-V cap dump + level-shifted pump** | F1 + custom level shifter | 4-5× energy/area when cap sees rated V | **Strong candidate** — see open-questions Q-3 |
| F9 | Deep-trench capacitor (DTC) | ✗ NOT in `gf180mcuD` | 50-500 fF/µm² | Tower / TSMC offer; we don't |
| F10 | Ferroelectric / RRAM / MRAM | ✗ NOT in `gf180mcuD` | n/a | Out of scope |

## Family 1 — Native MIM detail

GF180MCU exposes **three MIM density tiers** (1.0, 1.5, 2.0
fF/µm²) crossed with **four metal-pair stacks** (M2-M3, M3-M4,
M4-M5, M5-M6) — but DRC + foundry shuttle picks exactly **one**
density and **one** stack per tape-out. The blessed default per
upstream is `mim_single_2p0fF` at the top-1/top metal pair.

| MIM variant | Density | V_op | BV | Use case |
|---|---|---|---|---|
| MIM-2f0-M4M5 (`cap_mim_2f0_m4m5_noshield`) | 2.0 fF/µm² | ≤6.6 V | ~10-15 V | Post-LDO storage, blessed default |
| MIM-1f5-M4M5 | 1.5 fF/µm² | ≤10 V | 10-30 V | NFC rectifier output before regulation |
| MIM-1f0-M4M5 | 1.0 fF/µm² | ≤20 V | 20-40 V | Charge-pump nodes, eFuse program rail, **F8 hybrid** |
| MIM-{any}-M2M3 (Option A, 3LM) | same | same | same | **Rare; not selectable on GF180 5LM stack** |

Per-MIM-tile area is hard-capped at **100 × 100 µm² = 20 pF max**
by DRC rule MIMTM.8b / MIM.8b. Larger banks need parallel tiles.

SPICE: `sm141064_mim.ngspice` lines 252-279. `c_cox = 1.99e-3
pF/µm² × mim_corner`, `gleak ≈ 1.9 pA/µm²`. Magic gencell
`gf180mcu::cap_mim_2p0fF`. KLayout PCell `cap_mim.py` with
`mim_min_l = mim_min_w = 5`, `mim_cap_area = 10 000 µm²`.

## Family 2 — MOS-cap detail

`cap_nmos_03v3` / `cap_pmos_03v3`: peak ~3.98 fF/µm² inversion.
`cap_nmos_06v0` / `cap_pmos_06v0`: peak ~2.18 fF/µm².
**`cap_nmos_06v0` is the device used inside `fillcap_*` cells.**

## Family 4 — fillcap detail

`gf180mcu_fd_sc_mcu7t5v0__fillcap_{4,8,16,32,64}`. fillcap_64
LEF size 35.840 × 3.920 = 140.5 µm²; 16 × 0.82 µm² = 13.1 µm²
active; **~28.6 fF / fillcap_64**, 0.20 fF/µm² apparent density.
Free fill in std-cell rows; LibreLane default behaviour.

## Family 8 — Hybrid HV-dump architecture

A 1 nF / 1000 µm² MIM_1f0 at 20 V stores 200 nJ; same area
MIM_2f0 at 6.6 V stores ~43 nJ. **MIM_1f0 stores ~4.6× more
energy per unit area than MIM_2f0** when the cap actually sees
rated voltage. Pairing MIM_1f0 with the rectifier-output node
before regulation is a non-obvious architectural win.

## Stage-2 / Stage-3 handoff

The shortlist for Stage-2 gap analysis from this industry-survey
angle:

- **F1 MIM-2f0-M4M5 + F4 fillcap MOS** as the canonical
  bulk-storage + decoupling pair.
- **F8 hybrid HV-dump** as a non-obvious 4.6×-density alternative
  for unregulated rails (NFC rect-out, eFuse program rail).

## Discarded approaches

- **PIP / poly-poly cap** — not in `gf180mcuD`.
- **Junction caps** — poor density, strong VC.
- **LC-tank-as-storage** — resonator, not storage.
- **Bondpad-as-cap** — ~0.1 pF/pad × 44 pads ≈ 4 pF, useless.
- **External cap** — forbidden by no-external-passives rule.
- **Stacked-MIM** (two pairs in one die) — only `*_noshield`
  SUBCKTs ship in `gf180mcuD`.
