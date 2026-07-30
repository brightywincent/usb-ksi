`timescale 1 ns / 1ns;
module descriptor_manager_tb;
    reg dm_read_i;
    reg [7:0]dm_type_i;
    reg [7:0]dm_index_i;
    wire [7:0]dm_addr_o;
    wire [7:0]dm_length_o;
    wire dm_valid_o;

    reg stop;

    descriptor_manager dm_1(
        .dm_read_i(dm_read_i),
        .dm_type_i(dm_type_i),
        .dm_index_i(dm_index_i),
        .dm_addr_o(dm_addr_o),
        .dm_length_o(dm_length_o),
        .dm_valid_o(dm_valid_o)
    );

    initial begin
        $dumpfile("TB/CONTROL/DUMP/descriptor_manager.vcd");
        $dumpvars(0,descriptor_manager_tb);
        $display("|Time|Read|Type|Index|Address_Out|Length_Out|Valid_Out|");
        //$monitor("|%4t| %b  | %2h | %2h  |    %2h     |    %2h    |    %b    |",$time,dm_read_i,dm_type_i,dm_index_i,dm_addr_o,dm_length_o,dm_valid_o);
    end

    always begin
        #1  $display("|%4t| %b  | %2h | %2h  |    %2h     |    %2h    |    %b    |",$time,dm_read_i,dm_type_i,dm_index_i,dm_addr_o,dm_length_o,dm_valid_o);
    end

    initial begin
        dm_read_i=1'b0;
        dm_type_i=8'h00;
        dm_index_i=8'h00;
    end

    initial begin
        #3 dm_read_i=1'b1;
        dm_type_i=8'h01;
        dm_index_i=8'h00;
        #1 dm_read_i=1'b0;

        #3 dm_read_i=1'b1;
        dm_type_i=8'h02;
        dm_index_i=8'h00;
        #1 dm_read_i=1'b0;

        #3 dm_read_i=1'b1;
        dm_type_i=8'h05;
        dm_index_i=8'h00;
        #1 dm_read_i=1'b0;

        #3 dm_read_i=1'b1;
        dm_type_i=8'h05;
        dm_index_i=8'h01;
        #1 dm_read_i=1'b0;
        
        #3 dm_read_i=1'b1;
        dm_type_i=8'h05;
        dm_index_i=8'h02;
        #1 dm_read_i=1'b0;
        
        #3 dm_read_i=1'b1;
        dm_type_i=8'h05;
        dm_index_i=8'h03;
        #1 dm_read_i=1'b0;
        
        #5 $finish;
    end

endmodule
