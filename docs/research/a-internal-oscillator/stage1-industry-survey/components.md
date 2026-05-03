---
item: a
item_name: internal-oscillator
stage: 1
angle: industry-survey
researcher: claude-opus-4-7-1m (industry-survey instance 1/3)
status: draft
last-updated: 2026-05-03
---

# Sub-block / building-block breakdown -- internal oscillator

This file is the structured backing data for Sec 4 of `report.md`. It
enumerates, per topology family / per topology in
[`solutions.md`](./solutions.md), the *building blocks* (sub-blocks) an
implementation needs. The goal is to give a downstream architect (Stage
2 synthesiser, Stage 3 shortlister, Stage 4 deep-diver) the information
required to assess effort and area cost without re-reading the full
solutions catalogue.

Citation IDs in this file are the same stable IDs used in
[`references.md`](./references.md).

## 1. Master inventory of sub-blocks

Sub-blocks reused across topologies. Per-block area/power numbers are
order-of-magnitude estimates for GF180MCU at the 5 V flavour
(`gf180mcu_fd_sc_mcu7t5v0`); SPICE characterisation is a Stage-4
deliverable.

| Sub-block ID | Brief | Typical area (um^2) | Typical power | GF180MCU primitive |
|---|---|---|---|---|
| SB-INV | Single inverter (timing core element) | 5-15 | sub-uW | `mcu7t5v0__inv_*` |
| SB-NAND | NAND gate (ring enable + start) | 10-25 | sub-uW | `mcu7t5v0__nand_*` |
| SB-RING-N | N-stage inverter ring (N = 5..1001) | 100 (N=5) to 50 000 (N=1001) | scales with N and freq | composed of SB-INV + SB-NAND |
| SB-MIM-CAP | MIM cap as timing capacitor | 500-5 000 | quiescent leak only | `cap_mim_1f0fF` / `_1f5fF` / `_2f0fF` (1.0/1.5/2.0 fF/um^2) |
| SB-POLY-R | Poly resistor (timing R) | 100-1 000 | scales with current | `nplus_u`, `pplus_u`, `nwell` (sheet R 200-8000 ohm/sq) |
| SB-MOS-CAP | MOS cap (decoupling, not for accurate timing) | density ~5 fF/um^2 | quiescent leak only | NMOS gate-cap as cap |
| SB-COMP-HYS | Comparator with Schmitt hysteresis | 200-500 | 5-50 uW | diff-pair + cross-coupled load |
| SB-BANDGAP | Bandgap voltage reference (1.2 V) | 1 500-3 000 | 5-50 uW | PNP+resistor topology, Razavi ch.11 |
| SB-PTAT-I | PTAT current generator | 500-1 500 | 1-10 uW | 2 PNPs + resistor |
| SB-CTAT-I | CTAT (or PTAT^2) current generator | 500-1 500 | 1-10 uW | derived from bandgap |
| SB-EFUSE-N | N-bit eFuse trim register | 50 per bit | nW idle | PDK eFuse + sense-amp; depends on item (j) |
| SB-OSCCAL | OSCCAL-style trim DAC (5-8 bit) | 200-800 | sub-uW | switched-cap or switched-R; HDL-controlled |
| SB-CTR | Counter / divider chain | ~5 per bit | sub-uW | HDL synthesis output |
| SB-FLL-FILT | Digital FLL loop filter (counter + accumulator) | 200-1 000 | sub-uW | HDL synthesis output |
| SB-LSHIFT | Level shifter to a different domain | 50-150 | sub-uW | depends on item (i) |
| SB-PWR-GATE | Power-gate header / footer PMOS | 100-500 | leakage only | sized for osc Iq |
| SB-CARR-COMP | Antenna-input comparator (carrier extract) | 200-500 | 5-50 uW | similar to SB-COMP-HYS |
| SB-WIEN-FB | Wien / twin-T bridge feedback network | 3 000-5 000 | quiescent | poly R + MIM C network |
| SB-OTA | Operational transconductance amplifier | 500-2 000 | 5-50 uW | folded-cascode or two-stage |
| SB-XCOUPLE | Cross-coupled NMOS pair (LC negative-G) | 50-200 | scales with bias | `nfet_06v0` paired |
| SB-SPIRAL-L | On-die spiral inductor (3-30 nH) | 30 000-300 000 | n/a | Metal-stack-defined; only for BLE |
| SB-HEATER | Polysilicon heater (electrothermal ref) | 200-500 | 1-7 mW (active) | poly serpentine |
| SB-TPILE | Thermopile (electrothermal ref readout) | 500-2 000 | sub-uW | poly-Si + metal junctions |
| SB-BETA-MULT | beta-multiplier self-bias loop | 500-1 500 | sub-uW to 10 uW | 4 transistors + poly R |
| SB-EN-DELAY | Enable / soft-start delay element | 50-200 | sub-uW | RC + Schmitt or counter |

