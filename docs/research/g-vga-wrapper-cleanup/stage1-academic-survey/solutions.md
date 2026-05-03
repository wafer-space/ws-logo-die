---
item: g
item_name: vga-wrapper-cleanup
stage: 1
angle: academic-survey
researcher: claude-opus-4-7-1m Stage-1 academic-survey agent
status: draft
last-updated: 2026-05-02
---

# Solutions / Architectures from the academic record

This file enumerates approaches to the VGA-wrapper-cleanup problem
that have *some* support in the peer-reviewed academic record. It is
deliberately distinct from the parallel industry-survey and
first-principles solution maps: those exist already and this report
does not duplicate them.

The honest finding for this item: **the academic literature does
not directly address "what to do with two dead bits on a private
hardened-macro wrapper."** The four substantive references located
in this Stage-1 sweep speak to the *surrounding context* — how the
hardening flow treats macros generally, how shuttle wrappers handle
fixed pin sets, and what the per-harden cost looks like.

## A. Approaches with positive academic endorsement

### A-Acad-1. Fixed-port wrapper, tie off unused bits internally

**Source:** Venn, M. D. (2024). "Tiny Tapeout: A Shared Silicon
Tapeout Platform Accessible to Everyone." IEEE Solid-State Circuits
Magazine, 16(3), pp. 8–16. doi:10.1109/MSSC.2024.3418264.

**Position:** TinyTapeout user modules expose a fixed pin set
(`ui_in[7:0]`, `uo_out[7:0]`, `uio_in[7:0]`, `uio_out[7:0]`,
`uio_oe[7:0]`, `ena`, `clk`, `rst_n`). Unused bits are tied off
inside the user module via the conventional `_unused_ok = &{...}`
Verilog idiom. The shuttle multiplexer assumes a stable pin set
across all user projects.

**Maps to:** in-tree first-principles option G2 / G8; industry
option A1 / A2.

