# (a) Internal oscillator — research home

**Goal (from [`TODO.md`](../../../TODO.md#a-internal-oscillator)):**
replace the externally-supplied chip clock for everything that isn't
the VGA path, so harvested-power modes don't need a crystal or any
off-die timing reference.

## Scope of research

Researchers should consider:

1. **Frequency targets.** The chip's downstream consumers and what
   accuracy / phase-noise / drift they tolerate:
   - VGA pixel clock (may continue to use external clock when the
     monitor is connected; do we need internal coverage at all?).
   - NFC carrier-derived timing for (h) — typically self-clocked from
     the 13.56 MHz field; investigate whether on-die clock is needed.
   - Qi (c) and ambient-RF (d) — rectification is asynchronous; clock
     only needed for housekeeping.
   - LED twinkle (f) — slow, drift-tolerant.
   - eFuse programming (j) — slow.
   - BLE (k) — 2.4 GHz LO synthesis; this is by far the hardest
     consumer.
2. **Topology family** — every published topology that runs in a
   180 nm 5 V process, including (but not limited to): ring, RC
   relaxation, RC twin-T, Wien bridge, LC tank, mode-locked, MEMS-on-
   die (if any exist for `gf180mcuD`), self-biased, current-starved,
   chopper-stabilised, sub-threshold, FBAR, and any
   thermistor / temperature-compensated variants.
3. **Trim mechanism** — how published designs achieve their accuracy
   numbers (untrimmed, factory trim, eFuse trim, on-the-fly
   calibration against a reference, etc.).
4. **PVT sensitivity** — how each topology behaves across process,
   voltage and temperature corners. Pay particular attention to the
   *brown-out / supply-droop* condition that this chip's harvested
   rails will impose.
5. **Start-up time** — relevant to NFC tags which must respond to
   reader polls within milliseconds of field application.
6. **What `gf180mcuD` actually offers.** Researchers must check the
   PDK at `gf180mcu_pdk/gf180mcuD/libs.ref/` for any pre-built
   oscillator IPs, and the PDK docs for any process-specific
   considerations.

## Status

See [`../INDEX.md`](../INDEX.md) for stage-by-stage status.
