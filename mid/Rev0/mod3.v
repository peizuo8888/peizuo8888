module mod3(clk,rst_n,data,address,out_0,out_1,out_2,out_3);
input clk;
input rst_n;
input  [6:0] data;
output reg [2:0] address;
output reg [6:0] out_0;
output reg [6:0] out_1;
output reg [6:0] out_2;
output reg [6:0] out_3;

wire clk_out;

reg [2:0] counter;
reg [3:0] cr_state;
reg [3:0] nt_state;
parameter       idle        =   5'b00001,
                ex_right    =   5'b00010,
                right       =   5'b00100,
                ex_left     =   5'b01000,
                left        =   5'b10000;

always @(posedge clk_out or negedge rst_n)
begin
    if (!rst_n)
    begin
        counter <= 4'b1;
    end
    else
    begin
        if (nt_state != cr_state)
            counter <= 4'b1;
        else
            counter <= counter + 1'b1;

    end
end

always @(*)
begin
    case (cr_state)
        ex_left :
            address = (3'd7-counter);
        default :
            address = counter;
    endcase
end

always @(posedge clk_out or negedge rst_n)
begin
    if (!rst_n)
    begin
        out_0 <= 4'b0;
        out_1 <= 4'b0;
        out_2 <= 4'b0;
        out_3 <= data;
        cr_state <= ex_right;
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
                out_3 <= data;
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
                out_0 <= data;
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
always @(*)
begin
    case (cr_state)
        idle    :
            nt_state <= ex_right;
        ex_right:
            nt_state <= (counter == 4'd7)? right: ex_right;
        right   :
            nt_state <= (counter == 4'd3)? ex_left: right;
        ex_left :
            nt_state <= (counter == 4'd7)? left: ex_left;
        left    :
            nt_state <= (counter == 4'd3)? ex_right: left;
    endcase
end
endmodule