Notes:
- "Typical area" is the per-instance footprint for that sub-block on
  GF180MCU; full-block totals in Sec 2 below sum these for each
  topology.
- Power numbers are *active* unless otherwise stated; gating with
  SB-PWR-GATE drops them to leakage (~nW) when the topology is idle.
- SB-EFUSE-N counts only the eFuse cell + sense; the *programming
  infrastructure* lives in item (j) and is shared.

## 2. Per-topology composition

For each topology in [`solutions.md`](./solutions.md), the sub-blocks
needed and an estimated total area / power. These estimates are meant
for Stage-2 / Stage-3 ranking, not implementation sign-off.

### A1 -- Plain CMOS inverter ring

| Sub-block | Count | Note |
|---|---|---|
| SB-NAND | 1 | Enable / start |
| SB-INV | N-1 (N typically 5-15) | Ring stages |
| SB-PWR-GATE | 1 | Power gate to harvested-rail Iq |
| SB-LSHIFT | 1 (output) | Cross-domain to digital |

**Total area:** ~150-1 000 um^2 (depending on N).
**Total power:** sub-uW to a few uW (frequency-dependent).
**GF180MCU prior art:** `[GF180-MABRAINS]` `Ring-Osc-3.3vFETs`,
`Ring-Osc-5.0vFETs`; sky130 reference `[SKY130-RINGOSC-HK]`;
TT prior art `[TT09-RINGOSC]`, `[TT-MV-ANALOG-RINGOSC]`,
`[TT04-ROTEMP]`.

### A2 -- Current-starved ring oscillator

| Sub-block | Count | Note |
|---|---|---|
| SB-NAND | 1 | Enable |
| SB-INV (with current-source heads) | N | Replace plain inverters with starved variants |
| SB-BANDGAP | 1 | Bias reference (shared with rest of chip) |
| SB-PTAT-I | 1 | Bias-current source from bandgap |
| SB-OSCCAL | 1 (4-8 bit) | Frequency trim DAC |
| SB-EFUSE-N | 4-8 bits | Stores OSCCAL trim |
| SB-PWR-GATE | 1 | |
| SB-LSHIFT | 1 | |

**Total area:** ~800-2 000 um^2 *plus* shared bandgap (~3 000 um^2).
**Total power:** 5-50 uW.
**Industry refs:** TI MSP430 DCO topology [`[TI-SLAA336]`,
`[TI-SLAA992]`], Microchip patent [`[USP-6020792]`].

### A3 -- Process-corner-sensing compensated ring

| Sub-block | Count | Note |
|---|---|---|
| (everything in A2) | -- | Base topology |
| SB-PTAT-I + SB-CTAT-I | 1 each | Process probe |
| SB-COMP-HYS | 1 | Process-probe readout |
| SB-FLL-FILT | 1 | Bias-correction loop |

**Total area:** A2 + ~500-1 000 um^2.
**Total power:** A2 + 5-20 uW.
**Industry refs:** STM community thread [`[STM-RC-COMMUNITY]`]; patent
hints in `[USP-6020792]` extended embodiments.

### B1 -- Schmitt-trigger RC relaxation oscillator

