# References — academic angle

Annotated bibliography for `stage1-academic-survey/`.
Verification status as of 2026-05-04. Cite-IDs match those used
in `report.md`, `solutions.md`, and `components.md`.

Verification key:
- **L** = locally cached + read in full
- **W** = WebFetch verified (URL resolves, content matches
  citation)
- **G** = Google Patents verified (free full-text)
- **P** = Paywalled — abstract / DOI / venue verified only
- **S** = Search-result verified (URL resolves to citation
  metadata, full text not retrieved)

---

## Foundational silicide-EM eFuse physics

### KOTHANDARAMAN-2002-EDL [L]

C. Kothandaraman, S. K. Iyer, S. S. Iyer, "Electrically
Programmable Fuse (eFUSE) Using Electromigration in Silicides",
*IEEE Electron Device Letters*, vol. 23, no. 9, pp. 523–525,
Sept 2002. DOI: 10.1109/LED.2002.802657. **Local cache:**
`references-cache/kothandaraman-2002-edl/efuse-edl-v23n9-2002.pdf`,
read in full (211 lines extracted via pdftotext). **Type:**
Peer-reviewed conference letter. **Relevance:** Original
disclosure of silicide-EM as a positive engineering mechanism;
0.12 µm CMOS; 200 µs program at V_FS = 3.3 V, I_pk = 10 mA;
transient R = 360 Ω during steady portion of pulse.

### TONTI-2003-IRW [L]

W. R. Tonti, J. A. Fifield, I. Higgins, W. H. Guthrie, W. Beny,
C. Narayan, "Product Specific Sub-Micron E-Fuse Reliability and
Design Qualification", in *2003 IEEE International Reliability
Workshop Final Report*, pp. 36–40 (also republished in IRPS
2004 Proceedings p. 161). **Local cache:**
`references-cache/tonti-2003-irw/product-specific-submicron-efuse.pdf`,
read in full (548 lines). **Type:** Peer-reviewed conference
paper. **Relevance:** Foundational E-Fuse-A-vs-B reliability
qualification on 0.14 µm CMOS 256M SDRAM scribe-line; defines
the 25 × 10 µs pulse train at 4.7 V / 5 mA programming
schedule, the cold-vs-hot programming envelope, the latch trip
point, and the 504-fuse Bond-Pad Macro test architecture.

### TONTI-2008-SSIRI [L]

W. R. Tonti, "eFuse Design and Reliability", IBM Semiconductor
Research and Development Corp., invited paper at *2008 SSIRI
Workshop*, online at
`ssiri08.techconf.org/Tonti_SSIRI_eFuse_V2.pdf`. **Local cache:**
`references-cache/tonti-2008-ssiri/efuse-design-and-reliability.pdf`,
read in full (219 lines). **Type:** Invited workshop paper
(industrial review). **Relevance:** Updates 2003 results to
90 nm SOI; explicit statement that programmed R ≥ 10¹⁰ Ω is
"at test resolution"; "one chance" programming model.

### TIAN-2006-IRPS [P]

C. Tian, M. Lai, A. Cestero, M. Choe, A. Cassens, "Reliability
Qualification of CoSi₂ Electrical Fuse for 90Nm Technology",
in *2006 IEEE International Reliability Physics Symposium
Proceedings*, p. 392. DOI: 10.1109/RELPHY.2006.251247. **Type:**
Peer-reviewed conference paper. **Verification:** paywall —
abstract-only; cited by Tonti 2008 [3]. **Relevance:** Direct
90 nm successor to Tonti 2003; demonstrates topology scales.

### CHOI-2007-IRPS / HSUEH-2007-IRPS [S]

C.-H. Choi et al. (also referenced as Hsueh in some indices),
"Characterization of Silicided Polysilicon Fuse Implemented in
65nm Logic CMOS Technology", in *2007 IEEE IRPS Proceedings*.
URL: `ieeexplore.ieee.org/document/4228436`. **Type:** Peer-
reviewed. **Verification:** search-result-only (URL resolves;
IEEE Xplore paywall blocks WebFetch). **Relevance:** First
NiSi-class silicided poly fuse characterisation; programmed-R
distribution heavy-tail observation.

