---
item: f
item_name: led-twinkle-drivers
stage: 1
angle: industry-survey
researcher: claude-opus-4-7-1m — Stage-1 industry-survey agent
status: draft
last-updated: 2026-05-03
---

## 1. Executive summary

This report surveys the *industrial* solution space for driving 1-2
small LEDs at sub-10 mA average, from an intermittent ~3.3 V
harvested rail, on a die fabricated in `gf180mcuD` with no off-die
passives. The search canvassed:

- **Commercial multi-channel LED-driver ICs** (TI TLC59xx family,
  STMicro LED1xxx family) for constant-current sink topologies and
  PWM grayscale schemes.
- **Single-LED low-power boost drivers** (Linear/ADI LT3593,
  Maxim/ADI MAX1561/MAX1599) — to understand what an *external*
  inductor buys you and to confirm why we cannot replicate that.
- **Energy-harvesting power-management ICs** (TI BQ25505, BQ25570,
  Maxim MAX20361) — relevant for the upstream rail (item (e)) but
  worth knowing the boundary conditions they impose on a downstream
  LED load.
- **Boost converters as "pass-through" LED drivers** (Microchip
  MCP1640) — same rationale as above.
- **"Candle-flicker" novelty LEDs** with integrated controllers —
  the only commodity silicon that *exactly* matches our use case
  (single LED, sub-mA, organic-looking pattern, sub-µA standby).
- **Open-source designs**: Tiny Tapeout, OpenCores, Hackaday/blog
  reverse-engineering of candle-flicker dies.
- **GF180MCU pad-cell library** (`gf180mcu_fd_io`) for output drive
  capability and ESD topology.
- **Human-perception standards**: IEEE Std 1789-2015 and the
  Talbot–Plateau / Bloch psychophysical limits.

The headline industry findings, **without picking a winner**:

1. **Commercial LED-driver ICs target 5-100 mA per channel.** None
   sit naturally at our 100 µA-1 mA peak. Their constant-current-
   sink architecture is the standard reference but their *headroom*
   requirements (typ. 0.4-1.5 V across the sink) eat the margin we
   don't have on a 3.3 V rail driving a 2.0 V red LED.
2. **Boost converters cannot live on this die.** Every commercial
   sub-Vf-to-Vf LED driver (LT3593, MAX1561, MCP1640) is a
   switch-mode boost requiring an external 4.7-22 µH inductor.
   GF180MCU's on-die spiral inductors top out at ~10-20 nH at
   reasonable area — five orders of magnitude short. This kills an
   entire product category.
3. **Candle-flicker LEDs are direct prior art.** Reverse-engineered
   commercial parts (cpldcpu blog series, 2013-2024) implement
   exactly our design problem: ~3 V supply, ~1 mA average,
   pseudo-random visually-organic pattern, on a 2-µm-class die. They
   use either dual-RC oscillator + LFSR, or a single RC + LFSR, or
   (in the 2024 generation) an *embedded OTP microcontroller*. PWM
   carrier ≈ 125-440 Hz; pattern update ≈ 13-30 Hz.
4. **PAR1789 is the binding human-factors envelope.** For a 100 %
   modulation depth (PWM gating between 0 and full duty), IEEE
   1789-2015 demands carrier ≥ ~1.25 kHz to enter the "low-risk"
   zone, ≥ ~3 kHz for "no observable effect." Our design must clear
   ≥ 1.25 kHz PWM with margin.
5. **GF180MCU pad cells offer three viable pad choices** —
   `bi_24t` (24 mA fixed-strength bidir), `bi_t` (8/16 mA
   programmable bidir), and `asig_5p0` (passive bond pad with ESD
   diodes only). The passive pad is the most architecturally honest
   choice for an LED current-source output, since the bidir pads'
   internal CMOS push-pull driver is unnecessary and its ESD/
   isolation behaviour during VGA-rail-only operation needs careful
   review (item (i)).

No single topology is recommended at Stage 1. §9 hands a structured
comparison table to Stage 2.

## 2. Requirements as understood

| ID | Requirement | Source |
|---|---|---|
| R1 | Drive 2 off-chip LEDs visibly | `TODO.md` §(f) |
| R2 | Source from harvested rail nominally 3.3 V (intermittent, may dip) | `TODO.md` §(f), §(b)-(d) |
| R3 | No external passives (R, L, C) | Cross-cutting #2 |
| R4 | Visually pleasing organic "twinkle" | `TODO.md` §(f) goal |
| R5 | Brown-out aware: graceful dim, no glitch | `TODO.md` §(f) bullet 4 |
| R6 | 2 LED bond pads co-located with harvested-rail pads | `TODO.md` §(f) Execute |
| R7 | Use existing pad-cell library (preferring `bi_24t`/`bi_t`/`asig_5p0`) | `TODO.md` §(f) bullet 6, `gf180mcu_fd_io` audit |
| R8 | eFuse-driven pattern selection optional | `TODO.md` §(f) bullet 7 |
| R9 | Top-metal logo preserved | Cross-cutting #1 |
| R10 | Two-rail isolation; LEDs dark in VGA-only mode | `TODO.md` §(i), backwards-compat AC |
| R11 | Storage cap (item e) absorbs LED current pulses; rail must not brown out from LED PWM | `TODO.md` §(b)-(e), Stage-1-FP §5.6 |
| R12 | Comply with IEEE 1789-2015 NOEL for LED flicker | Industry safety standard, project-quality bar |

