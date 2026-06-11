`timescale 10 ns / 100 fs;
module resume_detector_tb;
   
    reg rumed_ref_clk_i;
    reg rumed_reset;
    reg rumed_suspend_state_i;
    reg rumed_dplus_i;
    reg rumed_dminus_i;
    wire rumed_resume_o;

    resume_detector rumed_1(
        .rumed_ref_clk_i(rumed_ref_clk_i),
        .rumed_reset(rumed_reset),
        .rumed_suspend_state_i(rumed_suspend_state_i),
        .rumed_dplus_i(rumed_dplus_i),
        .rumed_dminus_i(rumed_dminus_i),
        .rumed_resume_o(rumed_resume_o)
    );

    initial begin
        $dumpfile("TB/resume_detector.vcd");
        $dumpvars(0,resume_detector_tb);
        $display("|   Time  |Clk|Reset|Suspend_State|Dplus,Dminus|Resume|Count|");
    end

    always@(posedge rumed_ref_clk_i) begin
        if(({rumed_dplus_i,rumed_dminus_i}!=2'b10)||((rumed_resume_o)||(rumed_1.rumed_count==10'd960)))
            $display("|%9t| %b |  %b  |      %b      |     %2b     |   %b  |%d |",$time,rumed_ref_clk_i,rumed_reset,rumed_suspend_state_i,{rumed_dplus_i,rumed_dminus_i},rumed_resume_o,rumed_1.rumed_count);
    end

    initial begin
        rumed_ref_clk_i=1'b1;
        rumed_reset=1'b1;
        rumed_suspend_state_i=1'b0;
        {rumed_dplus_i,rumed_dminus_i}=2'b01;
    end

    always begin
        #1.0415 rumed_ref_clk_i=~rumed_ref_clk_i;
    end

    initial begin
        #2 rumed_reset=1'b0;
        #8 rumed_suspend_state_i=1'b1;
        #10 rumed_suspend_state_i=1'b0;
            {rumed_dplus_i,rumed_dminus_i}=2'b10;
        #2002 {rumed_dplus_i,rumed_dminus_i}=2'b01;
        #5 $finish;
    end

endmodule