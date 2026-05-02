# TODO — wafer.space business-card chip (v2)

This document captures the planned next-revision feature set for
`ws-logo-die`. The current silicon (Run 1) is a passive die that displays
the wafer.space logo on a VGA monitor when a clock and 5 V supply are
provided through the pad ring. The v2 chip aims to be a self-contained
business card.

> **Status:** planning. Almost every item below needs background research
> *before* it gets a concrete plan. Do not start implementation work
> against this document until the per-item "research" section is closed
> out and converted to a written design plan that has been reviewed.

## Vision — the wire-bonded business card

A printed-circuit-board business card with this die wire-bonded to it,
plus two LEDs and PCB-integrated antennas, behaves like this:

| Stimulus | Behaviour |
|---|---|
| Card placed on a **Qi wireless charger** | LEDs twinkle (Qi-powered) |
| Card brought to a **phone NFC reader** | LEDs twinkle and the phone receives the vCard / business-card NDEF payload (NFC-powered) |
| Card sitting in **dense ambient 2.4 GHz RF** (Wi-Fi / BT) | LEDs twinkle (RF-harvested) |
| Card's **castellated VGA / DVI edge fingers** plugged into a monitor | The wafer.space logo appears on the screen, powered by the display's I/O rail |

Nothing else on the PCB: just the die, the two LEDs, and the antennas
etched into the PCB copper. **No external capacitors, resistors,
inductors, regulators, or other passive components** are permitted —
every passive needed by the design lives on the die.

### Companion PCB

The business-card PCB itself is being designed in parallel under
`/home/tim/github/wafer-space/business-card/`. Current state of that
repo at the time of writing:

- 4-layer ISO 7810 ID-1 card.
- L2 (`In1.Cu`) — **NFC perimeter spiral antenna**, 4 turns, 80 × 50 mm
  centred on the card.
- L3 (`In2.Cu`) — **Qi small coil**, 8 turns, 56 × 40 mm centred on the
  card, plus a **BLE / 2.4 GHz IFA meander** 6 × 10 mm at the right
  edge.
- 12-pin 0.1″ castellated header on the bottom edge that takes the VGA
  signals out to a breakout connector.

The chip side of this design must match those antennas (resonance
tuning, single-ended vs differential feed, pad placement near the
wire-bond shelf) and must be wire-bond-compatible with both the
existing v1 die and any v2 die that adds the harvesting circuits.

The 2.4 GHz IFA on L3 is provisioned for both ambient-RF harvesting
(item (d)) **and** the aspirational BLE subsystem (item (k)) — they
will share the same antenna, with on-die switching / multiplexing if
both are implemented.

## Hard cross-cutting constraints

These are non-negotiable and must be respected by every item below:

1. **Top metal stays a wafer.space logo.** The optically dominant feature
   from above must remain the rocket-and-rings logo (currently
   `big_logo`, drawn across all metal layers). Any new analog or RF
   blocks must place their high-density top-metal usage so the logo
   still reads visually.
2. **No external passives.** All capacitors (storage, decoupling,
   matching, filtering), resistors (current limiters, biases, dividers)
   and inductors (anything that fits on-die — *PCB-loop* inductors are
   the only off-die inductive components allowed) live on the die.
3. **Existing VGA pad positions are frozen.** The bondout for VGA
   (`bidir[39:32]` outputs, `input[4..10]` controls, `clk_PAD`,
   `rst_n_PAD`, the existing `DVDD`/`DVSS` set) **must not move**, so
   that the *currently-fabricated* Run 1 dies can be wire-bonded to the
   v2 PCB and operate in reduced-functionality mode (VGA-only; LEDs,
   NFC and Qi paths inert).
4. **Wire-bonded.** Bond pads only — no flip-chip, no bumping. Pads
   added for new functions (antennas, LEDs, harvested-rail VDD/VSS)
   must fit the standard wafer.space pad ring rules.
5. **Existing chip must still work on the new PCB.** The PCB is the
   long-lived artefact; the v2 chip and the v1 chip must be
   pin-compatible at the bond level for the VGA path.

## High-level dependency graph

