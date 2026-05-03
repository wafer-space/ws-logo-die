# Solutions catalogue (item h, Stage 1 first-principles)

Distinct architectural stacks evaluated, presented as canonical
(protocol)+(modulation)+(payload)+(clock)+(AC) tuples.

## S1 — `T1T` minimum (baseline read-only Type-1)

`T1T` + `MOD-OOK-MAN` + `PAY-MASKROM` + `CLK-CARRIER` +
`AC-FIXED-UID` (Type-1 anticollision is RID-based, ~80 gates).

- Performance: 106 kbit/s, 64–256 B payload (Topaz-class limits).
- Used in: Innovision Topaz; very few current commercial deployments.
- Gate count: ~1,400 hand-tight + ~100 B mask-ROM.
- Power: ~0.5 mW peak modulator.
- Strength: smallest-area protocol that still produces a
  NDEF-readable tag.
- Weakness: iOS Core NFC supports T1T NDEF read but the pipeline is
  patchier; phone reader chip support is narrowing year-on-year.
- Eliminate when: anything else fits in similar gates with broader
  phone support — which `T2T` does.

## S2 — `T2T` baseline (recommended)

`T2T` + `MOD-OOK-MAN` + `PAY-MASKROM` + `CLK-CARRIER` +
`AC-FIXED-UID`.

- Performance: 106 kbit/s, 64–924 B payload (NTAG-class). Ours:
  ~125–256 B sufficient.
- Used in: NXP NTAG21x family — enormous deployed base.
- Gate count: ~1,500–2,000 hand-tight, ~3,500–5,000 synthesised +
  ~256 B mask-ROM.
- Power: ~0.5 mW peak modulator with R_mod ≈ 2 kΩ; ~0.2 mW digital
  at 13.56 MHz/16 = 847.5 kHz state-machine clock.
- Strength: broadest phone support (Android API 10+, iOS 11+);
  simplest digital that does the job; mature reference
  implementations.
- Weakness: payload locked at tape-out (single chip per design
  flavour); no per-die personalisation.
- Best for: project default. The candidate to beat in Stage 2.

## S3 — `T2T` personalised

`T2T` + `MOD-OOK-MAN` + `PAY-EFUSE-PARTIAL` + `CLK-CARRIER` +
`AC-EFUSE-UID`.

- Performance: Same as S2 + per-die personalisation.
- Gate count: S2 + ~200 gates eFuse shifter + mux logic. ~1,700–
  2,200 gates.
- Power: Same as S2 + small one-time eFuse program-current at test
  time.
- Strength: every die can carry a different UID and personalisation;
  appealing for "issue one card per attendee" scenarios.
- Weakness: depends on (j) — eFuse capacity, programming
  infrastructure; per-die test cost.
- Best for: if the project wants distinguishable per-die cards.

## S4 — `T2T` field-rewritable, auth-gated

`T2T` + `MOD-OOK-MAN` + `PAY-RAM-RW-AUTH` + `CLK-CARRIER` +
`AC-EFUSE-UID`.

- Performance: S2 + reader can rewrite payload (with password).
- Gate count: ~5,000 gates incl. SRAM-as-flops for 64 B writable
  area + auth machinery.
- Power: S2 levels in read-only mode; +1–2 mW briefly during WRITE
  programming if eFuse-backed write path used.
- Strength: dynamic content (e.g. "URL of the day"); can demo NFC
  writeback during conferences.
- Weakness: ~2.5× the gate cost; security policy must be carefully
  thought through (password recovery? lockout? brick-on-N-failed-
  attempts?); SRAM macro availability uncertain on GF180MCU.
- Best for: demo / "look what NFC can do" purposes, not strictly
  required by the brief.

## S5 — `T4T-A` for large payloads

`T4T-A` + `MOD-OOK-MAN` + `PAY-MASKROM` + `CLK-CARRIER` +
`AC-FIXED-UID`.

- Performance: 106–848 kbit/s, ≥ 1 kB payload practical (CC file
  0xE103 sets size).
- Gate count: ~3,200 hand-tight, ~7,000–9,000 synthesised.
- Power: comparable peak modulator power; digital ~2× S2 due to
  extra layers.
- Strength: room for embedded photo (vCard 4.0 PHOTO field), ISO
  7816-style file structure, banking-app-friendly framing.
- Weakness: ~2× digital area for capabilities not strictly needed
  for "name + email" vCard. Overkill.
- Best for: if the project decides to embed a photo or other large
  media.

## S6 — `T5T` long-range NDEF

`T5T` + `MOD-1OF256` + `PAY-MASKROM` + `CLK-CARRIER-DIV64` +
minimal-`AC`.

- Performance: 1.65 kbit/s (slow!) or 26.48 kbit/s; range up to
  ~10 cm with appropriate antenna.
- Used in: ST25 family, industrial asset tracking.
- Gate count: ~1,400 hand-tight (PPM modulator + CRC-15693).
- Power: sub-mW modulator (slow baud → low duty); compatible with
  weakest harvester margin.
- Strength: lowest power; longest range of any candidate.
- Weakness: patchy iOS support pre-iOS 17 (NfcV NDEF read works,
  raw NfcV access didn't); slow bit rate makes large payloads
  sluggish (240 B at 1.65 kbit/s = 1.4 s read time, noticeable to
  user).
- Best for: if range is a primary value (e.g. "tap the card from
  3 cm away"); de-emphasise if iOS is a primary target audience.

## S7 — `RAW` baseline (floor)

OOK on raw 13.56 MHz, no protocol, no NDEF.

- Performance: unstandardised; no phone reads it.
- Gate count: ~200 gates.
- Strength: shows the area floor; useful as internal calibration
  mode (e.g. "modulator stress test").
- Weakness: does not solve R-h-1.
- Verdict: included for methodology completeness; not a viable
  solution.

## Cross-stack architectural decisions independent of protocol

- **Clocking:** `CLK-CARRIER` for all viable stacks. `CLK-INT`
  eliminated by §7.4 (oscillator drift can't decode 106 kbit/s
  Manchester). `CLK-HYBRID` could put the response-buffer state
  machine on a slow internal clock for power saving but adds
  level-crossing complexity for marginal benefit; deferred to Stage
  4 if relevant.
- **Anticollision:** `AC-FIXED-UID` minimum for any phone-readable
  stack (§7.1). `AC-EFUSE-UID` if per-die uniqueness is needed.
- **Modulator:** R_mod ≈ 2–5 kΩ trades depth vs power. R_mod = 5 kΩ
  is the sweet-spot for our power budget per §5.2.
- **Payload-store split:** mask-ROM template + eFuse personalisation
  is the realistic pattern for any per-die-unique deployment. Pure
  eFuse is only viable if (j) delivers ≥ 256 B.