## 3. Solution-space map

Topology short names match the parallel first-principles report
(`stage1-first-principles/report.md`) where they coincide; **new**
industry-only topologies are prefixed `IND-`.

### 3.1 T1 — On-die ballast resistor + switch (industry view: "ballast-and-switch")

Used in **every cheap blinking-LED toy of the 1980s-1990s**, in
discrete form. Rare in modern ICs because external resistors are
cheap and external. The integrated equivalent is what the
candle-flicker LEDs (cpldcpu reverse-engineering, 2013) actually
implement: an on-die FET with a deliberately-sized W/L acting as
the current-limiting element, no separate resistor.

- *Where used in industry:* candle-flicker LED dies; "blinky"
  novelty pendants; integrated 7-segment indicator drivers in
  vintage CMOS (CD45xx series, indirectly).
- *Performance:* ±30 % current spread over PVT; efficiency =
  V_f/V_rail; sub-µA standby with switch off.
- *Failure mode in our regime:* when V_rail dips below V_f, current
  collapses smoothly — actually a *feature* for brown-out
  gracefulness.

### 3.2 T2 — Constant-current sink with internal reference (industry: "TLC59xx-class")

The commercial standard. **TI TLC5947 (24-channel, 30 mA per
channel, 12-bit PWM, 3.0-5.5 V VCC)** is the canonical part. Each
channel is a regulated current sink with a single external R_iref
setting full-scale current; per-channel 12-bit PWM gates the sink.
TLC59281, TLC5940, TLC5926 are sister parts with similar
architecture.

- *Headroom requirement:* typically **400 mV to 1.5 V** across the
  sink to keep regulation. **This kills the topology on our 3.3 V
  rail driving a 2.0 V red LED with 1.3 V margin** — barely
  workable at typical, unworkable at corners.
- *Idle current:* TLC5947 spec sheet does not commit a clean
  number; TLC5926/40 family quote 1-3 mA quiescent —
  **unsuitable for our µA-mA total budget.**
- *Why important to enumerate:* this is what every textbook and
  app note recommends; we must explicitly justify *not* using it.

### 3.3 T3 — Current-DAC + PWM (industry: "TLC59281 BC/DC")

TLC59281 adds **brightness control (BC)** and **dot correction
(DC)** registers — a per-channel current trim DAC on top of the T2
sink. Common on driver ICs targeting LED-display matrix uniformity.

- *Architecture is appropriate for matching two LEDs of slightly
  different Vf or efficacy.* For our 2-LED use case this is moderate
  overkill.
- *Same headroom and quiescent-current limits as T2.*

### 3.4 T4 — Charge-pump bucket-dump

No mass-market commercial LED driver IC uses this exactly, but
*every* RFID / NFC tag IC (NXP NTAG2xx, ST25TA, EM4423) has
equivalent on-die switched-cap rectifier-then-LED-pulse paths in
their optional "field-detect LED" mode. Energy-harvesting reference
designs (TI TIDA-00242, TIDA-00998) drop a *very large* off-die
storage cap then dump it through an LED with a small switch — same
energy-bookkeeping, different scale.

- *Headroom advantage:* the bucket cap charges to V_rail then dumps
  through V_f; LED sees the *cap* as source, not the rail directly.
  Brown-out is determined by V_cap > V_f, not by sink-headroom.
- *Rail-coupling advantage:* the rail provides smooth average
  charging current; the LED sees pulsed bucket current.
  ~1000× ripple reduction vs T1/T2/T3 with the same I_peak (per
  first-principles report §5.6 — confirmed, no contradiction).
- *Industry maturity:* RFID/NFC IC designers know this trick well;
  it is *not* well represented in textbook LED driver chapters.

### 3.5 T5 — Boost converter with on-die inductor — REJECTED

**Every commercial single-LED low-power driver is this topology**
because it lets a 1.5 V cell drive a 3.4 V white LED:

- **Linear/ADI LT3593** — 2.7-30 V Vin, 1 MHz boost, 5-bit DAC
  (32-step) single-wire dimming, can drive up to 10 series white
  LEDs from a Li-ion cell. Requires external L (typ 4.7 µH).
- **Maxim/ADI MAX1561** (1 MHz) / **MAX1599** (500 kHz) —
  2.6-5.5 V Vin, 26 V output, 0-20 mA programmable, 2-6 white LEDs
  in series. Requires external L (typ 4.7 µH).
- **Microchip MCP1640** — 0.35-5.5 V Vin (cold-start 0.65 V at
  1 mA), 5.5 V max output, ~50 mA, 19 µA quiescent in PFM,
  0.75 µA shutdown. Requires external L (typ 4.7 µH) and 10 µF
  caps.

**Rejected for our die:** GF180MCU on-die spiral inductors at a
200 × 200 µm footprint achieve ~10-20 nH (well below 1 µH).
Energy-per-pulse E = ½·L·I² is six orders of magnitude short
of LED pulse energy; switching frequency would need to be in the
tens of GHz. (Quantified in first-principles §5.5 — independently
verified here against industrial datasheets; see §5.)