| Sub-block | Count | Note |
|---|---|---|
| SB-COMP-HYS | 1 | Schmitt trigger |
| SB-MIM-CAP or SB-POLY-R | 1 each | RC timing pair |
| SB-INV | 1 | Output buffer |
| SB-PWR-GATE | 1 | |
| SB-LSHIFT | 1 | |

**Total area:** <500 um^2.
**Total power:** few uW.
**Industry ref:** ATmega328P 128 kHz watchdog [`[ATMEL-7810D Sec 28.5.2]`].

### B2 -- Comparator-based dual-cap relaxation osc with bandgap bias

This is the **industry default** topology and the one downstream
architects should anchor on.

| Sub-block | Count | Note |
|---|---|---|
| SB-BANDGAP | 1 | Voltage + current reference (shared with chip) |
| SB-PTAT-I | 1 | Current source for cap charging |
| SB-MIM-CAP | 2 | Dual-cap (alternating charge) |
| SB-COMP-HYS | 2 | Per-cap threshold detect |
| SB-OSCCAL | 1 (5-8 bit) | Frequency trim DAC |
| SB-EFUSE-N | 5-8 bits | Stores trim |
| SB-CTR | small | SR flip-flop and steering logic |
| SB-PWR-GATE | 1 | |
| SB-LSHIFT | 1 | |

**Total area:** ~5 000 um^2 (including shared bandgap; standalone the
oscillator core is ~2 000 um^2).
**Total power:** 50-500 uW.
**Industry refs:** Microchip HFINTOSC [`[MICROCHIP-PIC-INTOSC]`,
`[USP-6020792]`], ST HSI16 [`[ST-AN4736]`, `[ST-AN5067]`], Holtek HSI
[`[HOLTEK-HT32F52243]`], NXP Kinetis IRC48M [`[NXP-AN4905]`].

### B3 -- PTAT/CTAT-compensated relaxation osc

| Sub-block | Count | Note |
|---|---|---|
| (everything in B2) | -- | Base topology |
| SB-CTAT-I | 1 | Slope-compensating current |
| SB-OSCCAL | +1 (PTAT/CTAT mix) | Trim per slope |
| SB-EFUSE-N | +4-8 bits | Stores slope-trim |

**Total area:** B2 + ~200-500 um^2.
**Total power:** B2 + 5-10 uW.
**Industry ref:** `[USP-6020792]` headline embodiment; `[RENESAS-RL78G23-HOCO]`
firmware-corrected variant.

### B4 -- Native-offset-cancellation 3-OTA relaxation osc

| Sub-block | Count | Note |
|---|---|---|
| SB-OTA | 3 | Native-offset-cancellation topology |
| SB-MIM-CAP | 1 | Timing C |
| SB-POLY-R | 1 | Timing R (probe-trim at test) |
| SB-COMP-HYS | 1 | |
| SB-CTR | small | |
| SB-EFUSE-N | 4-8 bits | R/C trim |
| SB-PWR-GATE | 1 | |
| SB-LSHIFT | 1 | |

**Total area:** ~5 000-7 000 um^2.
**Total power:** 50-200 uW.
**Industry ref:** TI patent `[USP-9344070]`.

### C1 -- RC-bridge FLL with digital loop filter

| Sub-block | Count | Note |
|---|---|---|
| SB-WIEN-FB | 1 | RC bridge (probably twin-T) |
| SB-OTA | 1-2 | Bridge phase-readout |
| (DCO core: A2 or B1) | 1 | Trimmable via SB-OSCCAL |
| SB-OSCCAL | 1 (8-12 bit) | DCO trim word |
| SB-FLL-FILT | 1 | Digital loop filter |
| SB-CTR | small | Phase comparator |
| SB-EFUSE-N | 8 bits | Power-on default trim |
| SB-PWR-GATE | 1 | |
| SB-LSHIFT | 1 | |

**Total area:** ~8 000 um^2.
**Total power:** 100 uW - 1 mW.
**Industry refs:** Si Labs CMEMS architecture (with MEMS replaced by
RC bridge) [`[SI-CMEMS]`]; Microchip MCP78xx oscillator IP.

