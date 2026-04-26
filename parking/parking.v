`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/27 03:31:48
// Design Name: 
// Module Name: parking
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module parking (
    input clk,
    input rst_n,
    input car_in,
    input car_out,
    input [7:0] sram_dout,
    output sram_en,
    output sram_we,
    output [7:0] sram_addr,
    output [7:0] sram_din,
    output reg [7:0] parking_space,
    output [2:0] state_dbg, 
    output reg [2:0] counter
);
parameter ADDRESS = 8'h00;
//reg [2:0] counter;
reg [2:0] cr_state;
reg [2:0] nt_state;
reg car_in_reg;
reg car_out_reg;


parameter           IDLE          = 3'd0,
                    READ_SRAM     = 3'd1,
                    UPDATE        = 3'd2,
                    WRITE_SRAM    = 3'd3,
                    DONE          = 3'd4;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cr_state        <= IDLE;     
        counter         <= 3'b0;
        car_in_reg      <= 1'b0;          
        car_out_reg     <= 1'b0;
        parking_space   <= 8'd8;        
    end else begin
        cr_state <= nt_state;
        case (cr_state)
            IDLE    :begin
                    if (car_in || car_out) begin
                        counter <= counter + 1'b1;
                    end else counter <= 3'b0;
                    car_in_reg  <= car_in;         
                    car_out_reg <= car_out;         
            end
            READ_SRAM:begin 
                    parking_space <= sram_dout;
            end
            UPDATE   :begin
                if (car_in_reg) begin
                    parking_space <= (parking_space == 8'b0) ? parking_space : parking_space - 1'b1;
                end else if (car_out_reg) begin
                    parking_space <= (parking_space == 8'd8) ? parking_space : parking_space + 1'b1;
                end
            end
            WRITE_SRAM:;
            DONE:counter <= 3'b0;
        endcase
    end
end


always @(*) begin
    case (cr_state)
        IDLE        :   nt_state = (counter     == 3'd2) ? READ_SRAM : IDLE;
        default:        nt_state = (cr_state    == 3'd4) ? 3'b0 : cr_state + 1'b1; 
    endcase
end
assign sram_we      = (cr_state == WRITE_SRAM) ? 1'b1 : 1'b0;  
assign sram_din     = parking_space;
assign sram_addr    = ADDRESS;
assign state_dbg    = cr_state;
assign sram_en      = 1'b1;
endmodule



