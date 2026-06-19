module token_handler(
    input wire th_clk_i,
    input wire th_reset,
    input wire th_enable,
    input wire th_eop_i,
    input wire th_sync_i,
    input wire [10:0]th_bytes_i,  //only the 11 bits : 7 addr + 4 endp
    input wire [1:0]th_byte_ready_i, // byte 2 and 3 only as 1st one is pid.
    input wire [4:0]th_crc5_i,
    output reg th_crc_reset_o,
    output reg th_token_valid_o,
    output reg th_crc_fail_o,
    output reg th_packet_error_o,
    output reg [6:0]th_addr_o,
    output reg [3:0]th_endp_o
);

    localparam IDLE = 2'b00;
    localparam ACTIVE = 2'b01;

    reg [1:0]STATE;
    
    always@(posedge th_clk_i or posedge th_reset)begin
        if(th_reset)begin
            th_crc_reset_o<=1'b0;
            th_token_valid_o<=1'b0;
            th_crc_fail_o<=1'b0;
            th_addr_o<=7'b0;
            th_endp_o<=4'b0;
            th_packet_error_o<=1'b0;
            STATE<=2'b0;
        end
        else begin
            th_token_valid_o<=1'b0;
            th_crc_fail_o<=1'b0;
            th_crc_reset_o<=1'b0;
            th_packet_error_o<=1'b0;
            case(STATE)
                IDLE : begin
                    STATE<=(th_enable)?ACTIVE:IDLE;
                    th_addr_o<=7'b0;
                    th_endp_o<=4'b0;
                end
                ACTIVE : begin
                    if(th_byte_ready_i[0])begin
                        th_addr_o<=th_bytes_i[10:4];
                    end
                    if(th_byte_ready_i[1])begin
                        th_endp_o<=th_bytes_i[3:0];
                        STATE<=IDLE;
                        if(th_crc5_i==5'b0)begin
                            th_token_valid_o<=1'b1;
                            th_crc_reset_o<=1'b1;
                        end
                        else begin
                            th_crc_fail_o<=1'b1;
                            th_crc_reset_o<=1'b1;
                        end   
                    end
                end
                default :  STATE<=IDLE;
            endcase
            if(STATE==ACTIVE) begin
                if(th_eop_i | th_sync_i)begin
                    th_packet_error_o<=1'b1;
                    th_crc_reset_o<=1'b1;
                    STATE<=IDLE;
                end
            end
        end
    end

endmodule