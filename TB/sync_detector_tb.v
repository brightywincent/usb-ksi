`timescale 1 ns / 1 ns;
module sync_detector_tb;
    reg [1:0]sd_sbus_i;
	reg sd_clk_i;
	reg sd_reset;
	 reg [8*9:1]s;
    wire sd_sync_o;
    
    sync_detector sd_1(
        .sd_sbus_i(sd_sbus_i),
	    .sd_clk_i(sd_clk_i),
	    .sd_reset(sd_reset),
	    .sd_sync_o(sd_sync_o)
    );

    initial begin
	    $dumpfile("TB/sync_detector.vcd");
	    $dumpvars(0,sync_detector_tb);
	    $display(" Time | clk | reset |  state  |count| prev | Dp,Dm | sync |");
    end                               

    always@(posedge sd_clk_i) begin
        $display(" %3t  |  %b  |   %b   |%s|%d|  %2b  |   %2b  |   %b  |",$time,sd_clk_i,sd_reset,s,sd_1.sd_count,sd_1.sd_prev,sd_sbus_i,sd_sync_o);
         case (sd_1.STATE)
            2'b00: s = "IDLE";
            2'b01: s = "ACQUIRING";
            2'b10: s = "SYNC_OK"; 
            default: s = "IDLE";
        endcase
    end
    
    initial begin
        sd_sbus_i=2'b01;
        sd_clk_i=1;
        sd_reset=1;
    end

    always begin
        #1 sd_clk_i=~sd_clk_i;
    end

    initial begin
        #2 sd_reset=1'b0;
        #2 sd_sbus_i=2'b01;
        #2 sd_sbus_i=2'b01;
        #2 sd_sbus_i=2'b01;
        #2 sd_sbus_i=2'b01;
        for(integer i = 0;i<7;i++)begin
            #2 sd_sbus_i=2'b10;
            #2 sd_sbus_i=2'b01;
        end
        #2 sd_sbus_i=2'b10;
        #2 sd_sbus_i=2'b10;
        #13 $finish;
    end

endmodule

