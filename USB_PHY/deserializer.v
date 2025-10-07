module deserializer(
	input wire clk,
	input wire reset,
	input wire b,
	input wire unstuff,
	input wire sync,
	output reg [32:0]data_32,
	output reg [3:0]byte_ready
);
	reg [3:0]count;
	reg [1:0]byte;
	
	initial begin
		count <= 4'b0;
		byte <= 2'b00;
		byte_ready <= 4'b0000;
		data_32 <= 33'd0;
	end
	always@(posedge clk or posedge reset) begin
		if(reset) begin
			count <= 4'd0;
			byte <= 2'b00;
			byte_ready <= 4'b0000;
			data_32 <= 33'd0;
		end
		else begin
			if(!unstuff) begin
				case(byte) 
				2'b00 : data_32[7:0] <= {b,data_32[7:1]};
				2'b01 : data_32[15:8] <= {b,data_32[15:9]};
				2'b10 : data_32[23:16] <= {b,data_32[23:17]};
				2'b11 : data_32[31:24] <= {b,data_32[31:25]};
				endcase
				if(count==4'd7) begin
					byte_ready[byte] <= 1'b1;
					byte <= byte+1;
					count <= 4'd0;
				end
				else begin
					count <= count+1;
					byte_ready <= 4'b0000;
				end
			end
			data_32[31:0] <= (sync)?32'd0:data_32[31:0];
		end
	end
endmodule
