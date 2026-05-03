# Open questions (item e, Stage 1 industry-survey)

## Q-1 — Which metal layers does `big_logo` actually use?

The logo-on-all-metal constraint (per the v1 floorplan and the
`Metal2_ignore_active: true` workaround in
`librelane/config.yaml`) interacts with the MIM cap stack
choice. If `big_logo` uses M4 or M5 visibly, MIM-2f0-M4M5 (the
blessed default) may need to move stacks.

**Decision impact**: gates the MIM stack selection.

**Settle by**: Stage-2 inspection of `big_logo.gds` layer-by-
layer.

## Q-2 — Move v2 from 5LM to 6LM stack?

GF180MCU offers a 6LM (6-layer-metal) variant. A 6LM stack adds
M6, freeing M4-M5 for MIM and giving M5-M6 as an alternative
MIM stack. Cost/benefit unknown.

**Decision impact**: doubles MIM area headroom.

**Settle by**: Stage-2 review of foundry-shuttle `--variant`
options (Q-4) and area budget.

## Q-3 — How much fillcap_* is the current chip ALREADY placing?

LibreLane defaults to placing `fillcap_*` cells in std-cell row
gaps. Without measurement, the actual fF count is unknown — and
this directly bears on whether an explicit MIM bank is necessary
or whether the implicit MOS-cap fill is sufficient.

**Decision impact**: determines whether explicit bulk-storage
MIM cap is required.

**Settle by**: Run `magic` extraction on the v1 final GDS, sum
`cap_nmos_06v0` instances inside `fillcap_*` macros.

## Q-4 — Which `--variant` (A..F) is the wafer.space MPW shuttle?

The GF180MCU MPW shuttle ships in multiple `--variant`
configurations. Each variant blesses a different MIM density
and stack pair. We need to know which variant the wafer.space
MPW uses.

**Decision impact**: determines which MIM PCell is selectable.

**Settle by**: Check the wafer.space MPW shuttle documentation.

## Q-5 — How much current does NFC modulation half-cycle pull?

NFC ASK back-modulation pulls a load-modulator current from the
NFC rect-out node. The current waveform shape (peak, duration,
duty cycle) determines the storage-cap droop budget.

**Decision impact**: sizes the F8 hybrid HV-dump cap.

**Settle by**: Stage-3 deep-dive simulation of the NFC modulator
loading the cap.

## Q-6 — Does `Metal2_ignore_active` remain valid signoff under GF MPW rules?

The `KLAYOUT_FILLER_OPTIONS: Metal2_ignore_active: true`
workaround was accepted for v1. For v2, does the wafer.space
MPW signoff flow still permit ignoring M2 density on dummy-fill
checks?

**Decision impact**: gates the entire fill-strategy approach.

**Settle by**: Email wafer.space MPW signoff team.

## Q-7 — What is the practical area budget for a hybrid HV-dump cap?

If F8 hybrid (MIM-1f0 at 20 V) is chosen, the cap area still
competes with the rest of the chip. We need a concrete area
budget after the logo, the padring, and the digital core are
allocated.

**Decision impact**: sizes the F8 hybrid storage architecture.

**Settle by**: Stage-2 floorplan budget review.

## Q-8 — Can fillcap_* be displaced by user-MIM cap area?

If a user MIM cap occupies a region of the die that would
otherwise have been std-cell-row fillcap, what is the net cap
gain? (MIM: ~2.0 fF/µm². Fillcap: ~0.20 fF/µm². 10× gain — but
fillcap was free.)

**Decision impact**: tunes the MIM-to-fillcap ratio for the
optimum bulk + decoupling combination.

**Settle by**: Stage-2 first-principles area-vs-energy
optimisation.
