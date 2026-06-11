module sync_detector(
	input wire [1:0]sd_sbus_i,
	input wire sd_clk_i,
	input wire sd_reset,
	output reg sd_sync_o
);
	
	localparam IDLE=2'b00;
	localparam ACQUIRING=2'b01;

	reg [1:0]STATE;
	reg [3:0]sd_count;
	reg [1:0]sd_prev;

	always@(posedge sd_clk_i or posedge sd_reset)begin
		if(sd_reset)begin
			sd_sync_o<=1'b0;
			sd_prev<=2'b01;
			sd_count<={4{1'b0}};
			STATE<=IDLE;
		end
		else begin
			sd_prev<=sd_sbus_i;
			case(STATE)
				IDLE : begin
					sd_sync_o<=1'b0;
					sd_count<={4{1'b0}};
					if((sd_sbus_i==2'b10) && (sd_prev==2'b01))begin
						STATE<=ACQUIRING;
					end
				end
				ACQUIRING : begin
					if(sd_count<4'd14)begin
						if((sd_prev==2'b01 && sd_sbus_i==2'b10) || (sd_prev==2'b10 && sd_sbus_i==2'b01))begin
							sd_count<=sd_count+1;
						end
						else begin
							STATE<=IDLE;
							sd_count<={4{1'b0}};
						end
					end
					else begin
						if(({sd_sbus_i,sd_prev}==4'b1010)) begin
							sd_sync_o<=1'b1;
						end
						sd_count<=4'b0;
						STATE<=IDLE;
					end
				end
				default :begin
				    STATE<=IDLE;
				    sd_sync_o<=1'b0;
					sd_count<={4{1'b0}};
				end
			endcase
		end
	end
endmodule


