module flappybird(
  input  clk_100,
  input rst,
  input up,
  input start,
  input button,
  output wire audio,
  output wire[2:0]r,
  output wire[2:0]g,
  output wire[1:0]b,
  output wire hs,
  output wire vs,
  output wire[6:0]seven_seg,//段选
  output wire[7:0]seg_select//位选
  //output wire[7:0]score
);
  wire clk_25;
  wire ven;//videoenable
  wire[9:0]hc;
  wire[9:0]vc;
 // wire[7:0]score;
  wire pass;
  
//分频
  clockdiv clock(
    .clk(clk_100),
    .clr(rst),
    .clk_25(clk_25)
  	);

//
  vgaSync syn(
  	.clk(clk_25),
  	.rst(rst),
  	.hs(hs),
    .vs(vs),
  	.videoen(ven),
  	.hc(hc),
  	.vc(vc)
  	);
//VGA显示
  vgaRGB rgb(
  	.hc(hc),
  	.vc(vc),
  	.clk(clk_25),
  	.rst(rst),
  	.up(up),
  	.start(start),
  	.videoen(ven),
  	.r(r),
  	.g(g),
  	.b(b),
  	.pass(pass)
  //	.score(score)
  	);
//显示分数
 seven_seg sc(
  	.pass(pass),
  	.clk(clk_100),
  	.rst(rst),
  	.seven_seg(seven_seg),
  	.seg_select(seg_select)
  	);

buffer_music mu(
    .audio(audio),
    .clk(clk_100),
    .button(button)
);


endmodule