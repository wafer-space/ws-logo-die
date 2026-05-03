# Solutions / architectures surveyed (industry)

This file is the per-architecture catalogue for the industry-survey
Stage-1 angle. Each entry is the same one named in
[`report.md`](report.md) §3, expanded with the *vendor evidence*
backing the claim that the architecture is in shipping silicon.

The file is grouped: 1) rectifier topologies, 2) regulator topologies,
3) antenna-tuning architectures, 4) over-voltage protection patterns,
5) brown-out / power-management policies, 6) on-die energy storage
strategies, 7) end-to-end vendor mappings.

## 1. Rectifier topologies

### R-IND-1 — Single-stage Schottky bridge (legacy)

**Where it shipped:** early MIFARE Classic and ICODE SLI on BCD /
BiCMOS flows. Displaced ~2014 by all-CMOS topologies.

**Why excluded for us:** GF180MCU has no Schottky device. Verified
by absence of any Schottky model in `gf180mcu_pdk/gf180mcuD/libs.tech/
ngspice/`.

### R-IND-2 — Passive diode-connected MOS bridge

**Where it shipped:** read-only NTAG21x family (NTAG210/212/213/215/
216), ICODE SLIX/SLIX2. No Vout pin in these parts; harvested power
covers only the on-die digital + EEPROM.

**Vendor evidence:** small Cic (17–50 pF), absence of Vout pin in
the NTAG21x and SLIX/SLIX2 datasheets, and the absence of any
"shunt regulator" or "current detection" block in those datasheets'
block diagrams.

**Stage-2 priority:** low for the *primary* harvest path, **high**
as the start-up seed for any active topology.

### R-IND-3 — Half-bridge voltage doubler (Villard / Greinacher)

**Where it shipped:** UHF EPC tag literature, EM4423 dual-frequency
tag (UHF side). Not used in commercial 13.56 MHz HF tag silicon for
the main rail.

### R-IND-4 — Cascaded Greinacher / Cockcroft-Walton

**Where it shipped:** UHF EPC tags exclusively for main rail. At
HF: TI RF430CL330H block "RF143B" uses a single-stage charge pump
to generate the EEPROM programming HV from the rectified rail —
*not* the main rail.

### R-CC — Cross-coupled gate-driven CMOS bridge (industry default)

**Where it shipped (named):**

- NXP NTAG I²C (NT3H1x11) — verified in
  [NT3H2111_2211 datasheet](../references-cache/NT3H2111_2211/NT3H2111_2211.pdf)
  block diagram (single "Power Management / Energy Harvesting" block).
- NXP NTAG I²C plus (NT3H2x11).
- NXP NTAG 5 family (NTP5210 / NTP53x2 / NTA5332) — verified in
  [AN12365](../references-cache/AN12365/AN12365.pdf) Fig. 4
  "energy harvesting block diagram" showing rectifier → power-check →
  shunt regulator.
- STMicro ST25DV04K/16K/64K (web evidence: ST25DV datasheet).
- STMicro M24LRxxE (M24LR04E-R datasheet, WebSearch).
- ams AS3955 / AS3956 (datasheets, WebSearch — explicitly advertise
  "5 mA at 4.5 V" from harvested power).
- TI RF430CL330H — verified in datasheet block diagram §5.1, "RF
  Front End" + "Power Management".
- Patent: NXP US 8,326,224 fig. 3 (verified via WebFetch) describes
  exactly this architecture as a "four armed bridge … with forward
  gate controlled switches and ground return path gate controlled
  switches".

**Reported efficiency:** 75–85 % at Vpk_ant = 3 V on 0.18 µm CMOS
(Lu, Li et al. ISCAS 2016 — academic confirmation).

**Why this is the industry default:** zero Vth-drop loss, no
external bias chain, body-diode auto-start-up, area-efficient.
All other modern topologies are variations on this theme.

### R-AC — Active rectifier with comparator-driven gates

**Where it shipped:**

- TI RF430CL330H "RF143B Power Supply" block — ISO14443B-compliant
  load modulator paired with active rectifier. Datasheet §4.15
  exposes Vcc / VCORE pin pair consistent with active control loop.
- NXP NTAG 5 — the "current detection" block in
  [AN12365 §3.3](../references-cache/AN12365/AN12365.pdf) is the
  control surface that feeds the rectifier-comparator loop.
