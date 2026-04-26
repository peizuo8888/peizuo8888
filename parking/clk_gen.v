`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/27 03:44:22
// Design Name: 
// Module Name: clk_gen
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


module clk_gen#(
	parameter CNT_MAX = 25'd24_999_999
)(
	clk, rst_n, clk_out
);

input  clk, rst_n;
output reg clk_out;

reg  [24:0] counter;
wire [24:0] counter_inc  = counter + 1'b1;
wire        counter_end  = (counter == CNT_MAX) ? 1'b1 : 1'b0;
wire [24:0] counter_next = counter_end ? 20'd0 : counter_inc;


always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
        counter <= 25'd0;
        clk_out<= 1'b0;
    end 
	else begin
        counter <= counter_next;
		if (counter_end) clk_out <= ~clk_out;
	end
end

endmodule
