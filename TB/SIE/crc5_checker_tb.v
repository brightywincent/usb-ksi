`timescale 1 ns / 1 ns;
module crc5_checker_tb;
    
    reg cc_clk_i;
    reg cc_reset;
    reg cc_sbit_i;
    reg cc_sync_i;
    wire [4:0]cc_reg;

    crc5_checker cc_1(
        .cc_clk_i(cc_clk_i),
        .cc_reset(cc_reset),
        .cc_sbit_i(cc_sbit_i),
        .cc_sync_i(cc_sync_i),
        .cc_reg(cc_reg)
    );

    initial begin
        $dumpfile("TB/SIE/DUMP/crc5_checker.vcd");
        $dumpvars(0,crc5_checker_tb);
        $display("|Time|Clk|Reset|Sync|Reg_on|Bit|CRC register|");
    end

    always@(posedge cc_clk_i)begin
        $display("|%4t| %b |  %b  | %b  |  %b   | %b |   %5b    |",$time,cc_clk_i,cc_reset,cc_sync_i,cc_1.cc_on,cc_sbit_i,cc_reg);
    end

    initial begin
        cc_clk_i=1'b1;
        cc_reset=1'b1;
        cc_sbit_i=1'b0;
        cc_sync_i=1'b0;
    end

    always begin
        #1 cc_clk_i =~cc_clk_i;
    end

    initial begin
        #2 cc_reset=1'b0;
        #4 cc_sync_i=1'b1; // message is 0000_1111_0000_0001 but USB transmits lsb first.
        #2 cc_sync_i=1'b0;
        
        #2 cc_sbit_i=1'b1; //therefore, the bits 1000_0000_1111_0000 in order of appearance
        #2 cc_sbit_i=1'b0;
        #2 cc_sbit_i=1'b0;
        #2 cc_sbit_i=1'b0;
        
        #2 cc_sbit_i=1'b0;
        #2 cc_sbit_i=1'b0;
        #2 cc_sbit_i=1'b0;
        #2 cc_sbit_i=1'b0;
        
        #2 cc_sbit_i=1'b1;
        #2 cc_sbit_i=1'b1;
        #2 cc_sbit_i=1'b1;
        #2 cc_sbit_i=1'b1;
        
        #2 cc_sbit_i=1'b0;
        #2 cc_sbit_i=1'b0;
        #2 cc_sbit_i=1'b0;
        #2 cc_sbit_i=1'b0;
        #2 cc_reset=1'b1;
        #2 cc_sbit_i=1'b1;
        #2 cc_sbit_i=1'b0;
        #3 $finish;
    end 

endmodule