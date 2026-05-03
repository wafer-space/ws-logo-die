---
item: j
item_name: efuses-otp
stage: 1
angle: industry-survey
researcher: claude-opus-4-7-stage1-industry-1of3
status: draft
last-updated: 2026-05-03
---

## 1. Executive summary

This report surveys the **commercial / industrial** OTP and eFuse
landscape relevant to the v2 wafer.space business-card chip on
`gf180mcuD`. Sources canvassed: foundry PDK source files (audited
locally), foundry design manual, IP-vendor product briefs
(Synopsys/Sidense, eMemory, NSCore, K-Memory/Kilopass), MCU-vendor
docs (Microchip, NXP, ST), peer-reviewed papers (industry-funded),
issued US/WO patents, and open-source PDK comparison (sky130 vs
gf180mcuD).

**Headline findings (no winner picked):**

1. **`gf180mcuD` ships a polysilicon electromigration eFuse cell as
   a primitive PCell** named `efuse` (PCell) / `eFuse_0` (Magic
   gencell) / `gf180mcu_fd_pr__efuse` (SPICE subcircuit). It is a
   **two-pin device** (`in`, `out`) with **pre-blow R<200 Ω,
   post-blow R>900 Ω**. Geometry is fully fixed by DRC (PLFUSE
   0.18 µm × 1.26 µm rectangular link, anode 1.06 µm × 2.43 µm
   with 4 contacts, cathode 2.26 µm × 1.84 µm with 4 contacts,
   total Poly2 5.53 µm). **`gf180mcuD` does NOT ship a sense-amp,
   charge-pump, programming controller, or array macro.**
2. **A second OTP path also exists in the PDK**: an `OTP_MK` mark
   layer with FET-oriented DRC rules (gate-oxide-breakdown style),
   but **no PCell or macro ships** for it.
3. **At least 11 distinct OTP families** are active in the
   industry: silicide electromigration eFuse (IBM/Kothandaraman);
   polysilicon-rupture eFuse (foundry-PDK class, including
   GF180MCU); gate-oxide-breakdown antifuse (Sidense/Synopsys
   1T-Fuse, eMemory NeoFuse, academic 2T/3T cells); MIM/capacitor-
   rupture antifuse; floating-gate / hot-carrier-injection (eMemory
   NeoBit, NSCore PermSRAM); laser-trim / laser fuse; metal-fuse
   electromigration (I-fuse).
4. **Programming-flow architectures span four cost bands.** ATE-
   only → in-package via JTAG/test-mode pads → in-system at
   functional voltage (Microchip PIC32CX-BZ uses an internal
   **1.5 V OTP-LDO** for antifuse) → in-field over wireless (NFC
   tag with EEPROM/OTP).

## 2. Requirements as understood

(Same as sister `stage1-first-principles/report.md` §2.)

## 3. Solution-space map

### 3.A Silicide / poly electromigration eFuse family

**3.A.1 `gf180mcu-poly-efuse-pdk` (PRIMARY).** Polysilicon
resistor on field oxide; narrow PLFUSE neck joins wide anode and
cathode. Built into `libs.ref/gf180mcu_fd_pr/{mag,gds}/efuse*`
(PCell `efuse`, Magic `eFuse_0`); DRC at
`libs.tech/klayout/tech/drc/rule_decks/efuse.drc` (rules EF.01–
EF.22); SPICE `.LIB efuse` of `sm141064.ngspice`.

**Disclosed numbers:**
- PLFUSE width 0.18 µm; PLFUSE length 1.26 µm.
- Pre-blow R<200 Ω, post-blow R>900 Ω.
- SPICE-library tag: "**Subcircuit model for 6V/(5V) efuse**".
- Bit-cell footprint: ~12.5 µm² of poly alone, ~50–80 µm² with
  EFUSE_MK keep-outs.

Programming numbers **not disclosed in PDK**. Per IBM patent
US7485944B2: **3.3 V preferred, up to 5 V; 10–15 mA optimal;
150–250 µs pulse**.

**3.A.2 `ibm-electromigration-efuse`.** IBM Kothandaraman lineage.
POWER5/6/9, Xbox 360 (768 fuses).

**3.A.3 `infineon-temperature-gradient-efuse`** (WO2003073503A2).
Engineered thermal gradient lowers Ipr to ~10 mA. Not expressible
in `gf180mcuD` EFUSE_MK rules → **discarded**.

