`timescale 1 ns /1 ns;
module deserializer_tb;

    reg d_clk_i;
    reg d_reset;
    reg d_sbit_i;
    reg d_unstuff_i;
    reg d_sync_i;
    wire [31:0]d_bytes_o;
    wire [3:0]d_byte_ready_o;

    deserializer d_1(
        .d_clk_i(d_clk_i),
        .d_reset(d_reset),
        .d_sbit_i(d_sbit_i),
        .d_unstuff_i(d_unstuff_i),
        .d_sync_i(d_sync_i),
        .d_bytes_o(d_bytes_o), 
        .d_byte_ready_o(d_byte_ready_o)
    );

    initial begin
        $dumpfile("TB/deserializer.vcd");
        $dumpvars(0,deserializer_tb);
        $display("|Time|Clk|Reset|Sync|Bits|Unstuff|Byte_ready|  Byte3 |  Byte2 |  Byte1 |  Byte0 |");
    end

    always@(posedge d_clk_i)begin
        $display("|%3t | %b |  %b  |  %b |  %b |   %b   |   %4b   |%8b|%8b|%8b|%8b|",$time,d_clk_i,d_reset,d_sync_i,d_sbit_i,d_unstuff_i,d_byte_ready_o,d_bytes_o[31:24],d_bytes_o[23:16],d_bytes_o[15:8],d_bytes_o[7:0]);
    end

    initial begin
        d_clk_i=1'b1;
        d_reset=1'b1;
        d_sbit_i=1'b0;
        d_unstuff_i=1'b0;
        d_sync_i=1'b0;
    end

    always begin
        #1 d_clk_i=~d_clk_i;
    end

    initial begin
        #2 d_reset=1'b0;
        #2 d_sync_i=1'b1;
        #2 d_sync_i=1'b0;
           d_sbit_i=1'b0;
        #16 d_sbit_i=1'b1;
        for (integer i=0;i<3;i++)begin
            #2 d_sbit_i=1'b0;
            #2 d_sbit_i=1'b1;
        end
        for (integer j=0;j<4;j++)begin
            #2 d_sbit_i=1'b1;
            #2 d_sbit_i=1'b0;
        end
        for (integer k=0;k<6;k++)begin
            #2 d_sbit_i=1'b1;
        end
        #2 d_sbit_i=1'b0;
        d_unstuff_i=1'b1;
        #2 d_sbit_i=1'b1;
        d_unstuff_i=1'b0;
        #4 d_sbit_i=1'b0;
        #3 $finish;
    end

endmodule