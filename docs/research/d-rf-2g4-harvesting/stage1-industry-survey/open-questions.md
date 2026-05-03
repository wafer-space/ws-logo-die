# Open questions — item (d) industry-survey angle

Each question below names the downstream decision that depends on
it and a guess at how it would be settled.

## Q1. What is the *measured* sensitivity of the Powercast PCC110 chipset specifically at 2.45 GHz (vs the 915 MHz P2110B)?

- **Why it matters:** PCC110 is the closest commercial precedent to
  what we're building (a generic RF-to-DC chip tunable per band).
  If its 2.45 GHz sensitivity is documented at, say, -8 dBm (as
  trade press sometimes claims), our -19 dBm Yan 2024 reference is
  11 dB better — useful but not transformative. If PCC110 hits
  -16 dBm at 2.45 GHz, we have less competitive headroom.
- **How to settle:** Mirror the actual PCC110 datasheet from
  Powercast (currently I had no direct WebFetch success — the
  PowercastCo wp-content links 404 and Mouser timed out). Stage-2
  reviewer should retry, possibly via a distributor with the PDF
  hosted in cache.
- **Decision driver for:** Stage-3 shortlisting between
  `i-reconfigurable-rectifier` (Yan 2024) and `i-rectifier+lf-boost`
  (PCC110-class); in particular whether the project should target
  parity with commercial silicon or accept worse performance.

## Q2. What is the Wiliot IoT Pixel's *measured* sensitivity from a typical Wi-Fi AP, separate from a cooperating Wiliot energizer?

- **Why it matters:** Wiliot is the only public commercial 2.4 GHz
  RFEH-powered BLE chip; if its real-world ambient sensitivity
  (without an energizer) is -25 to -30 dBm, that's the bar we
  should aim at. If it's not measurable without an energizer,
  the project's "twinkle on ambient" goal must formally relax to
  "twinkle when near a known cooperating source".
- **How to settle:** FCC test report for the Wiliot pixel (the
  filing should include conducted-emission tests over a frequency
  sweep that imply harvester operating thresholds). Independent
  measurement reports from third parties (academic literature
  has cited several Wiliot benchmarks).
- **Decision driver for:** Project marketing-vs-engineering
  honesty calibration; Stage-3 selection of operating mode
  `mode-cooperative-source` vs `mode-true-ambient`.

## Q3. Does the cross-coupled differential rectifier (Yan 2024 / Pakkirisami Churchill 2022 (corrected from "Awad 2022" 2026-05-04 per reviewer-1) / Kadali 2021 family) require a true differential antenna, or can a single-pin antenna feed a 2.4 GHz on-die transformer with sufficient Q to run the differential rectifier?

- **Why it matters:** The card's PCB IFA is single-ended; if we
  must use the cross-coupled differential rectifier (best PCE),
  we need an on-die transformer. On-die 2.4 GHz transformers in
  180 nm typically have Q ~5–8 and 2–3× voltage gain — but with
  insertion loss 1–3 dB. A 3 dB loss at the antenna interface
  costs us 3 dB of effective sensitivity, partially erasing the
  benefit of the better rectifier topology.
- **How to settle:** Spice + EM co-simulation of an on-die
  transformer in `gf180mcuD` metal stack. Cross-check with at
  least one published 180 nm CMOS transformer-balun design at
  2.4 GHz.
- **Decision driver for:** §3.A topology selection; Stage-3
  shortlist composition.

## Q4. What is the *practical* cold-start voltage required by an on-die SC charge pump in the 1–10 µW input regime?

- **Why it matters:** Yan 2024 quotes 51 % peak PCE but does not
  fully publish a cold-start curve. The TI BQ25504 cold-start at
  600 mV (commercial floor) sets industry expectation. Our on-die
  SC charge pump replaces BQ25504; if the SC pump itself needs
  300 mV V_in to start, we need the rectifier to deliver that
  before any LED current. At -22 dBm (5 m, 100 mW EIRP) and 5 %
  PCE, rectifier output across a high-Z load is closer to
  100–200 mV — borderline.
- **How to settle:** Spice corner sims of a 3-stage SC pump in
  `gf180mcuD`; literature on cold-start charge pumps under µW
  inputs (Goeppert et al., Stanyard et al. are standard
  references).
- **Decision driver for:** Whether the project needs a cooperating
  bring-up event (NFC or Qi pre-charging the storage cap once,
  then ambient holds it) vs pure-ambient cold-start.

## Q5. How much area does an on-die 4-element matching network at 2.4 GHz cost in `gf180mcuD`?

- **Why it matters:** The Si Labs AN930.2-class matching network
  (3- to 5-element LC) sets the commercial expectation for a
  proper 2.4 GHz match. On-die spiral inductors at 5–10 nH and
  Q ~5–8 cost 0.05–0.15 mm² each; a 4-element match could
  consume 0.3 mm² — a meaningful slice of the die budget. Could
  also conflict with the wafer.space-logo top-metal constraint.
- **How to settle:** Floor-plan exploration in LibreLane;
  inductor extraction from the GF180MCU PDK; conflict check vs
  the existing `big_logo` mask layers.
- **Decision driver for:** Stage-2 area budgeting and
  floor-planning trade-off.

## Q6. Is there a published ISSCC / JSSC / RFIC measurement of a 2.4 GHz RFEH chip *integrated* with an LED driver (i.e. end-to-end "ambient RF to LED flash") with a measurement protocol that we can replicate?

- **Why it matters:** Several RFEH papers measure DC output into a
  resistive load; far fewer measure end-to-end LED visibility.
  An end-to-end measurement at known distance from a known AP
  would be the gold-standard validation target for our Stage-6
  comparison.
- **How to settle:** Targeted search of ISSCC / IEEE JSSC /
  RFIC Symposium 2018–2026 with keywords "ambient RF" + "LED" +
  "battery-free" + "2.4 GHz". Belongs to the parallel academic
  survey angle, not industry.
- **Decision driver for:** Stage-6 acceptance test design;
  honest demo-day numbers.

## Q7. What is the cost (in mm² and design-time) of including an MPPT controller for §3.A.7 reconfigurable rectifier vs running a fixed configuration tuned for the *expected* operating distance?

- **Why it matters:** MPPT adds digital area and quiescent
  power; if the card's expected use case is binary
  ("on someone's desk near a router" vs "in a pocket far from
  any AP"), a fixed configuration tuned for the desk case may
  be sufficient and ~2× simpler.
- **How to settle:** Architecture sketch + area estimate for the
  smallest viable MPPT (e.g. 4-state RSSI-driven config select);
  compare to fixed-config area.
- **Decision driver for:** Stage-3 shortlist scoping.

## Q8. Is the Antenova RUFA's -1.2 dBi *average* gain a fair model for the PCB IFA, or will the IFA's larger area give it +1 to +2 dBi average?

- **Why it matters:** A 3 dB swing in average antenna gain is a
  factor of √2 in usable distance. Antenova RUFA is a 12.8 mm
  chip antenna; the PCB IFA is 6 × 10 mm of trace plus the
  ground-plane keep-out. Without an EM simulation we do not
  know whether the PCB IFA is better or worse than a chip
  antenna at integrating over the full radiation sphere.
- **How to settle:** EM co-simulation of the actual PCB IFA
  geometry against the RUFA reference antenna pattern.
  Cross-check with the PCB sub-project's antenna designer.
- **Decision driver for:** Stage-2 sizing of "expected harvest
  power at d=1 m" — i.e. the headline marketing claim.