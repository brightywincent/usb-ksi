module bit_unstuffer(
	input wire bu_clk_i,
	input wire bu_reset,
	input wire bu_sbit_i,
	input wire bu_valid_bit_i, //input taken from the output of nrzi decoder -> nd_invalid_o
	output reg bu_unstuff_o,
	output reg bu_error_o
);
	
	reg [2:0]bu_count;
	
	always@(posedge bu_clk_i or posedge bu_reset) begin
		if(bu_reset) begin
			bu_unstuff_o <= 1'b0;
			bu_count <= 3'd0;
			bu_error_o<=1'b0;
		end
		else begin
			bu_unstuff_o<= 1'b0;
			bu_error_o<=1'b0;
			if(bu_valid_bit_i==1'b0) begin //input is negative logic so, valid is set to 0
				if(bu_sbit_i==1'b1) begin 
					if(bu_count<3'd6)begin
						bu_count <= bu_count+1;
					end
					else begin
						bu_error_o<=1'b1;
						bu_count<= 3'd0;
					end
				end
				else begin
					if(bu_count==3'd6)begin
						bu_unstuff_o<=1'b1;
					end
					bu_count<=3'b0;
				end
			end
			else begin
				bu_count<=3'b0;
			end	
		end
	end

endmodule
