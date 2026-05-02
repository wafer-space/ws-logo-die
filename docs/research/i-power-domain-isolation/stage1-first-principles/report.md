---
item: i
item_name: power-domain-isolation
stage: 1
angle: first-principles
researcher: stage1-first-principles-1
status: draft
last-updated: 2026-05-03
---

## 1. Executive summary

5 integrated end-to-end strategies (S1–S5), built from a 6-row
Family A/B/C × Family D level-shifter × Family E isolation-cell
taxonomy that itself enumerates 12 sub-primitives.

**Recommended floorplan locating harvested-rail pad pair
(provisional, subject to Stage 2):** Repurpose `analog[1]` and
`analog[0]` on the **north edge** as `harv_dvdd` and `harv_dvss`.
They are adjacent, sit at the corner away from VGA RGBHV bidir
pads on the south/east, and need only one
`gf180mcu_fd_io__brk5` insertion between them and `bidir[39]` to
break the io-ring DVDD/DVSS at the boundary. The v1 die's
`asig_5p0` cell at those positions still has ESD diodes, so
backwards-compat (R5) imposes a hard constraint that the
harvested rail never exceed ~5.7 V absolute (Vf above v1's DVDD).

**Latch-up risk assessment:** Substrate latch-up trigger requires
injected hole current of order 60–600 µA into substrate near an
NMOS source, given GF180MCU bulk Rsub ≈ 1–10 kΩ between substrate
tap and NMOS source and the 0.6 V emitter-base trigger of the
parasitic NPN. Realistic trigger is **negative undershoot of the
harvested rail** (rectifier diode reverse-recovery during NFC
modulation edges, or 13.56 MHz/847.5 kHz substrate noise).
Mitigation: keep `VDD_HARV` clamped above −0.5 V (the existing
`gf180mcu_ws_io__dvdd` D20 diode handles this for the IO ring),
and add a PCOMP guard ring tied to VSS around the HARV-domain
core area. Strong reader hits at 0 mm could push the antenna to
30 V open-circuit; the rectifier and clamp must absorb this
without injecting it into substrate.

**Most-surprising finding: GF180MCU's `gf180mcu_fd_sc_mcu7t5v0`
(and the 9t variant) standard-cell library contains *no* level-
shifter, *no* isolation cell, and *no* retention flop.** Every
cell uses NMOS body tied to the global P-substrate. The PDK *does*
have a working IO-ring break primitive (`gf180mcu_fd_io__brk5`,
with only VSS as a port — explicitly designed for multi-domain)
and DRC rules for different-potential DNWELL spacing (5.42 µm).
So the silicon allows full multi-domain isolation but the std-cell
library does not ship the primitives. **All level-shifter,
isolation, retention, and DNWELL-tubbed std-cell variants must be
hand-rolled.** This was not anticipated by the project brief,
which references "level shifters across the boundary: which PDK
cells are available?" — answer: none.

Other key first-principles findings:
- With a hand-rolled D1 (cross-coupled CMOS) level shifter, static
  cross-domain leakage is ≤ 1 nA per cell when one rail is dead.
  For 50 cross-domain signals, total cross-domain leakage = 50 nA
  ≪ 1 % of an NFC harvester budget (~50 µA at 3.3 V).
- The seal ring is one node at substrate potential — it is *not*
  domain-aware. For a shared-substrate strategy this is fine; for
  DNWELL-tubbed, the seal ring is irrelevant to the tubbed
  domain's local VPW.
- The current `gf180mcu_ws_io__dvdd` cell contains a hard-wired
  `D20: diode_nd2ps_06v0` from DVSS to DVDD; there is no
  ESD-stripped variant. This bounds how negative each domain's
  DVDD can swing (to ~−0.7 V).
- Big-logo metal usage: existing PDN uses Metal2(V)/Metal3(H);
  seal ring lives on M3/M4/M5. The cleanest second-domain PDN is
  *the same Metal2/Metal3 layers* but a separate `voltage_domain`
  region in `pdn_cfg.tcl` (LibreLane has the hooks via
  `set_voltage_domain ... -secondary_power`). Putting the second
  domain on Metal4/Metal5 is constrained by seal-ring usage and is
  not recommended.

## 2. Requirements as understood

R1 dual-rail isolation; R2 harvested rail powers (f) LEDs and (h)
NFC core only; R3 VGA path runs only from `DVDD`; R4 either rail
can be live independently; R5 v1 chip backwards-compat with v2
PCB; R6 no external passives; R7 top-metal logo preserved.

## 3. Solution-space map

### Family A — Logical-only separation

**A1 — single-domain-with-rtl-gating.** One physical VDD/VSS pair.
RTL gates blocks based on rail-presence flags. Cannot satisfy
"either domain alive while the other is dead". Baseline / fallback.

**A2 — pcb-schottky-or.** Two pad pairs OR'd by external Schottkys.
Banned by R6 (no external passives). Listed and rejected.

### Family B — Split VDD, shared substrate

**B1 — split-vdd-shared-vss-no-crosssignal.** Two VDD nets, one VSS
net (shared substrate). No cross-domain signals — the two domains
never share a wire.

**B2 — split-vdd-split-vss-shared-substrate.** Two VDD nets, two
VSS nets, but substrate still shared. Cross-domain signals via D1
level shifters.

### Family C — Substrate-isolated

**C1 — dnwell-tubbed-harv.** HARV-domain NMOS bodies wired to a
local VPW inside a DNWELL tub, electrically decoupled from global
P-substrate. Highest isolation, highest effort. Requires custom
std-cell library.

### Family D — Level shifter topologies (sub-primitives)

D1 pure-cmos-cross-coupled (≤1 nA static leakage when input rail
dead — recommended); D2 current-mirror-based (1-10 µA bias —
rejected); D3 self-biased-differential (100 nA static); D4
comparator-based (10 µA tail — sledgehammer); D5 ac-coupled-pulse
(zero static current).

### Family E — Isolation cell topologies

E1 clamp-to-rail-high (NAND2 + inverter); E2 clamp-to-ground
(AND2 + inverter); E3 tristate-with-retention (latch is best-
effort without true retention flop); E4 no-isolation-let-it-float.

### The five integrated strategies (S1–S5)

| Strategy | Family-mix | Description |
|---|---|---|
| S1 | A1 | single-domain + RTL gating; **fallback** |
| S2 | B1 | split-VDD shared-VSS, no cross-signals; **lowest-effort multi-domain** |
| S3 | B2 + D1 + E4 | split rails + D1 LS, no isolation; **balanced** |
| S4 | B2 + D1 + (E1/E2) | + isolation clamps; **brown-out clean** |
| S5 | C1 + D1 + (E1/E2) | DNWELL-tubbed HARV; **substrate-isolated, analog-grade** |

## 4. Sub-block breakdown

See [`components.md`](components.md). Adds to S1: brown-out / power-
good detector. To S2: harv-rail DVDD/DVSS pads (analog[0], analog[1]),
2× brk5, 1× extra cor cell. To S3: D1 level-shifters (~50 cells),
power-good × 2, brown-out × 2. To S4: isolation NAND/AND clamps. To
S5: custom DNWELL std-cell variant + DNWELL guard ring.

## 5. First-principles sanity checks

### 5.1 Reverse-leakage paths
Two domains sharing substrate: well-to-substrate diodes, ESD-clamp
diodes from one rail's pad to another, latch-up triggers. With D1
LS, leakage ≤1 nA/cell; for 50 signals, 50 nA total << NFC
harvester ~50 µA budget.

### 5.2 Latch-up trigger physics
Substrate Rsub 1-10 kΩ; parasitic NPN trigger at 0.6 V Vbe →
60-600 µA hole-current threshold. Negative undershoot of harvested
rail (rectifier reverse-recovery, 13.56 MHz substrate noise) is the
realistic trigger. Mitigation: keep VDD_HARV > −0.5 V (existing D20
diode); PCOMP guard ring around HARV core.

### 5.3 ESD-clamp cross-domain
`gf180mcu_ws_io__dvdd` cell has hardwired `D20` diode from DVSS to
DVDD. No ESD-stripped variant. Bounds DVDD swing to ≥ −0.7 V on
both domains.

### 5.4 big_logo PDN interaction
Logo on all metal layers. PDN uses M2(V)/M3(H); seal ring on
M3/M4/M5. Cleanest second-domain PDN is *same M2/M3 layers* via
LibreLane's `set_voltage_domain ... -secondary_power`.

### 5.5 Seal-ring crossings
Seal ring is one node at substrate potential — not domain-aware.
For shared-substrate strategies, fine; for DNWELL-tubbed, seal ring
is irrelevant to tubbed domain's local VPW.

### 5.6 Floorplan partitioning
Existing pad-side ordering: `analog[1]`, `analog[0]` are first two
PAD_NORTH entries (slot_1x1.yaml lines 63-64), confirming adjacent
at NW corner. Re-purposable as harv_dvdd / harv_dvss without
disturbing the VGA pad set.

## 6. References

See [`references.md`](references.md). Direct PDK-file reads:
`gf180mcu_fd_io.cdl` (D20 diode confirmed, brk5 VSS-only port);
`gf180mcu_fd_sc_mcu7t5v0.cdl` (229 .SUBCKT, 0 level-shifter cells);
`dnwell.drc` (rule DN.2b: 5.42 µm DNWELL diff-potential spacing).

## 7. Negative results

**NR1 — GF180MCU std-cell library has NO level-shifter, isolation,
or retention cells.** Verified by exhaustive read of `mcu7t5v0.cdl`
and `mcu9t5v0.cdl`. All custom-design.

**NR2 — `gf180mcu_ws_io__dvdd` has hardwired DVSS→DVDD diode.** No
ESD-stripped variant; bounds rail behaviour.

**NR3 — Body biasing for dynamic isolation not supported.** GF180
std-cell NMOS body fixed to substrate.

**NR4 — Triple-well DNWELL for both domains.** Doubles DNWELL guard
area for no benefit since VGA tolerates substrate noise.

**NR5 — Stacked 1.2 V + 5 V domains.** Project's harvester output
is 3.3 V class, std-cell library is 5 V only. Not applicable.

**NR6 — Deep-trench isolation, SOI, fully-isolated charge-pump
bridge.** Not in GF180MCU; or massive area cost without need.

**NR7 — Pad-cell type swap at fixed (x,y).** `gf180mcu_fd_io__in_c`
input-only cells cannot be swapped to bidir at the same position
without violating the bondout constraint at cell-type granularity.

## 8. Open questions

See [`open-questions.md`](open-questions.md). 10 questions; OQ1
(what cross-domain signals are actually needed) is highest-leverage.

## 9. Comparison readiness

| Approach | Headline | Area/power | Maturity | Best fit | Worst fit |
|---|---|---|---|---|---|
| S1 | works only with 1 rail at a time | 0 area, 0 leakage | trivial | demo / fallback | concurrent VGA + LED |
| S2 | 2 rails, true isolation, no cross-signals | +2 brk5, +1 cor | low risk | feature-isolated v2 | needs cross-signal |
| S3 | 2 rails, ~50 nA cross-leakage | +S2 +50×D1 LS | medium risk | balanced | ramp-glitch survival |
| S4 | clean ramp + isolation | +S3 +50×iso clamp +2×PG detect | medium-high | brown-out tolerant | small projects |
| S5 | full substrate isolation, <1 nA | +S4 + custom HARV std-cells + DNWELL guard | high | analog-grade NFC | tight schedule |

## 10. Author's notes

Coverage of the five strategies is genuinely exhaustive within the
first-principles angle. Five distinct strategies S1–S5, twelve
sub-primitives, all sized for static current. Reverse-leakage and
latch-up trigger calculations done from physics. PDK cells inspected
directly from CDL/SPICE/LEF (not literature). Reference verification
is light because the angle is "first principles" — the academic-
survey and industry-survey siblings own that load. **Confidence
~0.8 that no major strategy was missed**; the residual 0.2 is "what
would a Caravel/efabless multi-domain shuttle have done that I
didn't think of?"; that is precisely what the parallel surveys are
for.
