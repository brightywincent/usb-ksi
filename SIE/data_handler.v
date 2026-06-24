module data_handler(
    input wire dh_clk_i,
    input wire dh_reset,
    input wire dh_trigger,
    input wire dh_eop_start_i,
    input wire dh_sync_i,
    input wire [31:0]dh_bytes_i,  
    input wire [3:0]dh_byte_ready_i, 
    input wire [15:0]dh_crc16_i,
    output reg dh_write_o,
    output reg dh_crc16_reset_o,
    output reg dh_data_valid_o,
    output reg dh_crc16_fail_o,
    output reg dh_packet_error_o,
    output reg [7:0]dh_byte_o
);
    localparam IDLE = 2'b00;
    localparam ACTIVE = 2'b01;

    reg [1:0]STATE;
    reg [10:0]dh_byte_write_count;
    
    always@(posedge dh_clk_i or posedge dh_reset)begin
        if(dh_reset)begin
            dh_crc16_reset_o<=1'b0;
            dh_data_valid_o<=1'b0;
            dh_crc16_fail_o<=1'b0;
            dh_packet_error_o<=1'b0;
            dh_write_o<=1'b0;
            dh_byte_o<=8'b0;
            dh_byte_write_count<=11'b0;
            STATE<=2'b0;
        end
        else begin
            dh_data_valid_o<=1'b0;
            dh_crc16_fail_o<=1'b0;
            dh_crc16_reset_o<=1'b0;
            dh_packet_error_o<=1'b0;
            dh_write_o<=1'b0;
            case(STATE)
                IDLE : begin
                    if(dh_trigger)begin
                        STATE<=ACTIVE;
                        dh_byte_write_count<=11'b0;
                    end
                end
                ACTIVE : begin
                    case(dh_byte_ready_i)
                        4'b0001: begin
                            dh_byte_o<=dh_bytes_i[7:0];
                            dh_write_o<=1'b1;
                            dh_byte_write_count<=dh_byte_write_count+1;
                        end
                        4'b0010: begin
                            dh_byte_o<=dh_bytes_i[15:8];
                            dh_write_o<=1'b1;
                            dh_byte_write_count<=dh_byte_write_count+1;
                        end
                        4'b0100: begin
                            dh_byte_o<=dh_bytes_i[23:16];
                            dh_write_o<=1'b1;
                            dh_byte_write_count<=dh_byte_write_count+1;
                        end
                        4'b1000: begin
                            dh_byte_o<=dh_bytes_i[31:24];
                            dh_write_o<=1'b1;
                            dh_byte_write_count<=dh_byte_write_count+1;
                        end
                        default :begin 
                            dh_write_o<=1'b0;
                        end
                    endcase
                end
                default :  STATE<=IDLE;
            endcase
            if(STATE==ACTIVE) begin
                if(dh_sync_i)begin
                        dh_packet_error_o<=1'b1;
                        STATE<=IDLE;
                        dh_crc16_reset_o<=1'b1;
                end
                else if(dh_eop_start_i)begin
                    STATE<=IDLE;
                    dh_crc16_reset_o<=1'b1;
                    if(dh_crc16_i==16'b0)
                        dh_data_valid_o<=1'b1;
                    else
                        dh_crc16_fail_o<=1'b1;
                end
            end
        end
    end
endmodule

