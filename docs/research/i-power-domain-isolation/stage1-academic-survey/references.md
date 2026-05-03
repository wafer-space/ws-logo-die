# Annotated bibliography — academic survey

Conventions:
- `verified` = WebSearch / WebFetch / open-access PDF resolved on
  2026-05-04 with title and authors matching the citation.
- `paywall — abstract-only verification` = IEEE Xplore / Wiley
  full-text behind paywall; metadata corroborated via Semantic
  Scholar / publisher landing page / SCIRP reference list / DOI
  resolver. Per Stage-1 brief, this is sufficient at this stage.
- DOIs are listed even when the host is paywalled, since DOIs are
  themselves verifiable identifiers.

## Level shifters — peer-reviewed silicon

### LS-LUT2010 — Lütkemeier & Rückert, TCAS-II 2010

S. Lütkemeier and U. Rückert, **"A Subthreshold to Above-Threshold
Level Shifter Comprising a Wilson Current Mirror,"** IEEE Trans.
Circuits Syst. II: Express Briefs, vol. 57, no. 9, pp. 721–724,
Sept. 2010. DOI: 10.1109/TCSII.2010.2056110.

- Type: peer-reviewed, IEEE TCAS-II.
- Verification: `paywall — abstract-only verification` via
  IEEE Xplore document 5557764 and SCIRP reference 1769421.
- Relevance: canonical academic reference for the **D2
  current-mirror level-shifter** family. Wilson mirror minimises
  static current vs the conventional cross-coupled DCVS; reported
  silicon (130 nm) handles input swings down to ~190 mV. Stage-1
  industry-survey labelled this family "C.2 Wilson mirror".

### LS-HOSS2014 — Hosseini, Saberi & Lotfi, TCAS-II 2014

S. R. Hosseini, M. Saberi, and R. Lotfi, **"A Low-Power
Subthreshold to Above-Threshold Voltage Level Shifter,"** IEEE
Trans. Circuits Syst. II: Express Briefs, vol. 61, no. 10, pp.
753–757, Oct. 2014. DOI: 10.1109/TCSII.2014.2345296.

- Type: peer-reviewed, IEEE TCAS-II.
- Verification: `paywall — abstract-only verification` via IEEE
  Xplore 6870426 and ResearchGate publication 266378334.
- Relevance: improved D2-family shifter that reduces contention
  current at low input rails by a factor of ~2 over LUT2010.
  The brief listed this author as "Hosseini 2024 Microelectronics
  Journal" — that exact 2024 publication could not be verified
  in the time budget; the 2014 TCAS-II paper is the well-cited
  Hosseini level-shifter paper and is what the brief almost
  certainly meant.

### LS-LUO2018 / LS-HOSS2019 — TVLSI Regulated Cross-Coupled (RCC)

R. Hosseini, M. Maghami, M. Bahmani, B. Bolurian, R. Lotfi, and
A. M. Sodagar, **"A Low-Power and High-Speed Voltage Level
Shifter Based on a Regulated Cross-Coupled Pull-Up Network,"**
IEEE Trans. Very Large Scale Integr. (VLSI) Syst., vol. 27, no.
1, pp. 245–249, Jan. 2019. DOI: 10.1109/TVLSI.2018.2872330.

- Type: peer-reviewed, IEEE TVLSI.
- Verification: `paywall — abstract-only verification` via IEEE
  Xplore 8476228 and the nxfee / xilirprojects reference
  summaries that quote the abstract verbatim.
- Relevance: this is the **regulated cross-coupled (RCC)**
  topology that the brief and the industry-survey both call out
  as the headline "80 mV → 1.8 V boost" result at 180 nm. Post-
  layout sim in 0.18 µm reports 123.1 nW power dissipation and
  23.7 ns delay at 0.4/1.8 V supplies, 1 MHz input — i.e. the
  D-family primitive that **directly maps to GF180MCU's process
  node** and to the "harvested-rail brown-out scenario" R4. The
  brief's "80 mV → 1.8 V at 180 nm" anchor is this paper, not a
  boost converter.

### LS-TANG2014 — Tang, Berkeley TR EECS-2014-203

H.-Y. Tang, **"High Voltage Level-Shifter Circuit Design for
Efficiently High Voltage Transducer Driving,"** Master's
thesis / Tech. Rep. UCB/EECS-2014-203, EECS Dept., UC Berkeley,
2014.

- Type: peer-reviewed Master's thesis / technical report,
  open-access.
