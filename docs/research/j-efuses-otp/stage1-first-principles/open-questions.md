# Open questions (item j, Stage 1 first-principles)

## Q-J1. Is the NFC vCard payload identical per-tape-out, or per-die?

**Depends on**: OTP array sizing. Difference is ~106 bits vs ~1130
bits, an order-of-magnitude swing.

**Investigation**: Project owner / brand decision. Per-die
personalised vCards mean per-die programming flow must exist; a
single "this is the wafer.space business card" vCard across the
wafer means mask-ROM eliminates the entire NFC-payload OTP cost.

**Recommended default**: per-tape-out vCard via mask-ROM. Per-die
OTP only if/when there's a real product use case.

## Q-J2. Programming flow — wafer-probe, package-ATE, or no programming?

**Depends on**: pad-ring layout, ATE step list, eFuse cell
electrical-test data.

**Recommended default**: TM-EXISTING-PAD at package-ATE.
Programming ~106 bits at one bit per ~250 µs pulse with 16-bit
column mux ≈ 1.7 ms — trivially fast on ATE.

## Q-J3. Has the GF180MCU eFuse been silicon-validated by any prior tape-out?

**Depends on**: programming-yield risk acceptance for v2.

**Investigation**:
- Search Caravel / efabless / OpenFASOC tape-out reports for any
  GF180MCU shuttle exercising the eFuse cell.
- Direct query to GlobalFoundries / open-MCU PDK community.

**Risk if unvalidated**: our v2 is the validation vehicle for the
PDK eFuse. Tonti's 2003 paper is sobering — even his first
attempt (E-Fuse A) failed pre-conditioning despite passing
time-zero. Should include a row of eFuse test structures in
scribe / spare die for characterisation.

## Q-J4. Where does the charge-pump clock come from (for ANTIFUSE-GOX)?

**Depends on**: whether antifuse path is selected.

**Recommended default**: self-clocked charge pump. Eliminates
inter-block dependency.

## Q-J5. ECC strength — none, parity, SEC, or SEC-DED?

**Depends on**: post-precondition fail rate of the GF180MCU eFuse.

**Investigation**: Tonti measured 99.97 % post-precondition yield.
Assuming similar:
- 106 bits × 0.0003 = 0.03 expected fails per array → 3 % chance
  of any fail in any given die. ECC-PARITY catches the easy cases.
- 1130 bits × 0.0003 = 0.34 expected fails per array → ~30 %
  chance of at least one fail. ECC-SEC-HAMMING is essential.

## Q-J6. Brown-out-induced spurious-program credibility?

**Depends on**: harvested-rail brown-out behaviour (item i).

**Investigation**: simulate the brown-out detector's ability to
de-assert `program_enable` faster than a programming pulse can
build up enough current to partial-blow a fuse. Worst case: 5 mA
flowing through a 200 Ω fuse for ≥10 µs is enough to start
partial EM. Brown-out detector must respond in <1 µs.

**Mitigation**: only assert `program_enable` after detecting a
specific multi-bit unlock pattern over multiple cycles, making
accidental assertion vanishingly unlikely.

## Q-J7. Lock-bit policy — single-blow lockout, blow-and-revoke, or none?

**Depends on**: future re-programmability stance.

**Recommended default**: single lock fuse. Always include.

## Q-J8. Should the eFuse array be redundant?

**Depends on**: whether single bit-cell failures must be tolerated
without re-test.

**Recommended default**: ECC-PARITY or SEC, no redundancy. If a
die fails post-program ECC check, scrap.

## Q-J9. Programming-yield-vs-pulse-train: single-pulse or pulse-train?

**Depends on**: programming-FSM complexity vs yield. Tonti reports
that pulse trains (25 × 10 µs at lower V) are more effective at
yielding fuses than single pulses (250 µs at higher V).

**Recommended default**: 25 × 10 µs pulse train at 4.7 V.

## Q-J10. What is the on-die test-circuit overhead for built-in-self-test?

**Depends on**: whether we want to characterise the eFuse in
scribe test structures or in the main die.

**Recommended default**: include a 64-bit eFuse characterisation
BPM in the scribe.
