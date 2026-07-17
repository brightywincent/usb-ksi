module ep0_buffer(
    input wire ep0b_clk_i,
    input wire ep0b_reset,

    input wire ep0b_byte_i
);

    reg [7:0] ep0_mem[7:0];

    always @(posedge ep0b_clk_i or posedge ep0b_reset)begin

    end

endmodule
