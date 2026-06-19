`timescale 1 ns / 1 ns;
module packet_dispatcher_tb;

    reg pdis_clk_i;
	reg pdis_reset; 
	reg [3:0]pdis_pid_i;
    reg pdis_valid_i;
    wire pdis_token_o;
    wire pdis_data_o;
    wire pdis_handshake_o;
    wire pdis_special_o;
    wire pdis_subtype_o;

    packet_dispatcher pdis_1(
        .pdis_clk_i(pdis_clk_i),
        .pdis_reset(pdis_reset), 
        .pdis_pid_i(pdis_pid_i),
        .pdis_valid_i(pdis_valid_i),
        .pdis_token_o(pdis_token_o),
        .pdis_data_o(pdis_data_o),
        .pdis_handshake_o(pdis_handshake_o),
        .pdis_special_o(pdis_special_o),
        .pdis_subtype_o(pdis_subtype_o)
    );

    initial begin
        $dumpfile("TB/SIE/DUMP/packet_dispatcher.vcd");
        $dumpvars(0,packet_dispatcher_tb);
        $display("|Time|Clk|Reset|PID_nibble|PID_valid|TOKEN|DATA|HANDSHAKE|SPECIAL|");
    end

    always@(posedge pdis_clk_i)begin
        $display("|%4t| %b |  %b  |   %4b   |    %b    |  %b  | %b  |    %b    |   %b   |",$time,pdis_clk_i,pdis_reset,pdis_pid_i,pdis_valid_i,pdis_token_o,pdis_data_o,pdis_handshake_o,pdis_special_o);
    end

    initial begin
        pdis_clk_i=1'b1;
	    pdis_reset=1'b1; 
	    pdis_pid_i=4'b0000;
        pdis_valid_i=1'b0;
    end

    always begin
        #1 pdis_clk_i=~pdis_clk_i;
    end

    initial begin
        #2 pdis_reset=1'b0;
        #2 pdis_pid_i=4'b0000;
        #2 pdis_pid_i=4'b1000;
        #2 pdis_pid_i=4'b0100;
        #2 pdis_pid_i=4'b0010;
        #2 pdis_pid_i=4'b0001;
           pdis_valid_i=1'b1;
        #2 pdis_valid_i=1'b0;
        #2 pdis_pid_i=4'b0000;
        #2 pdis_pid_i=4'b1000;
        #2 pdis_pid_i=4'b1100;
        #2 pdis_pid_i=4'b0110;
        #2 pdis_pid_i=4'b0011;
           pdis_valid_i=1'b1;
        #2 pdis_valid_i=1'b0;
        #2 pdis_pid_i=4'b0000;
        #2 pdis_pid_i=4'b0000;
        #2 pdis_pid_i=4'b1000;
        #2 pdis_pid_i=4'b0100;
        #2 pdis_pid_i=4'b0010;
           pdis_valid_i=1'b1;
        #2 pdis_valid_i=1'b0;
        #2 pdis_pid_i=4'b0000;
        #2 pdis_pid_i=4'b0000;
        #2 pdis_pid_i=4'b0000;
        #2 pdis_pid_i=4'b1000;
        #2 pdis_pid_i=4'b0100;
           pdis_valid_i=1'b1;
        #2 pdis_valid_i=1'b0;
        #5 $finish;
    end

endmodule