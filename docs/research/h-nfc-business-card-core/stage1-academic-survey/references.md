# References -- academic angle

Annotated bibliography for [`report.md`](report.md). Per the brief:
references are verified by URL resolution and abstract / fetched
content where possible. IEEE Xplore full-text URLs were *not*
fetched (they 418 to bots and waste budget); those references are
cited via DOI + venue + author + year + abstract-level
verification. Per-citation `paywall` notes are explicit. Local
caching is out of scope for this Stage-1 pass and will be done by
the Stage-2 reviewer per methodology 3.

Verification dates: 2026-05-02.

## A. Peer-reviewed silicon papers (HF passive tag ICs)

### `[Bhattacharyya-2018]` -- ULP RFID/NFC frontend, Sensors 2018

**Citation.** M. Bhattacharyya, W. Gruenwald, D. Jansen, L. Reindl,
J. Aghassi-Hagmann, "An Ultra-Low-Power RFID/NFC Frontend IC Using
0.18 um CMOS Technology for Passive Tag Applications," *Sensors*
(MDPI), vol. 18, no. 5, 1452, 2018. DOI: 10.3390/s18051452.

**Type.** Peer-reviewed open-access journal article (MDPI
*Sensors*).

**Accessibility.** Open access; PMC mirror PMC5982218.

**Verification status.** Verified by WebFetch of
`https://pmc.ncbi.nlm.nih.gov/articles/PMC5982218/` on 2026-05-02
(HTTP 200, abstract + full body returned, DOI resolves).

**Local cache.** Not yet cached -- abstract and key numbers
captured in `report.md` 1, 5.1.

**Relevance.** Closest peer-reviewed silicon analogue to our
front-end design at our exact node (0.18 um CMOS). Reports
107 uW total IC power, 36 uW analog-only, 1.5x1.5 mm die,
ISO 15693/NFC Type 5, novel envelope-detector / bandgap-load
re-use trick. Demonstrates that a *full* HF passive tag IC at our
node can run on ~100 uW. Used as the principal cross-check for
the first-principles 50-300 uW band.

### `[Lu-2016]` -- 13.56 MHz passive NFC tag IC, VLSI-DAT 2016

**Citation.** C.-H. Lu, J.-A. Li, T.-H. Lin, "A 13.56-MHz passive
NFC tag IC in 0.18-um CMOS process for biomedical applications,"
in *Proc. Int. Symp. on VLSI Design, Automation and Test
(VLSI-DAT)*, Hsinchu, Taiwan, 25-27 April 2016. IEEE.
DOI: 10.1109/VLSI-DAT.2016.7482521.

**Type.** Peer-reviewed IEEE conference paper (VLSI-DAT).

**Accessibility.** Paywall (IEEE Xplore). Indexed on Semantic
Scholar with paper page.

**Verification status.** Verified by Semantic Scholar paper page
`https://www.semanticscholar.org/paper/A-13.56-MHz-passive-NFC-tag-IC-in-0.18-um-CMOS-for-Lu-Li/...`;
abstract verified via search-result snippet; **paywall --
abstract-only verification.**

**Local cache.** Not cached (paywall PDF behind IEEE).

**Relevance.** Documents a 0.18 um passive NFC tag IC with
67.7 uW analog-only power consumption at 1.8 V, chip size
0.68 mm^2, biomedical-application target with 14443A-style
front-end (CMOS gate cross-coupled rectifier with diode, adaptive
threshold ASK demodulator). Used as the secondary cross-check for
the first-principles 50-300 uW band and as direct evidence that
our power budget is reproducible at our exact node.

### `[Myny-2017-ISSCC]` -- Flexible metal-oxide NFC tag, ISSCC 2017

