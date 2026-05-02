---
item: a
item_name: internal-oscillator
stage: 1
angle: industry-survey
researcher: claude-opus-4-7-1m (industry-survey instance 1/3)
status: draft
last-updated: 2026-05-03
---

# Solutions surveyed — internal oscillator topology families

This file is the structured backing data for §3 of `report.md`. Approaches
are grouped by family. Each entry has a stable short ID used as the
identifier across `report.md` (§3, §9), `components.md`, and
`open-questions.md`.

---

## Family A — Inverter ring oscillators (no analog reference)

### A1: Plain CMOS inverter ring

**Description.** Odd number of inverters in a ring; an enable / start gate
(NAND or AND) breaks the ring at one point so it can be reset to a known
state. Frequency f ≈ 1 / (2 · N · t_pd), where t_pd is the average per-stage
propagation delay.

**Where it ships.** Effectively every microcontroller has one for housekeeping
(watchdog, brown-out timer); see ATmega328P 128 kHz watchdog
[ATMEL-7810D §28.5.2 Table 28-2: 76–180 kHz, V_CC = 2.7–5.5 V — i.e.
±41 % uncalibrated]. Open-source: [SKY130-RINGOSC-HK], [TT09-RINGOSC],
[GF180-MABRAINS] `Ring-Osc-3.3vFETs` and `Ring-Osc-5.0vFETs`.

**Performance numbers.**
- Frequency: any from kHz (long ring + sub-threshold inverters) to GHz
  (3-stage minimum-length devices).
- PVT spread: ±20 % to ±50 %, depending on PDK and stage count. Untrimmed
  thermal coefficient often quoted as 2400 ppm/°C in 0.18 µm RF-CMOS
  (uncompensated), -40 to +85 °C [search synthesis 2026-05-02 from
  multiple academic papers cited in `stage1-academic-survey`].
- Supply sensitivity: ~3–8 % per V (gate delay scales roughly with V_DD).
- Power: a few µW per stage at the µW–mW operating points typical for
  housekeeping; a 9-stage ring at 100 MHz typically consumes 100 µW–1 mW.

**Where it has been tried and found insufficient.**
- *USB / Bluetooth / NFC reader* clocks: ±20 % violates ±2500 ppm USB,
  ±50 ppm BLE radio, ISO 14443 reader timing. **Why this matters less to
  us:** our NFC mode is *tag-side* and self-clocked from the carrier
  (see I3 below).
- *Real-time clock*: ring drift integrated over an hour produces ~10
  minutes of error; commercially unacceptable for RTC timekeeping.
- *Music / audio*: pitch drift audible.

**How our requirements differ.** LED twinkle, brown-out detection, eFuse
program timing, and Qi housekeeping all tolerate ±20 %. NFC is
self-clocked. So the ring's failure modes do not apply to us — except for
one: BLE LO synthesis (item k) demands sub-ppm precision, and a plain
ring cannot supply it even after trim. (See A2/A3 below for ring-osc
descendants closer to a viable BLE reference.)

### A2: Current-starved ring oscillator

**Description.** A standard ring osc with PMOS / NMOS current sources
between each inverter and V_DD/V_SS, controlled by a single bias voltage.
The bias voltage sets the per-stage charging current and therefore the
delay, decoupling frequency from V_DD as long as the bias is V_DD-rejected.

**Where it ships.** Standard topology in basically every CMOS PLL VCO. As
an *open-loop* clock, it appears in MSP430 DCO ([TI-SLAA336]) — TI
describes the DCO as *digitally* controlled but the inner topology is a
current-controlled ring; the bias DAC is a switched-capacitor or
switched-resistor array. [USP-9344070] uses a related concept.

**Performance numbers.**
- After bandgap-referenced bias: ±1 % over PVT achievable at low MHz.
- Without bandgap: similar to A1.
- Power: dominated by the bias generator. Bandgap-referenced biasing
  costs 5–50 µW.

**Insufficient where.**
- BLE radio LO directly (jitter from current-source noise too high without
  PLL).
- Sub-ppm precision references (the bandgap doesn't reject enough fast
  noise).

**How our requirements differ.** ±1 % is *vastly* tighter than what we
need — the Stage-2 synthesiser may discard A2 in favour of A1 simply
because A1 needs no bandgap. But a current-starved ring with eFuse-trimmed
bias (no bandgap) is a credible compromise: ±5 % across PVT for a few µW.

### A3: Process-corner-sensing compensated ring oscillator

