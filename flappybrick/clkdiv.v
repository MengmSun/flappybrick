module clockdiv(
  input clk,
  input clr,
  output clk_25

);
  reg[1:0]count;
  initial count<=0;
  always @(posedge clk or posedge clr)
    begin
      if(clr)
      count<=0;
      else count<=count+1'b1;
    end

  assign clk_25 =count[1];
endmodule

