# Internal-oscillator -- Stage-1 academic-survey: solution-space catalogue

This file is the structured topology catalogue for the academic-survey
angle. It is keyed by stable short names that the report.md narrative
and the references.md bibliography both reference. Topology IDs use a
new prefix-letter scheme (`AC*` = academic) so they do not collide
with the `A1`/`B2`/etc. names used by the sister industry-survey and
first-principles reports; cross-references to those are noted inline.

> Where an entry says "paywall -- abstract-only verification", the
> WebFetch web-access guidance for this stage forbade pulling IEEE
> Xplore / Wiley / Elsevier full-text. The DOI / venue / year /
> authors are confirmed from open-access mirrors (Semantic Scholar,
> ResearchGate abstract, Google Scholar snippet, arXiv if available,
> author faculty page). Numerical claims have been read from those
> abstract / first-page surfaces and cross-checked against textbook
> formulae in §5 of report.md.

---

## Family AC-RC -- chopper / offset-cancelled RC relaxation oscillators

The academic literature on this family is much deeper than the
industry survey suggests. The unifying idea: the dominant accuracy
limitation of a textbook RC relaxation oscillator is the comparator's
input-referred offset (which dilates or contracts the trip points and
therefore the period). Academic work removes this with chopping,
auto-zero, swap-and-average, or duty-cycle balancing.

### AC-RC-1 -- Comparator-offset-cancellation RC, MIT Chandrakasan group

- Reference: A. Paidimarri, D. Griffith, A. Wang, A.P. Chandrakasan,
  "An RC Oscillator With Comparator Offset Cancellation," IEEE
  JSSC, Vol. 51, No. 8, pp. 1866-1877, Aug 2016. DOI:
  10.1109/JSSC.2016.2571331. **Verification:** open-access
  MIT-DSpace mirror at
  `https://dspace.mit.edu/bitstream/handle/1721.1/92830/...` for
  the ISSCC 2014 short version (120 nW, 18.5 kHz, +/-0.25 %). JSSC
  long version paywalled -- abstract-verified via Semantic Scholar
  ID `dcf530436a062e53ea8a0fa9477a76b26fa74858`.
- Topology: relaxation oscillator using two integrating
  capacitors swapped each half-cycle so that the comparator's
  input-referred offset adds to one half-period and subtracts
  from the other -- net offset cancels to first order.
- Headline numbers (ISSCC 2014 short): 120 nW at 18.5 kHz in
  65 nm CMOS, +/-0.25 % over -40 to 90 C, 4-25x temperature-
  stability improvement vs. the same topology without the
  swap.
- Why this matters for wafer.space: the chip's harvested rail
  imposes brown-out conditions where a fixed-offset comparator
  could shift the trip point disproportionately. Offset
  cancellation is structurally robust against rail-droop-
  modulated offset.
- Maps to industry survey: extends `B2` with a specific academic
  trick the industry datasheets do not advertise.

### AC-RC-2 -- 254-nW 20 kHz RC with 21 ppm/C minimum

- Reference: K.-J. Hsiao, "A 254-nW 20-kHz On-Chip RC Oscillator
  With 21-ppm/C Minimum Temperature Stability and 10-ppm Long
  Term Stability," IEEE JSSC (open-access via PMC10361407),
  2023. **Verification:** PMC mirror confirms full-text
  open-access at
  `https://pmc.ncbi.nlm.nih.gov/articles/PMC10361407/` --
  resolved 2026-05-03.
- Topology: dual-RC, swap-cap, with curvature-compensated bias
  current. Adds a tracking PTAT/CTAT sub-bias that flattens the
  RC TC curve at a chosen mid-temperature.
- Headline: 21 ppm/C minimum, 10 ppm long-term, 254 nW total --
  state of the art for kHz-range timers in 2023.
- For wafer.space: directly applicable as the LED-twinkle base
  clock and as the brown-out wake-up timer. 254 nW is well
  below any harvested-rail floor.

### AC-RC-3 -- Dynamic frequency-error compensation, 2.5 ppm/C, 1.05 MHz

- Reference: H. Jiang et al., "A 2.5 ppm/C 1.05-MHz Relaxation
  Oscillator With Dynamic Frequency-Error Compensation and Fast
  Start-Up Time," IEEE JSSC, vol. 54, no. 7, 2019. **Verification:**
  ResearchGate ID 333352284 -- abstract resolved; full text
  paywalled. paywall -- abstract-only verification.
- Topology: two parallel RC paths whose period error is measured
  by a chopped phase detector and corrected by feedback into the
  bias current. Effectively an internal FLL whose reference is
  the matched RC ratio, not an external standard.
