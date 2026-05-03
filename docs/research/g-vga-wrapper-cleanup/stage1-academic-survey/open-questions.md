---
item: g
item_name: vga-wrapper-cleanup
stage: 1
angle: academic-survey
researcher: claude-opus-4-7-1m Stage-1 academic-survey agent
status: draft
last-updated: 2026-05-02
---

# Open questions

Concrete questions surfaced by this academic-survey sweep that
remain unanswered. Each is phrased so a Stage-2 synthesiser can
either resolve it or escalate it.

## Q1. Does the academic literature have a position on dead-bit handling in non-shuttle hardened-macro wrappers?

**Why it matters:** The closest the literature comes (TinyTapeout
SSC-M 2024, Caravel ICCAD 2020) endorses fixed-pin shuttle wrappers
with internal tieoffs. It does not extend that endorsement to
non-shuttle internal wrappers like `wrapped_vga`. The Stage-1
sweep concluded "literature silent." Stage 2 needs to decide
whether that silence justifies treating "leave it alone" as a
valid academic position or whether it just means the question is
too small to publish on.

**Settles via:** A more thorough literature search — possibly
including theses (which engage with smaller-scale process
questions), WOSET 2021/2022/2023 (not searched in this sweep), and
the FOSSi Foundation El Correo Libre archives. Estimated cost:
half a day of focused search; could be done as part of Stage 2.

## Q2. Has anyone published the per-port LEF/Lib regeneration cost as a function of macro size on GF180MCU?

**Why it matters:** Ghazy & Shalan 2020 (WOSET) gives "single-digit
minutes" for sub-mm² macros on SKY130. GF180MCU at the same
complexity should be in the same ballpark, but the academic record
has fewer published GF180MCU benchmarks. The in-tree empirical
observation (`make project` runs in single-digit minutes) is
consistent.

**Settles via:** Direct measurement on the in-tree
`vga_screensaver` macro before vs. after the proposed cleanup.
Already feasible with the existing `make project` invocation —
zero research overhead, just run it twice and compare wall-clock
times.

## Q3. Is there a published convention for whether 5-bit-out-of-8 wrappers should preserve gaps or pack contiguously?

**Why it matters:** If we shrink `wrapped_vga.inputs` from 7 to 5,
we have a choice of bit assignment:
- Pack contiguously: `inputs[4:0]` map to `cfg_tile`, `cfg_solid`,
  `pmod_latch`, `pmod_clk`, `pmod_data`.
- Preserve upstream `ui_in[]` bit indices with gaps: `inputs[6:0]`
  becomes `inputs[6:4]` and `inputs[1:0]`, leaving 2 and 3 absent.

The Verilog language allows both; the OpenLane flow accepts both.
The academic literature on ASIC interface design doesn't strongly
favour either, though the SoC-integration culture (e.g. AMBA AXI
sideband signals) generally prefers contiguous packing.

**Settles via:** Engineering judgement. The parallel
first-principles and industry surveys lean toward contiguous
packing (option G1 / B1 as drafted). A Stage-3 synthesis decision.

## Q4. Does the TinyTapeout SSC-M paper or any of its references discuss "two-tier" wrapping (a private wrapper around a shuttle wrapper)?

**Why it matters:** Our `wrapped_vga` is exactly that: a private
in-tree wrapper around a TinyTapeout shuttle module. If the SSC-M
paper or its references address whether that second-tier wrapper
is allowed to deviate from the shuttle pin convention, that would
directly answer Q1.

**Settles via:** Read the full TinyTapeout SSC-M paper (currently
gated by IEEE Xplore 403/418 to LLM agents and TechRxiv preprint
mirror also 403). Could be obtained via institutional access or
manual download by a human collaborator.

## Q5. Are there published academic case studies of running a TinyTapeout-derived module outside the TinyTapeout shuttle context?

**Why it matters:** Our use of `tt_um_waferspace_vga_screensaver`
inside `wrapped_vga` inside `chip_top` is a "ride a TT module on a
non-TT chip" pattern. If anyone has published a case study of this
pattern, their wrapper-style choices are directly precedent for our
choice on (g).

**Settles via:** Targeted search. The IEEE ESL Caravel-vector-
accelerator paper (Baungarten-Leon et al. 2024 (corrected from 'Filip et al.' 2026-05-04 per reviewer-1)) is similar in spirit (a
custom accelerator wrapped for a fixed-shuttle host) but not
TT-derived. Worth a quarter-day of search in Stage 2.

## Q6. Is "academic silence on a small engineering question" itself a citable finding?

**Why it matters:** Methodology question. The per-item README
explicitly anticipates "if the academic literature is thin,
document that as a finding." This Stage-1 report does so. But
when the Stage-2 gap-analysis runs across all three Stage-1
reports (industry, academic, first-principles), how should it
reconcile a "literature silent" entry against industry and
first-principles entries that *do* take positions? Specifically:
should "academic silence" cause Stage-2 to **upweight** the
parallel non-academic positions (because no published academic
work refutes them) or **downweight** them (because no academic
work supports them either)?

**Settles via:** Methodology call. Recommend Stage-2 treat
"academic silence on a small engineering question" as neutral —
neither up- nor down-weighting — and rely on the in-tree empirical
observation and engineering judgement. This is consistent with
METHODOLOGY.md §"Calibration."
