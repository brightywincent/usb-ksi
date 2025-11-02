module pid_checker(
	input wire clk,
	input wire reset,
	input wire sync,
	input wire pid_byte,
	input wire [7:0]pid_in,
	output reg pid_valid
);
	reg pid_start;
	initial begin
		pid_start = 1'b0;
		pid_valid = 1'b0;
	end
	always@(posedge clk or posedge reset) begin
		if(reset) begin
			pid_valid <= 1'b0;
			pid_start <= 1'b0;
		end
		else begin
			if(sync) begin
				pid_start <= (sync)?1'b1:1'b0;
			end
			else if(pid_start && pid_byte) begin
				pid_valid <= (pid_in[7:4]==~pid_in[3:0])?1'b1:1'b0;
				pid_start <= 1'b0;
			end
			else begin
				pid_valid <= 1'b0;
			end
		end
	end
endmodule
