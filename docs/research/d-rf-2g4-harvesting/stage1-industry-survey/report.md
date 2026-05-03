---
item: d
item_name: rf-2g4-harvesting
stage: 1
angle: industry-survey
researcher: claude-opus-4-7-1m — Stage-1 industry-survey agent
status: draft
last-updated: 2026-05-03
---

## 1. Executive summary

This report surveys the *commercial* and *commercial-adjacent* state of
the art in 2.4 GHz ambient-RF energy harvesting, from the perspective
of a chip-side single-pin antenna feed on `gf180mcuD`. It looks at
discrete RF harvester ICs (Powercast P2110B, P21XXCSR / PCC110+PCC210,
e-peas AEM30940), integrated harvest+radio SoCs (Atmosic ATM3 / ATM33e,
Wiliot IoT Pixel), regulatory power envelopes (FCC 47 CFR §15.247,
ETSI EN 300 328, IEEE 802.11 typical AP behaviour), passive-front-end
practice (Antenova RUFA, Si Labs AN930.2), and the closest published
180 nm CMOS silicon results (Yan et al. 2024 RFIC; Kadali et al.
2021; Chun, Ramiah, Mekhilef 2022 IEEE Access review).

Headline conclusions (no winner picked at Stage 1):

- **No commercially available off-the-shelf RF harvester IC is
  optimised for 2.4 GHz ambient (Wi-Fi/BLE) operation.** Powercast's
  flagship P2110B is 902–928 MHz; their multi-band evaluation kit
  P21XXCSR includes a 2.45 GHz SMA, but the underlying chipset
  (PCC110/PCC210) is a generic RF-to-DC plus boost pair tuned via
  per-band off-chip matching networks. e-peas's AEM30940 RF
  application note characterises only 868 MHz and 915 MHz —
  explicitly stating that "using a non-dedicated RF source (such as
  WiFi, 3G, 4G or Bluetooth) prevents control on the antenna and on
  the real emitted power. It requires some previous tests to
  understand the truly available power" (verified, e-peas RF AppNote
  for AEM30940, 2020).
- **The most-cited 2.4 GHz silicon result for ambient RFEH** — Yan
  et al., RFIC 2024, "A 2.4 GHz, -19 dBm Sensitivity RF Energy
  Harvesting CMOS Chip with 51% Peak Efficiency and 24 dB Power
  Dynamic Range" — uses 180 nm bulk CMOS with a *reconfigurable*
  rectifier, MPPT, 3× switched-cap charge pump, two regulators, and a
  meander dipole antenna. Reported sensitivity threshold -19 dBm
  (12.6 µW input). At lab conditions, that's an extremely respectable
  number; under Friis at 2.45 GHz, -19 dBm corresponds to roughly
  1.1 m line-of-sight from a 100 mW (20 dBm) Wi-Fi AP with a
  textbook 2 dBi receive antenna. At realistic IFA gain (≈ -1 dBi
  for a 6 × 10 mm antenna) the threshold range collapses to roughly
  0.6 m.
- **The "ambient harvesting" branding in the trade press is, to a
  first approximation, marketing.** Atmosic's "Energy Harvesting
  Advantage" white paper (verified PDF, 2023) does *not* describe
  2.4 GHz ambient RF harvesting as the load case; it models a
  photovoltaic remote control. Atmosic's actual technology
  contribution is an *integrated PMU* that consumes harvested DC from
  *whatever* source — PV, TEG, RF (with an external rectifier),
  mechanical. Wiliot's IoT Pixels are documented as needing nearby
  Wiliot-provided "energizers" or compatible APs; ambient soup alone
  is well below their threshold (consistent with the first-principles
  report's Pinuela 2013 anchor).
- **Regulatory ceiling at 2.4 GHz is comparatively low.** US FCC
  47 CFR §15.247 caps 2.4 GHz unlicensed digitally-modulated
  conducted output at 1 W (30 dBm) with a 6 dBi reference antenna,
  i.e. 36 dBm EIRP at the regulatory ceiling, but real consumer Wi-Fi
  APs ship at 100 mW conducted (20 dBm) with 0–3 dBi PCB antennas →
  ~22 dBm EIRP typical. ETSI EN 300 328 V2.2.2 caps 2.4 GHz wideband
  TX at 100 mW EIRP, with PSD limits — the regulatory envelope in
  Europe is lower than in the US. Either way the *delivered* RF
  density to a card 1–10 m from the AP is set by Friis, and is
  several orders of magnitude below what commercial RF harvester ICs
  (built for dedicated, near-field-ish sources) characterise as
  "ambient".
- **Pure passive matching at 2.4 GHz on a chip with no off-chip
  passives is far from standard.** Si Labs AN930.2 (cached, 2025)
  shows that mainstream EFR32 Series-2 BLE radios match the antenna
  with 3-, 4-, or 5-element discrete LC ladders on the *PCB*. A
  no-external-passives constraint forces all matching onto the die
  plus the PCB antenna self-reactance — which is doable (multiple
  published RFEH chips do this) but is unconventional commercially.

The first-principles sister report concluded that ambient-only twinkle
becomes infeasible past ≈ 1–2 m from a 100 mW EIRP AP. **The
industry record substantially confirms this**, with the additional
qualifier that even the best published 180 nm silicon (-19 dBm
sensitivity) only buys back about a doubling of that range under
generous antenna assumptions. **The honest framing for the project is
"twinkle requires the card to be held within ~1 m of an actively
transmitting Wi-Fi AP", not "twinkle anywhere there's Wi-Fi".**

## 2. Requirements as understood

From `TODO.md` §(d) "Ambient 2.4 GHz RF harvesting (single-pin
antenna)": "Scavenge enough µW from background Wi-Fi / Bluetooth to
run the LED drivers (only) when neither Qi nor NFC is available."

