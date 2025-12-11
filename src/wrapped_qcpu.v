`default_nettype none

module wrapped_qcpu(
  input clk_i, //Clock input
  input rst_n, //Active low
  input [39:0] io_in,
  output [39:0] io_out,
  output [39:0] io_oe,
  output [39:0] io_pu,
  output [39:0] io_pd,
  output [39:0] io_cs,
  input [7:0] inputs
);

reg [7:0] RAM [127:0];
wire [6:0] sram_addr;
wire [7:0] sram_in;
wire [7:0] sram_out = RAM[sram_addr];
wire sram_gwe;
always @(posedge clk_i) begin
  if(rst_n) begin
    if(sram_gwe) RAM[sram_addr] <= sram_in;
  end
end

wire CS_ROM;
wire SCLK_ROM;
wire [3:0] ROM_DO;
wire ROM_OEB;
wire ROM_spi_mode;

wire [7:0] PORTA_DDR;
wire [7:0] PORTB_DDR;
wire [6:0] PORTC_DDR;
wire [7:0] PORTA;
wire [7:0] PORTB;
wire [6:0] PORTC;
wire txd;
wire spi_sclk;
wire spi_do;
wire M1;
wire pwm;
wire toggle;

assign io_out = {PORTC, ROM_spi_mode ? 1'b0 : ROM_OEB, toggle, pwm, 1'b0, 1'b0, M1, 1'b0, spi_do, spi_sclk, 1'b0, txd, PORTB, PORTA, SCLK_ROM, CS_ROM, ROM_DO};
assign io_oe = ~{~PORTC_DDR, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, ~PORTB_DDR, ~PORTA_DDR, 1'b0, 1'b0, ROM_spi_mode ? 1'b0 : ROM_OEB, ROM_spi_mode ? 1'b0 : ROM_OEB, ROM_spi_mode ? 1'b1 : ROM_OEB, ROM_spi_mode ? 1'b0 : ROM_OEB};
assign io_pu[23] = 1'b1;
assign io_pu[28] = 1'b1;
assign io_pu[13:6] = ~PORTA_DDR & PORTA;
assign io_pu[21:14] = ~PORTB_DDR & PORTB;
assign io_pu[39:33] = ~PORTC_DDR & PORTC;
assign io_pu[5:0] = 0;
assign io_pu[22] = 0;
assign io_pu[27:24] = 0;
assign io_pu[32:29] = 0;

assign io_pd[3:0] = ~io_oe[3:0];
assign io_pd[13:6] = ~PORTA_DDR & ~PORTA;
assign io_pd[21:14] = ~PORTB_DDR & ~PORTB;
assign io_pd[39:33] = ~PORTC_DDR & ~PORTC;
assign io_pd[26] = 1'b0;
assign io_pd[29] = 1'b0;
assign io_pd[5:4] = 0;
assign io_pd[25:22] = 0;
assign io_pd[28:27] = 0;
assign io_pd[32:30] = 0;

assign io_cs[3:0] = ~io_oe[3:0];
assign io_cs[23] = 1'b1;
assign io_cs[26] = 1'b1;
assign io_cs[27] = 0;
assign io_cs[28] = 1'b1;
assign io_cs[29] = 1'b1;
assign io_cs[39:33] = ~PORTC_DDR;
assign io_cs[22:4] = 0;
assign io_cs[25:24] = 0;
assign io_cs[32:30] = 0;

qcpu cpu(
  .clk(clk_i),
  .rst_n(rst_n),
  
  .CS_ROM(CS_ROM),
  .SCLK_ROM(SCLK_ROM),
  .ROM_DO(ROM_DO),
  .ROM_DI(io_in[3:0]),
  .ROM_OEB(ROM_OEB),
  .ROM_spi_mode(ROM_spi_mode),

  .PORTA_DDR(PORTA_DDR),
  .PORTB_DDR(PORTB_DDR),
  .PORTC_DDR(PORTC_DDR),
  .PORTA(PORTA),
  .PORTB(PORTB),
  .PORTC(PORTC),
  .PINA(io_in[13:6]),
  .PINB(io_in[21:14]),
  .PINC({io_in[26], io_in[39:33]}),
  .PIND(inputs),
  
  .RAM_we(sram_gwe),
  .RAM_addr(sram_addr),
  .RAM_in(sram_in),
  .RAM_out(sram_out),

  .rxd(io_in[23]),
  .txd(txd),
  .spi_sclk(spi_sclk),
  .spi_do(spi_do),
  .spi_di(io_in[26]),

  .M1(M1),

  .intb(io_in[28]),
  .pause(io_in[29]),
  .pwm(pwm),
  .toggle(toggle)
);

endmodule