### C2 -- Wien-bridge sinusoidal oscillator

| Sub-block | Count | Note |
|---|---|---|
| SB-OTA | 1-2 | Op-amp |
| SB-WIEN-FB | 1 | Wien bridge feedback |
| SB-COMP-HYS | 1 | Squaring comparator (sine -> digital) |
| SB-EN-DELAY | 1 | AGC stabilisation loop |
| SB-PWR-GATE | 1 | |
| SB-LSHIFT | 1 | |

**Total area:** ~5 000-8 000 um^2.
**Total power:** 100-500 uW.
**Industry ref:** Mizuhara IEICE 2014 [via `[MAKINWA-FREQ-REF-LECTURE]`
academic-survey territory].

### D1 -- Pierce CMOS crystal driver

| Sub-block | Count | Note |
|---|---|---|
| SB-INV (large drive) | 1 | Pierce inverter |
| SB-MIM-CAP | 2 | Load caps |
| SB-POLY-R | 1 | Feedback bias R |
| (external) | 1 quartz | **FORBIDDEN by constraint #2** |

**Status:** Listed for completeness, **not implemented** because of
the no-external-passives constraint. Mabrains supplies a
`XTAL-Osc-16M` cell `[GF180-MABRAINS]` if a future revision relaxes
this constraint.

### D2 -- FBAR / BAW resonator

**Process-incompatible with GF180MCU.** No sub-block table; included in
`solutions.md` for completeness only. Industry ref: `[INFINEON-FBAR-NSF]`.

### D3 -- CMEMS (Silicon Labs Si50x)

**Process-incompatible with GF180MCU.** No sub-block table; included in
`solutions.md` for completeness only. Industry ref: `[SI-CMEMS]`.

### E1 -- NFC carrier divider

| Sub-block | Count | Note |
|---|---|---|
| SB-CARR-COMP | 1 | Tap on rectifier-input node |
| SB-CTR | log2(N) bits (N up to 256) | Divide-by-128 / -16 / -64 |
| SB-PWR-GATE | 1 | Gated when no carrier |
| SB-LSHIFT | 1 | To digital domain |

**Total area:** <500 um^2.
**Total power:** 1-5 uW (only when carrier present).
**Industry refs:** every NTAG / MIFARE / ST25 tag IC; canonical
example `[NXP-NTAG213]`; standard `[ISO14443-A]`.

### E2 -- Qi power-carrier divider

| Sub-block | Count | Note |
|---|---|---|
| SB-CARR-COMP | 1 | Tap on Qi rectifier input |
| SB-CTR | log2(N) bits | Divide for housekeeping |
| SB-PWR-GATE | 1 | |
| SB-LSHIFT | 1 | |

**Total area:** <500 um^2.
**Total power:** 1-5 uW (only when Qi field present).
**Industry refs:** TI BQ51xxx-class Qi receiver ICs (architecture
inferred; not publicly documented in the same depth as NFC).

### E3 -- Ambient 2.4 GHz divider

**Rejected.** No sub-block table; ambient power below CMOS edge-detect
threshold.

### E4 -- SOF / packet clock-recovery

| Sub-block | Count | Note |
|---|---|---|
| (B2 oscillator) | 1 | Full B2 stack |
| SB-CARR-COMP | 1 | Frame-edge detector (NFC, USB SOF, ...) |
| SB-CTR | 16-32 bits | Edge-counter / time-of-flight |
| SB-FLL-FILT | 1 | Trim-update accumulator |
| SB-OSCCAL | shared with B2 | Trim word |
| SB-EFUSE-N | shared | Stores last-known trim |

**Total area:** B2 + ~300-800 um^2 (the additional logic).
**Total power:** B2 + sub-uW (digital).
**Industry refs:** NXP Kinetis `[NXP-AN4905]`, ST HSI48 + CRS
`[ST-AN4736]`, Atmel SAM-G55 (Microchip), Silicon Labs C8051F320.

