module address_manager_tb;
    reg am_clk_i;
    reg am_reset;
    reg [6:0]am_new_addr_i;
    reg am_ld_addr_i;
    reg am_commit_addr_i;
    wire [6:0]am_curr_addr_o;
    wire am_new_addr_committed_o;
    address_manager am_1(
        .am_clk_i(am_clk_i),
        .am_reset(am_reset),
        .am_new_addr_i(am_new_addr_i),
        .am_ld_addr_i(am_ld_addr_i),
        .am_commit_addr_i(am_commit_addr_i),
        .am_curr_addr_o(am_curr_addr_o),
        .am_new_addr_committed_o(am_new_addr_committed_o)
    );

    initial begin
        $dumpfile("TB/CONTROL/DUMP/address_manager.vcd");
        $dumpvars(0,address_manager_tb);
        $display("|Time|Clk|Reset|New_Addr|Load|Commit|Current_Addr|Commit_Done|");        
    end

    always @(posedge am_clk_i)begin
        $display("|%4t| %b |  %b  |  %3d   | %b  |  %b   |    %3d     |     %b     |",$time,am_clk_i,am_reset,am_new_addr_i,am_ld_addr_i,am_commit_addr_i,am_curr_addr_o,am_new_addr_committed_o);
    end

    initial begin
        am_clk_i=1'b1;
        am_reset=1'b1;
        am_new_addr_i=7'b0;
        am_ld_addr_i=1'b0;
        am_commit_addr_i=1'b0;
    end

    always begin
        #1 am_clk_i=~am_clk_i;
    end

    initial begin
        #2 am_reset=1'b0;
        #6 am_ld_addr_i=1'b1;
           am_new_addr_i=7'd7;
        #2 am_ld_addr_i=1'b0;
        #10 am_commit_addr_i=1'b1;
        #2 am_commit_addr_i=1'b0;
        #9 $finish;
    end

endmodule
