`timescale 1 ns / 1 ns;
module packet_timer_tb;
    reg pt_clk_i;
    reg pt_reset;
    reg pt_sync_i;
    reg pt_eop_i;
    wire pt_timeout_o;
    
    packet_timer pt_1(
        .pt_clk_i(pt_clk_i),
        .pt_reset(pt_reset),
        .pt_sync_i(pt_sync_i),
        .pt_eop_i(pt_eop_i),
        .pt_timeout_o(pt_timeout_o)
    );

    initial begin
        $dumpfile("TB/SIE/DUMP/packet_timer.vcd");
        $dumpvars(0,packet_timer_tb);
        $display("|Time |Clk|Reset|Sync|Timer On|Count|EOP|Time Out|");
    end

    always@(posedge pt_clk_i)begin
        $display("|%5t| %b |  %b  | %b  |   %b    |%5d| %b |   %b    |",$time,pt_clk_i,pt_reset,pt_sync_i,pt_1.pt_timer_on,pt_1.pt_count,pt_eop_i,pt_timeout_o);
    end

    initial begin
        pt_clk_i=1'b1;
        pt_reset=1'b1;
        pt_sync_i=1'b0;
        pt_eop_i=1'b0;
    end

    always begin
        #1 pt_clk_i=~pt_clk_i;
    end

    initial begin
        #2 pt_reset=1'b0;
        //normal
        #2 pt_sync_i=1'b1;
        #2 pt_sync_i=1'b0;
        #40 pt_eop_i=1'b1;
        #2 pt_eop_i=1'b0;
        //time out
        #10 pt_sync_i=1'b1;
        #2 pt_sync_i=1'b0;
        #20007 $finish;
    end
    
endmodule