### F1 -- Thermal-diffusivity (electrothermal) reference

| Sub-block | Count | Note |
|---|---|---|
| SB-HEATER | 1 | Polysilicon heater |
| SB-TPILE | 1 | Differential thermopile (poly-Si + metal junctions) |
| SB-OTA | 1-2 | Thermopile readout amplifier |
| (B2 oscillator core) | 1 | DCO that gets locked |
| SB-FLL-FILT | 1 | Phase-lock to thermal phase shift |
| SB-BANDGAP | 1 | For temperature-correction reference |
| SB-EFUSE-N | 8 bits | Power-on default trim |

**Total area:** several mm^2 (the heater + thermopile dominate).
**Total power:** 7.8 mW active (dominated by heater); much less in
burst-mode if duty-cycled <1 %.
**Industry ref:** TU Delft / Makinwa group, `[USP-8222940]`.

### F2 -- Resistive-memory (RRAM/PCM) R reference

**Process-incompatible with GF180MCU.** No sub-block table.

### F3 -- PTAT-bandgap-only oscillator (no RC, no caps)

| Sub-block | Count | Note |
|---|---|---|
| SB-BANDGAP | 1 | Reference voltage |
| SB-PTAT-I | 2 | Two-current ratio sets period |
| SB-COMP-HYS | 1 | |
| SB-CTR | small | |
| SB-PWR-GATE | 1 | |
| SB-LSHIFT | 1 | |

**Total area:** ~2 000 um^2.
**Total power:** few uW.
**Industry ref:** LTC6906 family (Linear Technology, now Analog
Devices); on-die clocks in implantable ICs.

### G1 -- Sub-threshold inverter ring

| Sub-block | Count | Note |
|---|---|---|
| SB-INV (sub-threshold-biased) | N | Ring stages, biased into weak inversion |
| SB-NAND | 1 | Enable |
| SB-PTAT-I | 1 | Sub-threshold bias |
| SB-PWR-GATE | 1 | |
| SB-LSHIFT | 1 | |

**Total area:** <500 um^2.
**Total power:** <100 nW (the headline benefit).
**Industry refs:** energy-harvesting RFID / biomedical research; cited
in Calhoun / Sandia / UVA literature (academic-survey territory).
**Caveat:** very PVT-sensitive; reject for the harvested rail per
`solutions.md` Sec G1.

### G2 -- Self-biased subthreshold (beta-multiplier) reference oscillator

| Sub-block | Count | Note |
|---|---|---|
| SB-BETA-MULT | 1 | Self-biased loop |
| SB-MIM-CAP | 1 | Timing C |
| SB-COMP-HYS | 1 | |
| SB-CTR | small | |
| SB-EFUSE-N | 4-8 bits | Trim |
| SB-OSCCAL | 1 | Trim DAC |
| SB-PWR-GATE | 1 | |
| SB-LSHIFT | 1 | |

**Total area:** ~1 000 um^2.
**Total power:** ~10 nW (headline benefit).
**Industry refs:** sciencedirect picowatt subthreshold reference family;
TI LMV951-class commercial product.

### H1 -- LC tank with on-die spiral inductor

| Sub-block | Count | Note |
|---|---|---|
| SB-SPIRAL-L | 1 | 3-30 nH on-die spiral |
| SB-MIM-CAP | 1-N | Tank cap (with switchable trim bank) |
| SB-XCOUPLE | 1 | NMOS cross-coupled negative-G |
| SB-BANDGAP | 1 | Bias |
| SB-PTAT-I | 1 | Tank bias current |
| SB-EFUSE-N | 4-8 bits | Cap-bank trim |
| SB-PWR-GATE | 1 | |
| SB-LSHIFT | 1 | |

**Total area:** ~100 000 um^2 (dominated by spiral L).
**Total power:** 0.5-2 mW active.
**Status:** Reject for sub-100 MHz; defer to BLE deep-dive (item k).

### I1 -- External-clock-passthrough only

