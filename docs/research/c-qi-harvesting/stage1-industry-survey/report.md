---
item: c
item_name: qi-harvesting
stage: 1
angle: industry-survey
researcher: claude-opus-4-7-1m (Stage-1 industry-survey, instance 1 of 3)
status: in-review
last-updated: 2026-05-03
---

## 1. Executive summary

This report surveys commercial / industrial silicon and the
publicly available Qi specifications for what they reveal about
how a Qi power receiver is built.

Sources canvassed: Qi Power Class 0 specification v1.2.3 (full
PDF), Qi v1.3 introduction (publicly available portion), TI
bq51013B / bq51003 / bq51050B / bq51221 datasheets, IDT/Renesas
P9221-R datasheet, ST STWLC38, Infineon WLC1115 (transmitter,
surveyed for context), Infineon AN234970 FOD tuning guide, NXP
MWCT1xxx app-notes (AN5075 + AN4937 surveyed), the Petzel
master's thesis on Qi/NFC coexistence (TU Graz, 2020, in
cooperation with NXP), the Wireless Power Wiki, the WPC web
pages, the open-source ATtiny13A free-rider receiver by Vinod S.
Tanur.

**Topology families catalogued: 8** across three orthogonal axes:
- A: 5 rectifier topologies (passive-bridge, voltage-doubler,
  full-synchronous, diode-MOS bridge, hybrid-fast-comparator)
- B: 3 regulator topologies (LDO, switching, CEP-controlled Vrect)
- C: 3 protocol-participation levels (compliant SoC, MCU-driven
  free-rider, silent ping-snatcher)

Headline observations:

- **Free-riding is documented to work in practice**: the Vinod-
  Tanur ATtiny13A receiver and the Hackaday write-up demonstrate
  that a *partial* WPC v1 protocol stack is sufficient to extract
  several watts from a commodity Qi pad. **Full FOD compliance
  is *not* required for the TX to keep applying its Power Signal
  — but silence past the WPC v1.x "first packet within 1.6 s of
  Digital Ping" watchdog is a hard timeout that *will* shut the
  pad off.**
- **A truly silent receiver is also a valid mode**: if the Rx
  loads the pad below the analog-ping detection threshold and
  never replies, the TX simply removes the Power Signal within
  ~90 ms (analog ping duration) and goes back to selection. This
  is "harvest the ping pulse only" mode — sub-mJ per ping at
  0.4 s cadence.
- **FOD trip thresholds are surprisingly generous.** Infineon
  AN234970 ships its WLC ICs with a default *first-strike* BPP
  power-loss threshold of **325 mW**, with a hard-latch threshold
  of **1000 mW**. The PCH design guide quotes the WPC certification
  numbers as **350 mW BPP / 750 mW EPP**.
- **Shared NFC+Qi front-end is mature** (Würth WE-WPCC combination
  coils, ROHM ML7630/7631 NFC-charging IC) — but the Petzel thesis
  is unambiguous that *uncontrolled* exposure of an NFC tag to a
  Qi field can destroy it via either over-voltage (limiter pulled
  past clamp) or over-current (limiter pulled into latch-up). For
  our chip the NFC and Qi rails *must* be independent enough that
  a Qi-induced AC voltage on the NFC pads cannot back-feed past
  the NFC clamp.

## 2. Requirements as understood

(See sister `stage1-first-principles/report.md` §2.)

## 3. Solution-space map

### Axis A — Rectifier topology

- **A1. Passive full-wave diode bridge.** Vinod-Tanur ATtiny13A
  free-rider uses Schottky bridge (1N5819-class). PCH design guide
  shows passive bridge in block diagrams. **In our process
  degenerates to A4** (no Schottky in `gf180mcuD`).
- **A2. Voltage-doubler / Greinacher / Cockcroft-Walton.** Standard
  for 2.4 GHz / UHF RFID. **Not used in any commercial Qi receiver
  IC** the survey found — wrong tool when V_pk is already several
  volts.
- **A3. Full-wave synchronous rectifier.** Used by **every
  commercial high-power Qi receiver IC**: bq51013B
  ("low-resistance synchronous rectifier"), bq51003, bq51221
  ("Fully Synchronous Rectifier With 96 % Efficiency"), P9221-R,
  STWLC38. Industry standard above ~1 W.
- **A4. Diode-connected MOSFET bridge.** Surface-of-die "passive
  front-end" of various non-Qi RFID and biomedical-implant
  rectifiers. **Not used** in commercial Qi.
- **A5. Hybrid: cross-coupled NMOS + comparator-driven PMOS with
  adaptive delay compensation.** P9221-R3 family.

### Axis B — Regulator topology

- **B1. LDO from Vrect to harvested rail.** Every TI bq510xx
  receiver. **Native fit** for our requirements.
- **B2. Switching converter.** All high-power (15 W+) commercial
  Qi receivers integrate post-regulation switchers. **Forbidden
  for us** (off-die inductors not allowed).
- **B3. Adjustable Vrect via load modulation back to the TX.**
  bq51013B's "Dynamic Rectifier Control". Requires *full* WPC v1.x
  comm.