**Description.** Ring oscillator with a parallel "process probe" — typically
a chain of devices sized to be very PVT-sensitive — that measures local
PVT and feeds back to the bias generator, giving a self-calibrating ring.

**Where it ships.** Several published designs in 0.18 µm; one cited in
[STM-RC-COMMUNITY] reports 22 ppm/°C from -40 to +90 °C in TT corner. Also
proposed in [USP-6020792]'s extended embodiments though that patent's
canonical claim is the relaxation oscillator (see family B).

**Performance.**
- Temperature coefficient: 22–85 ppm/°C in measured silicon (0.18 µm and
  90 nm respectively).
- Initial accuracy: ±1–2 % after factory trim.

**Insufficient where.**
- Sub-ppm precision still requires a crystal or BAW reference.
- The process probe consumes fixed area regardless of frequency target.

**How our requirements differ.** Overkill at the cost of a few hundred
µm² extra. May still be in the running if the harvested rail's V_DD
varies by tens of percent — the V_DD rejection of A3 is far better
than A1 because the process probe captures V_DD effects too.

---

## Family B — RC relaxation oscillators (charge-and-trip)

### B1: Schmitt-trigger RC relaxation osc

**Description.** A Schmitt trigger feeds back through an RC: cap charges
through R until the upper threshold V_th+ is hit, output flips, cap
discharges to V_th-, output flips again. Period T ≈ 2RC ln((V_DD - V_th-)/(V_DD - V_th+)).
Closed-form for symmetrical thresholds: T = 2 ln 3 · RC.

**Where it ships.** This is the ATmega watchdog, and it's the canonical
"first relaxation osc you draw on the back of a napkin." [ATMEL-7810D
§28.5.2] gives the watchdog as 76 / 128 / 180 kHz typ, V_CC = 2.7–5.5 V.

**Performance.**
- Untrimmed: ±30–50 % over PVT (R varies ±15 %, C varies ±10 %, V_th
  varies with V_DD by ~5 % per V).
- Strongly V_DD-sensitive because V_th is V_DD-referred.

**Insufficient where.**
- Anywhere precision is required without trim.
- Supply-droop applications (V_DD dependence is the dominant error term).

**How our requirements differ.** For LED twinkle and brown-out timer, ±50 %
is fine. The "watchdog osc" pattern is a literally-zero-effort implementation.

### B2: Comparator-based dual-cap relaxation osc with bandgap bias

**Description.** Two caps charged in alternation by a bandgap-referenced
current; two comparators check against a bandgap-referenced voltage; an
SR flip-flop steers the bias current between caps. Frequency f =
I_bg / (2 · C · V_bg) — both numerator and denominator are PVT-stable
because they're bandgap-referenced. **This is the [USP-6020792] topology.**

**Where it ships.** Inside every modern PIC microcontroller; the PIC
INTOSC architecture. [MICROCHIP-PIC-INTOSC] confirms HFINTOSC factory-trim
to ±1–2 %, ±5 % across PVT. Equivalent design in Holtek HT32F52243 (±2 %
factory at 25 °C) [HOLTEK-HT32F52243]. STM32 HSI is similar
[ST-AN2868, ST-AN4736] (±1 % factory @ 25 °C, ±4 % over -10 to +85 °C).
Renesas RL78/G23 HOCO targets ± 0.1 % (32 MHz) [RENESAS-RL78G23-HOCO]
with on-chip-temperature-sensor-based correction algorithm running in
firmware — i.e. a software-assisted variant of B2.

**Performance.**
- Factory: ±1 % at 25 °C.
- Across PVT (industrial): ±2–4 %.
- Across PVT (extended automotive): ±5–8 %.
- With temperature-sensor-fed firmware correction (Renesas style):
  ±0.1 %.
- Power: 50–500 µW.
- Trim register: 5–8 bits (32–256 steps).

**Insufficient where.**
- BLE radio.
- USB without SOF clock-recovery.

**How our requirements differ.** Comfortably exceeds our needs everywhere
except item (k) BLE. **B2 is the most plausible "high-end" candidate for
the wafer.space chip** — it costs a bandgap (which is reusable for the
brown-out detector and the rectifier reference) and an 8-bit eFuse trim
register that we already need for item (j).

### B3: PTAT/CTAT-compensated relaxation osc

**Description.** B2 with the bias current replaced by a deliberate sum of
PTAT and CTAT currents whose temperature slopes cancel. The cap remains
flat across temperature (cap temperature coefficient is small in MIM /
MOM caps), so frequency is now flat both in process and in temperature.
This is the headline embodiment of [USP-6020792].