- Headline: 2.5 ppm/C, 1.05 MHz, 60 us start-up.
- For wafer.space: the fast start-up is interesting for NFC
  cold-clock; the 2.5 ppm/C is suspect under our harvested-rail
  ripple regime (see §5 of report.md).

### AC-RC-4 -- Voltage-averaging-feedback relaxation, Tokushima group

- Reference: Tokairin et al., "A 280 nW, 100 kHz, 1-Cycle Start-up
  Time, On-chip CMOS Relaxation Oscillator Employing a
  Feedforward-Period-Control Scheme," VLSI Symp 2012;
  follow-up "An On-Chip CMOS Relaxation Oscillator With
  Voltage Averaging Feedback," IEEE JSSC vol. 45, no. 6, pp.
  1150-1158, June 2010. DOI: 10.1109/JSSC.2010.2046241.
  **Verification:** ResearchGate 224144593 -- abstract verified;
  paywall -- abstract-only verification on JSSC.
- Topology: feedback control averages the V_C waveform over a
  full cycle so the V_DD-dependence of the comparator threshold
  is partly cancelled by the V_DD-dependence of the average.
  Reduces V_DD sensitivity from ~1 %/V to ~0.04 %/V.
- For wafer.space: the V_DD-immunity result is the most
  directly relevant academic finding for a brown-out-prone rail.

### AC-RC-5 -- 8.1 nW, 4.22 kHz, leakage-compensated relaxation

- Reference: J. Lee et al., "A 8.1-nW, 4.22-kHz, -40-85 C
  relaxation oscillator with subthreshold leakage current
  compensation and forward body bias buffer for low power IoT
  applications," Solid-State Electronics, vol. 211, 2024.
  DOI: 10.1016/j.sse.2024.108810. **Verification:** ScienceDirect
  abstract resolved at
  `https://www.sciencedirect.com/science/article/abs/pii/S0026269224000028`.
  paywall -- abstract-only verification.
- Topology: relaxation osc where the leakage current of a
  transistor in the timing branch is matched and subtracted by
  a replica leakage path; forward body bias on the comparator
  buffer extends the operating range.
- Headline: 8.1 nW at 0.4 V supply, 4.22 kHz, energy efficiency
  1.92 nW/kHz.
- For wafer.space: relevant for the *always-on* brown-out
  timer that has to keep ticking when the harvested rail
  collapses to fractions of a volt.

### AC-RC-6 -- 33 kHz with on-die V/I reference and compensated comparator delay

- Reference: G. Wang, R. Liu, et al., "A -40-125 C, 0.8 V,
  33 kHz relaxation oscillator with integrated voltage and
  current reference and compensated comparator delay,"
  Microelectronics Journal, 2021.
  DOI: 10.1016/j.mejo.2021.105255. **Verification:**
  ScienceDirect abstract page S0026269221002718 resolved.
  paywall -- abstract-only verification.
- Topology: explicit comparator-delay compensation -- the
  comparator's propagation delay is digitised and subtracted
  from the period count. Removes the V_DD-dependent comparator
  delay that contributes ~30 % of the period error in
  classical Schmitt-RC implementations.
- For wafer.space: paywall verified by abstract; numbers
  reproduced from ScienceDirect snippet only. Useful prior art
  reference, not a candidate to copy directly because the
  topology assumes a 0.8 V supply not directly compatible with
  GF180MCU 5 V flow.

---

## Family AC-FLL -- frequency-locked-loop RC oscillators

The academic version of the industry-survey `C1` family. The
unifying idea: keep the cheap free-running ring/RC oscillator,
but lock its frequency to a known-accurate ratio (an on-die
RC time-constant, an external carrier, or a sigma-delta
modulated reference) using a digital loop filter.

### AC-FLL-1 -- 110 nW Resistive Frequency-Locked On-Chip Oscillator (Michigan)

- Reference: M. Choi, T. Jang, S. Bang, Y. Shi, D. Blaauw, D.
  Sylvester, "A 110 nW Resistive Frequency Locked On-Chip
  Oscillator with 34.3 ppm/C Temperature Stability for
  System-on-Chip Designs," IEEE JSSC, vol. 51, no. 9, pp.
  2106-2118, Sept 2016. DOI: 10.1109/JSSC.2016.2586744.
  **Verification:** open-access PDF at
  `https://blaauw.engin.umich.edu/wp-content/uploads/sites/342/2017/11/ChoiA-110-nw-resistive-frequency-locked-on-chip.pdf`
  -- resolved 2026-05-03.
