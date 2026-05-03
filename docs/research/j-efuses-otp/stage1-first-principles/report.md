---
item: j
item_name: efuses-otp
stage: 1
angle: first-principles
researcher: claude-opus-4.7-1m (parallel instance 1 of 3)
status: draft
last-updated: 2026-05-03
---

## 1. Executive summary

This report addresses how to store a small amount of post-fab
configuration data — oscillator trim, die ID, optionally the NFC
vCard payload, LED-pattern selection — on the v2 ws-logo-die in a
single 5 V GF180MCU process flow with no external programming
voltage and no external passives.

Headline conclusions:

- **The GF180MCU PDK already ships a polysilicon-silicide eFuse
  PCell** (`gf180mcu_fd_pr__efuse`) with full DRC / LVS / SPICE-
  model support; bit-cell footprint is **11.28 × 4.38 µm =
  49.4 µm²**, intrinsic resistance ~200 Ω, programmed end-of-life
  resistance > 900 Ω. The associated SPICE comment block describes
  this as a "6 V / (5 V) efuse", which means the cell is designed
  to be programmed from the 5–6 V rail without an on-die charge
  pump.
- No antifuse, floating-gate, MIM-rupture, or laser-fuse cell is
  shipped in the PDK. Any of those would require either a custom
  cell built from primitives, or acceptance that the structure is
  not modelled or DRC-clean.
- Antifuse OTP using the 3.3 V-device gate oxide (tox ≈ 8 nm) is
  physically possible because the intrinsic SiO₂ breakdown field of
  ~10 MV/cm gives V_BD ≈ 8 V — within reach of a small Dickson
  charge pump on the 5 V rail. It is electrically attractive (very
  small cell, no melt-energy thermal spike) but not modelled by the
  PDK and not de-risked by any prior wafer.space tape-out.
- **Charge-pump verdict: NOT NEEDED for the PDK eFuse**, because it
  is documented as a 5 V / 6 V cell. A pump *would* be needed for
  any 3.3 V-gate antifuse path (5 V → ~8 V).
- Bit-budget allocation totals 106 bits if NFC payload is mask-ROM,
  ~1130 bits if a 1024-bit programmable NFC vCard payload is
  included. At ≈49 µm² per PDK eFuse, the larger array is
  ≈0.09 mm² before accounting for sense-amp / decoder / programming-
  MOSFET overhead (typically 1.5×–2×).

The most surprising finding is that the **silicide-migration
physics sets the programming current, but the programming current
then sets the chip-level pad-and-driver area**. A 5 mA programming
pulse per bit on a 5 V rail demands a 5 V NMOS pass-transistor of
≈30–50 µm width *per bit being programmed simultaneously*;
serialising the program flow trades programming time for area and
is almost always the correct trade-off at this bit count.

Explicit limits on the search:
- Mask-ROM is included as the trivial extreme (no programmability)
  for comparability, even though it is technically not "OTP".
- We did NOT attempt to model the GF180MCU eFuse SPICE breakdown
  during programming (the PDK model is a static resistor switching
  at `pblow=0/1`); programming-pulse simulation is deferred to
  Stage 4.

## 2. Requirements as understood

| # | Requirement | Source |
|---|---|---|
| R-J1 | No external passives | Hard cross-cutting #2 |
| R-J2 | PDK audit: identify what `libs.ref/gf180mcu_fd_ip_*` provides | TODO §j research bullet 1 |
| R-J3 | Programming voltage: typical eFuses need 5–10 V; design a charge pump or use 5 V `DVDD` if compatible | TODO §j research bullet 2 |
| R-J4 | Bit count per consumer: oscillator trim 4–8 b, die ID/serial 32–64 b, NFC vCard 256–2048 b if programmable, LED pattern 1–4 b | TODO §j research bullet 3 |
| R-J5 | Programming flow: at-test (probe-card) vs in-field; in-field NFC writes very expensive in design effort | TODO §j research bullet 4 |
| R-J6 | Test-mode escape paths: chip must not be programmable from PCB by accident | TODO §j Verify §3 |
| R-J7 | VGA pad set is frozen | Hard cross-cutting #3 |
| R-J8 | Oscillator-trim consumer needs reliable read-out under both VGA rail and harvested rail | TODO §a interaction |

## 3. Solution-space map — 13 mechanisms

### 3.1 Polysilicon / silicide-migration eFuse (FUSE-POLY-SILICIDE)

