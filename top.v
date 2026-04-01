module top(clk,rst_n,sw,out_3,out_2,out_1,out_0,address,data,wren);
input clk;
input rst_n;
input [1:0]sw;
input [3:0] data;
input [2:0] address;
input wren;



output reg[6:0] out_0;
output reg[6:0] out_1;
output reg[6:0] out_2;
output reg[6:0] out_3;

wire [6:0] out_0_0;
wire [6:0] out_0_1;
wire [6:0] out_0_2;
wire [6:0] out_0_3;
wire [6:0] out_1_0;
wire [6:0] out_1_1;
wire [6:0] out_1_2;
wire [6:0] out_1_3;
wire [6:0] out_2_0;
wire [6:0] out_2_1;
wire [6:0] out_2_2;
wire [6:0] out_2_3;
wire [6:0] out_3_0;
wire [6:0] out_3_1;
wire [6:0] out_3_2;
wire [6:0] out_3_3;

always @(*) begin
    case (sw)
        2'b00:begin
            out_0 =out_0_0; 
            out_1 =out_0_1; 
            out_2 =out_0_2; 
            out_3 =out_0_3; 
        end
        2'b10:begin
            out_0 =out_2_0; 
            out_1 =out_2_1; 
            out_2 =out_2_2; 
            out_3 =out_2_3; 
        end
        default: ;
    endcase
end

mod0 M0(.clk(clk),.rst_n(rst_n),.out_0(out_0_0),.out_1(out_0_1),.out_2(out_0_2),.out_3(out_0_3)) ;
mod2 M2(.clk(clk),.rst_n(rst_n),.address(address),.data(data),.wren(wren),.out_0(out_2_0),.out_1(out_2_1),.out_2(out_2_2),.out_3(out_2_3));

endmodule