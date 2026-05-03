# Architectures / topologies surveyed — academic-survey angle

Index of every distinct architecture catalogued in this
report, with stable short names and one-line descriptions.
Detail is in `report.md` §3 and `components.md`. This file
is the *handoff index* for Stage-2 synthesis.

## Level-shifter topology families (D-family, per industry-survey naming)

| Short name | Class | Anchor reference(s) | Process / measurement |
|---|---|---|---|
| TC-1 DCVS | cross-coupled CMOS, no bias | Rabaey 2009 (textbook), LS-WIECK2010 | textbook; failure mode at sub-Vt VIN |
| TC-2 Wilson | current-mirror low-VIN | LS-LUT2010, LS-HOSS2014 | 130 nm CMOS, measured silicon, ~190 mV min VIN |
| TC-3 RCC | regulated cross-coupled hybrid | LS-KAB2019 (corrected from LS-KAB2019 (corrected from HOSS2019 2026-05-04 per reviewer-1) 2026-05-04 per reviewer-1; actual paper is Kabirpour & Jalali TCAS-II 2019, not Hosseini TVLSI 2019; see references.md) (TVLSI) | **180 nm CMOS, post-layout sim**, 80 mV → 1.8 V, 123 nW |
| TC-4 HV-up | bootstrap-capacitor 1.8 V→32 V | LS-TANG2014 (Berkeley TR) | measured silicon, 0 nA static, 16 ns / 8.2 ns |

## Retention / power-gating families (E-family)

| Short name | Class | Anchor reference(s) | Status on GF180MCU |
|---|---|---|---|
| TC-5a MTCMOS-FF | high-Vt header + low-Vt logic | PG-MUTOH1995 (JSSC) | structurally inaccessible (single-Vt PDK) |
| TC-5b Soft-iso FF | weak-keeper passive retention | LS-WIECK2008 (ISLPED) | structurally inaccessible (multi-Vt assumption) |
| TC-5c Glitch-free FF | master-slave iso during rail collapse | PG-SHIN2009 | structurally inaccessible (PD-SOI) |

## Cold-start cross-domain handshake (system-level)

| Short name | Class | Anchor reference(s) | Process / measurement |
|---|---|---|---|
| TC-6a 220 mV cold-start | inductor peak-I + RF kick | MD-SHRIV2015 (JSSC) | 130 nm CMOS, measured silicon |
| TC-6b 35 mV TEG cold-start | mechanical kick + transformer | MD-RAMA2011 (JSSC) | 0.35 µm CMOS, measured silicon |

## Latch-up / substrate isolation (D family per industry-survey, "TC-extra" here)

| Short name | Class | Anchor reference(s) | Status |
|---|---|---|---|
| TC-X-1 PCOMP guard | passive P+ guard ring around HARV core | LU-VOLD2007 (textbook) | mature; layout-only |
| TC-X-2 DNW tub | DNW-isolated HARV NMOS bodies | LU-VOLD2007 ch. 9 | layout-only; uses GF180MCU DNWELL |
| TC-X-3 active guard | comparator + injection compensation | LU-TSAI2015 (TED) | fallback if TC-X-1/2 insufficient |
| TC-X-4 mixed-V parasitic-NPN warning | layout caveat on naïve guard | LU-CHEN2021 | **negative result; design-rule constraint** |

## Process-flow / cell-library context

| Short name | Class | Anchor reference(s) | Relevance |
|---|---|---|---|
| TC-Y-1 UPF v4.0 | formal multi-domain semantics | UPF-IEEE1801 | LibreLane consumes; gf180mcuD has no cells to point UPF at |
| TC-Y-2 Caravel sky130 multi-domain | open-source 4-domain harness | CA-EFAB2024 | reference design; reveals what GF180MCU PDK is missing |

## Cross-walk to industry-survey families (for Stage 2)

| industry-survey family | academic-survey TC | agreement? |
|---|---|---|
| A.1 hard-split rails | (system-level — both reports treat as default) | yes |
| A.2 AON-island | TC-6 cold-start handshake (similar concept) | yes |
| B.1 clamp-low / B.2 clamp-high / B.3 clamp-latch / B.4 mux-iso | (not covered in academic-survey — straightforward logic) | n/a |
| C.1 cross-coupled DCVS | TC-1 + TC-3 (RCC is augmented C.1) | yes |
| C.2 Wilson mirror | TC-2 | yes (same paper anchor) |
| C.3 half-latch | (subset of C.1 — academic survey did not separate) | minor |
| C.5 self-biased wide-range | (academic-survey treated under TC-2/3 umbrella) | partial |
| D.1 back-to-back diodes | TC-X-1/2 (substrate guard rings) | partial — different aspect |
| D.4 DNW substrate guard | TC-X-2 | yes |
| E.1 PMOS-header MTCMOS+RFF | TC-5a (Mutoh-FF) | yes — both say "structurally absent" |
| E.2 NMOS-footer | TC-5a footer variant — same conclusion | yes |

**No silent drops in this academic survey:** every approach
the searcher considered is named here. Approaches dropped
with a one-line reason are at the bottom of `report.md` §3
("Discarded with stated reason").
