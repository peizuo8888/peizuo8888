module mod3(clk,rst_n,out_0,out_1,out_2,out_3);
input clk;
input rst_n;
reg [2:0] address;
output reg [6:0] out_0;
output reg [6:0] out_1;
output reg [6:0] out_2;
output reg [6:0] out_3;
wire [3:0] q;
reg [3:0]l0;
reg [3:0]l1;
reg [3:0]l2;
reg [3:0]l3;
wire clk_out;
seven_seg M31(clk, rst_n, l0, out_0);
seven_seg M32(clk, rst_n, l1, out_1);
seven_seg M33(clk, rst_n, l2, out_2);
seven_seg M34(clk, rst_n, l3, out_3);
reg [3:0] counter;
reg [3:0] cr_state;
reg [3:0] nt_state;
parameter       ex_right = 4'b0001,
                right  = 4'b0010,
                ex_left  = 4'b0100,
                left  = 4'b1000;
always @(posedge clk_out or negedge rst_n) begin
    if (!rst_n) begin
        address <= 3'b0; 
        l0 <= 4'b0;
        l1 <= 4'b0;
        l2 <= 4'b0;
        l3 <= q;
        cr_state <= ex_right;
    end else begin
        nt_state <= cr_state;
        case (cr_state)
            ex_right: begin
                address+1'b1;
                l0 <= l1;
                l1 <= l2;
                l2 <= l3;
                l3 <= q;
            end
            right: begin
                address+1'b1;
                l0 <= l1;
                l1 <= l2;
                l2 <= l3;
                l3 <= 0;
            end
            ex_left: begin
                address-1'b1;
                l0 <= q;
                l1 <= l0;
                l2 <= l1;
                l3 <= l2;
            end
            left: begin
                l0 <= 0;
                l1 <= l0;
                l2 <= l1;
                l3 <= l2;
            end
            default: ;
        endcase
    end
end




clk_gen M35(
	parameter CNT_MAX = 25'd24_999_999
)(
	clk, rst_n, clk_out
);

ram M23(
	address,
	clk,
	0,
	0,
	q);
endmodule