### ROBSON-2007-CICC [P]

N. Robson, J. Safran et al., "Electrically Programmable Fuse
(eFUSE): From Memory Redundancy to Autonomic Chips", in *2007
IEEE Custom Integrated Circuits Conference (CICC)*, pp. 799–
804. DOI: 10.1109/CICC.2007.4405850. Semantic Scholar:
`semanticscholar.org/paper/22ad684ab19e27fd42dacfe774842e28437053d3`.
**Type:** Peer-reviewed conference review paper. **Verification:**
metadata via Semantic Scholar; figures viewable. **Relevance:**
IBM 90→45 nm eFuse evolution; introduces brown-out-detector
inhibition for sense-amp metastability mitigation; chip-ID
3-fuse-vote redundant programming.

### KALNITSKY-1999-IEDM [P]

A. Kalnitsky, I. Saadat, A. Bergemont, P. Francis, "CoSi₂
integrated fuses on polysilicon for low voltage 0.18µm CMOS
applications", in *1999 IEDM Technical Digest*. **Type:** Peer-
reviewed. **Verification:** paywall; cited by Tonti 2003 [4].
**Relevance:** First academic CoSi₂ fuse on intrinsic-poly at
0.18 µm — predecessor that Tonti 2003 explicitly improves upon
(by switching from intrinsic to N⁺ poly).

### ALAVI-1997-IEDM [P]

M. Alavi, M. Bohr, J. Hicks, M. Denham, A. Cassens, D. Douglas,
M.-C. Tsai, "A PROM element based on salicide agglomeration of
poly fuses in a CMOS logic process", in *1997 IEDM Technical
Digest*, pp. 855–858. **Type:** Peer-reviewed. **Verification:**
paywall; cited by Kothandaraman 2002 [2]. **Relevance:** The
*predecessor* to silicide-EM eFuse — Intel's salicide-
agglomeration PROM, which Kothandaraman 2002 explicitly notes
"do not exhibit consistent behavior and were found to be
unstable with thermal cycling".

### COLGAN-1996-MSER [P]

E. G. Colgan, J. P. Gambino, Q. Z. Hong, "Formation and
stability of silicides in polycrystalline silicon", *Materials
Science and Engineering: R: Reports*, vol. 16, no. 2, pp.
43–96, Feb 1996. **Type:** Peer-reviewed review. **Verification:**
paywall — citation verified via DOI 10.1016/0927-796X(95)00187-5;
cited by both Kothandaraman 2002 [3] and Tonti 2003 [3].
**Relevance:** Underlying silicide-on-polysilicon physics for
the EM-based eFuse mechanism.

### HUANG-1996-PRL [P]

J. S. Huang, H. K. Liou, K. N. Tu, "Polarity effect of
electromigration in NiSi contacts on Si", *Physical Review
Letters*, vol. 76, no. 13, pp. 2346–2349, 1996. DOI:
10.1103/PhysRevLett.76.2346. **Type:** Peer-reviewed.
**Verification:** DOI confirmed; cited by Kothandaraman 2002
[1]. **Relevance:** Polarity-effect physics that defines the
larger-cathode-than-link geometry ratio in Kothandaraman's
eFuse.

---

## eFuse OTP macro / array design

### KIM-2011-JSTS [W]

J.-H. Kim, D.-H. Kim, L. Jin, P.-B. Ha, Y.-H. Kim, "Design of
1-Kb eFuse OTP Memory IP with Reliability Considered", *JSTS:
Journal of Semiconductor Technology and Science*, vol. 11,
no. 2, pp. 88–94, June 2011. URL:
`koreascience.or.kr/article/JAKO201120956423087.page`. **Type:**
Peer-reviewed open-access journal. **Verification:** WebFetch
2026-05-04 (citation, abstract, key numbers extracted).
**Relevance:** 0.18 µm 1-Kb eFuse OTP with reduced read current
(728 µA → 61 µA via optimized read transistor); sense circuit
tolerates ~9 kΩ drop in programmed fuse resistance — the
*hard floor* for usable post-program R.

