`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/27 03:29:03
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top #(
    parameter integer CLK_HZ            = 125_000_000,
    parameter integer SCAN_HZ_PER_DIGIT = 1000
)(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       car_in,
    input  wire       car_out,
    output reg  [7:0] seg,
    output reg  [3:0] dig
    );
    
    localparam integer SCAN_DIV = CLK_HZ / (SCAN_HZ_PER_DIGIT * 4);
    
    reg [$clog2(SCAN_DIV)-1:0] scan_cnt;
    reg [1:0]                  scan_sel;
    
    wire [7:0] seg0_pattern;
    wire [7:0] seg1_pattern;
    wire [7:0] seg2_pattern;
    wire [7:0] seg3_pattern;


//////////////////////////////////////////////////////////////////////////////////
    wire clk_2hz;
    wire sram_en;
    wire sram_we;
    wire [7:0] sram_dout;
    wire [7:0] sram_addr;
    wire [7:0] sram_din;
    wire [7:0] parking_space;
    wire [2:0] state_dbg;
    wire [2:0] counter;
    blk_mem_gen_0 blk_mem_gen_0_inst (
        .clka(clk_2hz),    
        .ena(sram_en),      
        .wea(sram_we),      
        .addra(sram_addr),  
        .dina(sram_din),    
        .douta(sram_dout)  
    );
    parking  parking_inst (
        .clk(clk_2hz),
        .rst_n(rst_n),
        .car_in(car_in),
        .car_out(car_out),
        .sram_dout(sram_dout),
        .sram_en(sram_en),
        .sram_we(sram_we),
        .sram_addr(sram_addr),
        .sram_din(sram_din),
        .parking_space(parking_space),
        .state_dbg(state_dbg),
        .counter(counter)
    );
    clk_gen  #(
	    .CNT_MAX(25'd31_249_999)
    )clk_gen_inst(
        .clk(clk),
        .rst_n(rst_n),
        .clk_out(clk_2hz)
    );
    seven_seg  seven_seg_inst_0 (
        .clk(clk),
        .rst_n(1),
        .data(counter),
        .o(seg0_pattern)
        );
    seven_seg  seven_seg_inst_1 (
        .clk(clk),
        .rst_n(1),
        .data(state_dbg),
        .o(seg1_pattern)
    );
    seven_seg  seven_seg_inst_2 (
        .clk(clk),
        .rst_n(1),
        .data(parking_space),
        .o(seg2_pattern)
    );
    seven_seg  seven_seg_inst_3 (
        .clk(clk),
        .rst_n(1),
        .data(sram_dout),
        .o(seg3_pattern)
    );
//////////////////////////////////////////////////////////////////////////////////      
        











    //============================================================
    // 掃描計數器
    //============================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            scan_cnt <= {($clog2(SCAN_DIV)){1'b0}};
            scan_sel <= 2'd0;
        end else if (scan_cnt == SCAN_DIV - 1) begin
            scan_cnt <= {($clog2(SCAN_DIV)){1'b0}};
            scan_sel <= scan_sel + 1'b1;
        end else begin
            scan_cnt <= scan_cnt + 1'b1;
        end
    end

    //============================================================
    // 掃描輸出
    // 共陽極 + PNP:
    //   seg 要反相
    //   dig 要 active-low
    //============================================================
    always @(*) begin
        seg = 8'hFF;      // 全滅
        dig = 4'b1111;    // 全關

        case (scan_sel)
            2'd0: begin
                seg = seg0_pattern;
                dig = 4'b1110;
            end

            2'd1: begin
                seg = seg1_pattern;
                dig = 4'b1101;
            end

            2'd2: begin
                seg = seg2_pattern;
                dig = 4'b1011;
            end

            2'd3: begin
                seg = seg3_pattern;
                dig = 4'b0111;
            end

            default: begin
                seg = 8'hFF;
                dig = 4'b1111;
            end
        endcase
    end

endmodule


