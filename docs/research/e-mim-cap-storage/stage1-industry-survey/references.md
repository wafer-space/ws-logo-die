# References (item e, Stage 1 industry-survey)

| ID | Citation | Verification | Notes |
|---|---|---|---|
| GF-PDK-MIM-RTD | `gf180mcu-pdk.readthedocs.io` "10.4.2 MIM Option B" | WebFetch 2026-05-02 | Upstream device summary blessing `mim_single_2p0fF` |
| GF-PDK-MIMA-RTD | `gf180mcu-pdk.readthedocs.io` "10.4.1 MIM Option A" | WebFetch 2026-05-02 | 3-LM Option A — not on our 5-LM Option B |
| GF-PDK-ELEC-6_4 | DRM `elec_specs/elec_specs_6_4.html` | WebFetch 2026-05-02 | Electrical specs for MIM (V_op, BV, leakage) |
| GF-PDK-LAYERS | DRM 4.1 "Drawn layer definition" | WebFetch 2026-05-02 | Metal-layer definitions and layer numbers |
| MOSBIUS-DEV | `mosbiuschip/chipathon2025/all_devices.md` | WebFetch 2026-05-02 | Community device-summary cross-check |
| GF-PDK-FILES | local `gf180mcu_pdk/gf180mcuD/libs.{ref,tech}/...` | direct file read | SPICE deck, DRC rules, PCells |
| GAMBINO-2019 | Gambino et al., *Reliability of an Al₂O₃/SiO₂ MIM Capacitor for 180nm (3.3V) Technology*, IRPS 2019 | indirect — paywall, ResearchGate 403; confirmed via search | Reliability data for the underlying MIM stack |
| SKY130-DEV | "Device Details — SkyWater SKY130 PDK" | WebFetch 2026-05-02 | Comparable open-source PDK for cross-reference |
| LIU-2018 | Liu *et al.*, *An Ultra-Low-Power RFID/NFC Frontend IC Using 0.18 µm CMOS*, *Sensors* 18(5):1452 | WebFetch 2026-05-02 | Closest reference design — uses external 10 µF |
| NTAG213-AN11276 | NXP AN11276, *NTAG Antenna Design Guide* | WebSearch 2026-05-02 (PDF 404; multiple secondary sources confirm 50 pF input cap) | Anchor for "NTAG has only 50 pF on-die" |
| TOWER-180BCD | towersemi.com — 180nm Power Management page | WebSearch 2026-05-02 | Trench-isolation only, no public DTC PCell |
| EDABOARD-IBM | edaboard.com IBM 180nm HV thread | WebSearch 2026-05-02 | Industry chatter on HV cap options |
| DICKSON-MDPI | "Signal Amplification by Means of a Dickson Charge Pump" (open-access, MDPI) | WebSearch 2026-05-02 | Family-5 reference |
| GF180-MIM-DENSITY-DRC | local `mim_a.drc` / `mim_b.drc` rules | direct file read | MIMTM.1-12; MIMTM.8b 100×100 µm tile cap |

## Notes

- **The SPICE deck advertises 12 MIM SUBCKTs** but the upstream
  device summary blesses only one (`mim_single_2p0fF`). Sister
  reports relying on `sm141064_mim.ngspice` alone will overstate
  the design space.
- **GAMBINO-2019** is the only reliability paper found for the
  GF180 MIM stack itself. Paywalled but the abstract confirms
  Al₂O₃/SiO₂ stack and reports BV/TDDB margins consistent with
  the DRM electrical specs.
- **No DTC reference for `gf180mcuD`** found in any source —
  consistent with the PDK file inventory.
