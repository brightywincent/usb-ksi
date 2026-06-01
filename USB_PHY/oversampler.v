module oversampler(
	input os_clk_8x_i,
	input os_dp_i,
	input os_dm_i,
	input os_reset,
	output reg os_dp_o,
	output reg os_dm_o
);
	
	always@(posedge os_clk_8x_i or posedge os_reset) begin
		if(os_reset) begin
			os_dp_o <= 1'b0;
			os_dm_o <= 1'b0;
		end
		else begin
			os_dp_o<=os_dp_i;
			os_dm_o<=os_dm_i;
		end
	end
	
endmodule
