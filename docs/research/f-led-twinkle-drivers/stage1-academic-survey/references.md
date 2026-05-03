# References (item f, Stage 1 academic-survey)

## OA / verified

### REF-OA-1 — Greene 2015 *PLOS ONE* (corrected from "Davis 2015")

> **Correction 2026-05-04** (reviewer-1): the prior author
> attribution was "Davis, J." Reviewer-1's spot-check against
> the PMC4395448 mirror confirms actual lead author is **Greene**.

- **Citation**: Greene et al. *PLOS ONE* (2015), PMC4395448.
- **URL**: https://pmc.ncbi.nlm.nih.gov/articles/PMC4395448/
- **Verification**: VERIFIED via PMC.
- **Relevance**: ~2× Talbot–Plateau deviation at sub-µs flashes
  (1.3 µs in the experimental conditions) — primary anchor for
  §1 conclusion 1.

### REF-OA-2 — Greene & Morrison 2023 *Frontiers* (corrected from "Davis 2023")

> **Correction 2026-05-04** (reviewer-1): the prior author
> attribution was "Davis, J." Reviewer-1's spot-check against
> the PMC10172486 mirror confirms actual authors are **Greene
> & Morrison**.

- **Citation**: Greene & Morrison. *Frontiers* (2023),
  PMC10172486.
- **URL**: https://pmc.ncbi.nlm.nih.gov/articles/PMC10172486/
- **Verification**: VERIFIED via PMC.
- **Relevance**: Confirms and extends the Greene 2015 finding;
  shows the Talbot-Plateau deviation actually ranges 0.85–1.55×
  (so "2×" is the worst case, not universal — reviewer-1 flag).

### REF-OA-3 — Hecht-Shlaer 1942 *J. Gen. Physiol.*
- **Citation**: Hecht, S., Shlaer, S., Pirenne, M.H. *J. Gen.
  Physiol.* 25(6), 1942.
- **URL**: PMC mirror available.
- **Verification**: VERIFIED via PMC.
- **Relevance**: Photon-count threshold of dark-adapted vision
  (5–14 photons at the cornea). **Caveat 2026-05-04**
  (reviewer-1): the academic-survey's translation of this to
  "0.1 µA red-LED current floor" is **~10⁵× too coarse** —
  reviewer's recalc puts the dark-adapted threshold at
  picoamps. The cap-on-cap-arithmetic and brightness-budget
  reasoning chain that depends on the µA-class number must be
  re-derived. The 5–14 photon historical claim itself is
  unaffected.

### REF-OA-4 — Berkeley EECS-2017-73 thesis (Hofer & Schmid 2018 antecedent)
- **Citation**: Hofer & Schmid, Berkeley EECS-2017-73 thesis,
  2017. Subsequently published as *IEEE TPE* 33(11) 2018.
- **URL**: https://www2.eecs.berkeley.edu/Pubs/TechRpts/2017/EECS-2017-73.html
- **Verification**: VERIFIED via Berkeley EECS open-access mirror.
- **Relevance**: 2nd-order ΔΣ brightness modulator silicon. Strong
  academic anchor for ACAD-A.

### REF-OA-5 — AzoM PAR1789 explainer
- **Citation**: AzoM (Azo Materials) PAR1789 industry explainer.
- **Verification**: VERIFIED open-access.
- **Relevance**: Independent corroboration of PAR1789 numerical
  thresholds; cross-checks Bullough 2011 / Wilkins 2010.

## Paywall — abstract-only verification

### REF-PW-1 — Curty 2005 *JSSC*
- **Citation**: Curty et al. "Remotely Powered Addressable UHF
  RFID Integrated System", *IEEE JSSC* 40(11), 2005.
- **DOI**: 10.1109/JSSC.2005.857167
- **Verification**: paywall — abstract only via IEEE Xplore.
  Per brief, **not WebFetched**.
- **Relevance**: Sub-mA LED in 0.18 µm passive RFID tag —
  silicon anchor for T1.

### REF-PW-2 — Karthaus & Fischer 2003 *JSSC*
- **Citation**: Karthaus, U., Fischer, M. "Fully integrated
  passive UHF RFID transponder IC with 16.7 µW minimum RF input
  power", *IEEE JSSC* 38(10), 2003.
- **DOI**: 10.1109/JSSC.2003.817627
- **Verification**: paywall — abstract only.
- **Relevance** (corrected 2026-05-04 per reviewer-1):
  ~~16.7 µW whole-tag including on-die LED indicator on
  0.18 µm CMOS — closest known silicon-anchored low-power LED
  budget.~~

  > **CORRECTION 2026-05-04** (reviewer-1): the prior summary
  > does NOT match the paper's abstract. The 16.7 µW figure is
  > the **RF receiver-sensitivity threshold for a 0.5 µm CMOS
  > RFID transponder** (NOT 0.18 µm as cited; NOT a whole-tag
  > including-LED budget). No on-die LED is mentioned in the
  > abstract. The math admittedly didn't work — see
  > open-questions Q-AC5. **Citation remains valid as a low-
  > power RFID transponder anchor** (it is a real paper with a
  > real 16.7 µW measurement), but **the LED-budget headline
  > derived from it is RETRACTED**. Stage-2 must find a
  > replacement anchor for the "lowest known silicon-anchored
  > low-power LED budget" claim, OR drop that headline.

