module scoreout(
    input wire [7:0] score, //得分
    input wire clk, input wire clr,
    output reg [6:0] seven_seg, 
    output reg [7:0] seg_select //数据及位�?
    );
wire a;   
reg [3:0] digit;  
reg [19:0] clkdiv;
assign a = clkdiv[19];

always @ (*)
  case (a)
     //表示为两�?16进制�?
     0 : digit = score[3:0];
     1 : digit = score[7:4];
   endcase

always @ (*)
  case (digit)
     0: seven_seg = 7'b000_0001;
     1: seven_seg = 7'b100_1111;
     2: seven_seg = 7'b001_0010;
     3: seven_seg = 7'b000_0110;
     4: seven_seg = 7'b100_1100;
     5: seven_seg = 7'b010_0100;
     6: seven_seg = 7'b010_0000;
     7: seven_seg = 7'b000_1111;
     8: seven_seg = 7'b000_0000;
     9: seven_seg = 7'b000_0100;
     10: seven_seg = 7'b000_1000;
     11: seven_seg = 7'b110_0000;
     12: seven_seg = 7'b011_0001;
     13: seven_seg = 7'b100_0010;
     14: seven_seg = 7'b011_0000;
     15: seven_seg = 7'b011_1000;
  endcase

always @ (*)
  begin
    if(clr)
       seg_select = 8'b11111111;
    else
       begin
         seg_select = 8'b11111111;
         seg_select[a] = 0;
       end
  end

always @ (posedge clk or posedge clr)  
  begin   
    if (clr == 1)  
      clkdiv <= 0;  
    else   
      clkdiv <= clkdiv + 1'b1;  
  end 

endmodule