From the per-item README scope:
1. Empirical ambient power densities at 2.4 GHz (independent
   measurements, not vendor white papers).
2. Single-pin antenna feed — IFA, monopole, chip antenna, PIFA,
   electrically-small loop.
3. Rectifier topologies — Dickson, cross-coupled differential,
   threshold-cancellation tricks, native / zero-Vt devices in
   `gf180mcuD`.
4. Matching network — on-die L is borderline at 2.4 GHz; bondwire
   self-inductance and antenna self-reactance are part of the
   network.
5. Real-world receive sensitivity — a published *measured* threshold
   that lit an LED, not just produced "a few mV across a cap".
6. Friis sanity for 100 mW APs at user distances.
7. Antenna sharing with item (k) BLE TR-switching.

Hard constraints inherited:

- One bond pad for the antenna, with the package + on-die return as
  ground reference.
- `gf180mcuD` 180 nm process, 5 V MCU flavour with native-Vt NMOS
  available.
- LED-driver consumer only (NFC core (h) and BLE PA (k) are powered
  by other rails / mostly out of scope here).
- No external passives anywhere on the card other than the PCB
  copper antenna itself.
- Top metal must remain readable as the wafer.space logo.
- Antenna shared with (k) BLE if item (k) is ever implemented.

## 3. Solution-space map

This survey is structured along the same three axes the
first-principles report used (multiplier topology, threshold
cancellation, matching network), plus four more axes that the
*industry* literature surfaces strongly: discrete-vs-integrated
back-end PMU, antenna technology, regulatory power envelope, and
ambient vs cooperative-source operating model.

### 3.A Rectifier / multiplier topologies (industry-observed)

Stable short names match those used in the first-principles report
where they exist; new entries are tagged `i-` for industry-survey
origin.

#### 3.A.1 `dickson-naive-nfet` — diode-connected NMOS Dickson

Textbook UHF RFID rectifier. Industry use: most early 13.56 MHz NFC
tags; small handful of UHF RFID tags in 0.35 µm CMOS where standard
Vth is also low. **Failure mode at our target:** Yan et al. 2024
explicitly motivate their reconfigurable rectifier by the
sub-100 mV-input regime in which a fixed Dickson collapses; consumer
CMOS Vth ~0.5 V is incompatible with our -20 to -30 dBm input.
Discarded by silicon designers for sub-µW ambient harvest.

#### 3.A.2 `dickson-native-nfet` — Dickson with native-Vt or zero-Vt NMOS

`gf180mcuD` exposes native-Vt 6 V NMOS with VT0 typ -0.12 V (verified
PDK page, first-principles report R1). Most published 180 nm bulk RFEH
chips use an equivalent device flavour from their foundry (TSMC's
ZVT, GF's NVT, UMC's similar). **Industry use:** a sizable fraction
of the IEEE Access 2022 Chun/Ramiah/Mekhilef review's surveyed
designs. Sensitivity in published 180 nm CMOS silicon: roughly
-12 dBm to -20 dBm depending on stage count, antenna+matching, and
charge-pump back-end. **Limit:** native-Vt FETs leak heavily in OFF,
which limits per-stage stored charge — multi-stage Dickson eats this
penalty as series-leakage divider.

