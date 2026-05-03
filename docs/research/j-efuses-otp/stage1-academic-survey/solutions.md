# Solutions surveyed — academic angle

This file enumerates each silicon-paper-anchored eFuse / OTP
topology in detail.

Group key:
- **POLY-EFUSE-*** — silicide-electromigration on N⁺ poly.
- **ANTIFUSE-*** — gate-oxide-breakdown.
- **FG-OTP-*** — floating-gate / FN-tunnelling.
- **MIM-RUPTURE-OTP** — capacitor dielectric rupture.

---

## POLY-EFUSE-COSI2 (CoSi₂ silicide-EM eFuse)

> **Correction 2026-05-04** (reviewer-1): the prior anchor list
> attributed Tonti 2003 IRW to the **CoSi₂** topology bucket,
> but the cached PDF (line 30) explicitly states Tonti 2003
> studies **WSi₂ (Tungsten Silicide)**, not CoSi₂. CoSi₂ is
> anchored solely by **Kothandaraman 2002 EDL**. Tonti 2003
> belongs in the WSi₂ topology bucket below.

**Anchor papers (corrected):** **Kothandaraman 2002 EDL** is the
primary CoSi₂ anchor. Tonti 2008 SSIRI extends with array-level
yield data (silicide-agnostic). Tian 2006 IRPS is a 90 nm
successor study. (Tonti 2003 IRW removed from this entry —
that paper's silicide is WSi₂; see POLY-EFUSE-WSI2 below.)

**Mechanism.** N⁺-doped polysilicon line clad with CoSi₂
(50 nm) plus a thin TiN/SiN cap; narrowed to a "neck" of
minimum lithographic width (0.18 µm × 1.26 µm in our PDK,
0.4 µm × 2.0 µm in Tonti 2003 IBM 0.14 µm). Programming = high-
current pulse from anode→cathode; Joule heating to ~850 °C
(Kothandaraman) or ~2200 °C (Tonti 2003 melt regime) drives
electromigration; CoSi₂ depletes from the neck, leaving
high-resistance polysilicon behind that recrystallises.

**Published silicon numbers (0.14 µm IBM):**

| Quantity | Value | Source |
|---|---|---|
| Pre-program R | ~350 Ω | Tonti 2003 Fig 6 |
| Latch-trip threshold | ~10 kΩ system / 2.5 kΩ practical | Tonti 2003 §5 |
| Post-program R | > 30 kΩ guaranteed; typically 1 MΩ–1 GΩ | Tonti 2003 / Tonti 2008 |
| Programming voltage | 4.7 V across whole macro | Tonti 2003 Fig 5b |
| Programming current | 5 mA per fuse | Tonti 2003 Fig 5b |
| Programming pulse | 25 × 10 µs train (best yield) OR 250 µs single | Tonti 2003 Fig 5a |
| Time-zero programming yield | 99.97 % (E-Fuse B) | Tonti 2003 Table 3 |
| HAST (130 °C / 2.85 V / 192 hr) survival | 100 % across 150 000 fuses | Tonti 2003 Table 4 |
| Retention extrapolation | > 10 yr at 85 °C field temp | Tonti 2003 Coffin-Manson |

**Programming MOSFET sizing** (Kothandaraman 2002): NFET in
deep triode at V_GS = 1.5 V (likely 2.5 V for GF180MCU 5 V
devices) sized to deliver 5 mA at V_DS ≈ 1 V → W/L ≈ 33 µm at
0.18 µm with a 5 V NFET (Idsat ≈ 150 µA/µm).

**Sense-amp practice** (Robson 2007 CICC; Kim 2011 JSTS).
Single-ended with poly-resistor reference *or* differential-
paired with twin fuse. Read current 5–20 µA. Differential
twin-fuse trades 2× cell count for ~10× sense margin and is
the dominant academic recommendation post-2010.

**Applicability to ws-logo-die:** **PRIMARY CANDIDATE.** PDK
ships the cell. Tonti 2003 25-pulse-train schedule is the right
SPICE-corner default. Differential-paired sensing (Kim 2011) is
a free architectural improvement with no extra PCell work.

**Caveats:**
- The PDK SPICE model is a static `pblow=0/1` resistor; it does
  *not* model the transient programming behaviour (Tonti 2003
  Fig 5; Kothandaraman 2002 Fig 5). Stage 4 must implement
  programming-pulse simulation outside the PCell.
- E-Fuse A failed JEDEC humidity preconditioning. We do not
  know which version GF180MCU is closer to. **Single biggest
  unverified risk.**

---

## POLY-EFUSE-WSI2 (Tungsten-silicide eFuse)

**Anchor papers:** Tonti 2003 IRW (the original IBM E-Fuse used
WSi₂ on the 0.14 µm 256M SDRAM scribe-line BPM); Kothandaraman
2002 EDL ("the same phenomena were observed even when the link
was formed using tungsten silicide").

**Mechanism.** Identical to CoSi₂ except the silicide is WSi₂.
Programming voltage and current envelope are essentially the
same; the migration model is W,Si or W₅Si₃ phase change rather
than CoSi₂ migration.

**Applicability:** Listed for completeness. **Not in our PDK
(GF180MCU uses CoSi₂).** Eliminated as a candidate but retained
as topology-equivalent for cross-reference.

---

## POLY-EFUSE-NISI (Nickel-silicide eFuse)

**Anchor papers:** Choi/Hsueh 2007 IRPS "Characterization of
Silicided Polysilicon Fuse Implemented in 65nm Logic CMOS
Technology"; Tian 2006 IRPS "Reliability Qualification of
CoSi2 Electrical Fuse for 90nm Technology" (transitions to
NiSi at the 90→65 nm boundary).

**Mechanism.** Identical electromigration-from-cathode behaviour
as CoSi₂, but NiSi is the silicide of choice for ≤ 65 nm logic.
Programming-current density requirements are similar; the cell
shrinks with the node.

**Applicability:** Wrong node. **Eliminated** — but the *sense-
amp design lessons* from these papers (especially Robson 2007's
99.999 % sense yield at 45 nm) transfer directly.

**Specific transferable lesson** (Choi 2007 IRPS): the post-
programmed resistance distribution at 65 nm has a heavy *high-R
tail* (median 100 kΩ, 99-percentile > 1 GΩ). Stage 4 should
ensure the GF180MCU sense-amp tolerates the same heavy-tail
distribution.

---

## ANTIFUSE-2T (2-transistor gate-oxide-breakdown)

**Anchor papers:** Wang 2014 ASICON "A gate-oxide-breakdown
antifuse OTP ROM array based on TSMC 90nm process"; Kim 2007
ISCAS "Three-transistor one-time programmable (OTP) ROM cell
array using standard CMOS gate oxide antifuse"; Han 2019 EDL
(taxonomy reference).

**Mechanism.** 2 series transistors per bit. The "antifuse
transistor" (AF) has its gate held at V_PP (programming pump
output, ~6.5 V at 90 nm tox / ~9 V at 0.18 µm tox); the access
transistor (AT) selects the bit. When AT is on, AF's
source/drain is grounded and the full V_PP appears across AF's
gate oxide → TDDB → percolation path forms in <1 ms.

