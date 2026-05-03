# Open questions (item c, Stage 1 industry-survey)

## Q-1 — Q-factor of our 8-turn 56 × 40 mm Qi coil

The companion PCB has an 8-turn Qi coil on the L3 inner copper,
with the adjacent NFC perimeter spiral on L2 and **no ferrite
shielding**. Currently un-quantified.

**Decision impact**: directly determines the analog-ping
detectability and the FOD pre-power-transfer threshold margin.

**Settle by**: PCB measurement (or 3D EM simulation) — out of
scope for chip design but a hard prerequisite for tape-out.

## Q-2 — Minimum WPC-v1 packet sequence to keep a representative set of commercial Qi pads in Power Transfer phase

The Vinod-Tanur ATtiny13A receiver works on *some* pads. No
published systematic survey of the minimum-viable-protocol per
TX vendor exists.

**Decision impact**: gates the C2 free-rider architecture.

**Settle by**: Stage-3 deep-dive with a bench survey (5+
commodity Qi pads × min-protocol variants).

## Q-3 — bq51013B "Adaptive Communication Limit" implies our on-die capacitive-load-modulator must support ≥100 mA peak?

Reading the bq51013B datasheet, the load modulator targets
~100 mA peak modulation current to be reliably demodulated by
typical Qi TXs.

**Decision impact**: sizes the modulator switch in our (C2)
design. Affects analog area budget significantly.

**Settle by**: Stage-2 first-principles re-derivation from Qi
spec [W2] §6.5 (ASK-modulation depth requirements), then
Stage-3 deep-dive simulation of TX demod margin.

## Q-4 — Will Qi 2 MPP-only pads fall back to BPP when the Rx fails authentication?

Anecdotally yes, but the Apple MagSafe spec proper is
members-only. Critical because Qi 2 pads are increasingly
common.

**Decision impact**: determines whether (C2) free-rider works on
modern (post-2024) pads at all.

**Settle by**: Stage-3 deep-dive bench survey with a Qi 2 MPP
pad.

## Q-5 — Is the analog-ping current threshold low enough for a small PCB coil to be detected without any compliance-protocol participation at all?

Decides viability of C3 "ping snatcher". The analog-ping
threshold is set by the TX manufacturer, typically 50–200 mA on
the primary side.

**Decision impact**: determines whether C3 architecture is
viable as a fallback or only as a debug/bring-up mode.

**Settle by**: Stage-3 deep-dive with bench measurement on a
representative Qi pad.

## Q-6 — Realistic on-die MIM cap area available given the logo-on-all-metal floorplan constraint

Cross-references item (e). Affects C3 ping-snatcher viability
(needs ~10 µF on-die for a useful LED pulse — not feasible).

**Decision impact**: confirms C2 free-rider is the only viable
architecture for sustained-power harvesting.

**Settle by**: Joint Stage-2 review of (c) and (e).

## Q-7 — What does the AC clamp actually cost in area and on-state leakage?

Required by **all** free-rider designs (the 20 V V_rect spec
applies only to compliant receivers). The clamp must dissipate
the full incident Qi power if the chip is unloaded — a
worst-case event of ~5 W on-die.

**Decision impact**: drives a non-trivial portion of the analog
front-end budget.

**Settle by**: Stage-2 first-principles thermal calculation +
Stage-3 deep-dive on clamp topology.

## Q-8 — Is there a documented Qi-pad TX whitelist we can target?

For Stage-3 deep-dives, knowing the *de-facto* most-installed
Qi pad models (e.g., Apple MagSafe puck, Samsung 9 W charger,
generic IKEA charger) would let us focus the bench survey.

**Settle by**: Open data — Hackaday surveys, teardown blogs.
