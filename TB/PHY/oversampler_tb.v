`timescale 1ps / 1ps;
module oversampler_tb;
reg clk,os_clk_8x_i;
reg os_dp_i,os_dm_i;
reg os_reset;
wire os_dp_o,os_dm_o;

oversampler u_os(
	.os_clk_8x_i(os_clk_8x_i),
	.os_dp_i(os_dp_i),
	.os_dm_i(os_dm_i),
	.os_reset(os_reset),
	.os_dp_o(os_dp_o),
	.os_dm_o(os_dm_o)
);

initial begin
	$dumpfile("TB/oversampler.vcd");
	$dumpvars(0,oversampler_tb);
	$display("time | clk | os_clk_8x_i | os_dp_i | os_dm_i | os_dp_o | os_dm_o | os_reset |");
end

always@(posedge os_clk_8x_i) begin
	$display(" %3t | %3t |  %3t   |  %b  |  %b  |  %b  |  %b  |   %b  |",$time/125,clk,os_clk_8x_i,os_dp_i,os_dm_i,os_dp_o,os_dm_o,os_reset);
end

initial begin
	clk = 0;
	os_clk_8x_i = 0;
	os_reset = 0;
end

always begin
	# 125 os_clk_8x_i = ~os_clk_8x_i;
end

always begin
	#1000 clk = ~clk;
end

	initial begin
		#0    {os_dp_i,os_dm_i} = 2'b00;
		#200 {os_dp_i,os_dm_i} = 2'b10;
		#200 {os_dp_i,os_dm_i} = 2'b10;
		#200 {os_dp_i,os_dm_i} = 2'b10;
		#200 {os_dp_i,os_dm_i} = 2'b10;
		#200 {os_dp_i,os_dm_i} = 2'b10;
		#200 {os_dp_i,os_dm_i} = 2'b10;
		#200 {os_dp_i,os_dm_i} = 2'b10;
		#200 {os_dp_i,os_dm_i} = 2'b01;
		#200 {os_dp_i,os_dm_i} = 2'b01;
		#200 {os_dp_i,os_dm_i} = 2'b10;
		#200 {os_dp_i,os_dm_i} = 2'b10;
		#200 {os_dp_i,os_dm_i} = 2'b10;
		for(integer i = 0;i<31;i++) begin
			#200 {os_dp_i,os_dm_i} = {~os_dp_i,~os_dm_i};
		end
		#200  {os_dp_i,os_dm_i} = 2'b01;
		#200  {os_dp_i,os_dm_i} = 2'b01;
		 #200 $finish;
	end
endmodule