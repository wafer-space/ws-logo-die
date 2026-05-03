# Open questions - academic-survey angle

Questions where the peer-reviewed silicon record is silent or
ambiguous, and where a downstream Stage-2/3/4 effort needs to make
explicit assumptions or run a measurement to settle.

## 1. Is there any 180 nm bulk-CMOS BLE-compliant TX in the
peer-reviewed silicon record that this survey missed?

- **Why it matters**: if such a paper exists, it provides a
  process-anchor for sub-block numbers and de-risks the
  "process-first-of-kind" caveat in this report.
- **What would settle it**: a Stage-2 reviewer agent specifically
  searching JSSC / IEEE TMTT / IEEE TCAS / A-SSCC 2010-2024 with
  `(BLE OR "Bluetooth Low Energy") AND ("0.18 um" OR "180 nm" OR
  "180-nm")` in title and abstract, plus a check of TSMC's own
  white papers for 180 nm BLE process anchors.
- **Default assumption**: no such paper exists; any 180 nm BLE TX
  is process-first-of-kind.

## 2. What is the actual measured Q of a 5 nH spiral on
`gf180mcuD` Metal4 at 2.4 GHz?

- **Why it matters**: phase-noise scales as 1/Q^2; Metal4 vs
  Metal5 difference between Q ~ 12 and Q ~ 8 is 3.5 dB of phase
  noise.  Margin to the BLE mask depends critically on this.
- **What would settle it**: a small spiral test-structure on the
  v2 die (or a Sonnet / EMX EM-simulation against the gf180mcuD
  PDK Metal4 stack-up).
- **Default assumption**: Q ~ 8 at 2.4 GHz on Metal4.

## 3. Is the negative-V_GS leakage-gating technique (Paidimarri
JSSC 2016) reproducible at 180 nm without a 5x sleep-power
penalty?

- **Why it matters**: the harvested-rail BLE TX needs sleep
  current < 100 nA to support 100-ms-interval adverts on the
  ambient harvester.  Paidimarri's 65 nm 370 pW does not directly
  port; the published silicon record contains no 180 nm
  reproduction.
- **What would settle it**: a Spice sim of the negative-V_GS
  bias generator + RF transistor stack in `gf180mcuD` nfet_06v0,
  worst-case corners.
- **Default assumption**: 30-100 nW sleep at 180 nm with negative-
  V_GS; 1 uA without.

## 4. Can a trimmed on-die RC + FLL achieve BLE +/- 50 ppm
carrier accuracy without an XTAL or BAW?

- **Why it matters**: standalone XTAL-less BLE is the *only* path
  for `ws-logo-die`'s no-external-passives constraint.  No
  measured silicon does this without a cooperative co-channel
  reference (Wentzloff's technique) or a BAW (Salvia / Lee /
  Selvakumar).
- **What would settle it**: a thermal-coefficient-trimmed RC + FLL
  reference paper search; if none exists, a Spice + Monte-Carlo
  characterisation of the trimmed RC vs PVT on `gf180mcuD`.
- **Default assumption**: +/- 50 ppm is **not achievable** with
  on-die RC + FLL alone; standalone XTAL-less BLE in 180 nm fails
  carrier accuracy.

## 5. What is the actual energy-per-bit floor in 180 nm at 0 dBm
GFSK?

- **Why it matters**: extrapolating from 28 nm 4 nJ/bit gives
  6-16 nJ/bit at 180 nm, a 2.5x range.  The advert-event energy
  budget (uJ-class) depends on which end of that range is
  realistic.
- **What would settle it**: full Spice + EM cosim of the synth +
  PA + buffer chain in `gf180mcuD` against a measurable target.
- **Default assumption**: 6-8 nJ/bit (conservative-medium).

## 6. Does the Roy ISSCC 2018 burst-mode TX architecture provide
a viable *sub-BLE-compliant* fallback?

- **Why it matters**: if true BLE compliance is silicon-physically
  infeasible at our power budget, a non-BLE 2.4 GHz beacon
  (proprietary advertising bearer + custom phone app) might still
  achieve the "scan-me business card" UX at 1/10th the radio
  power.
- **What would settle it**: a pass over the Bluetooth-SIG
  proprietary advertising bearer rules and the FCC PSD limits to
  see whether a wider-beam, narrower-channel non-GFSK beacon
  would fit the regulatory envelope.
- **Default assumption**: BLE-compliant or nothing; this question
  is for Stage-2 to escalate.

## 7. Are there any *published* harvested-RF + BLE silicon
demonstrations that don't depend on a 1 W cooperative power-bridge?

- **Why it matters**: the 20 dB ambient-harvesting gap is the
  killer for (k).  If any peer-reviewed paper bridges this gap
  with a clever architectural choice (e.g. hyper-aggressive
  leakage gating + 30 s advert intervals + 100x more efficient
  PA), it would change the verdict.
- **What would settle it**: a search of JSSC 2018-2024 + Imec /
  Holst / CEA-Leti recent publications for "ambient" + "BLE" +
  "TX" without "WattUp" / "PowerBridge" / "cooperative".
- **Default assumption**: no such paper exists; the 20 dB gap is
  silicon-confirmed.

## 8. Is the Apache NimBLE link-layer FSM portable to
`gf180mcuD` HDL synthesis?

- **Why it matters**: the digital baseband / packet-builder is
  ~ 5-10 kgates and the only credible open-source starting point.
- **What would settle it**: porting the NimBLE controller's
  packet-builder + CRC-24 + whitening to SystemVerilog and
  synthesising against `gf180mcu_fd_sc_mcu7t5v0` library.
- **Default assumption**: yes, portable; ~ 8 kgates.

## 9. What is the actual phone-side BLE scan duty-cycle on modern
iOS/Android?

- **Why it matters**: if a phone scans only every N seconds, our
  advert interval can be relaxed from 100 ms to ~ 1 s without UX
  regression - which closes ~ 10 dB of the harvesting gap.
- **What would settle it**: empirical measurement of the BLE
  scan duty-cycle on iPhone / Pixel using a BLE sniffer.
- **Default assumption**: 100 ms advert interval is the UX target;
  1 s acceptable for "passive scan-me" but loses interactivity.

## 10. Are scan-response (R1) packets worth the additional RX block?

- **Why it matters**: R1 lets the phone request a longer-payload
  reply (up to 31 B) on demand.  Adds ~ 2.5 mW RX cost during
  the post-advert listen window.
- **What would settle it**: UX-side decision; both FP and academic
  surveys recommend deferring to Stage-2.
- **Default assumption**: TX-only (R0) is the v3 target;
  TX+SCAN_RSP (R1) is a stretch goal.

## 11. Stage-2 prompt

If the gap analysis concludes (k) is silicon-physically
infeasible at our power budget, what is the *minimum* set of
relaxations (advert interval, output power, regulatory
compliance, no-external-passives) that would make it feasible?

- Relax advert interval from 100 ms to 10 s -> 1 dB savings.
- Relax 0 dBm to -10 dBm -> 7 dB savings.
- Allow 1 external 1 uF cap -> closes storage-cap wall.
- Add a primary battery -> closes the 20 dB power gap entirely.

Stage-2 should produce an *escalation matrix* showing which
combinations of relaxations make (k) feasible vs which don't.
