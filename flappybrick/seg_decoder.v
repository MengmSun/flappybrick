`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/11 19:10:01
// Design Name: 
// Module Name: seg_decoder
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


`include "Definition.h"
module seg_decoder(
    input clk,
    input [3:0] num,
    output reg [6:0] code
    );
always@(posedge clk)
begin
	case(num)
	4'b0000:
		code <= `ZERO;
	4'b0001:
		code <= `ONE;
	4'b0010:
		code <= `TWO;
	4'b0011:
		code <= `THREE;
	4'b0100:
		code <= `FOUR;
	4'b0101:
		code <= `FIVE;
	4'b0110:
		code <= `SIX;
	4'b0111:
		code <= `SEVEN;
	4'b1000:
		code <= `EIGHT;
	4'b1001:
		code <= `NINE;
	default:
		code <= code;
	endcase
end

endmodule

