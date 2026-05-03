# Solutions catalogue — industry-survey angle

This file fully enumerates every architecture / topology surveyed for
item (k). Where `report.md` §3 summarised in tables, this file gives
the per-entry plain-language description, where it is currently used,
typical performance, and the failure conditions under which it has
been abandoned. The IDs (C1, A7, S5, T2, B3, ...) are stable across
sister reports so Stage-2 can merge them.

---

## C — Whole-chip commercial BLE SoC references

These are not topologies we will reimplement; they are *baseline
data-points* for what current silicon can do, used to test the
first-principles report's numbers.

### C1 — Nordic nRF52810 (entry BLE-5, 55 nm)
**What it is:** Nordic's mainstream entry-tier BLE-5 SoC: ARM
Cortex-M4F, 192 KB flash, 24 KB RAM, 2.4 GHz multi-protocol radio.
**Datasheet numbers (Mouser-hosted PS v1.4):** TX current 4.6 mA at
0 dBm with DC/DC at 3 V; RX current 4.6 mA; system-OFF current
0.4 µA; supply 1.7–3.6 V; configurable TX power −20…+4 dBm.
**Where it's used:** beacons, BLE peripherals, wearables.
**Failure mode for our project:** 55 nm process, can't be ported to
180 nm without re-architecture. Useful as a current-budget anchor.

### C2 — Nordic nRF52832 (mid-tier BLE-5, 55 nm)
**What it is:** mid-tier Nordic SoC. 512 KB flash, 64 KB RAM,
NFC-A tag, +4 dBm TX max.
**Datasheet numbers:** TX 5.3 mA @ 0 dBm DC/DC 3 V; RX 5.4 mA;
sleep 0.3 µA; supply 1.7–3.6 V.
**Where used:** smart-locks, sensors.
**Failure mode for us:** as C1.

### C3 — Nordic nRF52840 (top-tier multiprotocol, 55 nm)
**What it is:** Nordic flagship 52-series with USB, +8 dBm TX,
802.15.4 (Zigbee/Thread), ARM Cortex-M4F.
**Datasheet numbers (PB v3.0):** TX 6.4 mA @ 0 dBm DC/DC 3 V; RX
4.6 mA; sleep 0.4 µA; supply 1.7–5.5 V; TX −20…+8 dBm.
**Where used:** Thread/Matter dev kits, USB dongles.
**Failure mode for us:** as C1.

### C4 — TI CC2640R2F (BLE-5, 90 nm or 65 nm)
**What it is:** TI's SimpleLink BLE-5 part with ARM Cortex-M3 + RF
core (Cortex-M0). 128 KB flash, 28 KB RAM.
**Datasheet numbers:** TX 6.1 mA @ 0 dBm 3 V; RX 5.9 mA; standby
1 µA; supply 1.8–3.8 V; TX −21…+5 dBm.
**Where used:** TI BLE evaluation kits, automotive (Q1 variant).
**Failure mode for us:** higher current than Nordic, otherwise as C1.

### C5 — ST BlueNRG-LP (BLE-5.3, ≈ 90 nm)
**What it is:** STMicroelectronics' ultra-low-power BLE SoC.
ARM Cortex-M0+. Up to 128 simultaneous connections.
**Datasheet numbers (from ST community Q&A and product brief):**
TX 4.3 mA @ 0 dBm; RX 3.4 mA; sleep 600 nA; supply 1.7–3.6 V; TX
−20…+8 dBm. The lowest mainstream RX current of the surveyed
chips.
**Where used:** wearables, mesh networks.
**Failure mode for us:** as C1.

### C6 — Renesas (Dialog) DA14531 SmartBond TINY (BLE-5.1, 55 nm UL)
**What it is:** physically the smallest BLE chip on the market
(2.0 × 1.7 mm WLCSP). ARM Cortex-M0+, 48 KB ROM, 32 KB RAM.
**Datasheet numbers:** TX ≈ 3.5 mA @ 0 dBm; RX 2.2 mA; hibernation
240 nA (lowest of all surveyed chips); supply 1.1–3.3 V buck/boost.
**Where used:** beacons, smart-tags, IoT modules.
**Failure mode for us:** 55 nm, not transferable; 240 nA hibernation
is the exemplar industry baseline for sleep current.

