module mod0(clk,rst_n,out_0,out_1,out_2,out_3);
input clk;
input rst_n;
output reg [6:0] out_0;
output reg [6:0] out_1;
output reg [6:0] out_2;
output reg [6:0] out_3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out_0 <= 7'b0;
        out_1 <= 7'b0;
        out_2 <= 7'b0;
        out_3 <= 7'b0;
    end else begin
        out_3 <= 7'b100_0000;
        out_2 <= 7'b111_0111;
        out_1 <= 7'b111_0111;
        out_0 <= 7'b010_0011;
    end
end
endmodule