**Applicability to (g):** The shuttle convention binds the
**upstream** `tt_um_waferspace_vga_screensaver.v` (which already
follows it via line 70's `_unused_ok = &{ena, ui_in[7:1], uio_in}`).
It does **not** bind the in-tree `wrapped_vga.v` derivative wrapper.
So: this convention is satisfied today and is unaffected by any
choice we make on (g).

**Performance:** Zero re-harden cost. Zero RTL diff in the upstream
module.

**Failure mode:** A wrapper *one level outside* the shuttle module
(i.e. `wrapped_vga`) that still exposes 7 bits while only 5 are
functional is *not* what the SSC-M paper describes; the paper does
not endorse non-shuttle wrappers exposing dead bits. So citing this
paper to defend a "leave it alone" stance for `wrapped_vga` would
be a misuse of the source.

### A-Acad-2. Caravel-style golden-template wrapper, tie off in user_project_wrapper

**Source:** Shalan, M. & Edwards, T. (2020). "Building OpenLANE: A
130nm OpenROAD-based Tapeout-Proven Flow: Invited Paper." 2020
IEEE/ACM ICCAD, pp. 1–6. doi:10.1145/3400302.3415735. Also referenced
by Filip, A. et al. (2024). "Vector Accelerator Unit for Caravel."
IEEE Embedded Systems Letters, 16(1), pp. 73–76.
doi:10.1109/LES.2023.3267341.

**Position:** Caravel `user_project_wrapper` instances must adhere to
a fixed golden-template pin order. User-area pins not consumed by the
embedded design are left unconnected or tied off to known constants
inside the wrapper.

**Maps to:** in-tree first-principles option G2 / G8; industry
option A2.

**Applicability to (g):** The Caravel convention binds the
chip-shuttle wrapper, *not* the arbitrary internal hardened-macro
wrappers used in this project. Same caveat as A-Acad-1: the
academic position concerns shuttle wrappers, not internal cleanup
wrappers.

### B-Acad-1. Re-harden on RTL change as routine "well-invested one-time effort"

**Source:** Ghazy, A. A. & Shalan, M. (2020). "OpenLANE: The
Open-Source Digital ASIC Implementation Flow." Workshop on
Open-Source EDA Technology (WOSET), 2020. Available at
https://woset-workshop.github.io/PDFs/2020/a21.pdf.

**Position quote (§II):** *"Hardening a macro can be thought of as
a well-invested one-time effort. Once physically verified, that is,
once LVS- and DRC-clean, the same verified macro can be used across
different designs. Also, if one is strict with the specification of
the macro interface, which means pre-defining its exact dimensions
and pin locations, then in cases where the functional definition of
the macro itself is subject to change or if issues with the macro
were found later in the process, then the consecutive steps in the
process do not have to be repeated after fixing the issue, and it
is a matter of simply re-hardening the macro, according to the
specification, and 'plugging' it in instead of its outdated version.
This makes it possible to work top-down instead of bottom-up once a
preliminary version of the macro is available."*

**Maps to:** in-tree first-principles option G1; industry option B1
("reduce-5bit").

**Applicability to (g):** Direct. The paper explicitly endorses
re-hardening a macro when its RTL changes. Removing two dead bits
from `wrapped_vga.v` falls cleanly into the "functional definition
of the macro itself is subject to change" framing.

**Performance:** Per the paper §V (and the in-tree
`make project` invocation which empirically reproduces this):
single-digit minutes for a 0.25 mm² macro on the analogous SKY130
flow at this complexity. GF180MCU is in the same complexity class.

**Failure mode in original use case:** The paper's "first striVe"
chip example (§III) had macros scattered across the top-level with
randomly-assigned pin sides; this *did* require manual intervention
on every re-harden. The recommended hierarchy (one core macro,
contextualised I/O placement) eliminates that failure mode. Our
chip already follows the recommended hierarchy
(`librelane/slots/slot_1x1.yaml`), so this failure mode does not
apply to us.

### B-Acad-2. Contextualised I/O placement on every harden

**Source:** Ghazy, A. A. & Shalan, M. (2020). WOSET §III &
Fig. 3: "Contextualized I/O Pin Placement."

**Position:** When a macro is re-hardened, OpenLANE's contextualised
I/O placer optimises pin (x,y) given the macro's instantiation
context at the chip-top level. Pin locations on the macro abstract
are not preserved across re-hardens unless explicitly pinned via a
custom I/O placer config.

**Maps to:** corollary of B-Acad-1; affects the LEF/GDS view
specifically.

**Applicability to (g):** Important for downstream chip-top P&R.
After a re-harden, the macro's external pin geometry will be
*different* (subset, since fewer bits) and the chip-top router will
adapt automatically. No manual pin-pinning needed.

## B. Approaches the academic literature is silent on

### C-Acad-1. Repurpose dead bits as DFT/observability

**No academic endorsement found** for opportunistic reuse of dead
bits on a hardened-macro wrapper. The DFT literature (Gaber,
Abdelatty & Shalan, *Fault: An Open Source DFT Toolchain*, WOSET
2019; cited as ref [10] in Ghazy & Shalan 2020) addresses *adding*
scan ports during synthesis, not opportunistic reuse of pre-existing
dead pins.

**Maps to:** in-tree first-principles options G3 / G6; industry
option C1.

**Applicability to (g):** Inconclusive. Not refuted, not endorsed.

### C-Acad-2. Hardwire dead bits at constants inside the wrapper, keep 7-bit port

**No academic endorsement found.** Some DFT tools (e.g. tieoff
optimisations in commercial flows) do this, but the open-source
academic literature does not specifically discuss it as a wrapper
hygiene practice.

**Maps to:** in-tree first-principles option G8.

**Applicability to (g):** Inconclusive.

### C-Acad-3. eFuse-driven dead-bit configuration

**No academic endorsement found** for two-bit dead-pin eFuse
configuration. Most eFuse / OTP literature deals with chip-ID,
trim, and key-storage at much larger bit-counts. Two bits is below
the threshold the literature engages with.

**Maps to:** in-tree first-principles options G4 / G9.

**Applicability to (g):** Off-scope; depends on item (j) which has
no Stage-1 output yet.

## C. Approaches mentioned in surrounding literature but inapplicable

### D-Acad-1. Cell-type swap at fixed (x,y) (e.g. input -> bidir)

**Mentioned in:** OpenLANE WOSET 2020 §III "Preparation" step,
which discusses wrapping/abstracting hard macros. The paper notes
that hard macros' pin layers, sizes, and grid alignment may be
incompatible with the flow.

**Applicability to (g):** Refuted by the parallel first-principles
report's negative-result §7.2. The pad-cell type
`gf180mcu_fd_io__in_c` cannot be swapped for an output type at the
*same* (x,y) without violating frozen-bondout at cell-type
granularity. This kills the "use these as outputs" family of
options regardless of any academic endorsement.

## Summary of academic positions

| Approach short-name | Paper(s) | Position | Maps to |
|---|---|---|---|
| A-Acad-1 | Venn 2024 (SSC-M) | endorse fixed-pin shuttle wrapper, tie off unused bits | G2 / G8; A1 / A2 |
| A-Acad-2 | Shalan & Edwards 2020 (ICCAD); Filip 2024 (ESL) | endorse Caravel golden-template, tie off unused | G2 / G8; A2 |
| B-Acad-1 | Ghazy & Shalan 2020 (WOSET) | endorse re-harden on RTL change | G1; B1 |
| B-Acad-2 | Ghazy & Shalan 2020 (WOSET §III) | I/O placement is re-optimised every harden | corollary of B-Acad-1 |
| C-Acad-1 | (silent) | no academic position on dead-bit DFT reuse | G3 / G6; C1 |
| C-Acad-2 | (silent) | no academic position on internal-only constant tieoff | G8 |
| C-Acad-3 | (silent) | no academic position on 2-bit eFuse use | G4 / G9 |
| D-Acad-1 | Ghazy & Shalan 2020 (Preparation step) | refuted on PDK grounds | G5 |

The academic record provides positive support for either:

- (Family A) keeping a fixed-pin shuttle wrapper unchanged when one
  is in use (does not directly apply to non-shuttle `wrapped_vga`);
- (Family B) re-hardening a macro when its RTL changes (directly
  applies to G1 / B1).

The record does **not** provide guidance on the
"shrink-vs-leave-alone" call for the specific case of two dead bits
on an internal hardened-macro wrapper. Stage 2 must make that
decision on engineering-judgement grounds, not academic citation.
