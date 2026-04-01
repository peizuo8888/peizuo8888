module mod2(clk,rst_n,address,data,wren,out_0,out_1,out_2,out_3);
input clk;
input rst_n;
input wren;
input [2:0] address;
input [3:0] data;
output [6:0] out_0;
output [6:0] out_1;
output [6:0] out_2;
output [6:0] out_3;
wire [3:0] q;
seven_seg M21(clk, rst_n, q, out_0);
seven_seg M22(clk, rst_n, address, out_1);
assign out_2 =7'b1111111;
assign out_3 =7'b1111111;

ram M23(
	address,
	clk,
	data,
	wren,
	q);
endmodule
