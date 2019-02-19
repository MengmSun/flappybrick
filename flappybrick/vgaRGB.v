module vgaRGB(
  input [9:0]hc,
  input [9:0]vc,
  input clk,
  input rst,
  input videoen,
  input up,
  input wire start,
  output reg[2:0]r,
  output reg[2:0]g,
  output reg[1:0]b,
  output reg pass
  //output reg[7:0]score
  );
//分频产生多个时钟
  reg start;
  reg [31:0]clkdiv;
  initial clkdiv=0;
  wire flyclk,sjclk,difficultclk,pipemoveclk;
  always@ (posedge clk or posedge rst)
    begin 
      if(rst==1)
        clkdiv<=0;
      else
        clkdiv<=clkdiv+1'b1;
    end

 reg [9:0]ubird=10'd100;
 reg [9:0]dbird=10'd131;//bird的上下界
 reg [9:0]ublock=10'd50;
 reg [9:0]lblock=10'd500;
 reg [9:0]rblock=10'd550;//waterpipe的上下界

 assign flyclk=clkdiv[20];//
 reg firstup = 1;//按键一次，只跳跃一次
 always @(posedge flyclk or posedge rst)
   begin
     if(rst==1)
       begin
         ubird<=10'd100;
         dbird<=10'd131;
       end
     else
       begin
         if(up==1&&ubird>10'd31)//up button pushed
           begin
             //jump once
             if(firstup==1)
               begin
                 ubird<=ubird-10'd50;
                 dbird<=dbird-10'd50;
                 firstup<=0;
               end
             else if(dbird<10'd510)
               begin
                 ubird<=ubird+10'd10;
                 dbird<=dbird+10'd10;
               end
           end
          else if(dbird<10'd510)
            begin
              ubird<=ubird+10'd10;
              dbird<=dbird+10'd10;
              firstup<=1;
            end
       end
   end

//35-400随机数产生器
 assign sjclk=clkdiv[15];//随机数时钟
 reg [9:0]usuiji=10'd35;
 always @(posedge sjclk)
   begin
     if(rst==1)
       usuiji<=10'd35;
     else
       begin
         usuiji<=usuiji+1'b1;
         if(usuiji==10'd400)
           usuiji<=10'd35;
       end
   end
//waterpipe移动的速度递增，难度（3~7）
assign difficultclk=clkdiv[29];//
reg [3:0]speed=10'd3;
always @(posedge difficultclk or posedge rst)
  begin
    if(rst)
        speed <= 3;
     else
      begin
        if(speed < 7)        
           speed <= speed + 1'b1;
      end
end
//waterpipe移动
assign pipemoveclk = clkdiv[20]; //
always @ (posedge pipemoveclk or posedge rst)
begin
   if(rst)
       begin
          lblock <= 10'd500;
          rblock <= 10'd550;
          ublock <= 10'd50;
        end
    else
      begin
        lblock <= lblock - speed;//
        rblock <= rblock - speed;
        if(lblock < 145)//
          begin
              lblock <= 10'd500;
              rblock <= 10'd550;
              ublock <= usuiji;  //上界为随机数
           end
      end
end

reg success = 1;//
reg first ;//防止重复计分
//reg pass = 0;//
reg [7:0]score=0;
initial first<=1;
initial pass<=0;
always @ (posedge flyclk or posedge rst)
begin
   if(rst)
       begin
         success <= 1;
        // score <= 0;
         pass<=0;
         first <= 1;
       end
    else if(lblock < 231 && rblock > 200)//bird meet pipe
       begin
          if((ubird < ublock || dbird > (ublock + 150))&&start)//collision
            begin
             success <= 0;
             pass<=0;
            end
             else if( first == 1&&success==1)
             begin
               pass <=1;//pass a waterpipe
               first <= 0;
             end 
        end
     else if(dbird>=510)
       begin
         success<=0;
         pass<=0;
       end
     else
       begin
        first <= 1;
        pass<=0;
       end
end

//birdRom
reg [9:0] addrbird = 0;
wire [7:0] databird;    
blk_mem_gen_0 bird( .clka(clk), .addra(addrbird), .douta(databird) );
//gameoverRom
reg [19:0] addrover = 0;
wire [7:0] dataover;    
blk_mem_gen_2 over( .clka(clk), .addra(addrover), .douta(dataover) );
//startRom
reg[19:0] addrstart = 0;
wire[7:0]datastart;
blk_mem_gen_1 startgame(.clka(clk),.addra(addrstart),.douta(datastart));



always @ (posedge clk )
begin
  if(videoen == 1)
    begin
      //gamestart
      if( start==0)
      begin
       if(vc<391&&vc>=151&&hc<624&&hc>=304)
         begin
          addrstart <= (vc-150-1)*320 + (hc-553)-1;
          r <= datastart[2:0];
          g <= datastart[5:3];
          b <= datastart[7:6];
         end
       else
         begin
           r<=3'b000;
           g<=3'b000;
           b<=2'b00;
         end
      end
      else if(success == 0 && start==1)
        begin
          //gameover
          if(vc < 511 && vc >=31 && hc < 784 && hc >=144)
            begin
              addrover <= (vc - 30  ) * 640 + (hc-383) - 1;
              r <= dataover[2:0];
              g <= dataover[5:3];
              b <= dataover[7:6];
            end
          else
            begin
              r <= 3'b000;
              g <= 3'b000;
              b <= 2'b00;
            end
      end
      else if(start==1 && success==1)
        begin
          //bird
          if(vc < dbird && vc > ubird && hc < 231 && hc > 200)
            begin               
             // addrbird <= (vc - ubird -1 ) * 30 + (hc-199) - 1;
              //r[2:0] <= databird[2:0];
              //g[2:0] <= databird[5:3];
              //b[1:0] <= databird[7:6];
              r<=3'b111;
              g<=3'b000;
              b<=2'b00;
            end
          //waterpipe
          else if(hc < rblock && hc > lblock && (vc >( ublock + 150) || vc < ublock))
            begin
              r <= 3'b000;
              g <= 3'b111;
              b <= 2'b00;
            end
          else
            begin
              //background
              r <= 3'b000;
              g <= 3'b100;
              b <= 2'b10;
            end
        end
    end  
  else
    begin
      r <= 3'b000;
      g <= 3'b000;
      b <= 2'b00;
    end
end

endmodule

