# Open questions -- Stage-1 academic survey, item (d)

Each question is phrased so that a follow-up agent can answer
it definitively. The "Decision depends on" field names which
downstream stage / item / sub-block depends on the answer; the
"Investigation" field names the kind of evidence that would
settle it.

## Q1. Is the "Awad 2022 MDPI Sensors" anchor used in parallel reports actually Pakkirisami Churchill et al. 2022 (DOI 10.3390/s22124415)?

- **Decision depends on:** Stage-2 reference disambiguation;
  any number quoted from "Awad 2022" by sister reports.
- **Background:** Both the first-principles and industry-
  survey reports cite "Awad et al., MDPI Sensors 2022" as the
  source of "21.15 % peak PCE at 0 dBm input, 423 uW output,
  423 uW DC". This academic survey could not locate any MDPI
  Sensors 2022 paper under "Awad" matching those numbers; the
  closest match is **Pakkirisami Churchill et al. 2022**, which
  reports exactly 21.15 % PCE at 0 dBm and 423 uW output.
- **Investigation:** open MDPI Sensors 2022 archive, search for
  any paper with author "Awad" and 2.4 GHz RFEH content; if
  none, conclude the sister-report attribution is mis-spelt
  and update Section 6 / 7 references accordingly.

## Q2. What is the *measured* RF input power at which Yan 2024 produces enough DC to drive 1 mA into a 1.6 V LED for 100 us once per second?

- **Decision depends on:** project's "twinkle" success criterion
  vs distance-from-AP regime; Stage-3 deep dive on Yan-2024
  architecture port.
- **Background:** Yan 2024's headline number is sensitivity at
  *signal detection*, not at *useful DC output* -- the chip
  starts producing DC at -19 dBm but the absolute power
  available at that input level is in the nW range. The
  visible-flash energy floor (first-principles report Section
  5.5) is 0.04-0.16 uJ per flash. Need to characterise the
  full P_RF -> P_DC curve, not just the threshold.
- **Investigation:** retrieve the full RFIC 2024 paper (when
  IEEE access available); plot eta(P_in) and integrate against
  the LED-twinkle duty cycle.

## Q3. What is the actual input impedance of GF180MCU `nfet_06v0_nvt` and `pfet_06v0` at 2.45 GHz, and what matching network steps that to 50 Ohm with on-die L Q 5-8?

- **Decision depends on:** Stage-3 matching network design;
  Stage-5 schematic.
- **Background:** Stoopman 2014 framework requires a known
  rectifier input impedance for antenna co-design. GF180MCU
  RF parameter extraction at 2.45 GHz is sparse in the
  publicly-available PDK documentation.
- **Investigation:** S-parameter simulation of native-Vt and
  standard PMOS in `gf180mcuD` Spectre/Xyce model; plot
  Z_in vs (W/L, V_DC bias) at 2.45 GHz.

## Q4. Does our chip need to recover from 60-dB Wi-Fi-coverage holes, or only operate in a "twinkle when illuminated" regime?

- **Decision depends on:** S5 Yan-class vs S3 Villard-SVC
  shortlist; whether MPPT is needed at all (it adds ~0.05 mm^2
  digital footprint and 66-157 nW quiescent).
- **Background:** Yan's 24 dB PDR is significantly more than
  our LED-twinkle use case needs. If we only operate near a
  Wi-Fi AP, a fixed-stage-count rectifier with hysteretic
  load gating is sufficient.
- **Investigation:** literature search for "RFEH minimum
  duty cycle for visible LED" measurements; or simulate
  rendering of LED twinkle pattern under sparse-power input
  and see if it's perceptually adequate.

## Q5. Does PMOS-only DTMOS in GF180MCU bulk recover the full 6 dB sensitivity advantage of full-CCDD-DTMOS in 65 nm SOTB, or only ~3 dB?

- **Decision depends on:** S6 fall-back-architecture viability.
- **Background:** Honma 2019 reports 2.77 uW DC at -19.4 dBm
  using DTMOS on **both** halves of CCDD on 65 nm SOTB.
  GF180MCU bulk allows DTMOS only on the PMOS half (NMOS body
  ties to the substrate).
- **Investigation:** Spice sim of CCDD-SVC vs CCDD-SVC-DTMOS-
  PMOS-only at 2.45 GHz on `gf180mcuD`.

## Q6. Can the wafer.space logo top-metal usage tolerate a 6-8 nH spiral inductor without breaking the visual rocket-rings pattern, or do we need a metal-3/4 dual-spiral instead?

- **Decision depends on:** Stage-3 layout floorplan; trade-
  off of inductor Q (top-metal) vs visible logo (any metal).
- **Background:** Top metal in `gf180mcuD` is the thickest /
  highest-Q layer. Stoopman / Theilmann inductor designs use
  it. The wafer.space logo currently spans all metal layers
  (`big_logo`); excluding the inductor footprint from logo
  metal will leave a visible gap.
- **Investigation:** floorplan study comparing 6-8 nH spiral
  on M5/M6 vs M3/M4 stacked-pair, with Q simulation in
  EM-CAD (Sonnet / EMX equivalent).

## Q7. Does the Pinuela 2013 explicit non-result for 2.4 GHz harvesting still hold in 2026 Wi-Fi-6 / Wi-Fi-6E environments, or has duty-cycle / channel utilisation increased enough to change the verdict?

- **Decision depends on:** "true ambient" honesty framing in
  Stage-2 / Stage-3.
