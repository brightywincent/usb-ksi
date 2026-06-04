`timescale 1 ns / 1 ns;
module nrzi_decoder_tb;
    
    reg nd_clk_i;
    reg nd_dplus_i;
    reg nd_dminus_i;
    reg nd_reset;
    wire nd_sbit_o;
    wire nd_invalid_o;

    nrzi_decoder nd_1(
        .nd_clk_i(nd_clk_i),
        .nd_dplus_i(nd_dplus_i),
        .nd_dminus_i(nd_dminus_i),
        .nd_reset(nd_reset),
        .nd_sbit_o(nd_sbit_o),
        .nd_invalid_o(nd_invalid_o)
    );

    initial begin
     $dumpfile("TB/nrzi_decoder.vcd");
     $dumpvars(0,nrzi_decoder_tb);
     $display("|Time|Clock|reset|Previous|Dplus,Dminus|Bit|Invalid|");
    end
    always@(posedge nd_clk_i)begin
        $display("|%3t |  %b  |  %b  |   %2b   |     %2b     | %b |   %b   |",$time,nd_clk_i,nd_reset,nd_1.nd_prev,{nd_dplus_i,nd_dminus_i},nd_sbit_o,nd_invalid_o);
    end
    
    initial begin
        nd_clk_i=1'b1;
        nd_dplus_i=1'b0;
        nd_dminus_i=1'b0;
        nd_reset=1'b1;
    end
    always begin
        #1 nd_clk_i=~nd_clk_i;
    end

    initial begin
        #2 nd_reset=1'b0;
        #2 {nd_dplus_i,nd_dminus_i}=2'b00;
        #8 {nd_dplus_i,nd_dminus_i}=2'b01;
        #2 {nd_dplus_i,nd_dminus_i}=2'b10;
        #2 {nd_dplus_i,nd_dminus_i}=2'b01;
        #2 {nd_dplus_i,nd_dminus_i}=2'b10;
        #2 {nd_dplus_i,nd_dminus_i}=2'b01;
        #2 {nd_dplus_i,nd_dminus_i}=2'b10;
        #10 {nd_dplus_i,nd_dminus_i}=2'b00;
        #2 {nd_dplus_i,nd_dminus_i}=2'b10;
        #2 {nd_dplus_i,nd_dminus_i}=2'b01;
        #2 {nd_dplus_i,nd_dminus_i}=2'b10;
        #5 $finish;
    end

endmodule