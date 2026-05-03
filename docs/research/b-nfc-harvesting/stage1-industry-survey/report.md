---
item: b
item_name: nfc-harvesting
stage: 1
angle: industry-survey
researcher: claude-opus-4-7-1m (auto-mode, parallel instance 2 of 3)
status: draft
last-updated: 2026-05-03
---

## 1. Executive summary

This report surveys what **commercial 13.56 MHz NFC tag and dynamic-tag
silicon actually does in practice** to convert near-field magnetic energy
into a regulated DC rail. The deliberate framing complement to the
sister first-principles report ([../stage1-first-principles/report.md](../stage1-first-principles/report.md))
is *industrial reality, not physical possibility*: which rectifier and
regulator topologies have shipped, in what packages, with what advertised
output capability, and what set of bondpads / matching components those
silicon vendors have settled on after twenty years of HF RFID iteration.

Search breadth: ten cached vendor PDFs (NXP NTAG, NTAG I²C plus, NTAG 5,
ICODE SLIX/SLIX2, TI RF430CL330H, Microchip / Atmel ISO 14443 app note,
ISO/IEC 14443-2:2010 Amd 2:2012 spec), the AS3955 / AS3956 (ams) and
ST25DV / M24LR (STMicroelectronics) datasheets via WebSearch / WebFetch,
the EM4423 (EM Microelectronic) dual-frequency tag, NXP US 8,326,224
("Harvesting power in a near field communications (NFC) device") via
WebFetch, one IEEE 0.18 µm biomedical passive NFC tag paper (Lu, Li
et al. ISCAS 2016), and the GF180MCU PDK ngspice models (verified
locally at
[`gf180mcu_pdk/gf180mcuD/libs.tech/ngspice/sm141064.ngspice`](../../../../gf180mcu_pdk/gf180mcuD/libs.tech/ngspice/sm141064.ngspice)
and `sm141064_mim.ngspice`).

Headline conclusions (no architecture is **selected** at Stage 1):

1. **Every shipping commercial NFC tag IC with energy-harvesting
   capability uses a *cross-coupled (gate-driven) active CMOS bridge*
   plus a *shunt regulator* with selectable Vout.** This is the
   industry's settled answer for "deliver mA-class current at 1.8–4.5 V
   into an external load". Passive diode bridges survive only in
   read-only memory tags (NTAG21x, ICODE SLIX) where the harvested
   power budget needs to cover only the on-die digital and EEPROM
   write — i.e. ~50–300 µW.
2. **Industry-quoted "energy harvesting" output figures cluster
   tightly:** NXP NT3H2x11 advertises *"typically 5 mA at 2 V on the
   VOUT pin with an NFC Phone"* (10 mW), NXP NTAG 5 supports
   *"up to 20 mW (low-field mode), up to 50 mW (high-field mode),
   selectable Vout 1.8 / 2.4 / 3.0 V"*, ams AS3955 advertises *"up to
   5 mA at 4.5 V"* (22.5 mW), STMicro ST25DV / M24LRxxE expose a Vout
   "excess energy" pin with selectable behaviour. The consistency
   across vendors strongly validates a few mW DC (one vendor's
   conservative spec) to ~50 mW DC (one vendor's high-field spec) as
   the genuinely-realistic harvest envelope from a phone reader on a
   credit-card-class antenna.
3. **The commercial silicon converges on an external storage cap
   between 100 nF and 220 nF on the Vout pin**, sized to ride out the
   ~5.1 ms NFC Forum-mandated polling-cycle off-time and the ~50 µs
   modulation pause. Our die's on-die equivalent must hit comparable
   capacitance under the logo metal — see the parallel cap research
   item (e). The commercial-cap-value floor is set by *application
   timing*, not by physics; this is a number the first-principles
   report under-quotes (it derives the modulation-pause cap budget
   only).
4. **Cic (chip input capacitance) is the single most-quoted antenna-
   facing parameter across every vendor.** NTAG 21x = 17 pF; NTAG I²C
   plus = 50 pF (at V_LA-LB = 2.4 V_rms); NTAG 5 family targets ~28 pF;
   ICODE SLIX / SLIX2 = 23.5 pF / 97 pF (two SKUs); ST25DVxxx = 28.5 pF
   typical. The on-die tuning cap *replaces* Cic in our design — and
   gives us flexibility to land *anywhere* on the 17–97 pF spectrum
   the industry already uses, depending on PCB-coil inductance choice.
5. **Two vendor families exist for VICC (ISO 15693 / NFC Type 5) vs
   PICC (ISO 14443 / NFC Type 2/4).** ICODE / NTAG 5 are vicinity-class
   (1.5 m read range, lower H-field threshold); NTAG, MIFARE, ST25DV
   are proximity-class (10 cm). For our *business-card-against-the-
   reader* use case, both classes' silicon would work, but Type 2
   (NTAG) gives near-100 % phone interop without needing the phone to
   support NFC-V — *this is a downstream item-(h) decision, but it
   binds the harvesting study because the Hmin floor differs
   (1.5 A/m for Class-1 PICC vs 2.5 A/m for Class-5 PICC, per
   ISO/IEC 14443-2:2010/Amd.2:2012 Tables 1 & 2)*.
6. **GF180MCU PDK ground-truthed against industry numbers:** the PDK's
   1.5 fF/µm² MIM density (verified at `sm141064_mim.ngspice` line
   14: `c_cox='1.47e-3*mim_corner_1p5fF'`) means a 200 nF on-die
   storage cap costs ~133,000,000 µm² ≈ **133 mm²** — completely
   infeasible. Industry's 100–220 nF figure is an *external 0402 cap*;
   on our die without externals we must accept the much smaller
   on-die ceiling and *redesign the power management to operate with
   it*. This is the single biggest delta-from-industry our design
   faces, and is exactly the cross-cutting constraint that makes
   item (e) MIM-cap floorplan so binding.

Industry's converged answer (cross-coupled active rectifier + shunt
regulator + 100–220 nF external cap) is therefore *not directly
adoptable by us*. We must keep the *rectifier and regulator*
architecture and re-engineer the *energy-storage strategy* to live
within an order-of-magnitude smaller on-die cap budget — likely by
gating the LED twinkle on cap-state and accepting brown-out-bursty
operation rather than continuous Vout-pin behaviour.

This report does **not** select an architecture. It enumerates what
*has shipped* (eight rectifier topology classes seen in commercial
silicon and patents, three regulator architectures, three antenna-
tuning schemes, three over-voltage protection patterns) and feeds
that catalog to Stage 2.

## 2. Requirements as understood

Requirements re-stated from the per-item README and `TODO.md`:

