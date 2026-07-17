module control_engine_ep0_dp(
    input wire cedp_clk_i,
    input wire cedp_reset,
    
    input wire [63:0]cedp_setup_packet_i, //Transaction engine
    input wire cedp_out_data_valid_i,
    input wire [7:0]cedp_out_data_byte_i,

    input wire cedp_descriptor_start_i, //Control path
    
    input wire [7:0]cedp_descriptor_byte_i, //Descriptor manager
    input wire cedp_descriptor_valid_i,
   
    input wire [2:0]STATE,

    output reg [7:0]bmRequestType_o,  //Control path
    output reg [7:0]bRequest_o,
    output reg [15:0]wValue_o,
    output reg [15:0]wIndex_o,
    output reg [15:0]wLength_o
    output reg cedp_descriptor_done_o
);

    always@(posedge cedp_clk_i or posedge cedp_reset)begin
        if(cedp_reset)begin

        end
        else begin

        end
    end

endmodule
