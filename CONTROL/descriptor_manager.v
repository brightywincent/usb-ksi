`include "DESCRIPTOR_TYPES.vh"
`include "BASES.vh"
module descriptor_manager(
    input wire dm_read_i,
    input wire [7:0]dm_type_i,
    input wire [7:0]dm_index_i,
    output reg [7:0]dm_addr_o,
    output reg [7:0]dm_length_o,
    output reg dm_valid_o
);

    localparam STRING0 = 8'h00;
    localparam STRING1 = 8'h01;
    localparam STRING2 = 8'h02;
    localparam STRING3 = 8'h03;

    always @(*)begin
            dm_addr_o=8'h00;
            dm_length_o=8'h00;
            dm_valid_o=1'b0;
            if(dm_read_i)begin
                case(dm_type_i)
                `TYPE_DEVICE : begin
                    if(dm_index_i==8'h00)begin
                        dm_addr_o=`DEVICE_BASE;
                        dm_length_o=`DEVICE_LENGTH;
                        dm_valid_o=1'b1;
                    end
                end
                `TYPE_CONFIGURATION : begin
                    if(dm_index_i==8'h00)begin
                        dm_addr_o=`CONFIGURATION_BASE;
                        dm_length_o=`CONFIGURATION_LENGTH;
                        dm_valid_o=1'b1;
                    end
                end
                `TYPE_STRING : begin
                    case(dm_index_i)
                        STRING0 : begin
                            dm_addr_o=`STRING0_BASE;
                            dm_length_o=`STRING0_LENGTH;
                            dm_valid_o=1'b1;
                        end
                        STRING1 : begin
                            dm_addr_o=`STRING1_BASE;
                            dm_length_o=`STRING1_LENGTH;
                            dm_valid_o=1'b1;
                        end
                        STRING2 : begin
                            dm_addr_o=`STRING2_BASE;
                            dm_length_o=`STRING2_LENGTH;
                            dm_valid_o=1'b1;
                        end
                        STRING3 : begin
                            dm_addr_o=`STRING3_BASE;
                            dm_length_o=`STRING3_LENGTH;
                            dm_valid_o=1'b1;
                        end
                    endcase 
                end
                endcase
            end
    end
endmodule
