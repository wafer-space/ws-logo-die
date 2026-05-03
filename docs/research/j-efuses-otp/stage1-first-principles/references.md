# References (item j, Stage 1 first-principles)

## Primary — silicide-migration eFuse physics

### TONTI-2003-IRW
- **Citation**: W. R. Tonti, J. A. Fifield, J. Higgins, W. H.
  Guthrie, W. Berry, C. Narayan, "Product Specific Sub-Micron
  E-Fuse Reliability and Design Qualification", *2003
  International Reliability Workshop Final Report* (IEEE),
  pp. 36–40, 2003.
- **Type**: peer-reviewed conference paper (IRPS satellite
  workshop)
- **URL**: https://www.bunniestudios.com/blog/images/efuse2.pdf
- **Verification**: URL fetched 2026-05-02; content read in full.
- **Local cache**: `references-cache/tonti-2003-irw/product-specific-submicron-efuse.pdf`
- **SHA-256**: `f7fbeff73c5baca89aa17463cecafbb12252508cca21e1279faaee3779a054ef`
- **Relevance**: The single most important reference for this
  report. Provides programming-current (5 mA), pulse-width
  (250 µs single or 25× 10 µs train), program voltage (4.7 V),
  reliability-stress results (no failures across 150 000 fuses at
  130 °C HAST), and the E-Fuse-A failure-mode discussion.

### TONTI-2008-SSIRI
- **Citation**: W. R. Tonti, "eFuse Design and Reliability", *IEEE
  SSIRI / IEEE Reliability Society educational article*, 2008.
- **URL**: https://ssiri08.techconf.org/Tonti_SSIRI_eFuse_V2.pdf
- **Verification**: URL fetched 2026-05-02; content read in full.
- **Local cache**: `references-cache/tonti-2008-ssiri/efuse-design-and-reliability.pdf`
- **SHA-256**: `ea30b8e85542ef2dc6089739ebde71ff6e3538576b8a2dafb80de0842361e1d2`
- **Relevance**: complements Tonti 2003 with broader context on
  eFuse physics, latch-trip-point selection, and 9-orders-of-
  magnitude R-ratio.

### KOTHANDARAMAN-2002-EDL
- **Citation**: C. Kothandaraman, S. Iyer, S. S. Iyer,
  "Electrically programmable fuse (eFUSE) using electromigration
  in silicides", *IEEE Electron Device Letters*, vol. 23, no. 9,
  pp. 523–525, Sep 2002.
- **DOI**: 10.1109/LED.2002.802657
- **Verification**: URL https://bunniestudios.com/blog/images/efuse.pdf
  fetched 2026-05-02; PDF saved but text extraction failed (binary).
- **Relevance**: original paper that established silicide-
  migration eFuse as a CMOS technology element.

## Secondary — process & PDK

### GF180MCU-PDK
- **Citation**: GlobalFoundries / Google, "GF180MCU Open PDK",
  https://github.com/google/gf180mcu-pdk, version
  `40cee970d8a9b7eaea35a34fe7d6068f05721f0a`.
- **Verification**: local mirror inspected directly. eFuse cell
  files identified:
  - `libs.ref/gf180mcu_fd_pr/gds/efuse.gds` (49.4 µm² footprint)
  - `libs.ref/gf180mcu_fd_pr/mag/efuse_cell.mag`
  - `libs.tech/ngspice/sm141064.ngspice` line 47007 (SPICE model:
    "6 V / (5 V) eFuse" with `pblow=0/1` static resistor switch)
  - `libs.tech/klayout/tech/drc/rule_decks/efuse.drc` (22 rules,
    EF.01–EF.22b)

### GF180MCU-PDK-DRM-EFUSE
- **Citation**: GlobalFoundries, "10.11 0.18um MCU eFuse Design
  Rules", *GF180MCU PDK documentation*.
- **URL**: https://gf180mcu-pdk.readthedocs.io/en/latest/physical_verification/design_manual/drm_10_11.html
- **Verification**: URL fetched 2026-05-02.
- **Relevance**: confirms PLFUSE 0.18 × 1.26 µm; cathode 2.26 ×
  1.84 µm with 4 contacts; anode 1.06 × 2.43 µm with 4 contacts.

## Secondary — antifuse / charge-pump

### CHIPESTIMATE-SIDENSE-2007
- **URL**: https://www.chipestimate.com/1T-OTP-Memory-Delivering-Quality-and-Reliability/Sidense-a-part-of-Synopsys/Technical-Article/2007/12/18
- **Verification**: URL fetched 2026-05-02.
- **Relevance**: industry context for ANTIFUSE-GOX architecture.

### TDDB-WIKIPEDIA-2025
- **URL**: https://en.wikipedia.org/wiki/Time-dependent_gate_oxide_breakdown
- **Verification**: URL fetched 2026-05-02.
- **Relevance**: confirmation of the SiO₂ breakdown-field figure
  (10 MV/cm) used in §5.4 of the report.

### SUEHLE-CHAPARALA-1998
- **URL**: https://web.ece.ucsb.edu/Faculty/Banerjee/pubs/IEDM_1998.pdf
- **Verification**: URL surfaced via search; **needs verification
  by next reviewer.**

### DICKSON-180NM-2018
- **URL**: https://ieeexplore.ieee.org/document/8354067
- **Verification**: WebFetch returned HTTP 418; **needs verification
  by next reviewer with IEEE access.**

## Cross-cutting / methodology

### TODO-MD
- **Path**: `/home/tim/github/wafer-space/ws-logo-die/TODO.md`
  §(j)
- **Verification**: source of all R-J1 … R-J8 requirements.

### METHODOLOGY-MD
- **Path**: `docs/research/METHODOLOGY.md`
- **Verification**: source of report-structure requirements.

## References cited but not yet verified (for Stage-2)

- A. Kalnitsky et al., "CoSi₂ integrated fuses on polysilicon for
  low voltage 0.18 µm CMOS applications", IEDM 1999 — directly
  relevant to our 0.18 µm node.
- C. Tian et al., "Reliability Qualification of CoSi₂ Electrical
  Fuse for 90 Nm Technology", IEEE IRPS 2006.
- E. G. Colgan et al., "Formation and stability of silicides on
  polycrystalline silicon", Materials Science and Engineering, R16,
  No. 2, Feb 1996.

## Verification status summary

| Reference | URL fetched | Locally cached | Content verified |
|---|---|---|---|
| TONTI-2003-IRW | yes (2026-05-02) | yes (SHA-256 recorded) | yes (read in full) |
| TONTI-2008-SSIRI | yes (2026-05-02) | yes (SHA-256 recorded) | yes (read in full) |
| KOTHANDARAMAN-2002-EDL | yes (mirror) | yes (binary only) | partial (snippets) |
| GF180MCU-PDK | local mirror | local mirror | yes (filesystem) |
| GF180MCU-PDK-DRM-EFUSE | yes (2026-05-02) | no (web only) | yes (cross-checked) |
| CHIPESTIMATE-SIDENSE-2007 | yes (2026-05-02) | no | partial |
| TDDB-WIKIPEDIA-2025 | yes (2026-05-02) | no | yes (number confirmed) |
| SUEHLE-CHAPARALA-1998 | no | no | **NEEDS REVIEWER** |
| DICKSON-180NM-2018 | no (HTTP 418) | no | **NEEDS REVIEWER (IEEE access)** |
