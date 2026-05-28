module oversampler(
	input clk_8x,
	input d_plus_device,
	input d_minus_device,
	input reset,
	output reg dp,
	output reg dm
);
	reg [2:0]counter;
	reg counter_en;
	reg dp_pa,dm_pa;
	
	initial begin
		counter = 3'd0;
		counter_en = 1'b0;
		dp = 1'b0;
		dm = 1'b0;
	end
	
	always@(posedge clk_8x or posedge reset) begin
		if(reset) begin
			counter<=3'd0;
			counter_en <= 1'b0;
			dp <= 1'b0;
			dm <= 1'b0;
			dp_pa <= 1'b0;
			dm_pa <= 1'b0;
		end
		else begin
			if(dp_pa != d_plus_device || dm_pa != d_minus_device) begin
				counter_en <= 1'b1;
				counter <= 3'd1;
			end
		end
		dp_pa <= d_plus_device;
		dm_pa <= d_minus_device;
		if(counter_en) begin
			counter <= (counter==3'd7)?3'd0:counter+1;
			if(counter == 3'd4) begin
				dp <= d_plus_device;
				dm <= d_minus_device;
			end
		end
	end
endmodule
