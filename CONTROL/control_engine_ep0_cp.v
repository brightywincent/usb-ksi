`include "bRequest.vh"
`include "DESCRIPTOR_TYPES.vh"
`include "BASES.vh"
//Max LUN = Number of LUNs − 1
module control_engine_ep0_cp #(
    parameter STANDARD 2'b00,
    parameter CLASS 2'b01,
    parameter VENDOR 2'b10,
    parameter RESERVED 2'b11
)(
    input wire cecp_clk_i,
    input wire cecp_reset,

    input wire cecp_setup_done_i,  //Transaction engine
    input wire cecp_status_in_done_i,
    input wire cecp_timeout_i,
    
    input wire [7:0]bmRequestType_i, //from datapath
    input wire [7:0]bRequest_i,
    input wire [15:0]wValue_i,
    input wire [15:0]wIndex_i,
    input wire [15:0]wLength_i,

    input wire cecp_transaction_error_i,

    input wire cecp_data_in_done_i,
    input wire cecp_status_out_done_i,
    input wire cecp_stall_done_i,

    input wire cecp_halt_i, //EP halt flags ORed input 

    output reg descriptor_start_o, //Data path
    
    output reg cecp_ld_addr_o,  //Address manager
    output reg [6:0]cecp_new_addr_o,

    output reg cecp_set_config_o,  //Config manager
    output reg [7:0]cecp_new_config_o,
    output reg start_status_stage_o,  //Transaction engine

    output reg [7:0]cecp_addr_o,
    output reg [15:0]cecp_length_o,

    output reg [7:0]cecp_interface_o,
    
    output reg cecp_rd_curr_config_o,
    output reg cecp_rd_interface_o,

    output reg cecp_ep1_out_halt_o,
    output reg cecp_ep1_in_halt_o,

    output reg cecp_ep1_out_clear_halt_o,
    output reg cecp_ep1_in_clear_halt_o,

    output reg [15:0] got_status,

    output reg cecp_bot_reset_o,
    output reg [7:0]cecp_max_lun_o,

    output reg cecp_send_zlp_o,

    output reg cecp_commit_o,
    output reg cecp_send_data_in_o
);

    localparam IDLE = 3'd0;
    localparam EXECUTE = 3'd1;
    localparam SEND_STATUS_IN = 3'd2;
    localparam STATUS_IN = 3'd3;
    localparam SEND_DATA_IN = 3'd4;
    localparam DATA_IN = 3'd5;
    localparam STALL = 3'd6;
    localparam ERROR = 3'd7;

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
            got_status<=16'h0000;
        end
        else begin
            cecp_rd_curr_config_o<=1'b0;
            cecp_set_config_o<=1'b0;
            cecp_rd_interface_o<=1'b0;
            cecp_ld_addr_o<=1'b0;
            cecp_ep1_out_halt_o<=1'b0;
            cecp_ep1_in_halt_o<=1'b0;
            cecp_ep1_out_clear_halt_o<=1'b0;
            cecp_ep1_in_clear_halt_o<=1'b0;
            got_status<=16'h0000;
            cecp_bot_reset_o<=1'b0;
            cecp_max_lun_o<=8'h00;
            cecp_send_zlp_o<=1'b0;
            cecp_commit_o<=1'b0;
            cecp_send_data_in_o<=1'b0;
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
                                `GET_STATUS : begin
                                        case(bmRequestType[4:0])
                                            5'b0 : begin //Device
                                                got_status<=16'h0000;
                                                STATE<=SEND_DATA_IN;
                                            end
                                            5'b1 : begin //Interface
                                                got_status<=16'h0000;
                                                STATE<=SEND_DATA_IN;
                                            end
                                            5'b2 : begin //Endpoint
                                                if(cecp_halt_i)begin
                                                    got_status<=16'h01;
                                                    STATE<=SEND_DATA_IN;
                                                end
                                                else 
                                                    got_status<=16'h00;
                                                    STATE<=SEND_DATA_IN;
                                            end
                                        endcase
                                end
                                `CLEAR_FEATURE : begin
                                    case(bmRequestType[4:0])
                                        5'b0 : begin //Device
                                            case(wValue)       //Feature Selectors
                                                //Device_Remote_Wakeup
                                                16'h0001 : //STALL
                                                STATE<=STALL;
                                                //Test_Mode
                                                16'h0002 : 
                                                STATE<=STALL;//STALL 
                                            endcase
                                        end
                                        5'b1 : begin //Interface
                                            //No Feature selectors for STANDARD.
                                            //STALL
                                            STATE<=STALL;
                                        end
                                        5'b2 : begin //Endpoint
                                            case(wIndex[7:0])
                                                8'h01 : begin
                                                    cecp_ep1_out_clear_halt_o<=1'b1;
                                                    STATE<=SEND_STATUS_IN;
                                                end
                                                8'h81 : begin
                                                    cecp_ep1_in_clear_halt_o<=1'b1;
                                                    STATE<=SEND_STATUS_IN;
                                                end
                                            endcase
                                        end
                                        default : STATE<=STALL;
                                    endcase
                                end 
                                `SET_FEATURE : begin
                                    case(bmRequestType[4:0])
                                        5'b0 : begin //Device
                                            case(wValue)       //Feature Selectors
                                                //Device_Remote_Wakeup
                                                16'h0001 : //STALL
                                                    STATE<=STALL;
                                                //Test_Mode
                                                16'h0002 : //STALL
                                                    STATE<=STALL; 
                                            endcase
                                        end
                                        5'b1 : begin //Interface
                                            //No Feature selectors for STANDARD.
                                            //STALL
                                            STATE<=STALL;
                                        end
                                        5'b2 : begin //Endpoint
                                            case(wIndex[7:0])
                                                8'h01 : begin
                                                    cecp_ep1_out_halt_o<=1'b1;
                                                    STATE<=SEND_STATUS_IN;
                                                end
                                                8'h81 : begin
                                                    cecp_ep1_in_halt_o<=1'b1;
                                                    STATE<=SEND_STATUS_IN;
                                                end
                                            endcase
                                        end
                                        default : STATE<=STALL;
                                    endcase
                                end
                                `SET_ADDRESS : begin
                                    cecp_new_addr_o<=wValue[6:0];
                                    cecp_ld_addr_o<=1'b1;
                                    //After status stage, give the commit signal to the address manager
                                    STATE<=SEND_STATUS_IN;
                                end
                                `GET_DESCRIPTOR : begin
                                    case(wValue[15:8])
                                        `TYPE_DEVICE :begin
                                            if(wValue[7:0]==8'h00)begin
                                                cecp_addr_o<=`DEVICE_BASE;
                                                cecp_length_o<=(wLength < `DEVICE_LENGTH)?wLength:`DEVICE_LENGTH;
                                                STATE<=SEND_DATA_IN;
                                            end
                                        end
                                        `TYPE_CONFIGURATION : begin
                                            if(wValue[7:0]==8'h00)begin
                                                cecp_addr_o<=`CONFIGURATION_BASE;
                                                cecp_length_o<=(wLength < `CONFIGURATION_LENGTH)?wLength:`CONFIGURATION_LENGTH;
                                                STATE<=SEND_DATA_IN;
                                            end
                                        end
                                        `TYPE_STRING : begin
                                            case(wValue[7:0])
                                                8'h00 : begin
                                                    cecp_addr_o<=`STRING0_BASE;
                                                    cecp_length_o<=(wLength < `STRING0_LENGTH)?wLength:`STRING0_LENGTH;     
                                                    STATE<=SEND_DATA_IN;
                                                end
                                                8'h01 : begin
                                                    cecp_addr_o<=`STRING1_BASE;
                                                    cecp_length_o<=(wLength < `STRING1_LENGTH)?wLength:`STRING1_LENGTH;     
                                                    STATE<=SEND_DATA_IN;
                                                end
                                                8'h02 : begin
                                                    cecp_addr_o<=`STRING2_BASE;
                                                    cecp_length_o<=(wLength < `STRING2_LENGTH)?wLength:`STRING2_LENGTH;     
                                                    STATE<=SEND_DATA_IN;
                                                end
                                                8'h03 : begin
                                                    cecp_addr_o<=`STRING3_BASE;
                                                    cecp_length_o<=(wLength < `STRING3_LENGTH)?wLength:`STRING3_LENGTH;     
                                                    STATE<=SEND_DATA_IN;
                                                end
                                            endcase
                                        end
                                    endcase
                                end
                                `SET_DESCRIPTOR : begin
                                    //STALL for mass storage
                                    STATE<=STALL;
                                end
                                `GET_CONFIGURATION : begin
                                    if(wLength==16'h0001)begin
                                        cecp_rd_curr_config_o<=1'b1;
                                        STATE<=SEND_DATA_IN;
                                    end
                                end
                                `SET_CONFIGURATION : begin
                                    if(wValue[7:0]<=8'h01)begin
                                        cecp_set_config_o<=1'b1;
                                        cecp_new_config_o<=wValue[7:0];
                                        STATE<=SEND_STATUS_IN;
                                    end
                                    else //STALL
                                        STATE<=STALL;
                                end
                                `GET_INTERFACE : begin
                                    if(wIndex==16'h0000) begin
                                        cecp_interface_o<=8'h00;
                                        cecp_rd_interface_o<=1'b1;
                                        STATE<=SEND_DATA_IN;
                                    end
                                    else //STALL
                                        STATE<=STALL;
                                end
                                `SET_INTERFACE : begin
                                    if(wIndex==16'h0000) begin
                                        STATE<=SEND_STATUS_IN;
                                    end
                                    else //STALL
                                        STATE<=STALL;
                                end
                                `SYNCH_FRAME :begin
                                    //For iscochronous endpoints
                                    //STALL
                                    STATE<=STALL;
                                end
                            endcase
                        end
                        CLASS : begin  //this is for interface recipient
                            case(bRequest)
                                `BULK_ONLY_RESET : begin
                                    if(wValue==16'h0000 && wLength==16'h0000)begin
                                        cecp_bot_reset_o<=1'b1;
                                        STATE<=SEND_STATUS_IN;
                                    end
                                end
                                `GET_MAX_LUN : begin
                                    if(wIndex==16'h0000 && wLength==16'h0001) begin
                                        cecp_max_lun_o<=8'h00;
                                        STATE<=SEND_DATA_IN;
                                    end
                                end
                            endcase
                        end
                        VENDOR : begin
                            //Custom requests. Will get to those later.
                            STATE<=STALL; //For now
                        end
                        RESERVED : begin
                            STATE<=STALL;
                        end
                    endcase
                end
                SEND_STATUS_IN : begin
                    cecp_send_zlp_o<=1'b1;
                    STATE<=STATUS_IN;
                end
                STATUS_IN : begin
                    if(cecp_status_in_done_i) begin
                        cecp_commit_o<=1'b1;
                        STATE<=IDLE;
                    end
                    else if(cecp_transaction_error_i) begin
                        STATE<=ERROR; //Error Handler. For future expansion
                    end
                end
                SEND_DATA_IN : begin
                    cecp_send_data_in_o<=1'b1;
                    STATE<=DATA_IN;
                end
                DATA_IN : begin
                    if(cecp_data_in_done_i) begin
                        STATE<=STATUS_OUT;
                    end
                    else if(cecp_transaction_error_i) begin
                        STATE<=ERROR;
                    end
                end
                STATUS_OUT : begin
                     //wait for the transaction engine to confirm the zlp sent by the host.
                     if(cecp_status_out_done_i) begin
                        STATE<=IDLE;
                     end
                     else if(cecp_transaction_error_i)begin
                        STATE<=ERROR;
                     end
                end
                SEND_STALL : begin 
                    cecp_send_stall_o<=1'b1;
                    STATE<=STALL;
                    /*Later separate, cecp_stall_setup_o
                                      cecp_stall_data_o
                                      cecp_stall_status_o */
                end
                STALL : begin
                    if(cecp_stall_done_i)begin
                        STATE<=IDLE;
                    end
                    else if(cecp_transaction_error_i) begin
                        STATE<=ERROR;
                    end
                end
                ERROR : begin
                    STATE<=IDLE;  //Until there is a dedicated error handling mechanism
                end
                default : STATE<=IDLE;
            endcase
        end
    end
endmodule
