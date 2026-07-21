module rx_fifo(
    input wire rf_clk_i,
    input wire rf_reset,
    input wire [7:0]rf_byte_i,
    input wire rf_write_i,
    input wire rf_read_i,
    output reg [7:0]rf_byte_o,
    output reg rf_empty_o, //flag
    output reg rf_full_o,  //flag
    output reg rf_underflow_o, //pulse
    output reg rf_overflow_o //pulse
);
    reg [7:0] fifo_mem[63:0];
    reg [5:0]rd_ptr;
    reg [5:0]wr_ptr;
    reg [6:0]byte_count;

    always@(posedge rf_clk_i or posedge rf_reset)begin
        if(rf_reset)begin
            rf_empty_o<=1'b1;
            rf_underflow_o<=1'b0;
            rf_full_o<=1'b0;
            rf_overflow_o<=1'b0;
            rd_ptr<=6'b0;
            wr_ptr<=6'b0;
            byte_count<=7'b0;
        end
        else begin
            rf_overflow_o<=1'b0;
            rf_underflow_o<=1'b0;
            rf_empty_o<=(byte_count==7'b0);
            rf_full_o<=(byte_count==7'd64);
            case({rf_write_i,rf_read_i})
                2'b00 : begin
                    rf_byte_o<=8'bx;
                end
                2'b10 : begin
                    if(byte_count==7'd64)begin
                        rf_overflow_o<=1'b1;
                        rf_byte_o<=8'bx;
                    end
                    else begin
                        fifo_mem[wr_ptr]<=rf_byte_i;
                        wr_ptr<=wr_ptr+1;
                        byte_count<=byte_count+1;
                    end
                end
                2'b01 : begin
                    if(byte_count==7'd0)begin
                        rf_underflow_o<=1'b1;
                        rf_byte_o<=8'bx;
                    end
                    else begin
                        rf_byte_o<=fifo_mem[rd_ptr];
                        rd_ptr<=rd_ptr+1;
                        byte_count<=byte_count-1;
                    end                       
                end
                2'b11 : begin
                    rf_byte_o<=rf_byte_i;
                end
                default : begin
                    rf_byte_o<=8'bx;
                end
            endcase
        end
    end

endmodule