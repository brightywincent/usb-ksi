module oversampler(
	input clk_8x_i,
	input dp_i,
	input dm_i,
	input reset,
	output reg dp_o,
	output reg dm_o
);
	/*reg [2:0]counter;
	reg counter_en;
	reg dp_pa,dm_pa;
	
	initial begin
		counter = 3'd0;
		counter_en = 1'b0;
		dp_o = 1'b0;
		dm_o = 1'b0;
	end*/
	
	always@(posedge clk_8x_i or posedge reset) begin
		if(reset) begin
			//counter<=3'd0;
			//counter_en <= 1'b0;
			dp_o <= 1'b0;
			dm_o <= 1'b0;
			//dp_pa <= 1'b0;
			//dm_pa <= 1'b0;
		end
		else begin
			/*if(dp_pa != dp_i || dm_pa != dm_i) begin
				counter_en <= 1'b1;
				counter <= 3'd1;
			end
		end
		dp_pa <= dp_i;
		dm_pa <= dm_i;
		if(counter_en) begin
			counter <= (counter==3'd7)?3'd0:counter+1;
			if(counter == 3'd4) begin
				dp_o <= dp_i;
				dm_o <= dm_i;
			end
		end*/
		dp_o<=dp_i;
		dm_o<=dm_i;
	end
endmodule
