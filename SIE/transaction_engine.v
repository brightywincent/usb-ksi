`include "PID.vh"
module transaction_engine(
    input wire te_clk_i;
    input wire te_reset;
    input wire te_sync_i;
    input wire te_eop_i;

    input wire [3:0]te_pid_nibble_i;
    input wire te_pid_valid_i;

    input wire te_token_trigger_i;
    input wire te_token_valid_i;
    input wire te_token_pac_err_i;
    input wire te_crc5_fail_i;
    input wire [6:0]te_addr_i;
    input wire [3:0]te_endp_i;

    input wire te_data_trigger_i;
    input wire te_data_valid_i;
    input wire te_data_pac_err_i;
    input wire te_crc16_fail_i;

    input wire te_handshake_trigger_i;

    input wire te_timeout_i;

    output reg te_send_ack_o;

    output reg te_protocol_err_o;
);

    localparam IDLE=3'b000;
    localparam OUT_TR=3'b001;
    localparam IN_TR=3'b010;
    localparam =3'b011;


    reg [2:0]STATE;
    reg [2:0]SUB_STATE;

    reg te_ignore; //just for testing
    reg te_abort;

    always@(posedge te_clk_i or posedge te_reset)begin
        if(te_reset)begin
            te_send_ack_o<=1'b0;
            te_protocol_err_o<=1'b0;
            te_ignore<=1'b0;
            te_abort<=1'b0;
            STATE<=3'b0;
            SUB_STATE<=3'b0;
        end
        else begin
            te_ignore<=1'b0;
            te_abort<=1'b0;
            te_protocol_err_o<=1'b0;
            te_send_ack_o<=1'b0;
            case(STATE)
                IDLE : begin
                    if(te_token_trigger_i)begin
                        if(te_pid_nibble_i==`PIDN_OUT)begin
                            STATE<=OUT_TR;
                        end
                        if(te_pid_nibble_i==`PIDN_IN)begin
                            STATE<=IN_TR;
                        end
                    end
                end
                OUT_TR : begin
                    case(SUB_STATE)
                        IDLE : begin
                            SUB_STATE<=IDLE;
                            if(te_token_pac_err_i || te_crc5_fail_i)begin
                                te_ignore<=1'b1;
                                STATE<=IDLE;
                                SUB_STATE<=IDLE;
                            end
                            else if(te_token_valid)begin
                                SUB_STATE<=OUT;
                                //note address and endpoint
                            end
                        end
                        OUT : begin
                            if(te_timeout_i)begin
                                te_abort<=1'b1;
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
                            end
                        end
                        DATA : begin
                            if(te_timeout_i)begin
                                te_abort<=1'b1;
                                SUB_STATE<=IDLE;
                                STATE<=IDLE;
                            end
                            else if(te_data_pack_err_i || te_crc16_fail_i)begin
                                te_ignore<=1'b1;
                                SUB_STATE<=IDLE;
                                STATE<=IDLE;
                            end
                            else if(te_data_valid)begin
                                te_send_ack_o<=1'b1;
                                SUB_STATE<=IDLE;
                                STATE<=IDLE;
                            end
                        end
                        default : SUB_STATE<=IDLE;
                    endcase
                    IN_TR : begin
                        case()
                            
                        endcase
                    end
                end
                default : STATE<=IDLE;
            endcase
        end
    end

endmodule