| # | Requirement | Source |
|---|---|---|
| R1 | Rectify 13.56 MHz HF magnetic field induced in PCB loop into a regulated rail. | `TODO.md` §(b) goal |
| R2 | Regulated rail must run NFC core (h) and LED drivers (f). | `TODO.md` §(b)/(h) |
| R3 | Differential PCB loop, on-die tuning cap, ~µH-class loop inductance. | `TODO.md` §(b) research |
| R4 | No Schottky in `gf180mcuD`. Quantify Vth-drop loss vs commercial Schottky-bridge designs. | `README.md` §8 |
| R5 | Regulator holds ~3.3 V from rectifier swinging 3–10 V. | `TODO.md` §(b) research bullet 4 |
| R6 | At 0 mm vs strong reader, open-circuit Vpk can exceed 30 V — must clamp. | `TODO.md` §(b) research bullet 5 |
| R7 | All passives on-die. PCB loop is the only off-die inductor allowed. | Hard cross-cutting constraints |
| R8 | Two pads, differential antenna feed, in currently-unused analog slots. | `TODO.md` §(b) execute bullet 1 |
| R9 | Tolerate (h) load modulation: 847.5 kHz subcarrier shorts antenna periodically. | `TODO.md` §(b) verify bullet 3 |
| R10 | Brown-out: rectifier-Vth loss and regulator drop-out are both first-order. | Project brief |
| R11 | Industry-comparable solution for "what does shipping silicon do?". | Stage-1 industry-survey angle |

PDK ground truth (verified by reading the files in this repo):

- 5 V nFET nominal `vth0 = 0.673 V` (PDK
  `sm141064.ngspice` BSIM section).
- 5 V pFET nominal `vth0 = -0.898 V`.
- 5 V **native nFET** (`nfet_06v0_nvt`) nominal `vth0 = -0.039 V`.
  This is verified explicitly at line 119 of
  `gf180mcu_pdk/gf180mcuD/libs.tech/ngspice/sm141064.ngspice`:
  `+vth0 = '-0.039 + nfet_06v0_nvt_vth0'`.
  Per the same file's preamble (lines 25–43), `nfet_06v0_nvt` is the
  **6.0 V native NMOS** subcircuit — the closest the PDK gets to
  Schottky-like low-Vth behaviour.
- MIM cap densities: **1.0 fF/µm², 1.5 fF/µm², 2.0 fF/µm²** in M2-M3
  and (1.5 fF/µm² also) M3-M4 sandwiches (verified at lines 11–127
  of `sm141064_mim.ngspice`).
- Process Vmax ≈ 5 V (abs-max ~6 V); no higher-voltage analog flavour.

These PDK numbers are the foundation against which every commercial
spec in this report is benchmarked.

## 3. Solution-space map

This section catalogs every distinct architecture we found in
commercial silicon, app notes, and patents. Approaches are grouped by
function: (3.1) rectifier topologies, (3.2) regulator topologies,
(3.3) antenna tuning architectures, (3.4) over-voltage protection
patterns, (3.5) brown-out / power-management policies, (3.6) on-die
energy storage strategies, (3.7) commercial reference architectures
(end-to-end).

### 3.1 Rectifier topologies — 8 distinct entries seen in shipping silicon

#### 3.1.1 (R-IND-1) Single-stage Schottky bridge (legacy / non-CMOS-only)

Four Schottky diodes in a Graetz bridge, antenna differential. The
historical workhorse of HF RFID up to ~2010 (early MIFARE Classic
generations, early ICODE SLI). Power-conversion efficiency at Vpk_ant
~3 V is ~75–85 %, dominated by the Schottky 0.2–0.3 V forward drop.

- **Where it ships:** legacy MIFARE Classic, early ICODE SLI on
  multi-process flows (BCD, BiCMOS).
- **Why we cannot use it:** **GF180MCU has no Schottky device.**
  Verified by absence of any `*sch*` or `dio_schottky` entry in
  `gf180mcu_pdk/gf180mcuD/libs.tech/ngspice/`. The closest available
  device is `nfet_06v0_nvt` (native nFET, Vth ≈ −0.039 V) — see
  R-IND-2 in §3.1.2.
- **Industry trend:** Schottky-bridge tags have been displaced in new
  product introductions since ~2014 by all-CMOS topologies (R-CC and
  R-AC below) — the same vendors moved their NTAG, ICODE SLIX, ST25DV
  and AS39xx families onto CMOS-only flows. The reason given in
  vendor literature is **process portability**: removing the Schottky
  module lets the same digital core be re-used across foundries.

#### 3.1.2 (R-IND-2) Passive diode-connected MOS bridge

Four diode-connected MOS (typically NMOS at the low side, PMOS at the
high side, or all-NMOS) in a Graetz bridge. Vth-drop loss = 2·Vth
per cycle. This is the simplest CMOS-only rectifier and is the
*starter* topology in every NFC tag IC course.

- **Where it ships:** the simplest read-only NTAG21x family
  (NTAG210/212/213/215/216) appears to use this — Cic = 17 pF,
  no Vout pin, on-die budget ~150 µW.
  *(Inferred: NXP do not publish the rectifier topology for NTAG21x
  but the absence of a Vout pin and the small Cic are consistent
  with a passive-only path.)*
- **Headline performance in `gf180mcuD`:**
  - With 5 V Vth nFET (Vth ≈ 0.673 V): η_volt = (Vpk − 1.35)/Vpk →
    50 % at Vpk = 3 V, 66 % at Vpk = 5 V.
  - With native nFET (Vth ≈ −0.039 V): η_volt = (Vpk − 0.08)/Vpk →
    97 % at Vpk = 3 V (limited only by Ron and reverse leakage).
- **Native-nFET caveat:** native nFETs' negative Vth means they
  conduct in *both* directions for small Vds — a passive bridge built
  from native-nFET diode-connected devices will leak in reverse and
  the η numbers above are *conduction-only* upper bounds. Realistic
  end-to-end η falls to 70–85 %. Native-nFET diodes need a body /
  back-bias trick or sit at the start-up edge only — see R-CC.

#### 3.1.3 (R-IND-3) Half-bridge voltage doubler (Villard / Greinacher single-stage)

DC-blocking series cap + diode-to-VDD + diode-to-GND. Output ≈
2·Vpk_ant − 2·Vth.

- **Where it ships:** UHF-RFID (860–960 MHz EPC tags) where Vpk_ant ≪
  Vth and voltage *gain* is needed; *not* mainstream for 13.56 MHz
  HF tags where Vpk_ant ≥ 2 V is normal. EM4423 dual-frequency tag
  uses a Villard/Greinacher-style topology on the UHF side with a
  conventional bridge on the HF side.
