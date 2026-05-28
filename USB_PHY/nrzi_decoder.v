module nrzi_decoder(
	input wire clk,
	input wire dp,
	input wire dm,
	input wire reset,
	output reg bit
);
	reg dpp,dmp;
	
	initial begin
		dpp = 1'b0;
		bit = 1'b0;
		dmp = 1'b0;
	end
	
	always@(posedge clk or posedge reset)begin
		if(reset) begin
			dpp <= 1'b0;
			dmp <= 1'b0;
			bit <= 1'b0;
		end
		else begin
			dpp <= dp;
			dmp <= dm;
			if(dp==~dpp || dm==~dmp) begin
				bit <= 1'b0;
			end
			else begin
				bit <= 1'b1;
			end
		end
	end
endmodule

