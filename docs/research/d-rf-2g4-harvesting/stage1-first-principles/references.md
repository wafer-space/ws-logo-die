# References (item d, Stage 1 first-principles)

## R1 — GlobalFoundries GF180MCU PDK, Native-Vt NMOS device specifications

- **Citation:** GlobalFoundries / Google / Efabless, *GF180MCU
  Open-Source PDK Documentation*, "4.0 Native Vt transistor (6V)
  — Electrical Specifications", `gf180mcu-pdk.readthedocs.io`,
  accessed 2026-05-02.
- **URL:** https://gf180mcu-pdk.readthedocs.io/en/latest/analog/spice/elec_specs/elec_specs_4.html
- **Type:** Process datasheet (open-source PDK documentation).
- **Verification status:** **VERIFIED 2026-05-02** by WebFetch.
  Page returned the exact threshold-voltage table cited:
  > "VT0 (@Vds=0.1V, Vgs at Ids maximum Slope, Vt0=Vgs_intercept-0.5*Vds)"
  > with W/L = 10/1.8 shows values of -0.32 V (minimum), -0.12 V
  > (typical), 0.08 V (maximum).
- **Local cache:** Not yet cached; recommend Stage-2 reviewer to
  mirror under `references-cache/R1/`.
- **Relevance:** Native-Vt NMOS Vth typical ~ -0.12 V — sets
  per-stage gain in §5 calculations and topology-S2/S4
  viability.

## R2 — Awad et al., MDPI Sensors 2022, fully-integrated 2.4 GHz ambient RF harvester

- **Citation:** Awad et al., "A Fully-Integrated Ambient RF
  Energy Harvesting System with 423-µW Output Power", *Sensors*
  (MDPI), 22(12), 4415, 2022. DOI: 10.3390/s22124415.
- **URL:** https://www.mdpi.com/1424-8220/22/12/4415 (returned
  403 on direct fetch); mirrored at
  https://pmc.ncbi.nlm.nih.gov/articles/PMC9227311/
- **Type:** Peer-reviewed journal paper (open-access, MDPI / PMC).
- **Verification status:** **VERIFIED 2026-05-02** by WebFetch on
  the PMC mirror. Cited numbers confirmed:
  > "Operating Frequency: 2.4 GHz. Input RF Power for 423 µW
  > Output: 0 dBm (1 mW). Peak RF-to-DC Efficiency: 21.15% @0 dBm
  > at a 3.3 kΩ load. Rectifier Topology: 3 × 3 stage differential
  > cross-coupled rectifier cascaded ... combined with a 6-stage
  > charge pump."
- **Relevance:** η-vs-P_in scaling anchor in §5.4. The 21.15%
  figure is the SOTA peak at 0 dBm; this report's η ∝ P_in
  extrapolation is *anchored* at this value.

## R3 — Pinuela et al., "Ambient RF Energy Harvesting in Urban and Semi-Urban Environments", IEEE TMTT 2013

- **Citation:** M. Pinuela, P. D. Mitcheson, S. Lucyszyn, *IEEE
  Transactions on Microwave Theory and Techniques*, vol. 61, no.
  7, July 2013.
- **URL:** https://www.imperial.ac.uk/media/imperial-college/faculty-of-engineering/electrical-and-electronic-engineering/public/optical-and-semiconductor-devices/pubs/2013_07_TMTT.pdf
- **Verification status:** **VERIFICATION PARTIAL** — WebFetch
  returned the binary PDF unreadable in transit. Cited
  numerical envelope (-60 to -14.5 dBm/m² in 680 MHz–3.5 GHz,
  average -12 dBm/m² broadband) is reproduced from web-search
  snippets, *not* from a verified read of the PDF. Stage-2
  reviewer must independently verify against the original.
- **Relevance:** *Broadband ambient RF* harvesting (without a
  clearly-identifiable nearby transmitter) yields nW total —
  supports this report's conclusion that the project depends on
  proximity to a *specific* AP.

## R4 — Wikipedia, Friis transmission equation

- **URL:** https://en.wikipedia.org/wiki/Friis_transmission_equation
- **Type:** Encyclopaedic summary (used only for the equation
  form).
- **Verification status:** **VERIFIED 2026-05-02** by WebFetch.
- **Relevance:** Definitional. Used in §5.1.

## R5 — Standard textbook for kTB and Chu-Harrington — *non-cited primary*

- **Citation envelope:** Pozar, *Microwave Engineering*, 4th ed.,
  Wiley 2011 (kTB derivation, Chu-Harrington discussion);
  Balanis, *Antenna Theory*, 4th ed., Wiley 2016 (Chu-Harrington
  Q-bandwidth limits for electrically-small antennas).
- **Verification status:** Not webfetched (textbooks). Numbers
  (kT = -174 dBm/Hz; Chu-Harrington Q ≥ 1/(ka) + 1/(ka)³) are
  textbook-standard and not in dispute.
- **Relevance:** §5.2 (Chu-Harrington), §5.3 (kTB).

## R6 — Kotani, Sasaki, "High Efficiency CMOS Rectifier Circuit with Self-Vth-Cancellation and Power Regulation Functions for UHF RFIDs", A-SSCC 2007

- **Verification status:** **NOT VERIFIED in this report.** Cited
  by name only as the canonical "aux-bias threshold cancellation"
  reference. Stage-2 reviewer must verify DOI and URL.
- **Relevance:** §3.A.5 / §3.B / S4 (`dickson-aux-bias-
  bootstrap`). Topology origin reference.

## Verification status summary

| Ref | Status | Action for Stage-2 reviewer |
|---|---|---|
| R1 | VERIFIED | Mirror PDK page locally |
| R2 | VERIFIED | Mirror PMC version locally |
| R3 | PARTIAL | Re-fetch PDF, verify numbers, compute SHA-256 |
| R4 | VERIFIED | Optional: snapshot Wikipedia page |
| R5 | NOT WEBFETCHED | Out of scope (textbooks) |
| R6 | NOT VERIFIED | Verify DOI, mirror PDF |
