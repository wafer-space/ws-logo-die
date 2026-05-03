---
item: e
item_name: mim-cap-storage
stage: 1
angle: industry-survey
researcher: agent-stage1-industry-1of3
status: in-review
last-updated: 2026-05-03
---

## 1. Executive summary

This report surveys industrial / open-source-PDK / tape-out
practice for storing energy on-die in `gf180mcuD` for the
wafer.space business-card v2 chip.

Sources canvassed: the local PDK (`libs.ref/`, `libs.tech/`),
upstream `gf180mcu-pdk.readthedocs.io`, comparable open-source PDK
(sky130), commercial 180 nm-class foundry briefs (TSMC, Tower,
IBM), academic 180 nm NFC/RFID-tag IC papers, and switched-cap /
Dickson / capacitor-multiplier literature.

Headline conclusions:

- `gf180mcuD` SPICE deck exposes **three MIM density tiers** (1.0,
  1.5, 2.0 fF/µm²) crossed with **four metal-pair stacks** (M2-M3,
  M3-M4, M4-M5, M5-M6) — but DRC + foundry shuttle picks exactly
  one density and one stack per tape-out. The blessed-default per
  the upstream device summary is **`mim_single_2p0fF`** at the
  top-1/top metal pair.
- Per-MIM-tile area is hard-capped at **100 × 100 µm² = 20 pF max**
  by DRC rule MIMTM.8b / MIM.8b. Larger banks need parallel tiles.
- MOS-cap (`cap_nmos_06v0`, peak ~2.18 fF/µm² in inversion) is the
  only PDK-blessed alternative; it ships in
  `gf180mcu_fd_sc_mcu7t5v0__fillcap_{4,8,16,32,64}` std-cell-row
  spacers.
- **No MOM/poly-poly/deep-trench/ferroelectric PCell exists** in
  `gf180mcuD`. PIP is explicitly absent.
- The closest reference design — Liu et al. 2018 0.18 µm passive-
  tag IC — uses an **external 10 µF** for storage. NTAG213 has
  only ~50 pF on-die for tuning. **Real on-die-only bulk storage at
  the µF scale is *not* practiced in industry at this node.**

## 2. Requirements as understood

(See sister `stage1-first-principles/report.md` §2.)

## 3. Solution-space map — 10 cap-storage families

### Family 1 — Native MIM in `gf180mcuD`

**MIM-2f0-M4M5** (`cap_mim_2f0_m4m5_noshield`, Option B 5LM):
- SPICE: `sm141064_mim.ngspice` lines 252-279. `c_cox = 1.99e-3
  pF/µm² × mim_corner`, `gleak ≈ 1.9 pA/µm²`.
- Magic gencell `gf180mcu::cap_mim_2p0fF`.
- KLayout PCell `cap_mim.py` with `mim_min_l = mim_min_w = 5`,
  `mim_cap_area = 10 000 µm²`.
- DRC `mim_b.drc` rules MIMTM.1-12; MIMTM.8a ≥25 µm², MIMTM.8b
  ≤10 000 µm².

**MIM-1f5-M4M5**: 1.5 fF/µm², ≤10 V op, BV 10-30 V. Use case: NFC
rectifier output before regulation.

**MIM-1f0-M4M5**: 1.0 fF/µm², ≤20 V op, BV 20-40 V. Use case:
charge-pump nodes / eFuse program rail.

**MIM-{…}-M2M3** (Option A, 3LM): same SPICE, but bottom plate is
metal-2. Rare; not selectable on `gf180mcuD` 5LM stack.

### Family 2 — MOS-cap (gate-oxide capacitance)

`cap_nmos_03v3` / `cap_pmos_03v3`: peak ~3.98 fF/µm² inversion.
`cap_nmos_06v0` / `cap_pmos_06v0`: peak ~2.18 fF/µm².
**`cap_nmos_06v0` is the device used inside `fillcap_*` cells.**

### Family 3 — MOM / vertical-fringe / inter-metal

**No PCell, no SPICE subckt.** Magic-extracted overlap densities
from `gf180mcuD.tech`: `metal4↔metal5 = 39.351 aF/µm²`. Five-layer
M1-M5 MOM stack ≈ ~0.35 fF/µm² total. **6× worse than MIM** and
consumes all metals. Discard for storage.

### Family 4 — Standard-cell fill cap arrays (`fillcap_*`)

`gf180mcu_fd_sc_mcu7t5v0__fillcap_{4,8,16,32,64}`. fillcap_64 LEF
size 35.840 × 3.920 = 140.5 µm²; 16 × 0.82 µm² = 13.1 µm² active;
**~28.6 fF / fillcap_64**, 0.20 fF/µm² apparent density. Free fill
in std-cell rows; LibreLane default.

### Family 5 — Switched-cap charge pump / Dickson

