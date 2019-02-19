`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/11 19:08:03
// Design Name: 
// Module Name: seven_seg
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
module seven_seg(
    input clk,
	 input rst,
	 input pass,
    output reg [7:0] seg_select,
    output reg [6:0] seven_seg
    );

reg [3:0] num0 = 4'b0;

reg [3:0] num1 = 4'b0;

reg [3:0] num2 = 4'b0;

reg [3:0] num3 = 4'b0;

reg [1:0] cnt = 0;

reg [6:0] clk_cnt = 0;
reg sclk = 0;

always@(posedge clk)
begin
	if(clk_cnt == 127)
	begin
		sclk <= ~sclk;
		clk_cnt <= 0;
	end
	else
		clk_cnt <= clk_cnt + 1;
end

wire [6:0] out0;
wire [6:0] out1;
wire [6:0] out2;
wire [6:0] out3;

seg_decoder seg0(
	.clk(clk),
	.num(num0),
	.code(out0)
	);

seg_decoder seg1(
	.clk(clk),
	.num(num1),
	.code(out1)
	);

seg_decoder seg2(
	.clk(clk),
	.num(num2),
	.code(out2)
	);

seg_decoder seg3(
	.clk(clk),
	.num(num3),
	.code(out3)
	);
	
// Display four seg
always@(posedge sclk)
begin
	if(rst) //high active
	begin
		cnt <= 0;
	end
	else
	begin
		case(cnt)
		2'b00:
		begin
			seven_seg <= out0;
			seg_select <= 8'b11111110;
		end	
		2'b01:
		begin
			seven_seg <= out1;
			seg_select <= 8'b11111101;
		end
		2'b10:
		begin
			seven_seg <= out2;
			seg_select <= 8'b11111011;
		end
		2'b11:
		begin
			seven_seg <= out3;
			seg_select <= 8'b11110111;
		end
		default:
		begin
			seven_seg <= seven_seg;
			seg_select <= seg_select;
		end
		endcase
		cnt <= cnt + 1;	
		if(cnt == 2'b11)
			cnt<=0;
	end
end

// Flush data each time you lose
always@(posedge pass or posedge rst)
begin
	if(rst)
	begin
		num0 <= 0;
		num1 <= 0;
		num2 <= 0;
		num3 <=0;
	end
	else if(num0 == 9)
	begin
		num0 <= 0;
		if(num1 == 9)
		begin
			num1 <= 0;
			if(num2 == 9)
			begin
				num2 <= 0;
				if(num3 == 9)
					num3 <= 0;
				else
					num3 <= num3 + 1;
			end
			else
				num2 <= num2 + 1;
		end
		else
			num1 <= num1 + 1;
	end
	else
		num0 <= num0 + 1;
		
end

endmodule
