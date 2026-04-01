module clk_gen#(
	parameter CNT_MAX = 25'd24_999_999
)(
	clk, rst_n, clk_out
);

input  clk, rst_n;
output clk_out;

reg  [24:0] counter;
wire [24:0] counter_inc  = counter + 1'b1;
wire        counter_end  = (counter == CNT_MAX) ? 1'b1 : 1'b0;
wire [24:0] counter_next = counter_end ? 20'd0 : counter_inc;

assign      clk_out = counter_end;

always@(posedge clk or negedge rst_n)begin
	if(!rst_n) counter <= 25'd0;
	else       counter <= counter_next;
end

endmodule