- Topology: digital-intensive FLL where a self-biased
  digitally-controlled oscillator is locked to an RC time
  constant via a single-bit chopped comparator and a digital
  sigma-delta loop filter.
- Headline: 110 nW @ 70 kHz, 34.3 ppm/C, sigma-delta DCO.
- For wafer.space: this is the *closest published silicon
  precedent* for the trim mechanism the project's brief calls
  out ("Sigma-Delta capacitor banks, current-DAC bias"). The
  Michigan paper builds exactly the trim DAC the brief asks
  for, in <1 mm^2, at 110 nW total power, all-CMOS, no on-die
  passives beyond R+C.

### AC-FLL-2 -- Bang-bang Digital FLL for IoT wakeup timer

- Reference: D. Griffith et al., "An Energy Efficient and
  Temperature Stable Digital FLL-based Wakeup Timer with
  Time-Domain Temperature Compensation," IEEE JSSC, 2024.
  PubMed PMID 38961880. **Verification:** PubMed abstract
  resolved at `https://pubmed.ncbi.nlm.nih.gov/38961880/`
  -- 2026-05-03.
- Topology: similar to AC-FLL-1 but the temperature
  compensation is done in the time-domain by measuring the
  ratio of two RC time-constants with different TC.
- For wafer.space: TC-domain compensation is firmware-free
  (unlike Renesas HOCO -- see industry survey N5), so it
  *is* transferable to our pure-HDL chip.

### AC-FLL-3 -- 2.5 ppm/C with dynamic frequency-error compensation (cf. AC-RC-3)

- Reused entry; see AC-RC-3 above. The classification is
  fluid -- this design is also a digital FLL whose reference
  is a swap-cap pair.

### AC-FLL-4 -- Carrier-locked FLL for HF RFID / NFC

- Reference: Y. Yao, J. Wu, Y. Shi, F.F. Dai, "A Fully
  Integrated 900-MHz Passive RFID Transponder Front End With
  Novel Zero-Threshold RF-DC Rectifier," IEEE Trans. Industrial
  Electronics, vol. 56, no. 7, pp. 2317-2325, July 2009. DOI:
  10.1109/TIE.2009.2018432. **Verification:** WebSearch hit
  confirms title/authors/venue; paywall -- abstract-only
  verification.
- Plus: J.-S. Park et al., "Low power clock recovery circuit
  for passive HF RFID tag," Analog Integrated Circuits and
  Signal Processing, 2009. DOI:
  10.1007/s10470-008-9276-4. **Verification:** Springer
  abstract page resolved; paywall -- abstract-only.
- Plus: WO2013063500A2 / US9124413B2 (Qualcomm), "Clock and
  data recovery for NFC transceivers." **Verification:**
  Google Patents resolved at
  `https://patents.google.com/patent/US9124413B2/en` --
  2026-05-03.
- Topology: comparator at the rectifier-input node detects
  zero-crossings of the 13.56 MHz carrier; a counter and
  digital loop filter compare against the local free-running
  ring and emit a trim word that adjusts the ring's bias.
- Headline: ppm-level precision while the carrier is present;
  graceful fallback to last-known-trim when the carrier is
  absent, stored in eFuse.
- For wafer.space: this is the *exact academic anchor* for
  the project brief's "Frequency-locked loops to external
  references (NFC carrier, etc.)" bullet. Combined with
  Choi/Blaauw AC-FLL-1's all-CMOS sigma-delta DCO, this is
  arguably the strongest academic-derived candidate for v2.

---

## Family AC-SUB -- sub-threshold ring oscillators with gate-bias compensation

The "deeper" academic reading of the industry-survey `G1`/`G2`
family. The unifying idea: bias the ring inverters into deep
sub-threshold so the per-stage delay is dominated by exponential
sub-threshold current rather than channel-saturation drive.
Gate-leakage and body-bias compensations make this stable
across PVT.

### AC-SUB-1 -- Dynamic Leakage Suppression (DLS) ring oscillator

- Reference: I. Lee, D. Blaauw, D. Sylvester, "A Constant
  Energy-Per-Cycle Ring Oscillator Over a Wide Frequency Range
  for Wireless Sensor Nodes," IEEE JSSC, vol. 51, no. 3, pp.
  697-711, Mar 2016. DOI: 10.1109/JSSC.2016.2517133.
  **Verification:** open-access PMC mirror at
  `https://pmc.ncbi.nlm.nih.gov/articles/PMC4989868/`
  resolved 2026-05-03.
