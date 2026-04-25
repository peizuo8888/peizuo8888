`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2026 09:32:40 PM
// Design Name: 
// Module Name: SRAM
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

module SRAM(
    input wire [2:0] addr,
    input wire [3:0] data_in,
    input wire WE,
    input wire rst_n,
    input wire clk,
    output reg [7:0] empty,
    output reg [3:0] data_out
    );
    
    reg [2:0] register [3:0];
    
    integer i;
    always@(posedge clk)
    begin
        if(!rst_n) begin
            for ( i = 0; i < 7; i = i + 1)begin
                register[i] <= 0;
                empty [i] <= 1;
            end
        end
        else if (WE) begin 
            empty[addr]    <= 0;
            register[addr] <= data_in;
        end        
        data_out <= register[addr];
    end

endmodule
