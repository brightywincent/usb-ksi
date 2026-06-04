module bit_unstuffer_tb;
    
    reg bu_clk_i;
    reg bu_reset;
    reg bu_sbit_i;
    reg bu_valid_bit_i;
    wire bu_unstuff_o;
    wire bu_error_o;

    bit_unstuffer bu_1(
        .bu_clk_i(bu_clk_i),
        .bu_reset(bu_reset),
        .bu_sbit_i(bu_sbit_i),
        .bu_valid_bit_i(bu_valid_bit_i), 
        .bu_unstuff_o(bu_unstuff_o),
        .bu_error_o(bu_error_o)
    );

    initial begin
        $dumpfile("TB/bit_unstuffer.vcd");
        $dumpvars(0,bit_unstuffer_tb);
        $display("|Time|Clk|Reset|Valid|Input|Count|Unstuff|Error|");
    end

    always@(posedge bu_clk_i)begin
        $display("|%3t | %b |  %b  |  %b  |  %b  |  %d  |   %b   |  %b  |",$time,bu_clk_i,bu_reset,~bu_valid_bit_i,bu_sbit_i,bu_1.bu_count,bu_unstuff_o,bu_error_o);
    end

    initial begin
        bu_clk_i=1'b1;
        bu_reset=1'b1;
        bu_sbit_i=1'b0;
        bu_valid_bit_i=1'b0;
    end

    always begin
        #1 bu_clk_i =~ bu_clk_i;
    end

    initial begin
        #2 bu_reset=1'b0;
           bu_sbit_i=1'b1;
        #12 bu_sbit_i=1'b0;
        bu_sbit_i=1'b1;
        #12 bu_sbit_i=1'b0;
        #4 bu_valid_bit_i=1'b1;
        #2 bu_valid_bit_i=1'b0;
        bu_sbit_i=1'b1;
        #12 bu_sbit_i=1'b0; 
        #9 $finish;
    end

endmodule