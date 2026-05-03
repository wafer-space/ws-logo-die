# Open questions — academic-survey angle

These are concrete unanswered questions that the academic
literature alone cannot answer. Each names the decision /
downstream work it gates and a guess at what kind of work
would settle it.

## OQ-A1. Measured-130 nm vs sim-180 nm — which is lower risk?

**Question:** The Wilson-mirror TC-2 (LUT2010) is measured
silicon at 130 nm — one process node from GF180MCU. The
RCC TC-3 (KAB2019 (corrected from HOSS2019 2026-05-04 per reviewer-1)) is post-layout sim at the *exact* node
(180 nm). Which is the lower risk for porting?

**Decision gated:** Stage-3 / Stage-4 deep-dive shortlist.
Choosing the wrong topology costs a Stage-5 implementation
cycle.

**Investigation:** import both schematics into GF180MCU
device models and run a 25-corner Spice MC sweep (TT/FF/SS/SF/FS
× −40/25/125 °C × ±10 % VDD on each rail). Record VIN_min
at trip threshold for each.

## OQ-A2. RCC pull-up regulator — corner stability?

**Question:** TC-3's "regulated pull-up" is what gives the
80 mV min VIN. Its mismatch sensitivity has not (per
literature search) been published as silicon Monte-Carlo.
*How robust is the trip threshold to local Vt mismatch?*

**Decision gated:** decides whether RCC needs trim-tuning
(eFuse from item (j)) or operates open-loop.

**Investigation:** schematic-level Spice MC (Monte-Carlo
on Vt mismatch).

## OQ-A3. Single-Vt retention flop — does any topology exist?

**Question:** The MTCMOS / soft-iso / glitch-free families
all assume multi-Vt. Is there an academic retention-flop
topology that uses *only single-Vt* devices and substitutes
geometric / capacitive isolation for the high-Vt sleep
header?

**Decision gated:** whether item (i) needs retention at all,
or if MIM-cap energy storage (item (e)) is the entire
"state survives brown-out" answer.

**Investigation:** further literature search at Stage 2
on "single-Vt retention flop" — possibly looking at
sub-threshold-class research from the Calhoun group (UVa);
this search did not exhaust that corner.

## OQ-A4. CHEN2021 parasitic-NPN — does it apply at our voltage delta?

**Question:** Their study is HV-PMOS (40 V) / LV-PMOS
(5 V) in 0.15 µm BCD. Our worst-case is 5 V VGA-DVDD vs
~3.3 V VDD_HARV — much smaller delta. Does the parasitic
NPN even reach trigger threshold at 1.7 V differential?

**Decision gated:** whether the harvested-rail PCOMP guard
ring needs the design-rule extra-spacing the CHEN2021 paper
recommends, or whether GF180MCU's standard DRC DN.2b
(5.42 µm DNWELL diff-potential) already covers the case.

**Investigation:** device-level sim with extracted
parasitic NPN; check Vh ≥ 1.7 V holding-voltage condition.

## OQ-A5. Cold-start interaction (TC-6) — does (b)/(c) need iso during cold-start?

**Question:** SHRIV2015 says yes (the boot path must be
deliberately isolated from the control rail during the
ramp). Confirm with the (b)-side investigator that the
NFC / Qi rectifier output ramp-rate budget on our chip
matches the 220 mV → 1.0 V SHRIV2015 envelope.

**Decision gated:** whether our (i)-domain isolation cells
need a "cold-start mode" with raised threshold, or whether
the standard run-mode iso is sufficient.

**Investigation:** load the SHRIV2015 boost-converter
ramp-rate trace into the (i)-side Spice testbench and
verify isolation does not collapse the harvested rail
during the ramp.

## OQ-A6. Caravel slice cells — could we hand-roll a GF180MCU equivalent?

**Question:** `sky130_ef_io__connect_vcchib_vccd_and_vswitch_vddio_slice_20um`
is the open-source slice cell that physically bridges two
power buses inside the IO ring. The first-principles
report points at `gf180mcu_fd_io__brk5` as the analogous
insertion site. Can a 20 µm-wide slice be hand-rolled?

**Decision gated:** whether the v2 chip can adopt
Caravel-style multi-domain ring topology, or must invent a
GF180MCU-specific pattern.

**Investigation:** layout prototype — copy the
`brk5` cell, add hand-rolled D.1 back-to-back diodes
(`diode_nd2ps_06v0` + `diode_pd2nw_06v0`), DRC + LVS check.

## OQ-A7. Sky130-hvl level shifter port to GF180MCU — feasible?

**Question:** sky130's `sky130_fd_sc_hvl__lsbufhv2lv` and
`__lsbuflv2hv` cells are open-source under Apache 2.0.
Their *circuit topologies* are portable; the device models
are not. Could the Stage-2 / Stage-4 work include a
*topology port* — re-characterise the same circuit in
GF180MCU device models?

**Decision gated:** whether the project can recover Caravel-
class flow ergonomics by porting cells, or must hand-roll
isolated/level-shifted cells from scratch.

**Investigation:** read the sky130 hvl liberty / cdl,
check if all primitives map; if so, prepare a "port
sky130 hvl level shifter to GF180MCU" Stage-4 work-package.

## OQ-A8. UPF compliance — give up or hand-roll?

**Question:** GF180MCU has no level-shifter, isolation, or
retention cells. UPF v4.0 commands like `set_isolation`
and `set_level_shifter` rely on cell names. Should we
(a) give up on UPF compliance and use ad-hoc multi-domain;
(b) hand-roll the cells and characterise them ourselves;
or (c) wait for GF180MCU PDK to ship a multi-domain
addendum?

**Decision gated:** Stage-2 synthesis — flow architecture.

**Investigation:** survey the GF180MCU GitHub issues /
roadmap for multi-domain cell plans; survey the open-PDK
ecosystem for any in-flight contributions.

## OQ-A9. Where is the "shared bias network" for TC-2 grounded?

**Question:** Wilson-mirror level shifters need an Iref
that is generated from one of the two domains. If from
the VGA domain, the bias is dead during VGA-off mode
(harvested-only operation). If from the harvested domain,
the bias is dead during cold-start. Is there an academic
example of a *dual-source* bias generator that
gracefully fails over?

**Decision gated:** topology completeness of TC-2 family.

**Investigation:** literature follow-up — keyword
"dual-rail bandgap" or "always-on biasing dual-supply".

## OQ-A10. Did the academic search miss a 2024–2026 ISSCC/A-SSCC paper?

**Question:** IEEE Xplore is bot-blocked per the brief.
Is there a 2024–2026 ISSCC / A-SSCC measured-silicon
multi-domain isolation paper that hasn't yet diffused
into Semantic Scholar / ResearchGate / arXiv?

**Decision gated:** completeness of this Stage-1 academic
survey.

**Investigation:** human reviewer with IEEE Xplore access
spot-checks the 2024–2026 conference proceedings tables of
contents for the listed venues. ~30-minute task.
