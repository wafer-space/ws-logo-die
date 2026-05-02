# References (item g, Stage 1 first-principles)

```
[1] Tiny Tapeout project template, "Module template for tt_um_*",
    URL: https://github.com/TinyTapeout/tt-template (and the in-tree
    upstream at vga_screensaver/tt-waferspace-vga-screensaver/src/
    tt_um_waferspace_vga_screensaver.v lines 15-24).
    Type: open-source HDL template / in-tree primary source.
    Accessibility: open. Verification: confirmed by reading the in-
    tree file (lines 15-24 declare the standard ui_in/uo_out/uio_in/
    uio_out/uio_oe/ena/clk/rst_n port set; line 70 demonstrates the
    standard `_unused_ok = &{...}` discard idiom for un-consumed
    bits). Local cache: in-tree at the path above; external upstream
    not separately fetched (would require WebFetch — not done in this
    Stage-1 single-angle pass).
    Relevance: confirms that `ui_in[7:0]` is an array of dedicated
    input bits with no positional contract — wrappers may tie any
    subset to internal logic, constants, or external pads at will.
    This is the only "literature" reference appropriate to item (g);
    everything else is local source.

[2] Cadence LEF/DEF Language Reference, "MACRO and PIN statements",
    https://www.ispd.cc/contests/14/web/doc/lefdefref.pdf
    Type: tool-vendor reference manual (open redistribution).
    Accessibility: open. Verification: NOT independently fetched in
    this Stage-1 pass — claim derived from first-principles knowledge
    that LEF MACRO blocks enumerate PINs explicitly per signal (no
    bus-parameter syntax); a Stage-2/3 reviewer should fetch and
    spot-check. SHA-256 to record on first download.
    Relevance: backs the claim in §5.2 that any port-width change in
    `wrapped_vga.inputs` *must* alter the LEF (and analogously the
    Liberty file) at the line level, so a port-width change forces a
    re-harden. The corresponding Liberty reference (Synopsys Liberty
    User Guide) is omitted here for brevity but makes the same per-
    pin enumeration argument.
```

Note on reference depth: the brief (per the per-item README) accepts
"a single literature reference confirming the tt_um_* upstream's
port-list semantics." Reference [1] discharges that. Reference [2]
is added because the hardened-views question (§5.2) materially
benefits from a citation, even if uncached. A full Stage-2/3 pass
should cache both and verify SHA-256.
