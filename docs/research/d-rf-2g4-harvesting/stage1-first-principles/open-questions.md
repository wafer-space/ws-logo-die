# Open questions (item d, Stage 1 first-principles)

**Q1.** What is the realistic G_rx of the 6 × 10 mm IFA on the
actual PCB ground plane? *Decides:* whether to size the chip for
2 dBi (textbook) or -3 dBi (electrically small) Friis budget.
*Investigate:* EM-simulation (HFSS / openEMS) of the actual L3
IFA on the 4-layer ISO 7810 stackup.

**Q2.** How much aperture coupling do the NFC perimeter spiral
(L2) and Qi coil (L3) cost the IFA? *Decides:* whether antennas
need re-positioning on the PCB.

**Q3.** What is the achievable Q of an on-die spiral inductor on
GF180MCU at 2.45 GHz? *Decides:* whether `match-LC-pi` (S2, S4)
or `match-transformer` (S3) gives the best voltage step-up.

**Q4.** What native-Vt NMOS Vth is achievable across PVT corners
with low-µA bias? *Decides:* number of multiplier stages required
to reach 1 V DC.

**Q5.** What is the best feasible TR-switch isolation in
GF180MCU? *Decides:* safety of co-existing harvester and item (k)
BLE PA.

**Q6.** Does the 25.175 MHz pixel clock's 97th harmonic genuinely
couple into the harvester at meaningful amplitude? *Decides:*
whether the harvester needs to be hard-gated off in VGA mode.

**Q7.** What is the on-die capacitance available after the logo
and PDN have taken their share? *Decides:* storage-cap size choice
(1 nF vs 10 nF). *Cross-reference:* Item (e) MIM cap storage
research output.

**Q8.** Is the project willing to redefine the (d) success
criterion to "twinkles when within 1–2 m of an active
transmitter" rather than "twinkles in arbitrary indoor RF
environments"? *Decides:* marketing/demo positioning. **This is
the single most important question raised by this report.**

**Q9.** Is a fixed-frequency single-band 2.45 GHz harvester
sufficient, or should the design be wideband (cellular + Wi-Fi)?
*First-principles answer:* Pinuela 2013 broadband measurement was
1.2 nW; *single-band 2.4 GHz near a known AP* easily exceeds
this. Single-band is the right call.

**Q10.** Does the antenna feed bond pad need to be a special "RF
pad" cell or can it be a stripped-down `bi_24t`?

**Q11.** Can the harvester self-start at -25 dBm input, or does
it need a non-cancelled "warmup" stage?

**Q12.** What is the actual (not nominal) bondwire inductance
distribution across a packaged-and-bonded population?
