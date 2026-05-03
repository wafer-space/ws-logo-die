# Components — sub-block inventory (item c, Stage 1 industry-survey)

The industry-survey angle inherits its sub-block decomposition
from the first-principles sister report. See
[`../stage1-first-principles/components.md`](../stage1-first-principles/components.md)
for the canonical component list.

This file enumerates **industry-survey-specific** sub-block
findings — corrections, additions, and named-IC anchors — to
augment the first-principles inventory.

## Industry-anchored sub-block additions

### AC clamp (mandatory for free-rider designs)

The Qi spec's **20 V V_rect guarantee** does not apply to
non-compliant receivers. Worst-case open-circuit AC swing on a
partly-resonant secondary can exceed 300 V_pk. A hard analog
clamp at the AC pads is **non-optional for any free-rider
design**.

bq51013B's CLAMP1/CLAMP2 reference circuit is **not directly
reusable** — it relies on an external 0.47 µF cap that our
no-external-passives rule forbids. Our equivalent must be a
closed-loop on-die clamp.

### Modulator (required for C2 free-rider)

Vinod-Tanur ATtiny13A pattern: ~500 gates digital + ASK
back-modulator. Our equivalent on-die capacitive-load modulator
(loading the AC node with a switched cap to encode bits) needs
**≥100 mA peak modulation current** — implied by bq51013B
"Adaptive Communication Limit" feature spec (Q-3 in
open-questions.md).

### Brown-out detector

Required by C3 ping-snatcher (and good practice for C2). On-die
band-gap-referenced comparator with hysteresis. Reuses (a)
bandgap from oscillator subsystem if temperature-coefficient
budget allows.

### Storage cap (cross-ref item (e))

C2 free-rider sustains ~500 mW load over 4 ms (between WPC
packets); needs ~1 mF if we need 100 mV ripple — *off-die*. C3
ping-snatcher harvests ~mJ per ping at 0.4 s cadence — needs
~10 µF on-die at 5 V to deliver a useful LED pulse.

### Compliance-protocol RTL

C1 full WPC stack: ~3000 gates. C2 free-rider: ~500 gates. C3
ping-snatcher: ~50 gates (just BOR + cap-discharge counter).

## Sub-blocks that the first-principles sister already covers

- Synchronous-rectifier MOSFETs (A3) sized per the
  first-principles `R_DS(on)` budget.
- LDO (B1) topology choices (PMOS vs NMOS pass).
- Inductor / coil interface (off-die, set by companion PCB).

## Industry-anchored named ICs

For Stage-2 / Stage-3 deep-dives, the most directly portable IP
templates are:

- TI bq51013B (sync-rect + LDO + WPC v1.0 stack)
- IDT/Renesas P9221-R3 (A5 hybrid adaptive-delay rectifier)
- Vinod-Tanur GitHub (C2 free-rider firmware on ATtiny13A)
