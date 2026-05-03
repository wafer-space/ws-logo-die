---
item: b
item_name: nfc-harvesting
stage: 1
angle: academic-survey
researcher: claude-opus-4-7-1m (auto-mode, parallel instance 3 of 3, retry pass)
status: draft
last-updated: 2026-05-03
---

# Solution-space — silicon-anchored 13.56 MHz HF rectifier topologies

This file catalogues *peer-reviewed silicon implementations* by
topology family. Each entry is anchored to one or more papers in
[`references.md`](references.md) and reports the **measured silicon
PCE** number from that paper, the process, and the rectifier-input
amplitude regime in which the number applies. The *short names*
(R-AC-LeeMok-2014, R-AC-LuKi-2016, etc.) are stable across this
report and are intended to be merged with the industry-survey
report's R-CC / R-AC / R-IND-2 names by Stage 2.

The exhaustiveness bar set by the parent agent: ≥5 distinct
rectifier topologies, each with peer-reviewed silicon η% number.
We catalogue **9 distinct topologies** spanning the literature.

---

## 1. Passive diode-connected MOS bridge (the baseline)

**Short name:** R-PD-baseline (academic equivalent of industry
R-IND-2).

- **Anchor papers:** Karthaus & Fischer JSSC 2003 [C1] (with
  Schottky); Mandal & Sarpeshkar TCAS-I 2007 [C2] (CMOS
  diode-connected NMOS variant).
- **Process:** 0.5 µm CMOS (Karthaus, with Schottky); 0.18 µm
  (Mandal, diode-connected).
- **Silicon PCE (measured):**
  - Karthaus 2003 [C1]: ~36 % overall (rectifier + matching
    network + multiplier), at 16.7 µW minimum input. The rectifier-
    only PCE figure isolated by Mandal 2007 from a similar
    Schottky-bridge topology: ~75 % at Vpk_in = 1 V.
  - Mandal 2007 [C2] all-CMOS: ~33 % at Vpk_in = 0.5 V (rises with
    Vpk_in).
- **Where it works for us:** Start-up seed only — at our Vpk_ant
  = 3 V the 5 V Vth costs 50 % of the voltage and the topology is
  outclassed by R-CC and R-AC.
- **PDK leverage:** Replacing the Vth ≈ 0.67 V 5 V nFET with the
  PDK's `nfet_06v0_nvt` (Vth ≈ −0.04 V) recovers the Schottky-
  equivalent η without needing Schottky devices — see §2.
- **Failure mode where it has been abandoned:** All commercial NFC
  designs since ~2014 moved to R-CC because passive-bridge
  efficiency at Vpk_ant ~3 V tops out at ~75 % even with Schottky
  and ~50 % without. The academic record is consistent: passive
  bridges survive only in the start-up path.

## 2. Passive bridge with native (low-Vth / zero-Vth) MOS

**Short name:** R-PD-native.

- **Anchor papers:** Umeda *et al.* JSSC 2006 [E1] (closest published
  proxy — uses native-NMOS for the Cockcroft-Walton stages); the
  GF180MCU PDK device file `gf180mcuD/libs.tech/ngspice/sm141064.ngspice`
  provides `nfet_06v0_nvt` with Vth0 ≈ −0.039 V (verified by the
  sister first-principles report).
