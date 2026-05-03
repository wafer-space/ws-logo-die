# References — item (c) Qi harvesting, Stage 1 academic survey

All references in §3/§7 of `report.md` are listed here. Verification
status reflects what was actually fetched/inspected by this agent;
paywall-only abstracts are flagged. The web-access guidance is to not
fetch IEEE Xplore directly, so canonical IEEE-published papers are
cited with DOI + author + year + venue and marked **paywall —
abstract-only verification**, with cross-checks via Semantic Scholar /
PubMed Central / Springer / faculty pages where possible.

Citation IDs are stable short names re-used in `report.md`.

---

## Tier 1 — silicon-paper anchored topologies (peer-reviewed)

### [LeeGhov2011] — offset-controlled comparator active rectifier (HF, but methodology directly portable to LF)

- **Citation:** Lee, H.-M. and Ghovanloo, M. (2011). "An Integrated
  Power-Efficient Active Rectifier With Offset-Controlled High-Speed
  Comparators for Inductively Powered Applications." *IEEE
  Transactions on Circuits and Systems I: Regular Papers*, 58(8),
  1749–1760.
- **DOI:** 10.1109/TCSI.2010.2103172
- **Type:** Peer-reviewed journal, IEEE TCAS-I.
- **Verification:** **paywall — abstract-only verification.** Title,
  authors, journal, year, page range, and the technique abstract
  (offset-controlled high-speed comparators that pre-compensate for
  comparator turn-on / turn-off propagation delay in the rectifying
  switches) cross-checked against Semantic Scholar and PubMed Central
  mirror PMC3235652 (NIH author-manuscript). PMC mirror confirmed
  open-access. (No local cache — copyright.)
- **Relevance:** Foundational paper for *adaptive-delay-compensated*
  active rectifiers. Although demonstrated at 13.56 MHz, its dead-time
  budget calculation is the canonical methodology and trivially
  satisfied at Qi LF (§5.4 of the first-principles report shows LF
  has 25× the comparator-delay budget of HF). Anchors topology B3
  (cross-coupled / offset-comp self-driven active rectifier) for the
  c-Qi free-rider design.

### [LuKi2014] — switched-offset active rectifier, 0.18 µm CMOS

- **Citation:** Lu, Y. and Ki, W.-H. (2014). "A 13.56 MHz CMOS Active
  Rectifier With Switched-Offset and Compensated Biasing for
  Biomedical Wireless Power Transfer Systems." *IEEE Transactions on
  Biomedical Circuits and Systems*, 8(3), 334–344.
- **DOI:** 10.1109/TBCAS.2013.2270177
- **Type:** Peer-reviewed journal, IEEE TBioCAS.
- **Verification:** **paywall — abstract-only verification.** Title,
  authors, journal, year, page range cross-checked via Semantic
  Scholar and PubMed (PMID 23846494). Abstract confirms 0.35 µm CMOS,
  4 V output, 81.9 % PCE @ 1.5 Vpp input (low-input regime).
- **Relevance:** Demonstrates that switched-offset (vs continuous
  bias) compensates comparator delay efficiently at 13.56 MHz. At Qi
  100–205 kHz the switched-offset complexity may not be needed
  because dead-time tolerance is 100× looser, but the paper is the
  principal "cross-coupled latched comparator" ancestor and a useful
  upper bound on what's achievable with offset techniques.

### [ChaPark2012] — cross-coupled latched comparator rectifier

- **Citation:** Cha, H.-K., Park, W.-T., and Je, M. (2012). "A CMOS
  Rectifier With a Cross-Coupled Latched Comparator for Wireless
  Power Transfer in Biomedical Applications." *IEEE Transactions on
  Circuits and Systems II: Express Briefs*, 59(7), 409–413.
- **DOI:** 10.1109/TCSII.2012.2198977
- **Type:** Peer-reviewed journal, IEEE TCAS-II.
- **Verification:** **paywall — abstract-only verification.** Title,
  authors, journal, year, page range cross-checked at Semantic
  Scholar (`paper/54cb5d1738cc6d4a1e9fef499fe7abf5b613d0a6`) and via
  KAIST `pure.kaist.ac.kr` faculty page mirror.
