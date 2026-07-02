`timescale 1 ns / 1 ns;
module handshake_decoder_tb;
    reg hd_clk_i;
    reg hd_reset;
    reg [3:0]hd_pid_i;
    reg hd_pid_valid_i;
    wire hd_ack_o;
    wire hd_nyet_o;
    wire hd_nak_o;
    wire hd_stall_o;
    handshake_decoder hd_1(
        .hd_clk_i(hd_clk_i),
        .hd_reset(hd_reset),
        .hd_pid_i(hd_pid_i),
        .hd_pid_valid_i(hd_pid_valid_i),
        .hd_ack_o(hd_ack_o),
        .hd_nyet_o(hd_nyet_o),
        .hd_nak_o(hd_nak_o),
        .hd_stall_o(hd_stall_o)
    );
    initial begin
        $dumpfile("TB/SIE/DUMP/handshake_decoder.vcd");
        $dumpvars(0,handshake_decoder_tb);
        $display("|Time|Clk|Reset|PID_in|PID_valid|ACK|NYET|NAK|STALL|");
    end
    always@(posedge hd_clk_i)begin
        $display("|%4t| %b |  %b  | %4b |    %b    | %b | %b  | %b |  %b  |",$time,hd_clk_i,hd_reset,hd_pid_i,hd_pid_valid_i,hd_ack_o,hd_nyet_o,hd_nak_o,hd_stall_o);
    end

    initial begin
        hd_clk_i=1'b1;
        hd_reset=1'b1;
        hd_pid_i=4'b0;
        hd_pid_valid_i=1'b0; 
    end
    always begin
        #1 hd_clk_i=~hd_clk_i;
    end

    initial begin
        #2 hd_reset=1'b0;
        //ACK
        #2 hd_pid_i=4'b0010;
            hd_pid_valid_i=1'b1;
        #2 hd_pid_valid_i=1'b0;
        //NYET
        #4 hd_pid_i=4'b0110;
            hd_pid_valid_i=1'b1;
        #2 hd_pid_valid_i=1'b0;
        //NAK
        #4 hd_pid_i=4'b1010;
            hd_pid_valid_i=1'b1;
        #2 hd_pid_valid_i=1'b0;
        //STALL
        #4 hd_pid_i=4'b1110;
            hd_pid_valid_i=1'b1;
        #2 hd_pid_valid_i=1'b0;
        #5 $finish;
    end
endmodule