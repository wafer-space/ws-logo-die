# Open questions (item k, Stage 1 first-principles)

## Q1. Is the v2 die large enough to host a BLE-burst storage cap?

§5.7: a single 3-channel advert event needs 4.3 µF (3.3 V → 2.5 V
droop) → 8.6 mm² of MIM at 2 fF/µm². A single-channel single-
packet advert needs 1.5 µF → 3 mm². Total v2 die area is
≤2.25 mm².

- **Blocks:** whether burst-mode BLE TX is architecturally viable
  at all, or whether BLE only works in continuous-power modes.
- **Settle by:** v2 floorplan estimate; co-design with (e). Possibly
  relax droop limit by designing the BLE radio to operate down to
  2.0 V.

## Q2. Can we share the LC-tank inductor between the (k) PA output match and the (d) harvester input match?

Both blocks need a tuned 50 Ω match at 2.4 GHz. An L shared between
them, switched in/out by the TR switch, could halve the on-die L
area.

- **Settle by:** EM co-simulation of single dual-purpose inductor
  with TR switch's parasitic Coff in series.

## Q3. What is the actual harvested-rail power profile from (d) on Run 2 silicon?

First-principles §5.8 says median ambient gives ≈1 µW DC →
1 advert per 11 s. This is the dominant uncertainty in the entire
(k) viability story.

- **Blocks:** whether ambient-RF-only advert mode is in spec at
  all.
- **Settle by:** empirical measurement on Run 2 silicon; (k) is
  explicitly gated on this.

## Q4. Two-point (M1) vs closed-loop (M2) GFSK modulation?

M1 needs ΣΔ + analog summer. M2 needs only loop-BW tuning but is
marginal at 1 Mbps with 300 kHz loop BW.

- **Settle by:** behavioural Spice model; check eye diagram and
  adjacent-channel power.

## Q5. Single antenna pad (TR switch) vs two separate antenna pads?

Per TODO.md L745: budget the bond pad now even if (k) doesn't
ship until v3.

- **Settle by:** parasitic + EM co-sim of single-pad-with-TR-switch
  vs dual-pad.

## Q6. eFuse (j) capacity needed for BLE state?

≈80–120 b. Negligible vs (j)'s likely 256+ b budget.

## Q7. FLL with periodic re-lock vs continuous PLL?

PLL relock burns ≈0.5 µJ each. If we relock 3× per advert event,
that's 1.5 µJ added to the 10 µJ event — non-trivial.

- **Settle by:** phase-noise integration with realistic re-lock
  schedule.

## Q8. Hardcoded vs eFuse-loadable BLE LL?

LL behaviour is fixed by spec, so HDL-hardcode is cheapest. ~3 kgate
for hardcoded advert-only LL.

## Q9. Advert-payload format — iBeacon, Eddystone-URL, manufacturer-data?

Marketing/UX decision. All fit in 31 B AdvData.

## Q10. Charge pump for PA drain rail?

Class E typically needs drain swing ≈3.5×Vdd. From 3.3 V Vdd:
≈11.5 V peak — within nfet_06v0 BVDS but stresses oxide.

- **Settle by:** small-signal ID-VD sweep to verify SOA, then
  transient sim of class-E waveform.

## Q11. Does the TR switch need DC blocking on both ports or just the antenna side?

- **Settle by:** schematic-level review of both blocks.

## Q12. ESD strategy at the antenna pad?

Standard pads have ≈250 fF clamps which are too lossy at 2.4 GHz.

- **Settle by:** survey RF-optimised ESD structures.

## Q13. Is 1-channel-only advert (channel 37 only) acceptable?

1-channel advert costs ⅓ the energy.

- **Settle by:** measured BLE scanner behaviour on common phones.
  **The single most powerful lever for cutting BLE energy demand.**

## Q14. Should (d) ambient harvester continue running between BLE advert events?

Storage cap keeps the BLE rail charged; harvester can keep topping
it up between events.

- **Settle by:** verify harvester rectifier presents acceptable
  off-state load to the antenna while BLE PA is idle.

## Q15. Should we plan for BLE 5 LE 2 Mbps PHY in addition to 1 Mbps?

2 Mbps halves packet duration → halves energy per advert. Same
modulator hardware.
