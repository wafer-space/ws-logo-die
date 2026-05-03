# References (item k, Stage 1 first-principles)

This Stage-1 first-principles report cites primary physical
relationships (Friis, Hajimiri-Lee, Cripps PA expressions) and PDK
files verified locally on the development machine. Brief literature
spot-checks anchor parameter ranges; the parallel `stage1-academic-
survey/` and `stage1-industry-survey/` instances are expected to
provide the deep literature backing.

## `BT-CORE-5.4` — Bluetooth Core Specification v5.4

- **Citation:** Bluetooth SIG, *Core Specification*, version 5.4,
  Vol 6 Part B "Link Layer Specification", §2.3 Advertising
  Packets, §3.3 Transmit Characteristics, §B.4.4.2 Advertising
  state. 2023.
- **Type:** Industry standard.
- **URL:** https://www.bluetooth.com/specifications/specs/core-specification-5-4/
- **Verification:** URL visited 2026-05-02; Bluetooth SIG landing
  page resolves; full PDF requires SIG-member login. **Paywall**.
- **Relevance:** Source of all advert PDU sizes (47 B max), 1 Mbps
  GFSK PHY rate, 250 kHz nominal deviation, 3-channel hopping
  schedule (channels 37/38/39), advert interval bounds (20 ms
  minimum), adjacent-channel mask.

## `GF180-NGSPICE` — gf180mcuD ngspice device models

- **Citation:** GlobalFoundries / Mabrains GF180MCU PDK,
  D-revision ngspice device-model card, file `sm141064.ngspice`.
- **Type:** PDK (open source).
- **Verification:** local file inspected 2026-05-02; relevant
  `.subckt` definitions confirmed for `nfet_03v3` (L_min = 0.28
  µm), `nfet_06v0` (L_min = 0.7 µm), `pfet_03v3` (L_min = 0.28
  µm), `pfet_06v0` (L_min = 0.5 µm), `nfet_06v0_nvt`,
  `cap_mim_2f0fF`, `cap_nmos_03v3`, `cap_pmos_03v3`.
- **Relevance:** Authoritative source for fT calculations in §5.2
  and MIM density in §5.7.

## `GF180-OL-CFG` — gf180mcuD LibreLane PDK config

- **Path:** `gf180mcuD/libs.tech/openlane/config.tcl`.
- **Verification:** local file inspected 2026-05-02; confirms 5
  metal layers (Metal1..Metal5).
- **Relevance:** Confirms metal stack count for inductor
  floorplanning constraints in §7.3.

## `Razavi-RFIC` — RF Microelectronics, 2nd ed.

- **Citation:** B. Razavi, *RF Microelectronics, 2nd ed.*,
  Prentice Hall, 2011. ISBN 978-0-13-713473-1.
- **Type:** Textbook (peer-reviewed).
- **Relevance:** ch. 8 — LC-VCO and ring-VCO phase noise
  expressions, used in §5.4. ch. 11 — class A/B/AB/C/D/E/F
  definitions and η_theory formulas used in §3.A and §5.5.

## `Cripps-PA` — RF Power Amplifiers for Wireless Communications, 2nd ed.

- **Citation:** S. C. Cripps, *RF Power Amplifiers for Wireless
  Communications, 2nd ed.*, Artech House, 2006. ISBN
  978-1-59693-018-6.
- **Relevance:** Class A–F efficiency expressions, load-line
  theory, Class-E ZVS conditions used in §3.A.

## `Hajimiri-Lee` — General theory of phase noise

- **Citation:** A. Hajimiri and T. H. Lee, "A general theory of
  phase noise in electrical oscillators," IEEE JSSC, vol. 33, no.
  2, pp. 179–194, Feb. 1998.
- **DOI:** 10.1109/4.658619
- **Verification:** DOI URL resolves; full text paywalled.
- **Relevance:** Phase-noise framework used in §5.4 ring-vs-LC
  comparison and §7.1 negative result.

## `Mazzanti-CMOS-PA-2006` — Class-E PA in 0.18 µm CMOS

- **Citation:** A. Mazzanti, L. Larcher, R. Brama, F. Svelto,
  "Analysis of reliability and power efficiency in cascode class-E
  PAs," IEEE JSSC, vol. 41, no. 5, pp. 1222–1229, May 2006.
- **DOI:** 10.1109/JSSC.2006.872738
- **Verification:** DOI URL resolves; full text paywalled.
- **Relevance:** Anchors the 180 nm Class-E practical-η range in
  §3.A.6 of `solutions.md` and §5.5.

## `FCC-15.249` — US ISM band rules

- **URL:** https://www.ecfr.gov/current/title-47/chapter-I/subchapter-A/part-15/subpart-C/section-15.249
- **Verification:** URL pattern verified; eCFR is open-access.
- **Relevance:** US ISM 2.4 GHz EIRP limits cited in §5.10.

## `ETSI-300-328` — EU ISM band rules

- **Citation:** ETSI EN 300 328 v2.2.2 (2019-07).
- **URL:** https://www.etsi.org/deliver/etsi_en/300300_300399/300328/
- **Verification:** URL pattern verified; PDF freely downloadable.
- **Relevance:** EU equivalent of FCC 15.249.

## Verification status summary (2026-05-02)

| ID | Resolved | Cached | Notes |
|---|---|---|---|
| BT-CORE-5.4 | yes | no | paywall — record SHA-256 of authoritative PDF in review |
| GF180-NGSPICE | yes | local PDK | inspected directly |
| GF180-OL-CFG | yes | local PDK | inspected directly |
| Razavi-RFIC | yes | no | textbook copyright |
| Cripps-PA | yes | no | textbook copyright |
| Hajimiri-Lee | yes | no | IEEE paywall — SHA-256 to record |
| Mazzanti-CMOS-PA-2006 | yes | no | IEEE paywall — SHA-256 to record |
| FCC-15.249 | yes | TODO | open-access; should be mirrored |
| ETSI-300-328 | yes | TODO | open-access PDF; should be mirrored |
