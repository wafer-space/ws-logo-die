# Sub-block components -- Stage-1 academic survey, item (d)

This file enumerates the recurring sub-blocks that appear across
the peer-reviewed silicon literature on 2.4 GHz CMOS RFEH. It
is the per-block companion to `report.md` Section 4.

## C1. RF input network (single-pin -> rectifier)

**Function.** Transform the antenna+bondwire complex impedance
to the conjugate of the rectifier input impedance, with maximum
voltage gain at 2.45 GHz.

**Published variants:**

- C1.a `match-onchip-LC-pi` -- Stoopman 2014 (90 nm, 0.866 GHz),
  Churchill 2022 (180 nm, 2.4 GHz). On-die spiral L 5-10 nH,
  Q 5-8; matched to 50 Ohm with two MIM/MOM caps in pi
  configuration.
- C1.b `match-onchip-transformer` -- Theilmann & Asbeck 2012
  (180 nm, 2.4 GHz). 2-3x voltage step-up + single-ended-to-
  differential conversion in one passive structure. Area
  ~0.06-0.10 mm^2.
- C1.c `match-bondwire-as-element` -- Yoo & Yoo 2014 (180 nm,
  920 MHz). Bondwire L = 1 nH/mm; +/-20 % tolerance requires
  on-chip trim cap bank (3-5 bit binary-weighted).
- C1.d `match-antenna-coplanar-L` -- Stoopman 2014 framework;
  the antenna itself is designed with a complex Z that
  matches the rectifier directly, eliminating the LC ladder.

**Sizing for our project (preliminary):**
- L ~ 6-8 nH on-die spiral, Q 5-8 (5 turns, 100 um trace, top
  metal stack -- conflicts with logo top-metal aesthetic;
  consider metal-3/4 dual-spiral instead).
- C ~ 200-400 fF for resonance at 2.45 GHz.
- Insertion loss budget: 1-3 dB.

## C2. Rectifier core stack

**Function.** Convert RF signal to DC, with effective Vth as
close to 0 as the topology+bias scheme allows.

**Published variants (cross-ref report.md Section 3.A):**

- C2.a `dickson-naive-nfet` -- 4-10 stages, NMOS diode-connected.
  Strawman.
- C2.b `dickson-native-nfet` -- 4-8 stages, native-Vt NMOS
  (`nfet_06v0_nvt`). Baseline.
- C2.c `CCDD-3stage` -- Churchill 2022 baseline; 3 stages of
  cross-coupled CMOS rectifier. Each stage requires both NMOS
  and PMOS, both with body-tie strategy.
- C2.d `CCDD-Kotani-SVC` -- Le 2008 / Kotani-and-CCDD hybrid.
  Each stage's gate offset bias drawn from a downstream stage
  output. Requires a self-startup naive first stage.
- C2.e `villard-3stage-asymmetric` -- single-ended drive
  natural; single-pin compatible.
- C2.f `reconfigurable-Yan` -- 4-8 stages with switchable
  per-stage bypass FETs; controller selects active count
  based on RSSI / output voltage.

**Sizing for our project (preliminary):**
- 3-5 stages CCDD with Kotani SVC bias.
- W/L per device ~ 5-10 um / 0.18 um.
- Per-stage coupling cap 100-300 fF (MIM); area-dominant.

## C3. Self-startup / cold-start network

**Function.** Bridge the chicken-and-egg between SVC bias
generation and rectifier output.

**Published variants:**

- C3.a `naive-first-stage` -- Kotani SVC standard. The
  first 1-2 stages are bias-less; their output drives the
  bias chain of subsequent stages.
- C3.b `relaxation-osc-50mV` -- Yan 2024. Self-starting
  oscillator that runs from 50 mV V_DD; provides clock to
  switched-capacitor charge pump that boosts bias rail.
- C3.c `body-bias-from-substrate-leakage` -- Papotto 2011.
  PMOS body biased from a leakage-current-derived negative
  rail; standard on-chip technique.

## C4. Charge-pump back-end

**Function.** Boost rectifier DC output to a usable rail
voltage (~1.2-3.3 V) and provide load regulation.

**Published variants:**

- C4.a `SC-charge-pump-3x` -- Yan 2024. Switched-capacitor 3x
  multiplier. No external inductor.
