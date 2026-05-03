# Solutions catalogue (item j, Stage 1 first-principles)

## OTP storage mechanisms (the bit cell itself)

### FUSE-POLY-SILICIDE — Polysilicon-silicide migration eFuse
- **Bit cell**: PDK PCell `gf180mcu_fd_pr__efuse` (49.4 µm²)
- **Mechanism**: silicide electromigrates anode→cathode under high J
- **State**: low (~200 Ω) intact / high (≥900 Ω, typically MΩ–GΩ)
  programmed
- **Programmable from**: 5 V DVDD rail directly, **no charge pump**
- **Programming pulse**: 5 mA × 250 µs (or pulse train 25× 10 µs)
- **Retention**: > 10 yr at 130 °C HAST (Tonti 2003)
- **Maturity**: PDK-shipped with DRC, LVS, SPICE static model

### FUSE-METAL-EM — Metal-line electromigration fuse
- **Mechanism**: same EM, but in metal not silicide
- **Programmable from**: needs ~50 mA, charge-pumped from 5 V
- **Maturity**: not in PDK; superseded by silicide eFuse

### FUSE-LASER — Laser-blown polysilicon fuse
- **Mechanism**: external laser pulse physically vapourises poly
- **Maturity**: not in PDK; incompatible with wire-bond flow

### ANTIFUSE-GOX — Gate-oxide rupture antifuse
- **Bit cell**: 3.3 V-device thin gate (tox=8 nm); 1T or 1.5T
- **Mechanism**: TDDB percolation filament forms in SiO₂
- **State**: open (fF MOS cap) / kΩ-class programmed
- **Programmable from**: needs 5.6–8 V → on-die charge pump
- **Maturity**: industry-standard at 0.18 µm but no PDK cell on
  `gf180mcuD`

### ANTIFUSE-CAP — MIM-cap dielectric rupture
- **Eliminated**: V_BD = 30–60 V exceeds any plausible pumped V

### FG-FLASH — Floating-gate flash memory
- **Eliminated**: `gf180mcuD` MCU flow has no second poly, no
  tunnel oxide

### CT-NVM — SONOS / charge-trap memory
- **Eliminated**: not in `gf180mcuD`

### MASK-ROM — Bit-pattern at metal mask
- **Bit cell**: 2–4 µm²/bit; metal-strapped contacts
- **Mechanism**: no programming after fab — bits set by photomask
- **Maturity**: trivial in any process

## Programming-source architectures (where Vprog comes from)

### VPROG-DVDD — Direct from 5 V DVDD rail
- **Use with**: FUSE-POLY-SILICIDE (matches its 5 V/6 V design)
- **Cost**: zero — exists already

### VPROG-PUMP-DICKSON-2 — On-die 2-stage Dickson charge pump
- **Output**: ~8.6 V at 1 mA from 5 V V_in
- **Cost**: ~20 000 µm² for 2× 10 pF MIM caps
- **Use with**: ANTIFUSE-GOX

### VPROG-EXTERNAL-PAD — Dedicated HV pad fed by ATE
- **Cost**: ~1 pad on the ring; zero on-die circuitry
- **Use with**: any mechanism, programming-at-test only

## Programming-flow architectures (when programming happens)

### PROG-WAFER-PROBE — Programmed at wafer-probe
- **Pad**: probe-card-only pad or shared with ATE-required test pad
- **Use case**: every die programmed individually before dicing

### PROG-ATE-FINAL — Programmed at packaged-die ATE
- **Pad**: existing pad multiplexed to TM (TM-EXISTING-PAD)
- **Use case**: final-test programming after assembly

### PROG-IN-FIELD-NFC — Programmed in field via NFC writer
- **Cost**: substantial RTL + protocol + lock + attack-resistance
- **Eliminated** for v2: poor cost-benefit, attack surface

### PROG-PCB-STRAP — Per-card configuration via PCB pad straps
- **Cost**: ~zero on-die beyond the pad itself
- **Limit**: bits-per-strap = bits-per-pad; impractical beyond ~8 b

## Read-path architectures

### READ-DIFF-SA — Differential current-mirror sense amp + reference R
- **For**: FUSE-POLY-SILICIDE (~5 kΩ trip)
- **Read I**: ~10 µA per bit × 100 ns sense time

### READ-TIA — Trans-impedance amp / current-comparator
- **For**: ANTIFUSE-GOX where read current is µA-class
- **Cost**: 2–3× area of differential SA

### READ-MASK — No read path needed
- **For**: MASK-ROM — the metal connection IS the read path

## ECC architectures

| Strength | Use when | Overhead |
|---|---|---|
| ECC-NONE | bit count < ~64 and per-bit yield > 99.9% | 0% |
| ECC-PARITY | need to detect (not correct) single-bit fails | 12.5% |
| ECC-SEC-HAMMING | bit count > ~256, any per-bit fail unacceptable | ~12% |
| ECC-SEC-DED | high-reliability claim needed | ~14% |

## Recommended architecture matrix (Stage 1 — no winner picked)

| Bit-count regime | Cell | Vprog | Flow | Read | ECC |
|---|---|---|---|---|---|
| ≤ 64 bits trim/ID | FUSE-POLY-SILICIDE | VPROG-DVDD | PROG-ATE-FINAL via TM-EXISTING-PAD | READ-DIFF-SA | ECC-PARITY (optional) |
| 64-128 bits | FUSE-POLY-SILICIDE | VPROG-DVDD | PROG-ATE-FINAL | READ-DIFF-SA | ECC-SEC-HAMMING (optional) |
| 256-1024 bits, payload not per-die | FUSE-POLY-SILICIDE (trim/ID) + MASK-ROM (payload) | VPROG-DVDD | PROG-ATE-FINAL | READ-DIFF-SA + READ-MASK | ECC-PARITY on OTP |
| 256-1024 bits, payload per-die | FUSE-POLY-SILICIDE | VPROG-DVDD | PROG-ATE-FINAL | READ-DIFF-SA | ECC-SEC-DED |
| > 1024 bits, payload per-die | ANTIFUSE-GOX | VPROG-PUMP-DICKSON-2 | PROG-ATE-FINAL | READ-TIA | ECC-SEC-DED |

These are not recommendations (Stage 1 doesn't pick winners) —
they are the natural pairings the physics + PDK + requirements
suggest. Stage-3 will resolve.
