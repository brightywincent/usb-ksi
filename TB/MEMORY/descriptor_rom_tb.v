module descriptor_rom_tb;
    reg [7:0]dr_rd_addr_i;
    wire [7:0]dr_rd_byte_o;

    descriptor_rom dr_1(
        .dr_rd_addr_i(dr_rd_addr_i),
        .dr_rd_byte_o(dr_rd_byte_o)
    );

    initial begin
        $dumpfile("TB/MEMORY/DUMP/descriptor_rom.vcd");
        $dumpvars(0,descriptor_rom_tb);
        $display("|Time|Input_Address|MEMORY|");
        for(dr_rd_addr_i=8'h00;dr_rd_addr_i<=8'h63;dr_rd_addr_i=dr_rd_addr_i+1) begin
            #2 $display("|%4t|    %2s%2h     |  %2h  |",$time,"0x",dr_rd_addr_i,dr_rd_byte_o);
        end
        $finish;
    end
endmodule
