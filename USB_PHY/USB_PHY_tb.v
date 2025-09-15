//modules must start with reset. This is mandatory
`timescale 1ns / 1ns
module USB_PHY_tb;
reg clk;

tri d_plus_device,d_minus_device; //device data lines
tri d_plus,d_minus; //host data lines

reg [7:0] VBUS_divider_voltage_i;
wire control_reg_0;
wire device_present;
reg VBUS_device;
reg host_state;
reg d_plus_deviceout_en,d_minus_deviceout_en; //device out enables
wire HIGH_SPEED;
wire d_plus_hostout_en_wire = USB_PHY_tb.uut_host.d_plus_hostout_en;
wire d_minus_hostout_en_wire = USB_PHY_tb.uut_host.d_minus_hostout_en;
//wire d_plus_hostout_wire = USB_PHY_tb.uut_host.d_plus_hostout;
//wire d_minus_hostout_wire = USB_PHY_tb.uut_host.d_minus_hostout;
	
assign d_plus = (VBUS_device && !d_plus_hostout_en_wire)? d_plus_device : 1'bz;
assign d_minus = (VBUS_device && !d_minus_hostout_en_wire)? d_minus_device : 1'bz;
assign d_plus_device = (VBUS_device && d_plus_hostout_en_wire)? d_plus : 1'bz;
assign d_minus_device = (VBUS_device && d_minus_hostout_en_wire)? d_minus : 1'bz;

USB_PHY uut_device(
	.d_plus_device(d_plus_device),
	.d_minus_device(d_minus_device),
	//.d_plus_deviceout_en(d_plus_deviceout_en),
	//.d_minus_deviceout_en(d_minus_deviceout_en),
	.VBUS_divider_voltage_i(VBUS_divider_voltage_i),
	.clk(clk),
	.control_reg_0(control_reg_0),
	.VBUS_device(VBUS_device)
);

HOST_PHY uut_host(
	.clk(clk),
	.d_plus(d_plus),
	.d_minus(d_minus),
	.device_present(device_present),
	.HIGH_SPEED(HIGH_SPEED)
);

always @(*) begin
	case(USB_PHY_tb.uut_host.state)
		3'd0:$display("HOST - FLOAT");
		3'd1:$display("HOST - IDLE");
		3'd2:$display("HOST - SE0");
		3'd3:$display("HOST - RELEASE");
		3'd4:$display("HOST - CHIRP_DETECT");
		3'd5:$display("HOST - J_PULSE");
		3'd6:$display("HOST - K_PULSE");
		3'd7:$display("HOST - HIGH_Z");
	endcase
	case(USB_PHY_tb.uut_device.state_device)
		3'd0:$display("DEVICE - IDLE");
		3'd1:$display("DEVICE - RESET");
		3'd2:$display("DEVICE - HIGH_Z");
		3'd3:$display("DEVICE - K_PULSE");
		3'd4:$display("DEVICE - JK_DETECT");
	endcase
end




initial begin
	$dumpfile("USB_PHY_tb.vcd");
	$dumpvars(0, USB_PHY_tb);
		$display("Time|comp_o/p|c_reg|DD_en|D+_D-_D|HD_en|D+_D-_H|chirp_c|K_count| De_Du |HS_D|HS_H|");
	//2$display("Time|comp_o/p|c_reg|D+_d_en|D-_d_en|D+_device|D-_device|D+_h_en|D-_h_en|D+|D-|state|chirp_c|");
	//$display("Time|VBUS_divider_voltage_i|VBUS_comparator_output_o|reset|control_reg_0|d_plus_device|d_plus|");
	//1$display("Time|device_present|d_plus|d_minus|d_plus_hostout_en|d_minus_hostout_en|state|  detection_duration  |");
end

always @ (posedge clk) begin
$display("%3t |    %b   |  %b  | %b  |   %b  |  %b |   %b  |  %3b  |   %d  |%d|  %b |  %b |",$time,USB_PHY_tb.uut_device.VBUS_comparator_output_o,control_reg_0,{USB_PHY_tb.uut_device.d_plus_deviceout_en,USB_PHY_tb.uut_device.d_minus_deviceout_en},{d_plus_device,d_minus_device},{d_plus_hostout_en_wire,d_minus_hostout_en_wire},{d_plus,d_minus},USB_PHY_tb.uut_device.chirp_count,USB_PHY_tb.uut_host.K_count,USB_PHY_tb.uut_host.detection_duration,USB_PHY_tb.uut_device.HIGH_SPEED,HIGH_SPEED);
//2$display("%3t |    %b   |  %b  |   %b   |   %b   |    %b    |    %b    |   %b   |   %b   | %b| %b| %2b  |  %3b  |",$time,USB_PHY_tb.uut_device.VBUS_comparator_output_o,control_reg_0,USB_PHY_tb.uut_device.d_plus_deviceout_en,USB_PHY_tb.uut_device.d_minus_deviceout_en,d_plus_device,d_minus_device,d_plus_hostout_en_wire,d_minus_hostout_en_wire,d_plus,d_minus,USB_PHY_tb.uut_host.state,USB_PHY_tb.uut_device.chirp_count);
//$display("%3t |  \t\t%3d\t   |\t\t%b\t    |  %b  |\t%b \t|      %b      |  %b   |",$time,VBUS_divider_voltage_i,USB_PHY_tb.uut_device.VBUS_comparator_output_o,reset_usb,control_reg_0,d_plus_device,d_plus);
//1$display(" %3t|       %b      |  %b   |   %b   |        %b        |         %b        | %2b  |%22b|",$time,device_present,d_plus,d_minus,d_plus_hostout_en_wire,d_minus_hostout_en_wire,USB_PHY_tb.uut_host.state,USB_PHY_tb.uut_host.detection_duration);

end

//clock initialization
initial clk = 0;
always begin
#1 clk = ~clk;
end

//Stimulus
	initial begin

		//d_plus_deviceout_en = 1'b0;
		//d_minus_deviceout_en = 1'b0;
		VBUS_device = 1'b0;
	#1  	VBUS_divider_voltage_i = 8'd0;
	#14	VBUS_divider_voltage_i = 8'd67;
		VBUS_device = 1'b1;
	//#4800430;
	#2000
	#1 $finish;
	end

endmodule
