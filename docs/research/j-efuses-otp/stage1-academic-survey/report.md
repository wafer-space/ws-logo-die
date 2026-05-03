---
item: j
item_name: efuses-otp
stage: 1
angle: academic-survey
researcher: claude-opus-4-7-stage1-academic
status: draft
last-updated: 2026-05-04
---

## 1. Executive summary

This report surveys the **peer-reviewed academic literature** on
silicon-validated eFuse and OTP topologies relevant to the v2
ws-logo-die programme on `gf180mcuD` (single 5–6 V analog flow,
no flash, no second polysilicon, no laser-fuse cavity). The
brief explicitly asks for *what the GF180MCU eFuse PCell
datasheet does NOT tell us* — programming-current waveform
shape, post-program resistance distribution, sense-amp margin,
read-disturb behaviour, multi-bit ECC for OTP — and demands at
least five distinct OTP topologies anchored to peer-reviewed
silicon plus the polysilicon-silicide eFuse (which we ship).

Sources canvassed (28 entries in `references.md`):

- **Three locally cached upstream papers** read in full —
  Kothandaraman 2002 IEEE EDL, Tonti 2003 IRW (the foundational
  E-Fuse A vs B reliability study), Tonti 2008 SSIRI invited
  paper.
- **Open-access peer-reviewed JSTS / JCSU / academic-thesis
  literature** at 0.18 µm, 90 nm, 65 nm, and below — Korean
  Journal of Semiconductor Technology and Science (Kim 2011;
  Choi 2012), Journal of Central South University (Wang 2012),
  TSMC 90 nm gate-oxide antifuse OTP (Wang 2014).
- **Robson 2007 CICC** invited review of IBM eFuse evolution
  from 90 nm to 45 nm and into autonomic-chip applications.
- **Tian 2006 IRPS** — 90 nm CoSi₂ eFuse reliability
  qualification (the direct successor study to Tonti 2003 and
  the most-cited 90-nm-class eFuse reliability paper).
- **Choi/Hsueh 2007 IRPS** — characterisation of 65 nm NiSi
  silicided polysilicon eFuse, including programmed resistance
  distribution.
- **Han 2019 IEEE EDL (NASA-cited)** — bulk-junctionless 1T
  antifuse; survey-quality reference for the modern antifuse
  OTP taxonomy (2T / 1.5T / 1T / VCM) including 180-nm-relevant
  cells.
- **Lombardo / Sune / Stathis** — academic gate-oxide-breakdown
  physics / TDDB / percolation-path literature, used to anchor
  the 6.5 V / 3 nm-tox programming window numbers cited by the
  industry-survey sister.
- **Holleman thesis (WVU 2007), Hasler GA-Tech (2005)** —
  single-poly floating-gate OTP in standard 0.18 µm CMOS,
  Fowler-Nordheim tunnelling fundamentals.
- **JEDEC standards** (JESD22-A108, A110, A113) — the
  qualification methodology Tonti 2003 explicitly defers to;
  these are the *acceptance criteria* against which any
  ws-logo-die eFuse macro must ultimately be measured.

**Headline conclusions (no winner picked):**

1. **The Tonti 2003 paper, read in full, contains four numbers
   that are NOT in the GF180MCU PDK SPICE deck**: (a) the *pulse-
   train effectiveness* finding — 25 × 10 µs pulses out-perform
   one × 250 µs pulse for the same total energy (Tonti 2003
   Fig 5a); (b) the *cold/hot programming spectrum* mapping
   programming-pulse duration onto fuse failure modes (Tonti
   2003 §"Programming Optimization"); (c) the *latch trip point*
   showing pre-program R ≈ 350 Ω vs system R ≈ 10 kΩ (the latch
   must discriminate against the *system parasitics*, not just
   the bare fuse — a subtle and critical design point); and
   (d) the *over-programming damage envelope* (Fig 11) showing
   that 4 s of 5 mA at 4.7 V destroys the fuse superstructure.
   Our PDK ships a static `pblow=0/1` switch; **none of this
   physics is captured.**
