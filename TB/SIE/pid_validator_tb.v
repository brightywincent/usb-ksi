`timescale 1 ns / 1 ns;
module pid_validator_tb;
    
    reg pv_clk_i;
	reg pv_reset; 
	reg [7:0]pv_pbyte0_i;
	reg pv_pbyte0_ready_i; 
	wire pv_valid_o;
	wire pv_error_o;

    pid_validator pv_1(
        .pv_clk_i(pv_clk_i),
        .pv_reset(pv_reset),
        .pv_pbyte0_i(pv_pbyte0_i),
        .pv_pbyte0_ready_i(pv_pbyte0_ready_i),
        .pv_valid_o(pv_valid_o),
        .pv_error_o(pv_error_o)
    );

    initial begin
        $dumpfile("TB/SIE/DUMP/pid_validator.vcd");
        $dumpvars(0,pid_validator_tb);
        $display("|Time|Clk|Reset| Byte_I |Byte_ready|PID_valid|PID_error|");
    end 

    always@(posedge pv_clk_i)begin
        $display("|%4t| %b |  %b  |%8b|    %b     |    %b    |    %b    |",$time,pv_clk_i,pv_reset,pv_pbyte0_i,pv_pbyte0_ready_i,pv_valid_o,pv_error_o);
    end

    initial begin
        pv_clk_i=1'b1;
        pv_reset=1'b1; 
        pv_pbyte0_i=8'b0;
    	pv_pbyte0_ready_i=1'b0; 
    end

    always begin
        #1 pv_clk_i=~pv_clk_i;
    end

    initial begin
        #2 pv_reset=1'b0;
        #2  pv_pbyte0_i=8'b0000_0000;
        #2  pv_pbyte0_i=8'b1000_0000;
        #2  pv_pbyte0_i=8'b0100_0000;
        #2  pv_pbyte0_i=8'b0010_0000;
        #2  pv_pbyte0_i=8'b0001_0000;
        #2  pv_pbyte0_i=8'b0000_1000;
        #2  pv_pbyte0_i=8'b1000_0100;
        #2  pv_pbyte0_i=8'b1100_0010;
        #2  pv_pbyte0_i=8'b1110_0001;
            pv_pbyte0_ready_i=1'b1;
        #2  pv_pbyte0_ready_i=1'b0;
        #5 $finish;
    end

endmodule