**Published silicon numbers (90 nm TSMC, Wang 2014):**
- Optimal program voltage: 6.5 V
- 3T variant cuts standard deviation of programmed-cell
  resistance by 15.3 % (worst) to 80.3 % (typical) vs 2T at
  18 % area cost.
- Read voltage: 1.0 V
- Cell area (2T): ~1.5 µm² at 90 nm → scales to ~6 µm² at
  0.18 µm.

**Applicability:** Not in `gf180mcuD` PDK. The `OTP_MK` DRC
layer suggests *intended* support, but no PCell ships. Could
be drawn manually using the 3.3 V NMOS — but the 9 V transient
across the 3.3 V tox is not a documented safe condition.
**Eliminated for v2** unless GF qualification data emerges.

---

## ANTIFUSE-1.5T-SPLIT-CHANNEL (Sidense / split-channel)

**Anchor papers:** Sidense / Synopsys US 7,402,855 (issued 2008);
Han 2019 EDL §I; Wang 2014 ASICON §II.

**Mechanism.** A single transistor with a *variable-thickness
gate oxide*: thin oxide over part of the channel length, thick
oxide over the rest. The thin-oxide region acts as a localised
breakdown zone; the thick-oxide region is normally-off and
provides the access function. Effectively a "1.5-transistor"
cell — single-MOS footprint, but two-region channel.

**Published silicon numbers** (US 7,402,855, comparison to
prior art):
- Programming voltage: V_PP ≈ 8 V in a 1.8 V process (i.e.
  thin-oxide region uses 1.8 V tox = 3.5 nm, programming field
  ~22 MV/cm).
- Cell area: smaller than 2T because the access function is
  built into the cell itself.

**Applicability.** **Eliminated** — Sidense / Synopsys is a
licensed-IP-only path. The split-channel structure is
*possible* in `gf180mcuD` if we draw a custom oxide-region
boundary, but doing so requires a custom mask delta or a clever
re-use of `OTP_MK`. Not de-risked. Listed for completeness.

---

## ANTIFUSE-3T (3-transistor cell)

**Anchor papers:** Kim 2007 IEEE TVLSI (3T paper for OTP ROM
cell array with standard CMOS gate-oxide antifuse); Lee 2011
JSTS (32-Kb 3T antifuse OTP integrated in 16-bit MCU); Han 2019
EDL §I (taxonomy reference).

**Mechanism.** 3 transistors per bit:
1. Antifuse transistor (AF) — gate oxide breaks during program.
2. Access transistor (AT) — bit-line select.
3. Block transistor (BT) — high-voltage isolation, prevents
   neighbour-bit programming.

Adding the BT transistor reduces the *programming-induced
disturb* on adjacent unselected bits.

**Published silicon numbers** (Lee 2011 JSTS; Wang 2014 ASICON
3T variant):
- Cell area: ~7.5 µm² at 90 nm → ~30 µm² at 0.18 µm (rough
  scaling).
- Standard deviation of equivalent programmed resistance
  reduced 15.3–80.3 % vs 2T (Wang 2014).