```
                  ┌─────────────────────────────────────────┐
                  │  (g) VGA wrapper cleanup (trivial; HDL) │
                  └─────────────────────────────────────────┘

  ┌─────────────────┐   ┌──────────────────┐   ┌──────────────┐
  │ (a) internal osc │  │ (j) eFuses / OTP │   │ (e) MIM caps │
  └────────┬─────────┘  └────────┬─────────┘   └──────┬───────┘
           │                     │                    │
           │   ┌─────────────────┼────────────────────┤
           │   │                 │                    │
           ▼   ▼                 ▼                    ▼
   ┌─────────────────┐  ┌─────────────────┐  ┌────────────────────┐
   │ (b) NFC harvest │  │ (c) Qi harvest  │  │ (d) 2.4 GHz harvest│
   └────────┬────────┘  └────────┬────────┘  └─────────┬──────────┘
            │                    │                     │
            └────────────────────┼─────────────────────┘
                                 ▼
                 ┌────────────────────────────────┐
                 │ (i) power-domain isolation     │
                 │   (VGA rail vs harvested rail) │
                 └─────────────┬──────────────────┘
                               │
                ┌──────────────┼──────────────┐
                ▼                             ▼
   ┌─────────────────────┐       ┌──────────────────────────┐
   │ (f) LED twinkle drv │       │ (h) NFC business-card TX │
   └─────────────────────┘       └──────────────────────────┘
                                              │
                                              ▼
                              ┌────────────────────────────────────┐
                              │ (k) Aspirational: BLE subsystem    │
                              │   shares 2.4 GHz antenna with (d)  │
                              │   only attempted post-(a)..(j)     │
                              └────────────────────────────────────┘
```

Suggested phasing:

- **Phase 0 — Foundations** (HDL-only / minor-area, low risk): (g) VGA
  wrapper cleanup.
- **Phase 1 — Analog primitives** (large research load): (a) oscillator,
  (e) MIM cap planning, (j) eFuse / OTP infrastructure.
- **Phase 2 — Energy harvesting** (RF-heavy research): (b) NFC, (c) Qi,
  (d) 2.4 GHz, sequenced or in parallel depending on team size.
- **Phase 3 — Power architecture**: (i) two-rail isolation, level
  shifters, brown-out behaviour.
- **Phase 4 — User-facing function**: (f) LED twinkle, (h) NFC core.
- **Phase 5 — Integration & sign-off**: full-chip simulation,
  manufacturability, board-level co-simulation with the PCB antennas.
- **Phase 6 — Aspirational, post-(j)**: (k) low-power BLE subsystem.
  Not to be attempted until items (a)–(j) have shipped and the
  harvested-power budget is empirically validated on Run 2 silicon.

---

## (a) Internal oscillator

**Goal:** Replace the externally-supplied chip clock for everything that
isn't the VGA path, so the harvested-power modes don't need a crystal
or any off-die timing reference.

### Research

- [ ] What target frequencies do downstream consumers need?
  - VGA pixel clock: 25.175 MHz (today, supplied externally via
    `clk_PAD`). VGA mode can keep using the external clock from the
    monitor side — does the internal oscillator need to drive VGA at
    all?
  - NFC: 13.56 MHz carrier; ISO14443A tag emulators are *traditionally
    self-clocked from the carrier* — confirm whether on-die timing is
    needed at all in NFC mode.
  - LED twinkle: kHz-range PWM is fine; tolerant of large drift.
  - Qi / 2.4 GHz harvesters: rectification is asynchronous; timing only
    needed for control loops if any.
- [ ] What oscillator topologies are practical in `gf180mcuD`?
  - Ring osc — simplest, drifts ±20 % over PVT.
  - RC relaxation — ±2–5 % achievable with eFuse trim.
  - Crystal-based — **ruled out** (external component).
  - LC tank — inductor area cost prohibitive below ~GHz on this node.
- [ ] What does the GF180MCU PDK already provide? Are there reference
  oscillator IPs in `libs.ref/gf180mcu_fd_ip_*`?
- [ ] Power-supply sensitivity: the harvested rail will be noisy and
  brown-out-prone. What VDD-rejection ratio is required?
- [ ] Start-up time: from rail rising to stable clock — important for
  NFC (NFC tags must respond within ~5 ms of field application).

### Plan (post-research)