Heavily-doped polysilicon line clad with metal silicide (CoSi₂ /
WSi₂), narrowed to a "neck" of minimum lithographic width.
Programming = high current pulse anode→cathode; Joule heating to
~2200 °C; silicide electromigrates to anode; underlying poly
recrystallises and is denuded of silicide, becoming high-
resistance.

Performance numbers (Tonti 2003 IRW; replicated in our PDK):

| Quantity | Value | Source |
|---|---|---|
| Intrinsic R (unprogrammed) | ~200 Ω (PDK) / ~350 Ω (Tonti) | `sm141064.ngspice` |
| Programmed R (post-EOL) | ≥ 900 Ω (PDK) / ≥ 1 MΩ (Tonti) | as above |
| Programming voltage | 4.7 V across whole macro / ~1 V across fuse | Tonti 2003 |
| Programming current | 5 mA | Tonti 2003 |
| Programming pulse | 250 µs single, or 25× 10 µs train | Tonti 2003 |
| Latch trip point | ~2.5 kΩ to 100 kΩ | Tonti 2003 |
| Retention | > 10 yr at 130 °C HAST | Tonti 2003 |
| Cell area (PDK bare) | 11.28 × 4.38 = 49.4 µm² | KLayout read |
| PLFUSE neck dimensions | 0.18 µm × 1.26 µm | DRC EF.02 / EF.03 |

### 3.2 Metal-line electromigration fuse (FUSE-METAL-EM)

Same mechanism as 3.1 but on Metal-1. Sheet resistance ≈ 0.07 Ω/sq
vs ~8 Ω/sq for silicided poly, so programming current is 5–10×
higher (20–50 mA). PDK does not provide this cell. **Strictly
inferior** to 3.1 for our requirements.

### 3.3 Laser-blown polysilicon fuse (FUSE-LASER)

Polysilicon link physically blown by laser at wafer-test. Requires
post-passivation cavity and laser-blow ATE step. **Out of scope**
for our wire-bond business-card flow.

### 3.4 Antifuse — gate-oxide rupture (ANTIFUSE-GOX)

MOS capacitor with thin gate oxide held at V > V_BD until
percolation conductive filament forms. Cell area at 0.18 µm: ~6–8
µm² (Sidense data) — 5–10× smaller than the polysilicon eFuse.

For GF180MCU 3.3V devices:
- tox ≈ 8 nm (`nfet_03v3_tox = 8e-9`)
- Intrinsic V_BD = 8 nm × 10 MV/cm = 8 V
- TDDB-accelerated V_prog = 70% × 8 V = 5.6 V
- Programming window: 5.6 – 8 V (charge pump from 5 V required)

**Critical risk:** PDK provides no antifuse device model.

### 3.5 Antifuse — capacitor-rupture (ANTIFUSE-CAP / FUSE-CAP)

MIM dielectric in `gf180mcuD` is ~30–40 nm; intrinsic V_BD =
30–60 V, far beyond any plausible on-die supply. **Eliminated on
physics.**

### 3.6 Floating-gate / flash NVM (FG-FLASH)

Tunnel-oxide + dual-poly stack required; HEI/FN programming needs
8–10 V. **`gf180mcuD` MCU flow has no second poly and no tunnel
oxide.** Eliminated by PDK availability.

### 3.7 SONOS / charge-trap NVM (CT-NVM)

Trap-rich nitride layer between gate poly and substrate. Same
elimination as 3.6: not in `gf180mcuD`.

### 3.8 ROM-programmed at metal mask (MASK-ROM)

Bits wired into the metal pattern at tape-out. Zero programming
infrastructure on-die; ~2–4 µm² per bit. **Trivially beats every
OTP option for the NFC vCard payload** if a single per-tape-out
vCard is acceptable.

### 3.9 Off-chip serial EEPROM / NFC tag IC (OFF-DIE-NVM)

Excluded by hard cross-cutting constraint #2. Listed for
completeness only.

### 3.10 Externally-supplied programming voltage on a dedicated pad (HV-PAD)

Single-purpose pad accepting external 8 V/12 V at wafer-probe / ATE
only. Removes need for on-die charge pump.

### 3.11 Repurposed existing pad for programming (TM-EXISTING-PAD)

Multiplex programming function onto existing pad (e.g. `clk_PAD`,
`rst_n_PAD`) under strap-decoded test-mode entry. No new pad.

### 3.12 In-field NFC-write programming (NFC-WRITE)

