module USB_PHY #(
	parameter VBUS_COMPARATOR_REFERENCE = 8'd62,	//VBUS comparator reference voltage
	parameter IDLE = 3'd0,
	parameter RESET = 3'd1,
	parameter HIGH_Z = 3'd2,
	parameter K_PULSE = 3'd3,
	parameter KJ_DETECT = 3'd4
)(
	input wire clk_8x,
	input wire clk,	 
	input wire VBUS_device,	//VBUS connection to device
	input wire[7:0] VBUS_divider_voltage_i, //VBUS divider voltage => input to comparator
	input wire reset,
	inout wire d_plus_device, //D+ interface line on device
	inout wire d_minus_device, //D- interface line on device

	output wire control_reg_0, //control regiser[0] that stores VBUS Comparator output
	output 	reg HIGH_SPEED,
	output reg term_en,
	//output wire dp,
	//output wire dm,
	output wire bit
);
oversampler u_os(
	.clk_8x(clk_8x),
	.d_plus_device(d_plus_device),
	.d_minus_device(d_minus_device),
	.reset(reset),
	.dp(dp_int),
	.dm(dm_int)
);	

nrzi_decoder u_nd(
	.clk(clk),
	.dp(dp_int),
	.dm(dm_int),
	.reset(reset),
	.bit(bit)
);
	wire dp_int,dm_int;
	
	reg sync_ff1,sync_ff2; //sync flipflops followed by VBUS comparator for stability
	wire VBUS_comparator_output_o; // VBUS comparator output
	reg [21:0] detection_duration_device;
	reg control_reg_0_ff;
	reg reset_usb;
	wire detection_variable;
	reg [2:0] state_device;
	reg [2:0] chirp_count;
	reg chirp_on;
	reg detection_duration_device_en;
	reg chirp_done;
	reg [3:0]J,K;

	reg d_plus_deviceout; //D+ device transmission data onto the interface -> d_plus_device
	reg d_minus_deviceout; //D- device transmission data onto the interface -> d_minus_device
	reg d_plus_deviceout_en;
	reg d_minus_deviceout_en;
	reg pullup_on;
	reg se0_done;

	assign VBUS_comparator_output_o = (VBUS_divider_voltage_i > VBUS_COMPARATOR_REFERENCE); //VBUS comparator logic
	assign detection_variable = ((!d_plus_deviceout_en && !d_minus_deviceout_en) && (d_plus_device === 1'b0 && d_minus_device ===1'b0));
	assign control_reg_0 = (!reset_usb)? sync_ff2 : control_reg_0_ff; //Assuming that this net to be 0th bit of control/flag register

	assign d_plus_device = (d_plus_deviceout_en)? d_plus_deviceout : 1'bz;  //D+ device driving logic
	assign d_minus_device = (d_minus_deviceout_en)? d_minus_deviceout : 1'bz; //D- device driving logic

	assign (weak1,weak0)d_plus_device = (VBUS_device && pullup_on)? 1'b1 : 1'bz; //D+ device passive pullup
	assign (weak0,weak1)d_minus_device = (VBUS_device && pullup_on)? 1'b0 : 1'bz; //D- device passive state

	initial begin	// Initializations
		detection_duration_device_en = 1'b0;
		d_plus_deviceout = 1'b0;
		d_minus_deviceout = 1'b1;
		detection_duration_device = 22'b0;
		reset_usb = 1'b0;
		chirp_count = 3'd0;
		chirp_on = 1'b0;
		d_plus_deviceout_en = 1'b0;
		d_minus_deviceout_en = 1'b0;
		J = 0;
		K = 0;
		se0_done = 0;
		term_en = 0;
		HIGH_SPEED = 0;
	end

	always @ (posedge clk) begin
		
		if (VBUS_device && ((detection_variable && detection_duration_device_en) || chirp_on)) begin
			detection_duration_device <= detection_duration_device+1;
		end

		case(state_device)
			
			IDLE : begin
				sync_ff1 <= VBUS_comparator_output_o;
				sync_ff2 <= sync_ff1;
				control_reg_0_ff <= sync_ff2;
				detection_duration_device_en <= 1'b1;
				d_plus_deviceout_en <= 1'b0;
				d_minus_deviceout_en <= 1'b0;
				if(!se0_done)begin
					pullup_on <= 1'b1;
				end
				if(detection_duration_device == 22'd120)begin   //should remove the counter later!!!
					state_device <= RESET;
					detection_duration_device_en <= 1'b0;
					pullup_on <= 1'b0;
					se0_done <= 1'b1;
				end	
			end

			RESET : begin
				sync_ff1 <= 0;
				sync_ff2 <= 0;
				reset_usb <= 1'b1;
				detection_duration_device <= 22'd0;
				state_device <= K_PULSE;
			end

			HIGH_Z : begin
				
			end

			KJ_DETECT : begin
				if(K<=4'd3 && J <= 4'd3)begin	
					if(d_plus_device === 1'b0 && d_minus_device === 1'b1)begin
						K <= J+1;
					end
					else if(d_plus_device === 1'b1 && d_minus_device === 1'b0)begin
						J <= K;
					end
				end
				else begin
					J <= 4'd0;
					K <= 4'd0;
					HIGH_SPEED <= 1'b1;
					term_en <= 1'b1;
					state_device <= HIGH_Z;
				end
			end

			K_PULSE : begin
				chirp_on <= 1'b1;
				d_plus_deviceout_en <= 1'b1;
				d_minus_deviceout_en <= 1'b1;
				d_plus_deviceout <= 1'b0;
				d_minus_deviceout <= 1'b1;
				if(detection_duration_device == 22'd20)begin
					detection_duration_device <= 22'd0;
					chirp_on <= 1'b0;
					d_plus_deviceout_en <= 1'b0;
					d_minus_deviceout_en <= 1'b0;
					state_device <= KJ_DETECT;
				end
			end

			default : begin 
				state_device <= IDLE;
			end
		endcase
	end

endmodule
