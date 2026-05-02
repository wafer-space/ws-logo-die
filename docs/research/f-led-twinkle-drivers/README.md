# (f) LED twinkle drivers — research home

**Goal (from [`TODO.md`](../../../TODO.md#f-led-twinkle-drivers)):**
drive two off-chip LEDs in a visually pleasing "twinkle" pattern from
the harvested rail.

## Scope of research

1. **LED driver topologies suitable for sub-mA average current** —
   fixed resistor (forbidden — no external passives), on-die ballast
   resistor, current mirror, current DAC, charge-pumped pulse driver.
2. **PWM brightness modulation** — frequency / duty range vs human
   perception (flicker fusion frequency, gamma curves), and the
   trade-off between PWM frequency and rail noise.
3. **Pattern generators** — pseudo-random (LFSR), Perlin / value
   noise, sine-table lookup, additive-synthesis, brownian motion.
   The aim is "looks organic". Survey what published "candle flicker"
   / "fairy light" / "breathing LED" implementations actually do.
4. **Brown-out behaviour.** When the harvested rail dips below the
   LED's forward voltage, what does the driver do? Graceful dimming
   vs hard cutoff vs latching brown-out vs glitchy shutdown.
5. **Rail-coupling.** PWM creates current spikes that the harvested
   rail's storage cap (e) must absorb without browning out. Survey
   how published harvested-power LED drivers spread these load
   transients.
6. **Pad type.** The existing `bi_24t` bidir pad on the chip can sink
   24 mA. Is a dedicated higher-current driver pad worth the area?
7. **eFuse-controlled pattern selection** (depends on (j)). Does the
   pattern need to be field-changeable, or is a fixed pattern
   acceptable?

## Status

See [`../INDEX.md`](../INDEX.md).