### C7 — Espressif ESP32-C3 (Wi-Fi + BLE-5, 40 nm)
**What it is:** RISC-V combo Wi-Fi+BLE SoC.
**Datasheet numbers:** BLE-only TX ≈ 12 mA; Wi-Fi+BLE peak 170 mA;
deep-sleep 5–8 µA; supply 3.0–3.6 V; BLE TX −24…+18 dBm; RX 9 mA.
**Where used:** ESP-32 dev boards.
**Failure mode for us:** combo radio with shared front-end optimised
for Wi-Fi sensitivity; BLE-only current is 2–4× higher than pure-BLE
silicon.

### C8 — Atmosic ATM33 / ATM33e (BLE-5.3, 22 nm + on-die RF harvester)
**What it is:** the only commercial BLE SoC explicitly marketed for
"battery-free" operation. ARM Cortex-M33, on-chip RF energy
harvester with MPPT, support for photovoltaic / TEG / motion
harvesting via external interface.
**Datasheet numbers (from Atmosic web):** TX 2.1 mA, RX 0.7 mA,
sleep "down to 240 nA", "off" 35 nA. ATM33e adds the integrated
RF harvester.
**Where used:** Energous WattUp battery-free sensor evaluation kits;
GlobalScale battery-free BLE module.
**Failure mode for us:** 22 nm, not transferable. **The relevant
industry datapoint: even with on-die RF harvester and MPPT, Atmosic's
shipping demo requires a cooperative 1 W RF transmitter at ≤ 1 m.
Pure ambient harvesting is not commercially demonstrated.**

---

## O — Open-source BLE stacks

### O1 — Apache Mynewt NimBLE
**What it is:** Apache 2.0 licensed, full BLE 5.4 host + controller
stack. Controller implements the link layer (LL), HCI, packet
scheduling. Host implements L2CAP, ATT, GAP, GATT, SM. Supports
Nordic nRF51/52/5340 and Renesas DA1469x radios.
**URL:** https://github.com/apache/mynewt-nimble
**Where used:** ESP-IDF (the BLE stack on ESP32), NuttX RTOS,
Mynewt OS, Zephyr.
**Failure mode for us:** the RTL of the *radio* is not part of the
repo (it's HAL'd to the proprietary nRF radio). The *link-layer C
code* (advertising state machine, packet builder, CRC-24, whitening)
is directly portable to HDL for a 180 nm implementation.

### O2 — Zephyr Bluetooth LE Controller
**What it is:** Zephyr Project's Apache 2.0 link-layer-only
controller. Multi-vendor radio HAL.
**URL:** https://docs.zephyrproject.org/latest/connectivity/bluetooth/
**Where used:** Zephyr-based Nordic Connect SDK, others.
**Failure mode for us:** as O1; PHY/radio not in open source.

### O3 — Espressif NimBLE port
**What it is:** ESP-IDF's port of NimBLE host above their
proprietary controller. Apache 2.0.
**Where used:** ESP32 / ESP32-C3 / ESP32-S3 BLE SDK.
**Failure mode for us:** controller is closed; only host is portable.

### O4 — Mbed BLE
**What it is:** ARM Mbed's BLE host stack (Apache 2.0).
**Failure mode for us:** host-only.

### O5 — UW / Wentzloff crystal-less BLE TX firmware
**What it is:** University of Michigan / U-Washington academic
release of a clock-recovery state machine for BLE adverts that
extracts a frequency reference from the GFSK preamble of a co-channel
cooperative transmitter.
**Failure mode for us:** assumes a cooperative transmitter exists in
the same RF environment; for a static-card use case this is unlikely
to apply.

---

## B — Beacon frame formats

### B1 — iBeacon
**Format:** AD-type 0xFF (manufacturer specific data), Apple company
ID 0x004C, 30-byte payload comprising 16 B UUID + 2 B major +
2 B minor + 1 B Tx-power calibration.
**Where used:** Apple-ecosystem proximity beacons.
**Failure mode for us:** requires a phone-side app or shortcut that
recognises specific UUIDs to do anything useful. For the
"scannable business card" UX it adds an indirection layer.

### B2 — Eddystone-UID
**Format:** AD-type 0x16 service data, Service UUID 0xFEAA, 31-byte
payload including 10 B namespace + 6 B instance.
**Where used:** Google's open beacon protocol; Android scanners
recognise it natively.
**Failure mode for us:** namespace+instance is opaque; requires a
phone-side resolver to translate to a vCard.