#### 3.A.3 `dickson-pmos-cross-coupled-differential`

The Yan et al. 2024 RFIC paper, the Pakkirisami Churchill 2022 MDPI (corrected from "Awad MDPI 2022" 2026-05-04 per reviewer-1) paper anchored in
the first-principles report, and Kadali 2021 all use a *differential*
cross-coupled rectifier as a key efficiency lever (PCE 47–86 % peak in
the surveyed papers). **Industry use:** dominant in modern UHF/2.4 GHz
RFID chips and modern 180 nm RFEH publications. **Conflict with our
single-pin constraint:** the topology requires a balanced /
differential RF input. Solutions: (a) on-die transformer
single-ended-to-differential balun (§3.A.6 / §3.C.3); (b) PCB-side
differential antenna feed — *forbidden* under the no-external-passives
rule unless the PCB antenna itself is intrinsically differential
(IFA is single-ended).

#### 3.A.4 `villard-half-wave` — Villard cascade

Classical asymmetric half-wave multiplier. **Industry use:** common
in pre-2010 UHF RFID tags; rarely the SOTA today. Better suited to
single-ended drive than 3.A.3 but lower PCE. Worth keeping in the
solution map as a low-area fallback.

#### 3.A.5 `dynamic-vth-cancellation` — Kotani-style aux-bias

Kotani & Sasaki A-SSCC 2007 introduced static gate-bias offsets that
cancel the rectifier's effective Vth. Adopted in many industry RFID
chips. **Sub-flavours:** (a) self-biased bootstrap from the rectifier
output (chicken-and-egg cold-start solved by a small naive first
stage); (b) DTMOS (body tied to gate) — depends on isolated-well
availability, problematic in `gf180mcuD` for the NMOS half; (c)
floating-gate trim — needs OTP, ties this work to item (j).

#### 3.A.6 `transformer-coupled` / on-die balun

Antenna feeds the primary of an on-die transformer; rectifier sees
the differential secondary plus a 2–3× voltage step-up. Common in
NFC tag silicon at 13.56 MHz where transformers are inexpensive in
area; **less common at 2.4 GHz** because the transformer Q (~5–8 in
180 nm) limits the achievable step-up. Compatible with single-pin
antenna feed.

#### 3.A.7 `i-reconfigurable-rectifier` — switched-stage / power-adaptive

**Industry-observed addition.** Yan et al. 2024 RFIC, and earlier
papers cited in Chun 2022 IEEE Access review, extend the rectifier's
useful Power Dynamic Range (PDR) to ~24 dB by *reconfiguring* the
stage count or rectifier connectivity as input power changes.
At low input the harvester runs many stages with low per-stage drop;
at high input it bypasses stages to avoid efficiency collapse from
over-drive. MPPT or a coarse RSSI digital loop chooses the
configuration. **Cost:** small digital control overhead, switching
FETs in series with the RF path (parasitics).

#### 3.A.8 `i-rectifier+lf-boost-converter` — discrete two-stage architecture

The dominant *commercial* topology. Powercast PCC110 (RF-to-DC) feeds
a TI bq25504-class boost PMIC (or Powercast PCC210, also
boost-PMIC-class). e-peas AEM30940 has the same architecture
internally. **Why this exists commercially:** the rectifier wants to
present a *low* Z (impedance match to ~50 Ω antenna), while the
storage-cap interface wants a *high* Z (so a slow DC-DC can extract
power efficiently across PCC). The boost converter is the impedance
transformer between them — and is also where MPPT lives. **For our
chip:** the boost converter needs an external inductor; on-die it
becomes a switched-capacitor charge pump (Yan 2024 uses 3× SC; this
is the standard substitute).

### 3.B Threshold-loss-reduction techniques (combinable with §3.A)

- `vth-low` — native-Vt devices (in 3.A.2 already).
- `vth-aux-bias` — Kotani 2007 style, see §3.A.5(a).
- `vth-bootstrap` — cold-start naïve stage feeding the auxiliary
  bias of subsequent stages. Industry standard.
- `body-tied-DTMOS` — limited by `gf180mcuD` bulk technology.
- `floating-gate-trim` — see §3.A.5(c). Industry-rare for ambient
  RFEH because OTP burn voltages must be supplied externally.

### 3.C Matching / step-up network options (industry practice)

#### 3.C.1 `match-LC-pi` and 3.C.2 `match-LC-series`