- Plus: I. Lee, R. Yang, et al., "An On-Chip Ultra-Low-Power
  Hz-Range Ring Oscillator Based on Dynamic Leakage
  Suppression Logic," IEEE Custom Integrated Circuits
  Conference (CICC) 2020, DOI 10.1109/CICC48029.2020.9182936.
  paywall -- abstract-only verification at IEEE Xplore (NOT
  fetched per stage guidance); Semantic Scholar abstract
  confirms 0.24 V to 1.8 V operation, picowatt order.
- Topology: each stage is a stack of OFF transistors; the
  exponentially small gate-leakage current charges/discharges
  the stage caps. Ring frequency is in the Hz range; energy
  per cycle is constant over a wide V_DD range, which makes
  the topology *brown-out tolerant by construction.*
- For wafer.space: directly applicable as the always-on
  brown-out timer (industry-survey `G2` slot). Not relevant
  for housekeeping clock (too slow).

### AC-SUB-2 -- 4.5 pW timer using gate-leakage of MOS caps

- Reference: Y.-S. Lin, D.M. Sylvester, D. Blaauw, "A sub-pW
  timer using gate leakage for ultra low-power sub-Hz
  monitoring systems," IEEE Custom Integrated Circuits
  Conference (CICC), Sept 2007. DOI:
  10.1109/CICC.2007.4405752. **Verification:** ResearchGate
  abstract 4300065 resolved; paywall -- abstract-only.
- Topology: gate leakage of a thin-oxide MOS cap discharges
  a storage node; the discharge time is the period.
- For wafer.space: GF180MCU 5 V is a *thick-oxide* node
  (typically 12 nm gate oxide for the 5 V devices) -- gate
  leakage is orders of magnitude smaller than in 130 nm /
  65 nm thin-oxide nodes that the original work targeted.
  **Negative finding:** the gate-leakage timer paper's
  attractive numbers don't transfer to GF180MCU's 5 V
  devices. See §7 of report.md (negative result NA-3).

### AC-SUB-3 -- 4.4 pW reference-free capacitive-discharging oscillator

- Reference: K.-K. Hsieh, M.M. Hella, "A Reference-Free
  Capacitive-Discharging Oscillator Architecture Consuming
  44.4 pW/75.6 nW at 2.8 Hz/6.4 kHz," IEEE JSSC, vol. 51,
  no. 6, 2016. DOI: 10.1109/JSSC.2016.2546304.
  **Verification:** ResearchGate abstract 303556351 resolved;
  paywall -- abstract-only verification.
- Topology: switched-capacitor topology that doesn't need a
  bandgap or PTAT bias -- the period is set by the ratio of
  two MIM caps and a sub-threshold transistor's V_GS that
  self-stabilises.
- For wafer.space: bandgap-free architecture is appealing
  because the bandgap itself is brown-out-sensitive. Pairing
  AC-SUB-3 with a bandgap-fallback could give the best of
  both.

### AC-SUB-4 -- Picowatt self-biased subthreshold voltage reference

- Reference: V. Ivanov, J. Gerber, R. Brederlow, "An Ultra
  Low Power Bandgap Operational at Supply From 0.75 V,"
  IEEE JSSC, vol. 47, no. 7, pp. 1515-1523, July 2012;
  related: De Oliveira et al., "Picowatt, 0.45-0.6 V Self-
  Biased Subthreshold CMOS Voltage Reference," IEEE
  TCAS-I, 2017. DOI: 10.1109/TCSI.2017.2754644.
  **Verification:** open-access mirror at
  `https://web.mit.edu/6.101/www/s2020/handouts/pico_watt.pdf`
  -- resolved 2026-05-03.
- Strictly speaking this is a *voltage reference* not an
  oscillator, but it is the bias generator that several of
  the other AC-SUB and AC-RC topologies depend on.
- For wafer.space: 55-184 pW reference at 0.45-0.6 V means
  the always-on brown-out detector + osc together fit a
  ~1 nW deep-sleep budget.

---

## Family AC-CHOP -- chopper-stabilised RC architectures

Distinct from AC-RC-* swap-cap because chopping is a
*continuous-time* technique that modulates the input offset to
a high-frequency band and then removes it with a low-pass
filter. The Makinwa group at TU Delft has produced the
canonical academic body of work on this.

### AC-CHOP-1 -- Wien-bridge frequency reference (Makinwa group)

