# References (item e, Stage 1 first-principles)

## REF-1 — `gf180mcuD` PDK SPICE models (local)

- **Path:** `gf180mcu_pdk/gf180mcuD/libs.tech/ngspice/sm141064.ngspice`
  and `sm141064_mim.ngspice`.
- **Verification:** **VERIFIED 2026-05-02** by direct file read.
- **Relevance:** Three MIM density tiers (1.0, 1.5, 2.0 fF/µm²)
  with `c_cox` parameters 0.987e-3, 1.47e-3, 1.99e-3 F/m². Voltage
  ratings 20 V, 10 V, 6.6 V respectively. Leakage spec 1 pA/µm²
  @ rated V. MOS-cap subckts `cap_nmos_03v3`/`cap_pmos_03v3`/etc.
  cvar1+cvar2 sums confirm 3.98 / 2.18 fF/µm² peaks.

## REF-2 — `gf180mcuD` Magic tech file

- **Path:** `gf180mcuD/libs.tech/magic/gf180mcuD.tech`
- **Verification:** VERIFIED LOCAL.
- **Relevance:** Confirms MIM = M4 + fusetop + M5; min top-plate
  width 5 µm (MIMTM.8a); MIM-to-unrelated-M4 spacing 1.2 µm
  (MIMTM.1).

## REF-3 — `gf180mcuD` density DRC

- **Path:** `gf180mcuD/libs.tech/klayout/tech/drc/rule_decks/density.drc`
- **Verification:** VERIFIED LOCAL.
- **Relevance:** M1.4–M5.4 are min-30 %; no max rule. So adding
  MIM on M4-M5 doesn't trigger density violations.

## REF-4 — GF180MCU DRM passive elements CSVs

- **URLs:**
  - https://raw.githubusercontent.com/google/gf180mcu-pdk/main/docs/analog/spice/elec_specs/tables_clear/6_Passive_Elements4.csv
    (MIM-1.5)
  - `.../6_Passive_Elements5.csv` (MIM-1.0)
  - `.../6_Passive_Elements6.csv` (MIM-2.0)
- **Verification:** VERIFIED via WebFetch 2026-05-02.
- **Relevance:** Density / Vop_max / BVox spec confirmation:
  MIM-1.5: 1.27/1.5/1.73 fF/µm², 10 V op, BVox 10/30 V; MIM-1.0:
  0.9-1.1, 20 V op, BVox 20-40 V; MIM-2.0: 1.8-2.2, 6.6 V op,
  BVox 10-24 V.

## REF-5 — Repo's floorplan & big_logo

- **Paths:** `librelane/slots/slot_1x1.yaml`, `librelane/config.yaml`,
  `big_logo/big_logo.lef`, `big_logo/Makefile`.
- **Verification:** VERIFIED LOCAL (HEAD 02d2ff4).
- **Relevance:** Per-layer logo coverage 22.4 % derived by
  RECT-area summation from `big_logo.lef` (12,810 RECTs, summed
  per layer).

## REF-6 — Repo methodology / TODO

- **Paths:** `docs/research/METHODOLOGY.md`, `TEMPLATE.md`,
  `e-mim-cap-storage/README.md`, `TODO.md`.
- **Verification:** VERIFIED LOCAL.

## REF-7 — GF180MCU PDK landing pages

- **URLs:** https://github.com/google/gf180mcu-pdk and
  https://gf180mcu-pdk.readthedocs.io/en/latest/
- **Verification:** VERIFIED via WebFetch 2026-05-02 (status pages
  only — used for navigation).

## Verification status summary

All references verified by direct read or WebFetch on 2026-05-02.
PRIOR_CONTEXT.md also confirms PIP is *not* in `gf180mcuD` —
referenced in §3 to exclude PIP from the topology survey.