Standard LC matches. Si Labs AN930.2 documents 3-, 4-, and 5-element
discrete LC ladders for EFR32 Series-2 — the dominant commercial
practice for 2.4 GHz **with off-board passives allowed**. We can't
use off-board passives, so these are interesting only as a model
template for what an *on-die* equivalent would have to deliver.

#### 3.C.3 `match-transformer` / `i-on-die-transformer-balun`

Same as §3.A.6. Industry uses this less at 2.4 GHz than at 13.56 MHz,
but it is documented in 180 nm RFEH publications. Q-limited
(simulator extracts ~5–8 typical at 2.45 GHz on `gf180mcuD`-class
metal stacks).

#### 3.C.4 `match-bondwire-only`

Industry attestation: most short-range radio reference designs treat
the bondwire as a parasitic to *minimise* (multiple parallel ground
bonds, short signal bondwire), not as a matching element. For our
case the single-pin antenna constraint makes this binding: the
bondwire's ~1 nH/mm × 2 mm = 2 nH ≈ 31 Ω at 2.45 GHz dominates
short-of-50 Ω rectifier input. **The bondwire is the matching
element whether we want it to be or not** (first-principles report
§5.7).

#### 3.C.5 `i-antenna-self-reactance-as-match` — co-design

The first-principles report calls this out implicitly. Industry
practice on chip antennas (Antenova RUFA — verified cached
datasheet): present a 50 Ω port at the SMA/feed pad, with -11 dB
return loss across the band, peak 2.1 dBi, **average -1.2 dBi**.
For a *non-50 Ω* die input, the antenna must be co-designed —
adjust IFA arm length / feed-tap position so that the antenna's
own complex impedance at the rectifier-side reference plane is the
conjugate of the rectifier+bondwire input impedance. Common in
academic implants and RFID tags; less common in commercial
short-range radios where 50 Ω discipline is the norm.

### 3.D Discrete-vs-integrated PMU back-end (industry-distinctive axis)

#### 3.D.1 `i-external-pmu-bq25504` — Texas Instruments

TI BQ25504 ultra-low-power boost converter (verified cached
datasheet, 2023 rev): V_in ≥ 130 mV operating, V_in ≥ 600 mV
cold-start, I_Q ≈ 330 nA quiescent, integrated MPPT, programmable
under/over-voltage. **Designed to be the back-end** to an external
photovoltaic, TEG, or *RF rectifier* DC output. Not a 2.4 GHz part
itself — it sees DC. Architectural relevance: any commercial path
that yields >130 mV DC into a storage cap can drive an LED via this
class of part. We can't use BQ25504 (external passive, external
inductor), but it shows the industry expectation: rectifier output
is 130 mV or more before useful work happens.

#### 3.D.2 `i-external-pmu-aem30940` — e-peas

Same role as 3.D.1 from a different vendor; AEM30940 application
note characterises 868 MHz / 915 MHz harvesting (verified cached
PDF). Importantly, the e-peas tables show: at 868 MHz, EIRP 0.2 W,
distance 1 m → average available power **63 µW** over 24 h with
93 % duty (their ETSI 302 208 baseline). At distance 5 m, EIRP 1 W,
915 MHz, 100 % duty → **0.8 µW**. Scaling to 2.4 GHz with FSPL 8.4
dB worse and Wi-Fi 100 mW EIRP, the equivalent figure drops by
roughly 7 dB just from the EIRP delta plus FSPL — **into single-µW
or below at 1 m, single-nW at 5 m.** Aligned with first-principles.

#### 3.D.3 `i-integrated-pmu-soc` — Atmosic ATM3 / ATM33e

Atmosic Energy Harvesting Advantage white paper (verified, cached
locally): the company integrates the PMU *into* a Bluetooth SoC,
accepting harvested DC up to 3.3 V (passive bypass) or higher
(boost). The white paper's worked example is a *photovoltaic*
remote control, not 2.4 GHz RFEH. Atmosic's "RF energy" claim is
covered by the same input PMU — there's no specific 2.4 GHz
rectifier sensitivity figure published for their parts. **For our
project, the architectural lesson is integration**: avoid the
discrete two-stage efficiency hit (~72–81 % overall, per Atmosic
white paper).

#### 3.D.4 `i-integrated-rectifier+ble-soc` — Wiliot IoT Pixel