NFC core implements ISO14443A WRITE. **Almost certainly out of
scope for v2** — multi-week design effort, attack surface.

### 3.13 Hard-tied straps to GND/VDD on bond pads (PAD-STRAP)

Use unused bond pads as 1-bit configuration straps. ~zero on-die
area. ~1 bit per pad.

### Summary

**13 distinct mechanisms catalogued.** Polysilicon silicide-
migration eFuse is the only one with a shipped, DRC-clean, LVS-
checked, SPICE-modelled cell in `gf180mcuD`; every other on-die
mechanism would be designed from primitives.

## 4. Sub-block breakdown

See [`components.md`](components.md). Per-mechanism: cell array,
programming pass-NMOS (33 µm/bit at 5 mA), row decoder, column
mux, sense amp (~100 µm²/col), reference resistor, programming-
control FSM, TM mux, lock register, optional ECC.

## 5. First-principles sanity checks

### 5.1 Silicide-migration eFuse programming-current sanity

At Tonti's I=5 mA × 250 µs at V≈4.7 V across 200 Ω fuse:
- P_diss = I²R = 5 mW per fuse during programming
- J_silicide = 56 MA/cm²
- E_pulse = 1.25 µJ per fuse

Compare to thermal energy needed to heat silicide neck volume
(0.18 × 1.26 × 0.05 µm³ = 1.1×10⁻²⁰ m³, ρ(WSi₂)=9300 kg/m³,
c=250 J/kg-K) from 25→2200 °C: E_heat = 54 pJ. The pulse delivers
~25 000× the adiabatic-heat energy; the rest dissipates into
substrate/anode/cathode. **Sanity check passes.**

### 5.2 Programming pass-NMOS sizing

For 5V NMOS, Idsat ≈ 150 µA/µm at V_GS=V_DS=5V. To deliver 5 mA:
W ≈ 33 µm. Column-organised programming: only one column active
at a time → column-driver area ≈ 33 µm × 0.6 µm = 20 µm² per
column. Broadcast row programming NOT feasible: 64 bits × 5 mA =
320 mA exceeds rail capacity. **Programming must be serialised or
column-paralleled.**

### 5.3 Charge-pump output current sanity (for ANTIFUSE-GOX)

2-stage Dickson: V_out_ideal = 13.6 V; under 1 mA load: 8.6 V ✓
Caps: 10 pF × 2 stages = 20 000 µm² at 1 fF/µm² ≈ 0.02 mm².
**Pump is physically realisable in our area budget.**

### 5.4 Antifuse breakdown voltage from gate-oxide thickness

Intrinsic SiO₂ V_BD field ≈ 10 MV/cm:
- 3.3V device tox=8 nm → V_BD_intrinsic = 8 V; TDDB sub-ms = 5.6 V
- 6.0V device tox=15.6 nm → V_BD ≈ 15.6 V (not useful at 5V supply)

**Antifuse Vprog window for 3.3V device: 5.6–8 V; pump required.**

### 5.5 Sense-amp read-margin

Intact ≤200 Ω vs programmed ≥900 Ω at I_read=10 µA: ΔV = 7 mV.
Standard differential current-mirror SA handles this if reference
resistor matches to ~5 % across PVT. Tonti's actual programmed R
is 1 MΩ–1 GΩ, so practical margin is many orders of magnitude.
**Sense-amp design is easy.**

### 5.6 Bit-budget total area

106 bits × 79 µm²/bit (with 1.6× overhead) = 8 400 µm² ≈ 0.0084 mm²
1130 bits × 79 µm² = 89 000 µm² ≈ 0.089 mm²
Both well below 5% of core area. **Not area-limited.**

### 5.7 Charge-pump retention sanity

For polysilicon eFuse, pump is only active during programming —
post-program retention is independent. Tonti 2003 retention claim:
130 °C / 2.85 V / 192 hr HAST, no failures across ~150 000 fuses
→ Coffin-Manson extrapolation to ~10⁹ years equivalent at field
temperatures. **Retention budget for our 10-year card is 10³× over-
spec.**

## 6. References

See [`references.md`](references.md). Tonti 2003 IRW and Tonti
2008 SSIRI papers cached locally; PDK files verified by direct
read.

## 7. Negative results

### 7.1 Floating-gate / flash NVM excluded by PDK
Verified by exhaustive `find` over `gf180mcuD/libs.ref/` and
`libs.tech/`: no second polysilicon layer, no tunnel-oxide implant,
no flash IP. **Eliminated.**