**Performance.**
- Headline: 1 ppm/°C at 4 MHz [USP-6020792].
- Realistic without elaborate trim: 50–100 ppm/°C, ±1 % accuracy.

**Insufficient where.** Sub-ppm precision still requires a crystal /
MEMS / BAW.

**How our requirements differ.** 1 ppm/°C is *enormously* over-spec for
us. Listed for completeness and as a stretch / aspirational architecture.

### B4: Native-offset-cancellation 3-OTA relaxation osc

**Description.** [USP-9344070]: three-OTA topology where matched current
sources cancel input-referred offset of the OTAs without a bandgap or a
chopper. R₁ and C₁ are trimmed at probe.

**Performance.**
- 0.5 % drift over 100 years at body-core temperature (claim).
- V_CC-independent.

**Insufficient where.** Frequency adjustment range is narrow without
re-trimming R₁ / C₁.

**How our requirements differ.** Designed for an implant — a pure match
to our "no external reference, no battery-scale calibration loop" use
case.

---

## Family C — RC frequency-locked-loop ("RC-FLL")

### C1: RC-bridge FLL with digital loop filter

**Description.** A digitally-controlled oscillator (DCO) is locked to the
frequency-phase characteristic of an on-die RC bridge filter (Wien-bridge
or twin-T). The DCO can be a current-starved ring or a relaxation osc.
The DCO output is digitally trimmed by the loop until the phase shift
across the RC bridge is exactly the target setpoint. The bridge
*resistors* are typically two physically-different types whose
temperature coefficients partially cancel — a poly-resistor + a diffusion
resistor in series, for example.

**Where it ships.** Silicon Labs CMEMS [SI-CMEMS] uses this topology with
the MEMS resonator standing in for the RC bridge. Microchip MCP78xx
oscillator IP (verified in [Electronics Weekly 2022 industry blurb,
search hit 2026-05-02]). Several Renesas, NXP and Cypress parts use
related FLL architectures internally.

**Performance.**
- ±0.1 % to ±0.5 % over -40 to +85 °C without trim if both resistor
  types' TC is well-modelled.
- Power: 100 µW – 1 mW.

**Insufficient where.** Sub-ppm precision (still RC-limited).

**How our requirements differ.** Massive over-spec for us. But the
architecture is interesting because it can be *built up incrementally* —
start with a current-starved ring (A2), add a 4-bit DCO trim word, lock
to RC-bridge phase digitally in HDL — making it a natural Stage-4
deep-dive option.

### C2: Wien-bridge sinusoidal oscillator

**Description.** Op-amp + Wien-bridge feedback network produces a
sinusoidal output. Frequency = 1 / (2π · RC).

**Where it ships.** Mostly in audio and instrumentation. Among on-CMOS
references, a 3.8 MHz Wien-bridge with differential cap-AGC published in
[Mizuhara IEICE-2014] (academic-survey territory). Wien-bridge is among
the few harmonic-oscillator candidates for sub-mW few-MHz on-chip CMOS
clock generators per [MAKINWA-FREQ-REF-LECTURE].

**Performance.** ±0.5 % achievable; complex amplitude-stabilisation loop.

**Insufficient where.** Few commercial MCUs use this; complexity beats
relaxation osc.

**How our requirements differ.** Complexity beats utility. **Listed for
completeness and to avoid silent omission.**

---

## Family D — Crystal- / MEMS- / BAW-based oscillators (off-die or back-end)

### D1: Pierce CMOS crystal driver

**Description.** Single-inverter Pierce circuit with two load caps and a
quartz crystal across the inverter feedback.

**Where it ships.** Universally. The wafer.space *Run-1* chip uses this
on the external `clk_PAD` for VGA. [GF180-MABRAINS] supplies an open
GF180MCU crystal-driver layout (`XTAL-Osc-16M`).

**Insufficient where.** Requires an external crystal — **explicitly ruled
out by the project's "no external passives" constraint** (TODO.md
"Hard cross-cutting constraints" #2).

### D2: FBAR / BAW resonator

**Description.** Bulk-acoustic-wave resonator above the CMOS — a thin
piezo film between two electrodes, producing a high-Q (>1000) GHz-class
resonance. Used as a PLL reference.

**Where it ships.** Avago / Broadcom RF transceivers (cellular, WiFi).
Originally Infineon → Avago (2008) → Broadcom (2016). [INFINEON-FBAR-NSF]
documents a fast start-up reference oscillator using FBAR.