Wikipedia entry verified 2026-05-03: Wiliot Pixels harvest from
"ambient Wi-Fi, cellular, and Bluetooth signals" with ARM
Cortex-M0+, BLE radio, and harvesting antennas. Practical operating
range — per third-party trade reporting — depends on Wiliot
"energizer" infrastructure or strong nearby APs; ambient RF
without a cooperating source is well below threshold. Publication
of formal sensitivity numbers is limited (FCC ID search inconclusive
at 2026-05-03; no clean match in the public FCC database).

### 3.E Antenna technology (industry-observed)

#### 3.E.1 `ant-pcb-ifa` — printed inverted-F

Our PCB project's `In2.Cu` 6 × 10 mm meander IFA. Antenova RUFA
(SMD chip equivalent, verified): 12.8 × 3.9 × 1.1 mm, 2.1 dBi peak
gain, **-1.2 dBi average gain**, 75 % efficiency, requires
ground-plane keep-out. Realistic for our card. Accepts single-pin
50 Ω feed.

#### 3.E.2 `ant-pcb-monopole` — quarter-wave

λ/4 at 2.45 GHz = 30.6 mm — fits diagonally on a credit-card form
factor but breaks the wafer.space-logo top-metal requirement on
chip-side antennas. Used as PCB monopole instead. Higher gain
(~2 dBi) than IFA but larger area.

#### 3.E.3 `ant-pcb-loop` — small magnetic loop

ka < 0.5 at our card dimensions → strong Chu-Harrington Q penalty.
Not normally used at 2.4 GHz (used at NFC 13.56 MHz where it makes
sense). Listed for completeness.

#### 3.E.4 `ant-chip-antenna` — discrete SMD

Antenova RUFA, Johanson, Yageo etc. Off-PCB passive — *forbidden*
on this card.

#### 3.E.5 `ant-pifa` — planar inverted-F

Mainstream in mobile handsets, but typically uses a multi-layer
substrate stackup, off-PCB component, and ground-plane shaping that
the credit-card PCB doesn't realistically provide. Listed for
completeness.

#### 3.E.6 `i-ant-pcb-meander-dipole-differential`

The Yan et al. 2024 RFIC paper uses a meander dipole — *intrinsically
balanced/differential*. This sidesteps the §3.A.3 single-pin
constraint at the cost of two bond pads and a balanced antenna
topology that doesn't match the existing PCB sub-project's
single-feed IFA. Worth flagging as a design-choice fork.

### 3.F Regulatory power envelope (industry-derived)

#### 3.F.1 FCC 47 CFR §15.247 (United States)

Verified from cornell.edu/cfr (2026-05-03): "1 watt" max
peak conducted output for digitally-modulated 2.4 GHz systems.
"The conducted output power limit ... is based on the use of
antennas with directional gains that do not exceed 6 dBi."
Higher-gain antennas trigger 1 dB-for-3 dB power reduction. **Real-
world consumer Wi-Fi APs:** roughly 100 mW (20 dBm) conducted with
0–3 dBi PCB antennas → ~22 dBm EIRP, well below the regulatory
ceiling and **6–14 dB below** the worst-case FCC envelope.

#### 3.F.2 ETSI EN 300 328 (Europe)

Verification status partial — cited at e-peas AppNote and elsewhere
indirectly. The key well-known limit is **100 mW EIRP** (20 dBm)
in 2400–2483.5 MHz, with PSD limits around 10 dBm/MHz. European
APs run at or below this. **For our purposes, the EU envelope is
strictly worse than the US one.**

#### 3.F.3 IEEE 802.11 typical AP transmit behaviour

The 802.11 standard does not pin down a TX power; it's regulated
locally. Survey of consumer datasheets (multiple AP vendors): typical
conducted Wi-Fi AP TX power 17–20 dBm at 2.4 GHz, 1–3 dBi PCB
antennas, EIRP 18–23 dBm (60–200 mW). Typical *duty cycle* for an
idle AP transmitting beacons only: 100 ms beacon interval × ~250 µs
beacon → ~0.25 % duty; BSS load with traffic raises this. **An idle
AP is not a continuous power source** — the harvester must hold up
between beacons via storage cap (10 ms-class hold-up). EFR32 BG24
RX sensitivity at 1 Mbps GFSK: -97.6 dBm (verified Si Labs page,
2026-05-03) — that's BLE *bit-detection* sensitivity, not a useful
energy-harvest threshold; the energy-harvest threshold is ~80 dB
worse, which is exactly the gap between communication and harvesting
that this whole problem space lives in.

