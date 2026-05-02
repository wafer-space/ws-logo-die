# Open questions (item f, Stage 1 first-principles)

**Q1.** What is the SPICE-modelled Vth and I_DSAT/W of `gf180mcuD`
5 V NMOS at the actual harvested-rail voltage across SS/TT/FF?
*Decides:* T7 viability and switch sizing for all topologies.
*Investigate:* pull `.lib` from LibreLane PDK and sweep, or read
corner table from the PDK SPICE specs subpages.

**Q2.** Achievable on-die polysilicon resistor sheet resistance and
tolerance in `gf180mcuD`? *Decides:* T1 ballast area cost; tolerance
determines whether ±30% I-spread is acceptable.

**Q3.** MIM-cap density achievable under the wafer.space logo
without disturbing logo metal? *Decides:* T4/T6 bucket-cap area;
whether C_b ≥ 10 nF is feasible. Cross-ref item (e); inspect
`big_logo` per-layer metal density.

**Q4.** Does η_e=0.20 hold for the LED part the PCB team actually
picks? *Decides:* pulse-energy budget for chosen part. *Investigate:*
get candidate LED PNs from PCB team; compute photopic luminance per
mA per part.

**Q5.** Is brown-out detection lifted from item (i) or duplicated
inside the LED driver? *Decides:* how much brown-out logic must
live in the LED driver. Cross-ref (i).

**Q6.** Single bucket cap shared between both LEDs, or one per LED?
*Decides:* area cost ×1 vs ×2; phase-staggered double-pump may
*reduce* rail ripple further. Spice in Stage 4.

**Q7.** eFuse knob choices (depends on j)? *Decides:* per-LED
knobs: pattern-select 2-3 b, brightness-cap 3-4 b, pump-frequency
2-3 b, twinkle-period 3-4 b ⇒ **10-14 bits per LED, 20-28 bits
total**. Trivial against any realistic eFuse budget.
