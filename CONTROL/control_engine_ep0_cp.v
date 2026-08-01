`include "bRequest.vh"
`include "DESCRIPTOR_TYPES.vh"
`include "BASES.vh"
module control_engine_ep0_cp #(
    parameter STANDARD 2'b00,
    parameter CLASS 2'b01,
    parameter VENDOR 2'b10,
    parameter RESERVED 2'b11
)(
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

    output reg descriptor_start_o, //Data path
    output reg set_address_o,  //Address manager
    output reg set_configuration_o,  //Config manager
    output reg start_status_stage_o  //Transaction engine

    output reg [7:0]cecp_addr_o,
    output reg [7:0]cecp_length_o,
    output reg  [15:0]wLength_o
);

    localparam IDLE = 3'd0;
    localparam EXECUTE = 3'd1;

    reg [7:0]bmRequestType;
    reg [7:0]bRequest;
    reg [15:0]wValue;
    reg [15:0]wIndex;
    reg [15:0]wLength;

    always @(posedge cecp_clk_i or posedge cecp_reset)begin
        if(cecp_reset)begin
            bmRequestType<=8'h00;
            bRequest<=8'h00;
            wValue<=16'h00_00;
            wIndex<=16'h00_00;
            wLength<=16'h00_00;
            STATE<=3'b0;
        end
        else begin
            case(STATE)
                IDLE : begin
                    if(cecp_setup_done_i) begin
                        bmRequestType<=bmRequestType_i;
                        bRequest<=bRequest_i;
                        wValue<=wValue_i;
                        wIndex<=wIndex_i;
                        wLength<=wLength_i;    
                        STATE<=EXECUTE;
                    end
                end
                EXECUTE : begin
                    case(bmRequestType[6:5])
                        STANDARD : begin
                            case(bRequest)
                                GET_STATUS :
                                CLEAR_FEATURE :
                                SET_FEATURE :
                                SET_ADDRESS :
                                
                                GET_DESCRIPTOR : begin
                                    case(wValue[15:8])
                                        `TYPE_DEVICE :begin
                                            if(wValue[7:0]==8'h00)begin
                                                cecp_addr_o<=`DEVICE_BASE;
                                                cecp_length_o<=(wLength < `DEVICE_LENGTH)?wLength:`DEVICE_LENGTH;
                                            end
                                        end
                                        `TYPE_CONFIGURATION : begin
                                            if(wValue[7:0]==8'h01)begin
                                                cecp_addr_o<=`CONFIGURATION_BASE;
                                                cecp_length_o<=(wLength < `CONFIGURATION_LENGTH)?wLength:`CONFIGURATION_LENGTH;
                                            end
                                        end
                                        `TYPE_INTERFACE : begin

                                        end
                                        `TYPE_ENDPOINT : begin

                                        end
                                        `TYPE_STRING : begin
                                            if()
                                        end
                                    endcase
                                end

                                SET_DESCRIPTOR :
                                GET_CONFIGURATION :
                                SET_CONFIGURATION :
                                GET_INTERFACE :
                                SET_INTERFACE :
                                SYNCH_FRAME :
                            endcase
                        end
                        CLASS : begin

                        end
                        VENDOR : begin

                        end
                        RESERVED : begin

                        end
                    endcase
                end
                STATUS : begin

                end
            endcase
        end
    end

endmodule
