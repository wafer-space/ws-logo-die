`default_nettype none

module wrapped_vga(
`ifdef USE_POWER_PINS
	inout VDD,
	inout VSS,
`endif
	input clk_i,
	input rst_n,
	input [6:0] inputs,
	output [7:0] outputs
);

tt_um_waferspace_vga_screensaver vga(
	.ui_in({1'b0, inputs}),
	.uo_out(outputs),
	.uio_in(8'h00),
	.uio_out(),
	.uio_oe(),
	.ena(1'b1),
	.clk(clk_i),
	.rst_n(rst_n)
);

endmodule
