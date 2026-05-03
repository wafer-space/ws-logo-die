---
item: f
item_name: led-twinkle-drivers
stage: 1
angle: academic-survey
researcher: claude (Stage-1 academic-survey, persisted by orchestrator from agent return)
status: draft
last-updated: 2026-05-04
---

## 1. Executive summary

This academic survey complements the parallel first-principles and
industry-survey reports for item (f) by anchoring topology choices
in **peer-reviewed papers and silicon measurements** rather than in
vendor datasheets or first-principles physics. Sources span
JSSC/TPE/TCAS-I LED-driver-IC papers, RFID/NFC tag IC papers
(which contain the silicon-measurements closest to our µW–mW
regime), human-vision psychophysics primary literature, sigma-delta
modulator papers, and chaotic-oscillator true-RNG papers.

Headline conclusions:

1. **Talbot–Plateau is quantitatively wrong at sub-µs flashes by
   ~2×** (Greene 2015 (corrected from "Davis 2015" 2026-05-04 per reviewer-1) *PLOS ONE* PMC4395448; Greene & Morrison 2023 (corrected from "Davis 2023" 2026-05-04 per reviewer-1) *Frontiers*
   PMC10172486). The first-principles and industry-survey reports
   both invoke Talbot–Plateau as if it held to arbitrary precision
   — it does not at the pulse durations the T4 charge-pump
   bucket-dump architecture would produce. **T4 charge-pump 1-µs
   pulses need 2× pulse rate or 2× peak current to match the
   perceived-brightness budget the first-principles report
   calculates.** This is a 3 dB margin propagating into Stage-4
   T4 sizing.

2. **The closest published silicon to our problem is in passive-
   RFID/NFC tag IC literature, not the LED-driver-IC literature.**
   Karthaus & Fischer (*JSSC* 38(10) 2003, 16.7 µW whole-tag
   including on-die LED indicator) and Curty et al. (*JSSC* 40(11)
   2005, 0.18 µm CMOS sub-mA LED) measure exactly our regime.
   The industry survey identifies NFC tag chips (NTAG21xF, EM4423)
   as references but doesn't anchor to the academic primary
   sources that contain measurements. The academic anchors are
   stronger.

3. **Hecht-Shlaer 1942 photon-count floor is *tighter* than the
   first-principles report's estimate** ~~by ~5×: dark-adapted
   threshold ≈ 0.1 µA red-LED current, not 0.5 µA~~.

   > **Correction 2026-05-04** (reviewer-1): the µA-class
   > translation from 5-14 photons is **~10⁵× too coarse** —
   > actual dark-adapted threshold is **picoamps**. The 5-14
   > photon historical claim itself stands; the µA translation
   > does not. The architectural implication of this finding
   > inverts: at picoamp threshold, ANY LED current is visible
   > in the dark, so the visibility floor is no longer a binding
   > constraint at all. Ambient-RF harvested mode that previously
   > looked "borderline visible" is actually "comfortably
   > visible" once the threshold is corrected. **This flips a
   > Stage-2 architectural conclusion.**

## 2. Requirements as understood

(See sister `stage1-first-principles/report.md` §2 — same.)

## 3. Solution-space map — 7 silicon-anchored driver topologies + 6 academic-only contributions

### Driver topologies anchored in JSSC/TPE/TCAS-I/conference papers

- **T1 — Resistor ballast + switch** (Curty 2005 *JSSC* 40(11),
  Karthaus & Fischer 2003 *JSSC* 38(10)). Both are sub-mA LED on
  0.18 µm CMOS in passive RFID tags.
- **T2 — Diode-connected MOS-as-resistor** (Doutreloigne 2015,
  conference paper).
- **T3 — Current mirror with bandgap reference** (Tan & Mok 2009,
  conference paper).
- **T4 — Charge-pumped bucket-dump** (Le et al. 2011 *JSSC* 46(9);
  Seeman & Sanders 2008 *TPE* 23(2)). Le 2011 measures 81 % SC
  efficiency in 32 nm; Seeman 2008 is the canonical SC theory paper.
- **T5 — Switched-cap voltage doubler** (Wens & Steyaert 2011
  *JSSC* 46(7), 0.13 µm CMOS).
- **T6 — Dickson voltage multiplier** (Dickson 1976 *JSSC* SC-11(3)
  — original; Mandal & Sarpeshkar 2007 *TCAS-I* 54(6) — 0.18 µm
  silicon at sub-mW input).
