# Research index

Live status of the v2-chip research programme. Updated as agents
return work and reviewers sign off.

> Read [`METHODOLOGY.md`](METHODOLOGY.md) before contributing.
> Use the [`TEMPLATE.md`](TEMPLATE.md) for every report.

## Stage definitions

| Stage | What it produces |
|---|---|
| 1 | Parallel expansive surveys (industry, academic, first-principles) |
| 2 | Gap analysis + synthesis across Stage-1 reports |
| 3 | Shortlist of 3–5 viable options, with elimination reasoning |
| 4 | Deep dive per shortlisted option (one report each) |
| 5 | Hands-on implementation attempts (RTL, schematic, sims) |
| 6 | Comparison of measured / simulated reality vs Stage-4 predictions |

A green check (`✓`) means the stage has at least one signed-off
report. A dash (`—`) means in progress or not yet started.

## Per-item status

Legend: `—` not started, `▶` in flight, `✓` signed-off draft exists,
`!` revisions requested.

| # | Item | Stage 1 ind. | Stage 1 acad. | Stage 1 1st-princ. | Stage 2 synth. | Stage 3 short | Stage 4 deep dive | Stage 5 impl. |
|---|---|---|---|---|---|---|---|---|
| (a) | [Internal oscillator](a-internal-oscillator/README.md) | ! | — | ✓ | — | — | — | — |
| (b) | [NFC energy harvest](b-nfc-harvesting/README.md) | ! | — | ! | — | — | — | — |
| (c) | [Qi power harvest](c-qi-harvesting/README.md) | ! | — | ! | — | — | — | — |
| (d) | [2.4 GHz ambient harvest](d-rf-2g4-harvesting/README.md) | ✗ | — | ✓ | — | — | — | — |
| (e) | [On-die MIM cap storage](e-mim-cap-storage/README.md) | ! | — | ! | — | — | — | — |
| (f) | [LED twinkle drivers](f-led-twinkle-drivers/README.md) | ✗ | — | ✓ | — | — | — | — |
| (g) | [VGA wrapper cleanup](g-vga-wrapper-cleanup/README.md) | ! | — | ✓ | — | — | — | — |
| (h) | [NFC business-card core](h-nfc-business-card-core/README.md) | ✗ | — | ✓ | — | — | — | — |
| (i) | [Power-domain isolation](i-power-domain-isolation/README.md) | ! | — | ✓ | — | — | — | — |
| (j) | [eFuses / OTP](j-efuses-otp/README.md) | ! | — | ! | — | — | — | — |
| (k) | [BLE (aspirational)](k-aspirational-ble/README.md) | ✗ | — | ! | — | — | — | — |

Legend additions: `!` = work returned as agent text but not yet
persisted to the structured 5-file layout; see
[`STATUS.md`](STATUS.md). `✗` = agent hit org monthly usage limit
before producing useful output.

**Stage-1 progress as of 2026-05-03**: org monthly usage limit
reached. 11 first-principles agents launched, 9 returned with
substantive work; 11 industry-survey agents launched, several
returned content but several hit the limit and produced nothing.
Stage 1 academic-survey wave was not launched.

Persistence status:
- **(a) first-principles**: ✓ all 5 files on disk and committed.
- **(g) first-principles**: ✓ all 5 files on disk and committed.
- **(f) first-principles**: ✓ all 5 files on disk and committed.
- **(d) first-principles**: ✓ all 5 files on disk and committed.
- **(h) first-principles**: report.md only on disk and committed;
  components / solutions / open-questions / references pending.
- **(i) first-principles**: report.md only on disk and committed;
  rest pending.
- **(b)/(c)/(e)/(j)/(k) first-principles**: agent text in
  conversation log only, not yet persisted.
- **(a) industry-survey**: solutions.md and references.md persisted;
  report / components / open-questions never produced (usage limit).
- **(c) industry-survey, (g) industry-survey, (i) industry-survey,
  (j) industry-survey, (e) industry-survey**: agent text in
  conversation log only.
- **(b)/(d)/(f)/(h)/(k) industry-survey**: agent hit usage limit
  before producing useful output.
- **references-cache/**: ~80 MB of cached upstream PDFs and
  pdftotext extractions across (a)/(b)/(c)/(d)/(h)/(j) committed.
  Stage-2 reviewers should hash-verify before relying on numerical
  claims.

## Open review queue

(Entries are added by agents that finish a draft; cleared when the
review is closed.)

| Item | Path | Submitted | Reviewer | Verdict |
|---|---|---|---|---|
| _none yet_ | | | | |

## Cross-item dependencies

These dependencies are inherited from the dependency graph in
[`TODO.md`](../../TODO.md) and should also surface as cross-references
between research reports:

- (b), (c), (d), (h), (k) all depend on (e) cap storage being
  understood — bulk-cap area drives them all.
- (b), (c), (d), (k) all depend on (a) — oscillator is shared
  resource, except where each block is self-clocked.
- (h), (k) and post-fab features depend on (j) — eFuse capacity caps
  the configurable payload size.
- (i) is the integrator: it depends on knowing the power and rail
  characteristics of every other block.
- (k) BLE is gated on (a)–(j) shipping; (k) research can proceed in
  parallel but (k) implementation cannot.

## Glossary of acronyms used in this programme

| Acronym | Expansion |
|---|---|
| BLE | Bluetooth Low Energy |
| BPP | Baseline Power Profile (Qi) |
| DCO | Digitally-controlled oscillator |
| DRC | Design rule check |
| EIRP | Equivalent isotropically radiated power |
| FoM | Figure of merit |
| GFSK | Gaussian frequency-shift keying |
| HBM | Human-body model (ESD) |
| IFA | Inverted-F antenna |
| ISM | Industrial / scientific / medical (RF band) |
| LDO | Low-dropout (regulator) |
| LL | Link layer |
| LO | Local oscillator |
| MIM | Metal-insulator-metal (capacitor) |
| MOM | Metal-oxide-metal (capacitor) |
| MOS | Metal-oxide-semiconductor |
| NDEF | NFC Data Exchange Format |
| NTAG | NXP NFC tag IC family |
| OTA | Operational transconductance amplifier |
| OTP | One-time programmable |
| PA | Power amplifier |
| PDK | Process design kit |
| PDN | Power-delivery network |
| PSRR | Power-supply rejection ratio |
| PVT | Process / voltage / temperature |
| TR | Transmit / receive |
| TT | Tiny Tapeout (project) |
| Vth | Transistor threshold voltage |