**3.A.4 `metal-electromigration-fuse`.** Pure-Cu/Al fuse. Ipr
**>20× silicide** ≈ 200 mA — incompatible with on-die 5 V
programming → **discarded**.

**3.A.5 `kilopass-i-fuse-1r1d`.** 1R1D EM cell, **7.5 mA at
0.18 µm**, 1/10 of conventional eFuse. Proprietary; not on
`gf180mcuD`.

### 3.B Gate-oxide-breakdown antifuse family

**3.B.1 `sidense-1t-fuse-split-channel`** (US7402855B2). Single
transistor, **split-channel** gate oxide. Sidense/Synopsys
DesignWare antifuse OTP IP. 180 nm – 28 nm. **256 kb / 128-bit IO,
−40 to 150 °C, >10 yr retention**. Cell area ~10–20 µm² at 180 nm.
Licensed IP only.

**3.B.2 `ememory-neofuse`.** Antifuse; logic-CMOS-compatible. 65/55/
40/28 nm — **not 180 nm** (eMemory's 180 nm offering is NeoBit
instead).

**3.B.3 `academic-2t-3t-gate-ox`.** Multiple papers in standard
0.18 µm CMOS: Kim & Lee 3T cell; 2T cell at 6.5 V; 32-kb antifuse
OTP in 16-bit MCU. **Most replicable** path on `gf180mcuD` if
polyfuse fails.

### 3.C MIM / capacitor-rupture antifuse

**3.C.1 `mim-cap-rupture`** (W/Al₂O₃/Ti, W/Ta₂O₅/TaN). GF180MCU
has MIM cap option but **no MIM-rupture cell**. ~30 V programming
on `gf180mcuD` MIM stacks → **discarded**.

### 3.D Floating-gate / HCI

**3.D.1 `nscore-permsram-hci`.** Hot-carrier injection. PermSRAM-
4Kb-OTP-TSMC-180nm-G, PermSRAM-512b-OTP-IBM-180nm-G listed. Read
down to **1.0 V**, 10-yr retention. >55 M units shipped. Licensed
IP. **Discarded as turnkey**; retained as low-Vread reference.

**3.D.2 `ememory-neobit`.** 2 series pMOS, one floating-gate, CHEI.
0.5 µm – 55 nm including 180 nm. No extra masks. Licensed IP, not
in `gf180mcuD`.

**3.D.3 `single-poly-fg-otp-academic`.** ~0.95 µm² in 0.18 µm
logic process. Risky retention without extra process steps.

### 3.E Laser-fuse / laser-trim

**3.E.1 `laser-fuse-wafer-trim`.** Metal/poly link vaporised by IR
laser at wafer test. Used historically (TI laser-trim, IBM POWER4
cache repair). Incompatible with shuttle services. **Discarded**.

### 3.F MTP / Flash / EEPROM

**3.F.1 `gf180-no-flash`.** Audit confirms no flash/EEPROM in
`gf180mcuD`. **Discarded by R5**.

**3.F.2 `nfc-tag-eeprom-as-otp`.** ST25 / NTAG / Mifare integrate
EEPROM with on-die charge pump for over-the-air programming. To
copy, we'd need to design EEPROM cell + tunnelling pump + ISO-14443
write stack. **Discarded as primary**.

### 3.G Explicitly ruled out

- PIP-based antifuse — PIP not in `gf180mcuD`.
- PCRAM/PCM, ReRAM, CNT, DNA — not in `gf180mcuD`.
- ROM/mask-ROM — does not satisfy "post-fab" (flagged for Stage 2
  if "post-fab" can be relaxed for fixed payloads).

## 4. Sub-block breakdown

(See sister `stage1-first-principles/components.md`.)

## 5. First-principles sanity checks

**5.1 Polyfuse Ipr from EM threshold.** GF PDK PLFUSE 0.18 µm wide
× ~50 nm CoSi₂ thick = 9 × 10⁻¹⁰ cm². EM threshold ~10⁷ A/cm²
gives **~9 mA** — consistent with patent's 10–15 mA. ✅

**5.2 Programming-pulse energy.** 12 mA × 2 V × 200 µs =
**4.8 µJ/bit**. Adiabatic heat capacity of bare link ≈ 10⁻¹¹ J →
99.99 % conducts to substrate during pulse. Hence quasi-steady-
state heating. ✅