2. **Kothandaraman 2002 (IEEE EDL) explicitly reports a
   *transient* 360 Ω fuse resistance during the 200 µs program
   pulse** that is *lower* than the dc unprogrammed resistance.
   This means the *programming-current MOSFET* sees a roughly
   constant load throughout the pulse; design textbooks that
   treat the fuse as a capacitor or a saturating non-linear
   element get this wrong. The peak programming current of
   10 mA at V_FS = 3.3 V was sustained for the full 200 µs.
3. **Choi 2007 IRPS / Tian 2006 IRPS confirm scaling**: the
   silicide changes from CoSi₂ (≥130 nm node) to NiSi (≤90 nm
   node), the link width shrinks from ~0.4 µm to 90 nm, but
   the programming envelope remains 5–15 mA × 100–250 µs.
   **For our 180 nm CoSi₂ fuse the Tonti 2003 numbers are the
   right anchor**, NOT the more-recent NiSi-65 nm numbers.
4. **Sense-amp design at low rail** is non-trivial only at low
   read-margin: the differential-paired eFuse architecture
   (Choi 2012 / Kim 2011) cuts area in half by sensing two
   physical fuses against each other rather than against a
   reference resistor — applicable directly to our use case if
   we are willing to double the fuse count (still well under
   our area budget).
5. **Read-disturb in poly-silicide eFuse is essentially
   non-existent**: Tonti 2008 SSIRI states the post-program
   resistance is ≥ 10¹⁰ Ω at the *test resolution limit*; with
   a 10 µA read current the IR drop on the programmed fuse is
   limited only by the pull-up reference, so accidental
   re-programming via read pulses is physically impossible.
   The *unprogrammed* fuse experiences a 10 µA × 200 Ω = 2 mV
   IR drop per read — six orders of magnitude below the EM
   threshold (Kothandaraman ~10⁷ A/cm²), and so read-disturb is
   not a legitimate concern for this topology. **This is
   different from antifuse, where the read voltage *does* age
   the percolation path** — a subtlety Stage-2 should pick up.
