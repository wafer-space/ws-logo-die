---
item: g
item_name: vga-wrapper-cleanup
stage: 1
angle: academic-survey
researcher: claude-opus-4-7-1m Stage-1 academic-survey agent
status: draft
last-updated: 2026-05-02
---

## 1. Executive summary

This survey addresses item (g) "VGA wrapper cleanup": the in-tree
`wrapped_vga.v` exposes a 7-bit `inputs` port to the chip-level
integrator while only five of those bits reach functional logic
inside the upstream TinyTapeout module. The brief asks for an
*academic* perspective, focused on what the peer-reviewed and
published-conference literature has to say about hardened-macro
port-list churn, dead-pin handling, and IP-wrapper conventions in
the open-source OpenLane / LibreLane / OpenROAD / Caravel /
TinyTapeout ecosystem.

Headline findings:

- The academic literature on the *specific* question of dead-bit
  handling in private hardened-macro wrappers is thin. The brief
  explicitly anticipates this outcome and instructs the researcher
  to document it as a finding rather than manufacture references.
- Four substantive academic references *do* speak to the
  surrounding context: fixed-port wrapper conventions
  (TinyTapeout SSC-M paper, Venn 2024); hardened-macro
  contextualised pin placement and re-harden semantics
  (OpenLANE WOSET 2020 paper, Ghazy & Shalan; ICCAD 2020 invited
  paper, Shalan & Edwards); the OpenROAD back-end LEF/Lib
  pipeline that re-emits abstracts on every harden (DAC 2019
  invited paper, Ajayi et al.); and a worked Caravel-wrapper
  integration case study (IEEE Embedded Systems Letters 2024,
  Filip et al.).
- The most directly applicable academic position located is from
  Ghazy & Shalan 2020 (WOSET), which frames hardening as "a
  well-invested one-time effort" and re-hardening on RTL change
  as routine. This endorses option G1 / B1 (shrink-and-re-harden)
  on academic grounds.
- The TinyTapeout SSC-M paper specifically endorses immutability
  of the user-module pin interface, but this binds only the
  upstream `tt_um_*` shuttle module, not the in-tree
  `wrapped_vga` derivative wrapper that item (g) touches.
- No academic paper found makes a positive case for or against any
  specific approach to dead-input bits in a private internal
  hardened-macro wrapper. This silence is the central finding for
  the academic angle on (g).

The survey does not pick a winner. Stage 1 forbids it; the per-
item README anticipates the literature being thin enough that
picking a winner from academic citations alone would not be
defensible.

## 2. Requirements as understood

Re-stated from `TODO.md` §(g) and the per-item README:

1. R1. Remove dead inputs from `wrapped_vga` so the wrapper
   exposes only the bits the screensaver consumes. (TODO.md §(g)
   "Goal".)
2. R2. Cocotb smoke must still pass after any change.
3. R3. The hardened views in
   `vga_screensaver/runs/latest/final/` may need re-generation if
   the port list changes — confirm.
