# Open questions (item f, Stage 1 industry-survey)

**Q1.** What is the actual quiescent current of `bi_24t` and
`asig_5p0` pad cells in their off-state across PVT?
*Decides:* whether the pad cell itself fits in the µW harvested
budget when the LED is dark.
*Investigate:* extract via SPICE from the PDK
`gf180mcu_fd_io.cdl` netlist; in particular the 36-instance NMOS-
cap decoupling on `asig_5p0` may have nontrivial gate-leakage at
125 °C SS.

**Q2.** During VGA-only mode (DVDD live, harvested rail dead), is
there a current path through the LED via the `asig_5p0` ESD-diode
stack that could (a) light the LED dimly or (b) damage the LED?
*Decides:* whether `asig_5p0` is safe as the LED pad and whether
an explicit on-die series isolation switch is required.
*Investigate:* nodal SPICE with DVDD = 5.0 V, harvested rail = 0,
LED model in series, anode→harvested, cathode→`asig_5p0` PAD.
Cross-ref item (i).

**Q3.** What is the *effective* PSRR of a candle-flicker pattern
generator when the harvested rail is rippling at the PWM frequency
itself?
*Decides:* whether T1/T3-style (rail-coupled) drivers cause
visible self-modulation that ruins the twinkle effect.
*Investigate:* behavioural Spice with rail-modulation feedback to
the comparator threshold.

**Q4.** Is PDM (IND-D) actually achievable in this die's clock
domain? What is the highest practical f_clk under the harvested-
rail-Vdd ring oscillator from item (a)?
*Decides:* whether IND-D's "lower-rail-ripple-than-PWM" win is
real for our system, or only theoretical.
*Investigate:* depends on item (a) topology selection.

**Q5.** Are there published results on how *human observers
distinguish* LFSR-based vs rejection-sampling-based vs sine-LUT
"twinkle" patterns at < 1 mA average current?
*Decides:* algorithm selection in PAT-1..PAT-5.
*Investigate:* requires perception-study literature search (out of
scope for industry survey; flag for academic-survey agent).

**Q6.** Does GF180MCU offer a true open-drain pad option, or do
all bidir pads have unavoidable PMOS pull-up paths to DVDD?
*Decides:* whether a low-side-only LED driver topology is viable
(advantageous for LEDs with anodes tied to the harvested rail).
*Investigate:* deeper LEF/CDL audit of `bi_24t` PMOS pull-up
network and its OE-controlled tristate behaviour.

**Q7.** What is the *measured* current draw of the FR1001 /
FR1002 ICs (referenced in IND-B), and the modern OTP-MCU candle-
flicker LEDs, that would let us calibrate our area / Iq budget
against real silicon?
*Decides:* sanity check on §5.5 of the report.
*Investigate:* purchase samples ($1-5 each); measure on a bench
ammeter.

**Q8.** Are there any commercial LED-driver ICs designed
explicitly for energy-harvested operation (sub-100 µA Iq, < 2.5 V
headroom)?
*Decides:* whether the survey missed an industry product line.
*Investigate:* search e-peas (AEM10941 / AEM30940 are the closest
known PMICs), Cypress / Infineon S6AE10x harvester families,
Nexperia novelty parts, ROHM ML8531 series.