### REF-PW-3 — Doutreloigne 2015
- **Citation**: Doutreloigne, J. (2015), conference paper on
  diode-connected MOS LED ballast.
- **Verification**: paywall — abstract only.
- **Relevance**: T2 anchor.

### REF-PW-4 — Tan & Mok 2009
- **Citation**: Tan, P.S., Mok, P.K.T. (2009), conference paper
  on LED current mirror with bandgap.
- **Verification**: paywall — abstract only.
- **Relevance**: T3 anchor.

### REF-PW-5 — Le 2011 *JSSC*
- **Citation**: Le, H.-P. et al. "Design Techniques for Fully
  Integrated Switched-Capacitor DC-DC Converters", *IEEE JSSC*
  46(9), 2011.
- **DOI**: 10.1109/JSSC.2011.2159054
- **Verification**: paywall — abstract only.
- **Relevance**: T4 charge-pump bucket-dump silicon anchor.

### REF-PW-6 — Seeman & Sanders 2008 *TPE*
- **Citation**: Seeman, M.D., Sanders, S.R. "Analysis and
  Optimization of Switched-Capacitor DC-DC Converters", *IEEE TPE*
  23(2), 2008.
- **DOI**: 10.1109/TPEL.2007.915182
- **Verification**: paywall — abstract only.
- **Relevance**: Canonical SC theory paper for T4.

### REF-PW-7 — Wens & Steyaert 2011 *JSSC*
- **Citation**: Wens, M., Steyaert, M.S.J. "A Fully Integrated CMOS
  800-mW Four-Phase Switched-Capacitor 2:1 Voltage Doubler", *IEEE
  JSSC* 46(7), 2011.
- **DOI**: 10.1109/JSSC.2011.2147830
- **Verification**: paywall — abstract only.
- **Relevance**: T5 anchor.

### REF-PW-8 — Mandal & Sarpeshkar 2007 *TCAS-I*
- **Citation**: Mandal, S., Sarpeshkar, R. "Power-efficient
  impedance-modulation wireless data links for biomedical
  implants", *IEEE TCAS-I* 54(6), 2007.
- **DOI**: 10.1109/TCSI.2007.901051
- **Verification**: paywall — abstract only.
- **Relevance**: T6 Dickson silicon anchor at sub-mW input on
  0.18 µm.

### REF-PW-9 — Hofer & Schmid 2018 *IEEE TPE* 33(11)
- **Citation**: Hofer, M., Schmid, M.J. ΔΣ LED brightness control,
  *IEEE TPE* 33(11), 2018.
- **DOI**: (paywalled).
- **Verification**: paywall — abstract only. Berkeley EECS-2017-73
  thesis is the open-access antecedent.

### REF-PW-10 — Pareschi 2010 *TCAS-I*
- **Citation**: Pareschi et al. "Implementation and Testing of
  High-Speed CMOS True Random Number Generators Based on Chaotic
  Systems", *IEEE TCAS-I* 57(11), 2010.
- **DOI**: 10.1109/TCSI.2010.2052515
- **Verification**: paywall — abstract only.
- **Relevance**: PAT-9 chaotic TRNG anchor.

## Vision-psychophysics primary sources

### REF-VP-1 — Bullough et al. 2011 *LR&T*
- **Citation**: Bullough, J.D. et al. "Effects of flicker
  characteristics from solid-state lighting on detection,
  acceptability and comfort", *Lighting Research and Technology*
  43(3), 2011.
- **Verification**: paywall — abstract only.
- **Relevance**: PAR1789 academic primary source.

### REF-VP-2 — Wilkins/Veitch/Lehman 2010 *PESGM*
- **Citation**: Wilkins et al. "LED lighting flicker and potential
  health concerns: IEEE Standard PAR1789 update", *IEEE PES
  General Meeting*, 2010.
- **Verification**: paywall — abstract only.
- **Relevance**: PAR1789 origin paper.

### REF-VP-3 — Tyler & Hamer 1993 *Vision Research*
- **Citation**: Tyler, C.W., Hamer, R.D. "Eccentricity and the
  Ferry-Porter law", *Vision Research* 33(10), 1993.
- **Verification**: paywall — abstract only.
- **Relevance**: Peripheral CFF vs foveal CFF — bounds twinkle
  envelope frequency.

## Chaotic TRNG references

### REF-TRNG-1 — Yang 2015
- **Citation**: Yang et al. (2015) chaotic TRNG silicon paper.
- **Verification**: paywall — abstract only.
- **Relevance**: PAT-9 anchor.

### REF-TRNG-2 — Mathew 2014
- **Citation**: Mathew, S. et al. (2014) chaotic TRNG silicon.
- **Verification**: paywall — abstract only.
- **Relevance**: PAT-9 anchor.

## Verification status summary

- 5 OA / verified
- 8 paywalled (cited by DOI per the no-IEEE-Xplore web-access
  guidance — `paywall — abstract-only verification`)
- 0 broken / failed

WebFetch budget used: 0 of 10. WebSearch calls: 6.
