# Solutions catalogue (item d, Stage 1 first-principles)

Six distinct multiplier topologies catalogued (exceeds the
Stage-1 minimum of 5).

## S1: `villard-native-singleseries`

- Multiplier: 6-stage Villard cascade (asymmetric)
- Devices: native-Vt NMOS, no threshold cancellation
- Match: single series L (5 nH on-die spiral) + shunt C
- Storage: 1 nF MIM
- Pros: simplest, smallest area, best fit for single-ended antenna
- Cons: ~3–7% η at -20 dBm; lowest of the catalogue
- First-principles verdict: works at 1 m, marginal at 2 m, dead at 5 m

## S2: `dickson-native-pi-match`

- Multiplier: 8-stage Dickson, native-Vt NMOS
- Match: pi-network at Q ≈ 5
- Storage: 1 nF MIM
- Verdict: ~5–10% η at -20 dBm; first-class "default"

## S3: `transformer-cc-pmos-nmos`

- Multiplier: 4-stage cross-coupled (PMOS + NMOS), differentially
  driven from on-die transformer secondary
- Match: 2-turn transformer, primary single-ended → secondary
  differential, ~3× voltage step-up
- Storage: 1 nF MIM
- Pros: highest η at -20 dBm (~12–18%); native single-pin
  compatible via transformer
- Cons: largest area (~0.07 mm² for transformer); transformer Q
  sensitivity at GF180MCU
- Verdict: best-η topology compatible with single-pin antenna

## S4: `dickson-aux-bias-bootstrap`

- Multiplier: 6-stage Dickson with aux-bias threshold
  cancellation; bootstrapped startup
- Devices: native-Vt NMOS with each gate biased at +Vth_eff via
  slow-charge bias chain
- Self-start: first stage operates naïvely until bias rail rises,
  then cancellation kicks in
- Match: pi at Q=5
- Storage: 1 nF MIM
- Pros: ~10–20% η at -20 dBm (best for non-transformer topology);
  compact
- Cons: complex; bias-chain quiescent (~50 nA) eats budget at low
  input
- Verdict: highest η of non-transformer options; complex to verify

## S5: `villard-naive-strong-RF-only`

- Multiplier: 4-stage Villard, *standard* (not native) NMOS
- Match: minimal (bondwire L only)
- Storage: 100 pF MIM
- Pros: minimum area; ~0.005 mm²
- Cons: only operates at >0 dBm input (i.e. card touching the AP)
- Verdict: deliberately included as the "simplest dumb" baseline

## S6: `floating-gate-trim-rectifier`

- Multiplier: 6-stage Dickson with floating-gate offset on each
  rectifier device, programmed at test
- Cross-dependency: requires (j) eFuse / FG infrastructure
- Pros: ~15–25% η at -20 dBm if FG offset holds over lifetime
- Cons: huge engineering effort; FG retention uncertainty over
  years; extra mask/test cost
- Verdict: best-η on paper but cost is disproportionate to use
  case

## Combinatorial design space summary

| Combination | Multiplier | Vth tech | Match | Stages | Area | η @ -20 dBm |
|---|---|---|---|---:|---:|---:|
| S1 | Villard | native | series-L | 6 | 0.06 mm² | 3–7% |
| S2 | Dickson | native | pi | 8 | 0.07 mm² | 5–10% |
| S3 | CC differential | native | transformer | 4 | 0.12 mm² | 12–18% |
| S4 | Dickson | native + aux-bias | pi | 6 | 0.10 mm² | 10–20% |
| S5 | Villard | standard | bondwire-only | 4 | 0.02 mm² | <1% |
| S6 | Dickson | standard + FG | pi | 6 | 0.10 mm² | 15–25% |

## Approaches discarded (with one-line reasons)

- `direct-thermoelectric` — first-principles efficiency
  catastrophic; rejected.
- `mechanical-resonator-MEMS` — no MEMS in PDK.
- `sub-harmonic-rectifier` — reduces fundamental capture; not
  advantageous for single-AP harvest.
- `digital-injection-locked-active-rectifier` — active oscillator
  power exceeds the harvest budget at our input levels.
- `differential-on-PCB-balun` — forbidden by "no external
  passives" rule.
- `passive-rectenna-with-no-multiplier` — at our input voltages
  the rectified DC never reaches LED drive voltage; multiplier is
  not optional.

## Stage-2 / Stage-3 handoff

Shortlist for Stage-2 gap analysis from this Stage-1 first-
principles angle:

- **S2** (`dickson-native-pi-match`) — strong default, no exotic
  infrastructure.
- **S3** (`transformer-cc-pmos-nmos`) — best η; pays in area.
- **S4** (`dickson-aux-bias-bootstrap`) — best η without
  transformer.
- **S1** (`villard-native-singleseries`) — minimum-area control /
  fallback.

S5 included only as deliberate "simplest dumb" reference. S6
listed but expected to be deprioritised on cost-benefit. **No
single approach is picked at Stage 1**, per methodology.
