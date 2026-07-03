`include "PID.vh"
module transaction_engine#(
    parameter RESPONSE_TIMEOUT=10'd816
)(
    input wire te_clk_i,
    input wire te_reset,
    //input wire te_sync_i,
    //input wire te_eop_i,

    input wire [3:0]te_pid_nibble_i,
    //input wire te_pid_valid_i,

    input wire te_token_trigger_i, //token handler net
    input wire te_token_valid_i,
    input wire te_token_pac_err_i,
    input wire te_crc5_fail_i,
    input wire [6:0]te_addr_i,
    input wire [3:0]te_endp_i,

    input wire te_data_trigger_i, //data handler net
    input wire te_data_valid_i,
    input wire te_data_pac_err_i,
    input wire te_crc16_fail_i,

    input wire te_handshake_trigger_i, //handshake handler net
    input wire te_ack_i,
    input wire te_stall_i,
    input wire te_nak_i,

    input wire te_timeout_i,

    input wire te_endp_data_toggle_i,
    input wire te_endp_data_fail_i,
    input wire te_endp_empty_i,
    input wire te_endp_tx_done_i,
    input wire te_endp_stalled_i,
    input wire te_endp_ready_i,  //flag

    output reg te_send_ack_o,
    output reg te_send_nak_o,
    output reg te_send_stall_o,
    output reg te_send_data_o,
    output reg te_data_toggle_o,
    output reg te_clear_endp_buff_o,
    output reg te_setup_done_o,

    output reg te_protocol_err_o
);
    //For both STATE and SUB_STATE
    localparam IDLE=3'd0; 
    //For STATE
    localparam OUT_TR=3'd1; 
    localparam IN_TR=3'd2;
    localparam SETUP_TR=3'd3;
    //For SUB_STATE
    localparam OUT=3'd1;  
    localparam IN=3'd1;
    localparam CONFIRM=3'd1;
    localparam DATA=3'd2;
    localparam RESPONSE=3'd3;

    reg [2:0]STATE;
    reg [2:0]SUB_STATE;

    reg[9:0]te_timer;
    reg te_timer_en;

    reg te_ignore; //just for 
    reg te_abort;  //testing

    always@(posedge te_clk_i or posedge te_reset)begin
        if(te_reset)begin
            te_send_ack_o<=1'b0;
            te_send_nak_o<=1'b0;
            te_send_data_o<=1'b0;
            te_send_stall_o<=1'b0;
            te_data_toggle_o<=1'b0;
            te_clear_endp_buff_o<=1'b0;
            te_protocol_err_o<=1'b0;
            te_ignore<=1'b0;
            te_abort<=1'b0;
            STATE<=3'b0;
            SUB_STATE<=3'b0;
            te_timer<=10'b0;
            te_timer_en<=1'b0;
            te_setup_done_o<=1'b0;
        end
        else begin
            te_ignore<=1'b0;
            te_abort<=1'b0;
            te_protocol_err_o<=1'b0;
            te_send_ack_o<=1'b0;
            te_send_nak_o<=1'b0;
            te_send_stall_o<=1'b0;
            te_send_data_o<=1'b0;
            te_data_toggle_o<=1'b0;
            te_clear_endp_buff_o<=1'b0;
            te_setup_done_o<=1'b0;
            case(STATE)
                IDLE : begin
                    SUB_STATE<=IDLE;
                    te_timer_en<=1'b0;
                    if(te_token_trigger_i)begin
                        case(te_pid_nibble_i)
                            `PIDN_OUT : STATE<=OUT_TR;
                            `PIDN_IN : STATE<=IN_TR;
                            `PIDN_SETUP : STATE<=SETUP_TR;
                            default: STATE<=IDLE;
                        endcase
                    end
                    if(te_data_trigger_i || te_handshake_trigger_i)begin
                        te_protocol_err_o<=1'b1;
                    end
                end
                OUT_TR : begin
                    if(te_timeout_i)begin
                        te_abort<=1'b1;
                        SUB_STATE<=IDLE;
                        STATE<=IDLE;
                    end
                    else begin 
                        case(SUB_STATE)
                            IDLE : begin
                                if(te_token_pac_err_i || te_crc5_fail_i)begin
                                    te_ignore<=1'b1;
                                    STATE<=IDLE;
                                end
                                else if(te_token_valid_i)begin
                                    SUB_STATE<=OUT;
                                    te_timer_en<=1'b1;
                                    //note address and endpoint
                                end
                            end
                            OUT : begin
                                if(te_timer==RESPONSE_TIMEOUT-1)begin
                                    te_timer_en<=1'b0;
                                    SUB_STATE<=IDLE;
                                    STATE<=IDLE;
                                end
                                else if(te_handshake_trigger_i)begin
                                    te_protocol_err_o<=1'b1;
                                    SUB_STATE<=IDLE;
                                    STATE<=IDLE;
                                end
                                else if(te_token_trigger_i)begin
                                    te_abort<=1'b1;
                                    SUB_STATE<=IDLE;
                                    STATE<=IDLE;
                                end
                                else if(te_data_trigger_i)begin
                                    SUB_STATE<=DATA;
                                    te_timer_en<=1'b0;
                                end
                            end
                            DATA : begin
                                if(te_data_pac_err_i || te_crc16_fail_i)begin
                                    te_ignore<=1'b1;
                                    SUB_STATE<=IDLE;
                                    STATE<=IDLE;
                                end
                                else if(te_data_valid_i)begin
                                    te_send_ack_o<=1'b1;
                                    te_data_toggle_o<=1'b1;  //if ack is lost in the middle,
                                    SUB_STATE<=IDLE;        //host resends the same DATA packet
                                    STATE<=IDLE;            //device must detect it as a duplicate &
                                end                         //send ack again
                            end
                            default : SUB_STATE<=IDLE;
                        endcase
                    end
                end
                IN_TR : begin
                    if(te_timeout_i)begin
                        te_abort<=1'b1;
                        SUB_STATE<=IDLE;
                        STATE<=IDLE;
                    end
                    else begin 
                        case(SUB_STATE)
                            IDLE : begin
                                if(te_token_pac_err_i || te_crc5_fail_i)begin
                                    te_ignore<=1'b1;
                                    STATE<=IDLE;
                                    SUB_STATE<=IDLE;
                                end
                                else if(te_token_valid_i)begin
                                    SUB_STATE<=IN;
                                end 
                            end
                            IN : begin
                                if(te_endp_empty_i)begin
                                    te_send_nak_o<=1'b1;
                                    STATE<=IDLE;
                                    SUB_STATE<=IDLE;
                                end
                                else if(te_endp_stalled_i)begin
                                    te_send_stall_o<=1'b1;
                                    STATE<=IDLE;
                                    SUB_STATE<=IDLE;
                                end
                                else if(te_endp_ready_i)begin
                                    te_send_data_o<=1'b1;
                                    SUB_STATE<=DATA;
                                end
                            end
                            DATA : begin
                                if(te_endp_data_fail_i)begin
                                    STATE<=IDLE;
                                    SUB_STATE<=IDLE;
                                end
                                else if(te_endp_tx_done_i)begin
                                    SUB_STATE<=RESPONSE;
                                    te_timer_en<=1'b1;
                                end
                            end
                            RESPONSE : begin
                                if(te_timer==RESPONSE_TIMEOUT-1)begin
                                    te_timer<=10'b0;
                                    SUB_STATE<=IDLE;
                                    STATE<=IDLE;
                                end
                                else if(te_ack_i)begin
                                    te_clear_endp_buff_o<=1'b1;
                                    te_data_toggle_o<=1'b1;
                                    te_timer_en<=1'b0;
                                    SUB_STATE<=IDLE;
                                    STATE<=IDLE;
                                end
                                else if(te_stall_i || te_nak_i)begin
                                    te_protocol_err_o<=1'b1;
                                    te_timer_en<=1'b0;
                                    SUB_STATE<=IDLE;
                                    STATE<=IDLE;
                                end
                            end
                            default : SUB_STATE<=IDLE;
                        endcase
                    end
                end
                SETUP_TR : begin    //'Sending control request DATA'
                    if(te_timeout_i)begin
                        te_abort<=1'b1;
                        SUB_STATE<=IDLE;
                        STATE<=IDLE;
                    end
                    else begin
                        case(SUB_STATE)
                            IDLE : begin
                                if(te_token_pac_err_i || te_crc5_fail_i)begin
                                    te_ignore<=1'b1;
                                    STATE<=IDLE;
                                end
                                else if(te_token_valid_i)begin
                                    SUB_STATE<=CONFIRM;
                                    te_timer_en<=1'b1;
                                end
                            end
                            CONFIRM : begin
                                if(te_timer==RESPONSE_TIMEOUT-1)begin
                                    te_timer_en<=1'b0;
                                    SUB_STATE<=IDLE;
                                    STATE<=IDLE;
                                end
                                else if(te_data_trigger_i)begin
                                    te_timer_en<=1'b0;
                                    if(te_pid_nibble_i==`PIDN_DATA0)
                                        SUB_STATE<=DATA;
                                    else begin
                                        SUB_STATE<=IDLE;
                                        STATE<=IDLE;
                                    end        
                                end
                            end
                            DATA : begin //DATA0 only
                                if(te_data_pac_err_i || te_crc16_fail_i)begin
                                    te_ignore<=1'b1;
                                    SUB_STATE<=IDLE;
                                    STATE<=IDLE;
                                end
                                else if(te_data_valid_i)begin
                                    te_send_ack_o<=1'b1;
                                    te_data_toggle_o<=1'b1;  //if ack is lost in the middle,
                                    SUB_STATE<=IDLE;        //host resends the same DATA packet
                                    STATE<=IDLE;            //device must detect it as a duplicate &
                                    te_setup_done_o<=1'b1;  //send ack again
                                end                         
                            end
                            default : SUB_STATE<=IDLE;
                        endcase
                    end
                end
                default : STATE<=IDLE;
            endcase
            if(te_timer_en)begin
                te_timer<=te_timer+1;
            end
            else 
                te_timer<=10'b0;
        end
    end
endmodule