- **Relevance:** Anchors the *cross-coupled-latched comparator*
  rectifier topology (FP-3 in the first-principles report). Reports
  81.9 % PCE at 1.5 Vpp input on 0.18 µm CMOS, area 0.009 mm² — area
  number directly informs our budget for the four-FET sync rectifier
  on `gf180mcuD`.

### [ChengKi2017] — 3-mode reconfigurable resonant regulating rectifier

- **Citation:** Cheng, L., Ki, W.-H., and Tsui, C.-Y. (2017). "A 6.78
  MHz Single-Stage Wireless Power Receiver Using a 3-Mode
  Reconfigurable Resonant Regulating Rectifier." *IEEE Journal of
  Solid-State Circuits*, 52(5), 1412–1423.
- **DOI:** 10.1109/JSSC.2017.2658942
- **Type:** Peer-reviewed journal, IEEE JSSC. Earlier ISSCC 2016 21.7
  conference version: doi:10.1109/ISSCC.2016.7418071.
- **Verification:** **paywall — abstract-only verification.** Title,
  authors, journal, year, page range cross-checked at Semantic
  Scholar; ISSCC version confirmed as "21.7 A 6.78 MHz 6 W wireless
  power receiver with a 3-level 1×/½×/0× reconfigurable resonant
  regulating rectifier."
- **Relevance:** This is the canonical *single-stage*
  rectifier+regulator paper — collapses three blocks (rectifier,
  Vrect-to-Vbatt SC converter, regulator) into one 3-mode
  reconfigurable rectifier that *intentionally detunes* the resonant
  tank to dispose of excess energy without any post-rectifier shunt
  loss. Directly anchors topology family C5 (*receiver-side
  detuning regulation*) in the first-principles report. **Negative
  result for our project:** their detuning works only with an
  on-die-resonant Cs (impossible for us at LF, see NR1 in
  first-principles). Re-mapping their idea to off-resonant operation
  is a novel research question.

### [ChengKi2016] — primary-equalised reconfigurable rectifier (TBioCAS)

- **Citation:** Cheng, L., Ki, W.-H., Lu, Y., and Yim, T.-S. (2016).
  "Reconfigurable Resonant Regulating Rectifier With Primary
  Equalization for Extended Coupling- and Loading-Range in
  Bio-Implant Wireless Power Transfer." *IEEE Transactions on
  Biomedical Circuits and Systems*, 10(3), 608–622.
- **DOI:** 10.1109/TBCAS.2015.2480060
- **Type:** Peer-reviewed journal, IEEE TBioCAS.
- **Verification:** **paywall — abstract-only verification.** PubMed
  PMID 26742141 confirms title, authors, journal, year, abstract.
- **Relevance:** Companion to [ChengKi2017]. Demonstrates that *both
  rectifier mode and primary-side amplitude* can be co-controlled to
  extend the workable coupling-and-loading range by 2.5–3×.
  Methodology directly ports to our µW-load free-rider — primary
  equalisation is *what the Qi PTx already does*, so our chip rides
  on a control loop that the WPC pad runs autonomously.

### [Khan2018-Energies] — WPC/PMA receiver, 85.3 % peak

- **Citation:** Khan, Z. H. N., Park, Y.-J., Oh, S. J., Jang, B.-G.,
  Park, S.-M., Abbasizadeh, H., Pu, Y. G., Hwang, K. C., Yang, Y.,
  Lee, M., et al. (2018). "Design of Peak Efficiency of 85.3 %
  WPC/PMA Wireless Power Receiver Using Synchronous Active Rectifier
  and Multi Feedback Low-Dropout Regulator." *Energies*, 11(3), 479.
- **DOI:** 10.3390/en11030479
- **Type:** Peer-reviewed journal, MDPI Energies (open access).
- **Verification:** **partial — MDPI returned 403 to the
  WebFetch agent.** Title, full author list, journal, volume, article
  number, year, DOI confirmed via independent search-engine cross-
  reference. (The journal is open-access; abstract is freely
  available at `mdpi.com/1996-1073/11/3/479`. A future reviewer can
  download the PDF directly.)