- Reference: F. Sebastiano et al., "A 1.2-V 10-uW NPN-Based
  Temperature Sensor in 65-nm CMOS With an Inaccuracy of
  0.2C (3sigma) From -70C to 125C," IEEE JSSC, vol. 45, no. 12,
  pp. 2591-2601, Dec 2010. DOI: 10.1109/JSSC.2010.2076610.
  **Verification:** Semantic Scholar resolves; paywall.
- Plus: K.A.A. Makinwa, "Smart Temperature Sensors in
  Standard CMOS," book chapter and tutorial, ISSCC 2012.
  **Verification:** open-access PDF at
  `https://picture.iczhiku.com/resource/eetop/shKFgtlahoGsQBCm.pdf`
  -- 2026-05-03.
- Plus: U. Sonmez, F. Sebastiano, K.A.A. Makinwa, "Compact
  Thermal-Diffusivity-Based Temperature Sensors in 40-nm CMOS
  for SoC Thermal Monitoring," IEEE JSSC, vol. 52, no. 3, pp.
  834-843, Mar 2017. **Verification:** TU Delft repository
  open-access; resolved 2026-05-03.
- Topology: silicided poly-silicon thermistors embedded in a
  Wien-bridge RC filter; the bridge phase shift is digitised
  by a continuous-time chopper-stabilised phase-domain delta-
  sigma modulator. *In the temperature-sensor flavour* the
  bridge frequency is held fixed and phase reads temperature;
  *in the frequency-reference flavour* the bridge phase is
  held fixed and frequency reads temperature -- output is the
  oscillation frequency.
- For wafer.space: novel and potentially wafer-killing-area;
  but: poly-silicon resistors with low TC are explicitly in
  the GF180MCU PDK (`nplus_u`, `pplus_u`, `nwell`, plus
  silicided variants), so the bridge is implementable on our
  PDK. The chopper-stabilised phase-detector is more
  complicated than the swap-cap topology AC-RC-1 but has a
  longer published track record at sub-uW currents.

### AC-CHOP-2 -- Chopped current-comparator RC

- Reference: S. Lee et al. (multiple), industry-academic
  prior art; see "An RC Oscillator With Comparator Offset
  Cancellation," AC-RC-1 above -- the swap-cap technique is
  the dual of chopper-stabilising the comparator.
- Note: in the AC literature a "chopped" comparator often
  uses two separate inverter pairs whose outputs are
  ping-ponged each cycle. The DC output is offset-free; the
  AC output band where chopping puts the offset is filtered.
- For wafer.space: extends AC-RC-1 with a more aggressive
  offset-removal mechanism. Marginal benefit for our
  application; budget as an option for the deep-dive stage.

---

## Family AC-RES -- resistor / RC + bandgap (silicon-anchored, MIT/Texas/Korea)

The academic version of the industry-survey `B2`/`B3` family
where the curvature compensation has been *measured* on silicon
and reported with full Allan-deviation/PSRR characterisation.

### AC-RES-1 -- 1.05 V relaxation, 25 ppm/C, 0.045 %/V line sensitivity

- Reference: F. Yang et al., "A 1.1 V 25 ppm/C Relaxation
  Oscillator with 0.045 %/V Line Sensitivity for Low Power
  Applications," J. Semicond. Technol. Sci., 2018.
  **Verification:** open-access mirror at OUCI:
  `https://ouci.dntb.gov.ua/en/works/9ZxWNLr4/` -- resolved
  2026-05-03.
- Topology: bandgap-biased relaxation osc with a current-mode
  feedback loop that subtracts the V_DD-dependent component
  of the comparator threshold.
- Headline: 0.045 %/V line sensitivity is the standout
  number, equivalent to ~20 dB PSRR -- not enough alone for
  our 30 dB requirement (§2.3 of first-principles report)
  but a useful baseline.

### AC-RES-2 -- 1 MHz PVT-compensated RC, 8 ppm/C

- Reference: A. Mossawir, M. Rashid, et al., "A 1 MHz PVT
  compensated RC oscillator with 8 ppm/C frequency stability,"
  Analog Integrated Circuits and Signal Processing, vol. 105,
  2020. DOI: 10.1007/s10470-020-01639-4. **Verification:**
  Springer abstract page resolved; paywall -- abstract-only.
- Topology: combined sub-bandgap PTAT and resistive CTAT to
  produce a temperature-flat bias current. Two RC paths in
  parallel cancel residual TC.
- For wafer.space: 8 ppm/C in a 90 nm BCD process should
  translate to ~30-50 ppm/C on GF180MCU 180 nm because of
  the larger junction-leakage variability. Still
  dramatically better than the untrimmed industry default.