- Programming voltage: 6.5 V at 90 nm; ~9 V at 0.18 µm.

**Applicability.** Same elimination as ANTIFUSE-2T — the
underlying gate-oxide-breakdown event is not characterised on
`gf180mcuD`'s 3.3 V devices. Listed as the "best-engineered"
antifuse if Stage 4 chooses an antifuse path.

---

## FG-OTP-SINGLE-POLY (Floating-gate single-poly OTP)

**Anchor papers:** Holleman 2007 WVU MS thesis (single-poly FG
in standard 0.18 µm CMOS); Hasler 2005 GA-Tech tutorial; eMemory
NeoBit product literature (industry-survey overlap); Tinajero-
Perez 2014 (Wiley) FN tunnelling characterisation on poly1-poly2
caps in 0.5 µm.

**Mechanism.** Two PMOS transistors share a *floating gate*
that has no electrical contact to the rest of the chip. A MIM
capacitor or a MOS-capacitor (using a separate well) acts as a
*coupling capacitor*; another MOS-capacitor acts as the
*tunnelling injector*. Programming: hold the injector cap at
~6.4 V for ~10 ms; FN tunnelling moves electrons onto the
floating gate. Erase (if the cell is MTP rather than OTP):
reverse polarity. For OTP behaviour, simply don't erase.

**Published silicon numbers:**
- Cell area (Holleman 2007): ~0.95 µm² at 0.18 µm logic
  (academic single-poly only — no extra masks).
- Programming voltage: ~6 V across coupling cap (V_app ≈ 6.4 V
  with CR = 0.7).
- Programming time: 1–10 ms FN tunnel.
- Read margin: ~50 % I_D shift between programmed and
  unprogrammed (good).
- Retention: 10 yr at 85 °C reported by NSCore PermSRAM
  product family (similar topology).

**Applicability.** **Possible in `gf180mcuD`** — has both gate-
oxide options and MIM capacitors. Not in any PDK PCell;
requires custom design from primitives. **Stage-4 backup path**
if the polysilicon eFuse fails programming-yield qualification.
Strongest argument: it's the only academic OTP path that gives
us *MTP* (multi-time programmable) capability if we ever want
to reprogram the trim values without re-spinning silicon.

---

## MIM-RUPTURE-OTP

**Anchor papers:** Hyde 1999 IEDM (academic-only research);
Schroder 2007 (review chapter on dielectric breakdown).

**Mechanism.** A MIM (metal-insulator-metal) capacitor in the
back-end stack is held at V > V_BD; the dielectric breaks down
and forms a conductive filament (or forms a high-conductance
ohmic path). Identical *physics* to gate-oxide antifuse but
using the BEOL MIM instead of the gate oxide.

**Published silicon numbers (academic, generic):**
- V_BD scales with thickness; for 30 nm Ta₂O₅ MIM, V_BD ≈ 30 V.
- Programming pulse < 100 µs at fields > 10 MV/cm.
- Cell area: dominated by MIM cap footprint, ~50 µm² at
  0.18 µm.

**Applicability.** **Eliminated by physics** on a 5 V supply.
Sister reports already concluded this; the academic literature
agrees. Listed for completeness.

---

## Summary table

| Topology | Mechanism | Anchor paper | Vprog | Iprog or Eprog | Cell area at 0.18 µm | In `gf180mcuD` PCell? |
|---|---|---|---|---|---|---|
| POLY-EFUSE-COSI2 | Silicide EM | Tonti 2003 IRW | 4.7 V | 5 mA × 250 µs | ~50 µm² | **YES** |
| POLY-EFUSE-WSI2 | Silicide EM | Tonti 2003 IRW | ~5 V | ~5 mA × 250 µs | ~50 µm² | No |
| POLY-EFUSE-NISI | Silicide EM | Choi 2007 IRPS | ~3 V (65 nm) | ~5 mA × 100 µs (65 nm) | n/a (65 nm) | No |
| ANTIFUSE-2T | Gate-ox BD | Wang 2014 ASICON | ~9 V | ~1 µJ | ~6 µm² | No (OTP_MK rules only) |
| ANTIFUSE-1.5T-SPLIT-CH | Gate-ox BD | US 7,402,855 | ~8 V | ~1 µJ | ~3 µm² | No (licensed IP) |
| ANTIFUSE-3T | Gate-ox BD | Kim 2007 / Lee 2011 | ~9 V | ~1 µJ | ~30 µm² | No |
| FG-OTP-SINGLE-POLY | FN tunnel | Holleman 2007 WVU | ~6.4 V | ~10 ms FN | ~10 µm² | No (custom) |
| MIM-RUPTURE-OTP | MIM BD | Hyde 1999 IEDM | ~30 V | physics-eliminated | ~50 µm² | No |

Eight peer-reviewed-silicon-anchored topologies, of which
**only POLY-EFUSE-COSI2 ships as a PDK PCell**; ANTIFUSE-2T /
ANTIFUSE-3T are buildable in principle if GF qualification data
emerges; FG-OTP-SINGLE-POLY is the academic backup; the rest are
eliminated for our specific process / supply / shuttle flow.
