# References (item c, Stage 1 first-principles)

## [QI-PC0-v1.2.3a] Wireless Power Consortium Qi Specification

- **Citation:** Wireless Power Consortium, *The Qi Wireless Power
  Transfer System Power Class 0 Specification, Parts 1 and 2:
  Interface Definitions*, Version 1.2.3 (April 2017 / amended
  2017).
- **Type:** Industry-consortium specification (PDF).
- **URL:** https://faculty-web.msoe.edu/johnsontimoj/EE4980/files4980/Qi-PC0-part1&2-v1.2.3a.pdf
  (publicly-accessible course-mirror copy of a WPC document).
- **Verification:** **VERIFIED 2026-05-02.** Fetched via
  `WebFetch`, downloaded as a 3.91 MB PDF, converted to text via
  `pdftotext`, read for §§5.1.2.1–5.1.2.6 (state machine), Table 8
  (ping timing), §11.2 (FOD without extensions). All numbers cited
  in the report are verbatim from the spec.
- **Local cache:** `references-cache/wpc-qi-pc0-v1.2.3a/Qi-PC0-part1-2-v1.2.3a.pdf`
  (3 906 798 bytes, SHA-256
  `d1b0b056ede9a5c14083e9b73fd224a57b22722b36ed510c5edd8b0c13bda1d9`).
- **Relevance:** Primary specification. Defines `t_ping = 65 ms`,
  `t_terminate ≤ 28 ms`, `t_first ≤ 20 ms`, `t_expire ≤ 90 ms`,
  `t_restart = 500 ms`, `P_received` accuracy +0/−350 mW. Also
  defines operating frequency 87–205 kHz.

## [GF180MCU-PDK-D] GF180MCU Open-Source PDK

- **Citation:** GlobalFoundries / Mabrains / efabless, GF180MCU
  Open Source Process Design Kit, version `gf180mcuD`. Volare-
  managed install at commit
  `18dbe6102a36303bb8942b490efb0f33d2815bdb`.
- **Type:** Vendor PDK, open-source.
- **URL:** https://github.com/google/gf180mcu-pdk
- **Verification:** **VERIFIED 2026-05-02 by local install
  inspection.** PDK files at
  `~/.volare/volare/gf180mcu/versions/.../gf180mcuD/`. The
  `libs.tech/ngspice/sm141064.ngspice` model file lists native 6 V
  NMOS `nfet_06v0_nvt` with parameter `nfet_06v0_nvt_vth0 =
  '-0.039'`, MIM caps with 1.0 / 1.5 / 2.0 fF/µm² densities, 6 V /
  20 V tolerances.
- **Relevance:** Establishes feasibility of every device used in
  rectifier and regulator topologies.

## [BUSINESS-CARD-WPS-v0.1] Companion-PCB wireless-power survey

- **Citation:** Wafer.space business-card PCB design notes,
  `business-card/docs/research/wireless-power-survey.md`.
- **Type:** Internal research document.
- **Verification:** **VERIFIED 2026-05-02** by direct read at
  `/home/tim/github/wafer-space/business-card/docs/research/wireless-power-survey.md`.
- **Relevance:** Companion-PCB constraints (coil dimensions, layer
  assignments) and a comparison table of wireless-power protocols.

## [WHEELER-MOHAN] Spiral inductance formulas

- **Citation:** Mohan, S. S., del Mar Hershenson, M., Boyd, S. P.,
  & Lee, T. H. (1999). *Simple Accurate Expressions for Planar
  Spiral Inductances.* IEEE Journal of Solid-State Circuits, 34(10),
  1419–1424.
- **DOI:** 10.1109/4.792620
- **URL:** https://web.stanford.edu/~boyd/papers/inductance_expressions.html
  (preprint mirror); IEEE Xplore for canonical version.
- **Verification:** **NOT FETCHED.** Cited only for K_1 = 2.34,
  K_2 = 2.75 modified-Wheeler coefficients used in §5.1. These are
  the industry-standard values quoted in Razavi textbooks.
  Recommended Stage-2 verification.
- **Relevance:** Provides the inductance estimator used to derive
  L = 6.2 µH for the 8T 56×40 mm PCB coil.

## [TODO] Project TODO

- **Citation:** This repository's own `TODO.md` (root-level).
- **Verification:** **VERIFIED 2026-05-02** by direct read.
- **Relevance:** §2 requirements derive from item (c) and the
  Hard Cross-cutting Constraints.
