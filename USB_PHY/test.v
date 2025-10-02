`timescale 1ps / 1ps;
module test;
reg clk;
reg dpl;
reg dmi;
reg reset;
reg clk_8x;
//wire dp,dm;
wire bit,dptmp,dmtmp;
wire dp_prev=test.u_nd.dpp;
wire dm_prev=test.u_nd.dmp;
oversampler u_os(
	.clk_8x(clk_8x),
	.d_plus_device(dpl),
	.d_minus_device(dmi),
	.reset(reset),
	.dp(dptmp),
	.dm(dmtmp)
	
);
nrzi_decoder u_nd(
	.clk(clk),
	.dp(dptmp),
	.dm(dmtmp),
	.reset(reset),
	.bit(bit)
);
initial begin
	$dumpfile("test.vcd");
	$dumpvars(0,test);
	$display("time | clk | clk_8x | dplus | dminus | dplus_samp | dminus_samp | reset |counter|bit|");
end

always@ (posedge clk_8x) begin
	$display(" %3t | %3t |  %3t   |   %b   |   %b    |     %b      |      %b      |   %b   |  %3d  | %b |",$time/125,clk,clk_8x,dpl,dmi,dptmp,dmtmp,reset,test.u_os.counter,bit);
end



initial begin
	clk = 0;
	clk_8x = 0;
	reset = 0;
	dpl = 0;
	dmi =0;
end
always begin
	# 125 clk_8x = ~clk_8x;
end
always begin
	#1000 clk = ~clk;
end

	initial begin
		#0 {dpl,dmi} = 2'b00;
		#500;
		#2000 {dpl,dmi} = 2'b10;
		#2000 {dpl,dmi} = 2'b01;
		#2000 {dpl,dmi} = 2'b10;
		#2000 {dpl,dmi} = 2'b01;
		#2000 {dpl,dmi} = 2'b10;
		#2000 {dpl,dmi} = 2'b01;
		#2000 {dpl,dmi} = 2'b10;
		#10000; 
		 $finish;
	end
endmodule

