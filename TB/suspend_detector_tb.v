`timescale 10 ns / 10 ns;
module suspend_detector_tb;
    
    reg susd_ref_clk_i;
    reg susd_dplus_i;
    reg susd_dminus_i;
    reg susd_reset;
    wire susd_suspend_state_o;

    suspend_detector susd_1(
         .susd_ref_clk_i(susd_ref_clk_i),
        .susd_dplus_i(susd_dplus_i),
        .susd_dminus_i(susd_dminus_i),
        .susd_reset(susd_reset),
        .susd_suspend_state_o(susd_suspend_state_o)
    );

    initial begin
        $dumpfile("TB/suspend_detector.vcd");
        $dumpvars(0,suspend_detector_tb);
        $display("| Time  |Clk|Reset|Dplus,Dminus|Suspend_state|");
    end

    always@(posedge susd_ref_clk_i)begin
        if({susd_dplus_i,susd_dminus_i}!=2'b01)
            $display("|%7t| %b |  %b  |     %2b     |      %b      |",$time,susd_ref_clk_i,susd_reset,{susd_dplus_i,susd_dminus_i},susd_suspend_state_o);
    end

    initial begin
        susd_ref_clk_i=1'b1;
        susd_reset=1'b1;
        susd_dplus_i=1'b0;
        susd_dminus_i=1'b0;
    end

    always begin
        #1 susd_ref_clk_i=~susd_ref_clk_i;
    end

    initial begin
        #2 susd_reset=1'b0;
           {susd_dplus_i,susd_dminus_i}=2'b00;
        #10 {susd_dplus_i,susd_dminus_i}=2'b01;
        #300008 {susd_dplus_i,susd_dminus_i}=2'b00;
        #9 $finish;
    end

endmodule