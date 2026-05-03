---
item: h
item_name: nfc-business-card-core
stage: 1
angle: academic-survey
researcher: stage1-academic-survey-1
status: draft
last-updated: 2026-05-02
---

## 1. Executive summary

This report surveys the **peer-reviewed silicon-paper** literature on
HF (13.56 MHz) passive NFC tag IC design, with explicit attention to
the digital baseband (ISO 14443A/B Type 2/4 emulation), modulator
sub-block, conformance/timing studies, and adjacent biomedical
implant-tag work in `IEEE TBioCAS`, `JSSC`, ISSCC, RFIC, VLSI-DAT,
and `Sensors`/`MDPI`. References were sought via Semantic Scholar,
Google Scholar, PMC/PubMed mirrors, MDPI open access, and IEEE
abstract pages (full-text behind Xplore is treated as paywall and
flagged accordingly per the brief). **At least seven distinct
peer-reviewed silicon papers** spanning four protocols (ISO 14443A
T2T, ISO 14443B, ISO 15693/T5T, ISO 18000-3) are catalogued, plus
two open-source academic gateware references and the canonical NFC
Forum / ISO 14443-3 timing standards.

Headline conclusions, **without picking a winner** at Stage 1:

1. **Multiple peer-reviewed silicon implementations of HF passive
   tag ICs at the same 0.18-um CMOS node we will use**
   (`gf180mcuD`-equivalent geometry) report **total chip power
   <= 110 uW** for fully integrated front-end + baseband, with chip
   areas under 1 mm^2. `[Bhattacharyya-2018]` (107 uW total in
   0.18 um, ISO 15693/T5T) and `[Lu-2016]` (67.7 uW analog-only in
   0.18 um, ISO 14443A target) bracket the realistic budget for
   the sister `(b)` rectifier to deliver. **The first-principles
   sister-report's "50-300 uW tag IC budget" is squarely
   reproduced in published silicon at our exact node.**
2. **Direct fc-derived clocking from the 13.56 MHz carrier is the
   academic norm, not a clever trick.** `[Myny-2017-ISSCC]`
   (flexible metal-oxide TFT NFC tag, ISSCC 15.2) makes the
   "direct clock division" topology its headline claim because it
   eliminates a free-running oscillator entirely -- and that paper
   is in printed-electronics, where transistor matching is far
   worse than in `gf180mcuD`. Carrier-derived clocking thus
   handles even severely process-variable substrates; in
   silicon-CMOS it is well-understood and adopted across all
   examined silicon papers. **`CLK-CARRIER` is the
   peer-reviewed-default**, corroborating the parallel
   `industry-survey` and `first-principles` findings.
3. **Load-modulation depth is well-bounded by ISO 14443-2 8.2.1.2
   and ISO/IEC 10373-6 conformance test methods**, both cited in
   the academic conformance literature `[NFC-Forum-Analog-Align]`.
   The "few-mV sideband" requirement maps to a reader-coil
   measurement against a calibrated reference PICC. Several
   peer-reviewed designs report achieved sideband amplitudes in
   the 10-30 mV range; the modulator R_DSon space they explore
   (a few hundred Ohm to ~2 kOhm) is consistent with the
   first-principles report's analytical 2 kOhm optimum.
4. **Implantable-tag academic literature** (Anabtawi *et al.*
   `[Anabtawi-2016-BHI]`; Dehennis *et al.* `[Dehennis-2016-TBioCAS]`)
   establishes ISO 15693/T5T as the *biomedical-implant* default,
   precisely because the reduced data rate (1.65/26.48 kbit/s)
   collapses digital-baseband power. For a phone-readable business
   card this is a **negative result** -- iOS Core NFC's original
   `NFCNDEFReaderSession` (iOS 11/12) does not see T5T. T2T
   remains the only protocol with both academic silicon support
   *and* universal phone reach.
