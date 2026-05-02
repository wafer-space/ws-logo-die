# (d) Ambient 2.4 GHz RF harvesting — research home

**Goal (from [`TODO.md`](../../../TODO.md#d-ambient-24-ghz-rf-harvesting-single-pin-antenna)):**
scavenge enough µW from background Wi-Fi / Bluetooth to run the LED
drivers (only) when neither Qi nor NFC power is available.

## Scope of research

1. **Empirical ambient power densities** at 2.4 GHz in indoor and
   outdoor environments. Independent measurements only — vendor white
   papers are notoriously optimistic. Cite the measurement
   methodology, antenna gain, integration time.
2. **Antenna topology for a single-pin feed** — IFAs, monopoles,
   chip antennas, PIFA, electrically-small magnetic loops. Ground
   reference via PCB plane / package / on-die.
3. **Rectifier topologies at 2.4 GHz** — Dickson voltage multiplier
   with various device flavours, cross-coupled differential
   rectifier, asymmetric pumping, threshold-cancellation tricks
   (DTMOS, gate-bias-bootstrapping, floating-gate). Native /
   zero-Vt devices in `gf180mcuD` if any.
4. **Matching network** — at this frequency, on-die matching becomes
   feasible; the trade-off is on-die L Q and area vs antenna self-
   inductance + capacitance.
5. **Real-world receive sensitivity** — what is the *minimum*
   ambient power density at which a published 2.4 GHz harvester has
   genuinely lit an LED, not merely "stored a few mV across a
   capacitor"? Cite measurements.
6. **Physics sanity check** — Friis-equation sanity for typical Wi-Fi
   AP powers and typical user distances. Does the µW LED-twinkle
   claim hold at, say, 5 m from a 100 mW AP?
7. **Sharing with (k) BLE.** The PCB places one IFA meander that
   serves both modes. Investigate published TR-switch / pin-mux
   architectures.

## Status

See [`../INDEX.md`](../INDEX.md).
