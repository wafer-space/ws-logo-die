# Sub-block / building-block breakdown (industry-survey)

This file is the bill-of-blocks for each architecture catalogued in
[`solutions.md`](solutions.md), translated into concrete `gf180mcuD`
device choices with sizes-of-magnitude where they can be estimated
from public industry data.

## 1. Antenna interface (shared by every architecture)

| Sub-block | Function | `gf180mcuD` realisation | Notes |
|---|---|---|---|
| LA / LB bondpads | Differential antenna feed | Standard wafer.space pad ring; reuse existing analog pad slots | 2 new pads — fits constraint R8 |
| Pad ESD | Protect IC from antenna kickback | `gf180mcu_fd_io` ESD diodes | Sized for one-shot only; *not* re-used as rectifier (NR-10) |
| Tuning cap (T-IND-Cic, fixed) | Resonate PCB-L at 13.56 MHz | MIM cap 1.5 fF/µm² — `cap_mim_1f5_m2m3_noshield` (verified at `sm141064_mim.ngspice` line 12) | 50–97 pF for our 1.6–2.5 µH PCB loop; 33,000–65,000 µm² area |
| Trim-cap bank (T-IND-Trim, optional) | ±30 % range trim | 4× binary-weighted MIM segments + 4× NMOS switches + 4 eFuse bits | LSB ≈ 1.5 pF; switch Ron < 100 Ω trivial; total bank ~24 pF |

## 2. Rectifier (R-CC + R-AC industry default)

| Sub-block | Function | `gf180mcuD` realisation | Notes |
|---|---|---|---|
| Cross-coupled NMOS pair (low side) | Main DC return path | `nfet_06v0` (5 V flavour) | W/L sized for I_peak ≈ 50 mA; ~50 µm × 0.6 µm × 50 fingers |
| Cross-coupled PMOS pair (high side) | Main DC supply path | `pfet_06v0` (5 V flavour) | W/L ~3× the NMOS for matched Ron at half mobility |
| Body-diode start-up path | Bootstrap rail without external bias | Implicit in MOS body | No additional area; relied on for first ~10 µs of cold-start |
| Comparator (R-AC variant) | Sense Vds polarity, drive PMOS gate | Two-stage CMOS comparator with bias chain | tens of µA quiescent per comparator; ≪ 73 ns response on 0.18 µm |
| Reference cell for comparator | Bias the comparator threshold | Bandgap (shared with §5) | Shared with B-IND-Bandgap UVLO |
| Native-nFET-as-diode start-up seed (alternative R-IND-2 path) | Lower-Vth start-up | `nfet_06v0_nvt` (Vth ≈ -0.039 V, verified line 119 of `sm141064.ngspice`) | Mind reverse leakage; useful as seed only |

## 3. Regulator (V-IND-Sh shunt + V-IND-Series LDO mix)

| Sub-block | Function | `gf180mcuD` realisation | Notes |
|---|---|---|---|
| Shunt FET | Pull V_RECT to ground when above V_REG | Large `nfet_06v0` (W ≈ 1000 µm) | Sized to absorb worst-case 50 mA without thermal damage |
| Error amp | Compare V_RECT to V_REF | Single-stage CMOS diff-pair + cascode | sub-µA quiescent target |
| Bandgap reference | 1.20 V reference | Standard 0.18 µm bandgap (BJT-based or MOS-only Banba style) | ~1 µA, ±2 % across PVT |
| Compensation cap | Stabilise shunt loop | MIM cap 5–10 pF (~5,000 µm²) | Required for loop stability |
| Series LDO PMOS pass (V-IND-Series, optional digital domain) | Provide clean digital rail downstream of V_RECT | `pfet_06v0` W ≈ 100 µm | 0.4 V drop-out at 1 mA |
| LDO error amp | Same architecture as shunt | Reuse if separate domain | — |
| LDO Miller cap | Loop stability | MIM 1–5 pF | — |

## 4. Over-voltage protection

| Sub-block | Function | `gf180mcuD` realisation | Notes |
|---|---|---|---|
| Stacked MOS clamp (C-IND-Stack) | Hard clamp at ~6 V abs-max | 6× diode-connected `nfet_06v0` in series | Always-on; small leakage in comfortable corner |
| Active shunt clamp (C-IND-Active) | Trim clamp at 4.5 V | Reuses V-IND-Sh shunt FET + comparator | Merged with regulator (industry standard) |
| Modulator-as-clamp (C-IND-LoadModulator) | Opportunistic clamp via (h) load mod NMOS | Shared with (h) NFC core's modulator (large NMOS at antenna pads) | Stage-2 candidate; saves 0.05 mm² |
| Hard clamp current limit | Protect stack from thermal runaway | Optional poly resistor in series | Sets max sink ~ 100 mA |