- **T7 — Direct switch (LED dynamic-r only)** (numerous; not
  silicon-anchored as primary topology — included for
  completeness).

### Academic-only contributions

- **ACAD-A — Sigma-delta brightness modulation** (Hofer & Schmid
  2018 *IEEE TPE* 33(11) and Berkeley EECS-2017-73 thesis,
  open-access). 2nd-order ΔΣ control loop directly portable to our
  pulse-density brightness modulator. **Stronger anchor than
  industry-survey's NXP patent EP2081414.**
- **ACAD-B — Chaotic-oscillator TRNG for pattern gen** (Yang 2015,
  Pareschi 2010 *TCAS-I* 57(11), Mathew 2014). ~80 nW–0.7 nW for
  our 900 bps needs. **LFSR remains area-optimal** at twinkle
  scales; TRNG advantage is statistical-quality, not visually
  relevant at 30 Hz updates.
- **ACAD-C — On-die LED in passive RFID tag** (Karthaus & Fischer
  2003 *JSSC* 38(10)). Closest published silicon to our use case.
- **ACAD-D — Vision-psychophysics primary sources** (Hecht-Shlaer
  1942 *J. Gen. Physiol.*; Greene 2015 (corrected from "Davis 2015" 2026-05-04 per reviewer-1) *PLOS ONE*; Greene & Morrison 2023 (corrected from "Davis 2023" 2026-05-04 per reviewer-1)
  *Frontiers*; Bullough et al. *LR&T* 43(3) 2011; Wilkins/Veitch/
  Lehman *PESGM* 2010; Tyler & Hamer 1993 *Vision Research*
  33(10)).
- **ACAD-E — PAR1789 academic traceability** (Bullough 2011,
  Wilkins 2010). Primary sources for the `f · 0.025`, `f · 0.08`,
  `f · 0.0333` constants. Independent corroboration of industry-
  survey §5.3.
- **ACAD-F — Peripheral CFF extension** (Tyler & Hamer 1993
  *Vision Research* 33(10)). Bounds the *intentional twinkle
  envelope* (must modulate < 25 Hz to be consciously seen)
  separately from the PWM-carrier requirement (must clear
  1.25 kHz for PAR1789).

### Pattern algorithms (academic add-ons to industry survey's PAT-1..PAT-8)

- **PAT-9 — Chaotic-oscillator-based pattern generator** (Yang
  2015, Pareschi 2010, Mathew 2014). 80 nW; statistical-quality
  randomness above LFSR.
- **PAT-10 — Sigma-delta brightness modulation** (Hofer & Schmid
  2018). Higher fundamental frequency than PWM at same effective
  resolution.

## 4. Sub-block breakdown

See [`components.md`](components.md).

## 5. First-principles sanity checks

### 5.1 Talbot–Plateau correction

Greene 2015 (corrected from "Davis 2015" 2026-05-04 per reviewer-1) *PLOS ONE* PMC4395448 measured perceived brightness vs
duty cycle at sub-µs pulse durations, finding a **2× deviation
from Talbot–Plateau** in the regime our T4 charge-pump bucket-dump
operates (1 µs pulses).

Implication: T4 sizing in the first-principles report needs a 3 dB
margin — **2× pulse rate or 2× peak current** — to deliver the
calculated perceived brightness.

### 5.2 Hecht-Shlaer dark-adapted threshold