**5.3 Antifuse breakdown field.** 6.5 V / 3 nm thin-ox =
**22 MV/cm**, well above SiO₂ intrinsic ~10–13 MV/cm; TDDB drives
breakdown in ~ns–µs. ✅

**5.4 MIM rupture on `gf180mcuD`.** Ta₂O₅ ~30–40 nm → ~30 V to
rupture, far above `DVDD`. ✅

**5.5 Footprint vs budget.** 64 b × 80 µm² = 5 120 µm² (within
0.05 mm² budget). 2 048 b × 80 µm² = 0.16 mm² (within 1 mm²
ceiling). ✅

## 6. References

| Cite-ID | Citation | Verification |
|---|---|---|
| GF-PDK-MIM-RTD | "10.4.2 MIM Option B", `gf180mcu-pdk.readthedocs.io/en/latest/physical_verification/design_manual/drm_10_4_2.html` | WebFetch 2026-05-02 |
| GF-PDK-EFUSE-DRM | DRM 10.11 0.18um MCU eFuse Design Rules | WebFetch 2026-05-02 |
| GF-PDK-OTP-DRM | DRM 10.10 OTP design rules | WebFetch 2026-05-02 |
| KOTHANDARAMAN-2002-EDL | URL https://ieeexplore.ieee.org/document/1028987/ | URL resolves; full text paywalled |
| US 7 485 944 B2 — IBM eFuse | https://patents.google.com/patent/US7485944B2/en | Verified; Vpr 3.3V/5V, Ipr 10–15 mA, tpr 150–250 µs |
| WO 2003/073503 A2 — Infineon | https://patents.google.com/patent/WO2003073503A2/en | Verified |
| US 7 402 855 — Sidense split-channel antifuse | https://patents.google.com/patent/US7402855 | Verified |
| Synopsys 1T-Fuse | https://www.synopsys.com/dw/ipdir.php?ds=nvm_1t-bit-cell | Reachable; light on numerics |
| Sidense 180 nm BCD article | chipestimate.com | Verified — −40 to 150 °C, 256 kb, >10 yr |
| Design-reuse I-fuse OTP article | https://www.design-reuse.com/articles/35933/ | Verified — 7.5 mA @ 0.18 µm |
| eMemory NeoFuse product brief | ememory.com.tw | URL resolves; PDF binary scrape failed |
| NSCore PermSRAM ChipEstimate | chipestimate.com | Verified — 180 nm versions exist |
| Microchip PIC32CX-BZ eFuse seq | onlinedocs.microchip.com | Verified — 1.5 V OTP-LDO disclosed |
| ST25 NFC tag AN5493 | st.com | Verified — OTP block in EEPROM area |
| Wikipedia "eFuse" | en.wikipedia.org/wiki/EFuse | Verified — Xbox 360 768-bit, IBM 2004 |

## 7. Negative results

1. **`gf180mcuD` does not ship a finished OTP macro.** Only a
   single-bit `efuse` PCell. Sense amp, charge pump, programming
   controller, decoder and bit-array layout are *all* the user's
   responsibility.
2. **`gf180mcuD` defines `OTP_MK` rules but ships NO `OTP_MK` cell.**
   Section 10.10 of the design manual documents an OTP_MK marker
   layer but **no PCell, no GDS, no reference netlist**.
3. **eMemory NeoFuse not listed at 180 nm**.
4. **Sky130 OTP audit returns nothing definitive.**
   `sky130_fd_pr_reram` is ReRAM (different physics from antifuse);
   no published `sky130` antifuse OTP analogue. **Contradicts the
   brief's hint** that "sky130 has a well-documented antifuse macro."
5. **Pure-metal (Cu/Al) electromigration fuses need >200 mA per
   bit.**
6. **Capacitor-rupture (MIM) OTP requires ~30 V on `gf180mcuD`
   MIM stacks.**
7. **Microchip's 1.5 V in-system programming** is for antifuse
   gate-oxide-breakdown, **not transferable** to the GF180MCU
   polyfuse.
8. **WebFetch failed on multiple PDFs** — numbers cross-checked
   from second sources; reviewers should mirror locally.

## 8. Open questions

1. **Exact Vpr and tpr for the GF180MCU polyfuse.** SPICE library
   tags "6V/(5V) efuse" but no programming-pulse parameter.
2. **Does GF have a foundry-blessed sense amp / programming
   controller for the polyfuse?**