### 3.G Ambient vs cooperative-source operating model (industry distinctive)

Two clear families exist:

#### 3.G.1 `mode-cooperative-source`

Powercast, e-peas (with their TX91501 or equivalent licensed dedicated
emitter), Wiliot Energizer pucks, RFID readers — a known, often
*licensed* (not unlicensed), high-power transmitter is provided. e-peas
table: 1 W EIRP @ 5 m → 0.8 µW average power. This is the operating
mode where commercial RFEH actually works.

#### 3.G.2 `mode-true-ambient`

Pinuela 2013 IEEE TMTT survey (cached PDF, verification partial):
broadband 680 MHz–3.5 GHz London urban average -12 dBm/m² → ~63 µW/m²
(area-density), single-channel 2.4 GHz contribution ~0.1 nW total
into a credit-card antenna in a *typical* urban location. **Industry
position:** no commercial RFEH IC is sold against this regime. Even
Wiliot's "ambient" branding is paired with infrastructure deployment.

### 3.H Antenna sharing with item (k) BLE — TR-switching

Not a commercial pattern in published harvester ICs (because they're
not radios), but ubiquitous in BLE/Wi-Fi front ends for RX/TX
sharing. Common topologies: (a) series-NFET TR switch with
shunt-NFET for off-isolation; (b) λ/4 transmission-line switch;
(c) detuned-network "soft" switch. At 2.4 GHz on `gf180mcuD`
expect ~0.5–1.5 dB insertion loss on the harvest path and 30–50 dB
TX-to-harvester isolation, consistent with first-principles §5.9.

## 4. Sub-block breakdown

See [`components.md`](components.md).

## 5. First-principles sanity checks

The first-principles sister report did the heavy Friis derivation
(report §5.1). This survey re-anchors several *industry* numbers
against physics and cross-checks them.

### 5.1 Powercast P2110B "operates down to -12 dBm" — sanity check

Verified from cached P2110B datasheet (2016/12 rev): "Operation down
to -12 dBm input power." -12 dBm = 63 µW input. With the e-peas-
documented ~50 % conversion at high input dropping to ~10 % at
-15 dBm, this is *plausible* at 915 MHz.

> **Correction 2026-05-04** (reviewer-1 EIRP-scenario slip):
> the prior version of this section gave d ≈ 4.0 m at 915 MHz
> and d ≈ 1.5 m at 2.45 GHz from a "20 dBm AP + 2 dBi rx"
> scenario. Reviewer-1 verified those distances actually
> require **32 dBm EIRP (1 W cooperative source like
> Energous)**, not the 22 dBm EIRP a real consumer Wi-Fi AP
> emits. Corrected distances below are for 100 mW Wi-Fi
> (22 dBm EIRP). The report silently switched between
> scenarios; Stage-2 must use the consistent corrected numbers.

Friis at 915 MHz with **22 dBm EIRP** (100 mW conducted +
2 dBi rx):

P_rx[dBm] = 22 - 20·log₁₀(4π·d/λ), λ=327.6 mm at 915 MHz.

For -12 dBm received: 20·log₁₀(4π·d/λ) = 34 dB → **d ≈ 1.31 m**
(corrected from "4.0 m" 2026-05-04). For real-world Wi-Fi
deployments this means the card must be **within ~1.3 m**
of the AP at 915 MHz to harvest enough power for the P2110B
threshold.

**Re-doing for 2.45 GHz** (λ = 122 mm), same -12 dBm threshold:

20·log₁₀(4π·d/λ) = 34 dB → **d ≈ 0.49 m at 2.45 GHz**
(corrected from "1.5 m" 2026-05-04).

The 2.45 GHz penalty is exactly the 8.4 dB of additional FSPL —
which is the Friis-equation core fact. The first-principles
report's "twinkle requires < 2 m" verdict is **confirmed and
sharpened** — at 22 dBm EIRP from 100 mW Wi-Fi, the card needs
to be **within 0.5 m at 2.45 GHz**, not 1.5 m. The "keep card
near AP" use case becomes "card adjacent to AP" — much more
restrictive than the prior text implied.

### 5.2 e-peas table re-check (5 m, 1 W EIRP)

Verified cached e-peas PDF Table 6 (915 MHz, 100 % duty):
0.5 W EIRP → 3.8 µW available average, 5 m distance.
1 W EIRP → 9.6 µW, 5 m.