- **Process:** 0.35 µm (Umeda); proposed for `gf180mcuD` (us).
- **Silicon PCE (extrapolated from Umeda's measured numbers):**
  - Umeda 2006: 950 MHz, 36-stage CW ≥ 4.5 V at −10 dBm input.
    Per-stage PCE ≈ 80–85 %.
  - For our HF case, η_volt ≈ (Vpk_ant − 2·0.04)/Vpk_ant = 97 % at
    Vpk_ant = 3 V, before conduction loss → ~88 % overall (sister
    first-principles report §5.9, table row "R-D / native").
- **Where it works for us:** Strongest contender for *passive*
  rectifier in `gf180mcuD`. Caveat: native-nFET conducts in *both*
  directions for small Vds (negative Vth means subthreshold leakage
  is significant); the 88 % number must be verified by spice with
  reverse-leakage corner.
- **Failure mode:** Native-nFET reverse-leakage at light load. Not
  reported in the academic literature for HF rectifiers because
  most published HF papers use comparator-driven gates (see §4)
  rather than native-Vth diodes; this is therefore *novel
  territory* for our project and a Stage 2 / Stage 4 deep-dive
  candidate.

## 3. Single-stage voltage-doubling Greinacher / Villard with HF MOS

**Short name:** R-GR-HF-1stage.

- **Anchor paper:** MDPI Electronics 2023 single-stage voltage-
  boosting rectifier [I1].
- **Process:** 0.18 µm CMOS.
- **Silicon PCE (measured):** ~75 % peak PCE at 13.56 MHz, with
  voltage gain ~1.6× — achieves regulated 1.8 V from a Vpk_ant
  ~1.2 V.
- **Where it works for us:** The brown-out fallback — when the
  card is held far from the reader and Vpk_ant drops below the
  passive-bridge minimum (≈ 2.3 V for native-nFET), the voltage-
  boosting Greinacher gives DC voltage gain to keep the regulator
  alive. Cost: ~75 % vs ~88 % at higher Vpk_ant, so the topology
  must be *switched in only at low coupling*.
- **Failure mode where abandoned:** Multi-stage Cockcroft-Walton
  dominates this regime in UHF (Vpk_in ≪ Vth) but is poorly
  matched at HF (Vpk_in ≥ 2 V is normal). The 1-stage variant is
  the right HF fit; >2 stages waste 2N·Vth tax.

## 4. Cross-coupled gate-driven full bridge (the academic R-CC)

**Short name:** R-CC-academic.

- **Anchor paper:** *every* 13.56 MHz NFC harvester paper since
  2010 uses this as the *baseline before adding their innovation*.
  Lu–Lam–Ki–Mok TBioCAS 2014 [A1], Lu–Ki JSSC 2014 [A4], and
  Cheng–Gong IEEE Access 2018 [A2] all use the cross-coupled MOS
  bridge as the rectifier core.
- **Process:** 0.35 µm (Lu, Cheng); 0.18 µm (multiple later
  papers).
- **Silicon PCE (measured):**
  - Lu–Ki JSSC 2014 [A4]: peak PCE ~80 %, VCR ~96 %, in 0.35 µm
    CMOS at Vpk_ant = 1.6 V. (Reverse-conduction loss near the
    zero crossings sets the 80 % ceiling.)
  - Without delay compensation, peak PCE in the literature is
    consistently in the **75–85 %** band across 0.35 / 0.18 µm
    processes.
- **Where it works for us:** The mainline architecture, matching
  industry's R-CC choice.
- **Failure mode in the academic record:** "Reverse-conduction
  loss near the zero-crossing" is the reason every paper after
  2014 adds either *switched offset* (A1, A4), *adaptive delay*
  (D1, D2, A3), or *dynamic comparator biasing* (A2) to the
  cross-coupled core. Plain R-CC tops out at ~85 %.

## 5. Active rectifier with comparator-driven high-side (Lee/Mok 2012-family) — switched-offset

**Short name:** R-AC-LeeMok-switched-offset (academic R-AC).

- **Anchor papers:** Lu–Lam–Ki–Mok TBioCAS 2014 [A1] (switched
  offset, the seminal paper); Lu–Ki JSSC 2014 [A4]
  (journal version).
- **Process:** 0.35 µm CMOS (both papers).
- **Silicon PCE (measured):** **80–85 % peak PCE** at 13.56 MHz,
  reportedly delivering >10 mA at 3 V to a 300 Ω load. Voltage-
  conversion ratio (VCR) 96 %. This is the *headline figure of the
  Lee/Mok line*.
- **Where it works for us:** Steady-state high-coupling regime —
  the same "phone-tap" range where the industry R-CC sits.
- **Innovation captured:** The "switched-offset" comparator is
  pre-charged with a deliberate offset that compensates for its
  natural turn-on / turn-off delay at 13.56 MHz. Without that
  compensation the comparator switches *too late* relative to the
  ideal zero-crossing and reverse current flows for ~10 ns per
  cycle — costing ~10 % of PCE.
- **Failure mode (in the literature):** Dynamic offset only
  compensates for nominal-PVT delay; under temperature and Vpk_ant
  variation the offset is wrong and reverse current returns.
  Successor papers (D1, A3) replace the static switched-offset
  with adaptive delay (see §6).

## 6. Active rectifier with adaptive (real-time) delay compensation

**Short name:** R-AC-adaptive-delay.

- **Anchor papers:** Lu–Ki JSSC 2016 [D1] (real-time circuit-delay
  calibration); Cha *et al.* MDPI Energies 2021 [D2] (open-access
  digital adaptive); Cheng *et al.* MDPI Electronics 2021 [D3]
  (time-domain technique).
- **Process:** 0.18 µm CMOS in all three papers.
- **Silicon PCE (measured):**
  - Lu–Ki 2016 [D1]: peak **PCE ~92 %** at 13.56 MHz, VCR 95 %, on
    0.18 µm.
  - Cha 2021 [D2]: peak **PCE 90.6 %** at 13.56 MHz.
- **Where it works for us:** The *most-efficient* steady-state
  topology in the published academic record. Cost: a small SAR-
  style state machine (or a tapped delay line) that runs once per
  carrier cycle to sample whether the comparator switched too
  early or too late, and slides the bias accordingly.
- **Failure mode:** All three papers operate at *high* Vpk_ant
  (≥ 1.5 V); the calibration loop's accuracy is poor at low Vpk_ant
  because the comparator can't distinguish the desired zero-
  crossing from noise. Therefore: same brown-out edge as R-CC.

## 7. SAR-assisted coarse-fine adaptive delay (the 2020 best-in-class)

**Short name:** R-AC-SAR-Ma2020.

- **Anchor paper:** Ma–Cui JSSC 2020 [A3].
- **Process:** 0.18 µm CMOS.
- **Silicon PCE (measured):** **peak PCE 92.6 %, VCR 95.7 %** at
  13.56 MHz, validated across PVT.
- **Where it works for us:** Identical use case to §6 but with a
  more sophisticated calibration loop — a 6-bit SAR
  (coarse-then-fine) per-cycle search for the ideal comparator
  delay. The 0.6 percentage-point improvement over Lu–Ki 2016 is
  small but reflects the maturity of the topology.
- **Cost:** ~10 µW for the SAR calibration logic. At our 0.84–7.7
  mW DC budget (sister first-principles §5.10) this is 0.13–1.2 %
  of the budget — affordable.

## 8. Threshold-cancellation rectifier (Kotani 2007-family)

**Short name:** R-TC-Kotani-self-Vth.

- **Anchor papers:** Kotani–Ito A-SSCC 2007 [B1] (the seminal SVC
  paper); Kotani–Sasaki–Ito JSSC 2009 [B2] (differential-drive
  journal version); Le–Mayaram–Fiez JSSC 2008 [B3] (floating-gate
  variant); Yi–Ki–Tsui TCAS-I 2007 [B4] (analytical framework);
  Hashemi–Sawan–Savaria TBioCAS 2012 [B5] (HF biomedical implant
  application).
- **Process:** 0.35 µm CMOS (Kotani 2007); 0.13 µm CMOS (Hashemi);
  0.25 µm CMOS (Le–Mayaram–Fiez floating-gate version).
- **Silicon PCE (measured):**
  - Kotani 2007 [B1]: 29 % PCE at −9.9 dBm UHF input — the *best
    published number for the input regime* at the time.
  - Kotani–Sasaki 2009 [B2]: 67.5 % PCE peak at low input
    amplitudes (UHF-relevant; HF would scale up given the larger
    Vpk_ant).
  - Hashemi 2012 [B5]: **87 % PCE at 13.56 MHz** in 0.13 µm —
    closest direct HF datapoint, on a Greinacher topology with
    internal Vth cancellation.
- **Where it works for us:** Brown-out edge — when Vpk_ant drops
  toward Vth, the Vth-cancelled topology continues delivering DC
  while a passive bridge has stopped. The PDK's native nFET
  partially overlaps this benefit; SVC adds further cancellation.
- **Failure mode where abandoned:** Static Vth-cancellation has a
  *leakage tax* — the always-on bias path leaks ~1–10 µA at room
  temperature, which is significant at low harvested power.
  Mitigation: dynamic Vth-cancellation (G3 / Sun 2021). Also, the
  bias arrangement is sensitive to PVT and can over-cancel,
  inducing reverse conduction.
- **PDK consideration:** The Le 2008 floating-gate variant [B3]
  *cannot port* — gf180mcuD has no qualified flow for one-time
  charge injection on isolated gates. SVC (Kotani static, B1/B2)
  *can port* — it uses ordinary capacitive coupling and DC bias
  generation.

## 9. Hybrid: half-active (passive low-side, active high-side)

**Short name:** R-AC-half-active.

- **Anchor paper:** Lu–Lam–Ki–Mok TBioCAS 2014 [A1] §III.B
  describes half-active variants tested on the same silicon as
  the full-active for comparison.
- **Process:** 0.35 µm CMOS.
- **Silicon PCE (measured):** ~70 % at Vpk_ant = 1.6 V — about 10
  percentage points worse than the full-active counterpart, but
  saves one comparator's quiescent (~30 µA) and avoids the
  stability concern of the second comparator near the brown-out
  edge.
- **Where it works for us:** Risk-mitigated fallback for §5–§7 if
  the high-precision comparator design proves difficult on
  gf180mcuD.
- **Failure mode:** Loss of one Vth on the low-side passive arm
  costs the full 0.67 V drop (or 0.04 V for native nFET) — at
  low Vpk_ant this is significant.

---

## Summary table — silicon-anchored 13.56 MHz / HF rectifier topologies

| # | Short name | Headline silicon PCE | Process | Best paper anchor | Stage 2 priority |
|---|---|---|---|---|---|
| 1 | R-PD-baseline | ~36 % overall (Karthaus); ~33 % (Mandal CMOS) | 0.5 / 0.18 µm | C1, C2 | low (start-up only) |
| 2 | R-PD-native | ~88 % expected (extrapolated) | gf180mcuD | E1 + sister 1st-princ. §5.9 | **high (PDK leverage)** |
| 3 | R-GR-HF-1stage | ~75 % | 0.18 µm | I1 | medium (brown-out fallback) |
| 4 | R-CC-academic | 75–85 % | 0.35 / 0.18 µm | A1/A4 baseline | **high (industry & academia default)** |
| 5 | R-AC-LeeMok-switched-offset | 80–85 % | 0.35 µm | A1, A4 | high |
| 6 | R-AC-adaptive-delay | 90.6 – 92 % | 0.18 µm | D1, D2 | **high (best fit for our 0.18 µm regime)** |
| 7 | R-AC-SAR-Ma2020 | 92.6 % | 0.18 µm | A3 | high (best-in-class peak) |
| 8 | R-TC-Kotani-self-Vth | 29–87 % depending on regime | 0.35 / 0.13 µm | B1, B2, B5 | medium (brown-out edge) |
| 9 | R-AC-half-active | ~70 % | 0.35 µm | A1 §III.B | medium (risk fallback) |

The published "best in class" PCE for a *13.56 MHz, 0.18 µm,
biomedical-implant-class* HF active rectifier is therefore **92.6 %
(Ma 2020, JSSC, R-AC-SAR-Ma2020)**, with multiple papers reporting
90 %+ and a deep tail of papers in the 75–85 % range for plain
R-CC.

The published worst-case for a 13.56 MHz HF rectifier shipping any
useful power is the Karthaus 2003 / Mandal 2007 baseline at ~33 %.
That sets the *floor*. Our project's GF180MCU choice — without
Schottky, without floating-gate Vth cancellation — has the floor
≥ 33 % (passive 5 V Vth bridge) and the ceiling ≤ 92.6 %
(R-AC-SAR-Ma2020) modulo our specific Vpk_ant range and load.

## Cross-cutting comparison vs the industry-survey sister report

| Sister report's industry name | This report's academic anchor | Convergence finding |
|---|---|---|
| R-IND-2 (passive MOS bridge) | R-PD-baseline / R-PD-native | Identical topology; we add the *native-nFET* angle that academia has not yet published for HF. |
| R-IND-3 (Villard doubler) | R-GR-HF-1stage | Both report the topology is mainly UHF; HF use is brown-out fallback. |
| R-IND-4 (Cockcroft-Walton) | not in our top-9 (rejected) | Convergent: wrong fit at HF main rail. |
| R-CC (cross-coupled bridge) | R-CC-academic | Convergent: same architecture, both report ~80 % PCE, both say it is the *baseline*. |
| R-AC (active comparator-driven) | R-AC-LeeMok / R-AC-adaptive-delay / R-AC-SAR-Ma2020 | Convergent on architecture; *academia outperforms* industry's quoted 90 %+ by a small margin (best 92.6 %). |
| R-BS (gate-bootstrap) | not in our top-9 separately | Convergent — cited in both as a UHF specialty. |
| R-TC (threshold-cancellation) | R-TC-Kotani-self-Vth | Convergent on naming; academia has *more* data on this topology than industry datasheets reveal. |

The single divergence: **the native-nFET passive bridge (R-PD-
native)** is *strongly indicated* by the gf180mcuD PDK reading and
the first-principles Faraday calculation, but is *not* a standard
academic topology because most academic papers don't have access
to a 0.18 µm flow with explicit native devices. This is therefore
project-specific innovation territory rather than a "pick the
published winner" decision.
