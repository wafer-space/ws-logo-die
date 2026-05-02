# Prior context

This file captures *known* prior context that is NOT in the current
working tree but may inform Stage-1+ research. Surfaced by an
episodic-memory search on 2026-05-03.

Researchers should treat the items below as *priors to verify*, not
as established conclusions.

## Wafer.space business-card project — earlier discussion (2026-05-02)

Conversation file (off-tree, not in this repo's history):
`~/.config/superpowers/conversation-archive/-home-tim-github-wafer-space-business-card/a7b6e3bd-5f43-4e20-acdf-5230a423f27b.jsonl`

Topics covered:

- Power-harvesting feasibility study for the wireless-powered
  business-card form factor.
- **A 50 mW power-budget target was discussed** as a sizing
  constraint for at least one of the harvesters (probably Qi, since
  NFC-budget is sub-mW and ambient-2.4-GHz is sub-µW). Researchers
  should treat 50 mW as one *plausible* target but not as a hard
  requirement until verified — the v2-chip-side budget is set by
  what consumers (LEDs, NFC core, BLE) actually need, not by what
  the harvester *could* deliver if pushed.
- NFC vs Qi coil placement on a credit-card-sized PCB; antenna-layout
  tradeoffs.
- Q-factor considerations for multiple simultaneous standards on the
  same physical card.
- Mechanical integration (clear epoxy dome over the wire-bonded
  die).

Researchers on items (b), (c), (d), (e), (i) should at least note
this 50 mW figure when discussing power budgets, and reconcile their
own derivations against it.

## GF180MCU PDK cap-type validation (2026-04-03)

Conversation file (off-tree):
`~/.config/superpowers/conversation-archive/-home-tim-github-wafer-space-wafer-space-github-io/874e1e2d-9ccf-481f-b269-5df546db5b96.jsonl`

Topics covered:

- Validation that GF180MCU offers **MOM (metal-oxide-metal) and MOS
  (metal-oxide-semiconductor) capacitors**.
- **PIP (poly-insulator-poly) references were removed** during
  documentation review — i.e. PIP is *not* part of `gf180mcuD` even
  though it appears in some early documentation drafts.

Researchers on item (e) MIM caps should explicitly *exclude* PIP from
their topology surveys (or include it with a clear note that it does
not exist in this PDK).

## Items with no prior conversation context found

The episodic-memory search returned **no substantive prior
discussion** on:

- RF rectifier topologies on `gf180mcuD`.
- NFC tag IC design beyond the antenna level.
- Silicon oscillator topology selection at 180 nm.
- eFuse / OTP cell design on open-source PDKs.
- Bluetooth Low Energy radios at 180 nm.
- LED driver design under harvested-power constraints.
- On-die energy-storage cap sizing strategies.
- Multi-domain power isolation in `gf180mcuD`.

This is fresh territory. Researchers should not assume any prior
in-house work exists; everything has to be built from public sources
plus first principles.

## How researchers should use this file

- Read this file as part of required reading after `METHODOLOGY.md`
  and the per-item README.
- Where this file states a prior target or design choice, treat it
  as a hypothesis to verify against your independent analysis. If
  your derivation disagrees with the prior, *state the disagreement
  in your report* — both numbers (yours and the prior) — and explain
  the discrepancy.
- If subsequent episodic-memory searches surface additional prior
  context, append to this file (do not rewrite earlier sections,
  since they may have already informed downstream reports).