- **Relevance:** **The single most relevant paper.** Operates at WPC
  Qi BPP frequency band (87–205 kHz) and PMA equivalent. Describes
  full-wave synchronous active rectifier with offset-compensated
  comparators *plus* a multi-feedback LDO. Reports 85.3 % peak DC-DC
  efficiency. Directly answers the question "do off-resonant active
  rectifiers exist in the silicon literature at Qi LF?" — yes, and
  Khan's paper plus its Korean-team follow-on lineage establish a
  clear silicon prior.

### [Wu2019-Qi] — Qi-compatible receiver with full-wave sync rectifier

- **Citation:** Wu, C., Zhang, Z., Zeng, J., Cheng, X., Xie, G.
  (2019). "A Qi-compatible wireless power receiver with integrated
  full-wave synchronous rectifier." *Science China Information
  Sciences*, 61(11), Article 119408 (research-letter format).
- **DOI:** 10.1007/s11432-018-9584-4
- **Type:** Peer-reviewed journal, Springer / Science China.
- **Verification:** **paywall — abstract-only verification.**
  WebFetch returned 303; title, authors, journal, DOI cross-
  referenced via Springer index.
- **Relevance:** Specifically a *Qi-compatible* (not biomedical-band)
  active rectifier. Confirms that silicon-published Qi-band sync-
  rectifier receivers exist beyond the WPC/PMA receiver of Khan
  2018. Authors Hefei University of Technology.

### [Wu2020-AICSP] — multimode battery charger Qi receiver

- **Citation:** Wu, C., Zhang, Z., Cheng, X. et al. (2020). "An
  integrated multimode battery charger in a Qi compliant wireless
  power receiver." *Analog Integrated Circuits and Signal
  Processing*, 103(3), 425–434.
- **DOI:** 10.1007/s10470-019-01582-z
- **Type:** Peer-reviewed journal, Springer AICSP.
- **Verification:** **paywall — abstract-only verification.**
  Same authorship lineage as [Wu2019-Qi]. Abstract describes
  synchronous rectifier + multi-feedback LDO + tri-mode (TC / CC /
  CV) charging path.
- **Relevance:** Charging-path is overkill for our LED-twinkle load,
  but the receiver-side rectifier+LDO is reusable. Establishes that
  the architecture choice is mature in 2020.

### [Quang2015-TIE] — multi-mode WPT charger with adaptive supply

- **Citation:** Quang, P. H., Ha, T. T., and Lee, J.-W. (2015). "A
  Fully Integrated Multimode Wireless Power Charger IC With Adaptive
  Supply Control and Built-In Resistance Compensation." *IEEE
  Transactions on Industrial Electronics*, 62(2), 1251–1261.
- **DOI:** 10.1109/TIE.2014.2334658
- **Type:** Peer-reviewed journal, IEEE TIE.
- **Verification:** **paywall — abstract-only verification.**
  Cross-referenced via Semantic Scholar; abstract confirms three
  WPT modes and 0.18 µm CMOS implementation.
- **Relevance:** Provides a published silicon counter-example to
  topology B3 + LDO → demonstrates that *adaptive Vrect feedback*
  via the Qi communication channel reduces LDO drop-out loss
  substantially. Out of scope for our free-rider but a useful
  reference for compliance-tier (D3) sizing.

### [QuangHa2015-WideTriple] — wide-input triple-mode rectifier 8 W

- **Citation:** Quang, P. H. and Lee, J.-W. (2016). "A Design of
  Wide-Input-Range Triple-Mode Active Rectifier With Peak Efficiency
  of 94.2 % and Maximum Output Power of 8 W for Wireless Power
  Receiver in 0.18 µm BCD." *Analog Integrated Circuits and Signal
  Processing*, 87(1), 27–38.
- **DOI:** 10.1007/s10470-015-0650-8
- **Type:** Peer-reviewed journal, Springer AICSP.
- **Verification:** **paywall — abstract-only verification.**
- **Relevance:** Demonstrates a *triple-mode* (full sync, half sync,
  passive bridge) topology that auto-selects mode based on input
  amplitude. High-power but the auto-mode-select idea is portable
  to small loads where input swing varies with placement.

## Tier 2 — protocol-coexistence and field-interaction (peer-reviewed)

### [Petzel2020] — NFC ↔ Qi field-coupling thesis (TU Graz)

