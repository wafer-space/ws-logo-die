---
item: e
item_name: mim-cap-storage
stage: 1
angle: industry-survey
researcher: agent-stage1-industry-1of3
status: persisted-from-conversation-log; split-into-5-file-structure
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

## 3. Solution-space map

See [`solutions.md`](solutions.md). 10 cap-storage families
catalogued: MIM (3 density × 4 stacks), MOS-cap, MOM, fillcap,
charge-pump (Dickson/Pelliconi), capacitor multiplier (Miller),
SC DC-DC, hybrid HV-dump, deep-trench (NOT in PDK), and
ferroelectric/RRAM (NOT in PDK).

## 4. Sub-block breakdown

See [`components.md`](components.md) for industry-survey-
specific sub-block findings (PCell names, SPICE deck pointers,
DRC constraints, hybrid HV-dump architecture sub-blocks).

## 5. First-principles sanity checks

(See sister `stage1-first-principles/report.md` §5.)

Industry-survey-specific cross-checks:

- Liu et al. 2018 reference design uses Cst = 10 µF (external),
  Cdem = 5 pF on-chip. Confirms our "real on-die-only at our
  targets is not practiced" finding.
- NTAG213 input C is ~50 pF on-die — for tuning, not for storage.

## 6. References

See [`references.md`](references.md) for the full annotated
bibliography. Headline: 14 references, 7 WebFetched + verified,
3 from direct file reads, 1 IRPS 2019 paywalled (cited by abstract
match), and the GAMBINO-2019 reliability paper (only public
reliability anchor for the GF180 MIM stack).

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

See [`open-questions.md`](open-questions.md). 8 specific
questions covering: `big_logo` metal layer (gates MIM stack
choice), 5LM→6LM stack option, current fillcap_* placement
count, MPW `--variant` selection, NFC modulator current draw,
`Metal2_ignore_active` signoff validity, hybrid HV-dump area
budget, MIM-vs-fillcap ratio optimisation.

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
