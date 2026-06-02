module sync_detector(
	input wire [1:0]sd_sbus_i,
	input wire sd_clk_i,
	input wire sd_reset,
	output reg sd_sync_o
);
	/*reg [3:0]sd_count;
	reg [1:0]sd_prev;
	always@(posedge sd_clk_i or posedge sd_reset)begin
		if(sd_reset)begin
			sd_sync_o<=1'b0;
			sd_prev<=2'b01;
			sd_count<={4{0}};
		end
		else begin
			sd_prev<=sd_sbus_i;
			if(sd_count<15)begin
				sd_sync_o<=1'b0;
				if((sd_prev==2'b01 &&sd_sbus_i==2'b10) || (sd_prev==2'b10 &&sd_sbus_i==2'b01))begin
					sd_count<=sd_count+1;
				end
				else sd_count<={4{0}};
			end
			else if(sd_count==15)begin
				if(sd_prev==sd_sbus_i)begin
					sd_sync_o<=1'b1;
					sd_count<={4{0}};
				
				else begin
					sd_count<={4{0}};
					sd_sync_o<=1'b0;
				end
			end
		end
	end
endmodule
*/
	localparam IDLE=2'b00;
	localparam ACQUIRING=2'b01;
	localparam SYNC_FOUND=2'b10;

	reg [1:0]STATE;
	reg [3:0]sd_count;
	reg [1:0]sd_prev;

	always@(posedge sd_clock_i or posedge sd_reset)begin
		if(sd_reset)begin
			sd_sync_o<=1'b0;
			sd_prev<=2'b01;
			sd_count<={4{0}};
			STATE<=IDLE;
		end
		else begin
			sd_prev<=sd_sbus_i;
			case(STATE)
				IDLE : begin
					sd_sync_o<=1'b0;
					sd_count<={4{0}};
					if(sd_sbus_i==2'b10)begin
						STATE<=ACQUIRING;
					end
				end
				ACQUIRING : begin
					if(sd_count<14)begin
						if((sd_prev==2'b01 && sd_sbus_i==2'b10) || (sd_prev==2'b10 && sd_sbus_i==2'b01))begin
							sd_count<=sd_count+1;
						end
						else begin
							STATE<=IDLE;
						end
					end
					else
						STATE<=SYNC_FOUND;
				end
				SYNC_FOUND : begin
					sd_sync_o<=1'b1;
					STATE<=IDLE;
				end
				default : STATE<=IDLE;
			endcase
		end
	end