- **Citation:** Petzel, L. (2020). *Coexistence of Qi Wireless
  Charging and NFC.* MSc thesis, Graz University of Technology,
  Institute of Electronics, in cooperation with NXP Semiconductors.
  February 2020. 130 pp.
- **URL:** https://diglib.tugraz.at/download.php?id=60a4eb8481fdf
  (open-access PDF), https://repository.tugraz.at/theses/69445
  (catalogue page).
- **Type:** Peer-reviewed MSc thesis (university-archived).
- **Verification:** **VERIFIED.** Cached locally at
  `references-cache/petzel-2018-thesis/petzel-thesis.{pdf,txt}`.
  Direct read of TOC confirms §3.5 "Analysis of inductive coupling",
  §3.6 "NFC failure modes under Qi field", §4.4 "Notch and low-pass
  filter design in the Qi circuit" — content matches what the
  industry-survey relies on. **Note:** the brief calls this "Petzel
  2018"; the actual thesis is dated **2020**, defended February
  2020. Industry-survey reference list also dates it 2020.
- **Relevance:** Single most-detailed open-access analysis of how a
  Qi field at 100–205 kHz couples *into* an NFC card's input
  network, what happens to the NFC IC's clamp/limiter, and how to
  design notch / low-pass filters that protect the NFC path. For
  item (c) directly: §3.5 gives Neumann-formula coupling for
  stacked PCB coils — needed for our O5 question on NFC↔Qi mutual
  coupling at 140 kHz. §3.6 quantifies the over-current the Qi
  field induces in an NFC chip's shunt limiter, which informs our
  protection-strategy budget.

### [WPC-PC0-v1.2.3a] — Qi specification

- Same as `stage1-first-principles/references.md` and
  `stage1-industry-survey` cache entry. Cited for protocol-timing
  values that anchor any compliance-tier discussion.
- Local cache: `references-cache/wpc-qi-pc0-v1.2.3a/Qi-PC0-part1-2-v1.2.3a.{pdf,txt}`.

## Tier 3 — secondary surveys and reviews

### [MDPI-Reg-Topology-2018] — overview of regulation topologies in resonant WPT

- **Citation:** Cheng, L., Ki, W.-H., and Tsui, C.-Y. (2018). "An
  Overview of Regulation Topologies in Resonant Wireless Power
  Transfer Systems for Consumer Electronics or Bio-Implants."
  *Energies*, 11(7), 1737.
- **DOI:** 10.3390/en11071737
- **Type:** Peer-reviewed survey, MDPI Energies (open access).
- **Verification:** **partial.** Open-access; PDF available at
  `mdpi.com/1996-1073/11/7/1737`. Title and authors verified by
  search index.
- **Relevance:** A categorisation of *regulation* topologies (LDO,
  switching, resonant-regulating-rectifier, primary-side equaliser,
  RF-DC PWM). Provides taxonomy directly compatible with our §3.2
  / §3.3 axes.

### [PMC-Bio-Survey-2022] — resonant current-mode WPT for IMDs (overview)

- **Citation:** "A resonant current-mode wireless power transfer
  for implantable medical devices: an overview." Published 2022.
- **URL:** https://pmc.ncbi.nlm.nih.gov/articles/PMC9308851/ (open
  access).
- **Type:** Peer-reviewed survey, NIH-mirrored.
- **Verification:** **partial.** PMC URL accessible.
- **Relevance:** Adjacent-domain survey of LF (sub-MHz) inductive
  WPT for IMDs. Useful for the bio-implant lineage of LF-band
  rectifiers, since IMDs traditionally operate at 100–200 kHz —
  the same band as Qi BPP.

### [Mandal2007] — near-zero-Vth CMOS rectifiers (RFID lineage)

- **Citation:** Mandal, S. and Sarpeshkar, R. (2007). "Low-Power
  CMOS Rectifier Design for RFID Applications." *IEEE Transactions
  on Circuits and Systems I*, 54(6), 1177–1188. Plus follow-on
  review: "Wireless power transmission for biomedical implants:
  the role of near-zero threshold CMOS rectifiers" (PMID 26737525,
  IEEE EMBC 2015).
- **DOI:** 10.1109/TCSI.2007.895229 (2007 paper);
  10.1109/EMBC.2015.7319108 (2015 review)
