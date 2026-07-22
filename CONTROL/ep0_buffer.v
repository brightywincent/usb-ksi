module ep0_buffer(
    input wire ep0b_clk_i,
    input wire ep0b_reset,
    input wire ep0b_clear,
    input wire ep0b_en,  //Enable for the EP0 buffer
    input wire ep0b_packet_commit_i,
    input wire [7:0]ep0b_wr_byte_i,
    input wire ep0b_wr_en_i,
    input wire ep0b_rd_en_i,
    input wire [7:0]ep0b_rd_addr_i,

    output reg [7:0]ep0b_rd_byte_o,
    output reg ep0b_empty_o,
    output reg ep0b_packet_valid_o,
    output reg [7:0]ep0b_packet_length_o
);
    reg [7:0] ep0_mem[63:0];
    reg [7:0]wr_ptr;
    always @(posedge ep0b_clk_i or posedge ep0b_reset)begin
        if(ep0b_reset)begin
            wr_ptr<=8'b0;
            ep0b_empty_o<=1'b1;
            ep0b_rd_byte_o<=8'bx;
            ep0b_packet_length_o<=8'b0;
            ep0b_packet_valid_o<=1'b0;
        end
        else if(ep0b_clear)begin
            wr_ptr<=8'b0;
            ep0b_empty_o<=1'b1;
            ep0b_rd_byte_o<=8'bx;
            ep0b_packet_length_o<=8'b0;
            ep0b_packet_valid_o<=1'b0;
        end
        else if(ep0b_en) begin
            if(ep0b_rd_en_i)begin  //Both conditions can never be satisfied simultaneously
                ep0b_rd_byte_o<=ep0_mem[ep0b_rd_addr_i];
            end
            if(ep0b_wr_en_i)begin  //So, just if statements are used.
                ep0_mem[wr_ptr]<=ep0b_wr_byte_i;
                wr_ptr<=wr_ptr+1;
                ep0b_empty_o<=1'b0;
            end
            if(ep0b_packet_commit_i)begin
                ep0b_packet_valid_o<=1'b1;
                ep0b_packet_length_o<=wr_ptr+1;
            end
        end
    end
endmodule