## 5. Brown-out / power management

| Sub-block | Function | `gf180mcuD` realisation | Notes |
|---|---|---|---|
| Vth-referenced detector (B-IND-Vth) | First-stage enable | 2× diode-connected `nfet_06v0` + CMOS inverter slicer | ~0 µA quiescent |
| Bandgap UVLO (B-IND-Bandgap) | Precise UVLO for digital domain | Bandgap (shared with regulator) + comparator + 5-pF hysteresis cap | ~1 µA total |
| Power-check current detector (B-IND-Powercheck) | Gate Vout enable on field strength | Sense FET in shunt path + comparator + threshold ref | Defines (f) LED twinkle policy |

## 6. Storage

| Sub-block | Function | `gf180mcuD` realisation | Notes |
|---|---|---|---|
| V_RECT smoothing cap | Smooth carrier ripple | MIM 1–5 nF | At 27.12 MHz ripple, very small cap suffices |
| V_REG bulk cap | Hold rail across mod-pause + ideally polling-gap | MIM under logo, 8–20 nF achievable | **Binding constraint** — see [`report.md`](report.md) §5.5 |
| Digital-domain decoupling | Local decoupling under digital cells | MOS-cap (gate-over-channel) 5–10 fF/µm² | Voltage-dependent but acceptable for digital |

## 7. Bond pads added (incremental over v1)

Beyond the existing v1 pad ring, the harvester needs:

| Pad name | Function | Signal | Industry-standard naming |
|---|---|---|---|
| LA | NFC antenna A | RF differential, 13.56 MHz | NXP "LA", ST "AC0", TI "ANT1" |
| LB | NFC antenna B | RF differential, 13.56 MHz | NXP "LB", ST "AC1", TI "ANT2" |
| (optional) FD | Field-detect open-drain output | Digital low when field present | NXP "FD" — useful for telemetry / co-debug; *not* mandatory for the basic harvester |
| (optional) VOUT_TEST | Test access to Vout for bench characterisation | DC | Not a production pad; Stage-4 / 5 decision |

## 8. Per-architecture sub-block count summary

Quick comparison so the Stage-2 synthesiser can rank architectures by
area cost without re-deriving the table.

| Architecture | # of MOS devices | # of comparators | # of bandgaps | MIM cap area |
|---|---|---|---|---|
| R-IND-2 passive bridge + V-IND-Sh shunt | 4 + ~10 (shunt) | 1 (shunt err amp) | 1 | 5–20 nF (~3 mm²) |
| R-CC cross-coupled + V-IND-Sh shunt | 4 + ~10 (shunt) | 1 (shunt err amp) | 1 | 5–20 nF (~3 mm²) |
| R-AC active + V-IND-Sh shunt | 4 + 2× comparator-FETs + ~10 (shunt) | 3 (2× rectifier + 1× shunt) | 1 (shared) | 6–22 nF (~3.5 mm²) |
| R-AC + V-IND-Sh + T-IND-Trim + C-IND-LoadMod-merged | as above + trim FETs | 3 | 1 | 6–22 nF + ~24 pF trim bank |
| R-CC + V-IND-Sh + B-IND-Powercheck + C-IND-LoadMod-merged | 4 + ~10 + 1 sense FET | 2 (shunt + power-check) | 1 | 5–20 nF |

## 9. Comparison with sister first-principles report's component list

The first-principles report
([`../stage1-first-principles/components.md`](../stage1-first-principles/components.md))
is expected to list the same MOS-device families (`nfet_06v0`,
`nfet_06v0_nvt`, `pfet_06v0`) and the same MIM-cap densities,
because both reports share the PDK ground truth. The industry-
survey angle adds:

- **The trim-cap bank as a standard sub-block** (industry uses
  trimming for production; first-principles may have skipped it).
- **The power-check current-detection block** (industry policy item;
  not a physics derivation).
- **The merged shunt-regulator-as-active-clamp pattern** (industry
  area-saving trick; obvious in retrospect but not first-principles).
- **The dual-use modulator-as-clamp** (industry patent trick).

If the first-principles report is missing any of these, that's a
gap for Stage 2 to close — not a contradiction.
