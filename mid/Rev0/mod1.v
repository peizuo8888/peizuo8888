module mod1 (
           clk,
           clk_2hz,
           rst_n,
           button,
           out_0,
           out_1,
           out_2,
           out_3
       );
input clk;
input clk_2hz;
input rst_n;
input button;
output reg [6:0] out_0;
output reg [6:0] out_1;
output reg [6:0] out_2;
output reg [6:0] out_3;
reg  [2:0] num;
reg  [2:0] counter;
reg  [4:0] cr_state;
reg  [4:0] nt_state;

wire [6:0] seg_right;
wire [6:0] seg_left;


parameter
    idle        =   5'b00001,
    ex_right    =   5'b00010,
    right       =   5'b00100,
    ex_left     =   5'b01000,
    left        =   5'b10000;



always @(posedge clk_2hz or negedge rst_n)
begin
    if (!rst_n)
    begin
        out_0 <= 7'b111_1111;
        out_1 <= 7'b111_1111;
        out_2 <= 7'b111_1111;
        out_3 <= 7'b111_1111;
        cr_state <= idle;
    end
    else
    begin
        cr_state <= nt_state;
        case (cr_state)
            idle:
            begin
                out_0 <= out_0;
                out_1 <= out_1;
                out_2 <= out_2;
                out_3 <= out_3;
            end
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
always @(*)
begin
    case (cr_state)
        idle:
            nt_state <= right;
        ex_right:
            nt_state <= (counter >= num - 1) ? right : ex_right;
        right:
            nt_state <= (counter == 3'd4) ? ex_left : right;
        ex_left:
            nt_state <= (counter >= num - 1) ? left : ex_left;
        left:
            nt_state <= (counter == 3'd4) ? ex_right : left;
    endcase
end

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        num <= 3'd2;
    end
    else
    begin
        if (button)
        begin
            num <= num + 1'b1;
        end
        else
        begin
            num <= num;
        end
    end
end
always @(posedge clk_2hz or negedge rst_n)
begin
    if (!rst_n)
    begin
        counter <= 3'b1;
    end
    else
    begin
        if (cr_state != nt_state)
        begin
            counter <= 3'b1;
        end
        else
        begin
            counter <= counter + 3'b1;
        end
    end
end
seven_seg M11 (
              .clk(clk),
              .rst_n(rst_n),
              .data(counter),
              .o(seg_right)
          );
seven_seg M12 (
              .clk(clk),
              .rst_n(rst_n),
              .data(num - counter),
              .o(seg_left)
          );
endmodule
