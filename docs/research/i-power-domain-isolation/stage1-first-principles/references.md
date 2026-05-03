# References (item i, Stage 1 first-principles)

This is a first-principles report. Literature survey is the sibling
reports' responsibility (`stage1-academic-survey/`,
`stage1-industry-survey/`). The references below are the *primary*
PDK and project artefacts read directly.

Verification status convention:
- `verified-direct-read`: file opened on this filesystem and quoted
  in this report.
- `not-verified`: cited but not opened.

## Project-internal artefacts (verified by direct read)

### REF-PROJ-1 — `TODO.md`
- **Path:** `/home/tim/github/wafer-space/ws-logo-die/TODO.md`
- **Verification:** verified-direct-read on 2026-05-02.
- **Relevance:** source of all requirements (R1–R7) cited in §2.
  Specifically lines 56–80 (cross-cutting constraints), lines
  534–587 (item i research scope), lines 753–768 (backwards-compat
  criteria).

### REF-PROJ-2 — `librelane/config.yaml`
- **Path:** `/home/tim/github/wafer-space/ws-logo-die/librelane/config.yaml`
- **Verification:** verified-direct-read on 2026-05-02.
- **Relevance:** current single-domain `VDD_NETS: [VDD]` /
  `GND_NETS: [VSS]` (lines 47–50). PDN layer choice Metal2/Metal3
  (line 96–97). `MAGIC_EXT_UNIQUE: notopports` (line 145) hint
  for multi-pad-per-domain.

### REF-PROJ-3 — `librelane/pdn_cfg.tcl`
- **Path:** `/home/tim/github/wafer-space/ws-logo-die/librelane/pdn_cfg.tcl`
- **Verification:** verified-direct-read on 2026-05-02.
- **Relevance:** shows `set_voltage_domain -name CORE -power
  $::env(VDD_NET) -ground $::env(GND_NET) -secondary_power
  $secondary` (lines 48–49) — the multi-domain hook in the
  existing flow; only one domain is currently configured.

### REF-PROJ-4 — `librelane/slots/slot_1x1.yaml`
- **Path:** `/home/tim/github/wafer-space/ws-logo-die/librelane/slots/slot_1x1.yaml`
- **Verification:** verified-direct-read on 2026-05-02.
- **Relevance:** pad-side ordering. `analog[1]` and `analog[0]`
  are the first two entries of `PAD_NORTH` (lines 63–64),
  confirming they are adjacent at the north-west corner.

### REF-PROJ-5 — `src/chip_top.sv`
- **Path:** `/home/tim/github/wafer-space/ws-logo-die/src/chip_top.sv`
- **Verification:** verified-direct-read on 2026-05-02.
- **Relevance:** shows current single-rail wiring of all pad
  instantiations (lines 50–166); shows that `analog` pads use
  `gf180mcu_fd_io__asig_5p0`.

### REF-PROJ-6 — `src/slot_defines.svh`
- **Verification:** verified-direct-read on 2026-05-02.
- **Relevance:** pad counts per slot. `SLOT_1X1` has 8 DVDD,
  10 DVSS, 12 input, 40 bidir, 2 analog pads (lines 1–12).

## PDK artefacts (verified by direct read)

### REF-PDK-1 — `gf180mcu_fd_io.cdl`
- **Path:** `gf180mcu_pdk/gf180mcuD/libs.ref/gf180mcu_fd_io/cdl/gf180mcu_fd_io.cdl`
- **Verification:** verified-direct-read on 2026-05-02.
- **Relevance:** SPICE netlists for all IO cells. Critical
  findings:
  - `gf180mcu_fd_io__brk5` netlist has only `VSS` as port
    (confirms single-VSS-passthrough domain breaker).
  - `gf180mcu_fd_io__dvdd` contains hardwired `D20:
    diode_nd2ps_06v0 DVSS DVDD` (forward-biased DVSS-to-DVDD when
    DVSS > DVDD + Vf).
  - `gf180mcu_fd_io__cor` contains a `4 mm` snapback NFET clamp
    plus the equivalent for the io-VDD/VSS subdomain.
  - `gf180mcu_fd_io__asig_5p0` has D2 (DVSS-to-PAD) and D3
    (PAD-to-DVDD) ESD clamps.

