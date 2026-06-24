module data_handler_tb;
    reg dh_clk_i;
    reg dh_reset;
    reg dh_trigger;
    reg dh_eop_start_i;
    reg dh_sync_i;
    reg [31:0]dh_bytes_i;  
    reg [3:0]dh_byte_ready_i; 
    reg [15:0]dh_crc16_i;
    wire dh_write_o;
    wire dh_crc16_reset_o;
    wire dh_data_valid_o;
    wire dh_crc16_fail_o;
    wire dh_packet_error_o;
    wire [7:0]dh_byte_o;

    data_handler dh_1(
        .dh_clk_i(dh_clk_i),
        .dh_reset(dh_reset),
        .dh_trigger(dh_trigger),
        .dh_eop_start_i(dh_eop_start_i),
        .dh_sync_i(dh_sync_i),
        .dh_bytes_i(dh_bytes_i),  
        .dh_byte_ready_i(dh_byte_ready_i), 
        .dh_crc16_i(dh_crc16_i),
        .dh_write_o(dh_write_o),
        .dh_crc16_reset_o(dh_crc16_reset_o),
        .dh_data_valid_o(dh_data_valid_o),
        .dh_crc16_fail_o(dh_crc16_fail_o),
        .dh_packet_error_o(dh_packet_error_o),
        .dh_byte_o(dh_byte_o)
    );
    
    initial begin
        $dumpfile("TB/SIE/DUMP/data_handler.vcd");
        $dumpvars(0,data_handler_tb);
        $display("|Time|Clk|Reset|Trigger|eop|sync|             Bytes              |Byte_ready|CRC_16|CRC16_reset|CRC16_fail|pack_err|Data_valid| Byte_o |write|");
    end

    always@(posedge dh_clk_i) begin
        $display("|%4t| %b |  %b  |   %b   | %b | %b  |%32b|   %4b   | %4h |     %b     |    %b     |   %b    |    %b     |%8b|  %b  |",$time,dh_clk_i,dh_reset,dh_trigger,dh_eop_start_i,dh_sync_i,dh_bytes_i,dh_byte_ready_i,dh_crc16_i,dh_crc16_reset_o,dh_crc16_fail_o,dh_packet_error_o,dh_data_valid_o,dh_byte_o,dh_write_o);
    end

    initial begin
        dh_clk_i=1'b1;
        dh_reset=1'b1;
        dh_trigger=1'b0;
        dh_eop_start_i=1'b0;
        dh_sync_i=1'b0;
        dh_bytes_i=32'b0;  
        dh_byte_ready_i=4'b0; 
        dh_crc16_i=16'b0;
    end

    always begin
        #1 dh_clk_i=~dh_clk_i;
    end

    initial begin
       #2 dh_reset=1'b0;
       #2 dh_sync_i=1'b1;
       #2 dh_sync_i=1'b0;

       #10 dh_trigger=1'b1;
       #2 dh_trigger=1'b0;

       #10 dh_bytes_i[7:0]=8'b1100_0011;  // payload byte1 is 0101_1010, byte0 is 1100_0011.
           dh_byte_ready_i=4'b0001;
          #2 dh_byte_ready_i=4'b0;
        #10 dh_bytes_i[15:8]=8'b0101_1010;  
           dh_byte_ready_i=4'b0010;
          #2 dh_byte_ready_i=4'b0;
           dh_crc16_i=16'b0;
        #2 dh_eop_start_i=1'b1;
        #2 dh_eop_start_i=1'b0;

//unexpected eop starts
        #8 dh_sync_i=1'b1;
       #2 dh_sync_i=1'b0;

       #10 dh_trigger=1'b1;
       #2 dh_trigger=1'b0;

       #10 dh_bytes_i[7:0]=8'b1100_0011;  // payload byte1 is 0101_1010, byte0 is 1100_0011.
           dh_byte_ready_i=4'b0001;
         #2  dh_byte_ready_i=4'b0;     // payload byte3 is 1101_1011, byte2 is 1000_0001.
        #10 dh_bytes_i[15:8]=8'b0101_1010;  
           dh_byte_ready_i=4'b0010;
           #2 dh_byte_ready_i=4'b0;
           dh_crc16_i=4'b0001;
        #2 dh_eop_start_i=1'b1;
        #2 dh_eop_start_i=1'b0;
//unexpected sync appears
       #8 dh_sync_i=1'b1;
       dh_crc16_i=4'b0000;
       #2 dh_sync_i=1'b0;

       #10 dh_trigger=1'b1;
       #2 dh_trigger=1'b0;

       #10 dh_bytes_i[7:0]=8'b1100_0011;  // payload byte1 is 0101_1010, byte0 is 1100_0011.
           dh_byte_ready_i=4'b0001; 
           #2 dh_byte_ready_i=4'b0;    // payload byte3 is 1101_1011, byte2 is 1000_0001.
        #10 dh_bytes_i[15:8]=8'b0101_1010;  
           dh_byte_ready_i=4'b0010;
           #2 dh_byte_ready_i=4'b0;
           dh_crc16_i=4'b0000;
        #2 dh_sync_i=1'b1;
        #2 dh_sync_i=1'b0;

//successful transmission
    #8 dh_sync_i=1'b1;
       #2 dh_sync_i=1'b0;

       #10 dh_trigger=1'b1;
       #2 dh_trigger=1'b0;

       #10 dh_bytes_i[7:0]=8'b1100_0011;  // payload byte1 is 0101_1010, byte0 is 1100_0011.
           dh_byte_ready_i=4'b0001;
           #2 dh_byte_ready_i=4'b0;     // payload byte3 is 1101_1011, byte2 is 1000_0001.
        #10 dh_bytes_i[15:8]=8'b0101_1010;  
           dh_byte_ready_i=4'b0010;
           #2 dh_byte_ready_i=4'b0;
        #10 dh_bytes_i[23:16]=8'b1000_0001;  
            dh_byte_ready_i=4'b0100;
            #2 dh_byte_ready_i=4'b0;
        #10 dh_bytes_i[31:24]=8'b1101_1011;  
           dh_byte_ready_i=4'b1000;
           #2 dh_byte_ready_i=4'b0;
           dh_crc16_i=4'h0;
        #2 dh_eop_start_i=1'b1;
        #2 dh_eop_start_i=1'b0;
        #9 $finish;
    end

endmodule