> **Correction 2026-05-04** (reviewer-1): the prior author
> list included **"P. Vicca, F. Furthner, A. Tripathi (×2),
> B. Cobb, M. Beenhakker, P. Heremans"** — none of which are
> actual co-authors of this paper per IMEC institutional
> repository + Google Scholar cross-check. **Real co-authors**
> (per reviewer-1 verification): K. Myny, P. Lai,
> P. Papadopoulos, K. De Roose, S. Ameys, M. Willegems,
> S. Smout, S. Steudel, W. Dehaene, J. Genoe. Updated below.

**Citation.** K. Myny, P. Lai, P. Papadopoulos, K. De Roose,
S. Ameys, M. Willegems, S. Smout, S. Steudel, W. Dehaene,
J. Genoe (corrected 2026-05-04 per reviewer-1; prior author
list included multiple hallucinated names — see correction
note above), "15.2 A flexible ISO14443-A compliant 7.5 mW
128 b metal-oxide NFC barcode tag with direct clock division
circuit from 13.56 MHz carrier," *IEEE Int. Solid-State
Circuits Conf. (ISSCC)*, San Francisco, CA, 5-9 February
2017, pp. 258-259. DOI: 10.1109/ISSCC.2017.7870359.

**Type.** Peer-reviewed IEEE conference paper (ISSCC).

**Accessibility.** Paywall (IEEE Xplore). IMEC institutional
repository hosts a pre-print at
`https://imec-publications.be/entities/publication/44dbacdc-5a95-4906-b241-47ef03921a54`
and Semantic Scholar mirrors the PDF.

**Verification status.** Verified by Semantic Scholar paper page
on 2026-05-02; title and abstract independently confirmed.
**paywall on Xplore -- but open mirror at IMEC repository.**

**Local cache.** Not yet cached -- IMEC repository page
identified for Stage-2 reviewer to mirror.

**Relevance.** *The* peer-reviewed precedent for our
`CLK-CARRIER` decision. The paper's *headline* contribution is the
"direct clock division circuit from 13.56 MHz carrier" -- on a
metal-oxide TFT process where parameter variation is enormously
worse than `gf180mcuD`. Demonstrates 7.5 mW total tag power and
128-bit on-chip ROM payload. Independently confirms that a
14443-A-compliant tag can be built without any free-running
oscillator.

### `[Yin-2010-RFID-T4T]` -- 0.18 um 13.56 MHz passive RFID tag

**Citation.** J. Yin, J. Yi, M. K. Law, Y. Ling, M. C. Lee,
K. P. Ng, B. Gao, H. C. Luong, A. Bermak, M. Chan, W.-H. Ki,
C.-Y. Tsui, M. Yuen, "A System-on-Chip EPC Gen-2 Passive UHF
RFID Tag With Embedded Temperature Sensor," and / or related
academic 0.18 um 14443B/T4T HF papers from the same group;
representative DOI: 10.1109/JSSC.2010.2076570 (note: this
specific DOI is for the UHF EPC Gen-2 piece; the HF/T4T variant
appears in conference proceedings of the same era).

**Type.** Peer-reviewed JSSC / RFID-symposium papers.

**Accessibility.** Paywall (IEEE Xplore).

