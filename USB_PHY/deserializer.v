module deserializer(
	input wire d_clk_i,
	input wire d_reset,
	input wire d_sbit_i,
	input wire d_unstuff_i,
	input wire d_sync_i,
	output reg [31:0]d_bytes_o, 
	output reg [3:0]d_byte_ready_o
);
	reg [3:0]d_count;
	reg [1:0]BYTE;
	reg d_start;
	
	always@(posedge d_clk_i or posedge d_reset) begin
		if(d_reset) begin
			d_count <= 4'd0;
			BYTE <= 2'b00;
			d_byte_ready_o <= 4'b0000;
			d_bytes_o <= 32'd0;
			d_start<=1'b0;
		end
		else if(d_sync_i | d_start) begin
			d_start<=1'b1;
			d_byte_ready_o <= 4'b0;
			if((!d_unstuff_i)&(d_start | d_sync_i)) begin
				case(BYTE) 
					2'b00 : d_bytes_o[7:0] <= {d_sbit_i,d_bytes_o[7:1]};
					2'b01 : d_bytes_o[15:8] <= {d_sbit_i,d_bytes_o[15:9]};
					2'b10 : d_bytes_o[23:16] <= {d_sbit_i,d_bytes_o[23:17]};
					2'b11 : d_bytes_o[31:24] <= {d_sbit_i,d_bytes_o[31:25]};	
					default : BYTE<=2'b00;
				endcase
				if(d_count==4'd7) begin
					d_byte_ready_o[BYTE] <= 1'b1;
					d_count <= 4'd0;
					if(BYTE==2'b11)begin
						d_start<=1'b0;
						BYTE<=2'b0;
					end
					else BYTE <= BYTE+1;
				end
				else begin
					d_count <= d_count+1;
				end
			end
		end 
	end
endmodule
