# (j) eFuses / OTP for post-fab configuration — research home

**Goal (from [`TODO.md`](../../../TODO.md#j-efuses--otp-for-post-fab-configuration)):**
configurable die identity, oscillator trim, and (optionally) NFC
payload after manufacturing.

## Scope of research

1. **What `gf180mcuD` actually offers.** Audit `libs.ref/` for
   eFuse / OTP / antifuse cells. The PDK is open; full specs should
   be readable. Investigate.
2. **Survey of OTP families** —
   - **Poly fuses** — laser-trim or current-blow; large area; well
     understood.
   - **Metal fuses** — small, simple, irreversible; programmability
     constraints.
   - **Antifuse OTP** — gate-oxide breakdown; small, but needs
     elevated voltage.
   - **Floating-gate / flash-like** — multi-time programmable but
     requires special flow not always available in MCU PDKs.
   - **Fuse-cap / capacitor-rupture** — a less common but
     interesting option.
3. **Programming infrastructure.** Charge pump for elevated
   programming voltage if needed; programming-voltage pad vs derive
   from existing 5 V supply; one-shot circuitry to prevent
   accidental re-programming.
4. **Read-margin and ageing.** How does each OTP family's read
   margin degrade over temperature, voltage, and ageing? Cite
   published reliability studies.
5. **Bit budget per consumer.** Oscillator trim (~4–8 bits),
   die ID / serial (~32–64 bits), NFC vCard payload (256–2048 bits if
   programmable), LED pattern selection (~1–4 bits). Total estimate
   sets the OTP array size.
6. **Programming flow.** At wafer-test (probe-card) vs assembled
   chip (test-mode entry on existing pads) vs in-field (NFC-write).
   Each has dramatically different chip-level cost.
7. **Failure modes.** What happens when a programmed bit fails to
   stick, mis-reads, or partially blows? Survey published mitigation
   strategies (ECC, redundant cells, voted reads).
8. **Open-source IP.** Has anyone published an OTP block targeting
   GF180MCU specifically? If yes, study it carefully; if no,
   document what would need to be designed from primitives.

## Status

See [`../INDEX.md`](../INDEX.md).
