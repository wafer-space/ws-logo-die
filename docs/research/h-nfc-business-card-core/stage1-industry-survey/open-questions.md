---
item: h
item_name: nfc-business-card-core
stage: 1
angle: industry-survey
researcher: stage1-industry-survey-1
status: draft
last-updated: 2026-05-03
---

# Open questions — industry-survey angle

Each entry phrased as a concrete question with the downstream decision
that depends on it and a sketch of how it could be settled. Cross-
references with `Q-fp-N` from the first-principles sister report are
called out.

---

## Q-is-1. What does *each* modern Android NFC stack actually need to
expose a tag as `Ndef` (and not just as `NfcA`)?

- **Why it matters:** if a tag completes anticollision but the CC
  bytes are non-conformant, Android exposes only the lower-level
  `NfcA` technology and apps that filter on `android.nfc.tech.Ndef`
  silently ignore the tag. The same goes for `NdefFormatable` vs
  `Ndef`.
- **What we'd verify:** does Android *only* trust `CC0 = 0xE1` and
  `CC1 = 0x10` (NFC Forum magic + version 1.0)? Does it parse the CC2
  size byte and refuse to read past it? Does it require a TLV chain
  ending in `0xFE` (terminator) or merely an NDEF Message TLV at the
  start?
- **How to settle:** read the AOSP source under
  `frameworks/base/core/java/android/nfc/tech/Ndef.java` and
  `system/nfc/src/nfa/dm/nfa_dm_ndef.c`. Cross-check on a Pixel and a
  Samsung phone against a controllable Proxmark3 emulator
  (`[Proxmark3]`) feeding deliberately broken CC bytes.
- **Same question for iOS Core NFC** (`NFCNDEFReaderSession`): the API
  guarantees only NDEF; the library does the CC parsing internally.

## Q-is-2. Does iOS Core NFC honour T2T `READ` (0x30) on every page, or
does it only scan up to the CC-declared size?

- **Why it matters:** size of the user-memory ROM we have to lay down.
  If iOS scans only up to CC2's declared limit, we can put junk past
  it; if it scans the whole memory of the chip type that `GET_VERSION`
  would advertise, we have to fill more bytes (or never respond to
  `GET_VERSION`).
- **How to settle:** read iOS Core NFC release notes; bench-test on
  iPhone 12+ with a Proxmark3 emulator presenting a tag that responds
  to `READ` for arbitrary pages.

## Q-is-3. Will the ChameleonMini / Proxmark3 / Hackaday "Power-Free"
emulator outputs match our pre-silicon RTL bit-for-bit?

- **Why it matters:** if we tape out matching the bit pattern of an
  industry-standard reference, we can declare "interop with at least
  one emulator" before silicon. If they diverge in subtle ways
  (subcarrier-vs-bitclock phase, FDT_PICC timing slop), our chip might
  still pass on phones but fail on niche industrial readers.
- **How to settle:** capture golden waveforms from `[Proxmark3]`'s
  T2T emulator, compare against Verilator/cocotb output of our HDL.
  Cycle-accurate compare on the modulator switch signal.

## Q-is-4. Does the wafer.space manufacturer ID conflict with the IANA-
controlled SN0 byte?

- **Why it matters:** ISO 14443-3 specifies SN0 = manufacturer ID.
  NXP = 0x04, Infineon = 0x05, ST = 0x02, Microchip = 0x07, etc. Using
  one of these IDs is forgery; using an unallocated value (e.g. `0xFE`
  or `0xFF`) is "private use" and should be safe. **What does the NFC
  Forum's manufacturer-ID registry say about wafer.space?**
- **How to settle:** check ISO/IEC JTC 1/SC 17 manufacturer-ID
  register (paywalled but available from secondary sources). Decide
  whether to apply for a wafer.space ID or use a private/test ID for
  the Run 2 silicon and accept "this is not a real production tag" as
  a known caveat.

## Q-is-5. Should the v2 chip implement `GET_VERSION` (0x60) so reader
apps identify it as a known NTAG variant, or NACK it so they fall
back to plain T2T parsing?

- **Why it matters:** Some reader apps refuse tags that respond to
  `GET_VERSION` with anything other than the canonical NXP byte
  pattern (chip type, sub-type, major/minor, storage size, protocol).
  But other apps refuse plain T2T tags that *don't* respond, falling
  back to `Mifare Ultralight` only. There is no winning answer
  without empirical data.