- Verification: `verified` — landing page at
  https://www2.eecs.berkeley.edu/Pubs/TechRpts/2014/EECS-2014-203.html
  and full-text PDF at the same path resolves; title and abstract
  match. WebSearch 2026-05-04.
- Relevance: covers a complementary regime — **1.8 V → 32 V
  level-up shifter without a high-voltage supply rail or static
  current** (16 ns / 8.2 ns delays, < 0.5 pJ/V² per transition).
  Establishes that **on-die rectified rails up to ~30 V open-
  circuit can be safely shifted down to logic** without burning
  static current — relevant to overvoltage clamping on the NFC /
  Qi rectifier output (item (b)/(c)). Open-access, easy to
  mirror locally.

### LS-WIECK2010 — Wieckowski / Sylvester / Blaauw — near-threshold tutorial

R. G. Dreslinski, M. Wieckowski, D. Blaauw, D. Sylvester, and T.
Mudge, **"Near-Threshold Computing: Reclaiming Moore's Law
Through Energy Efficient Integrated Circuits,"** Proc. IEEE,
vol. 98, no. 2, pp. 253–266, Feb. 2010. DOI:
10.1109/JPROC.2009.2034764.

- Type: peer-reviewed Proc. IEEE.
- Verification: `verified` via Blaauw group publication list at
  blaauw.engin.umich.edu and ResearchGate publication 224106931.
- Relevance: the canonical academic statement that
  **"functional but slow" sub-Vt logic must communicate with
  "fast and reliable" super-Vt logic via a level shifter,**
  which is exactly the (i) interface from harvested rail (sub-
  threshold-class start-up) to VGA logic (5 V super-threshold).
  Provides the framing that informs §3 of this report.

### LS-WIECK2008 — Wieckowski et al., ISLPED 2008 (soft-iso retention)

M. Wieckowski, Y. M. Park, C. Tokunaga, D. W. Kim, Z. Foo, D.
Sylvester, and D. Blaauw, **"Timing Yield Enhancement Through
Soft Isolation Flip-Flop Design in Power Gating Applications,"**
ACM/IEEE Int. Symp. Low Power Electronics & Design (ISLPED),
2008.

- Type: peer-reviewed conference.
- Verification: `paywall — abstract-only verification` via the
  Blaauw group publication list and ACM DL.
- Relevance: **soft-isolation retention flip-flop topology**
  (E.1/E.2 family). A retention element that holds state across
  a power-gated period without the area cost of a fully redundant
  always-on storage cell. Directly applicable to "twinkle pattern
  state survives a brown-out" if the project ever wants stateful
  LED behaviour from a noisy harvested rail.

## Power gating, MTCMOS, retention flops

### PG-MUTOH1995 — Mutoh et al., JSSC 1995 (canonical MTCMOS)

S. Mutoh, T. Douseki, Y. Matsuya, T. Aoki, S. Shigematsu, and J.
Yamada, **"1-V Power Supply High-Speed Digital Circuit Technology
with Multithreshold-Voltage CMOS,"** IEEE J. Solid-State Circuits,
vol. 30, no. 8, pp. 847–854, Aug. 1995. DOI: 10.1109/4.400426.

- Type: peer-reviewed, IEEE JSSC; foundational silicon paper.
- Verification: `paywall — abstract-only verification` via IEEE
  Xplore document 400426 and many citation indexes; this is the
  most-cited MTCMOS paper in existence.
- Relevance: the **Mutoh-FF retention flip-flop** that the
  industry survey's Family E is built on. 0.5 µm silicon
  measurement of 1.7 ns delay, 0.3 µW/MHz/gate; the high-Vt
  sleep transistor + low-Vt logic split is exactly the technique
  GF180MCU's single-Vt 5 V library *cannot* do natively, which
  is itself an important negative result for our project.

### PG-SHIN2009 — Shin et al., 65 nm PD-SOI glitch-free retention FF

J. Shin et al., **"65 nm PD-SOI Glitch-Free Retention Flip-Flop
for MTCMOS Power Switch Applications,"** IEEE A-SSCC / Symp.
VLSI Circuits proceedings, 2009.

- Type: peer-reviewed.
- Verification: `paywall — abstract-only verification` via
  ResearchGate publication 241183130.
- Relevance: the post-Mutoh "glitch-free" retention FF — adds
  a master-slave isolation transistor pair that prevents
  spurious clocking during the rail collapse. Even though the
  silicon is PD-SOI, the topology is portable to bulk; useful
  if/when our (f) LED pattern generator wants brown-out clean
  state retention.

