# Open questions — academic angle

These are concrete unanswered questions raised during the
academic-literature survey. Each question lists the downstream
decision that depends on the answer and the kind of
investigation that would settle it.

---

### Q-AS1. Has the GF180MCU eFuse PCell been silicon-qualified
to Tonti-2003-equivalent JEDEC standards?

- **Why it matters:** Tonti 2003 §"Reliability Evaluation"
  shows that the *first* IBM design (E-Fuse A) had 80 %
  time-zero yield and *failed* JESD22-A113 humidity
  preconditioning. The redesigned E-Fuse B passed all three
  major JEDEC stresses (A108 HTOL, A110 HAST, A113
  preconditioning + A104 temperature cycling) with 0 fails on
  150 000-fuse samples. **We do not know which class
  GF180MCU's PCell falls into.**
- **Decision blocked:** Whether the v2 ws-logo-die can rely on
  the PDK eFuse for the chip-ID critical bits, or whether
  Stage 4 must implement 3-fuse-vote redundancy + screen-test
  on critical bits as a hedge.
- **Investigation:** (i) ask GF directly via the open-PDK
  upstream contact (the PDK is open-source — they may have
  released qualification data we haven't found); (ii) Stage-5
  silicon test on a small fuse-array test vehicle to replicate
  Tonti 2003 Table 4.

### Q-AS2. Is the Tonti 2003 25-pulse train the right baseline,
or does GF specify its own programming schedule?

- **Why it matters:** Tonti 2003 Fig 5a shows 25 × 10 µs at
  4.7 V outperforms a single 250 µs pulse for the same total
  energy. The PDK SPICE deck is `pblow=0/1`, no programming
  model. If GF specs a different schedule, our SPICE testbench
  must follow it.
- **Decision blocked:** Programming-control FSM design (number
  of pulse train iterations, gap timing, verify-then-retry).
- **Investigation:** Ask GF; failing that, default to 25 ×
  10 µs at 4.7 V (Tonti 2003 baseline) and verify by Stage-5
  silicon.

### Q-AS3. What's the correct sense-amp topology for our use case?

- **Why it matters:** Single-ended-with-poly-resistor sensing
  (Tonti 2003 BPM) trips a latch at ~2.5 kΩ. Differential-
  paired (Choi 2012) doubles the cell count but improves
  margin by ~10× and removes reference-resistor PVT
  dependence. At 200 bits, the 2× cell-count cost is
  ~10 000 µm² — negligible.
- **Decision blocked:** Bit-cell array layout topology.
- **Investigation:** Stage 4 — paper SPICE-corner runs of
  both topologies under brown-out / harvested-rail noise.

### Q-AS4. Does GF180MCU's gate-oxide TDDB qualification permit
9 V transient on the 3.3 V tox device for ≤ 1 ms?

- **Why it matters:** This is the gating condition for the
  ANTIFUSE-2T / ANTIFUSE-3T topologies. If GF's tox is
  qualified for the 9 V transient (sub-ms), antifuse OTP
  becomes practical *without* charge-pump-pump, simplifying
  the design substantially.
- **Decision blocked:** Whether antifuse is a Stage-4
  candidate or eliminated.
- **Investigation:** Read GF180MCU 3.3 V device qualification
  package (TDDB E-model curves); failing that, derate to
  Lombardo 2005 / Sune 2001 distributions and accept ~10 %
  premature-breakdown risk on adjacent unselected bits.

### Q-AS5. Is 3-fuse-vote sufficient at our bit count, or do we
need ECC?

- **Why it matters:** At 99.97 % time-zero yield (Tonti 2003
  E-Fuse B), 200 bits → 6 % chance of one bit-error per chip.
  3-fuse-vote on critical 32-bit ID = 8.6×10⁻⁷ chip-ID error
  rate. Hamming(15,11) on full 200-bit array adds 36 % area
  overhead but only handles single random fails (not
  correlated programming yield).
- **Decision blocked:** ECC encoder/decoder gate budget.
- **Investigation:** Stage 4 — Monte-Carlo on programming-
  yield distribution under both schemes; compare to academic
  recommendation (Mukhopadhyay 2008 RS for crypto-grade,
  Cha 2011 separate-lock-fuse-bank for FPGA-class).

### Q-AS6. What's the lock-bit policy?

- **Why it matters:** The chip MUST NOT be reprogrammable from
  the PCB by accident (TODO §j R-J6). A "lock fuse" — a
  separate physical fuse that, once blown, gates the
  programming pass-NMOS off-state into ground — is the
  textbook approach. Cha 2011 IEDM puts the lock fuses in a
  *physically separate* sub-array to prevent
  programming-disturb of the lock fuses while the main array
  is being programmed.
- **Decision blocked:** Top-level eFuse macro architecture.
- **Investigation:** Stage 4; baseline is 4 lock fuses
  (3-fuse vote + 1 spare) in a separate sub-array.

### Q-AS7. Does the GF180MCU PCell support back-to-back
programming of adjacent cells without disturb?

- **Why it matters:** Wang 2014 ASICON 3T-cell paper shows the
  motivation for the BT (block transistor) is precisely
  *programming disturb on adjacent unselected bits*. Tonti
  2003 BPM design works one column at a time and does not
  discuss this; Robson 2007 CICC mentions it but doesn't
  quantify.
- **Decision blocked:** Bit-cell layout pitch (potentially
  guard-band rules).
- **Investigation:** Either GF qualification report, or Stage-
  5 silicon adjacent-bit-disturb test.

### Q-AS8. What is the post-program R distribution at the GF
PCell — is it heavy-tailed?

- **Why it matters:** Choi 2007 IRPS 65 nm NiSi shows median
  programmed R = 100 kΩ but 99-percentile > 1 GΩ. Tonti 2008
  reports ≥ 10¹⁰ Ω at test resolution. Sense-amp design must
  tolerate the entire distribution. The PDK's `pblow=1` model
  is binary — no distribution.
- **Decision blocked:** Sense-amp pull-up resistor sizing.
- **Investigation:** Stage 4 SPICE; defaulting to ≥ 100 kΩ
  worst-case programmed R is conservative.

### Q-AS9. What is the test-mode entry strap pattern, and which
existing pads carry programming current?

- **Why it matters:** TODO §j requires programming via probe-
  card (at-test) with no new pads — must repurpose existing
  pads. Programming current of 5 mA × multiple bits could
  exceed the existing power-pad rating during a parallel-
  column program. Tonti 2003 used 15 dedicated bond-pads on
  the BPM; we have to do this on shared pads.
- **Decision blocked:** Pad-mux design and probe-card flow.
- **Investigation:** Stage 4 — propose strap-decode on
  `clk_PAD` + `rst_n_PAD` (4-bit code), serial program
  through `bidir[39:32]` upper bits during test mode.

### Q-AS10. Does the OTP_MK marker layer in the PDK have
electrical models, or is it geometry-only?

- **Why it matters:** Sister industry-survey report identifies
  `OTP_MK` DRC rules but no PCell. If GF has internal SPICE
  models for an antifuse cell that they haven't released
  publicly, the antifuse path becomes drastically less risky.
- **Decision blocked:** Whether ANTIFUSE-2T can be a serious
  Stage-4 candidate.
- **Investigation:** Direct ask of GF / open-PDK upstream.

---

## Priority ranking (for Stage 2 synthesiser)

| # | Question | Blocking | Effort to settle |
|---|---|---|---|
| Q-AS1 | GF JEDEC qualification status | Stage 4 risk acceptance | low (ask GF) |
| Q-AS10 | OTP_MK SPICE model | antifuse path entirely | low (ask GF) |
| Q-AS2 | 25-pulse-train baseline | SPICE testbench | low (default to Tonti 2003) |
| Q-AS3 | Sense-amp topology | bit-cell array | medium (SPICE in Stage 4) |
| Q-AS4 | 9 V TDDB on 3.3 V tox | antifuse path | medium (paper SPICE) |
| Q-AS5 | 3-fuse-vote vs ECC | ECC gate budget | low (Monte-Carlo on yield) |
| Q-AS8 | post-program R distribution | sense-amp sizing | medium (Stage-5 silicon) |
| Q-AS9 | pad-mux test-mode entry | top-level architecture | medium (Stage-3 floorplan) |
| Q-AS6 | lock-bit policy | top-level architecture | low (use Cha 2011 default) |
| Q-AS7 | adjacent-bit programming disturb | layout pitch | medium (Stage-5 silicon) |
