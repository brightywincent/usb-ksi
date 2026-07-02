module handshake_decoder(
    input wire hd_clk_i,
    input wire hd_reset,

    input wire [3:0]hd_pid_i,
    input wire hd_pid_valid_i,

    output reg hd_ack_o,
    output reg hd_nyet_o,
    output reg hd_nak_o,
    output reg hd_stall_o
);

    always@(posedge hd_clk_i or posedge hd_reset)begin
        if(hd_reset)begin
            hd_ack_o<=1'b0;
            hd_nyet_o<=1'b0;
            hd_nak_o<=1'b0;
            hd_stall_o<=1'b0;
        end
        else begin
            hd_ack_o<=1'b0;
            hd_nyet_o<=1'b0;
            hd_nak_o<=1'b0;
            hd_stall_o<=1'b0;
            if(hd_pid_valid_i)begin
                case(hd_pid_i)
                    `PIDN_ACK : hd_ack_o<=1'b1;
                    `PIDN_NYET : hd_nyet_o<=1'b1;
                    `PIDN_NAK : hd_nak_o<=1'b1;
                    `PIDN_STALL : hd_stall_o<=1'b1;
                endcase
            end
        end
    end

endmodule