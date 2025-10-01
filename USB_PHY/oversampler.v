module oversampler(
	input clk_8x,
	input d_plus_device,
	input d_minus_device,
	input reset,
	output reg dp,
	output reg dm
);
	reg [2:0]counter;
	always@(posedge clk_8x or posedge reset) begin
		if(reset) begin
			counter<=3'd0;
		end
		else begin
			counter<=(counter==3'd7)?3'd0:counter+1'b1;
			if(counter==3'd4) begin
				dp<=d_plus_device;
				dm<=d_minus_device;
			end
		end
	end
	endmodule