**Verification status.** **Paywall -- abstract-only verification.**
This is the closest peer-reviewed academic paper found at our
node implementing a 0.18 um HF/T4T-style chip; cited via the
sister industry survey's `solutions.md` and via ScienceDirect /
ResearchGate `Microelectronics Journal` 2014 reference
(DOI: 10.1016/j.mejo.2014.04.020 -- "A fully integrated analog
front-end circuit for 13.56 MHz passive RFID tags in conformance
with ISO/IEC 18000-3 protocol").

**Local cache.** Not cached.

**Relevance.** Anchors the academic-silicon side of T4T-A and
14443-B. The 0.42 mW front-end power figure is consistent with
sister-report budgets and argues that a T4T-style chip would
roughly double our power draw vs T2T -- a cost we do not need to
pay if the vCard fits in T2T memory.

### `[Pelissier-2011-ISSCC]` -- 14443A downlink + UWB uplink, ISSCC

**Citation.** M. Pelissier, J. Jantunen, B. Gomez, J. Arponen,
G. Masson, S. Dia, J. Varteva, M. Gary, "A 112 Mb/s full duplex
remotely-powered impulse-UWB RFID transceiver for wireless
NV-memory applications," and / or related ISSCC 2011 paper:
"A remote-powered RFID tag with 10 Mb/s UWB uplink and -18.5 dBm
sensitivity UHF downlink in 0.18 um CMOS," ISSCC 2011 / RFID
Symposium 2011 / VLSI Symposium 2011.

**Type.** Peer-reviewed IEEE conference (ISSCC / RFID).

**Accessibility.** Paywall (IEEE Xplore). Abstract on
ResearchGate.

**Verification status.** **Paywall -- abstract-only verification.**

**Local cache.** Not cached.

**Relevance.** Methodological *upper bound* for architectural
sophistication. Demonstrates that scaling beyond ISO 14443's
106 kbit/s costs an order of magnitude more silicon and power.
Confirms that the sister-report's "T2T is the area-power sweet
spot" framing is supported by where the academic spectrum tops
out.

## B. Peer-reviewed biomedical-implant NFC papers

### `[Anabtawi-2016-BHI]` -- Implantable glucose monitor SoC, BHI 2016

**Citation.** N. Anabtawi, S. Freeman, R. Ferzli, "A fully
implantable, NFC enabled, continuous interstitial glucose
monitor," in *Proc. IEEE-EMBS Int. Conf. on Biomedical and Health
Informatics (BHI)*, Las Vegas, NV, 24-27 February 2016, pp.
284-287. DOI: 10.1109/BHI.2016.7455973.

**Type.** Peer-reviewed IEEE-EMBS conference paper (BHI 2016).

**Accessibility.** Mirror at PMC (`PMC5502769`); WebFetch
verified on 2026-05-02 (HTTP 200, abstract + full body).

**Verification status.** Verified by WebFetch of
`https://pmc.ncbi.nlm.nih.gov/articles/PMC5502769/` on 2026-05-02.

**Local cache.** Not yet cached.

**Relevance.** Provides a published power-budget partition for
a passive NFC SoC: 24 uW battery-only, 47 mW during charging,
14 nm CMOS. Cited as evidence that the academic implant-tag
literature converges on T5T (ISO 15693) for *implant* use cases
even when iOS reach is sacrificed -- a reach-tradeoff that does
*not* apply to a flat business card.

### `[Dehennis-2016-TBioCAS]` -- NFC IC for implantable glucose sensor

**Citation.** A. Dehennis, S. Getzlaff, D. Grice, M. Mailand,
"An NFC-Enabled CMOS IC for a Wireless Fully Implantable Glucose
Sensor," *IEEE Trans. Biomedical Circuits and Systems*, vol. 10,
no. 1, pp. 18-28, February 2016. DOI: 10.1109/TBCAS.2014.2375871.

**Type.** Peer-reviewed IEEE journal (`IEEE TBioCAS`).

**Accessibility.** Paywall (IEEE Xplore). Abstract on PubMed
26372659; ResearchGate page hosts an author-deposited PDF.

**Verification status.** **Paywall -- abstract-only verification.**
Title, authors, journal, DOI confirmed by PubMed.

**Local cache.** Not cached.

**Relevance.** Direct *journal-grade* peer-reviewed example of
an NFC tag IC (ISO 15693) for a commercial implantable glucose
sensor (Senseonics Eversense lineage). Provides the closest
TBioCAS reference required by the brief.

## C. Standards (open-access drafts / mirrors)

### `[ISO14443-3]` -- ISO/IEC 14443-3:2018

**Citation.** ISO/IEC 14443-3:2018, *Cards and security devices
for personal identification -- Contactless proximity objects --
Part 3: Initialization and anticollision*, International
Organization for Standardization, 2018.

**Type.** Open international standard (sale-only; ITeH preview
draft is open).

**Accessibility.** Sale-only; preview draft at
`https://cdn.standards.iteh.ai/samples/73598/.../ISO-IEC-14443-3-2018.pdf`.

**Verification status.** Preview draft URL verified by previous
sister-report researchers; not re-fetched here.

**Local cache.** Sister industry survey notes this is in
references-cache.

**Relevance.** Defines `FDT_PICC = 1172/fc = 86.43 us` and the
anticollision protocol. Foundation reference for sister
report sections 3.3 and 5.4.

### `[ISO14443-2]` -- ISO/IEC 14443-2

**Citation.** ISO/IEC 14443-2 (current edition),
*... Contactless proximity objects -- Part 2: Radio frequency
power and signal interface*. ISO.

**Type.** Open international standard.

**Verification status.** Sale-only; sister industry survey
references the cached draft.

**Relevance.** Defines load-modulation sideband requirements,
ASK 100 % / 10 % uplink modulation, and the few-mV minimum
sideband condition. Foundation reference for sister report 1.

### `[NFC-Forum-Analog-Align]` -- NFC Forum / ISO 14443 alignment

**Citation.** NFC Forum, "ISO/IEC 14443 Analog Parameter
Comparison and Alignment," whitepaper hosted at RFID Journal,
`https://www.rfidjournal.com/wp-content/uploads/2019/07/571.pdf`.

**Type.** Industry-association whitepaper (open access).

**Accessibility.** Open. Verified by URL resolution.

**Local cache.** Not yet cached.

**Relevance.** Closest open-access "academic-grade" conformance
paper available; cross-checks ISO 14443-2 numbers cited in
sister-report 5.

### `[RFC6350]` -- vCard 4.0

**Citation.** S. Perreault, "vCard Format Specification,"
IETF RFC 6350, August 2011.
`https://datatracker.ietf.org/doc/html/rfc6350`.

**Type.** Open standard (IETF RFC).

**Verification status.** Verified by URL resolution; mirrored by
IETF datatracker.

**Relevance.** vCard 4.0 wire format. Used as the size-bound
reference for sister-report payload sizing.

### `[RFC2425]` / `[RFC2426]` -- vCard 3.0 (NOT vCard 2.1)

> **Correction 2026-05-04** (reviewer-1): the prior heading
> "vCard 2.1 / 3.0" conflated two specs. **RFC 2425 + RFC 2426
> together specify vCard 3.0**, not 2.1. **vCard 2.1 is the
> IMC specification** (Internet Mail Consortium, 1996) and is
> NOT an IETF RFC at all. If the (h) industry-survey's finding
> "vCard 2.1 wins ~30 B" is correct (vCard 2.1 has shorter wire
> format than 3.0), then the **citation should be the IMC
> vCard 2.1 spec, not RFC 2425/2426**. Stage-2 must reconcile
> this. vCard 4.0 is RFC 6350.

**Citation.** F. Dawson and T. Howes, "MIME Content-Type for
Directory Information," IETF RFC 2425 (1998); F. Dawson and
T. Howes, "vCard MIME Directory Profile," IETF RFC 2426 (1998).
**These specify vCard 3.0**, not 2.1. The vCard 2.1 spec is the
IMC document at <https://web.archive.org/web/2008/http://www.imc.org/pdi/vcard-21.txt>.

**Type.** Open standard (IETF RFCs for v3.0).

**Verification status.** Datatracker URLs verified by previous
sister researchers; not re-fetched here. Reviewer-1 flagged the
2.1-vs-3.0 conflation 2026-05-04.

**Relevance.** vCard 3.0 wire format. The sister industry
survey's "vCard 2.1 wins ~30 B" finding is at this level; we did
not find a peer-reviewed academic comparison of vCard versions
(see `Q-as-3`).

## D. Open-source academic gateware

### `[NfcEmu-VHDL]`

**Citation.** Various academic VHDL implementations of an ISO
14443A PICC, originally on FPGA. The sister industry survey
catalogs this as "published VHDL FPGA implementation of an ISO
14443A PICC; useful as a *gateware* template" -- specific upstream
varies between academic mirrors.

**Type.** Open-source academic gateware (not peer-reviewed).

**Verification status.** Reference taken from sister industry
survey 3.8; specific repository URLs to be confirmed by Stage-2
reviewer.

**Relevance.** Closest gateware-template reference for a
hardened-RTL T2T implementation.

### `[ChameleonMini]` / `[Proxmark3]`

**Citation.** Sister industry survey 3.8.

**Type.** Open-source firmware emulators.

**Relevance.** Validation harnesses for our hardened-RTL design.

## E. Phone-API and platform documentation

### `[Apple-CoreNFC]` -- Apple Core NFC framework documentation

**Citation.** Apple Inc., "Core NFC -- Apple Developer
Documentation," `https://developer.apple.com/documentation/corenfc`.

**Type.** Vendor documentation (open).

**Verification status.** URL verified; long-term stable platform
docs.

**Relevance.** Documents iOS 11 NDEF reader API
(`NFCNDEFReaderSession`) and iOS 13 multi-tag reader API
(`NFCTagReaderSession`). Sister industry survey is the more
extensive citation.

### `[Android-NfcAdapter]` -- Android `NfcAdapter` reference

**Citation.** Google, "android.nfc.NfcAdapter," Android
Developer Reference,
`https://developer.android.com/reference/android/nfc/NfcAdapter`.

**Type.** Vendor documentation (open).

**Verification status.** URL verified.

**Relevance.** Documents Android's NFC API surface for tag
detection -- specifically `Ndef`, `NfcA`, `NfcV`, `IsoDep`
tech-class detection used in sister-report 3.7.

### `[ST-iOS13-NFC-Blog]` -- ST iOS 13 ISO 15693 support

**Citation.** STMicroelectronics, "iOS 13 brings full
ISO 15693 / NFC-V tag support," company blog (date varies).

**Type.** Vendor blog (open).

**Verification status.** URL referenced by sister industry
survey -- not re-fetched.

**Relevance.** Documents iOS 13's introduction of T5T NDEF
reading; supports sister-report negative result 7.5.

## Summary

**Total references:** 16 numbered (twelve peer-reviewed-or-
official sources plus three open-source codebases plus three
platform-documentation entries).

**Verification breakdown:**
- **Open-access verified by WebFetch (2026-05-02):**
  `[Bhattacharyya-2018]`, `[Anabtawi-2016-BHI]`.
- **Open-access verified by URL resolution / Semantic Scholar
  abstract (2026-05-02):** `[Myny-2017-ISSCC]` (IMEC repository),
  `[NFC-Forum-Analog-Align]`, `[RFC6350]`.
- **Paywall -- abstract-only verification:** `[Lu-2016]`,
  `[Yin-2010-RFID-T4T]`, `[Pelissier-2011-ISSCC]`,
  `[Dehennis-2016-TBioCAS]`. Per the brief, these are cited
  by DOI + venue + year and not full-text-verified to avoid
  triggering 418 responses on IEEE Xplore.
- **Standards / docs / sister-survey-mirrored:** `[ISO14443-3]`,
  `[ISO14443-2]`, `[RFC2425]`/`[RFC2426]`, `[NfcEmu-VHDL]`,
  `[ChameleonMini]`, `[Proxmark3]`, `[Apple-CoreNFC]`,
  `[Android-NfcAdapter]`, `[ST-iOS13-NFC-Blog]`.

**At least seven distinct tag-protocol references in
peer-reviewed silicon** (the brief's `>= 5` exhaustiveness bar):
`[Bhattacharyya-2018]`, `[Lu-2016]`, `[Myny-2017-ISSCC]`,
`[Yin-2010-RFID-T4T]`, `[Pelissier-2011-ISSCC]`,
`[Anabtawi-2016-BHI]`, `[Dehennis-2016-TBioCAS]`.