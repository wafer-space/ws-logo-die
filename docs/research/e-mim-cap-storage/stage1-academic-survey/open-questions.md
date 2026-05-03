---
item: e
stage: 1
angle: academic-survey
---

# Open questions — academic survey

Each question is followed by:

- the decision / downstream work it gates,
- the kind of investigation that would settle it.

---

## OQA-1 — Is the `gf180mcuD` PDK MIM dielectric the Gambino 2019 stack?

**Gates.** Reliability tail at 125 °C operation; whether the PDK
1 pA/µm² leakage spec is a measured value of the Gambino MIM-B
or a worst-case bound on a different (e.g. SiN) stack.

**Settle by.** Foundry contact / GF design-rule manual lookup of
the actual MIM dielectric composition. Failing that, request the
TDDB datasheet from GF for the MPW shuttle being used.

---

## OQA-2 — Frenkel-Poole leakage de-rating at 3.3 V vs PDK-rated 6.6 V

**Gates.** Ambient-RF mode feasibility (5 µW harvest budget vs
MIM bank leakage). The first-principles report's
"5 mm² at 6.6 V is energy-negative" verdict may flip at 3.3 V if
the de-rating is the §5.4-estimated 5-20x.

**Settle by.** Spice corner sweep in Cadence / ngspice using the
PDK MIM model `cap_mim_2f0_m4m5_noshield` at V_op = 1, 2, 3.3,
5, 6.6 V; extract gleak vs V; fit Frenkel-Poole exp(beta*sqrt(V))
and confirm beta. If PDK SPICE doesn't model bias-dependent
leakage (constant gleak), then this question is *unanswerable*
from the model card and only silicon measurement settles it.

---

## OQA-3 — Pelliconi cell vs planar bulk MIM, per rail

**Gates.** Architectural commitment for each of NFC / Qi /
ambient-RF rails.

**Settle by.** Stage-2 synthesis pass that costs out (area,
power, complexity) Pelliconi-vs-bulk for each rail, given the
load-event spec from items (b)/(c)/(d).

---

## OQA-4 — DTC mass-availability via shuttle?

**Gates.** Whether `gf180mcuD` *might* be re-spinnable to a DTC-
enabled variant in future runs (e.g. via a foundry option).

**Settle by.** Direct GF contact. Unlikely to be available; ask
once and document negative result.

---

## OQA-5 — Bank-switch off-leakage: real silicon

**Gates.** AS-9 (multi-port ZCS) feasibility at fine bank
granularity. NA-3 (negative result) flags that ~100 fA per
switch over ~1000 switches dominates.

**Settle by.** Spice sim using `nfet_06v0` / `pfet_06v0` with
gate at GND, drain at rail; extract I_off across PVT corners.
Cross-check against MDPI Energies 2018 (F2) measured values.

---

## OQA-6 — Pelliconi minimum-V_in for our switch flavour

**Gates.** Whether Pelliconi can serve the ambient-RF rail at
all, vs the survey-default verdict that "below ~1 V it
collapses".

**Settle by.** Spice sim across `nfet_06v0` (V_t ~0.7 V) and
`nfet_03v3` (V_t ~0.5 V) and any zero-Vt or native flavour.
Sweep V_in from 0.2 to 2 V; measure efficiency.

---

## OQA-7 — Effective MIM density when subtracting logo voids

**Gates.** Realistic on-die cap budget. First-principles report
flags 5.05 mm² inter-logo void / layer; the Gambino paper tells
us the dielectric tolerates 12 MV/cm so we have margin.

**Settle by.** GDS post-processing pass: take the logo M4
pattern, erode by 1.2 µm (MIMTM.1), compute remaining area;
multiply by 2.0 fF/µm². Should give an upper bound on
"under-logo MIM" capacitance.

---

## OQA-8 — Yang JSSC 2022 brown-out gate response time

**Gates.** AS-11 viability. If the brown-out detector takes longer
than a NFC modulation half-cycle to detect under-voltage, NFC
demodulation will glitch.

**Settle by.** Read the Yang paper appendix or supplemental
(arXiv 2112.15552) for the BOD bandwidth / latency. If too slow,
need a fast hold cap (small MIM) in parallel.

---

## OQA-9 — Hashimoto leakage-canceller stability

**Gates.** AS-10 viability. The active feedback loop has gain;
need stability margin against PVT drift.

**Settle by.** Consult Hashimoto ICCAD 2001 stability analysis;
re-run for our PDK with corner-aware OTA gain.

---

## OQA-10 — Switching-frequency upper bound on Pelliconi at 180 nm

**Gates.** Continuous-power capability of AS-5. The §5.2 estimate
of ~25 mW at 100 MHz is from the 2003 paper; gate-cap losses at
modern non-thin-oxide 180 nm may cap practical f at 30-50 MHz.

**Settle by.** Spice sim with extracted parasitics; alternatively
cite a more recent 180 nm Pelliconi-style paper (search for
"cross-coupled charge pump 180 nm" with publication year > 2015).

---

## OQA-11 — Is there a peer-reviewed silicon-paper with all-on-die
sub-mW IoT bulk storage?

**Gates.** Stage-2 confidence in the "negative result" NA-1.

**Settle by.** Targeted search in JSSC / TBioCAS / TCAS /
ESSCIRC since 2020 for "fully on-die µF storage <1 mW IoT". My
search did not find one; a Stage-2 reviewer should attempt to
disprove this finding.

---

## OQA-12 — Foundry-roadmap: when will GF180MCU offer high-k MIM?

**Gates.** Whether v3 or later silicon can target denser MIM.

**Settle by.** GF roadmap / direct contact. Out of scope for v2.