This is the single largest "obvious commercial answer that doesn't
fit our constraints" — included explicitly so Stage 2 cannot
silently rediscover it.

### 3.6 T6 — Switched-cap doubler / Dickson + bucket-dump

The industrial sibling of T4: when an off-die boost is impossible
but you need V_rail × 2 to drive blue/white LEDs from a 3.3 V
supply, a Dickson charge pump (textbook, 1976) does it.

- **Used in EEPROM/eFuse programming voltage generators** in *every*
  modern microcontroller (ATtiny series eFuse programming, etc.)
  and in **NFC tag ICs** for the ~5-12 V eFuse / EEPROM rail. The
  same pump topology can be repurposed to elevate the LED drive
  rail.
- *Efficiency cap:* 50 % per stage at typical CMOS switch losses;
  ≈30-40 % wall-plug at 2× elevation.
- *Industry maturity:* extremely high; appears in Razavi
  *Design of Analog CMOS ICs* §17.5 and ten thousand papers.

### 3.7 T7 — Direct switch (no ballast)

No commercial LED driver IC uses bare switches on purpose because
external resistors / current sinks are cheap. *But* the cheapest
discrete blinky toys (single CD4060B + LED) do exactly this —
relying on the LED's own dynamic resistance and the supply's
source impedance for current limiting.

- *Industry observation:* a 2024-vintage candle-flicker LED with
  embedded OTP microcontroller (cpldcpu 2024) drives the LED
  through a single PIC12F-class FET output, presumably relying on
  the on-die port driver's R_DSon plus the LED's r_d for current
  setting. **This is industrial validation of T7 at our exact
  scale.**

### 3.8 IND-A — Candle-flicker integrated LED IC ("commodity novelty IC")

Three distinct architectural generations, all reverse-engineered:

**IND-A1 — Dual RC-osc + analog rejection-sampling (cpldcpu 2013).**
- 440 Hz oscillator (musical "A").
- 12 brightness levels, ~50 % at maximum.
- Rejection-sampling RNG — ~4 attempts max, sequence period
  ~4 minutes ⇒ implies ≥17-bit state.
- Frame = 32 cycles ≈ 72 ms ⇒ pattern update ≈ 13.9 Hz.
- 2-µm-class CMOS, supply 1.9-3.8 V.

**IND-A2 — RC-osc + LFSR + divider chain (cpldcpu 2014).**
- Single RC-osc, 9-stage divider, ~30 flip-flop cells.
- LFSR drives PWM duty selection.
- 13-14 flip-flop minimum architecture: 5b frame counter, 4b PWM
  counter, 4-5b brightness register.

**IND-A3 — Embedded OTP MCU + sleep timer (cpldcpu 2024).**
- PIC12F508/9-class architecture moulded into the LED.
- 240 µA *sleep* current; mA range when active.
- 6 h on / 18 h off duty cycle (timer-based).
- 1 MHz core clock; PWM ≈ 125 Hz.
- ~0.5 mm² die on what looks like 180 nm CMOS.

**These are direct prior art for our problem.** The 2024 generation
in particular hints that "compute the pattern in software, dump
through one transistor" is a viable industry approach.

### 3.9 IND-B — FR1001 / FR1002 special-effects ICs

Eastern Voltage Research's FR1001 and FR1002 are off-the-shelf
candle-flicker controller ICs. 5 V VCC, output drives an external
N-MOSFET gate (so the chip itself is a logic-level pattern source,
not a current source). FR1001 = "harsh exaggerated" pattern;
FR1002 = "more realistic random" pattern.

- *Architecturally interesting:* confirms two distinct algorithm
  families — **deterministic-looped** (FR1001-style; periodic
  pattern with limited entropy) and **LFSR-pseudorandom** (FR1002 /
  cpldcpu IND-A2).
- *Not directly usable:* off-chip part. But it documents the
  *behavioural target* an industry product line treats as "good
  enough" to sell.

### 3.10 IND-C — RFID/NFC field-indicator LED drivers

**NXP NTAG21xF series, EM Microelectronic EM4423** include a
"field-detect" output that drives an LED when an NFC reader is
present. The drive is a small switched current source (~1 mA),
gated by carrier-derived envelope detection. **Architecturally
this is what we want for the NFC-powered case in (b)/(f).**

- *Performance:* sub-mA, fully self-powered from harvested NFC
  field.
- *Why it works in industry but is a niche reference for us:* the
  LED is gated *on* not modulated for twinkle; we need to add the
  twinkle pattern generator on top.

### 3.11 IND-D — PDM / sigma-delta brightness modulation (alternative to PWM)

Used in **NXP/Philips PCA9532** and many automotive LED drivers
(STMicro L99LD01/L99LD21 family) for **higher effective resolution
without raising the PWM carrier frequency**. A first-order sigma-
delta produces a 1-bit stream whose density encodes brightness;
because pulses are spread out, the fundamental-frequency content is
much higher than a same-resolution PWM at the same update rate.

- *Industry source:* EP2081414A1 (NXP, "Sigma delta LED driver"),
  filed 2008, granted 2011 — explicitly covers PDM for LED brightness
  with an added dither-noise input to break first-order tones.
- *Rail-coupling implication:* PDM spreads switching events more
  uniformly than PWM, so storage-cap ripple is *lower* at equal
  average current than PWM at the same effective resolution.
