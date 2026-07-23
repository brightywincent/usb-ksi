`timescale 1 ns / 1 ns;
module ep0_buffer_tb;
    reg ep0b_clk_i;
    reg ep0b_reset;
    reg ep0b_clear;
    reg ep0b_en;  //Enable for the EP0 buffer
    reg ep0b_packet_commit_i;
    reg [7:0]ep0b_wr_byte_i;
    reg ep0b_wr_en_i;
    reg ep0b_rd_en_i;
    reg [7:0]ep0b_rd_addr_i;
    wire [7:0]ep0b_rd_byte_o;
    wire ep0b_empty_o;
    wire ep0b_packet_valid_o;
    wire [7:0]ep0b_packet_length_o;
    
    ep0_buffer ep0b_1(
        .ep0b_clk_i(ep0b_clk_i),
        .ep0b_reset(ep0b_reset),
        .ep0b_clear(ep0b_clear),
        .ep0b_en(ep0b_en),  
        .ep0b_packet_commit_i(ep0b_packet_commit_i),
        .ep0b_wr_byte_i(ep0b_wr_byte_i),
        .ep0b_wr_en_i(ep0b_wr_en_i),
        .ep0b_rd_en_i(ep0b_rd_en_i),
        .ep0b_rd_addr_i(ep0b_rd_addr_i),
        .ep0b_rd_byte_o(ep0b_rd_byte_o),
        .ep0b_empty_o(ep0b_empty_o),
        .ep0b_packet_valid_o(ep0b_packet_valid_o),
        .ep0b_packet_length_o(ep0b_packet_length_o)
    );

    initial begin
        $dumpfile("TB/CONTROL/DUMP/ep0_buffer.vcd");
        $dumpvars(0,ep0_buffer_tb);
        $display("|Time|Clk|Reset|Clear|EP_en|Wr_en|Wr_ptr|Wr_Byte |Commit|Valid|Size|Empty|Rd_en|Rd_addr|Rd_Byte |");
    end

    always @(posedge ep0b_clk_i)begin
        $display("|%4t| %b |  %b  |  %b  |  %b  |  %b  |  %2d  |%8b|  %b   |  %b  | %2d |  %b  |  %b  |  %2d   |%8b|",$time,ep0b_clk_i,ep0b_reset,ep0b_clear,ep0b_en,ep0b_wr_en_i,ep0b_1.wr_ptr,ep0b_wr_byte_i,ep0b_packet_commit_i,ep0b_packet_valid_o,ep0b_packet_length_o,ep0b_empty_o,ep0b_rd_en_i,ep0b_rd_addr_i,ep0b_rd_byte_o);
    end

    initial begin
        ep0b_clk_i=1'b1;
        ep0b_reset=1'b1;
        ep0b_clear=1'b0;
        ep0b_en=1'b0;
        ep0b_packet_commit_i=1'b0;
        ep0b_wr_byte_i=8'bx;
        ep0b_wr_en_i=1'b0;
        ep0b_rd_en_i=1'b0;
        ep0b_rd_addr_i=8'bx;
    end

    always begin
        #1 ep0b_clk_i=~ep0b_clk_i;
    end

    initial begin
        #2 ep0b_reset=1'b0;
        #4 ep0b_en=1'b1; 
        
        #6 ep0b_wr_en_i=1'b1;  //Idle for few cycles after enabled
           ep0b_wr_byte_i=8'b0000_0001;  // Writing 8 bytes into the buffer
        #2 ep0b_wr_byte_i=8'b0000_0011;
        #2 ep0b_wr_byte_i=8'b0000_0111;
        #2 ep0b_wr_byte_i=8'b0000_1111;
        #2 ep0b_wr_byte_i=8'b0001_1111;
        #2 ep0b_wr_byte_i=8'b0011_1111;
        #2 ep0b_wr_byte_i=8'b0111_1111;
        #2 ep0b_wr_byte_i=8'b1111_1111;
        #2 ep0b_wr_en_i=1'b0;
           ep0b_wr_byte_i=8'bx; //waiting before getting commit signal
        
        #6 ep0b_packet_commit_i=1'b1; //commit
        #2 ep0b_packet_commit_i=1'b0;

        #6 ep0b_rd_en_i=1'b1;  //Read the 8 bytes from the buffer
            ep0b_rd_addr_i=8'd0;
        #2  ep0b_rd_addr_i=8'd1;
        #2  ep0b_rd_addr_i=8'd2;
        #2  ep0b_rd_addr_i=8'd3;
        #2  ep0b_rd_addr_i=8'd4;
        #2  ep0b_rd_addr_i=8'd5;
        #2  ep0b_rd_addr_i=8'd6;
        #2  ep0b_rd_addr_i=8'd7;
        #2  ep0b_rd_en_i=1'b0;
        ep0b_rd_addr_i=8'dx;  
                                //Waiting before clear arrives from the transaction engine
        #4 ep0b_clear=1'b1; //clear signal from transaction engine
        #2 ep0b_clear=1'b0;
                            //Waiting some time before finishing        
        #5 $finish;
    end
endmodule