### B3 — Eddystone-URL  *(strongest candidate for "scan-me vCard")*
**Format:** AD-type 0x16 service data, Service UUID 0xFEAA, frame
type 0x10. Payload: Tx-power + URL prefix (1 B) + URL chars
(up to 17 B). Encoding scheme allows e.g.
`https://wafer.space/c/...` ≤ 17 chars after prefix expansion.
**Where used:** the Google "Physical Web" project (deprecated 2018
but the format is still parseable by Android's nearby-share scanner
and any open-source BLE scanner).
**Failure mode for us:** Chrome no longer auto-prompts the URL on
scan (Physical Web sunset). Still works as a structured payload; a
generic BLE-scanner app can read and resolve it.

### B4 — Eddystone-TLM (telemetry)
**Format:** as B2 but frame type 0x20, carries battery / temperature.
**Failure mode for us:** wrong frame for vCard; potentially useful
as a *side-channel* status broadcast.

### B5 — AltBeacon
**Format:** AD-type 0xFF manufacturer-specific. 28-byte payload:
1 B length + 1 B type + 2 B mfgr ID + 24 B beacon ID. Open
specification (no Apple licensing).
**Where used:** Radius Networks' Android Beacon Library and many
third-party beacons.
**Failure mode for us:** as B1; requires phone-side resolver app.

### B6 — Custom: Eddystone-URL pointing to a hosted vCard
This is *not* a separate format; it's the recommended *use* of B3 for
the wafer.space card. Payload `https://wafer.space/c/<id>` resolves
on the web side to `text/vcard` content. Phone-side parser needs to
recognise either:
  (a) a vCard `Content-Type` and offer "save to contacts" (works on
      iOS and Android out-of-the-box), or
  (b) a `text/x-vcard` link in HTML (works via "share to Contacts").

### B7 — BLE Mesh advertising bearer
**Format:** AD-type 0x2A mesh message; carries provisioning or model
messages within the BLE Mesh stack.
**Failure mode for us:** assumes a Mesh network; overkill for a
static card.

---

## A — PA topologies (2.4 GHz)

### A1 — Class A
**Description:** linear, transistor always conducting.
**Drain efficiency:** ≤ 50 % theoretical, 25–35 % measured at 2.4 GHz
in 180 nm.
**Where used:** WCDMA back-off (rare in BLE).
**Failure mode for us:** wasteful for constant-envelope GFSK.

### A2 — Class AB
**Description:** linear with reduced quiescent current.
**Drain efficiency:** 35–45 %.
**Where used:** OFDM PAs (Wi-Fi).
**Failure mode for us:** linearity unnecessary for GFSK.

### A3 — Class B
**Description:** push-pull pair, each transistor conducts half-cycle.
**Drain efficiency:** 45–55 % theoretical π/4.
**Failure mode for us:** crossover distortion if not biased correctly.

### A4 — Class C
**Description:** transistor conducts < half-cycle; harmonic-rich.
**Drain efficiency:** 50–60 % typical.
**Failure mode for us:** harmonic content needs filtering for FCC PSD
compliance.

### A5 — Class D voltage-mode
**Description:** push-pull NMOS pair switched 180° apart; series LC
resonator selects fundamental.
**Drain efficiency:** 35–45 % at 2.4 GHz / 180 nm (Stauth UCB 2007).
**Failure mode for us:** drain-source capacitance loss is the
dominant inefficiency at 2.4 GHz in bulk CMOS.

### A6 — Class D current-mode
**Description:** half-bridges with shunt LC tank; resonates drain
capacitance.
**Drain efficiency:** 40 % measured at 28 nm (MDPI Sensors 2024).
**Failure mode for us:** transformer combiner usually off-die; not
ideal for our no-passives constraint.

### A7 — Class E  *(default candidate)*
**Description:** single NMOS switch with shunt cap and series LC
network designed for zero-voltage switching.
**Drain efficiency:** 45–57 % measured in 0.18 µm at 2.4 GHz
(Tsai 2009: 55 % @ 21.3 dBm; Mazzanti 2006 TMTT: 57 %; "low-area"
SciDir 2017: 43.5 % PAE differential).
**Where used:** Bluetooth, ZigBee, RFID transmitters.
**Failure mode for us:** load-pull sensitive — performance
degrades quickly if antenna match drifts. Manageable with on-die
matching network.

### A8 — Class E differential w/ on-chip RF transformer
**Description:** two A7 stages 180° apart, combined through an
on-chip 1:1 RF transformer (Metal4 spiral pair).
**Drain efficiency:** 60 %+ measured (Talbi/Ramos 2014 ScienceDirect).
**Where used:** higher-power BLE / Bluetooth-Classic.
**Failure mode for us:** transformer takes 0.2 mm² of Metal4 — large
chunk of die area.

