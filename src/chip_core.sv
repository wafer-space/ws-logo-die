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

    inout  wire [NUM_ANALOG_PADS-1:0] analog,  // Analog
    
    input wire [7:0] vga_outputs,
    output wire rst_n_vga
);
    
    assign input_pu = '1;
    assign input_pd = '0;

    // Set the bidir as output
    assign bidir_sl = '0;
    assign bidir_ie = ~bidir_oe;
    
    logic _unused;
    assign _unused = &bidir_in;
    
    assign rst_n_vga = rst_n && !input_in[7];
    wire [39:0] qcpu_oe;
    wire [39:0] qcpu_pu;
    wire [39:0] qcpu_pd;
    wire [39:0] qcpu_cs;
    wire [39:0] qcpu_out;
    
    assign bidir_oe  = {input_in[7] ? qcpu_oe[39:32] : 8'hFF, qcpu_oe[31:0]};
    assign bidir_pu  = {input_in[7] ? qcpu_pu[39:32] : 8'h00, qcpu_pu[31:0]};
    assign bidir_pd  = {input_in[7] ? qcpu_pd[39:32] : 8'h00, qcpu_pd[31:0]};
    assign bidir_cs  = {input_in[7] ? qcpu_cs[39:32] : 8'h00, qcpu_cs[31:0]};
    assign bidir_out = {input_in[7] ? qcpu_out[39:32] : vga_outputs, qcpu_out[31:0]};

    wrapped_qcpu wrapped_qcpu(
        .clk_i(clk),
        .rst_n(rst_n && input_in[7]),
        .io_in(bidir_in),
        .io_out(qcpu_out),
        .io_oe(qcpu_oe),
        .io_pu(qcpu_pu),
        .io_pd(qcpu_pd),
        .io_cs(qcpu_cs),
        .inputs(input_in[7:0])
    );
    
endmodule

`default_nettype wire