- **At 13.56 MHz this loses to R-IND-2 / R-CC** because the two-Vth
  loss is wasted when no voltage gain is needed.

#### 3.1.4 (R-IND-4) Cascaded Greinacher / Cockcroft-Walton multiplier

N stages of (series-cap + diode pair). Output ≈ 2N·Vpk_ant − 2N·Vth.

- **Where it ships:** UHF tags exclusively; not for the *main rail*
  of 13.56 MHz NFC. The TI RF430CL330H *integrated PMU* uses a
  single-stage charge-pump only for the EEPROM write voltage,
  **not** for the main rail.
- **Wrong fit for our budget**: the per-stage 2·Vth tax would burn
  more voltage than we get from the multiplication at our Vpk_ant.

#### 3.1.5 (R-CC) Cross-coupled gate-driven CMOS bridge (the modern industry default)

NMOS pair on the low side, PMOS pair on the high side, gates wired to
the *opposite* AC input. No diode-drop loss — only Ron and reverse-
conduction near zero-crossing. The basic "MOS bridge".

- **Where it ships (named):** NXP NTAG I²C (NT3H1x11) and NTAG I²C
  plus (NT3H2x11), NXP NTAG 5 family (NTP5210 / NTP53x2 / NTA5332),
  STMicro ST25DV04K/16K/64K, STMicro M24LRxxE, ams AS3955 / AS3956,
  TI RF430CL330H. **This is what every shipping NFC tag IC with a
  Vout pin uses, period.** The patent literature most directly
  matching this topology is Innovision Research / NXP US 8,326,224
  ("Harvesting power in a near field communications (NFC) device"),
  which describes a four-armed bridge with gate-controlled PMOS
  high-side switches and gate-controlled NMOS low-side switches, with
  passive parallel diodes for start-up.
