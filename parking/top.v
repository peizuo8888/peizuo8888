module top (
    input clk,
    input rst_n,
    input car_in,
    input car_out,
    output [7:0] parking_space_seg,
    output [7:0] state_dbg_seg 
);
wire clk_out;

wire [7:0] sram_dout;
wire [7:0] sram_we;
wire [7:0] sram_addr;
wire [7:0] sram_din;
wire [7:0] parking_space;
wire [7:0] state_dbg;



parking  parking_inst (
  .clk(clk_out),
    .rst_n(rst_n),
    .car_in(~car_in),
    .car_out(~car_out),
    .sram_dout(sram_dout),
    .sram_en(),
    .sram_we(sram_we),
    .sram_addr(sram_addr),
    .sram_din(sram_din),
    .parking_space(parking_space),
    .state_dbg(state_dbg)
  );

  SRAM  SRAM_inst (
    .addr(sram_addr),
    .data_in(sram_din),
    .WE(sram_we),
    .rst_n(rst_n),
    .clk(clk_out),
    .empty(),
    .data_out(sram_dout)
  );

  clk_gen  clk_gen_inst (
    .clk(clk),
    .rst_n(rst_n),
    .clk_out(clk_out)
  );


  seven_seg  seven_seg_inst (
    .clk(clk),
    .rst_n(rst_n),
    .data(parking_space),
    .o(parking_space_seg)
  );
  seven_seg  seven_seg_inst_1 (
    .clk(clk),
    .rst_n(rst_n),
    .data(state_dbg),
    .o(state_dbg_seg)
  );
endmodule



