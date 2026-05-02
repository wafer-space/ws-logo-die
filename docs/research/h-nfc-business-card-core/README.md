# (h) NFC business-card transmission core — research home

**Goal (from [`TODO.md`](../../../TODO.md#h-nfc-core-for-transmitting-business-card-information)):**
make the chip behave as a passive NFC tag that, when polled, returns
an NDEF-formatted vCard to the reader.

## Scope of research

1. **Tag type selection.** ISO 14443A Type 1/2/4, ISO 14443B,
   ISO 15693, NFC Forum Type 5 / NFC-V. Compare protocol complexity,
   phone-side compatibility, payload-size limits, power budget.
2. **Modulation scheme** — load modulation at 847.5 kHz subcarrier
   (HF) using OOK, BPSK, or Manchester / Miller encodings. Trade-offs
   in published silicon.
3. **Anticollision** — how each tag type implements anticollision and
   whether a single-tag-only implementation can omit it. (Some
   readers refuse single-tag-only tags; investigate.)
4. **NDEF mapping for vCard payloads.** vCard 2.1 vs 3.0 vs 4.0;
   payload sizes for realistic business-card content; NDEF Type 2
   memory map; capability container formats.
5. **Open-source reference designs.** Survey RFIDler, libnfc,
   Proxmark3 firmware, NFCpy, T+B Tag IC reference RTL, academic
   open-source NFC tag designs. Distinguish reader implementations
   (less useful) from tag emulators (much more useful).
6. **Power budget.** µW available from the harvester (from item
   (b)) vs published tag-IC power budgets. Where does the budget
   actually go (digital baseband, frame buffer, modulator, leakage)?
7. **Fixed-payload vs programmable.** vCard at tape-out (mask ROM in
   logic synth) vs eFuse-loaded (depends on (j)) vs RAM with reader-
   write capability (much more complex). Default recommendation:
   fixed at tape-out unless a strong case is made.
8. **Self-clocking from carrier vs internal oscillator.** Survey both
   approaches and their power costs.
9. **Phone reader compatibility.** What proportion of Android and iOS
   readers can read a Type 2 tag with vCard NDEF? Cite real
   compatibility-matrix data, not vendor claims.

## Status

See [`../INDEX.md`](../INDEX.md).