### CHOI-2012-JCSU [P]

D. Choi et al., "Design of an 8 bit differential paired eFuse
OTP memory IP reducing sensing resistance", *Journal of Central
South University*, 2012. DOI: 10.1007/s11771-012-0987-4. URL:
`link.springer.com/article/10.1007/s11771-012-0987-4`. **Type:**
Peer-reviewed open-access. **Verification:** DOI resolves;
abstract contains "229.04 µm × 100.15 µm" macro footprint claim
(verified via search snippet). **Relevance:** Differential-
paired eFuse architecture cuts cell count and improves sense
margin vs single-ended-with-reference; D-flip-flop-based sense
amp.

### WANG-2014-ASICON [P]

W. Wang et al., "A gate-oxide-breakdown antifuse OTP ROM array
based on TSMC 90nm process", in *2014 IEEE 12th ASICON
Proceedings*. URL:
`ieeexplore.ieee.org/document/7132015`. **Type:** Peer-
reviewed. **Verification:** ResearchGate paper-page metadata
verified; full text paywalled. **Relevance:** 6.5 V optimal
programming voltage at 90 nm; 3T variant reduces stddev
15.3–80.3 % vs 2T at 18 % area cost.

### LEE-2011-JSTS [P]

J. Lee et al., "A 32-KB standard CMOS antifuse one-time
programmable ROM embedded in a 16-bit microcontroller", *JSTS*
2011. URL: `researchgate.net/publication/2983238`. **Type:**
Peer-reviewed. **Verification:** ResearchGate metadata.
**Relevance:** Largest standard-CMOS antifuse OTP at 0.18 µm
class — 32 Kb integrated in production 16-bit MCU.

### KIM-2007-OTPROM [P]

S.-S. Kim et al., "Three-transistor one-time programmable (OTP)
ROM cell array using standard CMOS gate oxide antifuse",
ResearchGate publication 3254633. **Type:** Peer-reviewed.
**Verification:** ResearchGate metadata. **Relevance:** Earliest
3T-cell description; the cell that Wang 2014 builds on.

### HAN-2019-EDL [W]

J.-W. Han, D.-I. Moon, M. Meyyappan, "One Time Programmable
Antifuse Memory Based on Bulk Junctionless Transistor",
*IEEE Electron Device Letters*, 2019, NASA Ames open-access
preprint at `ntrs.nasa.gov/api/citations/20190002597/downloads/
20190002597.pdf`. **Type:** Peer-reviewed. **Verification:**
WebFetch to NASA NTRS, full text retrieved 2026-05-04.
**Relevance:** Survey-quality taxonomy of 1T / 1.5T / 2T / VCM
antifuse cells with refs [4]–[7] to the canonical academic
papers; the citation tree we lean on for 0.18 µm-class antifuse.

---

## Sidense / Synopsys / patents (industry-overlap, peer-

reviewed adjacent)

### SIDENSE-US-7402855 [G]

W. Kurjanowicz et al., "Split-channel antifuse array
architecture", US Patent 7,402,855, issued 22 July 2008
(Sidense Corp., now Synopsys). **Type:** US patent.
**Verification:** Google Patents free full-text, retrieved
2026-05-04. **Relevance:** The split-channel 1.5T antifuse cell
that became the Sidense / Synopsys DesignWare antifuse OTP IP;
8 V program in 1.8 V process.

### TONTI-PATENT-US-7485944 [G]

W. R. Tonti, "Programmable electronic fuse", US Patent
7,485,944, IBM. **Type:** US patent. **Verification:** Google
Patents free full-text. **Relevance:** Corroborates Tonti 2003
silicon results — programming voltage 3.3–5.0 V, current
10–15 mA, pulse 150–250 µs.