- **Background:** Pinuela 2013 measurements pre-date Wi-Fi 5
  (post-2013) and Wi-Fi 6 (post-2019). Wi-Fi 6 introduced
  OFDMA and is *more* spectrum-efficient -- which can mean
  either higher duty cycle (good for harvesting) or lower
  total energy (bad).
- **Investigation:** secondary literature search for "Wi-Fi
  channel utilisation 2024 2025"; or commission a fresh field
  measurement with a calibrated antenna.

## Q8. Does the on-die transformer balun (Theilmann 2012) achieve enough Q in `gf180mcuD` metal stack to be worth the area / IL trade vs an asymmetric Villard rectifier driven single-ended directly from the antenna?

- **Decision depends on:** S3 vs S4 architectural fork.
- **Background:** Theilmann 2012's transformer Q is reported
  at 5-8 on a 180 nm class metal stack, IL 1-3 dB. Asymmetric
  Villard avoids the transformer entirely but loses ~3 dB
  PCE vs CCDD.
- **Investigation:** EM simulation of a 5-turn 1:1 transformer
  on `gf180mcuD` M5/M6; co-simulate with rectifier S-parameters
  to extract end-to-end PCE; compare against asymmetric
  Villard reference design.

## Q9. What is the actual measured VT0 of `nfet_06v0_nvt` in `gf180mcuD` silicon (not PDK-typical) across PVT corners, and does it stay below 100 mV at the rectifier's sub-uA bias point?

- **Decision depends on:** S2 / S3 sensitivity floor; S6
  DTMOS-PMOS-only de-rating.
- **Background:** GF180MCU PDK datasheet specifies VT0 typ
  -0.12 V for native-Vt 6 V NMOS. At sub-uA currents the
  effective Vth could be either lower (sub-threshold) or
  higher (mismatch / process variation).
- **Investigation:** Spice corner sweep + Monte Carlo on
  `nfet_06v0_nvt`; ideally cross-check against measured Run 1
  silicon (item (j) test structures, if instrumented for this).

## Q10. Does the on-chip storage cap budget (10-50 nF MIM) sustain a 0.04-0.16 uJ visible-flash dump without dipping the rail below the brown-out detector's threshold and re-triggering oscillation?

- **Decision depends on:** S6 storage cap sizing; brown-out
  hysteresis design.
- **Background:** A 0.16 uJ flash from 50 nF at 1.5 V steady-
  state pulls the rail to V = sqrt(V0^2 - 2E/C) =
  sqrt(1.5^2 - 2*1.6e-7/5e-8) = sqrt(2.25 - 6.4) = imaginary
  -- meaning **50 nF cannot sustain 0.16 uJ at all**. The
  visible-flash energy must be reduced or the storage cap
  enlarged. This is a load-bearing arithmetic check.
- **Investigation:** re-derive the per-flash energy /
  storage-cap relation as a constraint surface; consider
  whether the visible-flash criterion needs to be relaxed
  to ~10 nJ-class flashes (sub-perceptual but measurable).

## Q11. Will item (k)'s BLE PA leakage during TX bursts damage the harvester's gate oxide, or merely de-tune the input network temporarily?

- **Decision depends on:** C8 T/R-switch isolation requirement.
- **Background:** First-principles report Section 5.9 derives
  >50 dB isolation for 1 mW BLE TX leakage to stay below
  1 V across the harvester gate. T-network + matching detune
  achieves ~50 dB at ~2 dB harvest IL.
- **Investigation:** transient Spice with TX burst injected
  into harvester input via T/R switch; track maximum gate
  V_GS on the rectifier devices.

## Q12. Is there a published silicon implementation of an asymmetric (single-ended) Villard rectifier *with* SVC at 2.4 GHz on 180 nm bulk?

- **Decision depends on:** S3 viability without inventing a
  new topology.
- **Background:** Most CCDD-SVC publications target
  differential antennas. Villard-SVC at 2.4 GHz on bulk 180 nm
  may be unpublished, in which case our S3 architecture
  becomes a partial novelty.
- **Investigation:** dedicated literature search for
  "Villard CMOS SVC 2.4 GHz" / "asymmetric rectifier
  threshold cancellation 2.4 GHz" in Stage-2.

## Q13. What is the area/PCE penalty of running the Yan-2024 reconfigurable rectifier with only 4 stages active vs the full 8 stages?

- **Decision depends on:** if the project ships S5 with a
  reduced stage count, does it still meet the LED-twinkle
  threshold?
- **Investigation:** retrieve the per-configuration PCE curve
  from Yan 2024 paper (Stage-2 IEEE-access dependent).

## Q14. Are there any tinytapeout / open-source 180 nm RFEH / 2.4 GHz rectifier reference designs that have been measured in silicon?

- **Decision depends on:** silicon-validated reuse vs designing
  from scratch.
- **Background:** Sister industry-survey reports zero hits on
  GitHub for `tinytapeout RF rectifier OR "energy harvest"`.
  The wafer.space project, if it ships, becomes the first
  open-source 2.4 GHz silicon RFEH design.
- **Investigation:** broader open-source silicon search
  beyond GitHub (Efabless / Skywater / IHP-foundry-share);
  CICC / ISSCC student-chip listings.

## Q15. How does the harvester behave when illuminated by *two* APs at substantially different frequencies (e.g. 2.4 GHz consumer Wi-Fi + 2.4 GHz BLE beacons + ZigBee), and is there constructive vs destructive combining?

- **Decision depends on:** real-world performance characterisation
  in Stage-6.
- **Background:** All published RFEH chips characterise against
  a single CW source. Real ambient is multi-tone.
- **Investigation:** transient Spice with two-tone RF input
  separated by 5-20 MHz; measure DC output vs single-tone of
  equivalent total power.
