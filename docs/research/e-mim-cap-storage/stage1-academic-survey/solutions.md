---
item: e
stage: 1
angle: academic-survey
---

# Solution-space — academic literature

This file mirrors §3 of `report.md` at architecture-detail level.

## Summary table of cap-storage strategies (academic literature)

| ID | Strategy family | Density / metric | Headline ref | Maturity in lit |
|---|---|---|---|---|
| AS-1 | Standard-density MIM (180 nm SiN / Al2O3-SiO2) | 2-7 fF/µm² | Gambino IRPS 2019 | foundry-shipping |
| AS-2 | High-k MIM (HfO2 / ZrO2) | 13-75 fF/µm² | Achanta 2010, Discover Nano 2019 | research only |
| AS-3 | Deep-trench cap (DTC) | 100-250 fF/µm² | Jayaraman ICICDT 2012 | IBM-SOI / specialty 180 nm BCD |
| AS-4 | MOS-cap / accumulation gate | 3-4 fF/µm² peak, V-dependent | textbook + many | foundry-default |
| AS-5 | Pelliconi cross-coupled charge pump | flying caps 1-10 pF; ~10 mW from ~5000 µm² | Pelliconi JSSC 2003 | mature 180 nm |
| AS-6 | Dickson voltage multiplier | flying caps 1-10 pF; sub-50 mV input feasible w/ ULP diode | Dickson 1976; Sze 2019 | mature |
| AS-7 | Successive-approximation SC DC-DC (8-bit ratio) | ~1 mm² flying-cap bank, 80%+ eff | Bang JSSC 2016 | published 180 nm |
| AS-8 | 2:1 / 3:2 fully-integrated SC step-down | 0.5-2 mm², 80-87 % peak | Le, Salem, NSF 2-stage | mature 180 nm |
| AS-9 | Hot-swap / multi-port zero-current bank-switching | extra switches; idle banks isolated | MDPI Energies 11(8) 2018 | published battery-mgmt |
| AS-10 | Active leakage-cancellation feedback | small OTA per switch; ~10x effective leak reduction | Hashimoto ICCAD 2001 | published low-power |
| AS-11 | Bulk-cap-less brown-out gating (implant approach) | zero cap area | Yang JSSC 2022 | published bio-implant |
| AS-12 | Output-cap-less LDO + slew-enhancement | ~640 nA Iq | Sensors 2024 NB-IoT | published IoT |
| AS-13 | MPPT + energy-recycling continuous replenisher | small cap + active loop | Khan arXiv 2602.02376 | preprint |
| AS-14 | On-chip cap-bank automatic resonance tuner | ~0.1-1 mm² tuning bank | Trigui 2024 | published |

## Architecture exemplars

### AS-5 Pelliconi cross-coupled doubler — block diagram

```
            VDD_in (rectified, e.g. 1-3 V)
                 |
        +--------+--------+
        |                 |
     M1 PMOS           M2 PMOS  (cross-coupled high-side)
        |                 |
   node A              node B
        |                 |
     C1 (MIM)          C2 (MIM)         <-- flying caps, 1-10 pF
        |                 |
        +-- phi_A         +-- phi_B    (non-overlap clocks)
        |                 |
     M3 NMOS           M4 NMOS  (cross-coupled low-side)
        |                 |
        +--------+--------+
                 |
              VSS_in
```

Output is taken from nodes A and B alternately into a hold cap.
Output voltage approaches 2*VDD_in - I_load*R_out where R_out
is inversely proportional to (f * C_fly). Efficiency 70-85 % at
180 nm when V_in > V_t.

### AS-9 multi-port ZCS bank-switching — block diagram

```
   VDD_harvest --+---+---+---+---+
                |   |   |   |   |
              SW1 SW2 SW3 SW4 SW5  (HV switches; both terminals
                |   |   |   |   |   isolated when off)
              C1  C2  C3  C4  C5  (parallel banks)
                |   |   |   |   |
              SWb1 SWb2 SWb3 ... (return-path switches)
                |   |   |   |   |
   VSS --------+---+---+---+---+
```

Only one bank is "live" (both SW and SWb on) at any moment;
other banks have both terminals open-circuit. Idle leakage
reduces to switch-off-leakage which dominates only at very fine
granularity.

### AS-10 leakage-cancellation feedback (Hashimoto)

A sense amp at the switched-off cap node measures sub-threshold
leakage. A current mirror feeds compensating current of equal
magnitude / opposite sign back into the node, nulling net
leakage. Effective only for slow leakage (DC-class); does not
help fast switching loss.

## Strategy-to-rail recommendations (preliminary)

| Rail | Best academic strategy | Rationale |
|---|---|---|
| 5 V VGA (DVDD)        | AS-1 + AS-4 distributed  | Already-regulated; standard decap |
| NFC harvested ~3.3 V  | AS-5 Pelliconi + AS-1 hold cap | Cross-coupled efficient at >1 V |
| Qi harvested ~3.3 V   | AS-1 LC-tank tuning + AS-5 | LC oscillation already present |
| Ambient-RF ~0.5-1 V   | AS-6 Dickson with ULP diode + AS-9/AS-10 idle | Sub-1 V is Pelliconi's failure regime |
| eFuse program ~5-7 V  | AS-5 Pelliconi boost + AS-1 MIM-1.0 hold | High-V hold needs MIM-1.0 |
| LED twinkle           | AS-11 brown-out gate + AS-1 small fast hold | No bulk-storage feasible per first-principles N-3 |

## Open architecture choices

- AS-7 vs AS-8 vs AS-5: they overlap functionally (all are SC
  step-down / step-up with flying caps). The 2-bit-per-stage
  Bang SAR-SC offers the most flexibility for variable-voltage
  rails but at the cost of digital control complexity.
- AS-9 + AS-10 are *complementary*, not alternative: F2
  bank-switching coarsens the off-leakage; F1 actively nulls the
  residual.
- AS-13 (active MPPT replenisher) requires an oscillator (item
  (a)) and a comparator + control loop — significant additional
  effort, but reduces the bulk-storage requirement to ~0.

## What this list does NOT include and why

- **Ferroelectric / FeCAP / HfZrO ferroelectric.** No PCell in
  `gf180mcuD`; not a tape-out option.
- **Supercapacitor / EDLC monolithic CMOS.** Lab-scale only;
  needs electrolyte process step.
- **MEMS variable cap.** Out-of-process.
- **Junction caps.** Industry survey already discarded;
  density poor.
- **3D-stacked DRAM-class cap.** Inaccessible.