| Sub-block | Count | Note |
|---|---|---|
| (none on-die for osc) | -- | The clock pad and an input buffer only |
| SB-LSHIFT | 1 | If `clk_PAD` lives on a different domain than the consumer |

**Status:** Already what v1 chip does. **Reject for harvested mode.**

### I2 -- Multi-oscillator system

| Sub-block | Count | Note |
|---|---|---|
| (G2 always-on osc) | 1 | LFRC-class always-on |
| (B2 housekeeping osc) | 1 | HSI-class on-demand |
| SB-EN-DELAY | 1 | Soft-start sequencing between domains |
| SB-LSHIFT | several | Domain crossings |

**Total area:** sum of constituents (~6 000 um^2).
**Total power:** ~10 nW always-on + 100-500 uW gated.
**Industry refs:** Nordic nRF52 (HFINT 64 MHz + LFRC 32.768 kHz)
`[NORDIC-NRF52832-PS]`; ATmega 8 MHz INTOSC + 128 kHz watchdog
`[ATMEL-7810D]`; STM32 HSI16 + LSI ~32 kHz `[ST-AN4736]`; ESP32 internal
8 MHz + 150 kHz RTC `[ESP32-DS]`. **Industry default architecture.**

### I3 -- NFC-carrier-derived (E1) for NFC core + ring (A1) for everything else

| Sub-block | Count | Note |
|---|---|---|
| (A1 or G2 housekeeping osc) | 1 | Always-on / on-rail-up |
| (E1 NFC carrier divider) | 1 | Active only when NFC carrier present |
| SB-EN-DELAY | 1 | Mode-switch sequencing |
| SB-LSHIFT | several | Cross-domain |

**Total area:** <2 000 um^2.
**Total power:** 100 nW - 50 uW depending on activity.
**Industry refs:** literally every NFC tag IC ever shipped; `[NXP-NTAG213]`,
`[ISO14443-A]`. **The strongest industry-derived candidate for the
wafer.space chip's combined items (a) + (h).**

## 3. Architectural composition examples