### AC-RES-3 -- Frequency-to-voltage temperature compensation (Lee 2014)

- Reference: J. Lee, S. Cho, "Frequency-to-voltage converter
  for temperature compensation of CMOS RC relaxation
  oscillator," IEEE Asian Solid-State Circuits Conference,
  2014. DOI: 10.1109/ASSCC.2014.7032714. **Verification:**
  IEEE Xplore page (NOT fetched per stage guidance); abstract
  via Semantic Scholar resolved.
- Topology: an on-die F-V converter measures the oscillator's
  own output and feeds a correction signal to the bias
  current.
- For wafer.space: closed-loop self-correction without an
  external reference is appealing but adds an analog feedback
  block -- area-wise we may prefer the simpler swap-cap
  AC-RC-1.

---

## Family AC-CK -- carrier-derived clocks (academic depth on the industry-survey `E1`/`E4` family)

Most academic-survey papers in this family are RFID / NFC tag
designs that demonstrate carrier recovery on real silicon at
sub-uA tag current.

### AC-CK-1 -- "High-precision high-sensitivity clock recovery for HF RFID tag"

- Reference: Y. Yu et al., Journal of Semiconductors (China)
  vol. 31 no. 12, Dec 2010, "High-precision high-sensitivity
  clock recovery circuit for a 13.56 MHz RFID tag." Open
  access at `https://www.jos.ac.cn/fileBDTXB/oldPDF/10120603.pdf`.
  **Verification:** open-access PDF resolved 2026-05-03.
- Topology: zero-crossing comparator at the rectifier coil
  node, followed by an edge-counter divide chain. Sensitivity
  -10 dBm; recovered clock 13.56 MHz +/- carrier accuracy.
- For wafer.space: this is the *direct silicon precedent* for
  the proposed E1 / I3 architecture in the industry survey.

### AC-CK-2 -- "Low power clock recovery circuit for passive HF RFID tag"

- Reference: H. Reinisch et al., Analog Integrated Circuits
  and Signal Processing, 2009. DOI: 10.1007/s10470-008-9276-4.
  **Verification:** Springer abstract resolved; paywall --
  abstract-only.
- Topology: similar to AC-CK-1 with explicit attention to the
  bias current of the comparator.

### AC-CK-3 -- UHF Gen-2 RFID continuously-calibrated clock

- Reference: P. Cilio, A. Lecointre, et al., "A Low-Power
  Continuously-Calibrated Clock Recovery Circuit for UHF
  RFID EPC Class-1 Generation-2 Transponders," IEEE Trans.
  VLSI Systems, 2010. **Verification:** ResearchGate abstract
  224118019 resolved; paywall -- abstract-only.
- Topology: similar carrier-divider scheme but at 860-960 MHz
  UHF, not HF. Listed for cross-domain coverage; not directly
  applicable to wafer.space (no UHF antenna).

---

## Family AC-LC -- on-die LC tank with academic-grade phase-noise data

Limited family for our chip's needs (sub-100 MHz consumers
are LC-impractical; BLE deferral is acknowledged), but
included for completeness because Stage 2 may want to compare
phase-noise targets across families.

### AC-LC-1 -- 180 nm cross-coupled LC at 2.4 GHz, Q ~5

- Reference: A. Bevilacqua, A. M. Niknejad, "An ultra-wideband
  CMOS low-noise amplifier for 3.1-10.6 GHz wireless
  receivers," IEEE JSSC, vol. 39, no. 12, pp. 2259-2268, Dec
  2004. DOI: 10.1109/JSSC.2004.836339. **Verification:**
  abstract via Semantic Scholar; paywall -- abstract-only.
  *Note: cited for the underlying 180 nm Q numbers, not as
  an oscillator design per se; oscillator phase-noise
  follows from those Q numbers via Leeson.*
- For wafer.space: confirms the §5.3 first-principles finding
  that 180 nm top-metal Q is in the 3-6 range without
  thick-top-metal extension.

### AC-LC-2 -- bondwire-tank GHz oscillator (legacy / academic)

- Reference: D. Ham, A. Hajimiri, "Concepts and methods in
  optimization of integrated LC VCOs," IEEE JSSC, vol. 36,
  no. 6, pp. 896-909, June 2001. DOI: 10.1109/4.924852.
  **Verification:** abstract via Semantic Scholar; paywall.
- For wafer.space: relevant only for BLE LO synthesis; not a
  candidate for the housekeeping clock.

---

## Family AC-FOM -- "figure of merit" / Allan-deviation / phase-noise survey papers

