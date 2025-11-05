`include "PID.vh"

module pid_decoder(
	input wire clk,
	input wire pid_valid,
	input wire [7:0]pid,
	output reg [3:0]token_sub,//[0]OUT_00,[1]SOF_01,[2]IN_10,[3]SETUP_11
	output reg [3:0]data_sub, //[0]DATA0_00,[1]DATA2_01,[2]DATA1_10,[3]MDATA_11
	output reg [3:0]handshake_sub, //[0]ACK_00,[1]NYET_01,[2]NAK_10,[3]STALL_11
	output reg [3:0]special_sub  //[0]_00,[1]PING_01,[2]SPLIT_10,[3]PRE_11
)

always@(posedge clk or reset) begin
	if(reset) begin
		token_sub<=4'd0;
		data_sub<=4'd0;
		handshake_sub<=4'd0;
		special_sub<=4'd0;
	end
	else if(pid_valid) begin
		case(pid)
			`PID_OUT : token_sub[0]<=1'b1;
			`PID_SOF : token_sub[1]<=1'b1;
			`PID_IN : token_sub[2]<=1'b1;
			`PID_SETUP : token_sub[3]<=1'b1;
			`PID_DATA0 : data_sub[0]<=1'b1;
			`PID_DATA2 : data_sub[1]<=1'b1;
			`PID_DATA1 : data_sub[2]<=1'b1;
			`PID_MDATA : data_sub[3]<=1'b1;		
			`PID_ACK : handshake_sub[0]<=1'b1;
			`PID_NYET : handshake_sub[1]<=1'b1;
			`PID_NAK : handshake_sub[2]<=1'b1;
			`PID_STALL : handshake_sub[3]<=1'b1;
			`PID_PING : special_sub[1]<=1'b1;
			`PID_SPLIT : special_sub[2]<=1'b1;
			`PID_PRE : special_sub[3]<=1'b1;
		endcase
	end
	else begin
		token_sub<=4'd0;
		data_sub<=4'd0;
		handshake_sub<=4'd0;
		special_sub<=4'd0;
	end
end
