`timescale 1 ns / 1 ns;
module eop_detector_tb;
    
    reg ed_clk_i;
    reg ed_reset;
    reg ed_dplus_i;
    reg ed_dminus_i;
    wire ed_eop_o;

    eop_detector ed_1(
        .ed_clk_i(ed_clk_i),
        .ed_reset(ed_reset),
        .ed_dplus_i(ed_dplus_i),
        .ed_dminus_i(ed_dminus_i),
        .ed_eop_o(ed_eop_o)
    );

    initial begin
        $dumpfile("TB/eop_detector.vcd");
        $dumpvars(0,eop_detector_tb);
        $display("|Time|Clk|Reset|Dplus,Dminus|EOP|");
    end
    always@(posedge ed_clk_i) begin
        $display("|%4t| %b |  %b  |     %2b     | %b |",$time,ed_clk_i,ed_reset,{ed_dplus_i,ed_dminus_i},ed_eop_o);
    end

    initial begin
        ed_clk_i=1'b1;
        ed_reset=1'b1;
        ed_dplus_i=1'b0;
        ed_dminus_i=1'b1;
    end

    always begin
        #1 ed_clk_i =~ed_clk_i;
    end

    initial begin
        #2 ed_reset=1'b0;
           {ed_dplus_i,ed_dminus_i}=2'b01;
        #2 {ed_dplus_i,ed_dminus_i}=2'b10;
        #2 {ed_dplus_i,ed_dminus_i}=2'b01;
        #10 {ed_dplus_i,ed_dminus_i}=2'b10;
        #2 {ed_dplus_i,ed_dminus_i}=2'b00;
        #4 {ed_dplus_i,ed_dminus_i}=2'b01;
        #2 {ed_dplus_i,ed_dminus_i}=2'b01;
        #8 {ed_dplus_i,ed_dminus_i}=2'b10;
        #5 $finish;
    end

endmodule