**Insufficient where.** **Process-incompatible with GF180MCU**: FBAR
requires special back-end wafer processing (piezo deposition + cavity
release). Not in the wafer.space PDK.

### D3: CMEMS — MEMS-on-CMOS monolithic

**Description.** [SI-CMEMS] grows a SiGe + SiO₂ resonator on top of a
finished CMOS wafer, encapsulates it under a vacuum cap with eutectic
bonding, then layered in a single die. Used in Silicon Labs Si50x.

**Insufficient where.** **Process-incompatible with GF180MCU.** The
GF180MCU PDK has no MEMS layer.

---

## Family E — Carrier-derived clocks (zero-cost when an RF carrier is present)

### E1: NFC carrier divider

**Description.** When the chip is in an NFC reader's field, the antenna
delivers a 13.56 MHz reference *for free*. ISO/IEC 14443-A timing is
literally counter divisions of the carrier:

- Bit duration = carrier ÷ 128 = 9.4 µs (i.e. 106 kbit/s).
- Subcarrier = carrier ÷ 16 = 847.5 kHz (the load-modulation sideband).
- Type-A "1-of-256" anticollision is also carrier-counter-derived.

**Where it ships.** Every NFC tag IC ever built — NXP NTAG213
[NXP-NTAG213], NXP MIFARE Ultralight, ST25TA, Infineon SLE66, etc. The
tag's "internal oscillator" is a counter on the rectified carrier, not
an RC.

**Insufficient where.** Carrier absent (off-the-pad mode).

**How our requirements differ.** This is the *cheapest possible* clock
for items (h) NFC core and (b) NFC-rail housekeeping. **Strong candidate
for selective use** — the NFC core simply does not need a separate
internal RC.

### E2: Qi power-carrier divider (100–205 kHz)

**Description.** Same trick as E1 but for the Qi low-frequency carrier.
A clipped-and-divided version of the rectifier input becomes the housekeeping
clock in Qi mode. Frequency unstable (Qi sweeps 100–205 kHz under control
loop) but useful for slow timers (e.g. brown-out timeout) where we don't
care about absolute frequency.

**Where it ships.** Various commercial Qi receiver ICs (TI BQ51xxx
family) use the Qi carrier as the on-chip control-loop clock. Not
publicly documented in the same depth as NFC tag self-clocking, but the
mechanism is identical.

**Insufficient where.** When Qi carrier absent. Frequency drifts as
transmitter adjusts coupling.

### E3: Ambient 2.4 GHz carrier divider

**Description.** A carrier-detector at 2.4 GHz produces a "field-present"
signal that can be divided to a slow housekeeping clock. **Probably
impractical** at our power budget — ambient RF is too weak for reliable
edge detection in CMOS.

**Insufficient where.** Realistic ambient RF is 0.1–10 µW/cm² indoor —
at that power level, the chip can barely *rectify* the field, never mind
extract a clock from it.

**How our requirements differ.** Listed for completeness; reject for
practical reasons. (**Not silently dropped.**)

### E4: SOF / packet clock-recovery ("crystal-less USB" pattern)

**Description.** A coarse internal RC (typically a B2 or B3 variant) is
periodically *trimmed* against an externally-arriving timing reference —
USB Start-of-Frame at 1 ms, BLE preamble symbols at 1 µs, NFC framing at
9.4 µs. The trim algorithm runs in HDL, updating an OSCCAL-style register.

**Where it ships.** NXP Kinetis crystal-less USB [NXP-AN4905]. Microchip
Atmel SAM-G55 [microchip.com/.../Atmel-44085-32-bit-Cortex-M4...]. ST
STM32 HSI48 + CRS [ST-AN4736]. Silicon Labs C8051F320.

**Insufficient where.** When no external timing reference is reaching
the chip. (Once the field/connection is gone, the clock is back to
uncorrected RC accuracy.)

**How our requirements differ.** **This is the one industry-survey
finding that the wafer.space chip can leverage even better than a
typical MCU does.** When the chip is in an NFC field, a B2 RC oscillator
running on harvested power can be SOF-style trimmed against the
13.56 MHz carrier and stored in eFuse (j). That trim survives across
field-cycle for everything that runs *off-field* (LED twinkle on
ambient-RF-only operation). This converts a permanent ±5 % drift into a
±1 % drift after the *first ever NFC-field exposure* — i.e. the chip
auto-calibrates itself the first time anyone NFC-taps the card.