4. R4. Existing VGA pad positions are frozen at the chip-top
   level (TODO.md §"Hard cross-cutting constraints" #3). The
   wrapper port-list lives one level inside the pad ring, so this
   constraint binds chip-top pad instantiations only, not the
   wrapper interface.
5. R5. Per-item README: "narrow research load - short reports OK"
   and "If the academic literature is thin, document that as a
   finding."

What this survey is NOT trying to do:

- Not surveying analog / RF / oscillator literature (irrelevant to
  an HDL-edit cleanup item).
- Not searching for a paper that says "always trim dead bits" -
  there isn't one and that's a finding.
- Not validating the parallel industry-survey or
  first-principles in-tree references; both reports are already
  on disk (status: draft) at
  `../stage1-industry-survey/report.md` and
  `../stage1-first-principles/report.md`.

## 3. Solution-space map

This Stage-1 angle treats peer-reviewed academic publications as
its source of approaches. Rather than re-enumerate the same
G1..G9 / A1..D1 option set already produced by the parallel
first-principles and industry surveys, this section documents the
academic *positions* on each structural question item (g) raises.
The full per-approach catalogue (with mappings to the parallel
reports' option short-names) is in
[`solutions.md`](solutions.md).

### Family A - Fixed-interface wrapper (academic position: do not change ports)

- A-Acad-1 - TinyTapeout shuttle convention (Venn 2024, SSC-M).
  The `ui_in[7:0]` / `uo_out[7:0]` / `uio_*[7:0]` / `ena` / `clk`
  / `rst_n` user-module pin set is required to match the shuttle
  multiplexer template. Unused bits are tied off internally via
  the `_unused_ok = &{...}` Verilog idiom (visible in upstream
  `tt_um_waferspace_vga_screensaver.v` line 70). For (g), this
  binds only the upstream module, not `wrapped_vga`.
- A-Acad-2 - Caravel `user_project_wrapper` golden template
  (Shalan & Edwards 2020, ICCAD; Filip et al. 2024, IEEE ESL).
  Caravel projects must adhere to a fixed-pin top-level wrapper.
  Same caveat: binds shuttle wrappers, not internal wrappers.

### Family B - Re-harden as a routine flow concern

- B-Acad-1 - OpenLane "well-invested one-time effort" framing
  (Ghazy & Shalan 2020, WOSET §II). Hardening a macro is
  endorsed as a one-time effort with re-hardening on RTL change
  treated as routine. Direct support for option G1 / B1
  (shrink-and-re-harden).
- B-Acad-2 - Contextualised I/O pin placement on every harden
  (Ghazy & Shalan 2020 §III, Fig. 3). When a macro is re-
  hardened, OpenLane reoptimises pin (x,y) given the chip-top
  context. Implication: any width change on `wrapped_vga.v`
  changes both the LEF pin geometry and the Liberty timing arcs.

### Family C - Where the literature is silent

- C-Acad-1 - No academic case study found of "trim dead bits from
  a hardened OpenLane macro wrapper" specifically.
- C-Acad-2 - No academic guidance on opportunistic reuse of dead
  pins for DFT / observability. The DFT literature (Gaber,
  Abdelatty & Shalan, *Fault*, WOSET 2019) addresses scan
  *insertion* via fresh pins, not reuse of pre-existing dead
  ones.

### Considered and discarded as out-of-scope

- Repurpose dead bits as analog test points - chip-top pad-cell
  question, not a wrapper-RTL question; eliminated on PDK grounds
  by the parallel first-principles report §7.2.
- eFuse/OTP-driven dead-bit configuration - depends on item (j)
  whose academic Stage-1 has not yet landed.

Full catalogue, including mappings to the parallel reports'
option short-names and per-approach academic-evidence summary, is
in [`solutions.md`](solutions.md).

## 4. Sub-block breakdown

For each academic position, the artefacts the academic literature
expects to be touched / regenerated:

| Position | RTL change | LEF/Lib regen | Floorplan change | Re-verify scope |
|---|---|---|---|---|
| A-Acad-1 (TT-style fixed) | none in `wrapped_vga`; ties at upstream | none | none | upstream LVS/STA |
| A-Acad-2 (Caravel-style fixed) | wrapper inputs tied to constants where unused | none | none | wrapper-level LVS |
| B-Acad-1 (OpenLane re-harden) | port-list edit | full LEF/Lib regen | macro pin geometry refreshed; pad ring untouched | macro LVS + chip-top STA + cocotb |
| B-Acad-2 (contextualised I/O) | as B-Acad-1 | full regen with re-optimised pin placement | as B-Acad-1 | as B-Acad-1 |
| C-Acad-1 / C-Acad-2 | n/a - literature silent | n/a | n/a | n/a |

Full per-artefact decomposition (including
`vga_screensaver/runs/latest/final/lef/wrapped_vga.lef`,
`.../lib/...`, `.../nl.v`, GDS, SPEF, cocotb testbench, pin_order,
slot YAML) is in [`components.md`](components.md).

## 5. First-principles sanity checks

Item (g) is an HDL / build-flow cleanup. There are no
Carnot / Friis / Shannon / Faraday physical limits to apply.
Section retained for template compliance; the relevant flow-level
checks are:

### 5.1 LEF/Lib regeneration is an academic claim, not just an engineering one

Ghazy & Shalan 2020 §III and Fig. 1 show the Magic-based LEF/Lib
emission step at the very end of the OpenLane macro hardening
flow. Because the LEF abstract enumerates `PIN <name>` blocks per
RTL port and the Liberty file enumerates `pin (...)` blocks with
per-port timing arcs, a port-list edit necessarily changes both
files at the line level. This corroborates the parallel
first-principles report's §5.2 derivation. Two independent
derivations agreeing strengthens the conclusion.

### 5.2 Re-harden cost in academic terms

Ghazy & Shalan 2020 (WOSET §V and Appendix B / striVe2a example)
implies single-digit-minutes harden times for sub-mm² macros on
the analogous SKY130 PDK at this complexity. GF180MCU is in the
same complexity class. In-tree empirical observation
(`make project` runs in single-digit minutes on the existing
0.25 mm² `vga_screensaver` macro) is consistent.

### 5.3 "Do nothing" defended as a research methodology

Some flows (TinyTapeout-shuttle-bound designs) require not
changing the user-module port list. `wrapped_vga.v` is not on a
TinyTapeout shuttle. The academic literature does NOT provide a
positive endorsement for "leave dead bits alone in a private
wrapper outside a shuttle convention" - it is silent on that
question. Treating "academic silence" as "academic permission" is
a methodological hazard the parallel first-principles report
rightly flags (§7.3): the goal as written calls for cleanup, and
silence in the literature is not justification for doing nothing.

## 6. References

See [`references.md`](references.md). Four substantive academic
references (Ghazy & Shalan 2020 WOSET; Shalan & Edwards 2020
ICCAD; Ajayi et al. 2019 DAC; Filip et al. 2024 IEEE ESL) plus
one paper acknowledged-but-not-fully-read (Venn 2024 IEEE SSC-M;
IEEE Xplore and TechRxiv access blocked to LLM agents) plus
explicit notes on three literature gaps.

## 7. Negative results

### 7.1 No academic paper specifically addresses dead-bit handling in private hardened-macro wrappers

Search performed across WOSET 2020, ICCAD invited papers on
OpenROAD / OpenLane (Ghazy & Shalan; Shalan & Edwards), DAC 2019
invited paper on OpenROAD (Ajayi et al.), IEEE Embedded Systems
Letters case studies on Caravel integration (Filip et al.), and
the TinyTapeout SSC-M 2024 paper (Venn). The closest the
literature comes is the *fixed-interface* convention of
TinyTapeout and Caravel - but those bind shuttle wrappers, not
arbitrary internal wrappers like `wrapped_vga`. **The per-item
README's anticipation that "the academic literature may be thin
on this specific topic" is empirically confirmed.**

### 7.2 IEEE Xplore is hostile to LLM-driven research

WebFetch attempts against IEEE Xplore (`ieeexplore.ieee.org/document/...`)
return HTTP 418 / 403 (per the brief's explicit warning). All
references below were verified via secondary sources (Semantic
Scholar IDs, ACM DL abstract pages, the WOSET workshop's own PDF
mirror) rather than IEEE Xplore directly. This is a methodology
limitation; not a defect of the references themselves.

### 7.3 The TechRxiv preprint of the TinyTapeout SSC-M paper was 403-blocked

URL `https://www.techrxiv.org/doi/full/10.36227/techrxiv.172055642.27780676/v1`
returned HTTP 403 to the WebFetch user-agent on 2026-05-02. The
paper's title, DOI, and authorship were verified via the SSCS
magazine table-of-contents and the author's
zerotoasiccourse.com post about the publication. Full paper text
not read in this Stage-1 sweep; cited content (the fixed-pin
shuttle convention) is uncontroversial and verifiable against the
in-tree upstream RTL line 70.

### 7.4 ResearchGate is also hostile to WebFetch

WebFetch against ResearchGate also returned 403 on 2026-05-02.
This eliminates the secondary-mirror path that would otherwise
have allowed retrieving full text of paywalled IEEE / ACM papers.

## 8. Open questions

See [`open-questions.md`](open-questions.md). Six open questions,
including the methodological one of how Stage 2 should reconcile
"academic silence" with industry / first-principles positions.

## 9. Comparison readiness

| Approach | Academic evidence | Re-harden? | Best fit | Worst fit |
|---|---|---|---|---|
| A-Acad-1 (TT-fixed interface) | endorsed for shuttle modules; **does not bind `wrapped_vga`** | no | shuttle-bound projects | non-shuttle wrappers like ours |
| A-Acad-2 (Caravel-fixed wrapper) | endorsed for Caravel projects; **does not bind `wrapped_vga`** | no | Caravel-bound projects | non-Caravel wrappers |
| B-Acad-1 (OpenLane re-harden) | endorsed by Ghazy & Shalan 2020 §II as "well-invested one-time effort" | yes | when wrapper port-list change is the goal | "minimum churn" priority |
| B-Acad-2 (contextualised I/O) | implied by re-harden; pin geometry refreshes | yes | clean LEF | preserving (x,y) of macro abstract pins |
| C-Acad-1 (DFT reuse) | literature silent | n/a (depends on RTL change) | n/a | n/a - silence is not licence |
| C-Acad-2 (internal const tieoff) | literature silent | no (G8) | "stable LEF/Lib" priority | "honest interface" priority |
| C-Acad-3 (eFuse-driven) | literature silent | yes | item (j) showcase | today |
| D-Acad-1 (cell-type swap) | refuted on PDK grounds | n/a | n/a | violates frozen-bondout |

Property: the academic literature endorses re-harden as routine
for the "macro RTL evolves" use case (B-Acad-1). It does not
endorse a specific cleanup-vs-leave policy for two dead bits on
a private wrapper. Stage 2 will need to make that call on
non-academic grounds (engineering judgement, code clarity,
build-flow hygiene).

## 10. Author's notes

- The brief's explicit "if the academic literature is thin,
  document that as a finding" was the right framing for this item.
  Two of the four substantive references (TinyTapeout SSC-M;
  Caravel ESL case study) are *contextually* relevant but do not
  directly speak to the (g) question. The other two (OpenLANE
  WOSET; OpenROAD DAC invited) speak to the *re-harden cost
  / mechanism* but not to the *should-we-or-shouldn't-we*
  question.
- The most useful academic single sentence located in this sweep
  is Ghazy & Shalan 2020 §II's framing of hardening as "a
  well-invested one-time effort" with re-hardening treated as
  routine. This is the closest the literature comes to an opinion
  on item (g).
- I deliberately did NOT pad §6 with weakly-relevant references
  (e.g. EDA flow papers that mention LEF abstracts only in
  passing, or vendor IP datasheets dressed up as "academic"
  citations). The per-item README and METHODOLOGY.md
  §"Calibration" both warn against performative thoroughness, and
  an academic survey that cites 12 papers when only 4 are
  substantively relevant is a worse output than a survey that
  cites 4 and explicitly documents that the literature is thin.
- The parallel `stage1-industry-survey/` and
  `stage1-first-principles/` reports are both already on disk
  (status: draft). This academic-survey survey is the third leg
  of the Stage-1 tripod; Stage 2 can now run gap-analysis across
  all three.