3. **What does OTP_MK enable?** Future feature, residue from closed
   PDK upstream, or actually intended to be filled in?
4. **Does sky130 have any OTP cross-reference?**
5. **Read margin at harvested-rail Vdd.** Polyfuse R-ratio 4.5×
   (200 → 900 Ω) ≈ 13 dB — adequate at 1.5 V if reference is
   well-trimmed.
6. **Is fixing the vCard at tape-out (mask ROM) acceptable?**
7. **Polyfuse retention at 85 / 105 / 125 °C ambient?**

## 9. Comparison readiness

| Approach | Performance (180 nm class) | Area / power per bit | Maturity in `gf180mcuD` | Best fit | Worst fit |
|---|---|---|---|---|---|
| `gf180mcu-poly-efuse-pdk` | 200 → 900 Ω; 5/6 V program; ~10–15 mA × 200 µs | ~80 µm² (incl keep-out); peak ~12 mA | **PCell shipped**; no array macro | small-bit-count post-fab config | high-density, low-V-only |
| `ibm-electromigration-efuse` | 10⁻⁵ pre-pgm defect; 10-yr 85 °C | ~1–2 µm² @ IBM 90 nm | identical physics, no PCell | sense-amp / programming reference | direct re-use without GF PCell |
| `sidense-1t-fuse` | 6.5–8 V program; 256 kb arrays; −40 to 150 °C | ~10–20 µm² @ 180 nm | not in PDK | high-density secure key storage | open-source / no-IP-licence |
| `academic-2t-3t-gate-ox` | 6.5 V program; std 0.18 µm CMOS | ~100 µm² per 3T | not in PDK; matches OTP_MK | replicable OTP if polyfuse fails | small area |
| `nscore-permsram-hci` | 1.0 V read; 10-yr; 55 M+ ship | proprietary, ~µm² | not in PDK | ultra-low-V read | open-source |
| `single-poly-fg-otp-academic` | ~0.95 µm² @ 0.18 µm; FN tunnelling | ~1–10 µm² | not in PDK | smallest area | retention without extra masks |
| `mim-cap-rupture` | filament forms | n/a; 30 V on GF | not in PDK | research | `gf180mcuD` directly |
| `metal-em-fuse` | >200 mA per bit | n/a | not in PDK | extreme reliability | low-current chips |
| `i-fuse-1r1d` | 7.5 mA @ 0.18 µm | proprietary | not in PDK | automotive | open-source replication |
| `laser-fuse` | wafer-only programming | needs laser tool | not in PDK | mass-production with laser-fab | shuttle-class |
| `nfc-tag-eeprom-as-otp` | sub-µW write; rewriteable | needs EEPROM (not in PDK) | not in PDK | post-deploy field updates | minimum-effort designs |

## 10. Author's notes

**Surprises.** (a) GF180MCU polyfuse PCell is **drawn but not
characterised** in the open PDK — treating it as a finished IP
block is a category error; it is a primitive like the BJTs.
(b) The PDK has *both* a populated `efuse.drc` (poly fuse) **and**
a populated `otp_mk.drc` (gate-oxide-breakdown OTP), but no
`OTP_MK` PCell; this looks like an unfilled invitation slot.
(c) The "in-field NFC-write" path is much worse than expected —
even Microchip's tightest in-system flow needs an on-die LDO and a
multi-step sequence; doing the same over a 13.56 MHz field with
sub-mW power is a non-starter without a real EEPROM. **Strong
signal**: v2 chip should burn its OTP at probe-test only. (d) The
brief's mention of a "well-documented sky130 antifuse macro"
appears to confuse antifuse with ReRAM.

## Three things others may miss

1. The "OTP_MK" DRC rules in `gf180mcuD` describe a **second,
   gate-oxide-breakdown OTP cell that the PDK does not actually
   ship a PCell for** — easy to overlook.
2. The GF polyfuse SPICE library is tagged "6V/(5V) efuse" — i.e.
   **6 V is the *intended* programming voltage**, not 5 V; the
   existing 5 V `DVDD` rail is the *minimum* and a small ~5→6 V
   cap-pump may be needed.
3. **In-field over-NFC writing of OTP is an order-of-magnitude
   harder than the brief implies** — Microchip's tightest flow
   uses a 1.5 V on-die OTP-LDO and a multi-step sequence even
   *with* a wired host. **Burn at probe-test only.**