### Axis C — System architecture / protocol participation

- **C1. Full WPC-compliant receiver.** Every commercial Qi
  receiver IC. ~3000 gates digital + modulator + demodulator +
  state machine. Plausible but expensive in design effort.
- **C2. Free-rider** — partial WPC compliance ("just enough to
  keep TX awake"). The Vinod-Tanur ATtiny13A receiver. **~500
  gates**, no demodulator. **Strong fit.**
- **C3. Pure free-rider** — no WPC packets at all ("ping
  snatcher"). Just rectifier + brown-out detector + storage cap.
  **Lowest-effort option.** Acceptable if average power < FOD
  pre-power-transfer threshold.

### Architectural variants beyond the three axes

- **V1. Shared NFC + Qi single-coil.** ROHM ML7630/7631; Würth
  WE-WPCC combination coils. Petzel thesis documents NFC ICs
  failing under Qi-class fields. **Inadvisable** — the companion
  PCB *deliberately* puts NFC and Qi on different inner layers.
- **V2. Independent NFC + Qi front-ends (two coils, two pad
  pairs).** *De-facto* commercial architecture. **What our
  companion PCB implements.**
- **V3. Multi-mode receiver** (Qi BPP + Qi EPP + Qi 2 MPP + PMA).
  TI bq51221 dual-mode WPC + PMA. Probably out-of-scope for our
  v2.

## 4. Sub-block breakdown

(See sister `stage1-first-principles/components.md`.)

## 5. First-principles sanity checks

(See sister `stage1-first-principles/report.md` §5.)

Industry-survey-specific cross-checks:

- bq51013B's claimed 93 % AC-DC efficiency at 5 W → 200 mW shunt
  + 250 mW R_DS(on) loss = within ~30 % of claim. Plausible.
- P9221-R3 87 % overall DC-DC efficiency at 9 V/12 V output —
  consistent with switched buck post-regulator.

## 6. References

| ID | Citation | Verification | Cache |
|---|---|---|---|
| W2 (Qi PC0 v1.2.3) | WPC, full PDF | VERIFIED 2026-05-02 | references-cache/wpc-qi-pc0-v1.2.3a/ |
| W1 (Qi v1.3 Introduction) | WPC, January 2021 | VERIFIED 2026-05-02 | references-cache/wpc-qi-v13-intro/ |
| D1 (TI bq51013B SLUSC65A) | TI datasheet, Sep 2018 | VERIFIED 2026-05-02 | references-cache/ti-bq51013b-ds/ |
| D2 (IDT P9221-R) | IDT/Renesas datasheet | VERIFIED 2026-05-02 | references-cache/idt-p9221-r-ds/ |
| D4 (TI bq51050B) | TI datasheet | VERIFIED 2026-05-02 | references-cache/ti-bq51050b-ds/ |
| D5 (ST STWLC38) | ST data brief | TIMEOUT — needs re-fetch | n/a |
| D7 (TI bq500412 transmitter) | TI datasheet | snippet only — flagged | n/a |
| W3 (Infineon AN234970 FOD) | Infineon, 2023-02-06 | VERIFIED 2026-05-02 | references-cache/infineon-fod-tuning/ |
| W4 (NXP AN5075 / AN4937) | NXP wireless-charging app notes | snippets only — flagged | n/a |
| W5 (ROHM ML7630/31) | rohm.com/lapis-tech | snippet only | n/a |
| W6 (Würth WE-WPCC) | we-online.com | snippet only | n/a |
| W7 (Hackaday Qi DIY) | hackaday.com 2019-04-11 | snippet only | n/a |
| W8 (PCH design guide) | pchintl.com | VERIFIED 2026-05-02 | references-cache/pch-design-guide/ |
| W12 (Wireless Power Wiki FOD) | wirelesspowerwiki.com | VERIFIED 2026-05-02 | n/a |
| A1 (Lee & Mok 2012) | IEEE TBioCAS active rectifier | snippet | n/a |
| A2 (Lu & Ki 2014) | JSSC adaptive delay-comp | snippet | n/a |
| A3 (Cha et al. 2018/2021) | MDPI Energies | snippet | n/a |
| A4 (Petzel 2020 TU Graz) | MSc thesis NFC/Qi coexistence | VERIFIED 2026-05-02 | references-cache/petzel-2018-thesis/ |
| O1 (Vinod-Tanur ATtiny13A) | github.com/vinodstanur/qi_wireless_receiver_attiny13 | VERIFIED 2026-05-02 | n/a |

## 7. Negative results

### N1. Voltage-doubler / Dickson stages are *not* useful at 100 kHz Qi power levels

Wasted voltage when input AC swing is already 7+ V_pk. None of
the surveyed commercial Qi receiver ICs use a multiplier.

### N2. Shared NFC + Qi single-coil architecture

Petzel thesis documents end-to-end that uncontrolled NFC-tag IC
exposure to a Qi field puts limiter currents in the hundreds of
mA range — multiple times the IC's absolute-maximum spec.
*Discarded for our project.*

### N3. Qi 2 MPP-mode authentication

Stage-2 should explore whether MPP-mode pads will fall back to
BPP for unauthenticated receivers — anecdotally yes, but the
Apple MagSafe spec proper is members-only.

### N4. PMA standalone receiver

A4WP / PMA are dead standards. Even bq51221 (which advertises
both Qi v1.1 and PMA) is end-of-life on the TI product portal.

### N5. On-die LC tank

LC-tank-style RF filtering is industry-standard at 13.56 MHz NFC
where the inductor is small (a few nH); at 100 kHz the inductor
would be hundreds of µH and area-prohibitive.

## 8. Open questions

1. **Q-factor of our 8-turn 56 × 40 mm Qi coil on the L3 inner
   copper, with adjacent NFC perimeter spiral on L2, *no* ferrite
   shielding** — currently un-quantified.
2. **What is the *minimum* WPC-v1 packet sequence that keeps a
   *representative* set of commercial Qi pads in Power Transfer
   phase?**
3. **Does the bq51013B's "Adaptive Communication Limit" feature
   imply that *our* on-die capacitive-load-modulator must support
   ≥100 mA peak?**
4. **Will Qi 2 MPP-only pads fall back to BPP when the Rx fails
   authentication?**
5. **Is the analog-ping current threshold low enough for a small
   PCB coil to be detected without any compliance-protocol
   participation at all?** Decides viability of C3 "ping snatcher".
6. **What is the realistic on-die MIM cap area available** given
   the logo-on-all-metal floorplan constraint?

## 9. Comparison readiness

| Approach (axis-tuple) | Headline | Area / power | Maturity | Best fit | Worst fit |
|---|---|---|---|---|---|
| A1 + B1 + C1 (pass-bridge LDO compliant) | Hard without Schottky in GF180; degenerates to A4 | Smallest digital, large dropout loss | Low (no GF180 reference) | sanity check only | Below 1 V V_F-budget loads |
| A3 + B1 + C1 (sync bridge LDO compliant) | 90 %+ AC-DC; standard industry | Largest digital block | High (every commercial Rx) | A future v3 chip with full WPC stack | Tight digital-area v2 |
| A3 + B1 + C2 (sync bridge LDO free-rider) | ~85 %+ AC-DC, simple; documented working in [O1] | Moderate digital (~500 gates) | Medium (DIY-grade) | **Our v2 chip's most-likely flow** | Qi 2 MPP-only TXs |
| A3 + B1 + C3 (sync bridge LDO ping-snatcher) | Marginal — pings only | Smallest of all | Low | Worst-case fallback | Sustained-load mode |
| A4 + B1 + C2 (diode-MOS bridge LDO free-rider) | ~70 %+ AC-DC; very simple | Smallest analog | Medium (academic) | Bring-up / silicon test | Production-quality |
| A5 + B1 + C1 (adaptive sync + LDO) | 95 %+ AC-DC; sophisticated | Largest analog | Medium-High | Future high-power harvester | µW–mW load |
| A3 + B3 + C1 (sync bridge + Vrect-tracking + compliant) | 95 %+ overall; the bq51013B path | Large digital + analog | High | Phone-class loads | Our budget |
| V1 — shared NFC/Qi coil | Reduces pad count by 2 | Shared analog mux | Low (academic, painful) | Future single-coil PCB rev | Current PCB; safety |
| V2 — separate NFC/Qi coils on different inner layers | Industry default | + 2 pads per radio | High | Our companion PCB | Single-board cost focus |

## 10. Author's notes

- **Search limits.** Industry-survey scope was limited to: WPC
  spec docs, the five canonical RX-IC vendor lines (TI, IDT/
  Renesas, ST, Infineon/Cypress, NXP), one Korean entrant (ROHM),
  and the open-source DIY corner.
- **PDF-fetch friction.** WebFetch on PDF URLs returns binary that
  the model can't parse; in this pass I cached eight PDFs locally
  and ran `pdftotext` on each. Future researchers should use the
  cached `.txt` extracts.
- **The Petzel thesis [A4] is the single most useful document of
  the survey.** Its §3.6.4 specifically quantifies what happens to
  an NFC-card IC under Qi-class fields, with closed-form formulas
  for both the over-voltage and the over-current case.

## Three things others may miss

1. **Pre-power-transfer FOD is a PCB problem, not a chip problem.**
   It is Q-factor-based and only depends on the inductor + tuning
   cap on the PCB, not on the receiver IC's behaviour. We can pass
   or fail it without writing any HDL.
2. **The Qi spec's 20 V Vrect guarantee does not apply to non-
   compliant receivers.** Worst-case open-circuit AC swing on a
   partly-resonant secondary can exceed 300 V_pk; a hard analog
   clamp at the AC pads is non-optional for any free-rider design.
3. **The bq51013B CLAMP1/CLAMP2 reference circuit is not directly
   reusable** — it relies on an external 0.47 µF cap that our
   no-external-passives rule forbids. Our equivalent must be a
   closed-loop on-die clamp.