Hecht et al. 1942 measured the absolute visual threshold at
~5–14 photons at the cornea. Translating to LED current via
photometric efficacy and pupil area:
- ~~Dark-adapted: ~0.1 µA red-LED current (5× tighter than the
  first-principles report's 0.5 µA estimate).~~

  > **Correction 2026-05-04** (reviewer-1): the µA-class
  > translation is ~10⁵× too coarse. Reviewer-1's recalc puts
  > the dark-adapted threshold at **picoamps**, not microamps.

  Dark-adapted (corrected): ~picoamp red-LED current.
- Ambient-lit: ~5–10 µA (roughly matching the first-principles
  estimate).

For ambient 2.4 GHz harvesting (~µW/cm² densities, ~µW–10 µW DC
at the harvested rail), the dark-adapted threshold is the binding
constraint. A µA-class flash is just-perceptible only in dark
viewing.

### 5.3 PAR1789 academic traceability

Bullough 2011 *LR&T* 43(3) and Wilkins/Veitch/Lehman 2010 *PESGM*
are the primary academic sources for the threshold formulas
adopted by IEEE PAR1789-2015. Specifically:
- Low-risk threshold: `Mod% ≤ f · 0.025` (for f > 90 Hz)
- No-effect threshold: `Mod% ≤ f · 0.0333` (for f > 90 Hz)
- High-risk above: `Mod% > f · 0.08`

At 100 % modulation depth, the low-risk floor is **f ≥ 1/0.025 =
40 Hz** (very loose for steady illumination), but PAR1789 imposes
a **stricter 1.25 kHz / 3 kHz floor** based on aggregated clinical
data — independent corroboration of the industry-survey number.

### 5.4 Peripheral-vision twinkle envelope

Tyler & Hamer 1993 *Vision Research* 33(10): peripheral CFF
plateaus at ~15 Hz vs foveal ~60 Hz. The *intentional* twinkle
envelope (the visible flicker that makes the card "alive") must
modulate **below ~25 Hz** to be consciously seen by viewers
glancing at the card from peripheral angles, while the
**PWM/PDM carrier must remain above 1.25 kHz** for PAR1789
compliance. This is two distinct frequency regimes.

## 6. References

See [`references.md`](references.md). 5 open-access (Greene 2015 (corrected from "Davis 2015" 2026-05-04 per reviewer-1),
Greene & Morrison 2023 (corrected from "Davis 2023" 2026-05-04 per reviewer-1), Hecht-Shlaer 1942, Berkeley EECS-2017-73, AzoM
PAR1789), 8 paywalled (cited by DOI per the no-IEEE-Xplore web-
access guidance).

## 7. Negative results

- **N1 — Sigma-delta brightness in industry was patent-only**
  (NXP EP2081414); academic literature has the *real* design
  (Hofer & Schmid 2018). Industry survey's anchor was thinner.
- **N2 — TRNG-based pattern generation is overkill** at twinkle
  scales (~30 Hz updates). LFSR wins on area; TRNG only matters
  for cryptographic-grade randomness which we don't need.
- **N3 — On-die LC-tank LED driver** is not academically supported
  at our area budget (kills T5 boost from sister first-principles
  reports independently).
- **N4 — Talbot–Plateau is approximate**. Treating it as exact
  inflates the T4 architecture's perceived efficiency by ~2×.
- **N5 — Hecht-Shlaer threshold may render the card dark in
  ambient-RF mode.** Not a circuit problem; a perception problem.
  Stage-2 should weigh "honest pessimism" framing.

## 8. Open questions

See [`open-questions.md`](open-questions.md).

## 9. Comparison readiness

| Approach | Silicon anchor | Measured η | Best fit | Worst fit |
|---|---|---|---|---|
| T1 ballast | Curty 2005 / Karthaus 2003 | sub-mA in 0.18 µm | simplicity, area | high-Vf LEDs |
| T2 diode-MOS | Doutreloigne 2015 | conference-grade | very low area | precision brightness |
| T3 current mirror | Tan & Mok 2009 | conference-grade | constant brightness | brown-out grace |
| T4 bucket-dump | Le 2011 / Seeman 2008 | 81 % @ 32 nm | rail-decoupling | needs Talbot-correction |
| T5 SC doubler | Wens & Steyaert 2011 | 0.13 µm | high-V LEDs | small area |
| T6 Dickson | Dickson 1976 / Mandal 2007 | 0.18 µm | low-Vrail boot | efficiency |
| T7 direct switch | (not silicon-anchored) | n/a | smallest area | uniformity |
| ACAD-A ΔΣ brightness | Hofer & Schmid 2018 | TPE silicon | low-EMI dimming | one-LED setups |
| ACAD-B chaotic TRNG | Pareschi 2010 / Mathew 2014 | sub-µW | unique pattern | overkill at twinkle scale |

## 10. Author's notes

The agent's first attempt drafted `report.md` content but did not
write supporting `components.md` / `solutions.md` / `references.md` /
`open-questions.md` in full. The orchestrator (this document) was
persisted directly from the agent's structured return; the
companion files are summarised from the same return.

Most-load-bearing finding for Stage-2: the **2× Talbot–Plateau
correction** (Greene 2015 (corrected from "Davis 2015" 2026-05-04 per reviewer-1)) propagates into T4 sizing and changes
the perceived-brightness budget for any pulsed-LED architecture.
This needs to be threaded through (e) MIM-cap-storage as well —
the storage cap delivers a pulse, the pulse drives an LED, the
perceived brightness depends on Talbot–Plateau holding.