---

## Family F — Exotic / electrothermal references

### F1: Thermal-diffusivity (silicon-substrate) reference

**Description.** [USP-8222940]: an FLL locked to the phase shift of an
electrothermal filter etched in standard CMOS. The reference is the
thermal diffusivity α(T) of bulk silicon, a *material* property not a
process-tolerance-bounded RC. Heater + remote thermopile. Bandgap-
temperature-sensor compensates the α(T) variation. ±0.1 % over -55 to
+125 °C with 24 chips, no per-chip trim.

**Where it ships.** No commercial product. Pure academic / patent — but
implemented on standard CMOS, so process-portable to GF180MCU.

**Insufficient where.** Power: 7.8 mW. Far too high for us
unconditionally.

**How our requirements differ.** Burst-mode operation (1 % duty cycle,
trimmed and stored to eFuse) might cut to ~80 µW average. **Genuine
candidate for a Stage-4 deep-dive as the most novel /
"differentiator" approach for a public demo.**

### F2: Resistive-memory / phase-change reference

**Description.** An RRAM or PCM cell's resistance referenced as the R in
a relaxation osc. The cell's resistance is set once at programming time
and is essentially process-immune.

**Where it ships.** Reported only in research; some Renesas / Sony
patents propose this for OTP-aided clock trim.

**Insufficient where.** **Process-incompatible with GF180MCU.** No
RRAM/PCM in the PDK.

### F3: PTAT-bandgap-only oscillator (no RC, no caps)

**Description.** Two PTAT BJTs feed a comparator with hysteresis; the
loop frequency is set by a bandgap-referenced charging current and the
bandgap voltage itself. The "RC" is effectively replaced by the
ratio of two on-chip currents.

**Where it ships.** Some ultra-low-power sensor ICs (Linear Technology
LTC6906 family, on-die clocks in implantables).

**Insufficient where.** Frequencies above ~1 MHz are inefficient.

**How our requirements differ.** Pulls a few µW; output frequency in the
kHz–100 kHz range — perfect for the LED twinkle (item f) base clock and
the brown-out timer.

---

## Family G — Sub-threshold and ultra-low-power topologies

### G1: Sub-threshold inverter ring

**Description.** The same ring as A1 but biased so each inverter operates
in weak inversion. Per-stage delay is exponential in V_DD/U_T, so the
oscillator is dramatically lower-power but also dramatically more
PVT-sensitive.

**Where it ships.** Energy-harvesting RFID and biomedical ICs (e.g.
research literature points back to Calhoun/Sandia/UVA designs at Hz–MHz
targeting nW total power).

**Performance.**
- Power: <100 nW achievable.
- Frequency: kHz to MHz.
- PVT: ±50–100 % uncalibrated; exponential V_DD dependence is the
  killer.

**Insufficient where.** Anywhere V_DD varies by more than ~10 %.

**How our requirements differ.** Brown-out-prone harvested rails
guarantee V_DD will swing > 10 %. **Reject for the harvested path.**
But for an *always-on* watchdog timer running off the *VGA rail* (which
is regulated by the monitor), this is great.

### G2: Self-biased subthreshold (β-multiplier) reference oscillator

**Description.** A bandgap-style β-multiplier provides PTAT bias; a
sub-threshold relaxation osc consumes that bias. Self-biased ⇒ V_DD
rejection is built in (the bias is *defined* by transistor sizing
ratios, not V_DD).

**Where it ships.** Several research papers ([sciencedirect search
2026-05-02 picowatt subthreshold biomedical voltage references]
including 545 pW dual-temp-compensated reference). At least one Texas
Instruments commercial product line uses this (LMV951-class
references).

**Performance.**
- Power: 100 pW – 10 nW.
- Frequency: ≤ kHz.
- Accuracy: ±5 % after factory trim.

**Insufficient where.** Frequencies above ~100 kHz; supply ramp times
< 1 ms (slow start-up).

**How our requirements differ.** *Spectacular* fit for the LED-twinkle
base clock (kHz, drift-tolerant) and the harvested-rail brown-out
timer.

---

## Family H — On-die LC tank oscillators

### H1: LC tank with on-die spiral inductor

**Description.** A cross-coupled NMOS pair with an LC tank. Frequency
f = 1 / (2π √(LC)). Q of a 0.18 µm on-die spiral is ~5–10.

