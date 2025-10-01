module nrzi_decoder(
	input wire clk,
	input wire dp,
	input wire dm,
	input wire reset,
	output wire bit
);

	reg bit_pr;
	reg bit_pa;
	
	assign bit = (bit_pr==bit_pa)?1'b1:1'b0;
	
	initial begin
		bit_pr = 1'b0;
		bit_pa = 1'b0;
	end
	
	always@(posedge clk or posedge reset)begin
		if(reset) begin
			bit_pr = 1'b0;
			bit_pa = 1'b0;
		end
		else begin
			bit_pa <= bit_pr;
			bit_pr <= (dp==1'b1 && dm==1'b0)?1'b1:(dp==1'b0 && dm==1'b1)?1'b0:bit_pr; //state to bit logic
		end
	end
endmodule
