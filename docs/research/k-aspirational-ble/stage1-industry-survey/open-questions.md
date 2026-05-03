# Open questions — industry-survey angle

These are concrete, decision-relevant questions left unresolved by the
industry-survey angle. Each notes the downstream decision blocked by
the answer and a guess at how to resolve it.

---

## Q1. Is there *any* published BLE-spec compliant transmitter in 180 nm bulk CMOS?

**Why it matters.** All ULV ADPLL/PLL BLE TX papers I found are
28 / 40 / 65 nm (Liu 2017, Sano 2018, Vidojkovic 2014, Kuo 2019).
Class-E PA papers exist in 180 nm but they target +20 dBm WLAN /
BT-Classic, not 0 dBm BLE. **Without a 180 nm BLE silicon datapoint
we are extrapolating across a process generation.**

**Decision blocked.** Synth power budget assumption (FP §5.1 estimates
4 mW; without 180 nm reference we can't tighten this).

**How to resolve.** The academic-survey sister angle should explicitly
hunt JSSC 2005–2015 archives for "BLE in 180 nm". If none exists,
flag this as a *novelty risk*: we may be designing a subsystem the
literature doesn't have a direct precedent for.

---

## Q2. What is the ATM33's exact supply rail for the 2.1 mA TX figure?

**Why it matters.** The Atmosic datapoint (2.1 mA TX) is the
industry's most relevant low-power BLE radio number. If it's quoted
at 1.1 V (their ULV core rail), the *power* is only 2.3 mW — far
below mainstream silicon. If it's at 3 V it's 6.3 mW, close to
mainstream.

**Decision blocked.** Whether ULV-supply techniques (charge-pump
down-conversion to ~ 1 V) are mandatory for 180 nm harvested-power
BLE.

**How to resolve.** Buy the Atmosic ATM33 datasheet (gated behind
NDA on their site as of 2026-05) or extract from FCC test reports
(FCC ID lookup).

---

## Q3. Is a fully crystal-less BLE TX feasible without a cooperative co-channel transmitter?

**Why it matters.** The Wentzloff 2020 crystal-less BLE TX recovers
its 32 MHz reference from a *co-channel* GFSK-modulated BLE packet
emitted by a cooperative transmitter in the environment. Pure
crystal-less BLE TX with no external reference at all relies on
internal RC oscillator + eFuse trim, with ±1000 ppm ageing risk.

**Decision blocked.** Whether item (a) (internal oscillator) can
serve as the BLE reference, or whether we need a small XO bond pad
on the v2 PCB.

**How to resolve.** Spice simulation of the proposed item (a)
oscillator over PVT vs the BLE 1 Mbps GFSK frequency tolerance
(±50 ppm initial, ±50 kHz drift). If the (a) RC + eFuse trim cannot
hit ±50 ppm reliably, we need an XO — which conflicts with the
no-passives constraint.

---

## Q4. What is the *minimum* harvested-rail input power that lets an Atmosic ATM3 successfully send one BLE advert?

**Why it matters.** This is the empirical answer to "is harvested-RF
BLE feasible". Atmosic markets it as feasible *with* a 1 W
WattUp transmitter, but doesn't publish the *threshold* power.

**Decision blocked.** Whether we should design (k) at all, or fold
its budget into more LEDs / a bigger NFC payload.

**How to resolve.** Buy a Wirelessly Powered Sensor Evaluation Kit
(Energous + Atmosic, ≈ $200) and measure the harvest-power threshold
with an attenuator chain on the WattUp output. **This is the single
most useful empirical measurement to do before committing to
(k) for v3 silicon.**

---

## Q5. Does the Apache NimBLE link-layer C code map cleanly to synthesisable HDL?

**Why it matters.** If the LL state machine is small enough
(< 5 kgates) it can be implemented as direct HDL. If it requires
a small CPU to run the C, we need either a soft-MCU on-die or to
re-write the LL as HDL.

**Decision blocked.** Digital area budget for (k); whether we can
piggy-back on an existing item (a)/(j) digital block.

**How to resolve.** Read NimBLE `controller/src/ble_ll_adv.c` and
related advertising-only code (skip the connection state machine
entirely). Estimate cycles/instructions and HDL state count.

---

## Q6. Do Eddystone-URL adverts still work in late-2025 / early-2026 phones?

**Why it matters.** The Eddystone-URL "Physical Web" auto-prompt
was sunset by Chrome in 2018. The format is still scannable but
no longer triggers a notification on Android. iOS never natively
recognised Eddystone-URL.

**Decision blocked.** Whether B3 (Eddystone-URL) is the right
default for the wafer.space card, or whether we need iBeacon (B1)
plus an Apple-side app, or AltBeacon (B5) plus an Android-side
app.

**How to resolve.** Test current phone behaviour with a USB BLE
dongle + an iPhone + an Android phone. Verify what *generic*
behaviour each platform exposes for each beacon type.

---

## Q7. What MIM-cap density does `gf180mcuD` actually deliver in the released PDK?

**Why it matters.** First-principles report assumed 2 fF/µm². If
density is lower (e.g. only metal-3 / metal-4 MIM at 1 fF/µm²),
the storage-cap wall is twice as bad; if it's higher (newer cap
modules in the C-flavour PDK at 4 fF/µm²), 2× better.

