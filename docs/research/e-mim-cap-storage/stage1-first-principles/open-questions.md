# Open questions (item e, Stage 1 first-principles)

## Q-1 — Real MIMTM.8a min top-plate-width interpretation (5 µm min vs max)

The 5 µm dimension referenced in MIMTM.8a — is it minimum or
maximum? Different DRC-deck versions disagree. **Decision impact:**
whether very small MIM tiles (e.g. 5×5 µm = 25 µm² = 50 fF) are
DRC-clean. **Settle by:** ask Mabrains / parse latest DRC version.

## Q-2 — Smallest void between logo features

logo PNG rasterised at 3.4 µm pixel pitch — voids may be too small
for MIMTM min-area rules. **Decision impact:** how much of the
logo bbox is actually usable for MIM. **Settle by:** KLayout scan
of `big_logo.gds` + DRC test.

## Q-3 — Effective MIM bottom-plate spacing rule against logo M4

MIMTM.1 requires 1.2 µm spacing of MIM bottom-plate to unrelated
M4. Inside the logo bbox the MIM cap shapes must be the *complement*
of the logo's M4 pattern, eroded by 1.2 µm. **Does it eliminate
>50 % of logo voids?** **Settle by:** DRC-clean trial layout.

## Q-4 — wrapped_vga + digital area consumption of core (unknown to this report)

Unknown core area is committed to wrapped_vga and chip_core
digital. **Decision impact:** how much core area is *available* for
caps. **Settle by:** parse `vga_screensaver/runs/latest/final/`
for cell area.

## Q-5 — Can MOS-cap fill + MIM coexist via parallel-add charge sharing?

Spice sim. MOS-cap voltage coefficient swings cap value 100× near
depletion — does parallel summing of MIM (linear) + MOS-cap
(nonlinear) deliver the expected total energy?

## Q-6 — Temperature coefficient impact on BLE timing

(irrelevant for LED, but flagged for completeness)

## Q-7 — Real (typical not max-spec) MIM leakage at 1 V vs 6 V

Likely 10× lower than the 1 pA/µm² spec (which is corner-case max).
**Decision impact:** S1 may be viable in ambient-RF mode if
real-world leakage is much less than spec.

## Q-8 — MIM density mask choice (1.0 / 1.5 / 2.0)

This is one tape-out decision affecting *all* analog blocks. Stage-
3 cost-benefit. Trade-off:
- MIM-2.0: highest density at 5 V rail, but 6.6 V tolerance only
- MIM-1.5: middle ground
- MIM-1.0: lowest density but 20 V tolerance (best for HV
  applications, charge-pump output, eFuse program rail)

**Decision impact:** affects every other research item that uses
caps. **Settle by:** Stage 2/3 shortlist comparison across
consumers.

## Q-9 — Seal-ring metal restrictions near die edge

(442 µm pad-ring already excludes most of edge)

**Decision impact:** how close to die edge the cap arrays can sit.

## Q-10 — One-time pre-charge from VGA rail at insert-and-remove

Could pre-charge a big cap from VGA's 5 V rail just before unplug,
then sustain LED twinkle for some time after. **Decision impact:**
gives a "ride-through" mode that doesn't depend on harvest.
**Settle by:** estimate plausible storage at MOS-cap fill density;
calc twinkle duration.
