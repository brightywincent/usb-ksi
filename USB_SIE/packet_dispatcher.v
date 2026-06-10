`include "PID.vh"
module packet_dispatcher(
    input wire pdis_clk_i,
	input wire pdis_reset, 
	input wire [3:0]pdis_pid_i,
    input wire pdis_valid_i,
    output reg pdis_token_o,
    output reg pdis_data_o,
    output reg pdis_handshake_o,
    output reg pdis_special_o,
);
    always@(posedge pdis_clk_i or posedge pdis_reset)begin
        if(pdis_reset)begin
            pdis_token_o<=1'b0;
            pdis_data_o<=1'b0;
            pdis_handshake_o<=1'b0;
            pdis_special_o<=1'b0;
        end
        else begin
            pdis_token_o<=1'b0;
            pdis_data_o<=1'b0;
            pdis_handshake_o<=1'b0;
            pdis_special_o<=1'b0;
            if(pdis_valid_i) begin
                case(pdis_pid_i) 
                
                `PID_OUT,`PID_SOF,
                `PID_IN,`PID_SETUP : pdis_token_o<=1'b1;

                `PID_DATA0,`PID_DATA2,
                `PID_DATA1,`PID_MDATA : pdis_data_o<=1'b1;

                `PID_ACK,`PID_NYET,
                `PID_NAK,`PID_STALL : pdis_handshake_o<=1'b1;

                `PID_PING,`PID_SPLIT,
                `PID_PRE : pdis_special_o<=1'b1;

                endcase
            end
        end
    end
endmodule