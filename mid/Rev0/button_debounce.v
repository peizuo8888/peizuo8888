module button_debounce#(
    parameter  CNT_MAX = 20'd999_999
)(
    clk, rst_n, button, btn_debounce
);

input    clk, rst_n, button;
output   reg btn_debounce;

reg      [19:0]    counter;
wire     [19:0]    counter_inc       = counter + 1'b1;
wire               counter_end       = (counter == CNT_MAX) ? 1'b1 : 1'b0;
wire     [19:0]    counter_next      = counter_end ? counter : counter_inc;

wire               btn_debounce_next = (counter == CNT_MAX - 1'b1) ? 1'b1 : 1'b0;

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)       counter <= 20'b0;
	 else if(!button) counter <= counter_next;
	 else             counter <= 20'b0;
end

always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)       btn_debounce <= 20'b0;
	 else             btn_debounce <= btn_debounce_next;
end

endmodule
