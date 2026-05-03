# Solutions catalogue (item c, Stage 1 industry-survey)

8 topology families across three orthogonal axes: 5 rectifier
topologies × 3 regulator topologies × 3 protocol-participation
levels. Plus 3 system-architecture variants beyond the axes.

## Axis A — Rectifier topology

| ID | Topology | Industry anchor | Verdict for our process |
|---|---|---|---|
| A1 | Passive full-wave diode bridge | Vinod-Tanur ATtiny13A free-rider (Schottky 1N5819-class); PCH design guide | **Degenerates to A4** — no Schottky in `gf180mcuD` |
| A2 | Voltage-doubler / Greinacher / Cockcroft-Walton | UHF-RFID literature | **Not used in any commercial Qi receiver IC** — wrong tool when V_pk is already several volts at 100 kHz |
| A3 | Full-wave synchronous rectifier | bq51013B ("low-resistance synchronous"), bq51003, bq51221 ("96 % efficiency"), P9221-R, STWLC38 | **Industry standard above ~1 W** |
| A4 | Diode-connected MOSFET bridge | RFID and biomedical-implant rectifiers | **Not used** in commercial Qi |
| A5 | Hybrid: cross-coupled NMOS + comparator-driven PMOS with adaptive delay compensation | P9221-R3 family | Sophisticated; suits high-Q coils |

## Axis B — Regulator topology

| ID | Topology | Industry anchor | Verdict |
|---|---|---|---|
| B1 | LDO from V_rect to harvested rail | Every TI bq510xx receiver | **Native fit** for our requirements |
| B2 | Switching converter (post-rectifier buck/boost) | All high-power (15 W+) Qi receivers | **Forbidden for us** — off-die inductors not allowed |
| B3 | Adjustable V_rect via load modulation back to TX | bq51013B "Dynamic Rectifier Control" | Requires **full** WPC v1.x communication stack |

## Axis C — System architecture / protocol participation

| ID | Architecture | Anchor | Gates / effort | Verdict |
|---|---|---|---|---|
| C1 | Full WPC-compliant receiver | Every commercial Qi receiver IC | ~3000 gates digital + modulator + demodulator + state machine | Plausible but expensive in design effort |
| C2 | Free-rider (partial WPC compliance) | Vinod-Tanur ATtiny13A receiver | ~500 gates, no demodulator | **Strong fit for our v2** |
| C3 | Pure free-rider — no WPC packets at all ("ping snatcher") | n/a (open-source / academic only) | Just rectifier + brown-out + storage cap | **Lowest-effort option**; acceptable if avg power < FOD pre-transfer threshold |

## System-architecture variants beyond axes

| ID | Variant | Anchor | Verdict |
|---|---|---|---|
| V1 | Shared NFC + Qi single-coil | ROHM ML7630/7631; Würth WE-WPCC combination coils | **Inadvisable** — Petzel thesis documents NFC-IC failures under Qi-class fields |
| V2 | Independent NFC + Qi front-ends (two coils, two pad pairs) | *De-facto* commercial architecture | **Companion PCB design** |
| V3 | Multi-mode Qi receiver (BPP + EPP + 2 MPP + PMA) | TI bq51221 dual-mode WPC + PMA | Out-of-scope for our v2 |

## Stage-2 / Stage-3 handoff

The shortlist for Stage-2 gap analysis from the industry-survey
angle:

- **A3 + B1 + C2 (sync bridge LDO free-rider)** — closest match to
  our v2 chip's constraints; documented working in [O1] open-
  source receiver. Most-likely-flow label.
- **A4 + B1 + C2 (diode-MOS bridge LDO free-rider)** — bring-up /
  silicon-test mode; smallest analog footprint.
- **A3 + B1 + C3 (sync bridge LDO ping-snatcher)** — worst-case
  fallback if free-rider protocol fails on a target Qi pad.

## Discarded approaches (industry-survey-specific)

- **A2 voltage-doubler** — wrong tool for 100 kHz Qi power levels.
- **B2 switching converter** — needs off-die inductor; forbidden.
- **B3 adjustable V_rect via WPC comm** — requires full v1.x stack.
- **V1 shared NFC + Qi single-coil** — Petzel thesis hazard.
- **V3 PMA standalone** — A4WP / PMA dead standards; bq51221 EOL.
