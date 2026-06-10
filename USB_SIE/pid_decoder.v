module pid_decoder(
	input wire pd_clk_i,
	input wire pd_reset, 
	input wire [7:0]pd_pbyte0_i,
	input wire pd_pbyte0_ready_i, 
	output reg pd_valid_o,
	output reg pd_error_o
);
	
	always@(posedge pd_clk_i or posedge pd_reset) begin
		if(pd_reset) begin
			pd_valid_o <= 1'b0;
			pd_error_o<=1'b0;
		end
		else begin
			pd_valid_o<=1'b0;
			pd_error_o<=1'b0;
			if(pd_pbyte0_ready_i)begin
				if(pd_pbyte0_i[7:4]==~pd_pbyte0_i[3:0])begin
					pd_valid_o<=1'b1;
				end
				else begin
					pd_error_o<=1'b1;
				end
			end
		end
	end
endmodule