- *Cost:* a few extra flip-flops. Trivially cheap.

### 3.12 IND-E — Self-powered energy-harvest reference designs (TI TIDA-00242, TIDA-00998, BQ25505/BQ25570; ADI MAX20361)

These are not LED drivers per se — they are *upstream* PMICs that
extract µW-mW from solar / RF / Qi sources and produce a regulated
rail. Of interest because the **system-level architecture** they
all converge on is:

- Cold-start at sub-V (BQ25505: V_in ≥ 330 mV; MAX20361: ≥ 225 mV).
- nA-class quiescent (BQ25505: 325 nA; MAX20361: 360 nA) so the
  PMIC itself doesn't burn the harvested budget.
- MPPT (maximum-power-point-tracking) on the harvester input.
- Big *external* storage cap (~10 µF or supercap).

For our die, the "PMIC" is items (b)/(c)/(d) and the storage cap
is item (e). The LED driver (this item) is the *load* below this
PMIC. **Our load must respect the same nA-class quiescent budget**
when the LED is off, or the harvester can't replenish.

### 3.13 IND-F — Pad-cell direct ESD-diode-only "passive analog" pad

**Not a topology per se but a pad choice.** The GF180MCU
`gf180mcu_fd_io__asig_5p0` pad cell is a passive analog bond pad:
no driver, no isolation logic, only ESD diodes (DVSS→ASIG5V and
ASIG5V→DVDD, both `diode_pd2nw_06v0`/`diode_nd2ps_06v0` 4-finger,
~150e-12 m² each — see CDL audit §6). Verified in
`gf180mcu_pdk/gf180mcuD/libs.ref/gf180mcu_fd_io/cdl/gf180mcu_fd_io.cdl`
lines 15-37.

- *Industry equivalent:* the analog "ASIG" pad in every PDK from
  Skywater (`sky130_fd_io__top_xres4v2` analog pads) to TSMC.
- *For LED drive:* lets us route the LED-driver core's
  drain/source directly to the bond pad, with only ESD diodes in
  the way. No CMOS push-pull stack to worry about.
- *Risk:* the ESD diodes connect to DVDD (the I/O 5 V rail). When
  the harvested rail is dead but DVDD is alive (VGA-only mode,
  R10), the LED pad sits at ~DVDD-V_diode = ~4.4 V relative to
  DVSS, with the LED's anode tied to a (dead) harvested rail. This
  forward-biases the LED. **Item (i) must address this; possibly
  via an on-die series isolation switch fed from the harvested-
  rail brown-out detector.**

### 3.14 IND-G — Pad-cell `bi_24t` (24 mA push-pull bidir)

`gf180mcu_fd_io__bi_24t` — 24 mA fixed drive, slew control via SL
input, pull-up/pull-down via PU/PD, 5 V DVDD-rail supply, output-
enable via OE. Reverse-engineered from the LIB
(`gf180mcu_fd_io__tt_025C_3v30.lib`):
`drive_current : 24000.000000` µA, `is_pad : true`,
`function : "((A))"`, `three_state : "((!OE))"`, `direction :
"inout"`. Verified at
`gf180mcu_pdk/gf180mcuD/libs.ref/gf180mcu_fd_io/lib/gf180mcu_fd_io__tt_025C_3v30.lib`.

- *Standard choice if treating the LED as a pulled-low/high digital
  load.* Same pad already used by every VGA output on the v1 die.
- *Issue:* the push-pull driver and its level-shift / OE logic are
  unnecessary for a current-source-driven LED. They consume area
  and add ESD/iso headaches across power-domain boundaries.
- *Cell area:* 75 × 350 µm (LEF audit), 26,250 µm² — large.

### 3.15 IND-H — Pad-cell `bi_t` (programmable 8/16 mA bidir)

`gf180mcu_fd_io__bi_t` — same architecture as `bi_24t` but with
PDRV0 / PDRV1 inputs that select 8 mA (00) / 16 mA (10/01) /
24 mA-equivalent (11). Useful if drive-strength tuning is wanted
post-tape-out. **Architecturally redundant if the on-die LED
driver is its own current source.**

### 3.16 IND-I — Open-source / Tiny Tapeout designs

Searched: nothing on Tiny Tapeout shuttles tt08/tt09 specifically
matches "LED twinkle driver / candle flicker / charge-pumped LED"
as a published project. Closest hits:

- **TomKeddie/tinytapeout-2023-2a** — LED Panel Driver (TT03p5),
  Verilog. Drives an external LED panel via constant-current sink
  pattern; not relevant to our integrated-LED-driver problem but
  validates that LED-driver HDL on Tiny Tapeout is viable.
- **mm21/tinytapeout-led-matrix** and **tinytapeout2-led-matrix**
  — RGB matrix backpack drivers.
- **gregdavill/tinytapeout_spin0** — animation on 7-segment.
- **thexeno/tt08-rgbw-controller** — colour-generator with custom
  CPU.
- **algofoogle/tt09-ring-osc2** — relevant *only* as a model for
  on-die ring oscillator (item (a)), not for LED drive.

**OpenCores:** the search interface returned no LED-driver-specific
projects under the "led" keyword (page rendered as navigation only;
deeper category-by-category browsing would be needed to be fully
exhaustive).

