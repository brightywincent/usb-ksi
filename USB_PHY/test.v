`timescale 1ps / 1ps;
module test;
reg clk,clk_8x;
reg dpl,dmi;
reg reset;
wire bit,dp,dm;
wire dp_prev=test.u_nd.dpp;
wire dm_prev=test.u_nd.dmp;
wire b,b_en;
oversampler u_os(
	.clk_8x(clk_8x),
	.d_plus_device(dpl),
	.d_minus_device(dmi),
	.reset(reset),
	.dp(dp),
	.dm(dm)
	
);
nrzi_decoder u_nd(
	.clk(clk),
	.dp(dp),
	.dm(dm),
	.reset(reset),
	.bit(bit)
);
bit_unstuffer u_bu(
	.clk(clk),
	.reset(reset),
	.bit(bit),
	.b(b),
	.b_en(b_en)
);
initial begin
	$dumpfile("test.vcd");
	$dumpvars(0,test);
	$display("time | clk | clk_8x | dplus | dminus | dplus_samp | dminus_samp | reset |counter|bit|");
end

always@ (posedge clk_8x) begin
	$display(" %3t | %3t |  %3t   |   %b   |   %b    |     %b      |      %b      |   %b   |  %3d  | %b |",$time/125,clk,clk_8x,dpl,dmi,dp,dm,reset,test.u_os.counter,bit);
end



initial begin
	clk = 0;
	clk_8x = 0;
	reset = 0;
end
always begin
	# 125 clk_8x = ~clk_8x;
end
always begin
	#1000 clk = ~clk;
end

	initial begin
		#0    {dpl,dmi} = 2'b00;
		#2000 {dpl,dmi} = 2'b10;
		#2000 {dpl,dmi} = 2'b10;
		#2000 {dpl,dmi} = 2'b10;
		#2000 {dpl,dmi} = 2'b10;
		#2000 {dpl,dmi} = 2'b10;
		#2000 {dpl,dmi} = 2'b10;
		#2000 {dpl,dmi} = 2'b10;
		#2000 {dpl,dmi} = 2'b01;
		#2000 {dpl,dmi} = 2'b01;
		#2000 {dpl,dmi} = 2'b10;
		#2000 {dpl,dmi} = 2'b10;
		#2000 {dpl,dmi} = 2'b10;
		#10000; 
		 $finish;
	end
endmodule

