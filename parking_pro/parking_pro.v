`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/30 03:15:17
// Design Name: 
// Module Name: parking_pro
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


module parking_pro(
    input               clk,
    input               rst_n,
    input       [7:0]   car_plate,      //DONE
    input               car_in,         //DONE
    input               car_out,        //DONE
    input       [7:0]   sram_dout,      //DONE
    output              sram_en,        //DONE
    output              sram_we,        //DONE
    output      [7:0]   sram_addr,      //DONE     
    output      [7:0]   sram_din,       //DONE
    output reg  [7:0]   parking_space,  //DONE
    output      [3:0]   state_dbg,      //DONE
    output reg  [2:0]   counter,        //DONE
    output reg          led             //DONE
    );
;

reg     [3:0]   cr_state;               //DONE            
//reg     [3:0]   nt_state;
reg             car_out_reg;            //DONE
reg             car_in_reg;             //DONE
reg     [7:0]   car_plate_reg;          //DONE

reg     [7:0]   bitmap_reg;             //DONE
wire    [7:0]   bitmap_in;              //DONE
wire    [7:0]   bitmap_out;             //DONE
reg     [3:0]   empty_space;            //DONE
reg     [3:0]   car_space_record;       //DONE
reg     [3:0]   addr_cnt;               //DONE 
reg             sram_wait;              //DONE
localparam          IDLE                = 4'd0,
                    READ_SRAM           = 4'd1,
                    READ_BITMAP         = 4'd2,
                    READ_CAR_PLATE      = 4'd3,
                    UPDATA              = 4'd4,
                    WRITE_SRAM          = 4'd5,
                    WRITE_BITMAP        = 4'd6,
                    WRITE_CAR_PLATE     = 4'd7,
                    DONE                = 4'd8;
///////////////////////////////////////////////////////////////////////////////////////
function  [3:0]  find_empty_space;
    input [7:0] value;
    casex (~value)
        8'bxxxx_xxx1:   find_empty_space = 4'd9; 
        8'bxxxx_xx10:   find_empty_space = 4'd8;
        8'bxxxx_x100:   find_empty_space = 4'd7;
        8'bxxxx_1000:   find_empty_space = 4'd6;   
        8'bxxx1_0000:   find_empty_space = 4'd5; 
        8'bxx10_0000:   find_empty_space = 4'd4; 
        8'bx100_0000:   find_empty_space = 4'd3; 
        8'b1000_0000:   find_empty_space = 4'd2; 
        default: find_empty_space = 4'd11;
    endcase
endfunction
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cr_state            <= IDLE;     
        counter             <= 3'b0;
        car_in_reg          <= 1'b0;          
        car_out_reg         <= 1'b0;
        car_plate_reg       <= 8'b1111_1111;
        parking_space       <= 8'd8;
        addr_cnt            <= 4'b0;
        car_space_record    <= 4'd11;
        led                 <= 1'b0;   
        bitmap_reg          <= 8'b0;
        sram_wait           <= 1'b0;
    end else begin
        case (cr_state)
            IDLE    :begin
                if (car_in || car_out) begin
                    counter <= counter + 1'b1;
                    if(counter == 3'd2) cr_state <= READ_SRAM;
                end else                counter <= 3'b0;
                car_in_reg      <= car_in;         
                car_out_reg     <= car_out;
                car_plate_reg   <= car_plate;
                addr_cnt        <= 8'd0;
                sram_wait       <= 1'b0;
                led             <= 1'b0;
            end
            READ_SRAM:begin 
                parking_space   <= sram_dout;
                if ((sram_dout == 8'd8) && car_out_reg || (sram_dout == 8'b0) && car_in_reg)begin
                    cr_state <= IDLE;
                    counter  <= 3'b0;
                end 
                else cr_state   <= READ_BITMAP;
                sram_wait   <= 1'b1;
                addr_cnt    <= 8'd1; 
                end
            READ_BITMAP:begin
                if (sram_wait) begin
                    sram_wait <= 1'b0;
                end else begin
                    sram_wait <= 1'b1;
                    bitmap_reg  <= sram_dout;
                    empty_space <= find_empty_space(sram_dout);
                    addr_cnt    <= 8'd2;    
                    cr_state    <= READ_CAR_PLATE;
                end
            end
            READ_CAR_PLATE:begin
                if (sram_wait) begin
                    sram_wait <= 1'b0;
                end else begin
                    if (sram_dout == car_plate_reg) begin
                        if (car_in_reg) begin
                            cr_state <= IDLE;
                            counter  <= 3'b0;
                        end else cr_state <= UPDATA;    
                    end else if (addr_cnt == 8'd9) begin
                        if (car_out_reg) begin
                            cr_state <= IDLE;
                            counter  <= 3'b0;
                        end else cr_state <= UPDATA;
                    end
                    addr_cnt         <= addr_cnt +1'b1;
                    car_space_record <= addr_cnt;
                    sram_wait        <= 1'b1;
                end
            end
            UPDATA:begin
                if (car_in_reg)         parking_space <= parking_space - 1'b1; 
                else                    parking_space <= parking_space + 1'b1;
                cr_state <= WRITE_SRAM;
                addr_cnt <= 8'd0;
            end
            WRITE_SRAM:begin
                addr_cnt <= 8'd1;
                cr_state <= WRITE_BITMAP;
            end
            WRITE_BITMAP:begin
                if (car_in_reg)     addr_cnt    <= empty_space; 
                else                addr_cnt    <= car_space_record;
                cr_state <= WRITE_CAR_PLATE;
            end
            WRITE_CAR_PLATE:begin
                cr_state <= DONE;
            end
            DONE:begin 
                counter     <= 3'b0;
                led         <= 1'b1;
                cr_state    <= IDLE; 
            end
        endcase
    end
end

assign bitmap_in    = bitmap_reg | (8'b1000_0000 >> (empty_space-2));
assign bitmap_out   = bitmap_reg & ~(8'b1000_0000 >> (car_space_record-2)); 

assign sram_we      = ( cr_state == WRITE_SRAM          ||
                        cr_state == WRITE_BITMAP        || 
                        cr_state == WRITE_CAR_PLATE) ? 1'b1 : 1'b0;
assign sram_addr    = addr_cnt;
assign sram_din     =   (cr_state == WRITE_SRAM)                     ? parking_space :
                        (cr_state == WRITE_BITMAP && car_in_reg)     ? bitmap_in     :
                        (cr_state == WRITE_BITMAP && car_out_reg)    ? bitmap_out    :
                        (cr_state == WRITE_CAR_PLATE && car_in_reg)  ? car_plate_reg :
                        (cr_state == WRITE_CAR_PLATE && car_out_reg) ? 8'b1111_1111 : 8'b1111_1111;
// assign sram_din     =   (cr_state == UPDATA)                        ? parking_space :
//                         (cr_state == WRITE_SRAM && car_in_reg)      ? bitmap_in     :
//                         (cr_state == WRITE_SRAM && car_out_reg)     ? bitmap_out    :
//                         (cr_state == WRITE_BITMAP && car_in_reg)    ? car_plate_reg :
//                         (cr_state == WRITE_BITMAP && car_out_reg)   ? 8'b1111_1111 : 8'b1111_1111;
assign state_dbg    = cr_state;
assign sram_en      = 1'b1;
endmodule