- C4.b `dickson-second-stage` -- Pakkirisami Churchill 2022.
  6-stage Dickson charge pump after the rectifier.
- C4.c `LDO-only` -- Stoopman 2014. No boost; LDO drops to
  load.
- C4.d `boost-converter-inductor-based` -- TI BQ25504
  (Pinuela 2013). **Forbidden in our project** (external
  inductor).

**Sizing for our project (preliminary):**
- Yan-2024-style 3x SC charge pump.
- Flying caps 200-500 fF MIM each, 4-5 stages.
- Switching freq 1-10 MHz from on-die relaxation osc.

## C5. MPPT controller

**Function.** Maintain rectifier output near maximum-power-
transfer operating point as RF input varies.

**Published variants:**

- C5.a `FOCV-80pct` -- TI BQ25504 / Pinuela 2013. Sample V_OC
  every ~16 ms; track 80 % of it. Quiescent ~330 nA.
- C5.b `perturb-and-observe` -- Yan 2024. Digital P&O loop
  with reconfigurable rectifier stage count. Quiescent
  66-157 nW.
- C5.c `bypass-no-MPPT` -- Stoopman 2014. Direct dump to
  storage cap; load gated by hysteretic comparator.

**Sizing for our project (preliminary):**
- C5.b for variable-distance operation; alternatively C5.c
  for absolute-minimum quiescent (LED-twinkle case).
- Digital footprint <= 200 standard cells.

## C6. Storage capacitor + load gate

**Function.** Smooth bursty rectifier output and enable
visible-flash LED pulses on top of average sub-uW DC supply.

**Published variants:**

- C6.a `MIM-onchip` -- 100 pF - 10 nF feasible on-die at
  GF180MCU MIM density (~1-2 fF/um^2). For 1.6 uJ visible
  flash at 1.5 V: C = 2E/V^2 = 2*1.6E-6/1.5^2 = 1.42 uF
  -- **infeasible on-die**; flash energy must scale to
  ~0.04-0.16 uJ (see first-principles report Section 5.5).
- C6.b `hysteretic-load-gate` -- comparator with hysteresis
  V_high / V_low trips the LED on when storage cap reaches
  V_high and off at V_low. Gates the visible-flash duty
  cycle to whatever the harvester can sustain.

**Sizing for our project (preliminary):**
- 10-50 nF MIM storage cap.
- Comparator with V_high = 1.5 V, V_low = 1.2 V hysteresis.
- LED gate FET sized for 1-5 mA pulse current.

## C7. Brown-out detector

**Function.** Disable subsystems when supply falls below
operating threshold; release them when rail recovers.

**Published variants:**

- C7.a `simple-bandgap-comp` -- standard. ~30 nA quiescent.
- C7.b `subthreshold-comparator-only` -- Stoopman 2014;
  ~5 nA quiescent.

## C8. T/R switch (item-(k) BLE share)

**Function.** Connect antenna to either harvester input or BLE
PA output; provide isolation when BLE TX is active.

**Published variants:**

- C8.a `series-NFET-TR` -- standard short-range radio FE.
  ~20 dB isolation.
- C8.b `series-NFET-plus-shunt-NFET` -- standard FE; ~30 dB
  isolation.
- C8.c `series-shunt-T-network` -- 50 dB isolation, 1-2 dB
  IL on harvest path.
- C8.d `LC-detuned-network-soft-switch` -- detunes harvester
  input network at TX time; ~25-35 dB.

**Sizing for our project (preliminary):**
- C8.b at minimum for protecting harvester input from BLE
  PA leakage; first-principles report Section 5.9 derives
  >50 dB isolation requirement -> C8.c.

## Cross-block adjacency notes

- C1 and C2 are typically co-designed: rectifier input
  impedance is a function of stage count and device size, and
  the matching network must conjugate-match it. Stoopman
  2014's framework treats them jointly.
- C3 and C5 share controller logic: both use a low-power
  oscillator and a comparator chain.
- C4 and C6 share charge-storage architecture: the SC charge
  pump's output cap is *also* the storage cap (or feeds it
  via a single FET).
- C7 must be implemented in the harvested-rail domain (not
  the VGA rail) because it is the gate-keeper for waking up
  consumers from brown-out.