### A9 — Class F / inverse F
**Description:** drain network terminates 2nd harmonic to short and
3rd to open (or vice versa for inverse F), shaping drain waveform
to a square wave.
**Drain efficiency:** 55–61 % measured in CMOS at 2.4 GHz (academia
two-stage Class-F PA).
**Failure mode for us:** harmonic-tuning network is narrowband and
delicate; layout-sensitive.

### A10 — Digital polar / segmented switching PA
**Description:** array of unit-cell PAs, each switched on/off to
realise amplitude modulation; constant-envelope GFSK driven from
PLL.
**Where used:** Liu JSSC 2017 (65 nm, 22.6 % system efficiency at
6 dBm; 14.5 % at 0 dBm).
**Failure mode for us:** unit-cell area cost is large in 180 nm
relative to a single PA stage. Best in deep-submicron.

---

## S — Synthesiser topologies

### S1 — Integer-N LC PLL
**Description:** classical LC-VCO + PFD + charge pump + ÷N divider +
loop filter. Reference XO at 16/32 MHz.
**Power / area:** 3–5 mW at 2.4 GHz BLE-spec; 0.3 mm² in 180 nm.
**Phase noise:** −115 dBc/Hz @ 1 MHz with Q ≈ 10 LC tank.
**Where used:** Razavi textbook reference; many academic BLE radios.
**Failure mode for us:** integer tuning steps need careful frequency
plan to land on BLE channels.

### S2 — Fractional-N LC PLL with ΔΣ modulator
**Description:** S1 with ΔΣ on the divide ratio for fractional
frequency.
**Power:** 4.5 mW @ 65 nm (Tasca JSSC 2011); scales to ~5 mW in
180 nm.
**Phase noise:** comparable to S1; ΔΣ noise pushed out by loop
filter.
**Failure mode for us:** complexity overkill for BLE 1 MHz channel
spacing.

### S3 — Fractional-N ADPLL with TDC
**Description:** all-digital PLL using a TDC for phase comparison
and an LC DCO.
**Power:** 1.6 mW @ 28 nm (Kuo JSSC-2019); estimated 4–6 mW @ 180 nm
(TDC capacitance scales with L²).
**Failure mode for us:** TDC area / power is the bottleneck in
180 nm. ADPLL is shipping in 28/40/65 nm radios but not 180 nm.

### S4 — Free-running ring DCO  *(negative result)*
**Description:** N-stage current-starved ring oscillator at 2.4 GHz.
**Power:** < 1 mW.
**Phase noise:** −75 dBc/Hz @ 1 MHz typical (Hajimiri-Lee).
**Failure mode for us:** **fails BLE adjacent-channel mask by ≈ 10 dB**.
Confirmed by FP report §5.4. No locked-LC alternative beaten by a
free-running ring at 2.4 GHz in any published BLE-compliant chip.

### S5 — Ring DCO + FLL
**Description:** S4 closed by a counter-based frequency-locked loop
to an external reference.
**Power:** ~ 2 mW average.
**Failure mode for us:** still has ring phase noise; **fails BLE
mask**. FLL only corrects long-term drift, not in-band noise.

### S6 — Injection-locked LC oscillator
**Description:** small LC tank with NMOS pair, locked by an injected
sub-harmonic signal.
**Power:** 1.4 mW at 0.9 V supply in 180 nm (Hsieh AICSP 2010).
**Phase noise:** −110 dBc/Hz @ 1 MHz when locked.
**Failure mode for us:** needs an external injection source — likely
the same PLL we are trying to avoid.

### S7 — Two-point LC ADPLL
**Description:** S3 with a two-point modulation path that injects
GFSK both directly into the DCO and into the FCW.
**Power:** 2.9 mW at 65 nm (Vidojkovic ISSCC 2014).
**Failure mode for us:** as S3 in 180 nm; calibration of two-point
gain match is non-trivial.

### S8 — BAW/FBAR-locked oscillator
**Description:** uses a thin-film bulk-acoustic resonator as the
high-Q reference.
**Power:** < 1 mW (Salvia JSSC 2010).
**Failure mode for us:** **off-PDK** — `gf180mcuD` has no BAW.

---

## T — TR-switch architectures

### T1 — Series NMOS
**Description:** single large-W NMOS in the antenna path; ON to
admit, OFF to block.
**IL / Iso @ 2.4 GHz:** 1.5–2 dB / 18–25 dB single-FET in bulk
CMOS.
**Failure mode for us:** isolation marginal vs (d) harvester; OK if
PA never on while harvester active.

