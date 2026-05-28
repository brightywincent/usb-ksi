module bit_unstuffer(
	input wire clk,
	input reset,
	input wire bit,
	output reg b,
	output reg unstuff
);
	reg [2:0]count;
	
	initial begin
		count = 3'd0;
		b = 1'b0;
		unstuff = 1'b0;
	end
	
	always@(posedge clk or posedge reset) begin
		if(reset) begin
			unstuff <= 1'b0;
			count <= 3'd0;
		end
		else begin
			b <= bit;
			if(bit==1'b1) begin
				count <= count+1;
				unstuff <= 1'b0;
			end
			else begin
				if(count>=3'd5) begin
					unstuff <= 1'b1;
					count <= 3'd0;
				end
				else begin
					count <= 3'd0;
					unstuff <= 1'b0;
				end
			end
		end
	end

endmodule