Dickson and Pelliconi/cross-coupled. Stage caps 1-10 pF MIM. Stores
energy by *raising V on a small cap* (E = ½CV²) rather than piling
up charge. Doesn't solve "sustain a 100 ms pulse" by itself.

### Family 6 — Capacitor multiplier (Miller)

Multiplies *effective* C for filter-pole purposes, doesn't multiply
*stored energy*. Useless for rail-droop survival.

### Family 7 — Switched-cap DC-DC

Trades cap area for switching frequency. At 180 nm, switching loss
caps efficiency around 70 % (vs >90 % at deep-sub-µm).

### Family 8 — Hybrid: small high-V cap dump + level-shifted pump

A 1 nF / 1000 µm² MIM_1f0 at 20 V stores 200 nJ; same area MIM_2f0
at 6.6 V stores ~43 nJ. **MIM_1f0 stores ~4.6× more energy per unit
area than MIM_2f0** when the cap actually sees rated voltage.
**Strong candidate.**

### Family 9 — Deep-trench capacitor (DTC)

Density 50-500 fF/µm² (100×-250× MIM). Tower Semi 180 nm BCD
(trench-isolation only, no public DTC PCell), TSMC 180 nm with DTC
(some product families). **None in `gf180mcuD`** — verified.

### Family 10 — Ferroelectric / RRAM / MRAM

**None in `gf180mcuD`.** Out of scope.

### Discarded approaches

PIP / poly-poly cap (not in PDK); junction caps (poor density,
strong VC); LC-tank-as-storage (resonator, not storage); bondpad-
as-cap (~0.1 pF/pad × 44 pads ≈ 4 pF, useless); external cap
(forbidden).

## 4. Sub-block breakdown

(See sister `stage1-first-principles/components.md`.)

## 5. First-principles sanity checks

(See sister `stage1-first-principles/report.md` §5.)

Industry-survey-specific cross-checks:

- Liu et al. 2018 reference design uses Cst = 10 µF (external),
  Cdem = 5 pF on-chip. Confirms our "real on-die-only at our
  targets is not practiced" finding.
- NTAG213 input C is ~50 pF on-die — for tuning, not for storage.

## 6. References

| ID | Citation | Verification |
|---|---|---|
| GF-PDK-MIM-RTD | "10.4.2 MIM Option B" | WebFetch 2026-05-02 |
| GF-PDK-MIMA-RTD | "10.4.1 MIM Option A" | WebFetch 2026-05-02 |
| GF-PDK-ELEC-6_4 | DRM elec_specs/elec_specs_6_4.html | WebFetch 2026-05-02 |
| GF-PDK-LAYERS | DRM 4.1 Drawn layer definition | WebFetch 2026-05-02 |
| MOSBIUS-DEV | mosbiuschip/chipathon2025/`all_devices.md` | WebFetch 2026-05-02 |
| GF-PDK-FILES | local `gf180mcu_pdk/gf180mcuD/libs.{ref,tech}/…` | direct file read |
| GAMBINO-2019 | "Reliability of an Al₂O₃/SiO₂ MIM Capacitor for 180nm (3.3V) Technology", IRPS 2019 | indirect (paywall, ResearchGate 403); confirmed via search |
| SKY130-DEV | "Device Details — SkyWater SKY130 PDK" | WebFetch 2026-05-02 |
| LIU-2018 | "An Ultra-Low-Power RFID/NFC Frontend IC Using 0.18 µm CMOS", *Sensors* 18(5):1452 | WebFetch 2026-05-02 |
| NTAG213-AN11276 | NXP AN11276, "NTAG Antenna Design Guide" | WebSearch 2026-05-02 (PDF 404; multiple secondary sources confirm 50 pF) |
| TOWER-180BCD | towersemi.com/technology/power-management/180nm-power-management/ | WebSearch 2026-05-02 |
| EDABOARD-IBM | edaboard.com IBM 180nm HV thread | WebSearch 2026-05-02 |
| DICKSON-MDPI | "Signal Amplification by Means of a Dickson Charge Pump" | WebSearch 2026-05-02 |
| GF180-MIM-DENSITY-DRC | local mim_a.drc / mim_b.drc rules | direct file read |

## 7. Negative results

- **N1 — Single-MIM-tile cap >100 × 100 µm² is forbidden** (DRC
  MIMTM.8b + KLayout PCell self-coercion).
- **N2 — PIP / poly-poly cap is NOT in `gf180mcuD`.** Confirms
  PRIOR_CONTEXT.md.
- **N3 — No deep-trench cap in `gf180mcuD`.** Searched all of
  `libs.tech/` for `cap_dt`, `cap_trench`, `dtc_*`. None found.
- **N4 — Stacked-MIM (two pairs in one die) NOT offered.** Only
  `*_noshield` SUBCKTs.