### T2 — Series-shunt NMOS  *(recommended)*
**Description:** series FET in the active path + shunt FET to
ground on the inactive port.
**IL / Iso @ 2.4 GHz:** 1.0 dB / 28–35 dB.
**Where used:** Bluetooth Class 1/2 silicon, Wi-Fi front-ends.
**Failure mode for us:** none significant; classical bulk-CMOS
architecture (Talwalkar Stanford 2004).

### T3 — Stacked series NMOS
**Description:** 2–3 NMOS in series sharing OFF voltage.
**IL / Iso:** 1.5 dB / 30 dB.
**Where used:** higher-power transmitters (Class 1 BT, Wi-Fi).
**Failure mode for us:** unnecessary at 0 dBm Pt.

### T4 — Lumped LC SPDT
**Description:** uses series and shunt LC sections instead of FETs;
near-zero IL but narrowband.
**Where used:** automotive radar 24 GHz / 77 GHz.
**Failure mode for us:** large area for L's at 2.4 GHz; doesn't help
IL much over T2.

### T5 — PD-SOI antenna switch  *(off-PDK)*
**Description:** SOI substrate gives high body resistance, low
parasitic capacitance.
**IL / Iso:** 0.7 dB / 50 dB at 2.4 GHz.
**Failure mode for us:** **`gf180mcuD` is bulk; T5 not available.**

### T6 — λ/4-line + shunt
**Description:** distributed quarter-wave line + shunt-FET to
ground; standard low-loss 5+ GHz topology.
**IL / Iso:** 0.5 dB / 35 dB.
**Failure mode for us:** λ/4 at 2.4 GHz = 31 mm — does not fit
on-die.

---

## N — Antenna-sharing architectures

### N1 — Hard time-mux via SPDT TR-switch  *(default)*
On-die SPDT (T1 or T2) selects (d) harvester or (k) BLE PA.

### N2 — Frequency-domain split (diplexer)
Both (d) and (k) target 2.4 GHz; no useful frequency separation
exists. Rejected.

### N3 — Two PCB antennas
Disallowed by TODO.md — PCB has only one IFA.

### N4 — Reactive co-existence
PA OFF presents reactance to harvester input; harvester continues
to receive while PA is dormant. Possible but requires careful
match design; default fallback if T2 isolation is inadequate.

---

## R — RX / TX architecture

### R0 — TX-only, non-connectable adverts
**Description:** card never receives; only sends ADV_NONCONN_IND
packets. No LNA, no demod, no link-layer connection state.
**Failure mode for us:** no scan-response, less interactive UX.

### R1 — TX + scan-response
**Description:** card listens briefly after each advert for
SCAN_REQ; if heard, sends SCAN_RSP with extended payload (e.g. full
vCard).
**Failure mode for us:** adds an LNA + demod at large power cost.

### R2 — Full peripheral with connection state
**Description:** card supports CONNECT_REQ and a full GATT server.
**Failure mode for us:** rejected on power; needs MCU + RAM that
the wafer.space form factor can't supply.

### R3 — TX + on-channel back-channel WRX
**Description:** Wentzloff 2020 ISSCC 30.7 architecture with a
−86 dBm wake-up RX in the same channel.
**Failure mode for us:** exotic; depends on a cooperative TX in
the environment.

---

## P — Privacy / addressing

### P1 — Static public address  *(default)*
**Description:** card's BD_ADDR is fixed at fab (eFuse-programmed).
**Failure mode for us:** no privacy. Acceptable for a public
business card.

### P2 — Static random address
**Description:** random-but-stable; chosen at fab via eFuse.
**Failure mode for us:** indistinguishable from P1 for our use case.

### P3 — Resolvable Private Address (RPA)
**Description:** BLE 5 privacy mechanism that rotates the address
every ~15 min; only paired devices with the IRK can resolve.
**Failure mode for us:** **breaks the "passive scan-me" UX**;
a phone that hasn't pre-paired with the card can't cluster adverts
as "same card". Reject.

---

## Modulator paths

### M1 — Two-point GFSK modulator (around an ADPLL or fractional-N PLL)
Direct DCO injection (high-pass) + FCW addition (low-pass).
Industry default for digital BLE TX.

### M2 — Closed-loop modulation (FCW only)
Only injects modulation into the divider; loop bandwidth must
exceed modulation bandwidth. Largely abandoned.

### M3 — Open-loop post-lock modulation
PLL locks then opens; DCO modulated directly. Drift is the
failure mode.

### M4 — ADPLL FCW direct
Bit stream added to integer FCW; loop attenuates high-frequency
components. Spectral mask compliance hard.
