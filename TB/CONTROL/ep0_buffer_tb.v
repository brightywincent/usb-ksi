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
        $display("|Time|Clk|Reset|Clear|EP_en|Wr_en|Wr_Byte |Commit|Valid|Size|Empty|Rd_en|Rd_addr |Rd_Byte |");
    end

    always @(posedge ep0b_clk_i)begin
        $display("|%4t| %b |  %b  |  %b  |  %b  |  %b  |%8b|  %b   |  %b  | %2d |  %b  |  %b  |%8b|%8b|",$time,ep0b_clk_i,ep0b_reset,ep0b_clear,ep0b_en,ep0b_wr_en_i,ep0b_wr_byte_i,ep0b_packet_commit_i,ep0b_packet_valid_o,ep0b_packet_length_o,ep0b_empty_o,ep0b_rd_en_i,ep0b_rd_addr_i,ep0b_rd_byte_o);
    end

    initial begin
        ep0b_clk_i=1'b1;
        ep0b_reset=1'b1;
        ep0b_clear=1'b0;
        ep0b_en=1'b0;
        ep0b_packet_commit_i=1'b0;
        ep0b_wr_byte_i=8'b0;
        ep0b_wr_en_i=1'b0;
        ep0b_rd_en_i=1'b0;
        ep0b_rd_addr_i=8'b0;
    end

    always begin
        #1 ep0b_clk_i=~ep0b_clk_i;
    end

    initial begin
        #5 $finish;
    end
endmodule
