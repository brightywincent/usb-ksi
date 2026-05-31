`timescale 1ps / 1ps;
module oversampler_tb;
reg clk,clk_8x_i;
reg dp_i,dm_i;
reg reset;
wire dp_o,dm_o;

oversampler u_os(
	.clk_8x_i(clk_8x_i),
	.dp_i(dp_i),
	.dm_i(dm_i),
	.reset(reset),
	.dp_o(dp_o),
	.dm_o(dm_o)
);

initial begin
	$dumpfile("TB/oversampler.vcd");
	$dumpvars(0,oversampler_tb);
	$display("time | clk | clk_8x_i | dp_i | dm_i | dp_o | dm_o | reset |");
end

always@(posedge clk_8x_i) begin
	$display(" %3t | %3t |  %3t   |  %b  |  %b  |  %b  |  %b  |   %b  |",$time/125,clk,clk_8x_i,dp_i,dm_i,dp_o,dm_o,reset);
end

initial begin
	clk = 0;
	clk_8x_i = 0;
	reset = 0;
end

always begin
	# 125 clk_8x_i = ~clk_8x_i;
end

always begin
	#1000 clk = ~clk;
end

	initial begin
		#0    {dp_i,dm_i} = 2'b00;
		#200 {dp_i,dm_i} = 2'b10;
		#200 {dp_i,dm_i} = 2'b10;
		#200 {dp_i,dm_i} = 2'b10;
		#200 {dp_i,dm_i} = 2'b10;
		#200 {dp_i,dm_i} = 2'b10;
		#200 {dp_i,dm_i} = 2'b10;
		#200 {dp_i,dm_i} = 2'b10;
		#200 {dp_i,dm_i} = 2'b01;
		#200 {dp_i,dm_i} = 2'b01;
		#200 {dp_i,dm_i} = 2'b10;
		#200 {dp_i,dm_i} = 2'b10;
		#200 {dp_i,dm_i} = 2'b10;
		for(integer i = 0;i<31;i++) begin
			#200 {dp_i,dm_i} = {~dp_i,~dm_i};
		end
		#200  {dp_i,dm_i} = 2'b01;
		#200  {dp_i,dm_i} = 2'b01;
		 #200 $finish;
	end
endmodule