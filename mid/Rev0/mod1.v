module mod1(clk,rst_n,button,out_0,out_1,out_2,out_3);
input clk;
input rst_n;
input button;
output reg [6:0] out_0;
output reg [6:0] out_1;
output reg [6:0] out_2;
output reg [6:0] out_3;
reg [2:0] num;
reg [2:0] counter;
reg [3:0] cr_state;
reg [3:0] nt_state;

wire [6:0] seg_right;
wire [6:0] seg_left;


parameter       idle        =   5'b00001,
                ex_right    =   5'b00010,
                right       =   5'b00100,
                ex_left     =   5'b01000,
                left        =   5'b10000;



always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        out_0 <= 4'b0;
        out_1 <= 4'b0;
        out_2 <= 4'b0;
        out_3 <= 4'b0;
        cr_state <= idle;
    end
    else
    begin
        cr_state <= nt_state;
        case (cr_state)
            ex_right:
            begin
                out_0 <= out_1;
                out_1 <= out_2;
                out_2 <= out_3;
                out_3 <= seg_right;
            end
            right:
            begin
                out_0 <= out_1;
                out_1 <= out_2;
                out_2 <= out_3;
                out_3 <= 7'b111_1111;
            end
            ex_left:
            begin
                out_0 <= seg_left;
                out_1 <= out_0;
                out_2 <= out_1;
                out_3 <= out_2;
            end
            left:
            begin
                out_0 <= 7'b111_1111;
                out_1 <= out_0;
                out_2 <= out_1;
                out_3 <= out_2;
            end
        endcase
    end
end


always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        num <= 3'b1;
    end
    else
    begin
        if (button)
        begin
            num<= num+1'b1;
        end
        else
        begin
            num <= num;
        end
    end
end
always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        counter <= 3'b1;
    end
    else
    begin
        if (cr_state != nt_state)
        begin
            counter<= 3'b1;
        end
        else
        begin
            counter <= counter + 3'b1;
        end
    end
end
seven_seg M11(.clk(clk), .rst_n(rst_n), .data(counter), .o(seg_right));
seven_seg M12(.clk(clk), .rst_n(rst_n), .data(num-counter), .o(seg_left));
endmodule