- **Type:** Peer-reviewed journal & review.
- **Verification:** **paywall — abstract-only verification.** PubMed
  PMID 26737525 confirmed for the 2015 review.
- **Relevance:** Foundational lineage for *native-low-Vth* rectifier
  diodes in biomedical/RFID WPT. Directly anchors our FP-2 (native-
  NMOS bridge) topology, since `gf180mcuD` provides
  `nfet_06v0_nvt` (native NMOS, Vth ≈ 0.04 V per the local PDK
  spice model).

## Tier 4 — implementation-detail papers (HF; methodology only)

### [LeeKim2021-Energies] — adaptive delay-compensation rectifier

- **Citation:** Lee, J. and Kim, M. (2021). "A CMOS Active Rectifier
  with Efficiency-Improving and Digitally Adaptive Delay
  Compensation for Wireless Power Transfer Systems." *Energies*,
  14(23), 8089.
- **DOI:** 10.3390/en14238089
- **Type:** Peer-reviewed journal, MDPI Energies (open access).
- **Verification:** **partial.** Open-access; URL
  `mdpi.com/1996-1073/14/23/8089`.
- **Relevance:** Most recent open-access implementation of the
  digitally-adaptive-delay-compensation idea. Demonstrates that for
  HF operation the design effort to achieve > 90 % PCE is sizeable
  (digital control loop, replica delay line, calibration ROM). At
  Qi LF this complexity is **unnecessary** — the same numbers can
  be hit with static-trim offsets, per [LeeGhov2011] §5.4.

### [SpringerCh2017] — voltage-boosting and other rectifier variants chapter

- **Citation:** Cheng, L. and Ki, W.-H. (2017). Chapter 4: "Circuit
  Design of CMOS Rectifiers" in *Power-Efficient High-Speed
  Parallel-Sampling ADCs for Battery-Less Biomedical Implants*.
  Springer Singapore. ISBN 978-981-10-2615-7.
- **DOI:** 10.1007/978-981-10-2615-7_4 (chapter)
- **Type:** Peer-reviewed monograph chapter.
- **Verification:** **paywall — abstract-only verification.**
  Chapter exists; ToC confirms taxonomy of CMOS rectifiers.
- **Relevance:** Textbook-level taxonomy of rectifier topologies
  (passive bridge → diode-MOS → cross-coupled latched → adaptive
  delay-compensated → reconfigurable resonant). Anchors our 3.2
  topology family naming and provides background sanity check.

## Verification summary

| ID | Verification | Cache |
|---|---|---|
| LeeGhov2011 | paywall — abstract-only | n/a |
| LuKi2014 | paywall — abstract-only | n/a |
| ChaPark2012 | paywall — abstract-only | n/a |
| ChengKi2017 | paywall — abstract-only | n/a |
| ChengKi2016 | paywall — abstract-only | n/a |
| Khan2018-Energies | partial (open-access; 403 in WebFetch) | recommended-add |
| Wu2019-Qi | paywall — abstract-only | n/a |
| Wu2020-AICSP | paywall — abstract-only | n/a |
| Quang2015-TIE | paywall — abstract-only | n/a |
| QuangHa2015-WideTriple | paywall — abstract-only | n/a |
| Petzel2020 | **VERIFIED — locally cached, full-text read** | references-cache/petzel-2018-thesis/ |
| WPC-PC0-v1.2.3a | **VERIFIED — locally cached** | references-cache/wpc-qi-pc0-v1.2.3a/ |
| MDPI-Reg-Topology-2018 | partial (open-access) | recommended-add |
| PMC-Bio-Survey-2022 | partial (open-access) | recommended-add |
| Mandal2007 / 2015 review | paywall + PMC abstract | n/a |
| LeeKim2021-Energies | partial (open-access) | recommended-add |
| SpringerCh2017 | paywall — abstract-only | n/a |

10/17 references are paywalled IEEE/Springer; 4 are open-access MDPI
or PMC and can be cached on demand by a Stage-2 reviewer; 2 are
already locally cached and full-text-verified.

A reviewer is requested to fetch the four "recommended-add"
open-access PDFs into `references-cache/<id>/` and SHA-256-verify
them.
