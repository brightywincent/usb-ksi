module deserializer(
	input wire clk,
	input wire reset,
	input wire b,
	input wire unstuff,
	input wire sync,
	output reg [32:0]data_32,
	output reg bytes
);
	reg [5:0]count;
	initial begin
		count <= 6'd0;
		bytes <= 1'b0;
	end
	always@(posedge clk or posedge reset) begin
		if(reset) begin
			data_32 <= 33'd0;
			count <= 6'd0;
			bytes <= 1'b0;
		end
		else begin
			if(unstuff==1'b1) begin
				data_32 <= data_32;
			end
			else begin
				data_32 <= {b,data_32[32:1]};
				count <= count+1;
				bytes <= 1'b0;
			end
			if(count==6'd32) begin
				bytes <= 1'b1;
				count <= 6'd0;
			end
		end
	end
endmodule