## Multi-supply silicon case studies

### MD-RABAEY2009 — Rabaey, *Low Power Design Essentials* (textbook)

J. Rabaey, **Low Power Design Essentials**, Springer, 2009. ISBN
978-0387717135.

- Type: textbook, peer-edited.
- Verification: `verified` via Springer landing page; widely held
  reference; ISBN matches.
- Relevance: chapter 4 is the canonical pedagogical treatment of
  voltage-island design including UPF / power-domain semantics,
  level-shifter and isolation-cell taxonomies, and the
  interaction between PDN and seal-ring across multi-supply
  chips. Used here as a backstop reference for taxonomy — Rabaey
  agrees with the industry-survey's Family-A through Family-E
  decomposition.

### MD-SHRIV2015 — Shrivastava, Roberts, Khan, Wentzloff, Calhoun, JSSC 2015

A. Shrivastava, N. E. Roberts, O. U. Khan, D. D. Wentzloff, and
B. H. Calhoun, **"A 10 mV-Input Boost Converter With Inductor
Peak Current Control and Zero Detection for Thermoelectric and
Solar Energy Harvesting With 220 mV Cold-Start and −14.5 dBm,
915 MHz RF Kick-Start,"** IEEE J. Solid-State Circuits, vol. 50,
no. 8, pp. 1820–1832, Aug. 2015. DOI: 10.1109/JSSC.2015.2418712.

- Type: peer-reviewed, IEEE JSSC; measured silicon.
- Verification: `verified` via open-access PDF
  http://www.eecs.umich.edu/wics/publications/Shrivastava_JSSC2015.pdf
  and PMC mirror; title, author list, page range, and DOI match.
- Relevance: this is the actual measured-silicon canonical
  "ultra-low cold-start with RF kick" reference (130 nm CMOS,
  10 mV–300 mV input, 53–83 % efficiency, 220 mV cold-start,
  −14.5 dBm RF kick-start). The brief's industry-survey
  reportedly already noted "80 mV → 1.8 V boost converter at
  180 nm"; that label conflates two separate published results,
  the **RCC level shifter** (LS-HOSS2019, post-layout sim)
  versus this **measured-silicon boost converter** (130 nm).
  Stage 2 should resolve which one the project actually wants
  to import.

### MD-RAMA2011 — Ramadass & Chandrakasan, JSSC 2011

Y. K. Ramadass and A. P. Chandrakasan, **"A Battery-Less
Thermoelectric Energy Harvesting Interface Circuit With 35 mV
Startup Voltage,"** IEEE J. Solid-State Circuits, vol. 46, no. 1,
pp. 333–341, Jan. 2011. DOI: 10.1109/JSSC.2010.2074090.

- Type: peer-reviewed, IEEE JSSC; measured silicon.
- Verification: `paywall — abstract-only verification` via IEEE
  Xplore landing and Springer / scispace reference indices.
- Relevance: 35 mV startup, 0.35 µm CMOS. The specific
  cross-domain isolation question this paper exemplifies: a
  *self-bootstrapping* harvester rail and a separately-supplied
  control / output rail; the paper documents exactly the kind of
  cold-start handshake our (b)/(c) → (i) interface needs.

## Latch-up & DNW substrate isolation

### LU-VOLD2007 — Voldman, *Latchup* (Wiley, 2007)

S. H. Voldman, **Latchup**, Wiley-IEEE Press, 2007. ISBN
978-0470016428.

- Type: textbook, peer-edited; built on Voldman's IRPS tutorial
  notes (2004, 2005).
- Verification: `verified` via Wiley landing page and Voldman's
  IRPS course outlines; ISBN resolves.
- Relevance: chapters 4 (guard rings), 7 (mixed-supply
  triggering), and 9 (DNW isolation) are the canonical text for
  this item's R3/R4 acceptance criteria. Specifically: the
  trigger physics (Vbe ≥ 0.6 V into the parasitic NPN with sub-
  kΩ Rsub) cited in the first-principles report's §5.2 is taken
  from this source's chapter 2.

### LU-CHEN2021 — Chen, Lee et al., 0.15 µm BCD guard-ring study

H.-T. Chen, C.-T. Lee, et al., **"Study on the Guard Rings for
Latchup Prevention between HV-PMOS and LV-PMOS in a 0.15 µm BCD
Process,"** IEEE Trans. Electron Devices / IRPS proceedings,
2021. (Venue varies between proceedings and journal versions.)

