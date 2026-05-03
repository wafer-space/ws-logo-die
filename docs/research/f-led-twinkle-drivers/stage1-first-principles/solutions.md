# Solutions catalogue (item f, Stage 1 first-principles)

| Short | Topology | Naïve / sophisticated |
|---|---|---|
| T1 | On-die resistor ballast + switch | Naïve floor |
| T2 | Classical current mirror | Conventional analog |
| T3 | Current-DAC + PWM | Conventional + digital |
| T4 | Charge-pumped bucket-dump | Sophisticated |
| T5 | Boost converter w/ on-die L | **Rejected (physics)** |
| T6 | Tribrid: SC multiplier + bucket-dump | Most sophisticated |
| T7 | Direct switch (LED dynamic-r only) | Simplest |

## Comparison-readiness table

| Approach | Headline performance | Area / power cost | Maturity | Best fit for | Worst fit for |
|---|---|---|---|---|---|
| T1 — resistor ballast | η ≈ V_f/V_rail (56% red); peak I limited by R; PVT-tolerant for twinkle | ≈2-5 kΩ poly + 50-100 µm switch; ~10k µm² | Trivial | Red/orange/yellow on intermittent rail; min area; graceful dim | Blue/white; precise brightness |
| T2 — current mirror | I-regulated; η identical to T1; cliff-edge brown-out | Bandgap (~50k µm²) + mirror (~5k µm²) | Mature analog | Steady controlled-I apps | Twinkle on intermittent rail |
| T3 — current-DAC + PWM | Programmable I; PWM duty; η identical to T1 | T2 + DAC tail (~5k µm²) + PWM counter (~1k gates) | Mature | Multi-level twinkle | Strict area minimisation |
| T4 — bucket-dump | η ≈ 50%; ~1000× rail-coupling reduction; graceful brown-out | 10 nF MIM (**~5 mm² @ 2 fF/µm²** — corrected 2026-05-04 from "~50k µm²" with 100× cap-arithmetic error; 5 mm² > 2.25 mm² die so bucket cap must shrink to ≤4 nF or move off-die) + 2 switches | Less common | Brown-out-prone rails; pulse-LED protection | Steady illumination |
| T5 — boost w/ on-die L | n/a | physically impossible | Rejected | n/a | Everything |
| T6 — tribrid SC-mult + bucket | η ≈ 30-40%; drives blue/white from 3.3 V | T4 + 1 cap + 3 switches | Less common | Blue/white at 3.3 V; series strings | Red is sufficient |
| T7 — direct switch | η = V_f/V_rail (max); I set by switch I_DSAT | ≈100-200 µm switch + eFuse trim; ~2k µm² | Trivial | Single colour, single LED, ±3× PVT acceptable | Brightness uniformity |

Total distinct topologies: **7** (incl. one explicitly rejected on
physics grounds). Exhaustiveness bar: ≥5.
