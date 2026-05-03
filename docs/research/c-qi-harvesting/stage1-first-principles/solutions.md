# Solutions catalogue (item c, Stage 1 first-principles)

## A. Resonance / tuning (one of)

| ID | Name | One-line description | Verdict |
|---|---|---|---|
| A1 | Series-resonant matching | Single C_s on-die in series with coil; Q-step-up V_oc | **REJECTED — R4** (208 nF infeasible on-die) |
| A2 | Off-resonant (untuned) coupling | No on-die series cap; rectifier sees raw V_oc | **DEFAULT — only viable A choice** |
| A3 | Parallel-resonant tank | C_p in parallel with coil | **REJECTED — R4** |
| A4 | Stagger-tuned dual band | L–C network resonates at NFC and Qi bands together | **REJECTED — R4 + geometry** |
| A5 | Distributed self-resonance | Use coil's parasitic C as the tuning element | **REJECTED** — SRF at 28 MHz far above Qi band |
| A6 | Receiver-side detuning as regulation | Switchable C bank intentionally detunes to reflect power | **MERGED INTO C5** |

## B. Rectifier topology (one of)

| ID | Name | Vf typical | Frequency suitability | Notes |
|---|---|---|---|---|
| B1 | Passive PN-junction or diode-connected MOSFET bridge | 0.6–0.7 V | DC to ~MHz | Simplest; good cold-start; 36 mW loss for 30 mA |
| B2 | Native-NMOS diode bridge | 0.1–0.2 V | DC to ~10 MHz | **Unique LF advantage** — 6× efficiency over B1 |
| B3 | Cross-coupled self-driven active rectifier | 0 V (R_on conduction only) | DC to ωT/10 (~5 GHz on this PDK) | Reverse-conduction risk; needs comparator backup |
| B4 | Dickson voltage doubler / multiplier | N×Vf | LF requires huge per-stage caps | **REJECTED at LF** |
| B5 | Hybrid passive + active | Passive cold-start, active steady-state | Universal | Most production-ready |

## C. Post-rectifier regulation (one or more)

| ID | Name | Topology | Notes |
|---|---|---|---|
| C1 | Linear LDO | Series-pass to 3.3 V | Mandatory output stage |
| C2 | Switching buck | High-frequency PWM | **REJECTED — R4** (needs external L) |
| C3 | Active shunt regulator | Bandgap+comparator+shunt FET | **MANDATORY** — hard requirement |
| C4 | Switched-capacitor DC–DC | Charge-pump down-converter | Useful at 1:2 or 1:3 ratio |
| C5 | Receiver detuning regulation | Switch C-bank to reflect power | Cool die; FOD coupling risk |
| C6 | Charge-redirection load steering | Pump excess into LED storage cap | Works in conjunction with C1 |

## D. Protocol participation (one of)

| ID | Name | Compliance level | Energy delivered per 500 ms cycle | Notes |
|---|---|---|---|---|
| D1 | Strict free-rider | None | ≤ 95 mJ (19 % duty) | No load modulation hardware needed |
| D2 | Minimum-compliance ping-responder | SSP only | ≤ 125 mJ (25 % duty) | ASK modulator + ~3 kgates |
| D3 | Full Qi 1.x BPP | Full BPP state machine | Continuous up to ~350 mW (FOD-limited) | ~10 kgates + Q-meter |
| D4 | Full Qi 2.x EPP | Full BPP + ECDSA-P-256 auth + FOD ext. | Continuous up to ~5 W certified | **REJECTED** — out of scope |
| D5 | Qi 2.x MPP (360 kHz) | Different state machine, different freq | n/a | **REJECTED** — coil isn't tuned for 360 kHz |

## Five viable architectural combinations (the §3.6 set)

```
FP-1: A2 + B1 + C3+C1 + D1
   Simplest; PN bridge + Zener stack + LDO; free-rider.

FP-2: A2 + B2(native) + C3+C1 + D1
   Same as FP-1 but native-NMOS bridge; 6× lower conduction loss.
   Best µW–mW free-rider candidate.

FP-3: A2 + B3 + C3+C5 + D1
   Cross-coupled active rectifier with detuning regulation.
   Cool die.

FP-4: A2 + B5 + C3+C1+C6 + D2
   Hybrid bridge with charge-redirect to LEDs.
   Adds SSP modulator → +6 % duty.

FP-5: A2 + B5 + C3+C1+C6 + D3
   Full Qi BPP compliance.
```

## Sharing matrix vs NFC harvester (b)

| Shared component | NFC use | Qi use | Verdict |
|---|---|---|---|
| Bond pads / antenna interface | distinct (different coil) | distinct (different coil) | **separate** |
| Tuning cap | C ≈ 99 pF (feasible) | C ≈ 208 nF (infeasible) | **completely different** |
| Rectifier | B3 (active) mandatory at HF | B1/B2/B3/B5 all viable | **separate** |
| Over-voltage clamp | needed | needed | **could share** |
| Shunt regulator | needed | needed | **could share** |
| LDO | yes | yes | **share** |
| Bulk storage cap | yes | yes | **share** |
| Brown-out detector | yes | yes | **share** |
| Protocol state machine | NFC-specific | Qi-specific | **completely different** |
| Load modulator transistor | NFC modulation (847.5 kHz) | Qi ASK (2 kHz) | **separate** |

Recommendation: wire-OR the rectifier outputs onto a single
regulated rail; share the LDO, brown-out detector, and storage cap;
keep rectifiers, tuning networks, and modulators distinct.
