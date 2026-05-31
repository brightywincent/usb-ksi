module oversampler(
	input clk_8x_i,
	input dp_i,
	input dm_i,
	input reset,
	output reg dp_o,
	output reg dm_o
);
	
	always@(posedge clk_8x_i or posedge reset) begin
		if(reset) begin
			dp_o <= 1'b0;
			dm_o <= 1'b0;
		end
		else begin
			dp_o<=dp_i;
			dm_o<=dm_i;
		end
	end
	
endmodule
