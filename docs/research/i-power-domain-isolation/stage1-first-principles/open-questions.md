# Open questions (item i, Stage 1 first-principles)

## OQ1. What v2 features actually require cross-domain signalling?

- **Decision gate**: before Stage 4 design freeze.
- **Why it matters**: If the answer is "no cross-signals", S2 is
  sufficient and we save the entire D1 / E1 / E2 design effort.
  If "more than ~5 signals" then S3+ is mandatory.
- **Candidates to investigate** (none confirmed needed):
  - VGA-detected → "monitor active" flag to dim LEDs.
  - Shared on-die oscillator (item (a)) — does VGA need it, or
    does VGA always rely on external clk_PAD?
  - Test-mode signalling.
  - eFuse content broadcast (item (j)).
- **Settle by**: feature-spec review with project owner.

## OQ2. Maximum harvested-rail voltage in worst-case (NFC at 0 mm)

- **Decision gate**: before NFC harvester design (item (b)).
- **Why it matters**: Sets the v1-backwards-compat constraint.
  TODO.md mentions 30 V open-circuit. v1 die's `analog[0/1]` ESD
  path forward-biases above ~5.7 V. If harvested rail can hit 30 V,
  v1 is in trouble.
- **Settle by**: PCB-antenna + rectifier Spice sim with realistic
  reader coupling (k = 0.05–0.5).

## OQ3. Floorplan room for DNWELL guard ring around HARV domain (S5)?

- **Decision gate**: before considering S5 seriously.
- **Why it matters**: 5.42 µm DNWELL different-potential spacing
  plus guard-ring PCOMP eats area. If HARV domain is e.g. 500×500
  µm then guard ring is ~2 % overhead. If HARV is 100×100 µm then
  guard ring is ~10 %.
- **Settle by**: sketch the floorplan after NFC core size is known
  (item (h) Stage 4).

## OQ4. Does LibreLane's multi-voltage-domain flow work end-to-end on GF180MCU?

- **Decision gate**: before Stage 5 implementation.
- **Why it matters**: We're relying on
  `set_voltage_domain ... -secondary_power` in `pdn_cfg.tcl`. The
  v1 chip is single-domain and never exercised this path.
- **Settle by**: smoke test in Stage 4 with a tiny two-domain
  design.

## OQ5. Two `cor` clamp cells in the same IO ring — supported?

- **Decision gate**: before pad-ring construction.
- **Why it matters**: Each of S2–S5 needs a separate `cor` cell per
  domain because `brk5` breaks DVDD/io-VDD continuity. Whether
  LibreLane's pad-ring flow accepts two cor instances is not
  documented.
- **Settle by**: inspect LibreLane padring source; try in Stage 4.

## OQ6. Latch-up risk from NFC modulator driving 847.5 kHz substrate transients

- **Decision gate**: before NFC core (item h) design freeze.
- **Why it matters**: NFC modulator pulls 1–10 mA pulses from
  HARV-domain. Substrate currents during modulation could couple
  into VGA-domain analog or trip the parasitic NPN for latch-up.
- **Settle by**: substrate-aware Spice sim with parasitic
  substrate-resistance network.

## OQ7. PCB-side trace-resistance / parasitic capacitance — passive or not?

- **Decision gate**: before R5 (v1-on-v2-PCB compat) sign-off.
- **Why it matters**: A 100 Ω series resistor in the harvested-rail
  trace would relax the over-voltage constraint on the v1 die's
  ESD, but TODO.md §"Hard cross-cutting constraints" §2 says no
  external passives. PCB trace resistance is implicit but
  inevitable.
- **Settle by**: clarify with project owner whether "no passives"
  includes deliberate PCB-trace-resistance design.

## OQ8. What does the project's "harv_dvdd" pad's bondout look like to a v1 die?

- **Decision gate**: before v2 PCB layout freeze.
- **Why it matters**: If `analog[0]` is the harv_dvdd pad position,
  the v1 die's `analog[0]` is an `asig_5p0` ESD-clamp cell. The PCB
  trace from the rectifier hits this pad on a v1 die and finds a
  diode path to v1's single DVDD/DVSS rail. Whether that's "OK
  because the rectifier output is bounded" or "not OK because
  rectifier can hit 30 V" depends on OQ2.
- **Settle by**: interlock with OQ2 result.

## OQ9. Are the `gf180mcu_ws_io__*` cells fully verified upstream?

- **Decision gate**: before tape-out.
- **Why it matters**: These are wafer.space's local IO variants of
  the GF cells. The CDL/SPICE I read is in the precheck PDK mirror,
  but I haven't compared SHA against the upstream.
- **Settle by**: SHA-check against upstream wafer.space repository.

## OQ10. Is there an ESD-stripped DVDD/DVSS pad cell variant?

- **Decision gate**: before harv-rail rectifier topology pick.
- **Why it matters**: If we want the harv rail to swing below 0 V
  during NFC modulation (to maximise rectifier efficiency), the
  D20 diode in the dvdd cell limits how negative it can go. An
  ESD-stripped variant would relax this. None found in the shipped
  library.
- **Settle by**: confirm absence with wafer.space, or hand-roll one.