**Where it ships.** Cellular/Wi-Fi RFICs at 1–6 GHz. Below ~1 GHz the
inductor area gets prohibitive (L ~ 1/ω², so 100 MHz inductance ~ 25 nH,
which is about 100 turns of 5 µm metal trace — 300 × 300 µm of die area,
unaffordable on a tiny logo die).

**Insufficient where.** Frequencies below ~GHz. Phase-noise-critical
applications without external reference.

**How our requirements differ.** **Reject** for the sub-100 MHz consumers.
Could be relevant only for a hypothetical BLE LO (item k) at 2.4 GHz —
but that's an academic-survey territory and well outside the wafer.space
v2 baseline.

---

## Family I — Hybrid / system-level approaches

### I1: External-clock-passthrough only (no on-die oscillator at all)

**Description.** Don't build an on-die clock. Use the external
`clk_PAD` (already wired up for VGA at 25.175 MHz) as the *only* clock,
and gate everything that needs it.

**Where it ships.** Many digital-only ASICs that assume a board clock.
Wafer.space Run-1 chip itself.

**Insufficient where.** When the harvested-power modes need to run *with
no monitor connected*. Which is exactly the wafer.space v2 use case.

**How our requirements differ.** Definitive **reject** because the
business-card harvested mode requires no external clock. **But** noting
this option exists is important: for VGA mode the external clock is
already available, and *the v2 chip should not build an internal
oscillator that runs in VGA mode unnecessarily*. The internal osc is for
harvested mode only.

### I2: Multi-oscillator system (low-frequency always-on + high-frequency on-demand)

**Description.** A pair of internal oscillators at very different
frequencies. The slow one (kHz) is always on, drives wake-up logic and
the brown-out timer. The fast one (MHz) is gated on only when a wireless
transaction is active.

**Where it ships.** All BLE SoCs (Nordic nRF52: HFINT 64 MHz + LFRC
32 768 Hz), all low-power MCUs (ATmega, MSP430, STM32 — three or four
internal oscillator domains routinely).

**How our requirements differ.** Best fit for the v2 architecture.
**Strong Stage-2 / Stage-3 candidate.**

### I3: NFC-carrier-derived (E1) for NFC core + ring (A1) for everything else

**Description.** Specialised version of I2 where the high-frequency
"oscillator" is literally a counter on the NFC carrier (no transistor
spent oscillating). Only one *real* on-die oscillator exists, the slow
ring or sub-threshold relaxation osc that runs the housekeeping.

**How our requirements differ.** **Plausibly the right answer for the
wafer.space chip.** Listed explicitly so the Stage-2 synthesiser
considers it; an industry-survey researcher could easily miss it because
it doesn't match the keyword "internal oscillator" — but it is
absolutely how every commercial NFC tag works.

---

## Family J — Approaches considered and explicitly rejected

For the avoidance of silent omissions, every approach considered during
this survey is recorded here even if rejected.

| ID | Approach | One-line reject reason |
|---|---|---|
| J1 | Off-chip RC trimmed via through-package laser | No package post-processing in our flow |
| J2 | TCXO (temperature-compensated XTAL osc) | External crystal forbidden |
| J3 | OCXO (oven-controlled XTAL osc) | Power and crystal both forbidden |
| J4 | DTCXO with digital temperature comp | External crystal forbidden |
| J5 | Atomic / chip-scale-atomic-clock (CSAC) | mW–W power; not on GF180MCU |
| J6 | Optical reference (light-pumped Rb cell) | Vacuum-cell process incompatible |
| J7 | NMR / nuclear-magnetic reference | Magnet hardware infeasible |
| J8 | GPS-disciplined oscillator | Requires GPS antenna + RX, infeasible |
| J9 | Power-line 50/60 Hz reference | Wrong physical environment |
| J10 | RTC battery-backed crystal (32 768 Hz off-chip) | External component forbidden |
| J11 | Optical-wavelength reference (HCN cell etc.) | Infeasible at chip scale |
| J12 | Pierce on-die crystal (in-package quartz) | No on-die quartz on GF180MCU |
| J13 | Ladder-diffusion thermal-noise clock (truly random) | Not a *clock*, just entropy |
| J14 | Single-event-upset triggered ring | Not deterministic |
| J15 | Chua circuit / chaotic clock | Phase undefined; not useful |
| J16 | Mode-locked-laser-on-die optical clock | No photonic layer in PDK |
| J17 | Acoustic resonator on top metal (CMUT) | No CMUT process step in PDK |
| J18 | Memristor-RC reference | No memristor in PDK |
