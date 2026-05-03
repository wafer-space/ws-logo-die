# Sub-block / building-block inventory — academic-survey angle

This file enumerates the sub-blocks each topology family
catalogued in `report.md` §3 would need if implemented in
GF180MCU. The intent is that a downstream architect can
estimate effort and area cost per topology.

Notation:
- **Tx** = transistor count.
- **Cap** = capacitor count (MIM unless noted).
- **PDK** = uses only standard `gf180mcu_fd_pr` primitives.
- **Custom** = requires hand-rolled / custom-characterised cell.

## TC-1 — Differential cascode voltage-switch (DCVS)

| Sub-block | Function | Tx | PDK / Custom | Notes |
|---|---|---:|---|---|
| Cross-coupled PMOS pull-up | Latch output rail | 2 | PDK | `pfet_06v0`, both gates cross-tied |
| Differential NMOS pull-down pair | Steer current from input | 2 | PDK | `nfet_06v0`, gates from VIN / VINb |
| Output inverter (opt) | Sharp slew on load side | 2 | PDK | std-cell `inv` |
| Tap / body ties | Substrate / nwell tie | 2 | PDK | `filltie` |
| **Total** | — | **8** | PDK | static current ≈ 0 nA when rails healthy |

## TC-2 — Wilson current-mirror level shifter

| Sub-block | Function | Tx | PDK / Custom | Notes |
|---|---|---:|---|---|
| Wilson mirror PMOS array | Limit contention current | 4 | PDK | 2 mirror + 2 cascode |
| NMOS input differential pair | Steer current | 2 | PDK | low-W, sub-Vt biased |
| Bias generator (Iref) | Mirror reference | 4 | PDK | always-on, ~1–10 nA |
| Output inverter | Sharp slew | 2 | PDK | — |
| **Total** | — | **12** | PDK | needs **shared bias network across both domains** — itself an isolation problem |

## TC-3 — Regulated cross-coupled (RCC) — HOSS2019

| Sub-block | Function | Tx | PDK / Custom | Notes |
|---|---|---:|---|---|
| DCVS core (PMOS latch + NMOS input) | Baseline shifter | 4 | PDK | as TC-1 |
| Auxiliary regulator NMOS pair | Reduce pull-up strength dynamically | 2 | PDK | gates from internal nodes |
| Auxiliary diode-connected PMOS | Set regulator headroom | 2 | PDK | acts as level reference |
| Auxiliary current-starve transistors | Limit auxiliary path current | 2 | PDK | — |
| Output buffer | Slew | 2 | PDK | — |
| **Total** | — | **12** | PDK | post-layout: 123 nW @ 1 MHz, 23.7 ns delay (HOSS2019 sim) |

## TC-4 — High-voltage no-static-current level-up (TANG2014)

| Sub-block | Function | Tx | Cap | Notes |
|---|---|---:|---:|---|
| Bootstrap capacitor | Couple input edge to high-V output | — | 2 (MIM) | sized for fan-out load |
| HV NMOS clamp pair | Hold output state between edges | 2 | — | `nfet_10v0` (HV native) — *check GF180MCU has HV NMOS variant* |
| Gate-drive logic | Generate complementary edge pulses | 4 | — | from low-V supply |
| Body-tie isolation | Prevent forward-bias on level-up edge | 2 | — | DNW tap (custom layout) |
| **Total** | — | **8** | **2** | 0 static current; needs HV transistor flavour, GF180MCU has 10 V devices in `gf180mcu_fd_pr` |

## TC-5 — MTCMOS retention flop (***N/A — see negative result***)

NR1 in `report.md` §7: **structurally inaccessible** on
GF180MCU due to single-Vt 5 V std-cell library. Listed for
completeness only:

| Sub-block | Function | Available on GF180MCU? |
|---|---|---|
| High-Vt sleep header (PMOS) | Cut leakage in sleep | **NO** |
| Low-Vt logic (NMOS/PMOS) | Speed in active mode | **NO** (single-Vt) |
| Always-on retention storage cell | Hold state | partially: AON rail can be added, but no PDK retention FF cell exists |
| Restore / save sequencer | Sequence retention save/restore | yes (RTL) |

## TC-6 — Cold-start handshake (protocol)

This is not transistor-level but a system-level protocol.
Sub-blocks per published silicon:

| Sub-block | Function | Implementation |
|---|---|---|
| Power-good detector (per domain) | Voltage-comparator with hysteresis | hand-rolled comparator on each rail; ~10 Tx |
| Rail-OR isolator | Release isolation only when both rails > Vmin | 2-input AND of power-good signals; std-cell |
| Cold-start kick path | Bootstrap rectifier from RF / NFC kick | overlaps with item (b)/(c) — owned there |
| Brown-out detector with deglitch | Re-engage isolation if rail collapses | hysteresis comparator + ~16-cycle deglitch counter |

## TC-extra — Latch-up & DNW substrate guard

Layout-level sub-blocks (no transistors per se):

| Sub-block | Function | Layout / Layer |
|---|---|---|
| PCOMP guard ring (HARV core) | Collect injected substrate holes | P+ in P-sub, tied to global VSS |
| NCOMP guard ring (HARV core) | Collect injected substrate electrons | N+ in N-well, tied to local HARV VDD |
| DNW tub (HARV NMOS, optional) | Float HARV-NMOS bodies above substrate | DNWELL + PWELL inside DNWELL |
| Inter-ring spacing | Per CHEN2021 — avoid parasitic NPN | DRC DN.2b ≥ 5.42 µm; *plus* extra width for the ring itself |
| Active guard (TSAI2015 — fallback) | Inject compensation current on detection | comparator + driver — only if passive guard insufficient |

## Cross-references

- Industry-survey IO-cell counts:
  `gf180mcu_fd_io__dvdd` → 648 nA RC-clamp leakage per pad;
  `gf180mcu_fd_io__cor` → 1296 nA per corner.
  Adding HARV-domain pad pair = + ~2.6 µA static, dominating
  any savings from TC-2 vs TC-3 vs TC-4 quiescent-current
  comparisons. **Optimisation target:
  pad-count, not shifter topology.**
- First-principles seal-ring analysis (`../stage1-first-principles/report.md`
  §5.5): seal-ring is one node at substrate potential — TC-extra's
  DNW tub does not need to cross it.
