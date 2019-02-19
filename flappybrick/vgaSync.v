module vgaSync(
	input clk,//clk_25
	input rst,
	input wire hs,
	input wire vs,
	output wire videoen,
	output reg [9:0]hc,
	output reg [9:0]vc
);
  reg vsenable;
  reg hs;
  reg vs;
  reg videoen;
  

  always @(posedge clk)
    begin
      if(rst==1)//
      	hc<=0;
      else
      	begin
          if(hc==10'd799)//
          begin
            hc<=0;//
            vsenable<=1;//
          end
           else
              begin
                hc <= hc + 1'b1;
                vsenable <= 0;
              end
        end
    end

  always@ (*)
    begin
      if(hc<96)
        hs=0;
      else
        hs=1;
    end

  always@(posedge clk)
    begin
      if(rst==1)
        vc<=0;
      else 
        if(vsenable==1)
          begin
            if(vc==10'd520)
              vc<=0;
            else
              vc<=vc+1'b1;
          end
    end

  always @(*)
    begin
      if(vc<2)
        vs=0;
      else
        vs=1;
    end

  always @(*)
    begin 
      if((hc<10'd784)&&(hc>=10'd144)&&(vc<10'd511)&&(vc>=10'd31))
      videoen=1;
      else 
      videoen=0;
    end
endmodule