**Negative finding:** there is no published open-source single-IC
"twinkle two LEDs from a harvested rail with on-die-only passives"
design. We are building a niche.

### 3.17 Summary table (industry topologies)

| Short | Topology | Industry source | Naïve / sophisticated |
|---|---|---|---|
| T1 | On-die ballast resistor + switch | candle-flicker LED dies (cpldcpu RE 2013-14) | Naïve |
| T2 | Constant-current sink + internal Iref | TI TLC5947, TLC59281, TLC5926 | Conventional |
| T3 | Current-DAC + PWM (BC/DC trim) | TI TLC59281 | Conventional+digital |
| T4 | Charge-pump bucket-dump | NFC tag IC field-LEDs; TI TIDA-00998 (scaled) | Less common |
| T5 | Boost converter w/ inductor | LT3593, MAX1561/99, MCP1640 | **Rejected (PDK)** |
| T6 | Switched-cap (Dickson) + bucket | EEPROM Vpp pumps, NFC tag pumps | Mature analog |
| T7 | Direct switch (no ballast) | 2024 candle-flicker MCU LED (cpldcpu 2024) | Simplest |
| IND-A1 | Dual RC + rejection-sampling | candle-flicker LED (cpldcpu 2013) | Pattern-gen variant |
| IND-A2 | RC + LFSR + divider chain | candle-flicker LED (cpldcpu 2014) | Pattern-gen variant |
| IND-A3 | OTP MCU + sleep timer | modern candle-flicker LED (cpldcpu 2024) | Pattern-gen variant |
| IND-B | Off-chip candle pattern IC | FR1001 / FR1002 | Pattern-gen variant |
| IND-C | NFC tag field-LED driver | NXP NTAG21xF, EM4423 | System-integration ref |
| IND-D | Sigma-delta / PDM brightness | EP2081414 (NXP); auto LED drivers | Modulator alternative |
| IND-E | Energy-harvest PMIC ref-designs | BQ25505/70, MAX20361, TIDA-00242/998 | Upstream ref |
| IND-F | `asig_5p0` pad (passive ESD-diode-only) | GF180MCU PDK | Pad choice |
| IND-G | `bi_24t` pad (24 mA push-pull) | GF180MCU PDK | Pad choice |
| IND-H | `bi_t` pad (8/16 mA programmable) | GF180MCU PDK | Pad choice |
| IND-I | Open-source / Tiny Tapeout | LED panel & matrix drivers (display, not single-LED) | Reference / null |

### 3.18 Twinkle-pattern algorithms surveyed (industry)

The brief requires ≥ 4 distinct twinkle-pattern algorithms. From
industrial / open-source / RE'd commercial silicon:

| ID | Algorithm | Industry source | Notes |
|---|---|---|---|
| PAT-1 | **LFSR pseudorandom → PWM duty** | candle-flicker LED IND-A2; Hackaday 2014 RE | 5-31 b LFSR; tap-table from RE'd dies |
| PAT-2 | **Rejection-sampling onto histogram** | candle-flicker LED IND-A1 | 12 levels, ~50 % at max — produces the "mostly steady, occasional dip" candle look |
| PAT-3 | **Sine-table lookup ("breathing")** | iPhone / Mac sleep LED; Apple US 7,031,420 (2006) | Smooth periodic, not "organic" — but cheap |
| PAT-4 | **Perlin / value-noise** | LED-matrix ambient-light installations (FastLED library) | More expensive; arguably overkill at single-LED scale |
| PAT-5 | **Brownian / random-walk integrator** | open-source sketches; "fairy light" hobby | Low-pass filtered LFSR — looks organic |
| PAT-6 | **Sigma-delta noise-shaped brightness** | EP2081414 (NXP) | Density-modulated; fewer rail transients per equivalent resolution |
| PAT-7 | **Embedded MCU with hand-tuned table + dithering** | candle-flicker LED IND-A3 | Pattern can be arbitrary; cost = OTP storage |
| PAT-8 | **Two LEDs × phase-staggered** | architectural lighting fixtures | Halves rail ripple in T4/T6; trivial extra cost |

## 4. Sub-block breakdown

See [`components.md`](components.md) for per-topology block lists.
The industry-survey perspective adds three sub-block families that
the first-principles report did not enumerate:

- **Pad-cell selection logic** — which of `asig_5p0` / `bi_t` /
  `bi_24t` is the LED bond pad, and what isolation lives between
  it and the harvested-rail brown-out detector (item (i)).
- **PDM / sigma-delta modulator** — three flip-flops + an adder
  per channel (per EP2081414).
- **NFC-style field-detect gating** — useful pattern for "LED only
  twinkles when harvested rail is alive" (IND-C lineage).

## 5. First-principles sanity checks

Industry numerical claims in §3 are cross-checked here against
physics and the parallel first-principles report.

### 5.1 Boost-converter fundamental limit (T5)

LT3593 datasheet claims 2.7 V Vin minimum with external 4.7 µH
boost inductor and 1 MHz switching. Energy per switching pulse
= ½·L·I_pk² ≈ ½·(4.7e-6)·(0.4)² = **376 nJ** at 400 mA peak.
This is plenty to dump 30 nJ into a white LED 1 µs pulse.

