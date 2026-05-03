# Solutions catalogue (item f, Stage 1 academic-survey)

7 silicon-anchored driver topologies + 6 academic-only
contributions + 2 new pattern algorithms. Stable short-name
identifiers maintained from industry-survey.

## Driver topologies (silicon-anchored)

| ID | Topology | Silicon anchor | Measured |
|---|---|---|---|
| T1 | Resistor ballast + switch | Curty 2005 *JSSC* 40(11); Karthaus & Fischer 2003 *JSSC* 38(10) | sub-mA in 0.18 µm; whole-tag 16.7 µW |
| T2 | Diode-connected MOS-as-resistor | Doutreloigne 2015 (conference) | conference-grade |
| T3 | Current mirror with bandgap | Tan & Mok 2009 (conference) | conference-grade |
| T4 | Charge-pumped bucket-dump | Le 2011 *JSSC* 46(9); Seeman & Sanders 2008 *TPE* 23(2) | 81 % SC eff @ 32 nm |
| T5 | Switched-cap voltage doubler | Wens & Steyaert 2011 *JSSC* 46(7) | 0.13 µm CMOS |
| T6 | Dickson voltage multiplier | Dickson 1976 *JSSC* SC-11(3); Mandal & Sarpeshkar 2007 *TCAS-I* 54(6) | 0.18 µm silicon at sub-mW input |
| T7 | Direct switch (LED dynamic-r only) | (not silicon-anchored as primary) | n/a |

## Academic-only contributions

| ID | Topic | Anchor | Industry-survey gap |
|---|---|---|---|
| ACAD-A | Sigma-delta brightness modulation | Hofer & Schmid 2018 *IEEE TPE* 33(11); Berkeley EECS-2017-73 thesis (OA) | Industry survey cited NXP patent EP2081414 only — academic anchor stronger |
| ACAD-B | Chaotic-oscillator TRNG | Yang 2015; Pareschi 2010 *TCAS-I* 57(11); Mathew 2014 | Sub-µW pattern-gen TRNG not in sister reports |
| ACAD-C | On-die LED in passive RFID tag | Karthaus & Fischer 2003 *JSSC* 38(10) | Industry survey cited NTAG21xF / EM4423 datasheets but not academic primary |
| ACAD-D | Vision-psychophysics primary sources | Hecht-Shlaer 1942; Davis 2015 *PLOS ONE*; Davis 2023 *Frontiers*; Tyler & Hamer 1993 *Vision Research* | Sister reports cited Wikipedia for CFF / Talbot-Plateau |
| ACAD-E | PAR1789 academic traceability | Bullough 2011 *LR&T* 43(3); Wilkins/Veitch/Lehman 2010 *PESGM* | Industry-survey numerical thresholds traceable to these primary sources |
| ACAD-F | Peripheral CFF extension | Tyler & Hamer 1993 *Vision Research* 33(10) | Industry survey treated CFF as single number; academic literature distinguishes foveal vs peripheral |

## New pattern algorithms

| ID | Algorithm | Anchor | Notes |
|---|---|---|---|
| PAT-9 | Chaotic-oscillator pattern generator | Yang 2015 / Pareschi 2010 / Mathew 2014 | 80 nW; statistical-quality randomness above LFSR |
| PAT-10 | Sigma-delta brightness modulation | Hofer & Schmid 2018 | Higher fundamental frequency than PWM |

## Stage-2 / Stage-3 handoff

The shortlist for Stage-2 gap analysis from this academic-survey
angle:

- **T1 (resistor ballast)** — strongest academic-anchored simplest
  topology; 16.7 µW whole-tag (Karthaus 2003) is the lowest known
  silicon-measured power point including LED indicator.
- **T4 (charge-pumped bucket-dump) — with the 2× Talbot–Plateau
  correction** (Davis 2015) — strongest for rail-decoupling.
- **ACAD-A ΔΣ brightness modulation** — strong replacement for
  PWM in PAR1789-stricter regimes.

## Discarded approaches (academic-survey-specific)

- **TRNG-based pattern gen** at twinkle scales (PAT-9) —
  statistical-quality randomness wasted at 30 Hz update rate;
  LFSR wins on area.
- **On-die LC-tank LED driver** — academic literature does not
  support this at our area budget (kills T5-style boost
  independently of the first-principles report).
- **Microcontroller + LUT pattern** (industry-survey ACAD-G) —
  no academic anchor at the sub-µW operating point.