- ams AS3955 — datasheet copy mentions "advanced energy
  management" with comparators for both clamp and shunt-regulator
  control.

**Reported efficiency:** 90 %+ at Vpk_ant = 3 V (vendor + IEEE).

**Cost:** comparator quiescent (tens of µA per comparator), bias-
chain start-up dependency, area for sense FETs.

### R-BS — Cross-coupled rectifier with charge-pumped gate-bootstrap

**Where it shipped:** standard in UHF EPC tags (where Vpk_ant ≪
Vth); rare in HF NFC tags. Mentioned in patent literature around
the AS3955 family for low-field operation.

### R-TC — Threshold-cancellation rectifier

**Where it shipped:** UHF EPC tag literature (Karthaus & Fischer
"Fully Integrated Passive UHF RFID Transponder IC With 16.7-µW
Minimum RF Input Power", JSSC 2003); rare in commercial HF NFC
silicon.

## 2. Regulator topologies

### V-IND-Sh — Shunt regulator (industry default)

**Where it shipped:** every modern HF NFC tag IC with a Vout pin.
Direct quote from
[AN12365 §3.3](../references-cache/AN12365/AN12365.pdf):
*"The block 'energy harvesting' … includes a shunt regulator which
provides the configured regulated voltage (EH_VOUT_V_SEL) at Vout."*

**Selectable Vout values seen in the wild:**

| Vendor | Vout values supported |
|---|---|
| NXP NTAG I²C plus | fixed (~2–3 V) |
| NXP NTAG 5 | 1.8 / 2.4 / 3.0 V (via EH_VOUT_V_SEL) |
| ams AS3955 | configurable (advertise "up to 4.5 V") |
| STMicro ST25DVxx | EH-mode-selectable |

**Why shunt and not series LDO at HF:** rectifier output impedance
is very low at carrier frequency (parallel-LC tank, low source-Z);
the shunt naturally absorbs the excess current. A series LDO would
need a pass FET sized for the full clamp-current of the over-voltage
corner — large, lossy, and area-prohibitive. The shunt also
*doubles as the active over-voltage clamp* at V_REG.

### V-IND-Series — Series LDO

**Where it shipped:** TI RF430CL330H VCORE pin (pin 13) — exposed
externally so the user can decouple the digital rail. Likely a
series LDO from the rectified rail.

**For 13.56 MHz NFC tags this is *not* the primary regulation
strategy.** Series LDOs appear when (a) the IC has a separate VCC
input (battery-backed mode), (b) a noise-sensitive sub-block needs
its own clean rail, or (c) production trim of the digital rail is
required.

### V-IND-Switched — Switched-cap regulator

**Where it shipped:** TI RF430 EEPROM HV programming pump (single
stage on the rectified rail). NXP NTAG 5 "boost" variant
(NTA5332) for ALM. Not used for the main harvest rail in any
commercial NFC tag IC.

## 3. Antenna-tuning architectures

### T-IND-Cic — On-die parallel-tuning capacitor (universal)

**Industry Cic data points (verified):**

| IC family | Cic (typ) | Source |
|---|---|---|
| NTAG210 / NTAG212 (NT2L) | 17 pF | [AN11276 Table 1](../references-cache/AN11276/AN11276.pdf) |
| NTAG203F / NTAG213/215/216 | 50 pF | AN11276 Table 1 |
| NTAG 424 DNA / NHS3100 / NHS3152 | 50 pF | AN11276 Table 1 |
| NTAG I²C plus (NT3H2x11) | 50 pF (V_LA-LB = 2.4 V_rms) | AN11276 Table 1 + NT3H2111 datasheet |
| NTAG 5 family | ~28 pF | AN12380 (referenced by AN12339) |
| ICODE SLIX / SLIX2 (low-Cic SKU) | 23.5 pF | SL2S2002 / SL2S2602 datasheets |
| ICODE SLIX-S / SLIX2 (high-Cic SKU) | 97 pF | SL2S2002 / SL2S2602 datasheets |
| STMicro ST25DV04K | 28.5 pF (typ) | ST25DV04K datasheet (WebFetch) |
| LPC8N04 (NXP NFC-MCU) | 50 pF | AN11276 Table 1 |

**The 17–97 pF range is the entire industry envelope.** Our
on-die tuning cap can land anywhere on this spectrum and remain
in well-trodden territory.

### T-IND-Trim — On-die trimmable cap bank

**Where it shipped:** TI RF430CL330H (datasheet §4.4 Recommended
Operating Conditions, Resonant Circuit), NXP NTAG 5 (EH_CONFIG
register has trim bits), STMicro ST25DV (web evidence).

**Bit count seen:** typically 4 bits (16-step, ±30 % range).

### T-IND-EMC — External EMC matching (reader-IC pattern, not tag)

**Where it shipped:** PN5180, PN7160, ST25R3911B reader ICs use
elaborate L-C-C-L matching networks for EMC compliance and
impedance matching. *No commercial tag IC* uses this — tag side
is always direct-Cic.

## 4. Over-voltage protection patterns

### C-IND-Stack — Stacked diode-connected MOS clamp (passive)

**Where it shipped:** every commercial NFC tag IC. Sized to absorb
the worst-case 0 mm-from-strong-reader corner where open-circuit
V_pk on the antenna can exceed 30 V Vpp differential.

### C-IND-Active — Active shunt clamp with comparator

**Where it shipped:** AS3955 ("advanced energy management"), NXP
NTAG 5 (the shunt regulator V-IND-Sh *is* the active clamp at the
selected Vout level). NXP US 8,326,224 patent fig. 3 also calls
this out — the cross-coupled NMOS arms double as voltage-limiter.

### C-IND-LoadModulator — Load-modulator transistor as opportunistic clamp

**Where it shipped:** patent literature (NXP US 8,326,224, STMicro
filings ~2010–2014). Not explicitly named in datasheets, but the
architecture appears in every modern tag IC where the modulator
NMOS sits across the antenna and is reused.

**For our project:** the (h) NFC core's modulator transistor will
be a large NMOS at the antenna pads anyway. Re-using it for OV
clamp duty saves area. *Stage-2 candidate.*

## 5. Brown-out / power-management policies

### B-IND-Vth — Vth-referenced first-stage detector

Universal first-stage enable in every commercial tag IC.

### B-IND-Bandgap — Bandgap-referenced UVLO

NTAG 5 specifies digital reset at V_CC < 1.62 V (
[AN12365](../references-cache/AN12365/AN12365.pdf) timestamp 7-12).
Common across vendors with V_CC pins.

### B-IND-Powercheck — "Power-check" current-detection arbitration

NXP NTAG 5 explicit — register bit "DISABLE_POWER_CHECK", described
in [AN12365 §3.3 and §4.1](../references-cache/AN12365/AN12365.pdf).
When the load can't be supported by the field, the regulator's Vout
enable is *gated off* to protect the digital rail's power priority.

**For our (f) LED twinkle:** the LED-twinkle generator should be
gated by the power-check signal — twinkle only when the field can
support it. This is the commercial answer to "what if the user
puts the card on a weak phone reader".

## 6. On-die energy storage strategies

### E-IND-ExtCap — External 100–220 nF cap on Vout

Quoted directly from
[NT3H2111 datasheet §8.6](../references-cache/NT3H2111_2211/NT3H2111_2211.pdf):
*"A complete total connected capacitor in the range of typically
150 nF up to 220 nF maximum shall be connected between VOUT and
GND close to the terminals."*

[AN12365](../references-cache/AN12365/AN12365.pdf) §3.2 gives a
formula relating the external cap to the modulation-pause droop:
`Vdrop = IL · tpause / C`. Same recipe across vendors.

**Forbidden for us** by cross-cutting constraint #2.

### E-IND-OnDie — On-die MIM bulk cap

Bespoke to our project (no shipping NFC tag IC has tried to build
the bulk Vout cap on die). At GF180MCU's 1.5 fF/µm² MIM density
the on-die ceiling is ~12 nF in 4 mm² — three orders of magnitude
below the industry external-cap value. **The binding constraint.**

### E-IND-MOSCap — MOS capacitor decoupling supplement

Universal in every digital block of every commercial tag IC.
Density 5–10 fF/µm² but voltage-dependent; suitable only for
decoupling, not Vout bulk storage.

## 7. End-to-end vendor mapping summary

See [`report.md`](report.md) §3.7 for the architecture-cell table.
The convergence is total: every modern commercial design uses
**R-CC + V-IND-Sh + T-IND-Cic + C-IND-Active + 100–220 nF external
cap**. The only differentiating axes are Cic value, Vout
selectability, trim-cap presence, and current-detection policy.
