# Components — sub-block breakdown (item f, Stage 1 first-principles)

## Per-topology block lists

**T1 (resistor ballast):** poly R 0.5-5 kΩ; 5 V NMOS or PMOS
switch, 100-1000 µm; pre-driver/level shifter from digital domain;
(opt) brown-out comparator.

**T2 (current mirror):** bandgap or β-multiplier reference; cascode
mirror; ref resistor 10-100 kΩ; output-gate FET; pre-driver.

**T3 (current-DAC + PWM):** all of T2 + binary-weighted tail array
(3-6 bit) + DAC code register + PWM counter (12-bit at low MHz).

**T4 (bucket-dump charge pump):** bucket MIM cap 5-50 nF; high-side
PMOS (rail→bucket); low-side NMOS (bucket→LED→GND); non-overlap
clock; pre-drivers; (opt) series R for I_peak limit.

**T6 (tribrid SC-multiplier + bucket):** all of T4 + 2nd flying
cap; 3-phase non-overlap clock; 2 series-mode switches.

**T7 (direct switch):** wide switch FET sized for worst-case PVT;
pre-driver; (strongly rec.) eFuse W/L trim.

## Shared infrastructure

- Pattern generator (LFSR / value-noise / brownian / additive —
  50-1000 gates per LED).
- Brown-out comparator on V_rail (intrinsic to (e)/(i)).
- 2 output pads `bi_24t` co-located with harvested-rail pads.
