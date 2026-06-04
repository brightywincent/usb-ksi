module nrzi_decoder(
	input wire nd_clk_i,
	input wire nd_dplus_i,
	input wire nd_dminus_i,
	input wire nd_reset,
	output reg nd_sbit_o
);
	reg nd_dplus_prev,nd_dminus_prev;
	
	always@(posedge nd_clk_i or posedge nd_reset)begin
		if(nd_reset) begin
			nd_dplus_prev <= 1'b0;
			nd_dminus_prev <= 1'b0;
			nd_sbit_o <= 1'b0;
		end
		else begin
			nd_dplus_prev <= nd_dplus_i;
			nd_dminus_prev <= nd_dminus_i;
			if(nd_dplus_i==~nd_dplus_prev || nd_dminus_i==~nd_dminus_prev) begin
				nd_sbit_o <= 1'b0;
			end
			else begin
				nd_sbit_o <= 1'b1;
			end
		end
	end
ennd_dminus_iodule

