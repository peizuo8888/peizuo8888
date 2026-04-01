module mod1(clk,rst_n,button,out_0,out_1,out_2,out_3);
input clk;
input rst_n;
input button;
output reg [6:0] out_0;
output reg [6:0] out_1;
output reg [6:0] out_2;
output reg [6:0] out_3;
reg [3:0] counter;
wire btn_debounce;
button_debounce M11#(
    CNT_MAX = 20'd999_999
)(
    clk, rst_n, button, btn_debounce
);
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 4'b0;
    end else begin
        if (btn_debounce) begin
            counter<= counter+1'b1;
        end else begin
            counter <= counter;
        end
    end
end

always @(posedge clk or negedge) begin
    if (!rst_n) begin
        
    end else begin
      
    end
end





endmodule