- [ ] Pick topology and target frequency.
- [ ] Decide which consumers run off the internal osc vs the external
      `clk_PAD` (likely: VGA → external; everything else → internal).
- [ ] Decide trim mechanism (relies on (j) eFuses if used).

### Execute

- [ ] Schematic + transistor-level layout.
- [ ] Floorplan: place under the logo without conflicting with `big_logo`
      metal usage (see also (e) MIM cap floorplan).

### Verify

- [ ] Spice corner sims (FF, SS, TT × −40 °C / 25 °C / 125 °C × 4.5 V /
      5.0 V / 5.5 V).
- [ ] Monte-Carlo for trim distribution.
- [ ] VDD-noise injection (relevant under harvested power).
- [ ] Lock-in / start-up time vs supply ramp rate.

---

## (b) NFC energy harvesting (13.56 MHz HF, two-pin antenna loop)

**Goal:** Rectify the magnetic field induced in a PCB loop antenna into a
regulated rail capable of running the NFC core (h) and the LED drivers
(f).

### Research

- [ ] Available power budget: at typical 13.56 MHz reader-to-tag
      coupling (k ≈ 0.05–0.2), what DC power can we expect on a small
      business-card-sized PCB loop? (Typical NFC tag IC budget:
      50–300 µW; large PCB loops should hit several mW at close range.)
- [ ] Antenna topology: differential PCB loop with on-die tuning cap to
      resonate at 13.56 MHz. Estimate inductance of a credit-card-sized
      loop (a few µH). Resonating cap = 1 / (ω²L) — sanity check this is
      MIM-cap-feasible (item (e)).
- [ ] Rectifier topology in `gf180mcuD`: full-wave bridge with diode-
      connected NMOS/PMOS, or active synchronous rectifier? GF180 has no
      Schottky — quantify diode-drop loss and decide whether a
      cross-coupled active rectifier is justified.
- [ ] LDO / linear regulator design for ~3.3 V output from rectifier
      output that can swing 3–10 V depending on coupling strength.
- [ ] Over-voltage protection: when held at 0 mm to a strong reader,
      open-circuit antenna voltage can exceed 30 V — design clamps.

### Plan (post-research)

- [ ] Antenna spec (turns, area, trace width) for the PCB team to
      etch — captured in a separate PCB design doc.
- [ ] Resonance cap value, regulator output target, max input Vpk.
- [ ] Decide if NFC rail and Qi rail are wire-OR'd or independent.

### Execute