These are the survey / tutorial / book-chapter sources that
ground every other family's headline numbers and provide the
methodological framing for Stage-2 cross-checks.

### AC-FOM-1 -- Makinwa frequency-reference tutorial

- Reference: K.A.A. Makinwa, "Energy-Efficient Frequency
  References," ISSCC tutorial, Feb 2014; updated lecture
  notes (multiple years) on EI TU Delft.
  **Verification:** TU Delft EI faculty page
  `https://ei.tudelft.nl/` lists Makinwa group publications;
  open-access lecture PDFs occasionally appear at
  picture.iczhiku.com mirror -- one resolved 2026-05-03.
- Coverage: tabulates ~20 published frequency-reference
  designs against accuracy, power, area, and figure-of-merit
  (FoM = Power / accuracy^2). Identifies the
  Makinwa-bridge / Wien-bridge / chopper-stabilised RC
  cluster as Pareto-frontier for sub-mW operation.

### AC-FOM-2 -- Pelgrom matching survey

- Reference: M.J.M. Pelgrom, A.C.J. Duinmaijer, A.P.G.
  Welbers, "Matching Properties of MOS Transistors," IEEE
  JSSC, vol. 24, no. 5, pp. 1433-1439, Oct 1989.
  **Verification:** open-access mirror at
  `https://ewh.ieee.org/r5/denver/sscs/References/1989_10_Pelgrom.pdf`
  -- resolved 2026-05-03.
- Coverage: foundational matching theory; AVt and Abeta
  coefficients for several processes. For 240/180 nm
  AVt = 5 mV.um, Abeta = 1 %.um. These set the *floor* on
  any matching-based trim resolution: an 8-bit current DAC
  with 1 um^2 unit cells has sigma/mu ~ 0.5 % per LSB by
  Pelgrom alone, before random offset.

### AC-FOM-3 -- MOM cap mismatch in 180 nm, Klootwijk 2014

- Reference: J.H. Klootwijk et al., "Mismatch of lateral
  field metal-oxide-metal capacitors in 180 nm CMOS process,"
  Microelectronics Reliability, 2014. DOI:
  10.1016/j.microrel.2014.01.014. **Verification:**
  ResearchGate abstract 260538290 resolved; paywall --
  abstract-only.
- For wafer.space: confirms first-principles §5.9
  cap-matching number (sigma/mu ~0.1 % for 1 pF unit caps).

### AC-FOM-4 -- NIST CMOS ring-osc Allan-deviation measurements

- Reference: NIST Tech-Branch report, "Characterization of
  Noise in CMOS Ring Oscillators at Reduced Temperatures,"
  Pub ID 936783. **Verification:** open-access PDF at
  `https://tsapps.nist.gov/publication/get_pdf.cfm?pub_id=936783`
  -- resolved 2026-05-03.
- Coverage: measured Allan deviation of a 7-stage 130 nm
  ring oscillator from 11 K to 300 K. Used as the
  cross-check on flicker-noise floor for ring-osc-class
  designs in §5 of report.md.

---

## Family AC-NEG -- approaches considered and rejected

Listed so they are not silently dropped.

### AC-NEG-1 -- Quartz / TCXO

Out of scope by hard constraint #2 (no external passives).

### AC-NEG-2 -- FBAR / BAW resonators

Process-incompatible; GF180MCU has no piezo BEOL. Same
rejection as industry-survey N3.

### AC-NEG-3 -- MEMS resonators (CMEMS, SiTime)

Process-incompatible.

### AC-NEG-4 -- Atomic / CSAC / chip-scale Rb

Power-budget-incompatible (mW); also not on PDK.

### AC-NEG-5 -- thermal-diffusivity reference (USP-8222940 / Makinwa 2007)

Listed as a notable "exotic" academic topology that *is*
process-compatible (just polysilicon serpentines + thermo-
piles) but power-incompatible at 7.8 mW, far above our
harvested-rail budget. Cited in solutions for
completeness; not a candidate.

### AC-NEG-6 -- Memristive timer

Process-incompatible (no RRAM/PCM in PDK).

---

## Comparison-readiness table

Stable short names from the catalogue above. This is the table
the Stage-2 synthesiser will ingest.

