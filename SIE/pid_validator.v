module pid_validator(
	input wire pv_clk_i,
	input wire pv_reset, 
	input wire [7:0]pv_pbyte0_i,
	input wire pv_pbyte0_ready_i, 
	output reg pv_valid_o,
	output reg pv_error_o
);
	
	always@(posedge pv_clk_i or posedge pv_reset) begin
		if(pv_reset) begin
			pv_valid_o <= 1'b0;
			pv_error_o<=1'b0;
		end
		else begin
			pv_valid_o<=1'b0;
			pv_error_o<=1'b0;
			if(pv_pbyte0_ready_i)begin
				if(pv_pbyte0_i[7:4]==~pv_pbyte0_i[3:0])begin
					pv_valid_o<=1'b1;
				end
				else begin
					pv_error_o<=1'b1;
				end
			end
		end
	end
endmodule
