//Uncomment the commands related to only one transaction at a time
`timescale 1 ns / 1 ns;
module transaction_engine_tb;
    wire te_abort=te_1.te_abort;
    wire te_ignore=te_1.te_ignore;
    wire [9:0]te_timer=te_1.te_timer;
    reg te_clk_i;
    reg te_reset;
    reg [3:0]te_pid_nibble_i;
    //token handler net
    reg te_token_trigger_i; 
    reg te_token_valid_i;
    reg te_token_pac_err_i;
    reg te_crc5_fail_i;
    reg [6:0]te_addr_i;
    reg [3:0]te_endp_i;
    //data handler net
    reg te_data_trigger_i; 
    reg te_data_valid_i;
    reg te_data_pac_err_i;
    reg te_crc16_fail_i;
    //handshake handler net
    reg te_handshake_trigger_i; 
    reg te_ack_i;
    reg te_stall_i;
    reg te_nak_i;
    reg te_timeout_i;
    reg te_endp_data_toggle_i;
    reg te_endp_data_fail_i;
    reg te_endp_empty_i;
    reg te_endp_tx_done_i;
    reg te_endp_stalled_i;
    reg te_endp_ready_i;  //flag
    wire te_send_ack_o;
    wire te_send_nak_o;
    wire te_send_stall_o;
    wire te_send_data_o;
    wire te_data_toggle_o;
    wire te_clear_endp_buff_o;
    wire te_setup_done_o;
    wire te_protocol_err_o;
    
    transaction_engine te_1(
        .te_clk_i(te_clk_i),
        .te_reset(te_reset),
        .te_pid_nibble_i(te_pid_nibble_i),
        .te_token_trigger_i(te_token_trigger_i), 
        .te_token_valid_i(te_token_valid_i),
        .te_token_pac_err_i(te_token_pac_err_i),
        .te_crc5_fail_i(te_crc5_fail_i),
        .te_addr_i(te_addr_i),
        .te_endp_i(te_endp_i),
        .te_data_trigger_i(te_data_trigger_i), 
        .te_data_valid_i(te_data_valid_i),
        .te_data_pac_err_i(te_data_pac_err_i),
        .te_crc16_fail_i(te_crc16_fail_i),
        .te_handshake_trigger_i(te_handshake_trigger_i), 
        .te_ack_i(te_ack_i),
        .te_stall_i(te_stall_i),
        .te_nak_i(te_nak_i),
        .te_timeout_i(te_timeout_i),
        .te_endp_data_toggle_i(te_endp_data_toggle_i),
        .te_endp_data_fail_i(te_endp_data_fail_i),
        .te_endp_empty_i(te_endp_empty_i),
        .te_endp_tx_done_i(te_endp_tx_done_i),
        .te_endp_stalled_i(te_endp_stalled_i),
        .te_endp_ready_i(te_endp_ready_i),  //flag
        .te_send_ack_o(te_send_ack_o),
        .te_send_nak_o(te_send_nak_o),
        .te_send_stall_o(te_send_stall_o),
        .te_send_data_o(te_send_data_o),
        .te_data_toggle_o(te_data_toggle_o),
        .te_clear_endp_buff_o(te_clear_endp_buff_o),
        .te_setup_done_o(te_setup_done_o),
        .te_protocol_err_o(te_protocol_err_o)
    );

    initial begin
        $dumpfile("TB/SIE/DUMP/transaction_engine.vcd");
        $dumpvars(0,transaction_engine_tb);
        //OUT transaction
       // $display("|Time|Clk|Rst|Timeout|PID_in|T_trigger|T_valid|T_err|T_crc5_fail|Timer|D_trigger|D_valid|D_err|D_crc16_fail|Abort|Ignore|Send_ACK|Data_toggle|");
        //IN transaction 
        $display("|Time|Clk|Rst|Timeout|PID_in|T_trig|T_ok|T_err|crc5_er|Timer|EP_err|EP_empty|EP_TX_ok|EP_stld|EP_ready|NAK|STALL|DATA|D_tog|Clr_buff|Abort|Ignore|Pcol_err|");
    end
    always@(posedge te_clk_i)begin
        //OUT transaction
       // $display("|%4t| %b | %b |   %b   | %4b |    %b    |   %b   |  %b  |     %b     | %4d|    %b    |   %b   |  %b  |     %b      |  %b  |  %b   |   %b    |     %b     |",$time,te_clk_i,te_reset,te_timeout_i,te_pid_nibble_i,te_token_trigger_i,te_token_valid_i,te_token_pac_err_i,te_crc5_fail_i,te_1.te_timer,te_data_trigger_i,te_data_valid_i,te_data_pac_err_i,te_crc16_fail_i,te_1.te_abort,te_1.te_ignore,te_send_ack_o,te_data_toggle_o);
        //IN transaction
        $display("|%4t| %b | %b |   %b   | %4b |  %b   | %b  |  %b  |   %b   | %4d|  %b   |   %b    |   %b    |   %b   |   %b    | %b |  %b  | %b  |  %b  |    %b   |  %b  |  %b   |    %b   |",$time,te_clk_i,te_reset,te_timeout_i,te_pid_nibble_i,te_token_trigger_i,te_token_valid_i,te_token_pac_err_i,te_crc5_fail_i,te_1.te_timer,te_endp_data_fail_i,te_endp_empty_i,te_endp_tx_done_i,te_endp_stalled_i,te_endp_ready_i,te_send_nak_o,te_send_stall_o,te_send_data_o,te_data_toggle_o,te_clear_endp_buff_o,te_1.te_abort,te_1.te_ignore,te_protocol_err_o);
    end

    initial begin
        te_clk_i=1'b1;
        te_reset=1'b1;
        te_pid_nibble_i=4'b0000;
    //token handler net
        te_token_trigger_i=1'b0; 
        te_token_valid_i=1'b0;
        te_token_pac_err_i=1'b0;
        te_crc5_fail_i=1'b0;
        te_addr_i=7'b0;
        te_endp_i=4'b0;
    //data handler net
        te_data_trigger_i=1'b0; 
        te_data_valid_i=1'b0;
        te_data_pac_err_i=1'b0;
        te_crc16_fail_i=1'b0;
    //handshake net
        te_handshake_trigger_i=1'b0; 
        te_ack_i=1'b0;
        te_stall_i=1'b0;
        te_nak_i=1'b0;
        //packet timer
        te_timeout_i=1'b0;
        //endpoint
        te_endp_data_toggle_i=1'b0;
        te_endp_data_fail_i=1'b0;
        te_endp_empty_i=1'b0;
        te_endp_tx_done_i=1'b0;
        te_endp_stalled_i=1'b0;
        te_endp_ready_i=1'b0;  //flag
    end
    always begin
        #1 te_clk_i=~te_clk_i;
    end

    initial begin
        #2 te_reset=1'b0;
        //OUT transaction
        /*
        #4 te_data_trigger_i=1'b1;  //data triggered - protocol error
            te_pid_nibble_i=4'b0001;
        #2 te_data_trigger_i=1'b0;
        #8 te_handshake_trigger_i=1'b1;  //handshake triggered - protocol error
        #2 te_handshake_trigger_i=1'b0;

        #2 te_token_trigger_i=1'b1;  //out triggered - timeout
        #2 te_token_trigger_i=1'b0;
        #4 te_timeout_i=1'b1;
        #2 te_timeout_i=1'b0;

        #4 te_token_trigger_i=1'b1;  //out triggered - token packet error
        #2 te_token_trigger_i=1'b0;
        #4 te_token_pac_err_i=1'b1;
        #2 te_token_pac_err_i=1'b0;

        #4 te_token_trigger_i=1'b1;  //out triggered - crc5 fail
        #2 te_token_trigger_i=1'b0;
        #4 te_crc5_fail_i=1'b1;
        #2 te_crc5_fail_i=1'b0;

        #4 te_token_trigger_i=1'b1;  //out triggered - abort
        #2 te_token_trigger_i=1'b0;
        #20 te_token_valid_i=1'b1;
        #2 te_token_valid_i=1'b0;
        #4 te_token_trigger_i=1'b1;
        #2 te_token_trigger_i=1'b0;

        #4 te_token_trigger_i=1'b1;  //out triggered - protocol error
        #2 te_token_trigger_i=1'b0;
        #20 te_token_valid_i=1'b1;
        #2 te_token_valid_i=1'b0;
        #4 te_handshake_trigger_i=1'b1;
        #2 te_handshake_trigger_i=1'b0;

        #2 te_token_trigger_i=1'b1;  //out triggered
        #2 te_token_trigger_i=1'b0;
        #20 te_token_valid_i=1'b1;
        #2 te_token_valid_i=1'b0;
        #10 te_data_trigger_i=1'b1;  //data triggered - data packet error
        #2 te_data_trigger_i=1'b0;
        #6 te_data_pac_err_i=1'b1;
        #2 te_data_pac_err_i=1'b0;

        #2 te_token_trigger_i=1'b1;  //out triggered
        #2 te_token_trigger_i=1'b0;
        #20 te_token_valid_i=1'b1;
        #2 te_token_valid_i=1'b0;
        #10 te_data_trigger_i=1'b1;  //data triggered - crc16 fail
        #2 te_data_trigger_i=1'b0;
        #20 te_crc16_fail_i=1'b1;
        #2 te_crc16_fail_i=1'b0;
        
        #2 te_token_trigger_i=1'b1;  //out triggered
        #2 te_token_trigger_i=1'b0;
        #20 te_token_valid_i=1'b1;
        #2 te_token_valid_i=1'b0;
        #10 te_data_trigger_i=1'b1;  //data triggered
        #2 te_data_trigger_i=1'b0;
        #20 te_data_valid_i=1'b1;
        #2 te_data_valid_i=1'b0;

        #8 
        */
        //IN transaction
        //*
         #4 te_data_trigger_i=1'b1;  //data triggered - protocol error
            te_pid_nibble_i=4'b1001;
        #2 te_data_trigger_i=1'b0;
        #8 te_handshake_trigger_i=1'b1;  //handshake triggered - protocol error
        #2 te_handshake_trigger_i=1'b0;

        #2 te_token_trigger_i=1'b1;  //IN triggered - timeout
        #2 te_token_trigger_i=1'b0;
        #4 te_timeout_i=1'b1;
        #2 te_timeout_i=1'b0;

        #4 te_token_trigger_i=1'b1;  //IN triggered - token packet error
        #2 te_token_trigger_i=1'b0;
        #4 te_token_pac_err_i=1'b1;
        #2 te_token_pac_err_i=1'b0;

        #4 te_token_trigger_i=1'b1;  //IN triggered - crc5 fail
        #2 te_token_trigger_i=1'b0;
        #4 te_crc5_fail_i=1'b1;
        #2 te_crc5_fail_i=1'b0;

        #4 te_token_trigger_i=1'b1;  //IN triggered - abort
        #2 te_token_trigger_i=1'b0;
        #20 te_token_valid_i=1'b1;
        #2 te_token_valid_i=1'b0;
        #4 te_token_trigger_i=1'b1;
        #2 te_token_trigger_i=1'b0;

        #4 te_token_trigger_i=1'b1;  //IN triggered - protocol error
        #2 te_token_trigger_i=1'b0;
        #20 te_token_valid_i=1'b1;
        #2 te_token_valid_i=1'b0;
        #4 te_handshake_trigger_i=1'b1;
        #2 te_handshake_trigger_i=1'b0;

        #4 te_token_trigger_i=1'b1;  //IN triggered - ENDP empty
        #2 te_token_trigger_i=1'b0;
        #20 te_token_valid_i=1'b1;
        #2 te_token_valid_i=1'b0;
        #4 te_endp_empty_i=1'b1;
        #2 te_endp_empty_i=1'b0;

        #4 te_token_trigger_i=1'b1;  //IN triggered - ENDP stalled
        #2 te_token_trigger_i=1'b0;
        #20 te_token_valid_i=1'b1;
        #2 te_token_valid_i=1'b0;
        #4 te_endp_stalled_i=1'b1;
        #2 te_endp_stalled_i=1'b0;

        #4 te_token_trigger_i=1'b1;  //IN triggered - ENDP data failed to send (problem in buffer)
        #2 te_token_trigger_i=1'b0;
        #20 te_token_valid_i=1'b1;
        #2 te_token_valid_i=1'b0;
        #4 te_endp_ready_i=1'b1;
        #2 te_endp_ready_i=1'b0;
        #4 te_endp_data_fail_i=1'b1;
        #2 te_endp_data_fail_i=1'b0;

        #4 te_token_trigger_i=1'b1;  //IN triggered - ENDP TX done but stall received
        #2 te_token_trigger_i=1'b0;
        #20 te_token_valid_i=1'b1;
        #2 te_token_valid_i=1'b0;
        #4 te_endp_ready_i=1'b1;
        #2 te_endp_ready_i=1'b0;
        #20 te_endp_tx_done_i=1'b1;
        #2 te_endp_tx_done_i=1'b0;
        #4 te_stall_i=1'b1;
        #2 te_stall_i=1'b0;

        #4 te_token_trigger_i=1'b1;  //IN triggered - ENDP TX done but nak received
        #2 te_token_trigger_i=1'b0;
        #20 te_token_valid_i=1'b1;
        #2 te_token_valid_i=1'b0;
        #4 te_endp_ready_i=1'b1;
        #2 te_endp_ready_i=1'b0;
        #20 te_endp_tx_done_i=1'b1;
        #2 te_endp_tx_done_i=1'b0;
        #4 te_nak_i=1'b1;
        #2 te_nak_i=1'b0;

        #4 te_token_trigger_i=1'b1;  //IN triggered - ENDP TX done and ack received
        #2 te_token_trigger_i=1'b0;
        #20 te_token_valid_i=1'b1;
        #2 te_token_valid_i=1'b0;
        #4 te_endp_ready_i=1'b1;
        #2 te_endp_ready_i=1'b0;
        #20 te_endp_tx_done_i=1'b1;
        #2 te_endp_tx_done_i=1'b0;
        #4 te_ack_i=1'b1;
        #2 te_ack_i=1'b0;
        //*/
        #7 $finish;
    end
endmodule