- [ ] Two new bond pads for the differential antenna feed (placed where
      the existing analog pads sit, since they're currently unused).
- [ ] Schematic + layout of: tuning cap bank, rectifier, clamp, LDO,
      brown-out detector.
- [ ] Floorplan integration with the harvested-rail PDN.

### Verify

- [ ] Spice sim with realistic reader-coil source model across distance
      and angle.
- [ ] PVT corners; assess regulator drop-out behaviour as the field
      weakens.
- [ ] Co-simulate with the NFC core (h) under realistic load
      transients (NFC modulation pulls current at 847.5 kHz subcarrier
      cadence — make sure rectifier+cap sustain it).
- [ ] Antenna co-simulation with the PCB team's loop model.

---

## (c) Qi power harvesting (100–205 kHz LF, two-pin antenna loop)

**Goal:** Rectify the LF magnetic field on a Qi charging pad into the
harvested rail.

### Research

- [ ] Qi BPP (Baseline Power Profile) operates at 100–205 kHz, up to
      5 W deliverable. Receiver coil typically 5–20 µH with a
      resonating cap. Confirm a PCB loop can carry the required
      flux without saturating.
- [ ] Power-control protocol: Qi requires the receiver to talk back via
      load modulation. **Decision needed:** do we implement the
      bidirectional Qi protocol (substantial digital + RF effort) or
      "free-ride" by dumping the received energy into the rail and
      letting the transmitter time out / reduce power? Free-riding is
      common for tiny harvesters and acceptable for our µW–mW
      consumption.
- [ ] Rectifier: full-bridge synchronous rectifier; LF is friendlier
      to switching FETs than 13.56 MHz so this is easier than (b).
- [ ] Coupling vs antenna footprint: the Qi coil is typically large
      (cm-scale) — does it fit on a business-card PCB without
      overlapping the NFC loop? Likely co-located with careful
      isolation.

### Plan

- [ ] Decide Qi protocol participation level (free-ride vs full
      compliance).
- [ ] Coil geometry brief for PCB team (probably stacked / interleaved
      with NFC loop).
- [ ] Resonance cap value, regulator target.

### Execute

- [ ] Bond pads for Qi coil (likely two new pads; or share via a mux
      with NFC if the coils' resonant frequencies are far enough apart
      — *unlikely to be worth the complexity*).
- [ ] Schematic + layout of bridge, regulator, brown-out / over-voltage
      protection.

### Verify

- [ ] Spice sim with Qi transmitter coil model at 5 W class.
- [ ] PVT and load-step corners.
- [ ] Coexistence test: Qi pad active and NFC reader active
      simultaneously — make sure neither input swamps the other.

---

## (d) Ambient 2.4 GHz RF harvesting (single-pin antenna)

**Goal:** Scavenge enough µW from background Wi-Fi / Bluetooth to run
the LED drivers (only) when neither Qi nor NFC is available.

### Research

- [ ] Realistic ambient 2.4 GHz power density: typically 0.1–10 µW/cm²
      indoor, falling off rapidly with distance. Conservatively, a
      business-card-sized antenna delivers single-digit µW DC at best.
      **Reality check:** is "twinkle the LEDs" achievable at this power
      level? Probably only as very brief, dim flashes once the storage
      cap charges up.
- [ ] Antenna topology for a single-pin feed: monopole / patch on the
      PCB with package/substrate as ground reference. Confirm the
      bondwire + on-die return path is acceptable for 2.4 GHz.
      **Note:** the companion PCB already places a 6 × 10 mm IFA
      meander on `In2.Cu` (L3) for this — this same antenna will be
      shared with the aspirational BLE subsystem (item (k)) via on-die
      muxing if both are implemented.
- [ ] RF rectifier design at 2.4 GHz on `gf180mcuD`: 180 nm has fT
      around 50 GHz so transistor speed is fine; the challenge is
      matching and losses. Likely a Dickson voltage multiplier with
      native FETs (or zero-VT devices if available in the PDK).
- [ ] Check: does GF180MCU have a zero-Vth or RF-optimised device
      flavour? `libs.tech` exploration required.

### Plan

- [ ] Antenna spec for PCB team (1-pin, with PCB ground plane as
      counterpoise).
- [ ] Multiplier-stage count, matching network values.

### Execute

- [ ] One new bond pad for the antenna feed.
- [ ] Schematic + layout of matching network (probably an integrated
      meander inductor — review whether on-die L is feasible at
      2.4 GHz; if not, use only on-die capacitance and rely on the
      antenna's own reactance).
- [ ] Storage-cap dump regulator (likely just a charge-pumped diode
      to the harvested rail, OR'd with NFC and Qi).

### Verify

- [ ] EM-co-simulation with PCB antenna.
- [ ] Worst-case "LEDs almost don't twinkle" power sim.
- [ ] Check no spurious emissions at 2.4 GHz from clocks (a) — the
      harvester is also a tuned receiver and could pick up our own
      digital noise.

---

## (e) On-die MIM cap arrays for energy storage

**Goal:** Provide the bulk capacitance that smooths the harvested rails
and sustains brief LED-twinkle / NFC-modulation current pulses.

### Research

- [ ] What MIM cap density does `gf180mcuD` give us? (Look up the
      `*cap*` cells in `libs.ref/gf180mcu_fd_ip_*`. Typical values are
      ~1–2 fF/µm² for stacked MIM, with multiple metal pairs available.)
- [ ] How much storage do we actually need? Energy budget:
  - 2 LEDs × 5 mA × 3 V × 100 ms blink = 3 mJ → 0.66 µF at 3 V if no
    replenishment. **Far too much** at MIM densities.
  - Realistic: harvester replenishes continuously; cap only needs to
    sustain the *peak* of the modulation cycle, probably 1–10 nF for
    NFC subcarrier transients and similar for LED PWM.
  - **Reality check:** the µF-scale "energy storage" framing in the
    feature brief may be optimistic — confirm via per-block load-step
    sims before committing area.
- [ ] Floorplan: where do we put the cap array? Under the logo is
      attractive, but the logo currently uses all metal layers. Audit
      which metal pairs the logo *actually* draws on vs which it leaves
      free for MIM.
- [ ] Alternatives to MIM: poly-poly caps, MOS caps (lower density,
      voltage-dependent — poor for energy storage but OK for
      decoupling).

### Plan

- [ ] Settle on a per-rail capacitance target for each consumer block.
- [ ] Decide per-region cap technology (MIM under logo, MOS-cap fill in
      the core, etc.).
- [ ] Floorplan deltas to `librelane/config.yaml`.

### Execute

- [ ] Lay out cap arrays with proper MIM stacking.
- [ ] Reuse the existing `KLAYOUT_FILLER_OPTIONS: Metal2_ignore_active`
      workaround pattern if MIM dominates Metal2 density.

### Verify

- [ ] Density / DRC checks.
- [ ] Capacitance extraction matches schematic targets.
- [ ] Load-step transient sims confirm cap sustains brown-out-free
      operation through worst-case load events.

---

## (f) LED twinkle drivers

**Goal:** Drive two off-chip LEDs in a visually pleasing "twinkle"
pattern from the harvested rail.

### Research

- [ ] Required LED current at the brightness we want vs the harvested
      power available — see (b)/(c)/(d). Likely 1–10 mA peak with PWM
      duty cycle scaled to available power.
- [ ] Pattern generator: LFSR-based pseudo-random walk, sine-wave
      lookup, Perlin-style noise — pick something cheap that looks
      organic.
- [ ] LED forward voltage: at 3.3 V rail, we have ~1 V of headroom for
      red/green LEDs (Vf ≈ 2.0–2.2 V); blue/white LEDs (Vf ≈ 3.0–3.4 V)
      may not work — choose colour with rail in mind.
- [ ] Brown-out aware: when harvested power is weak, drop LED current
      gracefully rather than glitch the rail.

### Plan

- [ ] Pattern generator algorithm + period.
- [ ] Driver topology (current source vs pulled-up output) and pad
      type (use existing `bi_24t` slow-slew or add dedicated drivers?).
- [ ] eFuse-controlled pattern selection (depends on (j)).

### Execute

- [ ] HDL for pattern generator.
- [ ] Schematic / layout for current-source / driver stage.
- [ ] Allocate 2 bond pads, ideally co-located with the harvested-rail
      power pads.

### Verify

- [ ] Visual review of pattern (rendered in simulation, not hardware).
- [ ] Brown-out behaviour under flickering harvested supply.
- [ ] Integration with (i) — confirm LEDs run only off harvested rail
      and stay dark under VGA-only supply.

---

## (g) Clean up the VGA wrapper

**Goal:** Remove dead inputs from `wrapped_vga` so the wrapper actually
exposes only the bits the screensaver consumes.

### Research

- [x] Already done — see analysis in this branch's discussion: the 7
      inputs decompose into `cfg_tile`, `cfg_solid_color`, two unused
      pass-throughs (`ui_in[2:3]`), and 3 gamepad-PMOD lines
      (latch/clock/data). The two pass-throughs reach the macro but
      `_unused_ok = &{ena, ui_in[7:1], uio_in}` discards them.

### Plan

- [ ] Decide whether to:
      1. Reduce the wrapper to a 5-bit input port and fix the dead
         pads at constants (clean), or
      2. Leave the wrapper unchanged and just document that input[6]
         and input[7] are dead-end pads (zero churn, but doesn't
         actually "clean up" anything).
      Default recommendation: option 1 — small change, more honest
      interface.

### Execute

- [ ] Edit `vga_screensaver/wrapped_vga.v` to take a 5-bit `inputs`
      input.
- [ ] Edit `src/chip_top.sv` to wire only the meaningful pads
      (`input[4]`, `input[5]`, `input[8]`, `input[9]`, `input[10]`) to
      the macro.
- [ ] Update README pinout to count `input[6]` and `input[7]` as
      "bonded but unused" (they'll join the 39 → 41 unused-pad set).

### Verify

- [ ] Cocotb smoke still passes.
- [ ] `make librelane` clean run (the macro's hardened views in
      `vga_screensaver/runs/latest/final/` may need a re-harden if the
      port list changes — check whether the LEF/Lib expose the input
      port width).

---

## (h) NFC core for transmitting business-card information

**Goal:** Make the chip behave as a passive NFC tag that, when polled,
returns an NDEF-formatted vCard to the reader.

### Research

- [ ] NFC Forum tag types: Type 2 (NTAG-class, ISO14443A) is the
      simplest and most widely supported by phones — confirm this is
      the right target.
- [ ] ISO14443A protocol stack: anticollision, framing, CRC-A, NDEF
      Type 2 mapping. Lots of off-the-shelf reference open-source
      implementations to review (e.g. RFIDler / opensky / Proxmark
      simulator code).
- [ ] vCard payload size and on-die storage: a minimal vCard fits in
      < 256 bytes; depends on (j) eFuse capacity.
- [ ] Modulation scheme: load modulation at 847.5 kHz subcarrier; the
      tag pulls current to modulate the field that the reader's coil
      sees. Coordinate with (b)'s rectifier design — the modulator
      shorts the antenna periodically, which the rectifier must
      tolerate.
- [ ] Power budget: typical NFC tag IC budget 50–300 µW. Confirm (b)
      can supply this with margin.
- [ ] Self-clocking from the carrier vs internal oscillator (a).

### Plan

- [ ] Decide tag type and feature set (read-only Type 2 is simplest).
- [ ] Storage architecture (eFuse-backed read-only NDEF page table?).
- [ ] Whether vCard content is fixed at tape-out (mask ROM) or
      programmable post-fab (eFuse).

### Execute

- [ ] HDL for ISO14443A modem and protocol engine.
- [ ] Modulator transistor at the antenna.
- [ ] vCard NDEF payload generation logic.
- [ ] Wire to eFuse content if programmable.

### Verify

- [ ] Cocotb against an open-source ISO14443A reader model.
- [ ] Power-load co-sim with (b).
- [ ] Real reader compatibility matrix (post-silicon — Android, iOS,
      common reader chipsets).
- [ ] NDEF format compliance (validates in standard tools).

---

## (i) Power-domain isolation between VGA and harvested rails

**Goal:** Two independent power islands. The VGA pixel pump is fed only
from the existing `DVDD` pads (driven by the monitor when the card is
plugged in); the LED drivers and NFC core are fed only from the
harvested rail. Either domain can run while the other is off.

### Research

- [ ] How does `gf180mcuD` support multiple supply domains? Look up
      `MAGIC_EXT_UNIQUE: notopports` and existing power-domain handling
      in LibreLane / OpenROAD.
- [ ] Level shifters across the boundary: which PDK cells are
      available?
- [ ] Pad-frame implications: do we need a new ring of `DVDD` /
      `DVSS` pads for the harvested domain, or can we reuse / repurpose
      existing pads (the unused `analog[1:0]` pads come to mind)?
      **Constraint:** existing VGA pad set is frozen — the harvested-
      rail pads must be additions or come from currently-unused pads.
- [ ] Brown-out and rail-sequencing behaviour when only one rail is
      live: the chip must not latch up, leak current backward into the
      dead rail, or stall.
- [ ] Seal-ring crossings: domain boundaries can't cross the seal ring.
- [ ] How does the existing `big_logo` (drawn across all metal layers)
      interact with two PDN rings? Is there a Metal-N layer that's free
      for domain-boundary routing?

### Plan

- [ ] Define the two domains, their supply nets, and which blocks live
      where.
- [ ] Pad-frame floorplan revision (add harvested-rail VDD/VSS pad
      pair, antenna pad pairs, LED output pads — all without disturbing
      existing VGA pads).
- [ ] Level-shifter inventory and placement strategy.

### Execute

- [ ] LibreLane PDN config (multiple `VDD_NETS` / `GND_NETS` entries).
- [ ] Level shifters at every cross-domain signal.
- [ ] Power-pad ring updates in the slot YAMLs.

### Verify

- [ ] LVS clean across both domains.
- [ ] Power-on sequencing sim: each domain ramps independently, in
      both orders, with the other off.
- [ ] Reverse-leakage sim: with one rail dead at 0 V and the other at
      nominal, ensure no significant current flows through level
      shifters.
- [ ] **Backwards-compat acceptance test:** simulate (or — once Run 2
      silicon exists — physically test) that a v1 chip placed on the v2
      PCB still drives VGA correctly when only the VGA rail is live.

---

## (j) eFuses / OTP for post-fab configuration

**Goal:** Configurable die identity, oscillator trim, and NFC payload
post-manufacturing.

### Research

- [ ] What OTP / eFuse cells does `gf180mcuD` provide? Audit
      `libs.ref/gf180mcu_fd_ip_*` and the PDK docs. Some flavours have
      antifuse-style OTP; others have nothing and you'd need to build
      a poly / metal fuse from scratch.
- [ ] Programming voltage: typical eFuses need 5–10 V — design a charge
      pump or use the 5 V `DVDD` rail directly if compatible.
- [ ] Bit count and endurance: how many bits do we actually need?
  - Oscillator trim: 4–8 bits.
  - NFC payload (if programmable): 256–2048 bits depending on vCard
    detail level.
  - LED pattern selection: 1–4 bits.
  - Die ID / serial: 32–64 bits.
- [ ] Programming interface: at-test (probe-card) vs in-field (over
      NFC writer). In-field writes via NFC are *very* expensive in
      design effort — confirm test-time is acceptable.

### Plan

- [ ] Pick OTP technology (PDK cell vs custom).
- [ ] Bit budget per consumer.
- [ ] Programming flow (at-test, via dedicated programming pads or via
      the existing `clk_PAD` / `rst_n_PAD` repurposed in a test mode).

### Execute

- [ ] OTP block (cell or custom) + programming control logic.
- [ ] Test-mode entry (mux on existing pads to avoid adding new ones).
- [ ] Wire eFuse outputs to consumers (oscillator, NFC, LED driver).

### Verify

- [ ] Programming sim across PVT.
- [ ] Read-margin sim across PVT and ageing.
- [ ] Test-mode escape paths (chip must not be programmable from the
      business-card PCB by accident — i.e. no NFC-write path unless
      explicitly designed in).

---

## (k) Aspirational: low-power BLE subsystem

> **⚠ Aspirational — do not start this work until items (a)–(j) have
> shipped on Run 2 silicon and their harvested-power budgets have been
> measured in the real world.** BLE TX is roughly an order of magnitude
> more power-hungry than NFC tag emulation; whether it can run from any
> of (b)/(c)/(d) at all is an open question that depends on actual
> measured harvester output, not just simulation.

**Goal:** A second wireless side-channel for transmitting the
business-card payload — a phone or laptop scanning for BLE
advertisements sees the card's vCard / URL and can open it without
needing the NFC tap gesture.

The PCB-side antenna already exists (`In2.Cu` IFA meander, 6 × 10 mm
at the card's right edge), so this is a chip-side-only work item.

### Research

- [ ] Realistic BLE TX power budget vs harvested supply: a typical
      BLE-only TX advertising packet costs ~1–10 mW peak for
      ~100–500 µs bursts. Even at 1 % duty cycle (one advert per
      ~100 ms) that's tens of µW average, which is right at the edge
      of what (b)/(c) can deliver and probably beyond (d). Storing
      energy in (e) caps to support burst-mode TX is the architectural
      key.
- [ ] BLE 5.x advertising-only PHY (TX-only, never enters connected
      mode) — the simplest viable feature set. No RX = no LNA, no
      anti-collision, no link-layer state. Consider also Bluetooth
      Mesh "advertising bearer" as a target.
- [ ] PA topology at 2.4 GHz on `gf180mcuD`: 180 nm RF is challenging
      but feasible — survey published reference designs (open-source
      and academic) for ~0 dBm PA in this node.
- [ ] Frequency synthesis: needs a 2.4 GHz LO. Options:
      - Integer-N PLL referenced to (a) — area-heavy, sensitive to
        oscillator phase noise.
      - Fractional-N — better, more complex.
      - Free-running ring osc + frequency-locked loop on a known
        reference — non-standard but possible at the precision BLE
        adverts tolerate.
- [ ] Antenna sharing with (d): TR switch or hard-mux selecting between
      "harvester input" and "BLE PA output" modes — tag is never doing
      both at the same instant.
- [ ] Crypto / privacy: BLE 5 supports privacy via random resolvable
      addresses; for a static "scannable card" we may not need this,
      but consider it for users who don't want to be passively tracked.
- [ ] Regulatory: 2.4 GHz ISM is licence-free up to certain EIRPs but
      requires conducted-emission cleanliness and respect for the
      power-spectral-density limits — this is a non-trivial design
      constraint on the PA and matching network.

### Plan

- [ ] Decide TX-only vs minimal-RX (RX would let the card respond to
      scan requests with a vCard payload — much friendlier for end
      users than connectionless adverts only).
- [ ] Decide whether the BLE LL is hard-coded mask-ROM, eFuse-loaded
      from (j), or both.
- [ ] Antenna-sharing arbitration policy with (d).

### Execute

- [ ] HDL for BLE link-layer state machine (advertising flavour at
      minimum).
- [ ] Modulator (GFSK at 1 Mbps, optionally 2 Mbps PHY).
- [ ] PLL / synthesiser, PA, T/R switch.
- [ ] Power-management hooks into the harvested rail's brown-out
      detector — the chip must defer TX bursts when the rail is too
      weak.

### Verify

- [ ] PA linearity / spectral mask sims at process corners.
- [ ] PLL phase-noise / frequency-error vs BLE spec.
- [ ] Antenna co-sim with the PCB IFA, including dual-use (harvester
      vs PA mode).
- [ ] Real-device interop matrix (post-silicon — Android, iOS, common
      desktop BLE adapters).
- [ ] Regulatory pre-compliance measurements before any field trial.

---

## Cross-cutting risks and open questions

These belong in their own brainstorming sessions before the per-item
plans are finalised:

1. **Is the µW power budget for ambient 2.4 GHz harvesting actually
   sufficient to twinkle even one LED visibly?** May need to scope down
   the ambient-RF mode to "occasional dim flash when energy is high
   enough" rather than "twinkles continuously".
2. **Can three antenna systems (NFC at 13.56 MHz, Qi at 100–205 kHz,
   2.4 GHz patch) coexist on a business-card-sized PCB without
   detuning each other?** This is fundamentally a PCB / antenna
   co-design problem; the chip side is comparatively easy.
3. **What's the realistic on-die capacitance ceiling once the logo and
   PDN have taken their share?** Drives whether energy storage on (e)
   is sufficient.
4. **Do we want post-fab NFC content programming?** That's the biggest
   single design-effort multiplier in this list. If a fixed-per-tape-
   out vCard payload is acceptable, item (j)'s scope shrinks
   dramatically.
5. **Is a v2 *full* tape-out the goal, or a "demo board" test chip with
   a subset of the harvesting paths first?** A staged approach (e.g.
   "Run 2 = NFC + LEDs only; Run 3 = add Qi + 2.4 GHz; Run 4 = add
   BLE") would substantially de-risk the overall programme. The BLE
   subsystem (k) is explicitly gated on real-world measurements from
   the earlier runs.
6. **Antenna sharing between the 2.4 GHz harvester (d) and the BLE
   subsystem (k):** the PCB places one IFA meander on `In2.Cu`. If
   (k) is ever implemented, the chip needs an on-die T/R switch and
   policy for who gets the antenna at any given instant. Worth at
   least *budgeting* the bond pad and pin-mux logic for this in the
   v2 floorplan even if (k) doesn't ship until v3 / v4 — adding it
   later is far cheaper than retrofitting a single-purpose pad.

## Backwards-compatibility acceptance criteria

Before the v2 chip can be considered ready, this end-to-end test must
pass:

- [ ] A *v1* die is wire-bonded to a v2 business-card PCB.
- [ ] The card is plugged into a VGA monitor via the castellated
      fingers.
- [ ] The wafer.space logo screensaver appears on the monitor with no
      observable difference vs the existing v1 demo board.
- [ ] All other paths (Qi pad, NFC reader, ambient RF) are silent —
      the v1 chip simply doesn't have those circuits, and the PCB-
      antenna ports on the v1 die are bonded to currently-unused pads
      so nothing is damaged.

This is what locks the existing VGA pad positions in place and forbids
moving them in the v2 floorplan.
