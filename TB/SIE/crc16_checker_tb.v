`timescale 1 ns / 1 ns;
module crc16_checker_tb;
    
    reg cc16_clk_i;
    reg cc16_reset;
    reg cc16_sbit_i;
    reg cc16_sync_i;
    wire [15:0]cc16_reg;

    crc16_checker cc16_1(
        .cc16_clk_i(cc16_clk_i),
        .cc16_reset(cc16_reset),
        .cc16_sbit_i(cc16_sbit_i),
        .cc16_sync_i(cc16_sync_i),
        .cc16_reg(cc16_reg)
    );

    initial begin
        $dumpfile("TB/SIE/DUMP/crc16_checker.vcd");
        $dumpvars(0,crc16_checker_tb);
        $display("|Time|Clk|Reset|Sync|Reg_on|Bit|CRC register|");
    end

    always@(posedge cc16_clk_i)begin
        $display("|%4t| %b |  %b  | %b  |  %b   | %b |   %16b    |",$time,cc16_clk_i,cc16_reset,cc16_sync_i,cc16_1.cc16_on,cc16_sbit_i,cc16_reg);
    end

    initial begin
        cc16_clk_i=1'b1;
        cc16_reset=1'b1;
        cc16_sbit_i=1'b0;
        cc16_sync_i=1'b0;
    end

    always begin
        #1 cc16_clk_i =~cc16_clk_i;
    end

    initial begin
        #2 cc16_reset=1'b0;
        #4 cc16_sync_i=1'b1;  
        #2 cc16_sync_i=1'b0; 
            //PID be DATA0 - 1100_0011 and crc16 - 1101_0111,1010_0111.
        
    //Order of appearance for DATA0 - 1100_0011
    //Order of appearance for crc16 - 1110_0101,1110_1011.
        
            // payload byte1 is 0101_1010, byte0 is 1100_0011.
    
    //Order of appearance for payload is 1100_0011,0101_1010
    
    //therefore, the bits 1100_0011,1100_0011,0101_1010,1110_0101,1110_1011 in order of appearance 
        #2 cc16_sbit_i=1'b1; 
        #2 cc16_sbit_i=1'b1;
        #2 cc16_sbit_i=1'b0;
        #2 cc16_sbit_i=1'b0;
        
        #2 cc16_sbit_i=1'b0;
        #2 cc16_sbit_i=1'b0;
        #2 cc16_sbit_i=1'b1;
        #2 cc16_sbit_i=1'b1;
        
        #2 cc16_sbit_i=1'b1;
        #2 cc16_sbit_i=1'b1;
        #2 cc16_sbit_i=1'b0;
        #2 cc16_sbit_i=1'b0;
        
        #2 cc16_sbit_i=1'b0;
        #2 cc16_sbit_i=1'b0;
        #2 cc16_sbit_i=1'b1;
        #2 cc16_sbit_i=1'b1;

        #2 cc16_sbit_i=1'b0;
        #2 cc16_sbit_i=1'b1;
        #2 cc16_sbit_i=1'b0;
        #2 cc16_sbit_i=1'b1;

        #2 cc16_sbit_i=1'b1;
        #2 cc16_sbit_i=1'b0;
        #2 cc16_sbit_i=1'b1;
        #2 cc16_sbit_i=1'b0;

        #2 cc16_sbit_i=1'b1;
        #2 cc16_sbit_i=1'b1;
        #2 cc16_sbit_i=1'b1;
        #2 cc16_sbit_i=1'b0;

        #2 cc16_sbit_i=1'b0;
        #2 cc16_sbit_i=1'b1;
        #2 cc16_sbit_i=1'b0;
        #2 cc16_sbit_i=1'b1;

        #2 cc16_sbit_i=1'b1;
        #2 cc16_sbit_i=1'b1;
        #2 cc16_sbit_i=1'b1;
        #2 cc16_sbit_i=1'b0;

        #2 cc16_sbit_i=1'b1;
        #2 cc16_sbit_i=1'b0;
        #2 cc16_sbit_i=1'b1;
        #2 cc16_sbit_i=1'b1;
        #2 cc16_reset=1'b1;
           cc16_sbit_i=1'b0;
        #2 cc16_reset=1'b0;

        #3 $finish;
    end 

endmodule