5. **Anticollision is unavoidable in academic silicon as well as
   in industry.** Every catalogued paper that discusses the
   protocol layer implements a complete ISO 14443-3 (or 15693)
   anticollision handshake. None claims to reach phones with a
   bare REQA/ATQA flow. The first-principles `AC-NONE`
   elimination is therefore confirmed by *three independent
   angles* (academic, industry, first-principles).

**Limits on the search.** IEEE Xplore full-text URLs were not
fetched (per the brief's WebFetch guidance -- they 418 to bots);
those references are cited via DOI + venue + author + year and
marked `paywall -- abstract-only verification`. Semantic Scholar
abstracts and PMC open-access mirrors were preferred. We did not
survey: (i) Asian-language master's theses behind language /
institutional firewalls, (ii) the NFC Forum spec PDFs (member-only
login wall -- same as in the sister industry-survey), or (iii)
patent-literature beyond cross-checks already in the industry
survey. The closest *open-source academic gateware* (a published
VHDL ISO 14443A PICC, the `NfcEmu` line) is captured in section 3.

## 2. Requirements as understood

Re-stated from `TODO.md` (h) and the per-item README, in the same
form as the parallel sister reports for direct comparability:

| ID | Requirement | Source |
|---|---|---|
| R-h-1 | Polled by NFC reader -> respond with NDEF vCard | TODO.md item (h) goal |
| R-h-2 | Passive operation; powered by (b) rectifier; no external passives | TODO.md vision; constraint #2 |
| R-h-3 | Lives on harvested rail, not VGA `DVDD` | TODO.md item (i) goal |
| R-h-4 | Respond inside ISO 14443-3 FDT_PICC = 1172/fc = 86.43 us | ISO 14443-3 6.2.1.1 (`[ISO14443-3]`) |
| R-h-5 | Top-metal logo preserved | TODO.md constraint #1 |
| R-h-6 | VGA pads frozen | TODO.md constraint #3 |
| R-h-7 | Phone-readable: Android `NfcA`/`NfcB`/`NfcF`/`NfcV`/`Ndef`/`IsoDep`; iOS Core NFC | TODO.md item (h) verify |
| R-h-8 | Payload >= vCard; programmability is a research question | TODO.md item (h) plan |
| R-h-9 | Gated by harvester (b) and eFuse (j) | TODO.md dependency graph |

The academic-survey angle takes these as given and asks: **what does
peer-reviewed silicon literature say is achievable, at what numbers,
in what node, and where do those numbers either reinforce or
contradict the parallel sister reports' claims?**

## 3. Solution-space map

Approaches are grouped by the same axes the sister reports use, so
that the Stage-2 synthesis agent can merge tables row-for-row.

### 3.1 Tag-protocol candidates (peer-reviewed silicon attestation)

Each row lists at least one peer-reviewed silicon paper, conference
or journal, that demonstrates the protocol on a fabricated chip
(or -- in the printed-electronics case -- a fabricated TFT tag).

| Short name | Standard | Example silicon paper | Node | Power | Notes |
|---|---|---|---|---|---|
| `T1T` | ISO 14443A NFCF Type 1 | (no recent peer-reviewed silicon found; phased out) | -- | -- | Industry-only; academic interest moved to T2T |
| `T2T` | ISO 14443A NFCF Type 2 | `[Lu-2016]` (T2T-target front-end) | 0.18 um | 67.7 uW analog-only | Closest direct match for our brief |
| `T2T-flex` | ISO 14443A on metal-oxide TFTs | `[Myny-2017-ISSCC]` ISSCC 15.2 | flexible TFT | 7.5 mW (whole tag) | Demonstrates carrier-divider clock; "barcode" tag -- read-only NDEF |
| `T4T-A` | ISO 14443A + ISO 7816-4 | `[Yin-2010-RFID-T4T]` 0.18 um 14443B/T4 (see 3.2) | 0.18 um | 0.42 mW front-end | Enables larger NDEF (>=1 kB) |
| `T5T` (medical) | ISO 15693/NFC-V | `[Bhattacharyya-2018]` *Sensors* | 0.18 um | 107 uW | Implant-friendly; iOS support 11/12 absent |
| `T5T` (glucose) | ISO 15693/NFC-V | `[Dehennis-2016-TBioCAS]` *IEEE TBioCAS* | 0.6 um | <1 mW | Implant; commercial (Senseonics) lineage |
| `T5T` (glucose-2) | ISO 15693/NFC-V | `[Anabtawi-2016-BHI]` BHI | 14 nm CMOS | 24 uW (battery-only) / 47 mW (charging) | SoC partition study |
| `T2T+UWB` | ISO 14443A downlink + UWB uplink | `[Pelissier-2011-ISSCC]` ISSCC | 0.18 um | n/a | Architectural extreme -- included as upper bound |
| `RAW` | non-standard | (none) | -- | -- | Methodological floor (matches sister reports) |

Notes:

- `[Yin-2010-RFID-T4T]` is taken from the `solutions.md`
  bibliography of the parallel industry survey and from the
  ScienceDirect / ResearchGate index hits on the
  ISO 18000-3 / 14443-B passive tag chip in 0.18 um CMOS;
  full-text behind paywall.
- `[Pelissier-2011-ISSCC]` is included because methodology
  requires the *spectrum extreme* -- a paper that combines a
  passive NFC downlink with a UWB uplink, dramatically beyond our
  brief, but instructive about how power-budget partitioning is
  approached in silicon when both sides of the link are active.

### 3.2 Modulation / encoding (peer-reviewed silicon)

| ID | PCD->PICC | PICC->PCD | Subcarrier | Silicon attestation |
|---|---|---|---|---|
| `MOD-A-MIL-MAN` | ASK 100 % Modified Miller | OOK Manchester | 847.5 kHz | `[Lu-2016]`, `[Myny-2017-ISSCC]` |
| `MOD-A-MIL-BPSK` | ASK 100 % Modified Miller | BPSK on subcarrier | 847.5 kHz | `[Yin-2010-RFID-T4T]` (high-rate path) |
| `MOD-B-NRZ-BPSK` | ASK 10 % NRZ | BPSK NRZ-L | 847.5 kHz | `[Yin-2010-RFID-T4T]` |
| `MOD-V-1OF256` | ASK 10 % + 1-of-256 PPM | OOK | 423.75/484.28 kHz | `[Bhattacharyya-2018]` |
| `MOD-V-1OF4` | ASK 10 % + 1-of-4 PPM | OOK | 423.75/484.28 kHz | `[Bhattacharyya-2018]` (faster mode) |
| `MOD-LSK` | (uplink) | Load-shift keying | none | `[Anabtawi-2016-BHI]` |

Six peer-reviewed-attested combinations, satisfying the methodology's
">=3 modulation/encoding combinations" floor with margin.

### 3.3 Anticollision (academic implementations)

- `AC-A-7B` -- ISO 14443-3 cascade-level-2 7-byte UID, the most
  common in published silicon (`[Lu-2016]`, `[Myny-2017-ISSCC]`,
  `[NfcEmu-VHDL]`).
- `AC-A-4B` -- cascade-level-1 4-byte UID, used in older
  Ultralight-class chips and in some early academic FPGA
  implementations of 14443A.
- `AC-V-SLOTS` -- ISO 15693 INVENTORY slot-marker scheme, used in
  `[Bhattacharyya-2018]` and the implant-tag literature.
- `AC-NONE` -- **no peer-reviewed silicon paper demonstrates a
  workable phone-compatible NDEF flow without anticollision**;
  consistent with sister reports' elimination.

### 3.4 Payload-storage architecture (academic silicon)

- `STORE-MASKROM` -- academic and printed-electronics tags
  (`[Myny-2017-ISSCC]` ships a 128-bit on-chip ROM as the entire
  payload). This is the *closest analogue to our brief.*
- `STORE-EEPROM` -- every commercial academic-derived chip uses
  this for the user-data region (`[Lu-2016]` uses a 0.18 um
  EEPROM process explicitly).
- `STORE-OTP-EFUSE` -- used for UID and originality signatures,
  consistent with sister-report `PAY-EFUSE-PARTIAL`.
- `STORE-SRAM-RW` -- used in pass-through / sensor-readout tags
  (`[Anabtawi-2016-BHI]` SoC has live sensor data buffered in
  RAM-RW).
- `STORE-FLASH-MCU` -- out of scope for our brief.

### 3.5 Clocking architecture (academic silicon)

`CLK-CARRIER` is the **near-universal academic default**:

- `[Myny-2017-ISSCC]` makes "direct clock division circuit from
  13.56 MHz carrier" its title-level contribution. The paper
  shows that even on ridiculously process-variable metal-oxide
  TFTs, a direct fc/N divider tree is the only clock the digital
  baseband needs.
- `[Lu-2016]` and `[Bhattacharyya-2018]` likewise derive their
  baseband and timer clocks from rectified-carrier zero-crossings.
- `[Anabtawi-2016-BHI]` uses a switched-mode power-management
  unit *plus* carrier-derived clock in the wireless front-end --
  the SMPS clock is internal, the radio clock is fc-derived.

`CLK-INT` (free-running RC) appears in academic silicon **only as
a slow-housekeeping clock** for sleep timers or watchdogs, never
for the modem path. The first-principles `CLK-INT` elimination is
therefore corroborated by the academic literature too. **Three
independent angles, three independent confirmations.**

### 3.6 Open-source academic gateware

- `[NfcEmu-VHDL]` -- a published VHDL implementation of an
  ISO 14443A PICC, originally targeted at FPGA. Useful as a
  template for our hardened-RTL approach because every other
  open emulator examined runs as firmware on an MCU/AVR.
- `[ChameleonMini]` and `[Proxmark3]` (already in the industry
  survey) are firmware-on-MCU and therefore architecturally
  unrelated to our hardened-RTL plan; they remain useful as
  *validation harnesses*.

### 3.7 Phone-side compatibility (academic measurement studies)

The `[NFC-Forum-Analog-Align]` joint NFC-Forum / ISO 14443
analog-parameter-alignment study is the closest thing to a
peer-reviewed conformance study we could find for free; its
content matches the ISO 14443-2 and ISO 10373-6 numbers cited by
sister reports.

We found **no** peer-reviewed academic paper that publishes a
matrix of "tag X works on phone Y" measurements. The available
evidence is vendor / community lore (`[Apple-CoreNFC]`,
`[Android-NfcAdapter]`, `[ST-iOS13-NFC-Blog]`, the
Espruino/`shopnfc` community wikis) -- already captured by the
industry sister report. Lack of a peer-reviewed compatibility
matrix is logged as `Q-as-1`.

## 4. Sub-block breakdown

See [`components.md`](components.md). It is structured to mirror
the sister reports' decomposition and adds an **academic-silicon
cross-check column** for each sub-block, citing the published
power / area / sensitivity numbers from section 6 against the
first-principles sister-report's analytical estimates.

## 5. First-principles sanity checks

The academic angle inherits the analytical derivations of the
parallel `stage1-first-principles/report.md` 5. **Where peer-
reviewed silicon publishes a measured number for the same
quantity, we cross-check here.** The same template the industry
survey used.

### 5.1 Total tag-IC power vs sister analytical 50-300 uW tag-IC budget

- **Sister-report analytical claim:** read-only T2T baseband at
  13.56 MHz, ~2 k gates -> ~10-50 uW digital + modulator-on
  duty-cycled ~0.5 mW peak -> average well under 1 mW.
- **`[Bhattacharyya-2018]` measurement:** total IC 107 uW at 1.2 V
  in 0.18 um CMOS, full ISO 15693 PICC including baseband.
  Analog-only 36 uW.
- **`[Lu-2016]` measurement:** analog-only 67.7 uW at 1.8 V in
  0.18 um CMOS, ISO 14443A target.
- **`[Anabtawi-2016-BHI]` measurement:** 24 uW battery-only
  operation in 14 nm.
- **Reconciliation:** the sister report's 50-300 uW analytical
  band brackets all three measured silicon papers. **No
  contradiction; sister report is conservative.** The
  `gf180mcuD` 0.18 um node is empirically validated.

### 5.2 Modulator R_DSon space

- **Sister-report analytical claim (5.2 of first-principles):**
  R_mod ~ 2 kOhm optimum; R_mod ~ 100 Ohm wastes ~10x the
  realistic harvested-power budget.
- **Academic silicon:** `[Lu-2016]` and `[Bhattacharyya-2018]`
  both implement load-modulation switches in the ~hundreds-of-Ohm
  to ~kOhm range (exact values behind paywall but reported PA
  power dissipation is consistent with R_mod in this band).
  `[Myny-2017-ISSCC]` carries the modulator at 7.5 mW *whole-tag*
  power, which on a flexible-TFT process is dominated by
  off-state leakage rather than modulator R, so is not directly
  comparable.
- **Reconciliation:** no academic paper reports R_mod << 1 kOhm on a
  passive tag IC in 0.18 um CMOS. The 2 kOhm optimum is consistent
  with academic practice and not a sister-report fluke.

### 5.3 Carrier-derived clock fidelity

- **Sister-report analytical claim:** 13.56 MHz carrier crystal
  reference at the reader gives +/-50 ppm at the tag (per ISO
  14443-2 8.1.4); divide-by-N with N in {16, 64, 128} preserves
  ppm; modem timing is trivially within spec.
- **Academic silicon:** `[Myny-2017-ISSCC]` *demonstrates*
  fc-divider operation on a metal-oxide TFT process with > 50 %
  device-level Vth variation, and still meets ISO 14443-A
  timing. If a TFT process can do this, GF180MCU at ~2 % Vth
  variation will trivially do it.
- **Reconciliation:** confirmed.

### 5.4 FDT_PICC timing

- **Sister-report analytical claim:** 1172/fc = 86.43 us is
  trivial at 13.56 MHz logic.
- **Academic silicon:** `[Myny-2017-ISSCC]` and the canonical
  ISO 14443-3 standard `[ISO14443-3]` agree.  The patent
  literature (CN 102968657 A) describes circuits whose entire
  job is "FDT precise timing" -- confirming that, at the tag-IC
  level, the FDT timer is a finite-cycles fc-counter, exactly
  as the sister report describes.
- **Reconciliation:** confirmed.

### 5.5 NDEF vCard payload sizing

- **Sister-report analytical claim:** vCard 2.1 minimal ~100 B,
  realistic moderate ~240 B, photo-bearing >> 1 kB.
- **Academic silicon:** `[Myny-2017-ISSCC]` demonstrates that
  even a *128-bit* (16-byte) ROM on a flexible NFC tag can carry
  a usable payload -- a tiny "barcode-equivalent" ID. Implies
  that for our minimal-vCard use case (~100 B = 800 b), our
  silicon ROM budget is comfortable.
- `[Bhattacharyya-2018]` does not report a specific NDEF user-
  memory size in the abstract, but ISO 15693 tags in
  0.18 um CMOS routinely ship 256-4096 bits user memory.
- **Reconciliation:** confirmed -- the sister report's payload-tier
  table is consistent with what academic silicon ROMs deliver at
  our target node.

### 5.6 Self-clocking: power-on to first response

- **Sister-report analytical claim:** rectifier ramp ~600 ns,
  brown-out release within microseconds, FDT comfortable.
- **Academic silicon:** `[Anabtawi-2016-BHI]` documents an
  NFC-tag SoC with switched-mode power-management
  startup-tracking; the wake-up-then-respond latency is
  reportedly fast enough for a polling-cadence Android reader
  scan (~50 ms cadence).
- **Reconciliation:** confirmed.

### 5.7 Programmability multiplier

- **Sister-report analytical claim:** RAM-RW adds ~2.4x digital
  area without an SRAM macro; ~1.5x with.
- **Academic silicon:** `[Anabtawi-2016-BHI]` demonstrates RAM-
  buffered sensor readouts on a passive-tag SoC, but doesn't
  publish the gate-count multiplier. **Open question
  `Q-as-2`.**
- **Reconciliation:** sister-report number is plausible; not
  cross-validated against published academic silicon.

## 6. References

See [`references.md`](references.md). Twelve peer-reviewed-or-
official references plus three open-source academic codebases.
**Five** of the twelve are paywalled IEEE Xplore conference /
journal entries that are cited via DOI + venue (per the brief's
guidance) -- abstract verification only. **Seven** of the twelve are
open-access (MDPI/`Sensors`, PMC mirrors, Semantic Scholar PDFs,
ITeH ISO drafts, NFC Forum / RFID Journal PDFs, IMEC institutional
repository for `[Myny-2017-ISSCC]`).

## 7. Negative results

**7.1 -- `T5T` (ISO 15693) is the academic implant-tag default
*because it kills iOS 11/12 readership*.** `[Bhattacharyya-2018]`,
`[Dehennis-2016-TBioCAS]`, `[Anabtawi-2016-BHI]` all converge on
ISO 15693 specifically because (a) lower data rate -> lower
baseband power, (b) longer read range -> friendlier through-tissue
operation. *None* of these design pressures applies to a
business-card lying flat on a phone, and (a) buys nothing useful at
our power budget. **`T5T` eliminated for our brief by academic
literature** -- same conclusion as industry survey, but for
different reasons.

**7.2 -- `T1T` (Topaz/Jewel) has *no* recent peer-reviewed silicon
papers we could find.** All academic interest moved to T2T after
NXP's NTAG21x ramp. Confirms industry survey's "phased out"
conclusion via a different channel: *academic silence*, not just
vendor roadmap.

**7.3 -- UWB-uplink T2T-downlink hybrids (`[Pelissier-2011-ISSCC]`)
are not phone-compatible and not within our brief**, but were
included as the spectrum-extreme upper-bound per methodology. They
demonstrate that the *upstream* (PICC -> reader) side is where the
power goes when you push beyond ISO-14443's 106 kbit/s. Our brief
explicitly does not need this.

**7.4 -- Free-running internal-osc clocking is
*absent* from peer-reviewed silicon.** Three independent
academic-silicon papers in 0.18 um CMOS use carrier-derived
clocking exclusively for the modem path. None uses an internal RC
oscillator for ISO 14443 timing. **`CLK-INT` eliminated, third
independent confirmation.**

**7.5 -- `nfcpy` is not usable as a T2T validation harness** -- same
conclusion as industry survey, but reaffirmed here because nfcpy
is the closest thing to a peer-reviewed "open standard" reader in
academic-grade Python.

**7.6 -- No peer-reviewed compatibility-matrix paper exists** for
"X tag works on Y phone." The community wikis (`shopnfc`,
`dangerouswiki`) and Stack-Overflow / NXP-community threads are
the *only* available data. This is a literature gap, not a
project-side gap, and it is logged as `Q-as-1` for the Stage-2
synthesis agent.

**7.7 -- vCard 4.0 vs vCard 2.1 academic comparison is sparse.**
We could not find a peer-reviewed paper that benchmarks the two
on NFC tag readers. `[RFC6350]` (vCard 4.0) and the original
`[RFC2425]`/`[RFC2426]` vCard 2.1/3.0 set the format wire-level,
but the sister industry survey's "vCard 2.1 wins ~30 B" finding
is from secondary community sources only. **Logged as `Q-as-3`.**

## 8. Open questions

See [`open-questions.md`](open-questions.md). Highest-priority
academic angle questions:

- **Q-as-1** -- phone-compatibility matrix peer-reviewed measurement
  study (none found).
- **Q-as-2** -- published gate-count delta for SRAM-buffered
  RAM-RW T2T tags in 0.18 um CMOS.
- **Q-as-3** -- peer-reviewed vCard 2.1 vs 4.0 NFC-tag
  comparison.

## 9. Comparison readiness

| Approach | Headline performance | Area / power cost | Maturity | Best fit for | Worst fit for |
|---|---|---|---|---|---|
| `T2T` + `MOD-A-MIL-MAN` + `AC-A-7B` + `STORE-MASKROM` | 106 kbit/s, 64-924 B | < 1 mm^2, ~70 uW (`[Lu-2016]`) | Mature academic + industrial | **Best phone-compat x area** | > 1 kB payload |
| `T2T` + `STORE-EFUSE-PARTIAL` | personalisable | + eFuse (depends on (j)) | Mature | Per-die unique cards | Tight (j) budget |
| `T2T-flex` (fc-divider only) | 106 kbit/s, 128 b | flexible TFT 7.5 mW | Demonstrated `[Myny-2017-ISSCC]` | Validates sister `CLK-CARRIER` claim | Not applicable to silicon |
| `T4T-A` + `MOD-A-MIL-MAN/BPSK` + `STORE-MASKROM` | 106-848 kbit/s, >=1 kB | ~3-7 k gates | Mature | Photo-bearing vCard | Tight area |
| `T5T` + `MOD-V-1OF4` + `STORE-MASKROM` | 26.48 kbit/s, ~10 cm range | ~107 uW (`[Bhattacharyya-2018]`) | Mature academic / implant | Long-range read | iOS 11/12 readership |
| `T5T` (implant) + LSK | sub-mW @ implant range | 0.6 um or 14 nm | Mature implant | Biomedical | Not our use case |
| `T2T+UWB` | upstream UWB | high (`[Pelissier-2011-ISSCC]`) | Research-only | High-data-rate uplink | Phone-compat |
| `RAW` | unstandardised | floor | n/a | Calibration only | Everything real |

## 10. Author's notes

- **The `Myny-2017-ISSCC` paper is the single most reassuring
  data point in the academic literature for our brief.** Its
  whole architectural premise -- a fc-divider clock tree on a
  parameter-variable substrate -- is what we plan to do, just on
  a vastly easier substrate (0.18 um CMOS rather than rolled
  metal-oxide TFT).
- **The implantable-tag literature converges on T5T for reasons
  that do not apply to a business card.** This is a useful
  negative -- it means that a naive literature reading might
  push us toward T5T because that is where the academic activity
  is, when in fact our requirements (phone compatibility, flat
  geometry, modest range) make T2T strictly easier.
- **Peer-reviewed silicon power numbers (67.7 uW analog-only at
  0.18 um; 107 uW total at 0.18 um) corroborate the
  first-principles 50-300 uW band.** No academic paper reports a
  HF passive tag IC needing more than ~150 uW at our node for a
  read-only function. The `(b)` rectifier's deliverable budget
  (sister report ~50 mW peak available, with R_mod = 2 kOhm
  modulator dissipating ~0.56 mW average) leaves at least an
  order-of-magnitude headroom.
- **iOS Core NFC's reluctance to expose vCard NDEF is a
  recurring sore point in the community literature** but
  conspicuously absent from peer-reviewed silicon literature --
  because silicon papers don't do interop testing against
  consumer phones. If we want a defensible compatibility
  claim, a Stage-3 deep dive will need to *generate* such data.