For an *on-die* substitute at 200 × 200 µm (5-15 nH), same I_pk
gives E = ½·(15e-9)·(0.4)² = **1.2 nJ** — 313× short of the
LT3593-equivalent budget. Even if I_pk were pushed to the
electromigration limit of on-die wires (~100 mA peak), E = 75 pJ
— still 5,000× short. **Rejection of T5 is independent of
optimistic on-die-L assumptions.** ✓ Consistent with §5.5 of the
first-principles report.

### 5.2 LED Vf at low currents — datasheet reality check

Industry LED datasheets (Lite-On LTL-307E red 5 mm; Kingbright
WP710A10ID) quote V_f at 20 mA and a *small-signal r_d*. Using
the diode-equation form V_f = V_f₀ + n·V_T · ln(I/I₀) with n=2:
ΔV = 2·26 mV·ln(200) ≈ 275 mV ⇒ V_f(100µA) ≈ **1.73 V** for a
2.0 V@20mA red. Within the **1.7-1.85 V** range claimed in
first-principles §3.1 and §5.1. ✓ Consistent.

### 5.3 IEEE PAR1789-2015 numerical thresholds

Sourced from *Calculating the Maximum Safe Flicker According to
IEEE PAR1789* (AzoM, 2018; URL verified §6) and Wikipedia /
flickersense.org summaries (URLs verified §6). Spot-check verified
against energy.gov SSL, lisungroup, dial.de:

- **Below 90 Hz**: low-risk = `Mod% ≤ f · 0.025`; NOEL =
  `f · 0.01`.
- **Above 90 Hz**: low-risk = `Mod% ≤ f · 0.08`; NOEL =
  `f · 0.0333`.

For our 100 % modulation depth (PWM gating between 0 % and 100 %
duty), Mod% = 100 %:

- **Low-risk above 90 Hz:** f ≥ 100/0.08 = **1250 Hz**.
- **NOEL above 90 Hz:** f ≥ 100/0.0333 = **3003 Hz**.

**Design implication:** PWM carrier *must* be ≥ 1.25 kHz to be
"low-risk", ≥ 3 kHz to be "no observable effect." **This binds T1,
T3, T4, T6, T7 PWM-rate design.** First-principles report §5.3
suggested 1-10 kHz — that range is consistent with PAR1789 but the
*bottom* of the range needs tightening from "1 kHz" to "≥ 1.25 kHz"
for low-risk compliance.

The visible-twinkle envelope is a separate signal — its modulation
is **intentional** and below CFF; PAR1789 is concerned with the
*involuntary* modulation due to PWM brightness control. The two
do not conflict.

### 5.4 Candle-flicker LED current draw vs harvested budget

cpldcpu (2024) reports the modern OTP-MCU candle-flicker LED
draws "several mA" active and 240 µA sleep on a CR2032. That's a
**direct existence proof** that a useful twinkle effect is
producible at single-mA average current — exactly our budget once
NFC or Qi harvester is engaged.

For ambient-2.4-GHz harvesting: typical office-RF density at 1 m
from a Wi-Fi AP is ~1 µW/cm². A 50 cm² PCB IFA at 30 % aperture
efficiency captures ~15 µW. At 2 V·100 µA = 200 µW for one
red-LED pulse, that's a duty cycle of ~7 %. **Possible but very
dim** — same conclusion as first-principles §N5.

### 5.5 Quiescent current of TLC5947 at zero PWM

TI's TLC5947 datasheet does not commit a clean idle-current
specification — multiple TI datasheets (TLC5926, TLC5940) commit
1-3 mA quiescent. **At µW-mW harvested budget, that quiescent
current alone exceeds the entire LED budget.** Industrial LED
driver ICs are *fundamentally mis-targeted* for our use case.

Independent verification: scaling from R8 candle-flicker data
(cpldcpu 2024 — 240 µA total *sleep* including LED-off PIC core
quiescent) to "controller alone" suggests integrated controller-IC
quiescent in the 10s of µA is achievable in 180 nm CMOS. This is
what we should be designing toward.

### 5.6 PDM vs PWM rail-coupling

For equal effective resolution N bits and equal average current I:

- **PWM**: pulse = I_peak for τ = (M/2^N)·T_period, where M is the
  digital code; period T = 2^N · t_clk.
- **PDM (1st-order ΔΣ)**: switch every t_clk, density = M/2^N,
  period of any *tone* = T/M typical.

For M = 0.5·2^N (50 % brightness), PWM has one pulse-per-period of
length T/2; PDM has alternating-pulse density. **PDM's
fundamental-frequency content is at f_clk/2, not f_clk/2^N.**
For 8-bit resolution at f_clk = 1 MHz: PWM fundamental = 3.9 kHz;
PDM fundamental = 500 kHz. **PAR1789 compliance is essentially
free with PDM.** This wins for small *N* but does not eliminate
the rail-current-pulse problem (T1/T3 worst case from §5.6 of the
first-principles report still applies; T4/T6 buffer either way).

### 5.7 Pad-cell drive current vs LED current

`bi_24t` is rated for 24 mA continuous (per LIB
`drive_current : 24000.000000` µA). Our peak target is 1-16 mA
(per first-principles §3.5 T4 example). Headroom is comfortable.
`bi_t` at 8 mA minimum strength is also adequate at 1 mA average.
No pad-current sanity-check fails.

