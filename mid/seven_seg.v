module seven_seg(
    clk, rst_n, data, o
);

input            clk;
input            rst_n;
input      [3:0] data;
output reg [7:0] o;

reg        [3:0] tmp;

always@(*)
begin
    case(tmp)
        4'h0:    o = 8'b11111_111;
        4'h1:    o = 8'b11111_001;
        4'h2:    o = 8'b10100_100;
        4'h3:    o = 8'b10110_000;
        4'h4:    o = 8'b10011_001;
        4'h5:    o = 8'b10010_010;
        4'h6:    o = 8'b10000_010;
        4'h7:    o = 8'b11111_000;
        4'h8:    o = 8'b10000_000;
        4'h9:    o = 8'b10010_000;
        4'hA:    o = 8'b10001_000;
        4'hB:    o = 8'b10000_011;
        4'hC:    o = 8'b11000_110;
        4'hD:    o = 8'b10100_001;
        4'hE:    o = 8'b10000_110;
        4'hF:    o = 8'b10001_110;
        default: o = 8'b11111_111;
    endcase
end

always@(posedge clk or negedge rst_n)begin
	if(!rst_n) tmp <= 4'b0;
	else       tmp <= data;
end

endmodule