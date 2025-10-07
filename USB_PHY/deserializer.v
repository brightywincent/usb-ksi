module deserializer(
	input wire clk,
	input wire reset,
	input wire b,
	input wire unstuff,
	input wire sync,
	output reg [31:0]data_32,
	output reg [3:0]byte_ready
);
	reg [3:0]count;
	reg [1:0]byte;
	
	initial begin
		count <= 4'b0;
		byte <= 2'b00;
		byte_ready <= 4'b0000;
		data_32 <= 32'd0;
	end
	always@(posedge clk or posedge reset) begin
		if(reset) begin
			count <= 4'd0;
			byte <= 2'b00;
			byte_ready <= 4'b0000;
			data_32 <= 32'd0;
		end
		else begin
			if(!unstuff) begin
				case(byte) 
					2'b00 : begin
						if(count<4'd8) begin
							data_32[7:0] <= {b,data_32[7:1]};
							count <= count+1;
						end
						else begin
							count <= 4'd0;
							byte <= 2'b01;
						end
					end	
					2'b01 : begin
						if(count<4'd8) begin
							data_32[15:8] <= {b,data_32[15:9]};
							count <= count+1;
						end
						else begin
							count <= 4'd0;
							byte <= 2'b10;
						end
					end
					2'b10 : begin
						if(count<4'd8) begin
							data_32[23:16] <= {b,data_32[23:17]};
							count <= count+1;
						end
						else begin
							count <= 4'd0;
							byte <= 2'b11;
						end
					end
					2'b11 : begin
						if(count<4'd8) begin
							data_32[31:24] <= {b,data_32[31:25]};
							count <= count+1;
						end
						else begin
							count <= 4'd0;
							byte <= 2'b00;
						end
					end
					default : begin
						byte <= 2'b00;
						count <= 4'd0;
					end
				endcase
				if(count==4'd7) begin
					byte_ready[0] <= (byte==2'b00)?1'b1:1'b0;
					byte_ready[1] <= (byte==2'b01)?1'b1:1'b0;
					byte_ready[2] <= (byte==2'b10)?1'b1:1'b0;
					byte_ready[3] <= (byte==2'b11)?1'b1:1'b0;
				end
			end
		end
	end
endmodule
