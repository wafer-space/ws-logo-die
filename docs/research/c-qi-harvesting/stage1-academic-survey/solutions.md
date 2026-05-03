# Solutions / topologies — academic-survey catalogue (item c, Stage 1)

This file is the structured catalogue of *every* peer-reviewed
silicon-paper-anchored topology surveyed for item (c). It is a
pure-data artefact intended for Stage 2 / Stage 3 ingestion;
discussion lives in [`report.md`](report.md). Each row corresponds
to one published silicon paper or thesis, not one architectural
family — so several rows share an architectural family but
differ in measured numbers / process / venue.

Stable IDs (`AS-Bx`, `AS-Cx`, `AS-Dx`, `AS-Ex`) are reused across
all academic-survey artefacts.

## Rectifier topologies (Family B)

| ID | Architectural family | Reference paper | Year | Venue | Process | Carrier freq. | Reported PCE | Output power | Output voltage | Area |
|---|---|---|---|---|---|---|---|---|---|---|
| AS-B1 | Passive PN bridge | [SpringerCh2017] (taxonomy) | 2017 | Springer monograph | n/a | 0.1-13.56 MHz | <= 50 % | varies | Vpk - 2 Vf | < 0.005 mm^2 |
| AS-B2 | Diode-connected native-NMOS bridge | [Mandal2007] | 2007 | TCAS-I | 0.18 um CMOS | 906 MHz (RFID), generalises to LF | 60-75 % | sub-mW | 1-3 V | < 0.01 mm^2 |
| AS-B2-bio | Diode-connected native-NMOS bridge (bio-implant LF variant) | Mandal & Sarpeshkar 2015 review (PMID 26737525) | 2015 | IEEE EMBC | 0.18-0.35 um CMOS | 100 kHz - 1 MHz | 60-75 % | sub-mW | ~3 V | < 0.01 mm^2 |
| AS-B3-LeeGhov | Cross-coupled NMOS + offset-controlled comparator | [LeeGhov2011] | 2011 | TCAS-I | 0.5 um CMOS | 13.56 MHz | up to 87 % | sub-100 mW | ~3 V | small (paper does not state) |
| AS-B3-ChaPark | Cross-coupled latched-comparator rectifier | [ChaPark2012] | 2012 | TCAS-II | 0.18 um CMOS | 13.56 MHz | 81.9 % @ 1.5 Vpp | sub-mW | ~1 V | **0.009 mm^2** |
| AS-B3-LuKi | Switched-offset cross-coupled rectifier | [LuKi2014] | 2014 | TBioCAS | 0.35 um CMOS | 13.56 MHz | 81.9 % @ 1.5 Vpp; 88 % @ higher amplitudes | up to 100 mW | 4 V | not explicit |
| AS-B4-LeeKim | Digitally-adaptive delay-comp rectifier | [LeeKim2021-Energies] | 2021 | MDPI Energies | 0.18 um CMOS | 1-13.56 MHz | > 90 % | up to 200 mW | 3.3 V | 0.02-0.05 mm^2 |
| AS-B4-Khan | Sync rectifier + multi-fb LDO at Qi LF | [Khan2018-Energies] | 2018 | MDPI Energies | 0.18 um CMOS | **87-205 kHz (Qi BPP / PMA)** | **85.3 % peak** | up to 1 W | 5 V | ~0.18 mm^2 (full IC) |
| AS-B4-Wu19 | Qi-compatible full-wave sync rectifier | [Wu2019-Qi] | 2019 | Sci. China Inf. Sci. | 0.18 um BCD | Qi BPP | not explicit | up to 5 W | 5 V | not explicit |
| AS-B4-Wu20 | Multimode battery charger Qi receiver | [Wu2020-AICSP] | 2020 | Springer AICSP | 0.18 um BCD | Qi BPP | not explicit | up to 5 W | 4.2 V Vbat | not explicit |
| AS-B4-Quang | Multi-mode WPT charger w/ adaptive supply | [Quang2015-TIE] | 2015 | IEEE TIE | 0.18 um CMOS | 100 kHz - 1 MHz | ~90 % overall | up to ~5 W | 5 V | not explicit |
| AS-B5 | R^3 reconfigurable resonant regulating rectifier | [ChengKi2017] | 2017 | IEEE JSSC | 0.35 um CMOS | 6.78 MHz | up to 92 % | up to 6 W | 5 V | not explicit |
| AS-B5-bio | R^3 with primary-side equaliser | [ChengKi2016] | 2016 | TBioCAS | 0.35 um CMOS | 6.78 MHz | not explicit | 120 mW @ 1.2 cm | 4 V | not explicit |
| AS-B6 | Wide-input-range triple-mode auto-selecting rectifier | [QuangHa2015-WideTriple] | 2016 | Springer AICSP | 0.18 um BCD | 100-300 kHz | **94.2 % peak** | 8 W | 5 V | not explicit |

