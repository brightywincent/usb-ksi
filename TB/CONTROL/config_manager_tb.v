module config_manager_tb;
    reg cm_clk_i;
    reg cm_reset;
    reg cm_ld_config_i;
    reg [7:0]cm_new_config_i;
    wire [7:0]cm_curr_config_o;
    wire cm_configured_o;
    
    config_manager cm_1(
        .cm_clk_i(cm_clk_i),
        .cm_reset(cm_reset),
        .cm_ld_config_i(cm_ld_config_i),
        .cm_new_config_i(cm_new_config_i),
        .cm_curr_config_o(cm_curr_config_o),
        .cm_configured_o(cm_configured_o)
    );

    initial begin
        $dumpfile("TB/CONTROL/DUMP/config_manager.vcd");
        $dumpvars(0,config_manager_tb);
        $display("|Time|Clk|Reset|Load|New_Config|Curr_config|Configured|");
    end

    always @(posedge cm_clk_i)begin
        $display("|%4t| %b |  %b  | %b  | %8b | %8b  |    %b     |",$time,cm_clk_i,cm_reset,cm_ld_config_i,cm_new_config_i,cm_curr_config_o,cm_configured_o);
    end

    initial begin
        cm_clk_i=1'b1;
        cm_reset=1'b1;
        cm_ld_config_i=1'b0;
        cm_new_config_i=8'b0;
    end
    
    always begin
        #1 cm_clk_i=~cm_clk_i;
    end

    initial begin
        #2 cm_reset=1'b0;
        #10 cm_ld_config_i=1'b1;
            cm_new_config_i=8'b0;
        #2 cm_ld_config_i=1'b0;
        #10 cm_ld_config_i=1'b1;
            cm_new_config_i=8'd7;
        #2 cm_ld_config_i=1'b0;
        #9 $finish;
    end

endmodule