**Decision blocked.** Storage-cap area budget — and whether the
storage-cap-wall finding can be circumvented.

**How to resolve.** Coordinate with item (e) MIM cap research; this
is *their* primary open question. Industry survey can offer no
information here beyond "GF180MCU PDK release notes". Follow-up
needed in (e) docs.

---

## Q8. Can a Class-E differential PA's on-chip RF transformer co-exist with the wafer.space top-metal logo?

**Why it matters.** Best-published Class-E in 180 nm uses an on-chip
1:1 RF transformer in Metal4–Metal5 spirals (Talbi/Ramos 2014).
TODO.md L60 reserves top-metal for the logo. Metal4-only transformer
has lower Q.

**Decision blocked.** PA topology choice (single-ended A7 vs
differential A8 with transformer).

**How to resolve.** Metal-stack audit of the existing logo to find
which Metal4 areas are unused; EM-sim a spiral pair on Metal4 only.

---

## Q9. Is a "bursty BLE-from-Qi" design viable without a µF-class storage cap?

**Why it matters.** Qi rail (item (c)) can sustain ~ mW continuous;
BLE bursts need ~ 10 µJ = 10 ms × 1 mW = 100 ms × 0.1 mW. So if Qi
sustains 1 mW continuously, *no storage cap is strictly required*
provided BLE bursts space themselves to match instantaneous
harvested power and there's no inrush spike.

**Decision blocked.** Whether the storage-cap wall is fatal or
manageable. If we relax burst-duration / inrush tolerance, the
storage cap can shrink dramatically.

**How to resolve.** Co-simulate (c) Qi rectifier + (k) PA load step;
measure rail droop during a BLE burst. If droop < 10 % the
storage-cap wall doesn't apply *for Qi-fed operation*.

---

## Q10. Do we want full BLE-Mesh advertising-bearer compatibility (B7) for any side-channel sensor / status reporting?

**Why it matters.** BLE Mesh adds another deployment / use-case
vector but its frame format isn't natively scannable as "vCard".

**Decision blocked.** Frame-format selection.

**How to resolve.** Defer to product-side decision; not a chip-side
question.

---

## Q11. What is the shortest in-the-field-measured time-on-air for a 3-channel ADV_NONCONN_IND advert event from any commercial BLE chip?

**Why it matters.** Our energy-per-event budget assumes 1.5 ms
on-air. If commercial chips do it in 0.6 ms (single-channel) or
3 ms (with PLL settling), our energy budget is off by 2×.

**Decision blocked.** Storage-cap sizing and harvested-rail load
profile.

**How to resolve.** Read Nordic / Atmosic application notes for
"advertising current profile"; one of them quotes per-channel
PLL warm-up + TX active times.

---

## Q12. Is there any open-source BLE PHY (modulator + GFSK shaper + radio control) RTL anywhere?

**Why it matters.** All open BLE stacks abstract over a closed PHY.
If a research group has open-sourced an RTL PHY for skywater /
gf180mcu, our work shrinks dramatically.

**Decision blocked.** Effort estimate for (k) HDL development.

**How to resolve.** Search OpenROAD / OpenLane benchmark designs;
search efabless "MPW" project archive for any BLE RTL submissions.
Search Github topic `:bluetooth-low-energy` + `verilog`.