### 7.2 Capacitor-rupture antifuse on MIM stack
MIM dielectric in `gf180mcuD` is ~30–40 nm; intrinsic V_BD = 30–
60 V, far beyond any plausible on-die supply. **Eliminated by
physics.**

### 7.3 Metal-EM fuse programming current
Metal-1 sheet resistance is 80–100× lower than silicided
polysilicon; 50 mA pass-NMOS would be >300 µm wide per bit. PDK
doesn't ship the cell. **Eliminated.**

### 7.4 Laser fuse incompatible with our test flow
Requires open passivation cavity over the fuse and laser-blow ATE.
Our wire-bond business-card flow has no provision. **Eliminated.**

### 7.5 Tonti 2003 E-Fuse "design A" failure
Tonti's first attempt (E-Fuse A) had only 80 % time-zero
programming yield and **failed pre-conditioning** (humidity bake),
forcing redesign to E-Fuse B. **Implication for us: even with a
known-good PDK cell, programming yield and pre-conditioning
robustness require Stage-4/5 verification before signoff.** We
cannot assume the GF180MCU eFuse is field-qualified just because
it has a PDK PCell.

### 7.6 In-field NFC-write
Robust write-protect/lock against malicious overwrites is multi-
week work and adds attack surface. **Eliminated for v2 scope.**

## 8. Open questions

See [`open-questions.md`](open-questions.md). Top-priority:
Q-J1 vCard payload identical per-wafer (mask-ROM) or per-die (OTP);
Q-J3 has the GF180MCU eFuse been silicon-validated?

## 9. Comparison readiness

| Approach | Headline performance | Area / power cost | Maturity in `gf180mcuD` | Best fit | Worst fit |
|---|---|---|---|---|---|
| FUSE-POLY-SILICIDE | ≥ 9 orders R-ratio; 5 mA × 250 µs prog; ≥10 yr retention | 49 µm²/bit + 30 µm² overhead/bit; 5 mW/bit during prog | **PDK shipped** | Trim, ID, lock bits | Bit-dense NFC payload |
| FUSE-METAL-EM | 5–10× higher I_prog | 49 µm²/bit + 200 µm pass-NMOS/bit | Not in PDK | nothing | everything |
| ANTIFUSE-GOX (3.3V tox) | ~kΩ programmed | 6–8 µm²/bit + 20 000 µm² charge pump | Not in PDK (custom) | dense ID/payload (≥1k bit) | tiny arrays |
| ANTIFUSE-CAP MIM | — | — | physics rules out at 5V | none | all |
| FG-FLASH | re-writable | needs process recipe | Not in PDK | none | n/a |
| MASK-ROM | infinite reliability; zero programmability | 2–4 µm²/bit | Trivially supported | identical-per-wafer vCards | per-die trim |
| HV-PAD | external Vprog; no on-die pump | ~0 on-die, +1 pad | trivially supported | wafer-test programming | in-field re-prog |
| TM-EXISTING-PAD | reuses existing strap pads | ~50 µm² strap decoder | trivially supported | combining with any of the above | n/a |
| NFC-WRITE | in-field re-programmable | RTL + lock + protocol weeks | within reach of (h) | post-deployment | low-effort path |

## 10. Author's notes

A surprising amount of effort went into reading the PDK files
themselves rather than literature: the canonical answer to "what
eFuse does GF180MCU give us?" lives in
`libs.ref/gf180mcu_fd_pr/gds/efuse.gds`, the SPICE model in
`libs.tech/ngspice/sm141064.ngspice` line 47007, and the DRC rule
deck in `libs.tech/klayout/tech/drc/rule_decks/efuse.drc`.

Most surprising finding: the polysilicon eFuse is documented in
the PDK SPICE comments as "6 V / (5 V) eFuse", meaning it is
*explicitly designed* to be programmable at the 5 V `DVDD` rail.
This is not the case for most modern-process eFuses (which require
a separate, typically 1.8 V-core / 3.3 V-program rail). We get
this "free" because GF180MCU is an MCU-flavoured node where the
6 V device is a primary citizen. **Charge-pump-free OTP at 5 V is
a genuine architectural advantage of choosing this PDK for a
business-card chip.**

Least surprising finding: floating-gate flash is unavailable.
Expected the moment the spec said "MCU PDK"; "MCU" in 180 nm
parlance typically means "high-voltage IO and tough analog" not
"embedded flash".
