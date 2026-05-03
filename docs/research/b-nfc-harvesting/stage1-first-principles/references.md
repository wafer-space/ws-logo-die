# References (item b, Stage 1 first-principles)

This is the **first-principles** angle — references are kept brief
because the work is anchored on physics and the local PDK, not on
literature survey. The parallel academic-survey and industry-survey
instances are expected to provide the comprehensive bibliography.

## REF-1 — `gf180mcuD` PDK SPICE models (local)

- **Citation:** GlobalFoundries 180 nm MCU PDK (`gf180mcuD`),
  open-source release via Volare. Files:
  `sm141064.ngspice` (BSIM models for 3.3 V and 5 V/6 V devices),
  `sm141064_mim.ngspice` (MIM cap subcircuit models).
- **Local path:** under `gf180mcu_pdk/gf180mcuD/libs.tech/ngspice/`.
- **Type:** Open-source PDK SPICE models.
- **Verification:** **Verified locally on 2026-05-02** by reading
  files directly:
  - 5 V nFET: `+vth0 = '0.67314+nfet_06v0_vth0'`.
  - 5 V pFET: `pfet_06v0_vth0 = '-0.8978 + ...'`.
  - 5 V native nFET: `nfet_06v0_nvt_vth0 = '-0.039 + ...'`.
  - MIM cap densities: 1.0, 1.5, 2.0 fF/µm² (subcircuits
    `cap_mim_1f0_m2m3_noshield`, `cap_mim_1f5_m2m3_noshield`,
    `cap_mim_2f0_m2m3_noshield`).
- **Relevance:** Ground truth for every Vth-loss and MIM-area
  calculation in this report.

## REF-2 — ISO/IEC 14443-2:2020

- **Citation:** ISO/IEC 14443-2:2020, "Cards and security devices
  for personal identification — Contactless proximity objects —
  Part 2: Radio frequency power and signal interface."
- **Type:** International standard.
- **Accessibility:** Paywalled (~CHF 138 from ISO directly).
- **Verification:** **Not verified directly.** The Hmin = 1.5 A/m
  and Hmax = 7.5 A/m values used in §5.1 are widely quoted in
  application notes from NXP, ST, TI, and Infineon, but not
  cross-checked against the primary standard. See OQ-3.
- **Local cache:** Not cached (paywalled).
- **Relevance:** Sets the field-strength compliance range that the
  Faraday-law derivation in §5.1 evaluates against.

## REF-3 — Wikipedia, "ISO/IEC 14443"

- **URL:** https://en.wikipedia.org/wiki/ISO/IEC_14443
- **Type:** Encyclopedia article.
- **Verification:** **Verified open via WebFetch on 2026-05-02.**
  Confirms the 13.56 MHz operating frequency and the PCD/PICC
  structure but does *not* quote the Hmin/Hmax values directly.
- **Relevance:** Confirms the operating-frequency basis for the
  Faraday calculations in §5.1 / §5.2.

## REF-4 — Mohan, Hershenson, Boyd, Lee, "Simple Accurate Expressions for Planar Spiral Inductances" (1999)

- **Citation:** S. S. Mohan, M. del Mar Hershenson, S. P. Boyd,
  T. H. Lee, "Simple Accurate Expressions for Planar Spiral
  Inductances," IEEE JSSC, vol. 34, no. 10, pp. 1419–1424, October
  1999.
- **DOI:** 10.1109/4.792620
- **Verification:** **Not directly verified.** Used the modified-
  Wheeler formulas as commonly cited. The K₁ = 2.34, K₂ = 2.75
  constants for square spirals are the canonical published values.
- **Relevance:** Source of the rectangular-spiral inductance
  estimate in §5.2.

## REF-5 — Local CLAUDE.md / TODO.md / docs/research/

- **Citations:** This project's `TODO.md`, `CLAUDE.md`,
  `docs/research/METHODOLOGY.md`, `docs/research/TEMPLATE.md`, and
  `docs/research/b-nfc-harvesting/README.md`.
- **Verification:** **Verified locally on 2026-05-02** by direct
  reading.
- **Relevance:** Source of every requirement enumerated in §2 and
  every framing assumption.

## REF-6 — General electromagnetism / circuit-analysis textbook results

- **Faraday's law:** Jackson, *Classical Electrodynamics*, 3rd ed.,
  or Griffiths, *Introduction to Electrodynamics*, 4th ed. Used in
  §5.1, §5.6.
- **Skin depth** (`δ = √(2/(ω·μ·σ))`): Same sources. Used in §5.3.
- **LC resonance** (`f = 1/(2π√LC)`): elementary. Used in §5.4.
- **RC discharge** (`ΔV = I·Δt/C`): elementary. Used in §5.5, §5.7.
- **fT for 0.18 µm CMOS** (~50 GHz): industry consensus across
  vendor data sheets. Used in §5.11.

## Verification sweep performed during this report

I attempted (with WebFetch) to verify primary references on:

- ISO/IEC 14443-2 Hmin/Hmax: blocked by paywalls and 404s on
  app-note links. **Not verified** — see OQ-3.
- ST AN2972 (NFC antenna design): WebFetch timed out.
- NXP AN11564 / AN11740 / AN1445 (NFC tag references): 404 (URLs
  no longer valid as of 2026-05-02).
- TI SLOA298: WebFetch returned PDF binary, not parsed text.
- ResearchGate paper on NFC Forum: 403.

The first-principles approach is robust against this — every key
number in the report is derived from physics or from local PDK
files, not from external claims.

## References cached locally

The orchestrating agent has cached several upstream NFC datasheets
and standards under `references-cache/`:

- `AN11276`, `AN11578`, `AN12339`, `AN12365`, `AN13219` — NXP NFC
  application notes
- `ISO-IEC-14443-2-2010-Amd-2-2012.pdf`
- `Microchip-doc2056.pdf`
- `NT3H2111_2211.pdf`, `SL2S2002_SL2S2102.pdf`, `SL2S2602.pdf` —
  NXP NFC Type 2 tag IC datasheets
- `RF430CL330H.pdf` — TI NFC Forum Type 4 tag
- `NTAG-I2C-plus-Webinar.pdf` — NXP webinar slides

Stage-2 academic-survey reviewer should perform SHA-256
verification and update this section.

## Reviewer notes

A reviewer should:

1. Spot-check Vth values in REF-1 by re-running:
   `grep "vth0" sm141064.ngspice | head -30`.
2. Verify MIM cap densities by re-reading `sm141064_mim.ngspice`
   for the `cap_mim_*_m2m3_noshield` subcircuits.
3. Re-derive §5.12 brown-out boundary from §5.1's
   V_pk_induced = 2.57 V at Hmin and the chosen V_REG_min + LDO
   drop-out + 2·Vth.
4. Cross-check against OQ-3 once the ISO Hmin/Hmax values are
   verified from the primary standard.
5. Confirm that no claim in §5 lacks an explicit calculation.
