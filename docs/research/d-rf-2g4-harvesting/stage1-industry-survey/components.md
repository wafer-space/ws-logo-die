# Sub-block breakdown — item (d) industry-survey angle

For each high-level approach catalogued in `report.md` §3, the
sub-blocks an implementation would need (with industry-attested
counterparts in *italics*).

## Common to all RFEH front-ends

- **Antenna pad + ESD network at the bond pad.** GF180MCU pad ring
  cells provide an ESD diode pair to VDD/VSS. *Industry analogue:*
  every BLE/Wi-Fi front-end pin on EFR32 / nRF52 / TI CC2640 has the
  same ESD discipline. Care: the diodes load the rectifier input
  with ~100–200 fF parasitic.
- **Bondwire(s).** Single signal bond is mandatory by project
  constraint; ground bond *count* is a key design knob (4 parallel
  ground bonds → ~0.5 nH ground inductance, vs ~2 nH for one bond).
  *Industry analogue:* Si Labs AN928.2 layout guide stipulates
  multiple ground vias and bond-equivalent ground patches around
  the RF pin.
- **Optional on-die balun / transformer.** Single-ended-to-
  differential conversion for §3.A.3 (cross-coupled differential
  rectifier). *Industry analogue:* on-die transformers are common
  in modern Bluetooth radio front-ends for differential PA drive
  (TI CC26xx, Nordic nRF52840).

## §3.A.1 / §3.A.2 — Dickson rectifier (single-ended)

- N-stage rectifier ladder (N typically 4–10 for 2.4 GHz ambient).
- Per-stage coupling caps (MIM, ~50–500 fF each).
- Diode-connected NMOS (native-Vt for §3.A.2).
- Output storage cap (~10 nF for our LED-twinkle load).
- DC blocking cap at input (Powercast P2110B mandates this for
  DC-shorted antennas — same concern applies to us).
- *Industry analogue:* Powercast PCC110 internal block diagram
  (inferred from product brief) and many UHF RFID tag silicon.

## §3.A.3 — Cross-coupled differential rectifier

- Differential RF input pair (forces §3.A.6 transformer or §3.E.6
  differential antenna).
- Cross-coupled NMOS + PMOS pair per stage (4 transistors per
  rectifier stage).
- Per-stage MIM coupling caps (2 per stage, balanced).
- Storage cap.
- *Industry analogue:* Yan et al. 2024 RFIC, Awad MDPI 2022,
  Kadali 2021 (all 180 nm CMOS academic-but-industry-relevant).

## §3.A.5(a) — Kotani aux-bias chain

- Naïve single-stage cold-start rectifier (small).
- Bias chain that holds gates of the main rectifier at ~Vth.
- Auxiliary regulator (often just a long-channel NMOS divider).
- *Industry analogue:* Many UHF RFID tag silicon (Impinj, NXP).

## §3.A.7 — Reconfigurable rectifier (Yan 2024 style)

- N rectifier stages, each switchable in/out via series-FET.
- RSSI / MPPT controller (digital + small comparator analogue).
- Configuration registers (latch-based, no eFuse needed at runtime
  but eFuse-trim friendly via item (j)).
- *Industry analogue:* Yan 2024 RFIC paper (180 nm CMOS).

## §3.D Back-end PMU (where the rectifier output is taken to a usable voltage)

For our project's no-external-passives constraint, this is forced to
on-die switched-capacitor only. *Industry analogue:* TI BQ25504
**(forbidden — needs external L)**, Powercast PCC210 boost
**(forbidden — same)**, e-peas AEM30940 **(forbidden — same)**.

- Switched-capacitor charge pump (2× or 3× as in Yan 2024).
- Storage cap (on-die MIM array, item (e)) — likely 1–10 nF given
  GF180MCU MIM density.
- Brown-out detector (compares storage-cap voltage to a bandgap
  reference; gates the LED driver until the cap holds enough
  charge).
- Bandgap reference (~50 nA quiescent).

## §3.E Antenna (off-die, on the PCB)

- 6 × 10 mm meander IFA on `In2.Cu` (already specified by the PCB
  sub-project).
- Ground keep-out under the antenna footprint.
- Optional: feed-tap position adjustment for non-50 Ω matching to
  the rectifier (industry departure from standard 50 Ω discipline).

## §3.H TR-switch for shared antenna with item (k) BLE

- Series-NFET switch in the harvest path.
- Shunt-NFET to ground in the BLE-PA path during harvest mode (and
  vice-versa).
- Switch control logic gated on item (k) operating mode.
- *Industry analogue:* every TX/RX-shared 2.4 GHz radio front-end
  (most BLE SoCs).

## Caveat — the §3.D PMU back-end is the elephant

The first-principles report flagged this; the industry survey
confirms it. The hardest part of the design is *not* the rectifier
topology but **getting the rectifier output to a usable voltage with
no external inductor**. All three commercial back-ends (TI BQ25504,
Powercast PCC210, e-peas internal boost) use external inductors;
our chip cannot. Switched-capacitor charge pumps in 180 nm at our
budget cap out at 2–3× voltage gain with reasonable area. This is
a major design-effort allocation that does not appear in the
"§3.A rectifier topology" comparison and must be sized separately
in Stage 4.