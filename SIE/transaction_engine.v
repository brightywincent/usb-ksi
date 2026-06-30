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

    input wire te_timeout_i;

    output reg te_send_ack_o;

    output reg te_protocol_err_o;
);

    localparam IDLE=2'b00;
    localparam TOKEN=2'b01;
    localparam DATA=2'b10;
    localparam HANDSHAKE=2'b11;

    reg [1:0]STATE;

    reg te_ignore; //just for testing
    reg te_abort;

    always@(posedge te_clk_i or posedge te_reset)begin
        if(te_reset)begin
            te_send_ack_o<=1'b0;
            te_protocol_err_o<=1'b0;
            STATE<=2'b0;
        end
        else begin
            case(STATE)
                IDLE : begin
                    if(te_token_trigger_i)begin
                        STATE<=TOKEN;
                    end
                end
                TOKEN : begin
                    case(te_pid_nibble_i)
                        `PIDN_OUT : begin
                            if(te_token_valid_i)begin
                                STATE<=DATA;
                            end
                        end
                        `PIDN_IN : begin
                            
                        end
                        `PIDN_SETUP :begin

                        end
                    endcase
                end
                DATA : begin

                end
                HANDSHAKE : begin

                end
                default : STATE<=IDLE;
            endcase
        end
    end

endmodule