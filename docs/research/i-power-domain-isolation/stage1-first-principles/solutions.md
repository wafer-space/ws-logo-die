# Solutions / topology catalogue (item i, Stage 1 first-principles)

## Family A — Logical-only separation

### A1 — single-domain-with-rtl-gating

One physical VDD/VSS pair. RTL gates blocks based on rail-presence
flags. Used in single-rail microcontrollers. Cannot satisfy "either
domain alive while the other is dead" because the *one* rail is
shared. **Baseline / fallback only.**

### A2 — pcb-schottky-or

Two pad pairs but OR'd by external Schottkys on the PCB. Banned by
project rule R2 (no external passives). **Listed and rejected.**

## Family B — Split VDD, shared substrate

### B1 — split-vdd-shared-vss-no-crosssignal

Two VDD nets, one VSS net (shared substrate). No cross-domain
signals — the two domains never share a wire. Implementable in
LibreLane via two `voltage_domain` regions. Pad-ring split via
`brk5`. **Sufficient for v2 only if the feature set has no
cross-domain signalling.**

### B2 — split-vdd-split-vss-shared-substrate

Two VDD nets, two VSS nets, but the substrate is still shared (both
VSS effectively at substrate potential ± transient noise).
Cross-domain signals via D1 level shifters. **The realistic v2
target if cross-signals are required.**

## Family C — Substrate-isolated

### C1 — dnwell-tubbed-harv

HARV-domain NMOS bodies are wired to a local VPW that sits inside a
DNWELL tub, electrically decoupled from the global P-substrate.
**Highest isolation, highest effort.** Requires custom std-cell
library. Justifiable only if HARV digital is small (< 1000 gates).

## Family D — Level shifter topologies (sub-primitives)

### D1 — pure-cmos-cross-coupled

Cross-coupled PMOS load + NMOS pull-down inverter pair. Static
current ≤ 1 nA when input rail is dead. **Recommended for digital
cross-domain signalling at 5/5 V class.**

### D2 — current-mirror-based

Always pulls 1–10 µA bias. Output floats when input rail dies.
**Rejected for HARV-domain due to power budget.**

### D3 — self-biased-differential

100 nA static current. Threshold tracks output rail. Acceptable for
small numbers of cells. Could be used if D1 contention margin is
too tight.

### D4 — comparator-based

10 µA tail current. Sledgehammer for digital — proper for
cross-domain analog-to-digital signalling (e.g., "is rail above
3 V?").

### D5 — ac-coupled-pulse

Capacitor + SR latch. Zero static current. **Excellent for low-
rate digital flags.** Sized capacitor + receiving latch must hold
state.

## Family E — Isolation cell topologies (sub-primitives)

### E1 — clamp-to-rail-high

NAND2 + inverter forces output high when iso enable de-asserted.

### E2 — clamp-to-ground

AND2 + inverter forces output low.

### E3 — tristate-with-retention

Tri-state output + receiving-side latch. Latch is best-effort
without true retention flop.

### E4 — no-isolation-let-it-float

Don't isolate. Receivers see floating input when source dies.
Cheapest. Risky if downstream gates have crowbar current at mid-
rail input.

## The five integrated strategies (S1–S5)

These cherry-pick from Families A–E into named end-to-end strategies
for Stage-2 / Stage-3 comparison.

### S1 — single-domain-rtl-gating
A1 only. Trivial. **Fallback.**

### S2 — split-vdd-shared-vss-no-cross
B1 + (no D, no E). **Lowest-effort multi-domain that satisfies
R1+R7.** Requires zero cross-domain RTL signals.

### S3 — split-rails-d1-noiso
B2 + D1 + E4. **Balanced.** Cross-signals work; isolation is "hope
downstream resets". 50 nA cross-leakage worst-case.

### S4 — split-rails-d1-with-iso
B2 + D1 + (E1 or E2). **Brown-out-clean.** Each cross-domain signal
has a deterministic state when its source dies. Power-good
detector per domain drives iso enables.

### S5 — dnwell-tubbed-d1-iso
C1 + D1 + (E1 or E2). **Substrate-isolated, analog-grade.**
Highest isolation, highest design effort, requires custom std-cell
library.

## Comparison table (mirrors report.md §9)

| Approach | Headline performance | Area/power cost | Maturity | Best fit | Worst fit |
|---|---|---|---|---|---|
| S1 | works only with 1 rail at a time | 0 area, 0 leakage | trivial | demo / fallback | concurrent VGA + LED |
| S2 | 2 rails, true isolation, no cross-signals | +2 brk5, +1 cor | low risk | feature-isolated v2 | needs cross-signal |
| S3 | 2 rails, ~50 nA cross-leakage | +S2 +50×D1 LS | medium risk | balanced | ramp-glitch survival |
| S4 | clean ramp + isolation | +S3 +50×iso clamp +2×PG detect | medium-high | brown-out tolerant | small projects |
| S5 | full substrate isolation, <1 nA | +S4 + custom HARV std-cells + DNWELL guard | high | analog-grade NFC | tight schedule |

## Approaches considered and discarded

- **Body biasing** to dynamically isolate domains — not supported by
  GF180MCU std-cells (NMOS body is fixed to substrate).
- **Tri-rail with always-on auxiliary rail** — no always-on rail
  available; not applicable.
- **Triple-well DNWELL for *both* domains** — symmetric variant of
  C1 where VGA is also tubbed. Doubles the DNWELL guard area for
  no clear benefit since VGA tolerates substrate noise; not
  warranted.
- **Stacked 1.2 V + 5 V domains** — would let us reuse the 1.2 V
  device flavour for low-power HARV. But the project's harvester
  rectifier output is 3.3 V class, and the std-cell library is 5 V
  only. Not applicable.
- **Deep-trench isolation** — not in GF180MCU.
- **SOI** — not GF180MCU.
- **Fully-isolated charge-pump bridge between domains** — adds an
  on-die transformer or charge pump. Massive area cost. Justified
  only if the cross-domain isolation must withstand kV ESD or
  galvanic isolation; we don't need either.