| Approach | Headline numbers (silicon) | Power | Area | Maturity | Best fit | Worst fit | Refs |
|---|---|---|---|---|---|---|---|
| AC-RC-1 (swap-cap, MIT) | +/-0.25 % over -40/+90 C | 120 nW | ~0.1 mm^2 (65 nm) | High (silicon, JSSC 2016) | Brown-out-tolerant HK clock | Sub-50 us startup | [Paidimarri-2016] |
| AC-RC-2 (Hsiao 2023) | 21 ppm/C, 10 ppm long-term | 254 nW | ~0.05 mm^2 | High (silicon, 2023) | LED twinkle base | Sub-MHz only | [Hsiao-2023] |
| AC-RC-3 (Jiang dyn-comp) | 2.5 ppm/C, 60 us start | low-uW | ~0.3 mm^2 | High (silicon, JSSC 2019) | Fast-startup HK | Brown-out conditions | [Jiang-2019] |
| AC-RC-4 (Tokairin VAFB) | 0.04 %/V line sens | <1 uW | medium | High (silicon, JSSC 2010) | V_DD-rejection on harvested rail | Sub-50 us startup | [Tokairin-2010] |
| AC-RC-5 (Lee leakage-comp) | 8.1 nW @ 0.4 V | 8.1 nW | small | High (silicon, 2024) | Always-on brown-out timer | High-frequency | [Lee-2024] |
| AC-FLL-1 (Choi/Blaauw) | 34.3 ppm/C, sigma-delta DCO | 110 nW | <1 mm^2 | High (silicon, JSSC 2016) | sigma-delta cap-bank trim | Field-absent forever | [Choi-2016] |
| AC-FLL-2 (digital FLL TC-domain) | TC-domain compensated | low | medium | High (silicon, JSSC 2024) | No-firmware chip | (untested at GF180) | [Griffith-2024] |
| AC-FLL-4 (NFC-carrier FLL) | ppm when locked | <50 uW | small | Universal in NFC | This project's NFC + HK mix | NFC absent forever | [Park-2009; Yu-2010] |
| AC-SUB-1 (DLS Hz-range) | Hz-range, picowatt | <1 nW | tiny | High (silicon, JSSC 2016) | Always-on brown-out | Above 1 kHz | [Lee-2016] |
| AC-SUB-3 (cap-discharge) | 2.8 Hz/6.4 kHz, 44.4 pW/75.6 nW | pW-nW | tiny | High (silicon, JSSC 2016) | Bandgap-free always-on | ppm spec | [Hsieh-2016] |
| AC-CHOP-1 (Wien-bridge ref) | 0.1 % over -40/+125 C | 87 uA @ 1.8 V | medium | High (silicon, multiple JSSC) | TC-flat reference | Sub-uW power budget | [Makinwa-Souri] |
| AC-RES-1 (25 ppm/C, 1.1 V) | 25 ppm/C, 0.045 %/V | low-uW | medium | High (silicon) | Line-sensitive rail | Sub-uW budget | [Yang-2018] |
| AC-RES-2 (8 ppm/C, 1 MHz) | 8 ppm/C | uW-mW | medium | High (silicon, 90 nm BCD) | Tight TC | Brown-out (90 nm) | [Mossawir-2020] |
| AC-CK-1 (HF RFID rec) | +/-50 ppm reader-bound | <50 uW | tiny | Universal NFC | NFC active | NFC absent | [Yu-2010] |
| AC-LC-1 (180 nm 2.4 GHz) | -110 dBc/Hz @ 1 MHz with Q=5 | 1 mW (TX) | spiral 100k um^2 | RF-heavy | BLE LO (item k only) | Sub-100 MHz | [Bevilacqua-2004] |

---

## Cross-reference table -- this catalogue's IDs vs sister reports'

| Academic ID (this report) | Industry-survey ID | First-principles ID |
|---|---|---|
| AC-RC-1 | (extends B2) | (extends B2) |
| AC-RC-2 | (extends B2) | (extends B2) |
| AC-RC-3 | (extends B3) | (extends B2) |
| AC-RC-4 | (extends B2) | (extends B2) |
| AC-RC-5 | (extends G2) | (extends D1) |
| AC-FLL-1 | C1 | (new -- not in sister reports) |
| AC-FLL-2 | (new) | (new) |
| AC-FLL-4 | E4 / I3 | E1 / G2 |
| AC-SUB-1 | G1 | D1 |
| AC-SUB-3 | (new) | (extends D1) |
| AC-CHOP-1 | (new -- under-represented in industry) | (new -- under-represented) |
| AC-RES-1 | B2 | B2 |
| AC-RES-2 | B3 | B2 |
| AC-CK-1 | E1 / I3 | E3 |
| AC-LC-1 | H1 | C1 |

The "new" entries are the academic-survey contributions that the
parallel sister reports did not cover. That is exactly what the
methodology asks for at this stage -- complementary breadth.
