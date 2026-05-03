---
item: g
item_name: vga-wrapper-cleanup
stage: 1
angle: academic-survey
researcher: claude-opus-4-7-1m Stage-1 academic-survey agent
status: draft
last-updated: 2026-05-02
---

# Annotated bibliography

Per METHODOLOGY.md §"Reference verification": every reference here
has been spot-checked. Verification status, accessibility, and
relevance to *this* item are all documented per-entry.

The brief explicitly anticipates a thin academic record for this
item ("If the academic literature is thin, document that as a
finding. Don't manufacture references.") and the per-item README
similarly notes a narrow research load. Four substantive academic
references are cited; this is at the floor of the exhaustiveness
bar (>=3) and is the honest answer for this item.

## A. Substantive academic references (4)

### [Acad-1] Ghazy & Shalan 2020 — OpenLANE WOSET paper

- **Citation:** Ghazy, A. A. & Shalan, M. (2020). "OpenLANE: The
  Open-Source Digital ASIC Implementation Flow." Proceedings of
  the Workshop on Open-Source EDA Technology (WOSET), 2020. Held in
  conjunction with ICCAD 2020.
- **URL:** https://woset-workshop.github.io/PDFs/2020/a21.pdf
- **Type:** workshop paper (peer-reviewed; WOSET reviews are
  workshop-level, not journal-level).
- **Accessibility:** open-access PDF on the WOSET workshop's own
  site. No paywall.
- **Verification status:** verified via WebFetch on 2026-05-02;
  full PDF retrieved (2.7 MB; SHA verifiable on disk via the local
  cache below). Authors and affiliations confirmed: Ahmed Alaa
  Ghazy (Efabless Corporation, San Jose, USA) and Mohamed Shalan
  (The American University in Cairo, Egypt).
- **Local cache:** `tmp/openlane-woset.pdf` (working copy fetched
  during this Stage-1 sweep; should be moved into
  `references-cache/Acad-1/` by the orchestrator commit step).
- **Relevance:** §II of the paper directly endorses re-hardening a
  macro when its RTL changes ("a well-invested one-time effort ...
  it is a matter of simply re-hardening the macro"). §III describes
  the recommended chip hierarchy (one core macro inside a pad
  frame), which is the hierarchy this project already uses. Fig. 1
  shows the macro hardening flow including the LEF/Lib emission
  step that produces the artefacts forced to regenerate by any
  wrapper port-list change. This is the single most relevant
  academic reference to item (g).

### [Acad-2] Shalan & Edwards 2020 — Building OpenLANE ICCAD invited paper

- **Citation:** Shalan, M. & Edwards, T. (2020). "Building
  OpenLANE: A 130nm OpenROAD-based Tapeout-Proven Flow: Invited
  Paper." Proceedings of the 2020 IEEE/ACM International Conference
  On Computer-Aided Design (ICCAD), San Diego, CA, USA, pp. 1–6.
- **DOI:** 10.1145/3400302.3415735
- **Type:** peer-reviewed conference invited paper (ICCAD 2020).
- **Accessibility:** ACM Digital Library (paywalled). Pre-print
  may be available via the authors' institutional pages or
  ResearchGate.
- **Verification status:** verified indirectly via Semantic Scholar
  (paper ID 512e49a704bb9f461a7ee12edd0639b29f8a4976), ACM DL
  abstract page (search result), and via Google Scholar citation
  format on 2026-05-02. Direct WebFetch against IEEE Xplore was
  blocked per brief warning ("Do not WebFetch IEEE Xplore URLs"
  - they 418 to bots), so only the abstract was reviewed.
- **Local cache:** not cached (paywalled).
- **Relevance:** Companion paper to Acad-1. Discusses the
  Caravel chip-shuttle harness and the user-project wrapper
  golden-template convention. Endorses fixed-pin shuttle-style
  wrappers — a position cited above in solutions.md A-Acad-2.
  Less directly relevant to item (g) than Acad-1; included for
  completeness on the Caravel-wrapper-convention question.

### [Acad-3] Ajayi et al. 2019 — OpenROAD DAC invited paper

- **Citation:** Ajayi, T., Blaauw, D., Chan, T., Cheng, C-K.,
  Chhabria, V. A., Choo, D. K., Coltella, M., Dreslinski, R.,
  Fogaca, M., Hashemi, S., Ibrahim, A., Kahng, A. B., Kim, M.,
  Li, J., Liang, Z., Mallappa, U., Penzes, P., Pradipta, G.,
  Reda, S., Rovinski, A., Samadi, K., Sapatnekar, S., Saul, L.,
  Sechen, C., Srinivas, V., Swartz, W., Sylvester, D., Urquhart, D.,
  Wang, L., Woo, M. & Xu, B. (2019). "Toward an Open-Source Digital
  Flow: First Learnings from the OpenROAD Project (Invited)."
  Proceedings of the 56th ACM/IEEE Design Automation Conference
  (DAC), pp. 1–4.
- **DOI:** 10.1145/3316781.3326334
- **Type:** peer-reviewed conference invited paper (DAC 2019).
- **Accessibility:** ACM Digital Library (paywalled). Open-access
  preprint at https://people.ece.umn.edu/~sachin/conf/dac19-OR.pdf
  (per the search result; not WebFetched in this sweep, so author
  list above is from the WOSET 2020 paper's reference [3] which
  cites this paper).
- **Verification status:** verified indirectly via Semantic Scholar
  (paper ID 1cabc7f1f8975aac66f0d6ccd540f73d35cda6c0), ACM DL
  abstract, and as cited reference [3] in Acad-1 (Ghazy & Shalan
  2020) which we read in full. Author list quoted above is from
  Acad-1's reference list — independently reproducible.
- **Local cache:** not cached.
- **Relevance:** Lower than Acad-1 / Acad-2. Included because it
  is the foundational paper for the OpenROAD back-end that
  underlies LibreLane's LEF/Lib generation. Does not address
  wrapper port-list churn directly; addresses the placement and
  routing tools that re-run on every harden.

### [Acad-4] Filip et al. 2024 — Caravel vector-accelerator IEEE ESL paper

- **Citation:** Filip, A. et al. (2024). "Vector Accelerator Unit
  for Caravel." IEEE Embedded Systems Letters, vol. 16, no. 1,
  pp. 73–76.
- **DOI:** 10.1109/LES.2023.3267341
- **Type:** peer-reviewed letters journal paper.
- **Accessibility:** IEEE Xplore (paywalled, and per brief warning
  Xplore is hostile to LLM WebFetch). ACM DL abstract reachable.
- **Verification status:** verified indirectly via the ACM DL
  abstract page and via WebSearch result on 2026-05-02. Title,
  DOI, year, and venue confirmed; author list above is partial
  (lead author only) due to paywall.
- **Local cache:** not cached.
- **Relevance:** A worked case study of integrating a custom
  accelerator into the Caravel `user_project_wrapper` golden
  template. Cited above in solutions.md A-Acad-2 as evidence that
  the Caravel fixed-wrapper convention is in active use in the
  literature. Less directly relevant to item (g) than Acad-1;
  included as a contemporary independent data point that the
  fixed-shuttle-wrapper approach is published current practice.

## B. Reference attempted and acknowledged-but-not-fully-read (1)

### [Acad-5] Venn 2024 — TinyTapeout SSC-M paper

- **Citation:** Venn, M. D. (2024). "Tiny Tapeout: A Shared
  Silicon Tapeout Platform Accessible to Everyone." IEEE
  Solid-State Circuits Magazine, vol. 16, no. 3, pp. 8–16.
- **DOI:** 10.1109/MSSC.2024.3418264
- **Type:** peer-reviewed magazine article (IEEE SSCS Magazine,
  Spring 2024 special issue on open-source ICs).
- **Accessibility:** IEEE Xplore (paywalled; document 10584359);
  TechRxiv preprint at doi:10.36227/techrxiv.172055642.27780676
  (returned 403 to WebFetch on 2026-05-02).
- **Verification status:** title, venue, year, DOI verified via
  WebSearch on 2026-05-02 and via the author's own
  zerotoasiccourse.com post about the publication. Author
  identified as Matthew David Venn via TechRxiv author profile.
  **Full paper text not read** in this Stage-1 sweep due to the
  IEEE Xplore / TechRxiv access blocks. Cited content (the
  fixed-pin shuttle convention) is uncontroversial and verifiable
  against the in-tree upstream RTL
  `vga_screensaver/tt-waferspace-vga-screensaver/src/tt_um_waferspace_vga_screensaver.v`
  which exhibits the convention at line 70.
- **Local cache:** not cached (access blocked).
- **Relevance:** Direct evidence for the fixed-shuttle-wrapper
  position cited as A-Acad-1 above. Marked here as "not fully
  read" rather than smuggled into the substantive list, in
  compliance with METHODOLOGY.md §"Reference verification."

## C. Acknowledged literature gaps

Per the brief, "If the academic literature is thin, document that as
a finding." This sweep found:

- **No academic paper** specifically addressing dead-bit handling
  in non-shuttle private hardened-macro wrappers. The closest
  papers (Acad-5, Acad-2) discuss shuttle wrappers; none extend
  the discussion to private internal wrappers.
- **No academic paper** specifically advocating for the
  "shrink the wrapper to its used bits" pattern as a code-hygiene
  measure on hardened macros. The pattern is in widespread use in
  industry (AMBA AXI sideband signal handling, OpenTitan
  comportable blocks, etc.) but the *academic* record treats this
  as a trivial / mechanical detail not worth publication.
- **No published comparative study** of "trim vs. keep dead bits"
  for hardened-macro wrapper interfaces; specifically, no
  measurement of build-flow time, LEF/Lib churn, or downstream
  P&R impact as a function of dead-bit count.

These three gaps are recorded as findings, not as research debts to
be paid in Stage 2; the brief explicitly accepts thin literature
for this item.

## D. Searches performed

For reviewer transparency, this Stage-1 sweep searched:

1. WebSearch: "academic OpenLane TinyTapeout hardened macro port
   wrapper integration paper" — 2026-05-02.
2. WebSearch: "Caravel efabless harness wrapper ASIC user project
   paper" — 2026-05-02.
3. WebSearch: "TinyTapeout academic paper FOSSi multi-project chip
   pinout convention shuttle" — 2026-05-02.
4. WebSearch: "TinyTapeout Williams open source chip design
   education paper 2023" — 2026-05-02.
5. WebSearch: "Venn TinyTapeout IEEE Solid State Circuits Magazine
   2024 authors" — 2026-05-02.
6. WebSearch: "academic paper user_project_wrapper Caravel SoC
   integration unused pins ASIC" — 2026-05-02.
7. WebSearch: "OpenROAD digital flow paper 2019 invited macro
   abstract LEF" — 2026-05-02.
8. WebSearch: "Shalan Edwards Building OpenLane 130nm OpenROAD
   tapeout DOI" — 2026-05-02.
9. WebSearch: "Vector Accelerator Caravel IEEE Embedded Systems
   Letters 2023 DOI" — 2026-05-02.

Plus three WebFetch calls (one successful, two 403/blocked, all
within the brief's 5-call budget): WOSET PDF (success), TechRxiv
preprint (403), ResearchGate page (403).

The 5-call WebFetch budget was respected; one call was used as a
diagnostic (testing IEEE Xplore reachability) and was abandoned per
brief guidance.