- **How to settle:** survey top 10 NFC tag-reader Android apps + iOS
  shortcut apps. Probe each with a Proxmark3 emulator in
  `GET_VERSION = NACK` and `GET_VERSION = NTAG213-like` modes.

## Q-is-6. Where is *Toshiba TB1106GBG*'s datasheet and is the chip
actually shipping?

- **Why it matters:** the brief specifically calls out TB1106GBG, but
  WebSearch did not find a publicly indexed datasheet. Either the
  chip is end-of-life, the part number is mis-spelled, or it lives
  behind an NDA portal.
- **How to settle:** contact Toshiba directly; check distributor
  catalogs (Digi-Key, Mouser, Future Electronics). If the chip is
  obsolete or NDA-only, drop it from the survey and document the
  result.

## Q-is-7. Is ST AN4910 still a current document and what does it
cover?

- **Why it matters:** the brief specifically lists AN4910. Modern
  ST app notes for the ST25 family appear to use AN5128, AN5119, etc.;
  AN4910 may have been retired.
- **How to settle:** search st.com directly with site filter.

## Q-is-8. What does the NFC Forum's *Type 2 Tag Operation
Specification* (members-only) say about response timing edge cases
that the open Nordic/Adafruit summaries gloss over?

- **Why it matters:** corner cases (inter-frame gap minima, what to
  do when two `READ` commands arrive within FDT_PICC) might bite us
  in field testing.
- **How to settle:** acquire NFC Forum membership for spec access, or
  bench-test against the open-source emulators which have presumably
  already been debugged against real readers.

## Q-is-9. Is there a published silicon implementation of a passive
ISO 14443A T2T tag *that we can cite as a reference for power and area
numbers* (i.e. a primary ISSCC/CICC silicon paper, not just a
firmware-on-MCU emulator)?

- **Why it matters:** to size our gate-count and µW budget against
  measured silicon, not just simulation. The first-principles report
  put the budget at 50–300 µW; we need a primary silicon-paper
  citation to nail this.
- **How to settle:** literature search (deferred to the academic-
  survey angle). Industry survey alone cannot answer this — vendor
  datasheets do not publish core power separately from rectifier+LDO.

## Q-is-10. What is the *measured* on-die capacitance of a 50 pF NFC
tuning cap on a generic 180 nm process?

- **Why it matters:** item (e) is sizing MIM caps, but the NFC tuning
  cap is much larger (50 pF) than the storage caps (1–10 nF
  estimated for digital decoupling). At GF180MCU's MIM density of
  ~1–2 fF/µm², 50 pF needs 25 000–50 000 µm² (5–7 cells of 100 µm
  side). Need to confirm we can fit this under the logo without
  cracking the wafer.space top-metal.
- **How to settle:** check `gf180mcuD` cap density spec sheet
  (item (e) deliverable) and floorplan accordingly.

## Q-is-11. Is "wafer.space business card NFC" allowed to use the NFC
Forum logo / declare itself NFC Forum certified?

- **Why it matters:** marketing question, not technical, but affects
  whether the v2 chip can be sold/distributed as "NFC tag" or only
  as "ISO 14443A compliant device". NFC Forum certification requires
  test-house attestation and a paid licence.
- **How to settle:** ask NFC Forum directly. For the wafer.space demo
  the answer is probably "be ISO 14443A compliant, use phrasing like
  'NFC reader compatible' rather than 'NFC Forum certified', do not
  use the logo".

## Q-is-12. Cross-link with first-principles questions

- `Q-fp-1` (GF180MCU SRAM-macro availability) — irrelevant to industry
  survey; deferred to PDK research.
- `Q-fp-2` (eFuse capacity from item (j)) — depends on (j); industry
  survey cannot answer.
- `Q-fp-3` (rectifier tolerance to modulator-induced shorts) —
  partially answered by `[Hackaday-PowerFreeNFC]`'s 3.5 mA / 11.5 mW
  measurement, which proves the harvester-modulator combo works in
  practice.
- `Q-fp-4` (iOS Core NFC T2T interop gotchas) — same scope as `Q-is-1`,
  `Q-is-2`, `Q-is-5`.
- `Q-fp-9` (PCB antenna L_ant verification) — out of scope for the
  chip-side industry survey; defer to PCB team.