## 6. References

See [`references.md`](references.md) for the full annotated
bibliography with WebFetch verification status.

## 7. Negative results

**N1 — TLC5947-class driver IC quiescent current is too high.** §5.5
above. Industrial LED-driver ICs target lighting / display
applications where 1-3 mA controller quiescent is irrelevant. For
our µW-mW harvested budget the controller quiescent alone would
deplete the rail. **Reject all TLC59xx-style commercial part lines as
direct architectural references.**

**N2 — Boost converter category dead.** §5.1 above. LT3593,
MAX1561, MCP1640 all need ≥ 4.7 µH external inductors. No on-die
substitute reaches within 5 orders of magnitude of the required
energy-per-pulse. This is **the** "obvious commercial answer" we
must explicitly close down. *Note overlap with first-principles
§N1; both reports agree, which is appropriate because the physics
is the same and the conclusion is unambiguous.*

**N3 — `asig_5p0` ESD-diode forward-bias risk in VGA-only mode.**
§3.13 above. The `asig_5p0` pad's ESD diodes are referenced to DVDD
(the 5 V I/O rail). If we route the LED via this pad and the LED's
anode is tied to the (dead) harvested rail while DVDD is alive,
the upper ESD diode (ASIG5V→DVDD) is reverse-biased (safe), but
the LED itself plus an external connection back to the dead
harvested rail will see DVDD - V_LED forward-bias from the I/O
ring through any unintended path. **An explicit cross-domain
analysis in item (i) is required.** This is a real, novel-to-us
finding the first-principles report did not flag.

**N4 — No directly-applicable open-source single-IC twinkle
driver.** §3.16. Searched Tiny Tapeout shuttles tt03p5..tt09 and
OpenCores. Found LED-matrix and 7-seg drivers (TomKeddie, mm21,
gregdavill, thexeno). None match "two LEDs, sub-mA, harvested
rail, on-die-only passives, organic pattern." We are designing
into a published-IP gap. *Note:* this absence is itself a
publishable contribution from the project.

**N5 — FR1001 deterministic pattern is rejected by user-experience
literature.** Implicit in cpldcpu 2024 conclusions: deterministic
short-period patterns "look like a pattern" within seconds-minutes
of observation. The 2014 RE'd LFSR die has a ~4 minute apparent
period (cpldcpu 2014, IND-A1). Recommendation: target ≥ 4-minute
non-repeating pattern for our die ⇒ **17-bit LFSR minimum, 24-bit
preferred.**

**N6 — Sine-table breathing (PAT-3) is "wrong shape" for candle
twinkle.** Industry usage (Apple sleep LED, breathing chargers)
gives a *too-smooth, too-periodic* feel. Acceptable for "presence
indicator" but not for "twinkle". Documented so PAT-3 isn't
silently chosen on the basis of cheap implementation.

**N7 — PAR1789 compliance kills sub-1 kHz PWM defaults.** Common
hobbyist LED-PWM defaults at 60-490 Hz (Arduino default = 490 Hz on
most pins) **violate IEEE 1789-2015 low-risk thresholds at any
substantial modulation depth.** At Mod% = 100 %, low-risk above
90 Hz requires f ≥ 1250 Hz. The first-principles report's "1-10
kHz" lower bound was an order-of-magnitude estimate that turns out
to be borderline-compliant only at the upper end; we should
specify ≥ 1.25 kHz minimum, target 3-10 kHz.

## 8. Open questions

See [`open-questions.md`](open-questions.md).

## 9. Comparison readiness

