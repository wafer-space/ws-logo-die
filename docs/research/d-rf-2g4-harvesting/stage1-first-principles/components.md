# Components — sub-block inventory (item d, Stage 1 first-principles)

## End-to-end harvester sub-blocks

1. **Antenna pad + low-loading ESD** — pad cap ≤200 fF; standard
   `bi_24t` cells have several pF (detunes everything).
2. **On-die matching network** — series L + shunt C, or
   transformer. Q-target 5–8. Area dominated by spiral inductor
   (~150–200 µm/side for 5–10 nH).
3. **Multiplier core** — N-stage per §3.A.
4. **Aux-bias generator** — only with §3.B aux-bias variants.
5. **Storage capacitor** — MIM or MOM, 1–10 nF target. See item
   (e).
6. **Brown-out detector / pulse-shaping** — fires LED only when
   V_storage > ~1.5 V; nA-class quiescent.
7. **Output OR-gate** — diode-OR with NFC and Qi rails. PMOS-OR
   with body diodes.
8. **TR-switch / antenna pin-mux** — must give >50 dB isolation
   in TX mode.
9. **Decoupling and PDN** — protect harvester from chip's own
   digital noise; the harvester is a tuned receiver at 2.45 GHz
   and self-receives our own clock harmonics.

## Block-level area (back-of-envelope)

| Block | Area |
|---|---|
| 5 nH spiral inductor | ~0.0225 mm² |
| 2-turn transformer | ~0.0625 mm² |
| 6-stage cross-coupled rectifier | ~0.01 mm² |
| 1 nF MIM storage | ~0.026 mm² |
| 10 nF MIM storage | ~0.26 mm² (significant) |

## Total area floor

| Configuration | Area |
|---|---|
| Min (Villard, native, 1 nF storage, single L match, no aux-bias) | ~0.06 mm² |
| Typical (cross-coupled-via-transformer, 1 nF storage, aux-bias) | ~0.12 mm² |
| Max (transformer + 10 nF storage + aux-bias + T-switch) | ~0.40 mm² |

The 10 nF storage cap dominates if specified; can be partially
shared with NFC and Qi harvested rails (item (e) bulk-cap planning).

## Cross-references

- Item (e) MIM cap storage — caps for harvester live in shared
  bulk-cap allocation.
- Item (i) power-domain isolation — harvester output OR'd onto
  the harvested rail with Qi/NFC.
- Item (k) BLE — shares antenna pad and matching network;
  informs TR-switch design.
- Item (a) internal oscillator — 25.175 MHz harmonic landing in
  Wi-Fi band is a self-interference concern.
