# Solutions catalogue (item k, Stage 1 first-principles)

Stable short-name keys (`A1..A10`, `S1..S8`, `T1..T6`, `M1..M4`,
`R0..R2`, `P1..P3`, `N1..N4`).

## 3.A. PA topologies

| ID | Topology | η_theory | η 180nm @ 2.4GHz | Notes |
|---|---|---|---|---|
| A1 | Class A | 50 % | 25–35 % | Used in legacy linear PAs. Wasted bias for const-env GFSK. |
| A2 | Class AB | 60–78 % | 35–45 % | WLAN, LTE PAs needing OFDM/QAM linearity. Linearity wasted on BLE GFSK. |
| A3 | Class B | π/4 ≈ 78.5 % | 50–55 % | BLE-suitable. Crossover distortion at carrier → out-of-band → mostly harmless. |
| A4 | Class C | ≤ 90 % | 50–60 % | Conduction <180°. BLE-suitable. Some published 65 nm BLE TXs use it. |
| A5 | Class D voltage-mode | 100 % | 50–55 % | Two switches, square-wave drain, output filter. Switching loss caps η. |
| A6 | Class E (default candidate) | 100 % | 55–65 % | Single switch + load network for ZVS. Constant-envelope ideal. |
| A7 | Class F / Inverse F | 100 % | 55–70 % | Multiple harmonic resonators on drain. On-die L Q ≈ 8–15 limits realisable benefit. |
| A8 | Inverse Class D | 100 % | 60 %+ | Switches handle current; parallel-resonant output. |
| A9 | Direct-modulation digital PA | varies | ~50 % | Many small unit transistors switched on/off. For const-env GFSK degenerates to Class D. |
| A10 | Cascode Class A/B with stacked devices | — | 40 % | Stack two `nfet_06v0` to extend safe Vds swing to ≈10 V. |

## 3.B. Frequency-synthesiser topologies

| ID | Topology | PN @ 1 MHz | Power | BLE-compliant |
|---|---|---|---|---|
| S1 | Integer-N PLL (LC-VCO) | −115 dBc/Hz | 4 mW | yes |
| S2 | Fractional-N PLL | −115 dBc/Hz | 5 mW | yes (overkill) |
| S3 | Free-running ring DCO | −80 dBc/Hz | 1.5 mW | **no** (fails by 10 dB) |
| S4 | Ring + FLL | −80 dBc/Hz | 2 mW avg | **no** |
| S5 | LC-tank VCO + integer-N PLL | −120 dBc/Hz | 4 mW | yes — **default** |
| S6 | Injection-locked from LC sub-multiple | −110 dBc/Hz | 3 mW | yes |
| S7 | ADPLL (TDC + DCO + digital LF) | −110 dBc/Hz | 3 mW | yes; **rejected on area in 180 nm** |
| S8 | BAW / FBAR-referenced | n/a | n/a | **rejected — not in PDK** |

## 3.C. Modulator paths

| ID | Path | Notes |
|---|---|---|
| M1 | Two-point modulation | Standard for BLE radios. Data BW not limited by loop BW. |
| M2 | Closed-loop modulation | Loop BW limits data rate; 1 Mbps GFSK marginal at 300 kHz loop BW. |
| M3 | Open-loop post-lock modulation | Used in older BLE radios (TI CC254x). Frequency drifts during packet but adverts tolerate ±150 kHz. |
| M4 | Direct DCO frequency-word modulation | Requires ADPLL. Out on area in 180 nm. |

## 3.D. TR-switch architectures

| ID | Topology | IL (dB) | Off iso (dB) | Notes |
|---|---|---|---|---|
| T1 | Single series NMOS (`nfet_06v0`) | 0.5 | 28 | Lowest insertion loss |
| T2 | Series-shunt FET | 0.7 | 40 | **Default candidate** |
| T3 | Stacked FET (cascoded) | 0.9 | 28 | High RF power handling |
| T4 | Lumped LC SPDT | 1.0 | 30 | Frequency selective |
| T5 | λ/4 transmission line + shunt PIN | n/a | n/a | **NOT VIABLE on-die** (12 mm at 2.4 GHz) |
| T6 | PMOS+NMOS pass-gate | 1.5 | 25 | PMOS too slow at 2.4 GHz; rejected |

## 3.E. TX architecture

| ID | Configuration | Gates | Avg P @ 100 ms | UX |
|---|---|---|---|---|
| R0 | TX-only (advertising bearer) | ≈3 kgate | 108 µW | scan visible only |
| R1 | TX + SCAN_RSP RX | ≈10 kgate | 140 µW | full vCard |
| R2 | Full BLE peripheral (connectable) | 50–100 kgate + 1–4 kB SRAM | mA-class | not viable |

## 3.F. Crypto/privacy

| ID | Address | Notes |
|---|---|---|
| P1 | Static public address | Simplest. 6-byte fixed MAC. Acceptable. |
| P2 | Static random address | Random at first power-on, persists in eFuse. |
| P3 | Resolvable random address (RPA) | **Defeats use case** — only paired devices can resolve, but card is meant to be passively scannable. |

## 3.G. Antenna sharing strategies

| ID | Strategy | Verdict |
|---|---|---|
| N1 | Hard time-multiplex via TR switch | **Default** |
| N2 | Frequency-domain split | **NOT VIABLE** — same band |
| N3 | Diplexer (PA at 2.45 GHz, harvester at e.g. 5 GHz) | Contradicts (d) |
| N4 | Two separate PCB antennas | PCB footprint too tight |

## Discarded approaches (not given full sub-sections)

| Discarded | One-line reason |
|---|---|
| Doherty PA | Linearity benefit irrelevant for const-env GFSK |
| Envelope tracking | No envelope to track in GFSK |
| Outphasing (LINC) | Constant-envelope already; pointless |
| Crystal oscillator reference | External component prohibited |
| MEMS resonator reference | Not in gf180mcuD PDK |
| GaN PA | Wrong PDK |
| Off-die SAW filter | External component prohibited |
| Direct conversion non-coherent demod (R1) | Inferior NF vs limiter-discriminator at ≤1 Mbps |
| Coded PHY (BLE 5 LE Coded) | Out of scope |
| 2 Mbps uncoded PHY | Out of scope but trivially supportable from same hardware |