- **N5 — Bondpad / package C negligible.** ~4 pF total, useless.
- **N6 — Liu et al. (canonical 0.18 µm NFC frontend) needs an
  EXTERNAL 10 µF.** The closest reference design says "you can't do
  this fully on-die at our targets".
- **N7 — `Metal2_ignore_active: true` is a workaround, not a
  feature.** Adding MIM_2f0_M4M5 *adds* M4 density, doesn't help
  M2.
- **N8 — MOM-stack 30-50× lower density than MIM.** Practically
  rules out MOM as primary storage.
- **N9 — Capacitor-multiplier (Family 6) doesn't multiply STORED
  energy.**

## 8. Open questions

- **OQ-1 — Which metal layers does `big_logo` actually use?**
- **OQ-2 — Move v2 from 5LM to 6LM stack?**
- **OQ-3 — How much fillcap_* is the current chip ALREADY
  placing?**
- **OQ-4 — Which `--variant` (A..F) is the wafer.space MPW
  shuttle?**
- **OQ-5 — How much current does NFC modulation half-cycle pull?**
- **OQ-6 — Does `Metal2_ignore_active` remain valid signoff under
  GF MPW rules?**

## 9. Comparison readiness

| Approach | Headline | Area / cost | Maturity | Best fit | Worst fit |
|---|---|---|---|---|---|
| MIM-2f0-M4M5 | 2.0 fF/µm², ≤6.6 V, 1 pA/µm² | 5 500 µm²/nF | foundry default | post-LDO storage | rail >6.6 V |
| MIM-1f5-M4M5 | 1.5 fF/µm², ≤10 V | 6 700 µm²/nF | foundry default | medium-V rail | high-density needs |
| MIM-1f0-M4M5 | 1.0 fF/µm², ≤20 V | 10 000 µm²/nF | foundry default | NFC rect-out, eFuse, Family-8 hybrid | low-V high-density |
| `cap_nmos_03v3` | ~3.98 fF/µm² peak, nonlinear | needs DGATE area | foundry default | rail-on-rail decoupling | brown-out |
| `cap_nmos_06v0` | ~2.18 fF/µm² peak, 5 V | same | foundry default | std-cell fill | precision analog |
| Std-cell `fillcap_64` | 28.6 fF / cell, 0.20 fF/µm² | free in std-cell rows | LibreLane default | empty digital area | blocked rows |
| MOM stack M1-M5 | ~0.35 fF/µm² | uses all metals | hand-built | matched pairs | bulk storage |
| Dickson / Pelliconi | 1-10 pF flying caps | switching loss, clock | very mature | rectification + boost | bulk storage alone |
| SC DC-DC | ~70 % eff at 180 nm | 10-100 pF flying + control | mature deep-sub-µm; 180 nm marginal | replace LDO+bulk | low-clock loads |
| Hybrid HV dump (Family 8) | 4-5× energy/area if V matches | level shifter + comparator | published in stim ICs | NFC pre-regulator | regulated 5 V |
| Deep-trench cap | 50-500 fF/µm² | not in `gf180mcuD` | foundry-restricted | 100× density | this project |
| Ferroelectric / RRAM | non-volatile | not in `gf180mcuD` | foundry-restricted | non-volatile data | this project |
| External cap | unlimited | forbidden | mature | most products | this project |

## 10. Author's notes

Most surprising finding: contrast between SPICE deck (12 distinct
MIM SUBCKTs) and upstream device summary (single blessed
`mim_single_2p0fF`). Designers reading only SPICE will overestimate
the design space.

The KLayout PCell auto-coercing `MIM-A → metal_level=M3` and
refusing the M3 setting under MIM-B (`cap_mim.py` line 78-80) is
the kind of subtle constraint that only surfaces from reading the
actual PDK.

`KLAYOUT_FILLER_OPTIONS: Metal2_ignore_active: true` is a known
soft spot — item (e) should not just add MIM caps and walk away;
the right long-term fix is to choose cap-bottom-plate metal that
*also* helps M2 density.

## Three things others may miss

1. **The SPICE deck advertises 12 MIM subckts but the upstream
   device summary blesses only one** (`mim_single_2p0fF`). Sister
   reports relying on `sm141064_mim.ngspice` alone will overstate
   the design space — the foundry-shuttle picks one mask set per
   tape-out.
2. **The 100×100 µm per-MIM-tile DRC ceiling** (MIMTM.8b /
   MIM.8b) is a hard limit that turns "1 nF storage" into
   "≥50 parallel tiles". The KLayout PCell silently clamps area
   to 10 000 µm² (`cap_mim.py` line 25) — easy to miss.
3. **MIM_1f0 (20 V flavour) stores 4.6× more energy per µm² than
   MIM_2f0 (6.6 V flavour)** when the cap is allowed to see its
   full rating, because energy goes as V². Pairing MIM_1f0 with
   the rectifier-output node before regulation (Family 8 hybrid)
   is a non-obvious architectural win.