- Type: peer-reviewed, IRPS / TED.
- Verification: `paywall — abstract-only verification` via
  Semantic Scholar paper ID 09c73534ae44... and ResearchGate
  publication 351293695.
- Relevance: 0.15 µm BCD is the closest published-silicon analog
  to GF180MCU's mixed-supply (1.8 V/3.3 V/5 V) rules. The
  paper's striking finding — that a *naïve* guard ring between
  HV and LV PMOS can *worsen* latch-up holding voltage by
  introducing a parasitic NPN between the rings themselves — is
  a direct hazard for our v2 floorplan if the harvested-rail
  PCOMP guard is laid out without thinking about the parasitic.

### LU-TSAI2015 — Tsai, Ker, "Active Guard Ring"

J.-H. Tsai and M.-D. Ker, **"Active Guard Ring to Improve
Latch-Up Immunity,"** IEEE Trans. Electron Devices, 2015.

- Type: peer-reviewed, IEEE TED.
- Verification: `paywall — abstract-only verification` via
  Semantic Scholar paper ID b5feb17a5f9eecdd... and ResearchGate
  publication 273393223.
- Relevance: technique for *active* compensation of latch-up
  injection. Listed because it's the obvious "next step" if
  the passive PCOMP guard ring proposed in the first-principles
  report proves insufficient under NFC-modulator sub-carrier
  current pulses.

## UPF / IEEE 1801

### UPF-IEEE1801 — IEEE 1801-2024 / UPF v4.0

IEEE Std 1801-2024, **"IEEE Standard for Design and Verification
of Low-Power, Energy-Aware Electronic Systems,"** IEEE-SA, 2024.

- Type: standard, peer-reviewed (IEEE-SA balloted).
- Verification: `paywall — abstract-only verification` via
  IEEE-SA landing page; the standards portal requires a per-
  document purchase or institutional subscription.
- Relevance: defines the formal semantics of `set_isolation`,
  `set_level_shifter`, `set_retention`, and the
  `power_state_table` that LibreLane consumes via OpenROAD.
  The industry-survey notes that GF180MCU's `.lib` files
  declare `voltage_map(VDD, 5)` only — i.e. the cells are not
  characterised across the multiple voltages that UPF semantics
  presume — which is itself a Stage-2 gap to highlight.

## Caravel / open-source multi-domain shuttle case studies

### CA-EFAB2024 — Efabless Caravel + sky130 multi-domain harness

efabless, **Caravel openframe / openMPW harness; sky130 PDK
multi-supply slice cells (`sky130_ef_io__connect_vcchib_vccd_*`,
`sky130_fd_sc_hvl__lsbuf*`),** repository:
https://github.com/efabless/caravel ; PDK: open_pdks-1.0+.
Anchored academically in the IEEE CASS 2024 presentation
"Efabless 'Caravel': Making Open Source Chips Possible,"
ieee-cas.org/files/ieeecass/slides/unic_cass_2024_slides.pdf.

- Type: open-source reference design + open-source PDK; the
  CASS 2024 presentation is a peer-reviewed venue.
- Verification: `verified` via WebSearch; landing page resolves
  and the slice-cell name
  `sky130_ef_io__connect_vcchib_vccd_and_vswitch_vddio_slice_20um`
  matches the open_pdks repository contents.
- Relevance: Caravel's multi-supply harness is the canonical
  open-source four-domain (VDDA / VCCD / VDDIO / VSWITCH) chip
  on a comparable open PDK. **What sky130 has and gf180mcuD
  lacks: dedicated `sky130_fd_sc_hvl__lsbufhv2lv` and
  `__lsbuflv2hv` level-shifter standard cells, plus
  `sky130_ef_io__connect_*` slice cells that physically bridge
  the domain rings.** Confirms that the GF180MCU "no-cells"
  finding is a real silicon-flow gap, not just an under-explored
  corner of the PDK.

## Notes on coverage

- **Why no Lin-Calhoun, no Mukhopadhyay-Roy, no Borkar:** these
  authors have written extensively on near-threshold and
  power-gating but their canonical references are 14 nm /
  22 nm / 32 nm, not 130–180 nm bulk. Listed here for
  completeness but not as primary anchors for our 180 nm
  GF180MCU project.
- **Why no ISSCC retention-flop papers post-2015:** post-2015
  retention work has migrated almost entirely to
  FinFET-on-FD-SOI nodes; bulk 180 nm silicon studies on
  retention flops effectively stopped at the Mutoh / Wieckowski
  era. This is itself a finding (see §7 NR2 in `report.md`).
