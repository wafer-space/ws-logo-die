// SPDX-FileCopyrightText: © 2025 XXX Authors
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

module chip_core #(
    parameter NUM_INPUT_PADS,
    parameter NUM_BIDIR_PADS,
    parameter NUM_ANALOG_PADS
    )(
    `ifdef USE_POWER_PINS
    inout  wire VDD,
    inout  wire VSS,
    `endif

    input  wire clk,       // clock
    input  wire rst_n,     // reset (active low)

    input  wire [NUM_INPUT_PADS-1:0] input_in,   // Input value
    output wire [NUM_INPUT_PADS-1:0] input_pu,   // Pull-up
    output wire [NUM_INPUT_PADS-1:0] input_pd,   // Pull-down

    input  wire [NUM_BIDIR_PADS-1:0] bidir_in,   // Input value
    output wire [NUM_BIDIR_PADS-1:0] bidir_out,  // Output value
    output wire [NUM_BIDIR_PADS-1:0] bidir_oe,   // Output enable
    output wire [NUM_BIDIR_PADS-1:0] bidir_cs,   // Input type (0=CMOS Buffer, 1=Schmitt Trigger)
    output wire [NUM_BIDIR_PADS-1:0] bidir_sl,   // Slew rate (0=fast, 1=slow)
    output wire [NUM_BIDIR_PADS-1:0] bidir_ie,   // Input enable
    output wire [NUM_BIDIR_PADS-1:0] bidir_pu,   // Pull-up
    output wire [NUM_BIDIR_PADS-1:0] bidir_pd,   // Pull-down

    inout  wire [NUM_ANALOG_PADS-1:0] analog,    // Analog (unused)

    input  wire [7:0] vga_outputs,
    output wire       rst_n_vga
);

    // VGA macro shares the chip-level reset.
    assign rst_n_vga = rst_n;

    // Drive vga_outputs onto the top 8 bidir pads. Lower bidir pads are
    // not used: output disabled, input buffer disabled, no pulls.
    assign bidir_out = {vga_outputs, {(NUM_BIDIR_PADS-8){1'b0}}};
    assign bidir_oe  = { {8{1'b1}}, {(NUM_BIDIR_PADS-8){1'b0}} };
    assign bidir_ie  = '0;
    assign bidir_pu  = '0;
    assign bidir_pd  = '0;
    assign bidir_cs  = '0;
    assign bidir_sl  = '0;

    // Unused input pads default to a defined state via the pad-side pull-ups.
    assign input_pu = '1;
    assign input_pd = '0;

    // bidir_in / input_in have no consumer in this design.
    logic _unused;
    assign _unused = &{bidir_in, input_in};

endmodule

`default_nettype wire