| Approach | Headline performance | Area / power cost | Maturity | Best fit for | Worst fit for |
|---|---|---|---|---|---|
| T1 — resistor ballast + switch | η = V_f/V_rail (56 % red); ±30 % I PVT spread | ≈ 2-5 kΩ poly + 50-100 µm switch (~10k µm²) | Trivial; matches RE'd commodity ICs (cpldcpu 2013-14) | Red/orange/yellow on intermittent rail | Blue/white; precise match of 2 LEDs |
| T2 — current sink + Iref | Constant I; needs 0.4-1.5 V headroom; controller draws mA quiescent | Bandgap (~50k µm²) + mirror (~5k µm²); + mA-class Iq | Mature commercial (TLC59xx) | Multi-LED display matrices on stiff rail | **Our µW-mW harvested rail (Iq exceeds budget)** |
| T3 — current-DAC + PWM (BC/DC) | Per-LED brightness trim | T2 + DAC tail (~5k µm²) + PWM counter | Mature commercial (TLC59281) | Multi-LED matched-uniformity displays | Single-LED, energy-budgeted |
| T4 — bucket-dump | η ≈ 50 %; 1000× rail-coupling reduction; brown-out smooth | 10 nF MIM (~50k µm²) + 2 switches + non-overlap clk | Less common; well-known to RFID/NFC IC designers | Brown-out-prone harvested rails; pulse LED protection | Steady illumination; when MIM area scarce |
| T5 — boost (on-die L) | n/a (rejected) | 5-15 nH on-die L vs 4.7 µH external ⇒ 313-5000× short of energy budget | **Rejected** | n/a | Everything |
| T6 — Dickson + bucket | η ≈ 30-40 %; drives blue/white from 3.3 V; deferred brown-out | T4 + 1 cap + 3 switches | Mature (Dickson 1976; EEPROM Vpp pumps everywhere) | Blue/white at 3.3 V; series-LED strings | When red is sufficient |
| T7 — direct switch | η = V_f/V_rail max; I = switch I_DSAT; ±3× PVT | ≈ 100-200 µm switch + eFuse trim (~2k µm²) | Trivial; validated by 2024 candle-flicker MCU | Single colour, single LED, area-constrained | Brightness uniformity across LEDs |
| IND-A1 | Dual RC + rejection-sampling pattern | Cell area: ~0.1 mm² in 2 µm CMOS; scales to ~5k µm² in 180 nm | Reverse-engineered commercial silicon | "Realistic candle" effect | Power-flexible / arbitrary patterns |
| IND-A2 | RC + LFSR + 9-stage divider | ~30 flip-flops + ~5-10 gates | RE'd commercial silicon | LFSR-based variable patterns | Fixed deterministic patterns |
| IND-A3 | OTP MCU (PIC12-class) | ~0.5 mm² in 180 nm; 240 µA sleep | Modern commercial silicon | Arbitrary pattern + scheduling | Strict ultra-low Iq |
| IND-D | PDM / sigma-delta brightness | +3 FF, +1 adder vs PWM | Patented (NXP EP2081414); textbook | PAR1789 compliance with low f_clk | When PWM is already plenty fast |
| IND-F | `asig_5p0` pad | 26,250 µm² (0.026 mm²); ESD-diode-only | PDK standard cell; verified in CDL | Direct LED current routing; minimal interference | When push-pull is also wanted |
| IND-G | `bi_24t` pad | 26,250 µm²; 24 mA push-pull | PDK standard cell; already used in v1 | Reuse as switched-low-side LED driver | When current-source semantics wanted |

## 10. Author's notes (surprises)

1. **The candle-flicker LED industry is the single most directly-
   relevant prior art** for our problem and it lives entirely
   *outside* the formal LED-driver-IC literature (which is targeted
   at lighting / display, not novelty single-LED applications).
   Three reverse-engineered architectural generations exist
   (cpldcpu 2013, 2014, 2024) — all on dies essentially equivalent
   to or smaller than our intended block area. **They are existence
   proofs.**
2. **PAR1789 numerical thresholds are tighter than typical
   hobbyist LED-PWM practice** by an order of magnitude. The widely
   quoted "100 Hz is fine" rule fails the standard at any
   substantial modulation depth. Our design must hit ≥ 1.25 kHz
   minimum to claim low-risk; ≥ 3 kHz for NOEL.
3. **The boost-converter rejection is a more powerful argument with
   industry datasheet evidence than first-principles alone** —
   LT3593 / MAX1561 / MCP1640 *all* commit to external L of similar
   value, despite competitors trying to differentiate. If on-die L
   were viable, somebody would have shipped a boost-converter LED
   driver with no external passives. Nobody has.
4. **Pad-cell choice is non-trivially cross-coupled with item (i)
   power-domain isolation.** The naive answer ("use `bi_24t` again")
   risks forward-biasing the LED through ESD diodes during VGA-only
   mode. The honest answer ("use `asig_5p0`") has a different
   ESD-diode topology that needs the same analysis. This deserves
   explicit Stage-2 attention.
5. **PDM brightness modulation (IND-D) appears nowhere in the
   first-principles report**, despite being a well-developed
   industry technique covered by NXP's 2008 patent and shipping in
   automotive LED drivers. This is a Stage-1 gap surfaced by the
   industry survey. Strong candidate for Stage 2 to elevate into
   the option-comparison matrix.
6. **No `pdrv0`/`pdrv1` programmable strength in `bi_24t`** — the
   24 mA cell is fixed-strength only. The `bi_t` cell offers
   programmable 8/16 mA via PDRV[1:0]. If the LED-driver wants
   eFuse-trimmable strength via pad-driver gain, `bi_t` is the
   correct pad — but the "right" answer is probably to do trimming
   inside the on-die driver core and use `asig_5p0`.

## Recommended pad cell (PDK audit)

**Recommendation: `gf180mcu_fd_io__asig_5p0`** for both LED bond
pads, with the LED current source / driver implemented as on-die
custom logic in the harvested-rail power island. Justification:

- Passive bond pad (only ESD diodes between PAD and DVDD/DVSS).
- No level shifters or unwanted push-pull behaviour to worry about
  during VGA-only mode (the active driver lives in the harvested
  domain and is implicitly off when that rail is dead).
- Same cell area (75 × 350 µm = 26,250 µm²) as `bi_24t`, so no
  pad-ring penalty.
- Cross-domain ESD analysis still required (negative result N3) but
  is decoupled from the driver's own current-source logic.

**Fallback: `gf180mcu_fd_io__bi_24t`** if the on-die LED driver
must reuse the standard pad-frame infrastructure (ESD path, slew
control, OE gating). Drive current 24 mA is comfortably above LED
peaks of 1-16 mA. Already validated by the v1 die's VGA outputs.

**Reject: `gf180mcu_fd_io__bi_t`** for our use case — programmable
drive strength is the wrong knob; eFuse trim should live in the
LED-driver core, not in the pad.