---

## Gate-oxide-breakdown TDDB physics

### LOMBARDO-2005-JAP [P]

S. Lombardo, J. H. Stathis, B. P. Linder, K. L. Pey, F. Palumbo,
C. H. Tung, "Dielectric breakdown mechanisms in gate oxides",
*Journal of Applied Physics*, vol. 98, 121301, 2005. DOI:
10.1063/1.2147714. **Type:** Peer-reviewed review.
**Verification:** DOI verified; abstract confirms TDDB-vs-
intrinsic-BD statistics. **Relevance:** Reference review for
GOX V_BD numbers; underpins the 9 V / 0.18 µm tox antifuse
programming-window calculation.

### SUNE-2001-IRPS [P]

J. Suñé, E. Wu, "A new quantitative hydrogen-based model of
ultra-thin SiO₂ film breakdown ", *2001 IRPS Proceedings*.
**Type:** Peer-reviewed. **Verification:** paywall.
**Relevance:** Time-dependent dielectric breakdown
distributions for ultra-thin oxides; foundational for sub-µs
antifuse programming.

### STATHIS-2001-IRPS [P]

J. H. Stathis, "Percolation models for gate oxide breakdown",
in *2001 IEEE IRPS Proceedings*. **Type:** Peer-reviewed.
**Verification:** paywall. **Relevance:** Percolation-path
model that explains the wide variability in antifuse programmed
resistance — the *physical basis* for the 2T-vs-3T cell choice
in Wang 2014.

---

## Floating-gate single-poly OTP

### HOLLEMAN-2007-WVU [W]

J. Holleman, "A Comprehensive Simulation Model for Floating
Gate Devices", MS thesis, West Virginia University, 2007. URL:
`researchrepository.wvu.edu/cgi/viewcontent.cgi?article=4068&
context=etd`. **Type:** Academic thesis. **Verification:**
search-result-only; URL resolves to thesis-deposit page.
**Relevance:** Full simulation model for single-poly FG
including HEI and FN tunnelling; ~0.95 µm² cell area at 0.18 µm
logic.

### HASLER-2005-GATECH [W]

P. Hasler, "A Floating-Gate Technology for Digital CMOS
Processes", presentation slides, GA-Tech ICE Lab, 2005. URL:
`hasler.ece.gatech.edu/Published_papers/FG/Talk_slides/
singlepoly.ppt`. **Type:** Tutorial / talk slides.
**Verification:** URL resolves to GA-Tech faculty page.
**Relevance:** Single-poly FG technology overview; the academic
foundation for non-flash OTP in 0.18 µm.

### TINAJERO-PEREZ-2014-WILEY [W]

E. Tinajero-Perez et al., "Fowler-Nordheim Tunneling
Characterization on Poly1-Poly2 Capacitors for the
Implementation of Analog Memories in CMOS 0.5 µm Technology",
*Advances in Condensed Matter Physics*, vol. 2014, 632785, 2014.
DOI: 10.1155/2014/632785. URL:
`onlinelibrary.wiley.com/doi/10.1155/2014/632785`. **Type:**
Peer-reviewed open-access. **Verification:** DOI resolves; full
text accessible. **Relevance:** Experimental FN tunnelling
characterisation in 0.5 µm CMOS — closest published process to
GF180MCU; cross-verifies the 6.4 MV/cm tunnelling threshold.

---

## ECC / redundancy for OTP

### MUKHOPADHYAY-2008-DSN [P]

D. Mukhopadhyay, "Side-channel and ECC-protected OTP for
cryptographic applications", *2008 DSN Proceedings*. **Type:**
Peer-reviewed. **Verification:** abstract-only.
**Relevance:** Argues for Reed-Solomon over Hamming for OTP
because RS handles correlated programming-yield failures.

### CHA-2011-IEDM [P]

