`timescale 10 ns / 10 ns;
module reset_detector_tb;
    
    reg rd_ref_clk_i;
    reg rd_dplus_i;
    reg rd_dminus_i;
    reg rd_reset;
    wire rd_reset_state_o;

    reset_detector rd_1(
        .rd_ref_clk_i(rd_ref_clk_i),
        .rd_dplus_i(rd_dplus_i),
        .rd_dminus_i(rd_dminus_i),
        .rd_reset(rd_reset),
        .rd_reset_state_o(rd_reset_state_o)
    );

    initial begin
        $dumpfile("TB/reset_detector.vcd");
        $dumpvars(0,reset_detector_tb);
        $display("|  Time  |Clk|Reset|Dplus,Dminus|Reset_state|");
    end

    always@(posedge rd_ref_clk_i)begin
        if({rd_dplus_i,rd_dminus_i}!=2'b00)
        $display("|%7t | %b |  %b  |     %2b     |     %b     |",$time,rd_ref_clk_i,rd_reset,{rd_dplus_i,rd_dminus_i},rd_reset_state_o);
    end

    initial begin
        rd_ref_clk_i=1'b1;
        rd_reset=1'b1;
        {rd_dplus_i,rd_dminus_i}=2'b01;
    end

    always begin
        #1 rd_ref_clk_i=~rd_ref_clk_i;
    end

    initial begin
        #2 rd_reset=1'b0;
        #10 {rd_dplus_i,rd_dminus_i}=2'b00;
        #1000008 {rd_dplus_i,rd_dminus_i}=2'b01;
        #5 $finish;
    end

endmodule