Friis at 915 MHz, 1 W (30 dBm) EIRP, 2 dBi RX, 5 m:
P_rx = 30 + 2 − 20·log₁₀(4π·5/0.328) = 30 + 2 - 45.7 = -13.7 dBm
= 42.7 µW. Times the e-peas global RF efficiency at -10 to -15 dBm
input (~25 % from their Fig. 2) = 10.7 µW. **Matches their claimed
9.6 µW within ~1 dB**. e-peas's numbers are physics-consistent.

### 5.3 e-peas 2.4 GHz inference

e-peas don't publish 2.4 GHz tables; we extrapolate. Same 5 m, 1 W
EIRP geometry at 2.45 GHz: FSPL is 8.4 dB worse → P_rx = -22.1 dBm
= 6.2 µW. RF→DC efficiency at -22 dBm drops to ~3–5 % per the
Pakkirisami Churchill 2022 MDPI (corrected from "Awad MDPI 2022" 2026-05-04 per reviewer-1) anchor → **0.2–0.3 µW DC**. Drop EIRP to a more
realistic Wi-Fi 100 mW (20 dBm): another 10 dB hit → 0.6 µW
RF input → ~30 nW DC. **Below the BQ25504 130 mV operating
threshold** — i.e. the conventional commercial PMU back-end won't
even start.

### 5.4 Yan et al. 2024 -19 dBm sensitivity → distance

-19 dBm = 12.6 µW received. At 2.45 GHz, 100 mW EIRP, 2 dBi RX:
20·log₁₀(4π·d/0.122) = 41 dB → d ≈ 1.1 m.
With realistic IFA gain -1 dBi: d ≈ 0.6 m.

**Industry SOTA buys roughly 2× the range of a generic
naive-Dickson** — useful, but does not change the order of
magnitude.

### 5.5 Antenova RUFA -1.2 dBi average gain

Verified from Antenova datasheet. Average gain (over the radiation
sphere) of -1.2 dBi vs peak 2.1 dBi tells us that **a textbook
"2 dBi IFA" assumption is optimistic by ~3 dB** for any orientation
that isn't peak-aligned. For a randomly-oriented credit card, use
-1 to 0 dBi as the *practical* gain figure. Adds 3 dB to the FSPL
budget — i.e. halves the usable distance vs the textbook anchor.

### 5.6 FCC 36 dBm vs realistic 22 dBm AP

The FCC ceiling is 36 dBm EIRP (1 W conducted + 6 dBi). Real APs
sit at 22 dBm EIRP. Marketing arithmetic that quotes "1 W APs"
overestimates available power by 14 dB — i.e. ~5× distance, ~25×
power. Trade-press "ambient harvesting from Wi-Fi" claims that
implicitly use the FCC ceiling are off by an order of magnitude
in *power* and a factor of 5 in *distance*.

## 6. References

See [`references.md`](references.md).

## 7. Negative results

1. **No commercial 2.4 GHz-optimised RFEH IC exists with published
   sensitivity better than -20 dBm.** Powercast's flagship is
   915 MHz; their multi-band evaluation board uses generic chipsets
   with off-board matching. e-peas doesn't characterise 2.4 GHz at
   all in the published AppNote.
2. **Atmosic's "RF harvesting" is not an integrated 2.4 GHz
   rectifier.** The Atmosic white paper's worked example is a
   photovoltaic remote control. Their actual contribution is an
   integrated PMU back-end accepting DC from any harvester.
   Trade-press conflation of "BLE SoC + RF harvesting" with
   "BLE SoC that lights itself from ambient Wi-Fi" is misleading.
3. **No open-source Tiny Tapeout RFEH project found.** GitHub
   search for `tinytapeout RF rectifier OR "energy harvest"`
   returned zero hits (2026-05-03). The wafer.space project, if
   shipped, becomes the first or among the first such open-source
   silicon designs in this lineage.
4. **Mainstream 2.4 GHz radio reference designs use 3- to 5-element
   discrete LC PCB matching networks** (Si Labs AN930.2 is the
   canonical example). The "no external passives" constraint of
   our project rules out the entire reference-design library;
   on-die matching becomes mandatory and unconventional.
5. **The TI BQ25504 cold-start floor is 600 mV V_in.** A naïve
   plan of "rectifier → BQ25504 → battery → load" requires the
   rectifier to deliver >600 mV DC just to *start* — well above
   what sub-µW ambient delivers across our antenna. This is why
   commercial RFEH systems use larger antennas, dedicated
   transmitters, or both.