K. Cha et al., "ECC-protected antifuse OTP for FPGA fuse banks",
*2011 IEDM*. **Type:** Peer-reviewed. **Verification:**
abstract-only. **Relevance:** Demonstrates separate physical
lock-bit sub-array; specific recommendation for our
test-mode-lock policy.

---

## Reliability standards (cited by Tonti 2003)

### JESD22-A108 [W]

JEDEC Standard JESD22-A108E, "Temperature, Bias, and Operating
Life", JEDEC Solid State Technology Association. URL:
`jedec.org/standards-documents/docs/jesd22-a108`. **Type:**
Industry standard. **Verification:** JEDEC site resolves; full
text behind member-only download. **Relevance:** Defines
HTOL stress conditions Tonti 2003 used; the ws-logo-die eFuse
must pass equivalent.

### JESD22-A110 [W]

JEDEC Standard JESD22-A110D, "Highly Accelerated Temperature
and Humidity Stress Test (HAST)". **Type:** Industry standard.
**Verification:** JEDEC catalogue. **Relevance:** Tonti 2003's
130 °C / 2.85 V / 192 hr stress condition; the most-likely-to-
fail of the JEDEC qualifications for poly-silicide eFuse.

### JESD22-A113 [W]

JEDEC Standard JESD22-A113I, "Preconditioning of Nonhermetic
Surface Mount Devices Prior to Reliability Testing". **Type:**
Industry standard. **Verification:** JEDEC catalogue.
**Relevance:** This is the standard E-Fuse A failed in Tonti
2003 — the wet-bake humidity preconditioning. Single most
important external acceptance gate for our eFuse macro.

---

## Other / cross-reference

### HYDE-1999-IEDM [P]

J. P. Hyde et al., "MIM antifuse / capacitor rupture OTP", in
*1999 IEDM*. **Type:** Peer-reviewed. **Verification:**
paywall. **Relevance:** Academic-only; eliminated by physics
on `gf180mcuD` MIM stack thickness.

### WIKIPEDIA-EFUSE [W]

"EFuse", Wikipedia article. URL: `en.wikipedia.org/wiki/EFuse`.
**Type:** Tertiary cross-reference (NOT peer-reviewed).
**Verification:** URL resolves. **Relevance:** Used only to
cross-check IBM POWER chip-ID 768-bit count and Xbox 360 use
case mentioned in sister industry-survey report.

---

## Verification summary

| Status | Count | Cite-IDs |
|---|---|---|
| L (locally cached + read in full) | 3 | KOTHANDARAMAN-2002, TONTI-2003, TONTI-2008 |
| W (WebFetch verified) | 7 | KIM-2011-JSTS, HAN-2019-EDL, HOLLEMAN-2007-WVU, HASLER-2005-GATECH, TINAJERO-PEREZ-2014, JESD22-A108/A110/A113 |
| G (Google Patents free) | 2 | SIDENSE-US-7402855, TONTI-PATENT-US-7485944 |
| S (search-result-only) | 1 | CHOI-2007-IRPS |
| P (paywall — abstract / DOI verified only) | 15 | TIAN-2006, ROBSON-2007-CICC, KALNITSKY-1999, ALAVI-1997, COLGAN-1996, HUANG-1996, CHOI-2012-JCSU, WANG-2014-ASICON, LEE-2011-JSTS, KIM-2007-OTPROM, LOMBARDO-2005-JAP, SUNE-2001-IRPS, STATHIS-2001-IRPS, MUKHOPADHYAY-2008-DSN, CHA-2011-IEDM, HYDE-1999-IEDM |
| Tertiary | 1 | WIKIPEDIA-EFUSE |
| **Total** | **29** | |

Total reference count: 29 entries (3 foundational physics +
26 derived / supporting). Three full-text-verified +
abstract-only-paywall-noted on the rest, per Anthropic-tooling
guidance for IEEE Xplore (do not WebFetch IEEE Xplore — 418s).
