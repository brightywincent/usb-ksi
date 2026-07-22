`timescale 1 ns / 1 ns;
module rx_fifo_tb;
    reg rf_clk_i;
    reg rf_reset;
    reg [7:0]rf_byte_i;
    reg rf_write_i;
    reg rf_read_i;
    wire [7:0]rf_byte_o;
    wire rf_empty_o;
    wire rf_full_o;
    wire rf_underflow_o;
    wire rf_overflow_o;
    
    rx_fifo rf_1(
        .rf_clk_i(rf_clk_i),
        .rf_reset(rf_reset),
        .rf_byte_i(rf_byte_i),
        .rf_write_i(rf_write_i),
        .rf_read_i(rf_read_i),
        .rf_byte_o(rf_byte_o),
        .rf_empty_o(rf_empty_o),
        .rf_full_o(rf_full_o),
        .rf_underflow_o(rf_underflow_o),
        .rf_overflow_o(rf_overflow_o)
    );

    initial begin
        $dumpfile("TB/SIE/DUMP/rx_fifo.vcd");
        $dumpvars(0,rx_fifo_tb);
        $display("|Time|Clk|Reset|Write|wr_ptr|Byte__in|byte_count|Read|rd_ptr|Byte_out|Empty|Underflow|Full|Overflow|");
    end

    always@ (posedge rf_clk_i)begin
        $display("|%4t| %b |  %b  |  %b  |  %2d  |%8b|    %2d    | %b  |  %2d  |%8b|  %b  |    %b    | %b  |   %b    |",$time,rf_clk_i,rf_reset,rf_write_i,rf_1.wr_ptr,rf_byte_i,rf_1.byte_count,rf_read_i,rf_1.rd_ptr,rf_byte_o,rf_empty_o,rf_underflow_o,rf_full_o,rf_overflow_o);
    end

    initial begin
        rf_clk_i=1'b1;
        rf_reset=1'b1;
        rf_byte_i=8'b0;
        rf_write_i=1'b0;
        rf_read_i=1'b0; 
    end

    always begin
        #1 rf_clk_i=~rf_clk_i;
    end

    initial begin
        #2 rf_reset=1'b0;
        //write only
        #2 rf_byte_i=8'b0000_0001;
            rf_write_i=1'b1;
        #2 rf_write_i=1'b0;
        #2 rf_byte_i=8'b0000_1111;
            rf_write_i=1'b1;
        #2 rf_write_i=1'b0;
        #2 rf_byte_i=8'b0101_0101;
            rf_write_i=1'b1;
        #2 rf_write_i=1'b0;
        //read only
        #4 rf_read_i=1'b1;
        #2 rf_read_i=1'b0;
        //write and read at a time
        #2 rf_byte_i=8'b1111_1111;
            rf_write_i=1'b1;
            rf_read_i=1'b1;
        #2 rf_write_i=1'b0;
        #2    rf_read_i=1'b0;
        //underflow
        #2 rf_read_i=1'b1;
        #2 rf_read_i=1'b0;
        //overflow
        for(integer i=0;i<64;i++)begin
            #2 rf_byte_i=8'b0000_1111;
                rf_write_i=1'b1;
        end
        #4 rf_write_i=1'b0;
        #2 rf_reset=1'b1;
        #2 rf_reset=1'b0;
        rf_byte_i=8'b0000_0000;
        //multiple read and writes at a time
        #6 rf_byte_i=8'b1111_0000;
            rf_write_i=1'b1;
        #2 rf_byte_i=8'b0000_1111;
        #2 rf_byte_i=8'b1111_0000;
        #2 rf_byte_i=8'b0000_1111;
        #2 rf_byte_i=8'b1111_0000;
        #2 rf_byte_i=8'b0000_1111;
        #2 rf_byte_i=8'b1111_0000;
        rf_read_i=1'b1;
        #2 rf_byte_i=8'b0000_1111;
        #2 rf_write_i=1'b0;
         rf_byte_i=8'b0000_0000;
        #12 rf_read_i=1'b0;
        #11 $finish;
    end

endmodule