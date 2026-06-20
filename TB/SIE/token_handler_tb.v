module token_handler_tb;
    reg th_clk_i;
    reg th_reset;
    reg th_trigger;
    reg th_eop_i;
    reg th_sync_i;
    reg [10:0]th_bytes_i;
    reg [1:0]th_byte_ready_i;
    reg [4:0]th_crc5_i;
    wire th_crc_reset_o;
    wire th_token_valid_o;
    wire th_crc_fail_o;
    wire th_packet_error_o;
    wire [6:0]th_addr_o;
    wire [3:0]th_endp_o;

    reg [8*6:1]s;

    token_handler th_1(
        .th_clk_i(th_clk_i),
        .th_reset(th_reset),
        .th_trigger(th_trigger),
        .th_eop_i(th_eop_i),
        .th_sync_i(th_sync_i),
        .th_bytes_i(th_bytes_i),
        .th_byte_ready_i(th_byte_ready_i),
        .th_crc5_i(th_crc5_i),
        .th_crc_reset_o(th_crc_reset_o),
        .th_token_valid_o(th_token_valid_o),
        .th_crc_fail_o(th_crc_fail_o),
        .th_packet_error_o(th_packet_error_o),
        .th_addr_o(th_addr_o),
        .th_endp_o(th_endp_o)
    );

    initial begin
        $dumpfile("TB/SIE/DUMP/token_handler.vcd");
        $dumpvars(0,token_handler_tb);
        $display("|Time|Clk|Reset|En|Sync|EOP|Bytes(11-bits)|Byte_ready|State |CRC5 |Token_valid| Addr  |Endp|CRC_reset|CRC_fail|Pack_err|");
    end

    always@(posedge th_clk_i)begin
        $display("|%4t| %b |  %b  |%b | %b  | %b | %11b  |    %2b    |%s|%5b|     %b     |%7b|%4b|    %b    |   %b    |   %b    |",$time,th_clk_i,th_reset,th_trigger,th_sync_i,th_eop_i,th_bytes_i,th_byte_ready_i,s,th_crc5_i,th_token_valid_o,th_addr_o,th_endp_o,th_crc_reset_o,th_crc_fail_o,th_packet_error_o);
        case(th_1.STATE)
            2'b00 : s="IDLE";
            2'b01 : s="ACTIVE";
            default : s="IDLE";
        endcase
    end

    initial begin
        th_clk_i=1'b1;
        th_reset=1'b1;
        th_trigger=1'b0;
        th_eop_i=1'b0;
        th_sync_i=1'b0;
        th_bytes_i=11'b0;
        th_byte_ready_i=2'b0;
        th_crc5_i=5'b0;
    end

    always begin
        #1 th_clk_i=~th_clk_i;
    end

    initial begin
        #2 th_reset=1'b0;
        #2 th_sync_i=1'b1;
        #2 th_sync_i=1'b0;
        #10 th_trigger=1'b1;
        #2 th_trigger=1'b0;
        #14 th_byte_ready_i[0]=1'b1;
            th_bytes_i[7:0]=8'b0000_1111;  // 0000_1111_0000_0001
        #2 th_byte_ready_i[0]=1'b0;
        #14 th_byte_ready_i[1]=1'b1;
            th_bytes_i[10:8]=3'b000;
            th_crc5_i=5'b0;
        #2 th_byte_ready_i[1]=1'b0;
        #7 $finish;
    end

endmodule