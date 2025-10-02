module bit_unstuffer(
	input wire clk,
	input reset,
	input wire bit,
	output reg b,
	output reg b_en
);
	reg [2:0]count;
	
	initial begin
		count = 3'd0;
		b = 1'b0;
		b_en = 1'b0;
	end
	
	always@(posedge clk or posedge reset) begin
		if(reset) begin
			b_en <= 1'b0;
			count <= 3'd0;
		end
		else begin
			b <= bit;
			if(bit==1'b1) begin
				count <= count+1;
				b_en <= 1'b1;
			end
			else begin
				if(count>=3'd5) begin
					b_en <= 1'b0;
					count <= 3'd0;
				end
				else begin
					count <= 3'd0;
					b_en <= 1'b1;
				end
			end
		end
	end

endmodule
