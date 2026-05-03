# Open questions (item h, Stage 1 first-principles)

## Q1. Does GF180MCU offer a standard-cell SRAM macro suitable for `PAY-RAM-RW`?

- *Decision:* whether `S4` (field-rewritable) is feasible at ~1.5×
  gate-cost or balloons to ~2.5×.
- *Settle:* audit `libs.ref/gf180mcu_fd_ip_*` for SRAM macros at
  the chosen rail voltage. Fallback: stdcell flop array at 5 NAND-
  eq/bit.
- *Cost:* ~30 minutes of PDK browsing.

## Q2. What is the actual eFuse capacity in item (j)?

- *Decision:* whether `PAY-EFUSE` (full payload in eFuse) or
  `PAY-EFUSE-PARTIAL` (only personalisation in eFuse) is viable.
- *Settle:* await item (j) Stage-1 outputs; cross-check whether
  GF180MCU has a custom OTP cell library.
- *Cost:* dependent on (j) research timeline.

## Q3. How does the (b) rectifier tolerate antenna shorts during modulation?

- *Decision:* whether the modulator must be in series with a
  damping resistor (limits short current, costs voltage) or can
  shunt the antenna directly.
- *Settle:* SPICE co-simulation of (b)'s rectifier + (h)'s
  modulator at 13.56 MHz with realistic phone-reader source coil.
- *Cost:* 1–2 days of analog co-sim.

## Q4. Is iOS Core NFC NDEF-read fully compatible with `T2T` at typical tap distance?

- *Decision:* if iOS has a hidden gotcha (e.g. requires a specific
  ATQA value or rejects 4-byte UIDs on certain models).
- *Settle:* survey Apple developer documentation; brief Empirical
  Stage 4 test with an iPhone XR / 12 / 14 against an emulated
  `T2T` reference (e.g. NTAG215 sticker).
- *Cost:* ~half-day post-Stage-3.

## Q5. Should the card hold a photo?

- *Decision:* drives `T2T` vs `T4T` choice; affects whether photo
  can ever be personalised post-fab.
- *Settle:* product-design / aesthetics decision by project owner.

## Q6. UID assignment policy: factory-blank or eFuse-personalised per die?

- *Decision:* drives `AC-FIXED-UID` vs `AC-EFUSE-UID`.
- *Settle:* product policy + cost-benefit (eFuse programming adds
  wafer-test time per die).

## Q7. Do we need anticollision past a single SELECT cascade?

- *Decision:* 4-byte UID (one cascade, ~120 gates) vs 7-byte UID
  (two cascades, ~190 gates).
- *Settle:* check NFC Forum spec on UID format requirements;
  survey whether Android requires 7-byte UIDs for `Ndef`
  enumeration.

## Q8. What happens if both VGA `clk_PAD` and the NFC field are present?

- *Decision:* defines whether (h) must coordinate with the VGA
  path or can ignore it via (i)'s isolation.
- *Settle:* (i) handles isolation but the cross-domain reset / wake
  handshake must be specified. Stage-2 cross-cut.

## Q9. Is the PCB antenna inductance estimate (L_ant ≈ 2.5 µH) realistic?

- *Decision:* drives MIM tuning cap value; affects R_mod sizing.
- *Settle:* EM simulation of the PCB antenna stack-up; compare
  against analytic Wheeler/Mohan formulas.
- *Cost:* ~1 day of PCB EM-sim.

## Q10. Can the modulator also serve as the over-voltage clamp?

- *Decision:* dual-purpose modulator+clamp saves area but couples
  failure modes.
- *Settle:* SPICE study of integrated modulator-clamp transistor
  sizing across PVT; investigate whether commercial tag ICs do this.

## Q11. What is the tag's response policy when the carrier amplitude is ambiguous?

- *Decision:* affects field-detect hysteresis design and the
  brown-out threshold.

## Q12. Is `T5T` worth keeping in the shortlist if iOS is a primary user-target?

- *Decision:* drives whether Stage-3 carries `S6` forward.
- *Settle:* check iOS 13–17 Core NFC release notes for NfcV /
  NDEF Type 5 read support evolution.
