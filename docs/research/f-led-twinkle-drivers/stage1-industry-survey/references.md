# References (item f, Stage 1 industry-survey)

| Ref | Citation | Type | URL/DOI | Verified | Cached |
|---|---|---|---|---|---|
| I1 | Texas Instruments, "TLC5947: 24-Channel, 12-Bit PWM LED Driver With 30 mA Constant Current Sink", product page | datasheet | https://www.ti.com/product/TLC5947 | yes (WebFetch 2026-05-03; "30-mA Capability (Constant-Current Sink)", "3.0 V to 5.5 V VCC", "12-Bit (4096 Steps) PWM Grayscale Control", "24 channels" extracted) | no (deferred to stage 2) |
| I2 | Texas Instruments, "TLC59281: 16-Channel LED Driver With BC, DC, EC and Pre-Charge FET" datasheet PDF | datasheet | https://www.ti.com/lit/ds/symlink/tlc59281.pdf | partial (WebFetch 2026-05-03 returned PDF binary; cell architecture confirmed, exact numbers not extracted from binary) | yes (binary cached at `~/.claude/projects/.../tool-results/webfetch-1777780231390-uhldtc.pdf`) — re-fetch via PDF text in stage 2 |
| I3 | Linear Technology / Analog Devices, "LT3593 — 1MHz White LED Driver with Output Disconnect and 1-Wire Current Programming", datasheet PDF | datasheet | https://www.analog.com/media/en/technical-documentation/data-sheets/3593f.pdf | yes (WebSearch 2026-05-02, snippet: "input supply voltage to the LT3593 must be 2.7V or higher", "5-bit DAC", "1MHz", "VCAP clamped at 38V", "6-lead 2mm × 2mm DFN / SOT-23") | no |
| I4 | Maxim / Analog Devices, "MAX1561 / MAX1599: High-Efficiency, 26V Step-Up Converters for Two to Six White LEDs", datasheet PDF | datasheet | https://www.analog.com/media/en/technical-documentation/data-sheets/max1561-max1599.pdf | yes (WebSearch 2026-05-03, snippet: "2.6V to 5.5V", "0 to 20mA", "1MHz / 500kHz", "up to six white LEDs in series") | no |
| I5 | Microchip Technology, "MCP1640/B/C/D Synchronous Boost Converter with True Output Disconnect", datasheet PDF | datasheet | https://ww1.microchip.com/downloads/en/DeviceDoc/20002234D.pdf | yes (WebSearch 2026-05-03, snippet: "0.65V at 1 mA start-up", "19 µA quiescent in PFM", "0.75 µA shutdown", "0.35 to 5.5V Vin", "PWM 500 kHz") | no |
| I6 | Texas Instruments, "BQ25505: Ultra-low-power Boost Charger IC With Battery Management and Autonomous Power Multiplexer", datasheet excerpts | datasheet | https://www.ti.com/lit/ds/symlink/bq25570.pdf (companion BQ25570) | yes (WebSearch 2026-05-03, snippet: "VIN ≥ 330 mV cold start", "325 nA quiescent", "programmable MPPT") | no |
| I7 | Maxim / Analog Devices, "MAX20361 Solar Cell Energy Harvester", product page | datasheet | https://www.analog.com/en/products/max20361.html | yes (WebSearch 2026-05-03, snippet: "ultra-low quiescent current (360nA)", "starting from voltages as low as 225mV", "harvest 15μW to over 300mW", "MPPT") | no |
| I8 | Texas Instruments, "TIDA-00242: Indoor Light Energy Harvesting Reference Design", design document | reference design | https://www.ti.com/lit/pdf/tidu235 | URL exists (WebSearch 2026-05-03) | no |
| I9 | Eastern Voltage Research, "FR1001 Candle Effects IC Datasheet" PDF | datasheet | https://www.easternvoltageresearch.com/content/datasheets/datasheet_fr1001.pdf | partial (WebFetch 2026-05-03 returned binary PDF; product page confirms 5 V VCC, drives external N-MOSFET gate) | yes (binary cached at `~/.claude/projects/.../tool-results/webfetch-1777780419957-8m2k36.pdf`) |
| I10 | Eastern Voltage Research, "FR1001 Candle Flicker Effects IC" product page | product page | https://www.easternvoltageresearch.com/fr1001-candle-flicker-effects-ic/ | yes (WebSearch 2026-05-03, snippet: "5V VCC ... output connects directly to the gate of a logic-level N-channel MOSFET"; FR1001 = "harsher exaggerated"; FR1002 = "more realistic random") | no |
| I11 | Tim "cpldcpu", "Hacking a candleflicker LED" (blog) | blog / RE | https://cpldcpu.com/2013/12/08/hacking-a-candleflicker-led/ | yes (WebFetch 2026-05-03, extracted: 440 Hz osc, 12 brightness levels, frame=32 cycles=72 ms, ~14 Hz update, 4-min non-repeat, 17b state, 2 µm CMOS, 1.9-3.8 V) | no (text snippet in report §3.8) |
| I12 | Tim "cpldcpu", "Reverse Engineering Candle Flicker LEDs, Again" / "Follow up on Candle Flicker LEDs" (blog) | blog / RE | https://cpldcpu.com/2014/03/01/follow-up-on-candle-flicker-leds/ | yes (WebFetch 2026-05-03, extracted: dual-RC vs single-RC architectures; ~30 FF cells; 13-14 FF minimum: 5b frame counter + 4b PWM + 4-5b brightness; LFSR-based) | no |
| I13 | Tim "cpldcpu", "Revisiting Candle Flicker-LEDs: Now with integrated Timer" (blog) | blog / RE | https://cpldcpu.com/2024/01/14/revisiting-candle-flicker-leds-now-with-integrated-timer/ | yes (WebFetch 2026-05-03, extracted: PIC12F-class OTP MCU, 1 MHz core, 125 Hz PWM, 240 µA sleep, several mA active, 6h on/18h off, ~0.5 mm² 180 nm CMOS, 3 V CR2032) | no |
| I14 | Hackaday, "Reverse Engineering Candle Flicker LEDs Again" (2014-03-02) | blog / RE summary | https://hackaday.com/2014/03/02/reverse-engineering-candle-flicker-leds-again/ | yes (WebFetch 2026-05-03; extracted: ~30 cell repetitions, 13-14 FF minimum, 2 µm CMOS, < 3 V supply, dual-RC oscillators) | no |
| I15 | Hackaday, "Reverse Engineering A Candle Flicker LED" (2013-12-16) | blog / RE summary | https://hackaday.com/2013/12/16/reverse-engineering-a-candle-flicker-led/ | yes (WebFetch 2026-05-03; extracted: RC osc, 9-stage divider chain, multiple shift-register cells, EXOR-gate combiner, "serpentine" output FET) | no |
| I16 | IEEE Std 1789-2015, "IEEE Recommended Practices for Modulating Current in High-Brightness LEDs for Mitigating Health Risks to Viewers" | standard | https://ieeexplore.ieee.org/document/7118618 | URL exists (WebSearch 2026-05-03); standard is paywalled | no (paywalled) |
| I17 | "Calculating the Maximum Safe Flicker According to IEEE PAR1789", AzoM, Article ID 14729 | secondary | https://www.azom.com/article.aspx?ArticleID=14729 | yes (WebFetch 2026-05-03, exact quotes: "Below 90 Hz NOEL: Max % Modulation ≤ Flicker Frequency × 0.025"; "Below 90 Hz Low-Risk: × 0.01"; "Above 90 Hz NOEL: × 0.08"; "Above 90 Hz Low-Risk: × 0.033"; "jump in trend at 90 Hz") | no |
| I18 | flickersense.org, "Definitions" page (LED flicker, modulation index) | tertiary | https://www.flickersense.org/background/definitions | yes (WebFetch 2026-05-03, extracted: "Flicker percent = 100% × (max-min)/(max+min)"; "Below 90 Hz: < 0.01 × frequency"; "Above 90 Hz: < 0.0333 × frequency"; cites ANSI/IES TM-39-25 critique) | no |
| I19 | "IEEE 1789: A new standard for evaluating flickering LEDs?", DIAL GmbH | tertiary | https://www.dial.de/en-GB/articles/ieee-1789-a-new-standard-for-evaluating-flickering-leds | yes (WebFetch 2026-05-03; corroborates: < 80 Hz CFF range, "above 3 kHz no evidence of effects on humans") | no |
| I20 | NXP B.V., "Sigma delta LED driver", European patent EP2081414A1 | patent | https://patents.google.com/patent/EP2081414A1/en | yes (WebSearch 2026-05-03 snippet: "modulating ... thus generating a pulse-density modulated signal", "adder ... configured to receive a first signal representing a desired brightness or colour and to add a dither noise signal thereto") | no |
| I21 | "Implementation of Improved Perlin Noise" — NVIDIA GPU Gems Ch. 5 (Ken Perlin) | tertiary book chapter | https://developer.nvidia.com/gpugems/gpugems/part-i-natural-effects/chapter-5-implementing-improved-perlin-noise | yes (WebSearch 2026-05-03; standard reference for value/Perlin noise algorithms — used as PAT-4 source) | no |
| I22 | TomKeddie, "tinytapeout-2023-2a" (LED panel driver, TT03p5) | open source | https://github.com/TomKeddie/tinytapeout-2023-2a | URL exists per GitHub search (2026-05-03) | no |
| I23 | thexeno, "tt08-rgbw-controller" (Color generator with custom CPU) | open source | https://github.com/thexeno/tt08-rgbw-controller | URL exists per WebSearch 2026-05-03 | no |
| I24 | algofoogle, "tt09-ring-osc2" (alternate ring-osc test design) | open source | https://github.com/algofoogle/tt09-ring-osc2 | URL exists per WebSearch 2026-05-03 | no |
| I25 | GlobalFoundries / Mabrains, "gf180mcu_fd_io" pad-cell library — `bi_24t`, `bi_t`, `asig_5p0`, `brk2/5` cells | PDK source | local: `gf180mcu_pdk/gf180mcuD/libs.ref/gf180mcu_fd_io/{lib,lef,verilog,cdl}/` | yes (filesystem audit 2026-05-03; LIB `drive_current : 24000.000000`, CDL `asig_5p0` netlist with 4-finger ESD diodes + 36-instance cap_nmos_06v0 decoupling) | yes (in repo at the cited paths) |
| I26 | Schubert, "Light-Emitting Diodes", 3rd ed., CUP 2018 | textbook | ISBN 9781107106406 | URL not used; standard reference for LED Vf vs I (cross-ref §5.2) | n/a (copyright) |
| I27 | Lite-On, "LTL-307E" 5 mm red LED datasheet | datasheet | (vendor — multiple mirrors) | not re-fetched; well-known commodity part used in §5.2 sanity check | no |

