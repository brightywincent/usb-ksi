module HOST_PHY#(
	parameter FLOAT = 3'd0,
	parameter IDLE = 3'd1,
	parameter SE0 = 3'd2,
	parameter RELEASE = 3'd3,
	parameter K_CHIRP_DETECT = 3'd4,
	parameter J_PULSE = 3'd5,
	parameter K_PULSE = 3'd6,
	parameter HIGH_Z = 3'd7
)(
	input wire clk,
//----------------------------------------------	
	inout tri d_plus,
	inout tri d_minus,
//----------------------------------------------	
	output reg device_present,
	output reg HIGH_SPEED
);
	reg [2:0]state;
	reg [21:0] detection_duration; 
	reg detect_en;
	reg [3:0]K_count;
	reg se0_done;
	reg k_pulse_done;
//----------------------------------------------	
	reg d_plus_hostout;
	reg d_minus_hostout;
//----------------------------------------------	
	reg d_plus_hostout_en;
	reg d_minus_hostout_en;
//----------------------------------------------	
	initial begin //Initializations
        	state = FLOAT;
	        device_present = 0;
        	d_plus_hostout_en = 0;
        	d_minus_hostout_en = 0;
        	detection_duration = 0;
        	detect_en = 0;
        	d_plus_hostout = 1'b0;
        	d_minus_hostout = 1'b0;
        	K_count = 4'd0;
        	se0_done = 1'b0;
        	k_pulse_done = 1'b0;
        	HIGH_SPEED = 1'b0;
    	end
//---------------------------------------------------------------------------------	
	assign d_plus = (d_plus_hostout_en)? d_plus_hostout : 1'bz;
	assign d_minus = (d_minus_hostout_en)? d_minus_hostout : 1'bz;
//--------------------------------------------------------------------------------------------------------------------	
	always @ (posedge clk) begin
		if (detect_en) begin
			detection_duration <= detection_duration+1;
		end	
//------------------------------------------------------------------------------------------
			case (state)
				FLOAT : begin
					d_plus_hostout_en <= 0;
					d_minus_hostout_en <= 0;
					detection_duration <= 22'd0;
					detect_en <= 0;
					if((d_plus===1'b1) && (d_minus===1'b0))begin
						state <= IDLE;
						detect_en <= 1'b1;
						device_present <= 1'b1;
					end
				end
//------------------------------------------------------------------------------------------				
				IDLE : begin 
					d_plus_hostout_en <= 0;
					d_minus_hostout_en <= 0;
					if((d_plus===1'b1) && (d_minus===1'b0))begin
						if(detection_duration == 22'd120 && !se0_done)begin
							state <= SE0;
							detection_duration <= 22'd0;
						end
					end
					if(d_plus === 1'bz && d_minus === 1'bz)begin
							state <= HIGH_Z;
					end
				end
//------------------------------------------------------------------------------------------				
				SE0 : begin
					d_plus_hostout <= 1'b0;
					d_minus_hostout <= 1'b0;
					d_plus_hostout_en <= 1'b1;
					d_minus_hostout_en <= 1'b1;
					if(detection_duration == 22'd120) begin
						se0_done <= 1'b1;
						state <= RELEASE;
					end
				end
//------------------------------------------------------------------------------------------	
				HIGH_Z : begin
					if(se0_done && !HIGH_SPEED)begin 
						if(d_plus === 1'b0 && d_minus === 1'b1)begin
							state <= K_CHIRP_DETECT;
							detect_en <= 1'b1;
						end
					end
				end 
//------------------------------------------------------------------------------------------				
				K_CHIRP_DETECT : begin
					if(detection_duration == 22'd20)begin
						HIGH_SPEED <= 1'b1;
						state <= J_PULSE;
						detect_en <= 1'b0;
						detection_duration <= 22'd0;
					end
				end
//------------------------------------------------------------------------------------------
				RELEASE : begin
					detection_duration <= 22'd0;
					detect_en <= 1'b0;
					d_plus_hostout_en <= 1'b0;
					d_minus_hostout_en <= 1'b0;
					state <= IDLE;
				end
//------------------------------------------------------------------------------------------
				J_PULSE : begin
					d_plus_hostout_en <= 1'b1;
					d_minus_hostout_en <= 1'b1;
					d_plus_hostout <= 1'b1;
					d_minus_hostout <= 1'b0;
					detect_en <= 1'b1;
					if(detection_duration == 22'd20)begin
						detection_duration <= 22'd0;
						d_plus_hostout <= 1'b0;
						d_minus_hostout <= 1'b1;
						state <= K_PULSE;
					end
					
				end
//-----------------------------------------------------------------------------------------				
				K_PULSE : begin
					if(detection_duration == 22'd20)begin
						if(K_count == 4'd7)begin
							K_count <= 4'b0;
							state <= HIGH_Z;
							d_plus_hostout_en <= 1'b0;
							d_minus_hostout_en <= 1'b0;
							detection_duration <= 22'd0;
							detect_en <= 1'b0;
						end
						else begin
							detection_duration <= 22'd0;
							state <= J_PULSE;
							K_count <= K_count+1;
						end
					end
				end
//------------------------------------------------------------------------------------------				
				default : begin
					state <= FLOAT;
				end
			endcase
	end
//--------------------------------------------------------------------------------------------------------------------------
endmodule
