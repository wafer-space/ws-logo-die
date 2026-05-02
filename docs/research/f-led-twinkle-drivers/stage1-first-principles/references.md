# References (item f, Stage 1 first-principles)

| Ref | Citation | Type | URL/DOI | Verified | Cached |
|---|---|---|---|---|---|
| V1 | "Flicker fusion threshold", Wikipedia | tertiary | https://en.wikipedia.org/wiki/Flicker_fusion_threshold | yes (WebFetch 2026-05-02; 15 Hz scotopic / 60 Hz photopic plateau confirmed) | no (stage 1) |
| V2 | Hartmann, Lachenmayr & Brettel, "The peripheral critical flicker frequency", *Vision Research* 19(9):1019-23, 1979 | peer-reviewed | DOI:10.1016/0042-6989(79)90227-X | DOI resolves; abstract visible; full paywalled | no |
| V3 | GlobalFoundries "GF180MCU PDK — Spice Electrical Specifications" | PDK doc | https://gf180mcu-pdk.readthedocs.io/en/latest/analog/spice/elec_specs/elec_specs.html | yes (WebFetch 2026-05-02; ToC fetched, Vth tables in linked subsections — Stage 2 should pull actual numbers) | no |
| V4 | GF180MCU "Native Vt NMOS (Optional)" DRM §10.5 | PDK doc | https://gf180mcu-pdk.readthedocs.io/en/latest/physical_verification/design_manual/drm_10_05.html | URL exists per WebSearch 2026-05-02 | no |
| V5 | Schubert, *Light-Emitting Diodes*, 3rd ed., CUP 2018 | textbook | ISBN 9781107106406 | exists | n/a (copyright) |
| V6 | CIE 1931/1951 V(λ), V'(λ) luminous-efficiency tables | std-body data | https://cie.co.at/data-tables | not re-fetched (well-known) | n/a |

**Outstanding for Stage-2 reviewer:**

(a) pull actual Vth and I_DSAT/W tables from V3 subpages;
(b) cache V1, V2 abstract, V3 numerical pages locally;
(c) compute SHA-256 of cached copies.