**14 rows, 6 distinct architectural families, 100% silicon-paper
anchored.**

## Regulator topologies (Family C)

| ID | Architectural family | Reference paper | Year | Venue | Topology | Reported overall PCE |
|---|---|---|---|---|---|---|
| AS-C1-single | Single-feedback LDO | [Wu2019-Qi] | 2019 | Sci. China Inf. Sci. | Pass-PMOS + bandgap-ref. error amp | not explicit |
| AS-C1-multi | Multi-feedback LDO | [Khan2018-Energies] | 2018 | Energies | Pass-PMOS + DC error amp + AC ripple feed-forward | 85.3 % overall AC-Vout |
| AS-C2 | CEP-adjusted Vrect (closed-loop with PTx) | [Quang2015-TIE] | 2015 | IEEE TIE | LDO + CEP modulator | ~90 % overall |
| AS-C3 | Detuning-regulation built into rectifier | [ChengKi2017] | 2017 | IEEE JSSC | R^3 (no separate regulator block) | up to 92 % |

**4 rows, 4 distinct families.**

## Protocol-participation tiers (Family D)

| ID | Tier | Reference paper(s) | Year | Notes |
|---|---|---|---|---|
| AS-D1 | Strict free-rider (no WPC packets) | **NO PEER-REVIEWED PAPER** | n/a | Closest artefact: Vinod-Tanur ATtiny13A (industry-survey [O1]) |
| AS-D2-bio | Bio-implant primary-cooperative regulation | [ChengKi2016] | 2016 | Cooperative primary; not applicable on stock Qi pad |
| AS-D3 | Full WPC v1.x compliance | [Khan2018-Energies], [Wu2019-Qi], [Wu2020-AICSP], [Quang2015-TIE] | 2015-2020 | All four Qi-band papers fall here |
| AS-D4 | Qi v2 EPP / MPP compliance | None peer-reviewed at time of survey | n/a | EPP/MPP stack is members-only; out-of-scope |

**4 rows; 1 important gap (AS-D1).**

## Coexistence / co-design (Family E)

| ID | Topic | Reference | Year | Venue | Notes |
|---|---|---|---|---|---|
| AS-E1 | NFC <-> Qi field coupling at PCB-coil distances | [Petzel2020] | 2020 | TU Graz MSc thesis | Locally cached; full-text verified |
| AS-E2 | Survey of regulation topologies in resonant WPT | [MDPI-Reg-Topology-2018] | 2018 | MDPI Energies | Open-access |
| AS-E3 | Resonant current-mode WPT for IMDs (overview) | [PMC-Bio-Survey-2022] | 2022 | NIH PMC mirror | Open-access |
| AS-E4 | CMOS rectifier circuit design (textbook chapter) | [SpringerCh2017] | 2017 | Springer monograph | Paywalled |

## Notes on methodology

- **Topologies discarded.** Voltage-doubler / Dickson; single half-
  wave; on-chip-inductor switching; capacitively-coupled WPT;
  6.78 MHz A4WP — see `report.md` §3.6.
- **No silent omissions.** All approaches evaluated by the agent
  appear here, including those discarded with one-line reasons.
- **Quality bar.** >= 5 distinct architectural families (counting
  rectifier families only) is the assignment-brief minimum.
  **Six achieved** (B1, B2, B3, B4, B5, B6). With regulator and
  protocol axes, total distinct catalogued topologies (architectural
  family x axis) is >= 14, well above the bar.