These bundle the topologies above into concrete chip-architecture
proposals. They mirror (and are intentionally consistent with) the
first-principles sister report's "alpha / beta / gamma / delta"
arrangement at
[`stage1-first-principles/report.md` Sec 4](../stage1-first-principles/report.md#4-sub-block-breakdown).

### Architecture I -- Industry-minimum

**Topologies:** A1 (plain ring) only.

**Where it fits:** LED twinkle, brown-out timer, eFuse pulse timer.

**Sub-blocks:** SB-RING-N (small N), SB-PWR-GATE, SB-LSHIFT.

**Total area:** ~150-1 000 um^2.
**Total power:** sub-uW to a few uW.

**Closest industry analog:** ATmega watchdog 128 kHz osc (architecture
A1 in `solutions.md`).

### Architecture II -- Industry-default

**Topologies:** I2 = G2 (always-on, sub-threshold beta-mult) + B2
(on-demand bandgap-biased relaxation).

**Where it fits:** the wafer.space v2 chip's standard "low + high"
operating split.

**Sub-blocks:** all of G2's stack, all of B2's stack, plus inter-
domain SB-EN-DELAY and SB-LSHIFT.

**Total area:** ~6 000 um^2 (about half of which is the shared
bandgap if reused with brown-out / rectifier reference).

**Total power:** ~10 nW always-on + 100 uW when B2 is enabled.

**Closest industry analog:** Nordic nRF52 LFRC + HFINT split.

### Architecture III -- NFC-aware industry-default

**Topologies:** I3 = E1 (NFC-mode timing) + (A1 or G2) (housekeeping)
+ E4 (carrier-trim of B2 when carrier present, eFuse-stored trim
otherwise).

**Where it fits:** the *fully wafer.space-specific* answer that takes
maximum advantage of the chip's NFC mode being the precision-clock-
giver.

**Sub-blocks:** I3 stack + E4 stack (carrier comparator + edge counter
+ FLL filter + eFuse update path).

**Total area:** ~7 000-8 000 um^2.

**Total power:** ~10 nW always-on; ~50 uW when NFC-mode active; ~100
uW when B2 enabled in field-absent operation.

**Closest industry analog:** combination of `[NXP-NTAG213]` (carrier
divide) + `[NXP-AN4905]` (SOF crystal-less USB IRC48M trim). The novelty
is the *combination* of the two patterns -- it borrows the SOF/USB
trim mechanism but routes it to NFC framing.

### Architecture IV -- Industry-most-novel demonstrator

**Topologies:** F1 (electrothermal reference) trimming a B2 DCO at
test, eFuse-stored.

**Where it fits:** if the wafer.space chip wants to *demonstrate*
something the public industry rarely deploys -- a thermal-diffusivity
reference is the most novel topology in commercial-adjacent silicon.

**Sub-blocks:** F1 stack (heater + thermopile + readout) plus B2 DCO
plus eFuse for the trim word.

**Total area:** several mm^2 (heater dominates).

**Total power:** burst-mode, 7.8 mW peak / ~80 uW average at 1 % duty.

**Closest industry analog:** TU Delft research chip `[USP-8222940]`;
no commercial product known.

### Architecture V -- BLE-ready (post-(j))

**Topologies:** Architecture III + H1 (LC tank for BLE LO).

**Where it fits:** only after item (k) BLE work is unlocked; very area-
expensive.

**Sub-blocks:** Architecture III + SB-SPIRAL-L + SB-XCOUPLE + cap-bank
trim.

**Total area:** ~110 000 um^2 (spiral dominates).

**Total power:** Architecture III + ~1 mW for BLE TX bursts.

**Closest industry analog:** Nordic / TI BLE radios with LC VCO + LFXO
+ HFINT auxiliary.

## 4. Cross-block sharing opportunities

Quoting Sec 4 of `report.md`: a **B2-class oscillator's bandgap +
comparator + eFuse-trim infrastructure is shared with several other v2
chip blocks**. The detail:

| Sub-block | Shared with item | Saving (um^2 of marginal area) |
|---|---|---|
| SB-BANDGAP | (b) NFC rectifier reference, (c) Qi rectifier reference, (i) brown-out detector | ~3 000 |
| SB-COMP-HYS | (i) brown-out detector, (b)/(c) over-voltage clamp comparator | ~500 each |
| SB-EFUSE-N | (j) eFuse infrastructure, (h) NFC payload trim | per-bit area; programming logic shared |
| SB-OSCCAL (DAC pattern) | (h) NFC modulator depth-trim, (f) LED PWM duty-trim | ~300 each |
| SB-PTAT-I | (i) brown-out detector temperature-compensation | ~500 |

**Implication:** the marginal area attributable to "the oscillator" in
Architecture II / III, after the rest of the harvested-mode chip is
built, is on the order of **2 000 um^2**, not the 5 000 um^2 standalone
B2 number. The *first* block to commit to Architecture II/III pays the
bandgap area; subsequent blocks save it.

## 5. Stage-2 / Stage-3 questions answered here

Anticipating the Stage-2 synthesiser's questions:

- **Q: What's the smallest area that gives us ALL the harvested-mode
  consumers?** A: Architecture II at ~6 000 um^2 (or ~3 000 um^2
  marginal after sharing).
- **Q: What's the smallest area that's industry-default and well-
  characterised?** A: Architecture II.
- **Q: What's the most accuracy we can get for our area without
  firmware?** A: Architecture III (E4 carrier-trim) gets us ~+/-50 ppm
  while NFC carrier present, ~+/-2 % off-field. Anything tighter
  needs firmware (item j or a CPU subsystem -- out of scope).
- **Q: What's the most novel topology that ships in commercial
  silicon today?** A: Architecture IV (F1 thermal-diffusivity).
  Chip-area-prohibitive but illustrative.
- **Q: What's the cheapest way to get just LED twinkle running?**
  A: Architecture I (a single A1 ring, ~500 um^2). All other
  consumers can hang off the same ring at degraded accuracy.

These answers feed directly into the Stage-3 option-comparison matrix.
