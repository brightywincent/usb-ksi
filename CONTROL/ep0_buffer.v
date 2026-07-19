module ep0_buffer(
    input wire ep0b_clk_i,
    input wire ep0b_reset,
    input wire ep0b_en,  //Enable for the EP0 buffer
    input wire ep0b_empty_i,  //RX FIFO empty flag

    input wire [7:0]ep0b_wr_byte_i,
    input wire ep0b_rd_en_i,
    input wire ep0b_rd_addr_i,

    output reg [7:0]ep0b_rd_byte_o
);

    reg [7:0] ep0_mem[7:0];
    reg wr_en;
    reg [7:0]wr_ptr;
    reg [7:0]rd_ptr;
    reg [7:0]byte_count;

    always @(posedge ep0b_clk_i or posedge ep0b_reset)begin
        if(ep0b_reset)begin
            wr_en<=1'b0;
            rd_ptr<=8'b0;
            wr_ptr<=8'b0;
        end
        else if(ep0b_en) begin
            case(ep0b_empty_i)
                1'b0 : begin
                    STATE<=WRITE;
                end
                1'b1 : begin
                    STATE<=IDLE;
                end
            endcase
            case(STATE)
                IDLE : begin
                    if(ep0b_rd_en)begin
                        STATE<=READ;
                    end
                end
                WRITE : begin
                    ep0_mem[wr_ptr]<=ep0b_wr_byte_i;
                    wr_ptr<=wr_ptr+1;
                    byte_count<=byte_count+1;
                end
                READ : begin
                    
                end
            endcase
        end
    end

endmodule
