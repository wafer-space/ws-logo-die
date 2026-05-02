# (k) Aspirational low-power BLE subsystem — research home

**Goal (from [`TODO.md`](../../../TODO.md#k-aspirational-low-power-ble-subsystem)):**
a second wireless side-channel that transmits the business-card
payload as a Bluetooth Low Energy advertising packet, so a phone or
laptop scanning for BLE adverts can see the card without the NFC tap
gesture.

> **Aspirational:** not to be implemented until items (a)–(j) ship on
> Run 2 silicon and the harvested-power budgets are *measured*, not
> simulated.

## Scope of research

Despite (k) being aspirational, the *research* on it can run in
parallel with everything else — a Stage-1 survey informs the v2
floorplan (e.g. whether to budget a TR-switch pad and PA stage that
could later hold BLE).

1. **Power budget reality check.** BLE TX advertising packets cost
   ~1–10 mW peak for ~100–500 µs; mean power depends entirely on
   advert interval. Compare with what (b)/(c)/(d) can plausibly
   deliver into a storage cap (e). Apply Friis / coupling-coefficient
   sanity to all vendor numbers.
2. **Bluetooth flavour.** BLE 5.0+ advertising-only PHY (TX-only),
   Bluetooth Mesh advertising bearer, "AltBeacon" / "Eddystone" /
   "iBeacon" frame formats. Compare phone compatibility and the
   minimum on-die complexity for each.
3. **PA topologies on `gf180mcuD`.** Class A, AB, B, C, D, E, F at
   2.4 GHz on a 180 nm 5 V process. Output-power ranges, efficiency,
   linearity, antenna-match sensitivity. Cite published silicon at
   this node.
4. **Frequency synthesiser.** Integer-N PLL, fractional-N PLL,
   open-loop ring DCO with calibration, FLL against an external
   reference. Phase-noise targets for BLE compliance.
5. **TX-only vs minimal-RX.** TX-only: simplest, cheapest, but the
   reader sees only one-way adverts. Minimal-RX (scan-response
   support): much friendlier user experience, but adds an LNA, demod,
   and protocol complexity. Survey both.
6. **Antenna sharing with (d).** The PCB places a single 2.4 GHz IFA
   shared between ambient harvesting and BLE TX. Survey TR-switch
   architectures, isolation requirements, and any published
   integrated harvester+BLE designs.
7. **Regulatory pre-compliance.** ISM-band conducted-emission limits,
   PSD limits, frequency-hopping requirements (BLE adverts). What
   would a non-compliant design look like, and what would it cost to
   make it compliant?
8. **Crypto / privacy.** BLE 5 resolvable random addresses; should a
   static "card scan" use them?
9. **Open-source reference designs.** Are there published or
   open-source TX-only BLE radios / advertisers at any process? Even
   a 65 nm reference implementation gives strong architectural
   guidance even if the silicon doesn't directly transfer.

## Status

See [`../INDEX.md`](../INDEX.md).