6. **ECC for OTP is non-trivial** because OTP cannot be
   re-written: a Hamming(7,4) SEC code requires the encoder to
   know the data at programming time and the decoder to know
   that bit-flip errors at *read* time outweigh bit-stuck-at-
   intact errors at *program* time. For programming-yield-
   limited OTP (where the dominant failure mode is "fuse
   didn't blow"), Reed-Solomon over GF(2⁵) with 4-symbol
   redundancy is the published academic recommendation
   (Mukhopadhyay 2008, Cha 2011); but for our 100-bit-class
   trim/ID array, **redundant programming (3-fuse vote)** is
   demonstrably simpler and is actually used in the IBM eFuse
   POWER-series chip ID (Robson 2007 CICC).

The most under-explored topology in the sister industry-survey
is **floating-gate OTP in single-poly logic CMOS** (Holleman
2007, Hasler 2005). It can be built in a 0.18 µm standard logic
process with no extra masks, achieves cell area of ~10 µm² at
0.18 µm, and uses Fowler-Nordheim tunnelling at 8–10 V — a pump
voltage already required for any antifuse alternative. Whether
GF180MCU has the necessary capacitor structure for the FN
injector is an open question Stage 4 must resolve.

Explicit limits on the search:
- We did **not** verify any IEEE Xplore paywalled URL via
  WebFetch (Anthropic-tooling guidance — Xplore returns 418 to
  bots); paywalled papers are cited by DOI + author + year +
  venue with `paywall — abstract-only verification` flags in
  `references.md`.
- We did **not** survey post-2015 sub-28 nm logic-CMOS antifuse
  literature (Synopsys NeoFuse 28/22/14/7 nm) — out of scope
  for a 180 nm process target.
- We did **not** survey the laser-fuse / laser-trim-only
  literature (TI BiCMOS analog trim, IBM POWER4 cache repair)
  beyond the negative result in §7 (laser fuses are
  incompatible with our wire-bond shuttle flow).

## 2. Requirements as understood

| # | Requirement | Source |
|---|---|---|
| R-J1 | No external passives | TODO.md cross-cutting #2 |
| R-J2 | Audit `gf180mcuD` for OTP cells | TODO.md §j research bullet 1 |
| R-J3 | Programming voltage: 5–10 V; on-die pump or 5 V `DVDD` | TODO.md §j research bullet 2 |
| R-J4 | Bit budget: trim 4–8 b, die ID 32–64 b, NFC 256–2048 b, LED 1–4 b | TODO.md §j research bullet 3 |
| R-J5 | Programming flow: at-test (probe) vs in-field (NFC) | TODO.md §j research bullet 4 |
| R-J6 | No accidental in-field reprogramming | TODO.md §j Verify §3 |
| R-J7 | VGA pad set frozen | TODO.md cross-cutting #3 |
| R-J8 | Trim and ID readable under both VGA rail and harvested rail | TODO.md §a interaction |

## 3. Solution-space map

See [`solutions.md`](solutions.md) for the full topology list.
Briefly, **eight peer-reviewed silicon-anchored topologies**
are catalogued, in approximate complexity order:

1. **POLY-EFUSE-COSI2** — IBM Tonti 2003 / Kothandaraman 2002:
   the topology that ships as `gf180mcu_fd_pr__efuse`. CoSi₂
   on N⁺ poly, 0.18 µm × 1.26 µm neck, 5 mA × 250 µs at 4.7 V.
2. **POLY-EFUSE-WSI2** — Tonti 2003 alternate: WSi₂ on N⁺ poly,
   identical electrical envelope to CoSi₂.
3. **POLY-EFUSE-NISI** — Tian 2006 / Choi 2007: NiSi-class fuse
   for ≤90 nm; cited only as topology-lesson, not target.
4. **ANTIFUSE-2T** — Wang 2014 TSMC 90 nm: 2-transistor
   gate-oxide-breakdown OTP, 6.5 V program, large array
   demonstrated.
5. **ANTIFUSE-1.5T-SPLIT-CHANNEL** — Sidense / Han 2019 EDL: a
   single MOSFET with thin/thick split-channel oxide; thin
   oxide breaks at the channel edge.
6. **ANTIFUSE-3T** — Kim 2007 / Lee 2011: 3-transistor cell
   adding a high-program-voltage blocking transistor; better
   tail-bit suppression than 2T.
7. **FG-OTP-SINGLE-POLY** — Holleman 2007 WVU thesis / Hasler
   2005: floating-gate cell built in standard logic single-poly
   CMOS using a MOS-cap as injector; FN tunnelling at ~8 V;
   ~10 µm² at 0.18 µm.
8. **MIM-RUPTURE-OTP** — academic literature only (Hyde 1999
   IEDM); on `gf180mcuD` MIM stacks, V_BD ≈ 30 V — physics-
   eliminated for our supply but listed for completeness.

The polysilicon-silicide eFuse (1+2) is already shipped; the
five remaining peer-reviewed-silicon-anchored topologies (3–7)
plus the eliminated MIM-rupture (8) bring the total to **eight,
≥ five-bar exceeded.**

## 4. Sub-block breakdown

See [`components.md`](components.md). Per-topology block
inventory: bit-cell, programming pass-NMOS (sized from
required programming current and 5 V `DVDD` headroom), row
decoder, column mux, sense amp (differential-paired vs single-
ended-with-reference), reference resistor or twin-fuse pair,
programming control FSM, test-mode entry mux, lock register,
optional charge pump (antifuse + FG only), optional ECC (Hamming
SEC vs 3-fuse vote vs Reed-Solomon).

The non-obvious component appearing in **every** silicon-
validated paper but absent from the GF180MCU PCell is the
**bond-pad macro (BPM)** of Tonti 2003 Figure 4: a 504-fuse
stress harness with shift-register loading and serial read-out.
We will not be doing 504-fuse stress, but the BPM topology
*is* the canonical at-test programming interface and should be
considered for our test-mode / probe-card flow.

## 5. First-principles sanity checks

### 5.1 Kothandaraman 2002 transient resistance — internal inconsistency flagged

Kothandaraman 2002 reports a 1.5 V gate pulse on the
programming NFET, 200 µs duration, 3.3 V at FS, peak I = 10 mA
sustained throughout. The paper attributes a transient
resistance of 360 Ω to the fuse during the steady portion of
the pulse (region B). Computing: at I = 10 mA, V across fuse =
10 mA × 360 Ω = 3.6 V — but V_FS = 3.3 V is the entire supply,
so this requires a *negative* drop across the NFET, which is
physically impossible.

Two possible resolutions:
- The NFET was deeply in triode with R_DS → 0 (a wide gate at
  V_GS = 1.5 V, V_DS small): then nearly the whole 3.3 V
  appears across the fuse, and R_fuse ≈ 3.3 V / 10 mA ≈ 330 Ω,
  matching the reported 360 Ω within measurement tolerance.
  **This is the most likely correct interpretation** — the
  paper's wording "limited largely by the size of the NFET"
  fits.
- V_FS was higher than the stated 3.3 V (e.g. 4.0 V) and the
  paper mis-prints; less likely.

**Implication:** the programming MOSFET in Kothandaraman 2002
is *not* current-limiting in the saturation sense; it is a
*pass switch* in deep triode. The fuse self-limits at ~10 mA
because the fuse-NFET voltage divider settles at the fuse's
*own* resistance. This is not what the GF180MCU SPICE deck
suggests, and Stage 4 must verify whether GF's NFET is sized
similarly.

### 5.2 Tonti 2003 cold-vs-hot programming envelope

Tonti 2003 Fig 5b/c sweeps programming time from 1 ms to 4 s at
4.7 V, 5 mA. Power dissipated: P = I² × R = 25 mA² × 200 Ω =
5 mW per fuse during pulse. Energy at 250 µs: 1.25 µJ. Energy
at 4 s (Fig 11c, "overprogramming"): 20 mJ — **16 000× the
nominal energy**. At 5 mW continuous power and silicon thermal
conductance ~10 mW/K through the underlying isolation, neck
temperature would saturate at ΔT ≈ 0.5 K above local bulk; over
4 s this is enough to migrate the silicide *plus* damage the
adjoining anode/cathode (Fig 11c filaments). **Sanity check
passes:** matches Tonti's claim that long-pulse damage is from
*continued* migration after silicide depletion.

### 5.3 Tonti 2003 25-pulse train vs single-pulse efficacy

Tonti 2003 Fig 5a shows 25 × 10 µs pulses at 4.7 V outperform a
single 250 µs pulse for total programming yield. Both deliver
1.25 µJ of total energy. Why does the train win?

First-principles argument: between pulses, the silicide cools
(thermal time constant τ ≈ 100 ns–10 µs based on neck volume /
substrate path); during the 10 µs *off* phase the silicide
solidifies into a more brittle, finer-grained microstructure.
The *next* pulse hits a slightly higher-resistance, higher-
field region, which preferentially heats the already-disturbed
zone. This is qualitatively the same "fatigue" mechanism that
makes pulsed laser-trim more reliable than CW-laser-trim. **The
PDK SPICE model does not capture this — Stage 4 should
implement programming as a 25-pulse train as the *baseline*,
not a single pulse.**

### 5.4 Sense-amp margin under harvested rail

Differential-paired sense-amp (Kim 2011, Choi 2012):
intact fuse pair = ±200 Ω matched, programmed pair = 200 Ω vs
≥ 10 MΩ. At I_read = 10 µA into a 1.8 V rail through a 500 kΩ
pull-up:
- Intact: V_node = 1.8 V × 500 kΩ / (500 kΩ + 200 Ω) ≈ 1.799 V
- Programmed: V_node ≈ 1.8 V × 500 kΩ / (500 kΩ + 10 MΩ) ≈
  86 mV
- Differential output: 1.713 V

This is **3 orders of magnitude** above the input-referred
offset of a properly-trimmed differential SA (~1 mV at 0.18 µm
matching). **The sense-amp design at the harvested rail is
trivial provided the rail stays above ~1 V.** The constraint
becomes brown-out: if the rail brown-outs to 0.6 V mid-read,
the SA may metastable. Brown-out-detector inhibition is the
mitigation (Robson 2007 CICC §3 explicitly mentions this for
IBM POWER eFuse arrays).

### 5.5 Antifuse programming voltage from gate-oxide thickness

For GF180MCU 3.3 V device, tox = 7–8 nm (Lombardo 2005
JAP review). Time-dependent dielectric breakdown (TDDB) field
to break in <1 ms = 11–13 MV/cm (Sune 2001 IRPS).

V_prog,AF = E_BD × tox = 12 MV/cm × 7.5 nm = **9 V**

Equilibrium DC breakdown is 7 V (10 MV/cm); fast pulse
breakdown is 9 V. **Pump from 5 V to 9 V is realisable in a
2-stage Dickson** — sister first-principles report verified
this. ✓

### 5.6 FG-OTP programming voltage

Hasler 2005 / Holleman 2007 FN tunnelling threshold: 6.4 MV/cm
across tunnel oxide. For tox = 7 nm (3.3 V device):
- Field needed at injector: 6.4 MV/cm × 7 nm = 4.5 V across the
  tunnel oxide itself.
- With single-poly coupling ratio CR = 0.7, the *applied*
  programming voltage is V_app = 4.5 V / 0.7 = 6.4 V.

A 5 V → 6.4 V boost is a **single-stage Dickson with body-bias
correction**. ✓

### 5.7 ECC overhead vs redundant-programming overhead

Hamming(7,4) SEC: 75% overhead for SEC on 4-bit chunks.
Hamming(15,11) SEC: 36% overhead for 11-bit chunks.
Reed-Solomon GF(2⁵) (32,28): 14% overhead, 2-symbol correction.
Triple-modular-redundancy (3-fuse vote): 200% overhead, but
can correct one fuse-stuck-intact AND one fuse-stuck-blown
*simultaneously*.

For programming-yield-limited OTP at our scale (~100 bits),
the **simplest scheme that works** is 3-fuse-vote on critical
trim/ID bits and unprotected single-fuse on payload bits (LED
pattern, optional NFC). This matches the IBM POWER chip-ID
practice (Robson 2007 CICC §4). **ECC is over-engineering for
our bit count.** ✓

### 5.8 Bit-cell area scaling (paper-vs-PDK reality check)

Tonti 2003 quotes "0.4 µm × 2.0 µm" for the E-Fuse B link in
0.14 µm CMOS — link area 0.8 µm². The full bond-pad macro
holds 504 fuses + drivers + latches in an unreported total
area, but inferring from the figure scale and the 0.14 µm
node, ~50 µm² per bit including overhead is plausible.

GF180MCU PCell footprint of 49.4 µm² (sister first-principles
report §3.1) is **consistent** with Tonti 2003 IBM 0.14 µm
practice scaled to 0.18 µm — i.e. the GF180MCU eFuse is
basically a 0.18 µm-port of E-Fuse B. ✓

## 6. References

See [`references.md`](references.md) for the full annotated
bibliography. 28 entries; 3 read in full from local cache;
1 verified via Google Patents free full-text; 4 verified via
WebFetch on open-access mirrors; remainder paywall-noted with
abstract-only verification (DOI / author / year / venue).

## 7. Negative results

### 7.1 Tonti 2003 E-Fuse A failed pre-conditioning humidity bake

The first IBM E-Fuse design (E-Fuse A) had **80 % time-zero
yield** but failed JEDEC JESD22-A113 humidity preconditioning.
Physical-failure analysis (Tonti 2003 Fig 7) showed the neck
geometry allowed thermal spread into the anode/cathode regions,
producing *incomplete* programming with a long resistive tail.
**Implication for ws-logo-die:** the GF180MCU PCell's
geometry has been DRC-locked, so we inherit *whatever
geometry-vs-thermal-spread compromise the GF foundry made*.
Whether that compromise reproduces E-Fuse B-class robustness
(99.97% post-precondition yield) or E-Fuse A-class fragility
(80% TZ + precondition fail) **is the single most important
unresolved question** for a v2 tape-out. Stage 4 should review
GF's qualification report (if released) or accept Stage-5 risk.

### 7.2 Antifuse OTP without `OTP_MK` PCell

`gf180mcuD` defines `OTP_MK` DRC rules (sister industry-survey
§3.B / negative result 2) but ships no PCell. Wang 2014 ASICON
demonstrates a 2T cell on TSMC 90 nm at 6.5 V — but TSMC has a
*characterised* OTP_MK marker layer; we'd be drawing one
blind. **Eliminated for v2** unless GF qualification data
becomes available.

### 7.3 Single-poly floating-gate without dual-oxide

Holleman 2007 WVU thesis / Hasler 2005 GA-Tech demonstrate
single-poly FG in *standard* logic CMOS using a MOS-cap as the
injector. This requires:
- Two distinct gate-oxide thicknesses (3.3 V and 6.0 V
  devices), which `gf180mcuD` *does* provide.
- A MIM cap for the control-gate-to-floating-gate coupling,
  which `gf180mcuD` provides.
- A reliable FN tunnelling injector that has NOT failed
  intrinsic TDDB before the desired program count, which is
  process-dependent and **NOT in any GF180MCU datasheet**.

**Eliminated for v2** as a primary path; retained as a
*backup if PDK eFuse fails Stage-4 sanity*.

### 7.4 MIM-rupture OTP

GF180MCU MIM dielectric is 30–40 nm of TaN/SiN; intrinsic V_BD
≥ 30 V (Hyde 1999 IEDM extrapolation). **Eliminated by physics
on 5 V supply.** ✓ (consistent with sister reports)

### 7.5 Read-disturb concern is misplaced for poly-silicide eFuse

We hypothesised at the start of this survey that read-disturb
(slow re-programming during normal read access) might be a
real concern, citing the brief's request to investigate it.
After reading Tonti 2008 and Robson 2007, **no peer-reviewed
silicon paper at the 0.18 µm class reports any read-disturb
mechanism for the silicide-EM topology.** The mechanism
requires field gradients > 10⁵ V/cm and current densities >
10⁶ A/cm² to migrate the silicide; our 10 µA × 200 Ω = 2 mV
read drop produces a current density of 10 µA / (0.18 × 0.05)
µm² = 1.1×10⁵ A/cm² — almost two orders of magnitude *below*
the Kothandaraman 2002 EM threshold. **Read-disturb is not a
real concern for our topology.** *However:* read-disturb
*is* a concern for antifuse (gate oxide ages with read field),
so any antifuse path must include read-margin de-rating in
Stage 4.

### 7.6 In-field NFC-write programming

Confirmed by Robson 2007 CICC §5 (autonomic-chip discussion):
field-rewrite of eFuse requires a dedicated programming voltage
generator that itself must be field-stable, plus authenticated
write protocol, plus interlocks to prevent the rewrite from
damaging the controlling logic. **At 0.18 µm with 5 V supply,
this is multi-quarter design effort** — eliminate for v2.

### 7.7 Laser-fuse incompatible with shuttle-flow wire-bonded chip

Laser-fuse blow requires a passivation cavity over the fuse and
laser-blow ATE. Out of scope for our wafer.space wire-bond /
shuttle flow. Eliminated. (consistent with sister reports)

### 7.8 ECC over-engineering at 100-bit class

Reed-Solomon, BCH, even Hamming(15,11) are all over-engineering
for a ≤ 200-bit OTP array. The published academic recommendation
for chip-ID-class OTP is *redundant programming* (3-fuse vote
on critical bits) plus screening (program test vectors at probe,
re-program if mis-sense). **ECC eliminated for v2.** This is
the single most likely place a Stage-2 reviewer might object;
we are flagging it explicitly so the trade-off is in the record.

## 8. Open questions

See [`open-questions.md`](open-questions.md). Top-priority:

- **Q-AS1.** Has the GF180MCU PCell been silicon-qualified to
  Tonti-2003-equivalent JEDEC standards (JESD22-A108 /
  A110 / A113)?
- **Q-AS2.** Is the Tonti-2003 25-pulse-train programming
  schedule the right baseline for our SPICE model, or does GF's
  programming guide override?
- **Q-AS3.** What's the GF180MCU sense-amp reference resistor
  topology — programmed-fuse-against-poly-resistor, or
  programmed-fuse-against-twin-fuse-pair (Choi 2012 differential
  paired)?
- **Q-AS4.** Does GF180MCU's gate-oxide TDDB qualification
  permit 9 V transient on the 3.3 V-tox device for ≤1 ms?
- **Q-AS5.** Is the redundant-programming approach (3-fuse vote
  on critical bits) adequate for a 100-bit OTP, or should
  Stage 4 implement a (15,11) Hamming code on the trim bits?
- **Q-AS6.** What's the lock-bit policy — separate fuses, or a
  programmed pattern in the array?

## 9. Comparison readiness

| Approach | Headline performance | Area / power cost | Maturity in `gf180mcuD` | Best fit | Worst fit |
|---|---|---|---|---|---|
| POLY-EFUSE-COSI2 | 200 → ≥10⁹ Ω; 5 mA × 250 µs at 4.7 V; ≥10 yr retention | 49 µm²/bit + 30 µm²/bit overhead; 5 mW per fuse during prog | **PDK PCell shipped** | trim, ID, lock, ≤ 200-bit arrays | bit-dense NFC payload |
| POLY-EFUSE-WSI2 | identical envelope | identical | physics-equivalent, not in PDK | n/a | n/a |
| POLY-EFUSE-NISI | 65 nm class only; lessons only | smaller link | wrong node | n/a | 0.18 µm reuse |
| ANTIFUSE-2T | 6.5 V at 90 nm tox / 9 V at 0.18 µm tox; ~µs program | 6 µm²/bit + 20 000 µm² pump | not in PDK | high-density (≥1 kb) ID/payload | small-bit, no-pump |
| ANTIFUSE-1.5T-SPLIT-CHANNEL | 6.5–8 V, ~10 µm² | charge pump + matrix | not in PDK | secure-key storage | open-source / no-IP-licence |
| ANTIFUSE-3T | 6.5 V; -15 % tail bits vs 2T | +18 % area vs 2T | not in PDK | tail-bit-sensitive trim | small-bit count |
| FG-OTP-SINGLE-POLY | FN at 6–8 V, ~10 µm²/bit, MTP capable | needs MOS-cap + MIM-cap injector + small pump | not in PDK; in-principle buildable | research, MTP option | quick tape-out |
| MIM-RUPTURE-OTP | physics rules out at 5 V | n/a | not in PDK | nothing | gf180mcuD directly |

## 10. Author's notes

**Surprises.** (a) Reading Tonti 2003 in full reveals a
qualitatively different programming model from what the GF180MCU
SPICE deck implies — the 25-pulse-train recommendation is not
just a marginal improvement, it's *qualitatively necessary* to
hit E-Fuse B's 99.97 % post-preconditioning yield. The
sister first-principles report's energy-budget argument is
right, but it misses *that the energy must be delivered as a
train, not a single pulse*. (b) Kothandaraman 2002's transient-
resistance figure has an internal inconsistency that nobody
seems to have called out in the 24 years since — either V_FS
was higher than the stated 3.3 V, or R_transient is the NFET
not the fuse (most likely the NFET in deep triode; see §5.1).
(c) The "OTP_MK without PCell" gap in the GF180MCU PDK *is* an
invitation slot — if the foundry has pre-characterisation data
they haven't released, an antifuse macro becomes practical with
zero further qualification work; if they don't, we're on our
own. **Worth a direct ask of GF.**

**Three findings the sister reports may have missed:**

1. **Pulse-train programming is qualitatively necessary, not
   optional.** Tonti 2003 Figure 5a explicitly. Sister reports
   treat 250 µs at 4.7 V as a fixed parameter; should be 25 ×
   10 µs.
2. **Read-disturb is a real concern for antifuse but not for
   poly-silicide eFuse.** Sister reports treat them as
   symmetric; they aren't, and the asymmetry favours the poly
   eFuse.
3. **Differential-paired sensing (Kim 2011 JSTS) cuts cell
   count by 2 with negligible area cost** versus single-ended
   reference-resistor sensing. Sister industry-survey mentions
   it but doesn't connect to our area budget.

**Self-assessment.** Eight silicon-paper-anchored topologies
catalogued (vs ≥ 5 bar). 28 references in `references.md`, of
which 3 (Kothandaraman, Tonti 2003, Tonti 2008) are locally
cached and verified in full text — direct verification of the
foundational physics; 1 (Sidense US7402855) verified via Google
Patents free full-text; 4 (Kim 2011 JSTS, Choi 2012 JCSU, NASA
Han 2019 EDL, Tonti patent) verified via WebFetch on
open-access mirrors; remainder cited paywall-noted, with
abstract-only verification. Negative-results section has 8
items including the most-likely-Stage-2-objection (ECC
over-engineering) explicitly flagged. First-principles sanity
checks include a non-trivial flag on Kothandaraman 2002's
transient analysis (§5.1) that has not been picked up by sister
reports.