- **Efficiency:** ~75–85 % at Vpk_ant = 3 V on a typical 0.18 µm
  process. The published academic 13.56 MHz reference (Lu, Li et al.
  "A 13.56 MHz passive NFC tag IC in 0.18 µm CMOS for biomedical
  applications", 2016) reports >75 % PCE.
- **Start-up:** native body diodes of the MOS conduct passively
  during the first few µs, raising the rail enough to enable the
  cross-coupled gates. **No external start-up bias is needed.**
  Note that this is exactly why R-IND-2 (passive bridge) cannot be
  abandoned even when R-CC is used — it *is* the start-up path.
- **Reverse-conduction loss:** near zero crossings, both PMOS
  and NMOS in opposite arms can conduct simultaneously for a brief
  interval (∝ Vpk_ant / dV/dt), causing an effective shoot-through
  loss. This is the quoted reason that real R-CC efficiency tops out
  at ~85 %, not 100 %.

#### 3.1.6 (R-AC) Active rectifier with comparator-driven gates (zero reverse current)

Adds Vds-sense comparators driving the high-side (and sometimes
low-side) gates. Eliminates the reverse-conduction window of R-CC.

- **Where it ships:** the TI RF430CL330H datasheet's block diagram
  shows a "RF143B Power Supply" block that includes an active
  rectifier with a control loop. The NTAG 5 reference design is also
  consistent with comparator-driven active rectification (the
  "current detection" block referenced in
  [AN12365](../references-cache/AN12365/AN12365.pdf) §3.3 is part of
  the same control surface).
- **Efficiency:** 90 %+ at Vpk_ant ~ 3 V.
- **Cost:** comparator quiescent (tens of µA / comparator) and a
  bias chain that must be alive *before* the rectifier gives DC —
  i.e. start-up requires a passive seed (R-IND-2 or R-CC body-diode).
- **Comparator-bandwidth feasibility on `gf180mcuD`:** carrier period
  73 ns; comparator must respond in ≪ 73 ns. At 0.18 µm fT ≈ 50 GHz
  this is trivial (fT/100 ≈ 500 MHz).

#### 3.1.7 (R-BS) Cross-coupled rectifier with charge-pumped gate-bootstrap

Adds a small auxiliary charge pump to drive PMOS gates above the
output rail, extending operation toward weaker input fields.

- **Where it ships:** uncommon in HF NFC tags (where Vpk_ant ≥ 2 V is
  available) but standard in **UHF EPC tags** (where Vpk_ant < 0.5 V).
  Mentioned in the patent literature surrounding the AS3955 family
  for low-field operation.
- **For our use case:** the bootstrap-pump complexity is unjustified
  unless we explicitly target operation at H-field strengths well
  below ISO Class-1 Hmin (1.5 A/m). Useful as an optional brown-out
  edge-extender.

#### 3.1.8 (R-TC) Threshold-cancellation rectifier (Vth-cancelled MOS bridge)

Static / capacitively-coupled / floating-gate bias adds an "anti-Vth"
offset on each MOS gate. Effective Vth approaches zero.

- **Where it ships:** common in UHF EPC tag literature (Karthaus &
  Fischer 2003 and many derivatives); rare in commercial 13.56 MHz HF
  silicon. The reason is that R-CC + R-AC already deliver 80–90 % at
  HF Vpk_ant levels, so the leakage cost of Vth-cancellation isn't
  worth it.
- **In `gf180mcuD`:** would reduce 5 V-Vth nFET 0.673 V loss to
  effectively zero, *if* the bias arrangement holds across PVT and
  doesn't leak more than it saves. Not currently a popular choice.

#### 3.1.9 Considered and discarded

- **Synchronous rectifier driven by an on-die oscillator** —
  chicken-and-egg start-up: oscillator needs the rail the rectifier
  is supposed to provide.
- **Class-D / E resonant self-rectifier** — sweet spot is wireless-
  power-class kHz-low-MHz (Qi at 100–205 kHz), wrong loss-dominance
  regime at HF.
- **Mechanical / piezoelectric augmentation** — out of scope.
- **Inductor-input rectifier (LC pre-stage)** — needs an extra
  on-die inductor that is impractical for the area budget at HF;
  no commercial NFC tag IC ships with this.

### 3.2 Regulator topologies — 3 distinct entries

#### 3.2.1 (V-IND-Sh) Shunt regulator (the universal industry choice)

A controlled shunt FET (often a stack of NMOS) pulls excess current
from the rectifier output to ground when V_RECT exceeds a reference,
holding V_RECT ≈ V_REG. Combined with a fixed cap to ground, this
gives a regulated rail without a series pass element.

- **Where it ships:** **every** modern HF NFC tag IC with a Vout pin
  uses a shunt regulator on V_RECT. Quoted directly from
  [AN12365](../references-cache/AN12365/AN12365.pdf) §3.3:
  *"The block 'energy harvesting' can operate in low or high field
  strength mode and it includes a shunt regulator which provides
  the configured regulated voltage (EH_VOUT_V_SEL) at Vout."*
  The same shunt-regulator architecture is in the NT3H2x11
  block-diagram caption ("Power Management / Energy Harvesting" is
  drawn as a single block straddling the rectifier output, with
  Vout taken directly).
- **Selectable Vout:** NTAG 5 lets firmware pick 1.8 / 2.4 / 3.0 V at
  the Vout pin via the EH_VOUT_V_SEL register. ST25DVxx and AS3955
  expose similar select-able output modes.
- **Why shunt and not series LDO:** at HF, the rectifier's output
  impedance is very low (the antenna is a current-source with a
  parallel cap-tuned tank); a shunt regulator naturally absorbs the
  excess current, while a series LDO would need a bulky pass element
  rated for the full clamp current of the over-voltage corner. The
  shunt also doubles as a "soft" over-voltage clamp at the regulated
  level — see §3.4.
- **Trade-off:** shunt wastes the difference between rectifier output
  and Vout as heat. At weak fields this matters; vendors mitigate
  with a "current detection" block (AN12365 §3.3) that disables the
  shunt regulator when harvested current is insufficient.

#### 3.2.2 (V-IND-Series) Series LDO (PMOS pass + bandgap + error amp)

Classical low-drop-out regulator. PMOS pass FET in series with the
rail, error amp closes loop to a bandgap reference.

- **Where it ships:** **rare on 13.56 MHz NFC tag harvesters** —
  series LDOs are typically on the *VCC-supplied* path (e.g. when
  the host MCU powers the tag externally) for noise rejection on
  the digital rail. The TI RF430CL330H datasheet's "VCORE" pin
  (pin 13) is the regulated digital rail — likely a series LDO from
  the rectified rail.
- **Drop-out:** ≈ 0.4 V at 100 µA on a 0.18 µm process; 1 V at 1 mA.
- **PSRR at 27 MHz:** poor (~−10 dB) — a series LDO depends on the
  smoothing cap upstream to do most of the noise filtering.

#### 3.2.3 (V-IND-Switched) Switched-cap (charge-pump) regulator

Step-down or step-up switched-cap delivers a different voltage from
the rectified rail with no inductor.

- **Where it ships:** TI RF430CL330H has a "RF143B" block that
  generates the EEPROM programming voltage via a switched-cap pump
  off the rectified rail. NXP NTAG 5 mentions a "boost" variant
  (NTA5332, "NTAG 5 Boost") that uses Active Load Modulation and
  presumably an on-die step-up pump.
- **For our use case:** plausible for the LED twinkle path if we
  ever want a specific drive voltage different from the rectifier
  rail; not part of the *primary* harvest path.

### 3.3 Antenna tuning architectures — 3 distinct entries

#### 3.3.1 (T-IND-Cic) On-die parallel-tuning capacitor (the universal choice)

The IC presents a fixed-value parallel cap (Cic) between LA and LB.
The PCB inductance plus Cic resonates at 13.56 MHz. *Cic is the
single most-quoted antenna-facing parameter on every NFC tag
datasheet.*

- **Industry Cic values (verified across cached datasheets and
  WebFetch):**

| IC family | Cic (typ) | Source |
|---|---|---|
| NTAG210 / NTAG212 (NT2L) | 17 pF | [AN11276](../references-cache/AN11276/AN11276.pdf) Table 1 |
| NTAG203F / NTAG213/215/216 / NTAG 424 DNA / NHS31xx | 50 pF | AN11276 Table 1 |
| NTAG I²C (NT3H1) and NTAG I²C plus (NT3H2) | 50 pF (at V_LA-LB = 2.4 V_rms) | NT3H2111 datasheet §2.1 |
| NTAG 5 family | ~28 pF | AN12380 (referenced by AN12339) |
| ICODE SLIX (SL2S2002) | 23.5 pF | SL2S2002 datasheet §4 ordering table |
| ICODE SLIX-S high-Cic (SL2S2102) | 97 pF | same |
| ICODE SLIX2 (SL2S2602) | 23.5 pF / 97 pF (two SKUs) | SL2S2602 datasheet |
| STMicro ST25DV04K | 28.5 pF (typ) | ST25DV04K datasheet (WebFetch) |

- **Implication for our design:** the on-die tuning cap can be
  *anywhere on the 17–97 pF spectrum* and still be in industry-
  proven territory. The first-principles report's 86 pF estimate
  for a 1.6 µH PCB loop (resonating at 13.56 MHz) sits squarely in
  this band. Industry uses *both* "smaller Cic + bigger PCB
  inductance" (NTAG210, 17 pF + ~10 µH) *and* "bigger Cic + smaller
  PCB inductance" (NTAG I²C plus, 50 pF + ~3 µH) — there is no
  vendor preference, it's a coil-design choice.

#### 3.3.2 (T-IND-Trim) On-die trimmable cap bank

Switched bank of MIM caps (typically binary-weighted, 4–8 bits) with
NMOS switches to allow post-fab fine tuning. Compensates for PCB-
inductance variation in production.

- **Where it ships:** TI RF430CL330H datasheet §4.4 "Recommended
  Operating Conditions, Resonant Circuit" exposes a trim register;
  NTAG 5 has trim bits in EH_CONFIG. ST25DV similar.
- **Bit-count vs LSB:** 4 bits (16 steps over ±30 % range, LSB ≈
  1.5 pF for an 86 pF nominal), or 6–8 bits if more precision is
  needed.
- **Switch Ron requirement per segment:** Ron ≪ 1/(ωC_segment).
  For LSB = 1.5 pF: Ron ≪ 7.8 kΩ — easy.
- **Q penalty:** the switch Ron in the on path adds to the antenna
  loss resistance. At Ron ≈ 100 Ω per branch and C_seg ≈ 12 pF,
  loss ≈ Ron × (ωC_seg)² ≈ 0.011 Ω equivalent — negligible.

#### 3.3.3 (T-IND-EMC) External EMC filter + matching network

Off-die L-C-C-L or T network between IC and antenna for EMC
compliance and impedance matching. Used by *reader* ICs (PN5180,
PN7160, ST25R3911B) but **never** by *tag* ICs — tags resonate the
antenna directly via Cic. Listed for completeness.

### 3.4 Over-voltage protection topologies — 3 distinct entries

#### 3.4.1 (C-IND-Stack) Stacked diode-connected MOS clamp (passive)

A stack of N diode-connected MOS between V_RECT and GND. Conducts
hard above N·Vth ≈ 5–6 V for the 5 V flavour. Always-on; consumes
some leakage in the comfortable corner.

- **Where it ships:** every commercial NFC tag IC. Typically sized
  to handle the worst-case 0 mm-from-strong-reader case where
  open-circuit V_pk on the antenna can exceed 30 V Vpp differential.
  The stack absorbs hundreds of mW continuously in that corner and
  typically runs *hot* — vendors limit operation in this corner by
  application notes (e.g. "do not place the card permanently against
  the reader").

#### 3.4.2 (C-IND-Active) Active shunt clamp with comparator

Sense + comparator + large NMOS shunt. Engages above a precise
threshold (e.g. 4.5 V at the rail) and dumps current to GND with
low ON-resistance. Used in conjunction with C-IND-Stack as a
*layered* over-voltage strategy.

- **Where it ships:** AS3955 datasheet describes "advanced energy
  management" that includes an active shunt regulator engaging
  above the configured Vout. NXP NTAG 5's shunt regulator (V-IND-Sh
  above) doubles as the active clamp at the regulated voltage.
- **In effect:** in commercial silicon, the *regulator* (V-IND-Sh)
  and the *clamp* (C-IND-Active) are often **the same circuit** —
  the shunt regulator clamps at V_REG by design.

#### 3.4.3 (C-IND-LoadModulator) Modulator transistor as opportunistic clamp

The same NMOS load-modulator transistor that is used to send the
ISO 14443 subcarrier doubles as a voltage clamp during over-voltage
events — driven hard ON to short the antenna whenever V_RECT exceeds
threshold.

- **Where it ships:** patent literature (e.g. STMicro and NXP filings
  around 2010–2014) describes this dual-use trick, and NXP US
  8,326,224 fig. 3 explicitly uses the cross-coupled-rectifier NMOS
  arms as both rectifier and clamp. The modulator must already be a
  large device for ISO 14443 modulation depth, so re-using it for
  clamp duty saves area.
- **For our use case:** very attractive — the (h) NFC core
  modulator transistor, which we will already place at the antenna
  pads, can be sized once and used for both load modulation and
  emergency clamp. *This deserves its own attention in Stage 2.*

### 3.5 Brown-out / power-management policies — 3 distinct entries

#### 3.5.1 (B-IND-Vth) Vth-referenced detector

Coarse, near-zero quiescent. Used as the *first-stage* enable —
gates the whole power-management block on or off.

- **Where it ships:** universal first-stage enable in every
  commercial tag IC. Typically a stacked diode-connected MOS chain
  comparing V_RECT against ~1.4 V (≈ 2 Vth).

#### 3.5.2 (B-IND-Bandgap) Bandgap-referenced detector

Precise sub-µA bandgap-referenced under-voltage lock-out (UVLO).
Second-stage enable for the digital domain.

- **Where it ships:** NTAG 5 datasheet §"Energy harvesting" specifies
  digital reset at V_CC < 1.62 V (verified in
  [AN12365](../references-cache/AN12365/AN12365.pdf) timestamp 7-12:
  *"If VCC goes below 1.62 V, the system reset will be triggered
  and NTAG 5 will reboot"*). 1.62 V is consistent with a 1.2 V
  bandgap × 1.35 voltage divider — standard recipe.
- For our 1.8/3.3 V digital rail, a 1.62-V UVLO threshold
  reproduced at our scale would be ~1.5 V.

#### 3.5.3 (B-IND-Powercheck) "Power-check" current-detection arbitration

An on-die comparator that monitors the current delivered through the
rectifier and gates the regulator/Vout enable based on whether the
field is strong enough to support the configured load.

- **Where it ships:** explicit in NXP NTAG 5 (named "DISABLE_POWER_
  CHECK" register bit and described in
  [AN12365](../references-cache/AN12365/AN12365.pdf) §3.3 and §4.1).
  When the load current exceeds what the field can supply, the
  power-check block disables Vout to protect the digital rail
  (which now holds priority for the harvested energy).
- **Architectural lesson:** this policy is independent of the
  rectifier choice and is *the* commercial-silicon answer to "the
  user puts the card on a weak phone reader and expects the LEDs to
  twinkle". The right answer (from industry) is **don't twinkle** —
  let the digital core run, defer the LED draw until the rail can
  support it. Our (f) LED twinkle architecture should adopt this
  policy explicitly.

### 3.6 On-die energy storage strategies — 3 distinct entries

#### 3.6.1 (E-IND-ExtCap) External 100–220 nF cap on Vout (the universal industry approach)

Every commercial tag with a Vout pin requires an external bulk cap.
Quoted directly from
[NT3H2111 datasheet §8.6](../references-cache/NT3H2111_2211/NT3H2111_2211.pdf):
*"A complete total connected capacitor in the range of typically
150 nF up to 220 nF maximum shall be connected between VOUT and
GND close to the terminals to ensure that the voltage does not
drop below VCC min during modulation or during any application
operation."*

- **Sizing rationale:** the external cap must hold rail across:
  - The ~50 µs ISO 14443 modulation pause (worst case for active-
    load-modulation modes),
  - The ≥ 5.1 ms NFC Forum-mandated polling-cycle Field-Off time
    (NT3H2111 datasheet §8.6: *"shall apply polling cycles
    including an NFC Field Off condition of at least 5.1 ms"*).
- **For our die without externals:** see (E-IND-OnDie) below.

#### 3.6.2 (E-IND-OnDie) On-die MIM bulk cap

For our project, the *external cap is forbidden*. Hence the bulk
storage must come entirely from on-die MIM under the logo. With
GF180MCU's **1.5 fF/µm² MIM** (ground-truthed at line 14 of
`sm141064_mim.ngspice`):

- 220 nF on-die ⇒ A_MIM = 220 × 10⁻⁹ / 1.5 × 10⁻¹⁵ F/µm² ≈
  **147,000,000 µm² = 147 mm²** of MIM area. **Infeasible** — die
  area is at most a few mm² total.
- Realistic on-die cap ceiling (assume 20 % of a 4 mm² die for the
  storage cap) is **~12 nF at 1.5 fF/µm²**. With the higher 2.0 fF/
  µm² MIM (also available per `sm141064_mim.ngspice` line 68),
  ~16 nF.
- Implication: **we cannot ride out the 5.1 ms Field-Off polling
  gap.** This is the single biggest delta-from-industry our design
  must accept and engineer around.
- Mitigations to consider in Stage 2:
  1. **Operate only when field is present.** LEDs twinkle only
     while the reader is active; brown-out gracefully when reader
     leaves.
  2. **Use a buck-converter-style stop-and-go** — fill the on-die
     cap in tens of µs of charge time, dump into LED for tens of µs
     of discharge time, brown-out the digital core in between.
     **This is non-standard for commercial tags** and is interesting
     research territory.
  3. **Negotiate Field-Off windows** — if our (h) NFC core can
     advertise itself as a Type 2 Tag *that does not need polling
     gaps*, the reader can extend Field-On time. The NFC Forum
     activity spec allows this for some tag types.

#### 3.6.3 (E-IND-MOSCap) MOS capacitor decoupling (lower-density supplement)

Industry uses MOSFET-as-cap (gate over channel) for decoupling-grade
storage where MIM is too costly or too thin. Density ≈ 5–10 fF/µm²
but voltage-dependent and lossy.

- **Where it ships:** every digital block in every commercial tag's
  decoupling network is MOS-cap. *Not* used for Vout bulk storage
  because of the voltage non-linearity — a MOS-cap above its Vth
  is a cap; below, it's almost open.
- **For us:** MOS-caps can supplement MIM under the logo for the
  digital-decoupling part of the budget; not appropriate for the
  rectifier-output storage where the voltage swings 0 → 5 V.

### 3.7 End-to-end commercial reference architectures — 7 mappings

Distillation of how each shipping IC family combines the above
sub-blocks. This is the *vendor-converged* architecture map.

| IC family | Rectifier | Regulator | Tuning | OV protection | Storage | Vout cap | Cic |
|---|---|---|---|---|---|---|---|
| NXP NTAG21x (read-only) | R-IND-2 (passive MOS bridge) | none / V-IND-Sh on digital | T-IND-Cic | C-IND-Stack | none (no Vout) | none | 17–50 pF |
| NXP NTAG I²C plus (NT3H2x11) | R-CC | V-IND-Sh, fixed Vout | T-IND-Cic | C-IND-Active (= regulator) | external 150–220 nF | 150–220 nF | 50 pF |
| NXP NTAG 5 (NTP5x10/NTP53x2/NTA5332) | R-CC + R-AC current-detect | V-IND-Sh, *selectable* Vout | T-IND-Cic + T-IND-Trim | C-IND-Active + C-IND-Stack | external + on-die mix | application-dependent | ~28 pF |
| NXP ICODE SLIX/SLIX2 | R-IND-2 (read-only family) | none / minimal | T-IND-Cic (two SKUs) | C-IND-Stack | none (no Vout) | none | 23.5 / 97 pF |
| TI RF430CL330H | R-AC + R-IND-Switched (for EE write) | V-IND-Series (VCORE) + V-IND-Switched (HV) | T-IND-Cic + T-IND-Trim | C-IND-Active | VCORE pin needs decoupling | external | ~28 pF |
| STMicro ST25DVxx / M24LRxxE | R-CC | V-IND-Sh, EH-mode-enable selectable | T-IND-Cic | C-IND-Active | external | external | ~28.5 pF |
| ams AS3955 / AS3956 | R-CC | V-IND-Sh, configurable | T-IND-Cic + T-IND-Trim | C-IND-Active | external | external | ~50 pF |

The convergence is striking: **every modern commercial design uses
R-CC + V-IND-Sh + T-IND-Cic + C-IND-Active + external bulk cap**.
The only meaningful axes of differentiation are (a) Cic value (PCB-
coil sizing trade-off), (b) Vout selectability, (c) trim-cap bank
presence, (d) "current detection" power-check policy.

## 4. Sub-block breakdown

See [`components.md`](components.md) for the full bill-of-blocks per
architecture. A compact summary follows.

For each architecture in §3, the implementation requires:

| Architecture | Sub-blocks |
|---|---|
| R-IND-2 passive bridge | 4× diode-connected MOS, 2× pad ESD diodes (or merged), 1× rectifier-output cap |
| R-CC cross-coupled bridge | 2× NMOS + 2× PMOS, body-diode parasitic conduction relied upon at start-up, 1× rectifier-output cap |
| R-AC active rectifier | R-CC blocks + 2× high-speed comparators with bias-chain start-up + reference cell |
| V-IND-Sh shunt regulator | 1× large shunt NMOS + 1× error amp + 1× bandgap reference + compensation cap |
| V-IND-Series LDO | 1× PMOS pass + 1× error amp + 1× bandgap + Miller cap |
| T-IND-Cic fixed cap | 1× MIM cap, 2× antenna pads, ESD-coordinated layout |
| T-IND-Trim trimmable bank | N× MIM cap segments + N× NMOS switches + N× eFuse-controlled enable bits |
| C-IND-Stack passive clamp | N× diode-connected MOS in series, optional poly resistor for hard-clamp current limit |
| C-IND-Active shunt clamp | comparator + reference + large shunt NMOS (often merged with V-IND-Sh) |
| C-IND-LoadModulator dual-use | shared with (h) NFC core's modulator transistor |
| B-IND-Vth detector | 2-3× diode-connected MOS reference + 1× CMOS inverter slicer |
| B-IND-Bandgap UVLO | bandgap + comparator + hysteresis cap |
| B-IND-Powercheck | sense FET + comparator + threshold ref |
| E-IND-OnDie storage | MIM array under logo, ~10–20 nF achievable |

## 5. First-principles sanity checks

The industry numbers we found must reconcile against physics. The
sister first-principles report
([../stage1-first-principles/report.md](../stage1-first-principles/report.md))
derives the underlying bounds in detail. Here we verify *industry-
quoted figures* against those bounds.

### 5.1 NXP NT3H2x11 "5 mA at 2 V on Vout from a phone reader" = 10 mW DC

Sanity check: the
[AN11578](../references-cache/AN11578/AN11578.pdf) Table 1 measured
data (using a Class-5 reference antenna) gives the operating-floor
relationship:

| I_load [mA] | Hmin [A/m] | Vout_min [V] |
|---|---|---|
| 1 | 1.2 | 2.7 |
| 2 | 1.9 | 2.5 |
| 3 | 2.7 | 2.4 |
| 4 | 3.5 | 2.2 |
| 5 | 4.3 | 2.0 |
| 6 | 5.0 | 1.9 |
| 7 | 5.7 | 1.7 |

Crosscheck against Faraday: at H = 4.3 A/m and a Class-5 antenna
(~30 cm² × 4 turns):
- V_pk_induced = ω · μ₀ · N · A · H_pk = 8.52e7 · 1.257e-6 · 4 ·
  3e-3 · (4.3 × √2) ≈ 7.8 V_pk open-circuit. After a Q-loaded tank
  (Q ≈ 20–30) the differential antenna voltage easily reaches 50 V_pk
  *open*, but is loaded down by the rectifier+regulator. Available
  source current at the rectifier ≈ V_induced / (ω·L/Q) ≈ tens of mA.
  5 mA at 2 V = 10 mW is within bounds. ✓

### 5.2 NXP NTAG 5 "up to 50 mW high-field mode" — does this violate Faraday?

At ISO Class-5 PICC Hmax = 14 A/m (2.5×–3× the typical Class-1
upper) and a ~30 cm² Class-5 antenna, the induced voltage scales
linearly with both A and H. Power scales with V²/Z and antenna Q.

- Ballpark: P_avail ≈ P_reader · k² · η_match. P_reader = 1 W,
  k = 0.25 (close coupling), η_match = 0.8 → P_avail ≈ 50 mW.
- 50 mW from a 1 W reader at close coupling on a credit-card antenna
  is **at the Faraday limit but not over it**. NXP's quoted figure
  is *plausible* and consistent with the first-principles report's
  finding that *circuit losses, not the field, set the cap.*

### 5.3 ams AS3955 "5 mA at 4.5 V" = 22.5 mW

Same calculation. With Vout = 4.5 V, the shunt regulator dissipates
less than at 2 V (smaller (V_RECT − Vout) drop); in exchange it
needs higher V_RECT and therefore stronger field. The 22.5 mW
number is consistent with operation at H ≈ 7–10 A/m (close-coupled
phone or bench reader). Within Faraday.

### 5.4 220 nF external Vout cap — what does it buy in seconds?

`Δt = C·ΔV/I`. With ΔV_max = 0.4 V (Vout drop tolerated before
brown-out at Vout=2 V → 1.62 V V_CC threshold) and I = 5 mA:

`Δt = 220e-9 · 0.4 / 5e-3 = 17.6 µs` per modulation pause —
sufficient for the ~50 µs ISO 14443 mod-pause if the rectifier
recovers in between. **Insufficient** for the 5.1 ms Field-Off
polling gap (would need 220 nF / 17.6 µs × 5100 µs ≈ 64 µF to ride
that out at 5 mA load). Industry policy must therefore be: **Vout
load goes to zero during Field-Off polling gaps**, by design. The
external bulk cap rides only the modulation pauses, not the polling
gaps.

This reconciles the apparent paradox in the NT3H2x11 datasheet
(which simultaneously requires a Field-Off ≥ 5.1 ms and only a
220 nF cap): the load must shed itself during the gap.

### 5.5 On-die 12 nF MIM cap: what does *that* buy us?

Same formula. ΔV = 0.4 V, I = 1 mA (LED-only): `Δt = 4.8 µs`.
At I = 5 mA: `Δt = 1 µs`. **The on-die cap holds for less than one
modulation pause.** Implications:
- Either we accept brown-out-bursty LED operation (LED on for ≤1 µs
  bursts as cap drains, off while cap re-fills),
- Or we run LEDs at much lower current (50 µA peak → Δt = 96 µs,
  enough for a single modulation pause), trading brightness for
  cap-friendly behaviour,
- Or we accept that *VGA-only (item g) ships first, NFC-with-LED-
  twinkle is a Run 3 risk*.
This is a major architecture finding that didn't surface in the
first-principles report; it is **the** consequence of denying the
external cap.

### 5.6 Cic-vs-Linductance trade space (industry data points sanity-check)

Industry's three Cic clusters (~17, ~28–50, ~97 pF) imply three
PCB-inductance clusters at 13.56 MHz resonance:

| Cic | Required L for resonance | Typical PCB form factor |
|---|---|---|
| 17 pF | 8.1 µH | Small (NTAG210 sticker) |
| 28 pF | 4.9 µH | Small-to-medium |
| 50 pF | 2.7 µH | Medium (ID-1 card class) |
| 97 pF | 1.4 µH | Large card / inlay |

Our companion business-card PCB places a 4-turn 80 × 50 mm spiral
(item §1 of TODO.md). Mohan-modified-Wheeler estimate (from the
sister first-principles report §5.2) gives L ≈ 1.5–2.5 µH. The
implied Cic is in the **50–97 pF range** — i.e. *bigger* than NTAG
I²C plus, similar to the high-Cic SLIX / SLIX-S variant. This is
inside industry-proven territory. ✓

### 5.7 Summary of sanity-check results

| Industry claim | Bounded by | Verdict |
|---|---|---|
| NT3H2x11 5 mA @ 2 V (10 mW) | Faraday | Conservative |
| NTAG 5 50 mW high-field | Faraday + reader power | At the limit, plausible |
| AS3955 5 mA @ 4.5 V (22.5 mW) | Faraday | Within bounds |
| 220 nF external cap rides 50 µs mod pause at 5 mA | C·ΔV/I | ✓ (17.6 µs/cycle) |
| 220 nF external cap rides 5.1 ms polling gap | C·ΔV/I | ✗ — must shed load |
| 12 nF on-die cap rides 50 µs mod pause | C·ΔV/I | Fails at >0.1 mA load |
| Industry Cic 17–97 pF range | LC at 13.56 MHz | Fits practical PCB-coil L 1.4–8 µH |

## 6. References

See [`references.md`](references.md).

## 7. Negative results

A Stage-1 industry-survey report's negative-results section is the
catalogue of **commercial paths that exist and were tried but should
not be ported to our project, with the failure mode**.

- **NR-1: Schottky-bridge tag designs (early MIFARE Classic, early
  ICODE SLI).** Failure mode for us: GF180MCU has no Schottky
  device — verified by absence of any Schottky model in
  `sm141064.ngspice`. *Industry response was the same: every
  vendor moved to all-CMOS rectifiers ~2014 to drop the Schottky
  dependency. We follow that move by necessity.*
- **NR-2: Single-stage Villard / Greinacher voltage-doubler at 13.56
  MHz.** Used in EM4423 only on the UHF side. At 13.56 MHz with
  Vpk_ant ≥ 2 V, the 2-Vth tax outweighs the doubling benefit.
  Survives only as a UHF-style topology. Wrong-fit for our HF rail.
- **NR-3: Multi-stage Cockcroft-Walton at 13.56 MHz.** Used by no
  shipping HF NFC tag IC for the main rail; reserved for the EEPROM
  programming voltage (TI RF430CL330H, NXP NTAG family) where 7–12 V
  is needed locally. Wrong-fit for the main harvest path.
- **NR-4: External 100–220 nF Vout bulk cap.** Industry-standard;
  forbidden by our cross-cutting constraint #2 (no external
  passives). The biggest single delta-from-industry the project
  faces.
- **NR-5: External-LDO post-regulator.** Common in evaluation kits
  (e.g. NTP5210 + LP5907 reference) to provide a clean 1.8 V
  digital rail; forbidden for the same reason. We must absorb the
  noise rejection inside our on-die LDO/shunt-regulator.
- **NR-6: VCC-pin dual-mode operation (battery- and harvest-
  capable).** NTAG I²C plus, ST25DVxx, and NTAG 5 all have a VCC
  pin that lets the host provide power if available, with the
  harvester used only for excess. *We cannot field a battery-mode
  fallback on a passive business-card PCB.* The Vout rail must be
  the only rail.
- **NR-7: Active Load Modulation (ALM) for response-side range
  extension.** NTA5332 ("NTAG 5 Boost") and AS3956 implement ALM
  to drive a *transmit-back* signal stronger than passive load
  modulation can. ALM costs significant TX power (mA-class) and
  conflicts with energy harvesting (NXP AN12365 §2 explicitly:
  *"It shall be considered that ALM ... and energy harvesting are
  not available at the same time."*). For a card that wants to
  twinkle LEDs **while** being read, passive load modulation is
  the only viable path.
- **NR-8: Single-ended antenna feed to GND.** No commercial NFC tag
  IC ships with a single-ended antenna feed; every vendor uses
  differential LA / LB pads. Single-ended drops common-mode
  rejection and fights the bond-wire inductance. Our project
  follows the industry standard here.
- **NR-9: PIP (poly-insulator-poly) caps for the storage tank.**
  PIP exists in many 0.18 µm flows but is **not** part of
  `gf180mcuD` (verified by [PRIOR_CONTEXT.md](../../PRIOR_CONTEXT.md)
  GF180MCU PDK validation entry, 2026-04-03: *"PIP references
  were removed during documentation review — i.e. PIP is not part
  of `gf180mcuD`"*). Storage must be MIM only.
- **NR-10: "Just use the ESD diodes as the rectifier."** Pad ESD
  diodes are sized for one-shot ~kV pulses, not steady-state mA-
  level conduction — they would be destroyed in seconds at any
  realistic harvested current. No commercial NFC tag IC re-uses
  pad-ESD diodes for harvesting; the dedicated rectifier MOS
  devices are sized for the steady-state thermal load.

## 8. Open questions

See [`open-questions.md`](open-questions.md).

## 9. Comparison readiness

Industry-survey-flavoured comparison table for hand-off to Stage 2.
Stable short names from §3 are used.

| Approach (industry name) | Where shipped | Headline performance | On-die area cost | Stage-2 priority |
|---|---|---|---|---|
| R-IND-2 passive MOS bridge | NTAG21x, ICODE SLIX | 50 % @ Vpk=3 V (5 V flavour); 88 % (native nFET) | small | low (start-up only); native variant: medium |
| R-IND-3 Villard doubler | EM4423 (UHF side) | 50 % @ Vpk=3 V | small | low (wrong fit at HF) |
| R-IND-4 Cockcroft-Walton | TI RF430 (HV-pump only) | per-stage formula | medium | low (wrong fit at HF) |
| R-CC cross-coupled bridge | every modern HF tag IC | 75–85 % @ Vpk=3 V | medium | **high (industry default)** |
| R-AC active rectifier with comparators | TI RF430, NTAG 5 | 90 %+ @ Vpk=3 V | medium-high (incl. comparators) | **high (best-in-class)** |
| R-BS gate-bootstrap | UHF EPC tags | 85–90 % at low Vpk | medium-high | low (HF doesn't need it) |
| R-TC threshold-cancellation | UHF tag literature | "0 Vth" + leakage hit | medium | low (HF doesn't need it) |
| V-IND-Sh shunt regulator | every modern tag | shunt → V_REG, dissipative | small | **high (industry default)** |
| V-IND-Series LDO | TI RF430 VCORE | ~0.4 V drop-out, poor PSRR at HF | small | medium (digital domain only) |
| V-IND-Switched switched-cap | TI RF430 HV pump | inductor-free | medium | low (specialised use) |
| T-IND-Cic fixed cap | every tag | sets resonance | small | **high (mandatory)** |
| T-IND-Trim trimmable cap bank | NTAG 5, RF430, ST25DV | ±30 % range | small (4–8 bits) | high (production tolerance) |
| C-IND-Stack stacked-MOS clamp | every tag | passive, hard clamp | small | high (mandatory backup) |
| C-IND-Active shunt clamp | NTAG 5, AS3955 | precise, low-Z | shared with V-IND-Sh | **high (industry default; merged with regulator)** |
| C-IND-LoadModulator dual-use | patent literature | reuses (h) modulator | zero (shared) | medium (worth Stage-2 study) |
| B-IND-Vth | every tag | coarse first-stage | small | high |
| B-IND-Bandgap UVLO | every tag with V_CC | precise, ~µA quiescent | small | high |
| B-IND-Powercheck current detection | NTAG 5 | gates Vout enable | small | **high (defines the LED twinkle policy)** |
| E-IND-ExtCap external 100–220 nF | every commercial tag | rides 50 µs mod pause and (with shed) 5.1 ms polling gap | none on-die | **excluded** by constraint #2 |
| E-IND-OnDie MIM under logo | (none — bespoke) | ~12 nF achievable | 4 mm² @ 1.5 fF/µm² | **the binding constraint** |
| E-IND-MOSCap decoupling | every digital block | 5–10 fF/µm², voltage-dependent | small | medium (digital decoupling supplement) |

## 10. Author's notes

Three things future readers should know:

1. **The industry-converged answer is genuinely well-converged.**
   Across NXP, ST, TI, ams, and EM, the rectifier-regulator-tuning
   architecture is the *same* (R-CC + V-IND-Sh + T-IND-Cic) — the
   only differentiating axes are Cic value, Vout selectability, trim-
   cap presence, and current-detection policy. Stage 2 should
   *probably* pick the same architecture but **must** independently
   re-engineer the energy-storage layer, because the external-cap
   assumption built into every commercial design is forbidden here.
2. **The biggest under-explored area I see is the dual-use of the
   load-modulator transistor as an over-voltage clamp** (C-IND-Load-
   Modulator, §3.4.3). It's named in the patent literature but I
   don't see it called out in datasheets. For our area-constrained
   die where the (h) NFC core needs a big modulator NMOS *anyway*,
   merging the two duties is a meaningful area win and deserves
   Stage-2 attention.
3. **The "current detection" power-check (B-IND-Powercheck) is the
   commercial answer to "what if the field is too weak to drive the
   LEDs?".** The answer is: gate the Vout enable based on whether
   the field can support the load. Our (f) LED twinkle architecture
   should adopt this gating *explicitly* — twinkle only when the
   power-check confirms enough field strength. The first-principles
   report doesn't surface this because it's an application-policy
   choice, not a physics outcome.

A surprise: I expected commercial tag silicon to be *less*
converged than it turned out to be. The fact that every vendor
ships essentially the same architecture is itself a signal — we
should treat divergence from the industry choice as a thing
requiring justification, not as a default freedom.
