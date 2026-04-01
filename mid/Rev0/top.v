module top(clk,rst_n,sw,out_3,out_2,out_1,out_0,address,data,wren,button);
input clk;
input rst_n;
input [1:0]sw;
input [3:0] data;
input [2:0] address;
input wren;
input button;


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

wire       clk_2hz;
wire       btn_debounce;

wire [2:0] in2_address;
wire [2:0] out3_address;



always @(*)
begin
    case (sw)
        2'b00:
        begin
            out_0 =out_0_0;
            out_1 =out_0_1;
            out_2 =out_0_2;
            out_3 =out_0_3;
        end
        2'b01:
        begin
            out_0 =out_1_0;
            out_1 =out_1_1;
            out_2 =out_1_2;
            out_3 =out_1_3;
        end
        2'b10:
        begin
            out_0 =out_2_0;
            out_1 =out_2_1;
            out_2 =out_2_2;
            out_3 =out_2_3;
        end
        2'b11:
        begin
            out_0 =out_3_0;
            out_1 =out_3_1;
            out_2 =out_3_2;
            out_3 =out_3_3;
        end
    endcase

end

assign in2_address = (sw == 2'b11) ? out3_address : in2_address;


mod0 M0(.clk(clk), .rst_n(rst_n), .out_0(out_0_0), .out_1(out_0_1), .out_2(out_0_2), .out_3(out_0_3));
mod1 M1(.clk(clk), .rst_n(rst_n), .button(btn_debounce),.out_0(out_1_0),.out_1(out_1_1),.out_2(out_1_2),.out_3(out_1_3));
mod2 M2(.clk(clk), .rst_n(rst_n), .address(in2_address), .data(data), .out_0(out_2_0), .out_1(out_2_1), .out_2(out_2_2), .out_3(out_2_3));
mod3 M3(.clk(clk_2hz), .rst_n(rst_n),.data(out_2_0),.address(out3_address) ,.out_0(out_3_0), .out_1(out_3_1), .out_2(out_3_2), .out_3(out_3_3));

ram M23(.address(address),.clk(clk),.data(data),.wren(wren),.q(q));
clk_gen #(.CNT_MAX(25'd24_999_999) )M00(.clk(clk), .rst_n(rst_n), .clk_out(clk_2hz));
button_debounce #(.CNT_MAX(20'd999_999)) M000(.clk(clk), .rst_n(rst_n), .button(button), .btn_debounce(btn_debounce));
endmodule
