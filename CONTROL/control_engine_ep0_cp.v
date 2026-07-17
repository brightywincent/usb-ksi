module control_engine_ep0_cp(
    input wire cecp_clk_i,
    input wire cecp_reset,

    input wire cecp_setup_done_i,  //Transaction engine
    input wire cecp_status_done_i,
    input wire cecp_timeout_i,
    
    input wire [7:0]bmRequestType_i, //from datapath
    input wire [7:0]bRequest_i,
    input wire [15:0]wValue_i,
    input wire [15:0]wIndex_i,
    input wire [15:0]wLength_i,

    output reg [2:0]STATE;
    output reg descriptor_start_o, //Data path
    output reg set_address_o,  //Address manager
    output reg set_configuration_o,  //Config manager
    output reg start_status_stage_o  //Transaction engine
);

    localparam IDLE = 3'd0;
    localparam DECODE = 3'd1;

    always @(posedge cecp_clk_i or posedge cecp_reset)begin
        if(cecp_reset)begin
            STATE<=3'b0;
        end
        else begin
            case(STATE)
                IDLE : begin
                    if(cecp_setup_done_i)
                        STATE<=DECODE;
                end
                DECODE : begin

                end
            endcase
        end
    end

endmodule
