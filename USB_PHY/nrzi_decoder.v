module nrzi_decoder(
	input wire nd_clk_i,
	input wire nd_dplus_i,
	input wire nd_dminus_i,
	input wire nd_reset,
	output reg nd_sbit_o,
	output reg nd_invalid_o
);
	reg [1:0]nd_prev; // [1:0] -> dp,dm
	
	always@(posedge nd_clk_i or posedge nd_reset)begin
		if(nd_reset) begin
			nd_prev <= 2'b0;
			nd_sbit_o <= 1'b0;
			nd_invalid_o<=1'b1;
		end
		else begin
			nd_prev<={nd_dplus_i,nd_dminus_i};
			if(((nd_dplus_i^nd_dminus_i)==1'b1) && ((nd_prev[1]^nd_prev[0])==1'b1)) begin
				nd_invalid_o<=1'b0;
				if({nd_dplus_i,nd_dminus_i}==nd_prev)begin
					nd_sbit_o<=1'b1;
				end
				else 
					nd_sbit_o<=1'b0;
			end
			else nd_invalid_o<=1'b1;
		end
	end
endmodule

