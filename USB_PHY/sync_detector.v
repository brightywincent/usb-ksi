module sync_detector(
	input wire b,
	input wire clk,
	input wire reset,
	output reg sync
);
	reg [5:0]count;
	initial begin
	 count = 6'd0;
	 sync =1'b0;
	end
	always@(posedge clk or posedge reset) begin
		if(reset) begin
			sync <= 1'b0;
			count <= 6'd0;
		end
		else begin
			if(b==1'b0) begin
				count <= count+1;
				sync <= 1'b0;
			end
			else if(count>=6'd30 && b==1'b1) begin
				sync <= 1'b1;
				count <= 6'd0;
			end
			else begin
				count <= 6'd0;
				sync <= 1'b0;
			end
		end
	end	
endmodule
