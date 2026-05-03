# Solution-space summary — item (d) industry-survey angle

This file is a flat-table version of `report.md` §3, intended to be
mergeable with the parallel first-principles and academic-survey
solution maps without duplication. Stable short names match those
used in the first-principles report where they exist.

## Rectifier / multiplier topologies

| ID | Family | Industry exemplar | 2.4 GHz silicon proof |
|---|---|---|---|
| `dickson-naive-nfet` | Dickson | NFC tag silicon (early) | None (fails sub-100 mV) |
| `dickson-native-nfet` | Dickson | Many 180 nm RFEH papers | -12 to -20 dBm threshold |
| `dickson-pmos-cross-coupled-differential` | Cross-coupled | Modern UHF RFID, Yan 2024 | 47–86 % peak PCE |
| `villard-half-wave` | Half-wave cascade | Pre-2010 RFID | Lower PCE |
| `dynamic-vth-cancellation` (Kotani) | Threshold cancel | Impinj/NXP RFID | 10–20 % PCE @ -20 dBm |
| `transformer-coupled` | Balun + diff. rect. | NFC; less so 2.4 GHz | Q-limited |
| `i-reconfigurable-rectifier` | Switched-stage | Yan 2024 RFIC | -19 dBm, 51 % peak |
| `i-rectifier+lf-boost-converter` | Two-stage discrete | Powercast, e-peas, TI | Commercial mature |

## Threshold-loss-reduction techniques (combinable)

| ID | Mechanism | `gf180mcuD` viability |
|---|---|---|
| `vth-low` | Native-Vt NMOS | Yes (NVT device available) |
| `vth-aux-bias` | Static gate bias offset | Yes |
| `vth-bootstrap` | Cold-start naïve → aux-bias | Yes |
| `body-tied-DTMOS` | Body=gate | Limited (bulk CMOS) |
| `floating-gate-trim` | OTP-set offset | Needs item (j) infrastructure |

## Matching network options

| ID | Mechanism | No-external-passives compatible? |
|---|---|---|
| `match-LC-pi` | Discrete LC π | No (PCB passives) |
| `match-LC-series` | Discrete LC series | No (PCB passives) |
| `match-transformer` | On-die transformer | Yes |
| `match-bondwire-only` | Bondwire as L | Forced (single bond constraint) |
| `i-antenna-self-reactance-as-match` | Antenna co-design | Yes (preferred) |

## Discrete-vs-integrated PMU back-end

| ID | Vendor archetype | On-die feasible? |
|---|---|---|
| `i-external-pmu-bq25504` | TI BQ25504 | No (external L) |
| `i-external-pmu-aem30940` | e-peas | No (external L) |
| `i-integrated-pmu-soc` | Atmosic | Yes (architectural lesson) |
| `i-integrated-rectifier+ble-soc` | Wiliot Pixel | Yes (architectural lesson) |
| **(forced)** SC charge pump | Yan 2024 3× SC | Yes — only viable on-die path |

## Antenna technology

| ID | Mechanism | Card-PCB compatible? |
|---|---|---|
| `ant-pcb-ifa` | Printed inverted-F | Yes (currently spec'd) |
| `ant-pcb-monopole` | λ/4 PCB monopole | Yes (alternative) |
| `ant-pcb-loop` | Small magnetic loop | Possible but Q-penalised |
| `ant-chip-antenna` | Discrete SMD (Antenova) | No (off-PCB passive) |
| `ant-pifa` | Multi-layer PIFA | Marginal |
| `i-ant-pcb-meander-dipole-differential` | Balanced dipole | Yes — but 2 bond pads |

## Regulatory power envelope

| ID | Region | EIRP cap | Realistic AP EIRP |
|---|---|---|---|
| `reg-fcc-15.247` | US | 36 dBm (1 W + 6 dBi) | 22 dBm |
| `reg-etsi-en-300-328` | EU | 20 dBm (100 mW) | 18–20 dBm |
| `reg-iee-802.11-typical` | Global de facto | n/a | 17–22 dBm |

## Operating model

| ID | Source | Available power at 1 m | Comment |
|---|---|---|---|
| `mode-cooperative-source` | Powercast TX, RFID reader, Wiliot Energizer | 30+ µW (910 MHz, 1 W EIRP) | Commercial RFEH operates here |
| `mode-true-ambient` | Background Wi-Fi/cellular only | <0.1 µW | Pinuela 2013; nW total at 2.4 GHz |

## Antenna sharing with item (k) BLE — TR-switch options

| ID | Mechanism | Insertion loss / isolation |
|---|---|---|
| `trsw-series-fet` | Series NFET + shunt NFET | ~1 dB / ~30 dB |
| `trsw-quarter-wave` | λ/4 transmission line | ~0.5 dB / ~25 dB |
| `trsw-detuned-network` | Detune harvester in TX mode | ~0.5 dB / ~50 dB |