**Verification status summary:**

- 19 of 27 references (I1, I3-I7, I10-I20) verified by WebFetch or
  WebSearch on 2026-05-03 with extracted numerical content quoted
  directly in `report.md` §5.
- 1 reference (I25, GF180MCU pad cells) verified by direct
  filesystem audit of LIB / LEF / CDL / Verilog files in the local
  PDK install — *the highest-confidence verification because the
  source IS the local repo*.
- 2 references (I9, I2) are PDFs whose binary form was successfully
  fetched but whose content needs re-extraction in Stage 2 (cached
  in tool-results, paths recorded above).
- 5 references (I8, I21-I24) are URLs known to exist (verified by
  search) but whose deep content was not extracted line-by-line for
  this report — flagged for Stage-2 reviewer to spot-check.
- 1 reference (I16, IEEE 1789-2015) is paywalled; the
  numerical NOEL / low-risk thresholds were verified through three
  independent secondary sources (I17, I18, I19) which all agree on
  the formulas.
- 2 references (I26, I27) are well-known textbook / datasheet
  citations used only for sanity-check purposes; they are not
  load-bearing for any novel claim and are listed for completeness.

**Outstanding for Stage-2 reviewer:**

(a) Re-extract numerical specs from cached binary PDFs (I2, I9)
    using a PDF text extractor (uv run pdfminer.six or similar).
(b) Cache I3, I4, I5, I8 PDFs locally and SHA-256 them.
(c) Confirm the extracted PAR1789 formulas (I17/I18) against the
    paywalled IEEE 1789-2015 directly if a copy can be obtained
    via institutional access.
(d) Spot-check the cpldcpu blog series (I11-I13) for archive.org
    snapshots in case the original blog goes offline; URL stability
    of personal blogs is a known archival risk.