### REF-PDK-2 — `gf180mcu_ws_io.spice`
- **Verification:** verified-direct-read on 2026-05-02.
- **Relevance:** shows `gf180mcu_ws_io__dvdd` and
  `gf180mcu_ws_io__dvss` are functionally identical to the GF
  `__dvdd`/`__dvss` cells (same D20 ESD diode, same RC clamp string,
  same large NMOS snapback FET).

### REF-PDK-3 — `gf180mcu_fd_sc_mcu7t5v0.cdl`
- **Verification:** verified-direct-read on 2026-05-02 (header +
  grep for level-shift / iso / retn cell types).
- **Relevance:** 229 .SUBCKT entries, **none of which are
  level-shifter, isolation, or retention cells.** Only logic gates
  plus `tieh / tiel / filltie` (the only special cells).

### REF-PDK-4 — `gf180mcu_fd_sc_mcu9t5v0.cdl`
- **Verification:** verified-direct-read on 2026-05-02.
- **Relevance:** same conclusion — no level-shifter / isolation /
  retention cells. The 9t variant is identical to the 7t variant
  in this respect.

### REF-PDK-5 — `gf180mcu_fd_sc_mcu7t5v0__nom.tlef`
- **Verification:** verified-direct-read on 2026-05-02.
- **Relevance:** confirms 5 metal layers (Metal1–Metal5), Pwell
  and Nwell as masterslice layers. No DNWELL in the masterslice
  list, but DNWELL exists in DRC rules — used only for explicit
  DNWELL-isolation pockets, not standard cells.

### REF-PDK-6 — `dnwell.drc`
- **Path:** `libs.tech/klayout/tech/drc/rule_decks/dnwell.drc`
- **Verification:** verified-direct-read on 2026-05-02.
- **Relevance:** rule DN.2b "Min. DNWELL Space (Different
  potential): 5.42 µm". Rule DN.3 requires PCOMP guard ring around
  DNWELL. Confirms triple-well isolation is supported.

### REF-PDK-7 — `guard_ring.drc`
- **Verification:** verified-direct-read on 2026-05-02.
- **Relevance:** GR.2 "Min GUARD_RING_MK space to prime die COMP,
  NWELL, Poly2, Metal 1–5: 10 µm". Confirms seal ring exists as
  a defined zone with strict spacing rules.

### REF-PDK-8 — `gf180mcu_fd_io__brk5.lef`
- **Verification:** verified-direct-read on 2026-05-02.
- **Relevance:** confirms VSS port appears on Metal3, Metal4,
  Metal5 (not Metal2). Confirms cell is 5 µm wide × 350 µm tall —
  fits in the standard pad-ring.

## External references (not used at Stage 1)

None. This report is first-principles; literature is delegated to
sibling surveys.

## Verification methodology

For every PDK and project file cited above:
- Path absolute-checked.
- File opened in this conversation (Read or Bash with grep).
- Specific lines or netlist elements quoted in `report.md` with
  file path and (where relevant) line range.
- No SHAs computed yet (Stage-1 first-principles does not require
  SHA-mirroring; that is a Stage-2/3 reviewer task).

## Open verification work for downstream stages

- Compute SHA-256 of REF-PDK-1, REF-PDK-2, REF-PDK-8 to detect any
  drift between the precheck mirror and upstream PDK.
- Confirm with wafer.space whether `gf180mcu_ws_io__dvdd` is a
  drop-in for `gf180mcu_fd_io__dvdd` for the v2 multi-domain
  variant.
- Spot-check that the 9t cell library doesn't surprise us with
  cells the 7t variant lacks.