6. **Single-bondwire-ground antenna feeds at 2.4 GHz are
   pathological.** Si Labs AN928.2 (cited from AN930.2) and every
   commercial 2.4 GHz radio reference layout uses tightly-coupled
   ground floods, vias, and multiple ground bonds. A "one signal
   bond, one ground bond" layout will dominate the rectifier's
   input impedance with the bondwire's ~30 Ω inductive reactance.

## 8. Open questions

See [`open-questions.md`](open-questions.md).

## 9. Comparison readiness

| Approach | Headline performance | Area / power cost | Maturity | Best fit for | Worst fit for |
|---|---|---|---|---|---|
| `dickson-naive-nfet` | Fails sub-100 mV input | Trivial | High (NFC) | Strong-source demo | Ambient at -20 dBm |
| `dickson-native-nfet` | -12 to -20 dBm threshold; 5–10 % PCE @ -20 dBm | ~0.005 mm² rectifier + caps | High in lit; few commercial | Single-pin asymmetric drive | Sub-30 mV inputs |
| `dickson-pmos-cross-coupled-differential` | Up to 86 % PCE @ -14 dBm (Kadali 2021) | ~0.01 mm² | High in 180 nm RFEH lit | Differential antenna | Single-pin without balun |
| `villard-half-wave-native` | Lower PCE than 3.A.3 | Smallest | Mature | Single-pin ultra-low-area | Best-in-class sensitivity |
| `dynamic-vth-cancellation` (Kotani aux-bias) | 10–20 % PCE @ -20 dBm | +0.02 mm² | Published, commercial | Best-effort efficiency | Cold-start without aux rail |
| `transformer-coupled` on-die balun | Solves single-pin → differential | 0.06–0.10 mm² | Mature 13.56 MHz, less so 2.4 GHz | Single-pin to differential rectifier | Tight area budget |
| `i-reconfigurable-rectifier` (Yan 2024) | -19 dBm sens, 51 % peak PCE, 24 dB PDR | ~0.05 mm² + digital | Newest, RFIC 2024 | Real-world variable-AP-distance | Minimum-area silicon |
| `i-rectifier+lf-boost` (commercial) | Works to ~600 mV DC threshold | Large external | Highest commercial maturity | Off-chip systems | No-external-passives constraint |
| `i-integrated-pmu-soc` (Atmosic) | Integrates PMU into SoC; not RF-specific | N/A on our die | High (Atmosic) | Combined SoC + harvester | Pure-RFEH demos |
| `i-integrated-rectifier+ble-soc` (Wiliot) | Practical operation needs energizer | N/A | High commercial, opaque internals | Cooperative-source IoT | True ambient |

## 10. Author's notes

Process honesty flags:

- WebFetch failed (HTTP 403/404/418) on direct ETSI EN 300 328 PDF,
  IEEE Xplore (Yan 2024 RFIC, Kadali 2021 IEEE), Mouser product
  pages, PowercastCo PCC110 datasheet PDF, Powercast wp-content
  hosted PDFs, MDPI Sensors PDFs, and the Wiliot blog. Numbers in
  this report sourced from those references are taken from Google
  Scholar abstracts, distributor product summaries, or Wikipedia
  encyclopaedic mirrors — flagged in `references.md` as
  "VERIFICATION PARTIAL" where applicable. Full PDF retrieval and
  caching is the primary outstanding action for the Stage-2
  reviewer.
- The cached PDFs that worked first-attempt: TI BQ25504, e-peas
  AEM30940 RF AppNote, Antenova RUFA, Si Labs AN930.2, Powercast
  P2110B, Powercast P21XXCSR-EVB, Pinuela 2013 (binary integrity
  unverified — first-principles report flagged the same), Atmosic
  Energy Harvesting Advantage white paper (newly cached this session,
  SHA-256 `39acf50f26295cee0fd3fc1e7c74486c79a5ffe0c9893e6fb6f663cf91ae1caa`).
- This survey deliberately avoided merely repeating the
  first-principles report's Friis-derived numbers; instead it
  cross-checks *industry* claims against Friis. The two reports
  agree where physics binds and disagree where industry numbers
  silently assume cooperative sources or FCC-ceiling EIRPs.
- Not surveyed (out of scope or low-yield): patent literature on
  threshold-cancellation tricks (mostly 1990s-2010s UHF RFID, well
  summarised in the IEEE Access 2022 review); MMIC/GaAs Schottky
  rectifier designs (different process family); 5.8 GHz / 24 GHz
  RFEH (different band).