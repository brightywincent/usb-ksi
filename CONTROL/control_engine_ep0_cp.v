`include "bRequest_i.vh"
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
    input wire cecp_timeout_i,  //Transaction engine
    input wire cecp_setup_done_i,  
    input wire cecp_status_in_done_i,
    input wire cecp_transaction_error_i,
    input wire cecp_data_in_done_i,
    input wire cecp_status_out_done_i,
    input wire cecp_stall_done_i,
    input wire [7:0]bmRequestType_i, //from datapath
    input wire [7:0]bRequest_i,
    input wire [15:0]wValue_i,
    input wire [15:0]wIndex_i,
    input wire [15:0]wLength_i,
    input wire cecp_halt_i, //EP halt flags ORed input 
    
    output reg descriptor_start_o, //Data path
    output reg [7:0]cecp_addr_o,
    output reg [15:0]cecp_length_o,
    output reg cecp_set_addr_o,  //Address manager
    output reg [6:0]cecp_new_addr_o,
    output reg cecp_commit_o, //address, config managers
    output reg cecp_set_config_o,  //Config manager
    output reg [7:0]cecp_new_config_o,
    output reg cecp_rd_curr_config_o,  
    output reg cecp_rd_interface_o,
    output reg start_status_stage_o,  //Transaction engine
    output reg cecp_send_zlp_o,
    output reg cecp_send_data_in_o 
    output reg cecp_ep1_out_halt_o,  //endpoint
    output reg cecp_ep1_in_halt_o,  
    output reg cecp_ep1_out_clear_halt_o, 
    output reg cecp_ep1_in_clear_halt_o,  
    output reg [15:0] got_status,  
    output reg [7:0]cecp_max_lun_o,    
    output reg [7:0]cecp_interface_o, //datapath 
    output reg cecp_get_status_o,

    output reg cecp_bot_reset_o,    
);
    localparam IDLE = 4'd0;
    localparam EXECUTE = 4'd1;
    localparam SEND_STATUS_IN = 4'd2;
    localparam STATUS_IN = 4'd3;
    localparam SEND_DATA_IN = 4'd4;
    localparam DATA_IN = 4'd5;
    localparam STATUS_OUT =4'd6;
    localparam SEND_STALL =4'd7;
    localparam STALL = 4'd8;
    localparam ERROR = 4'd9;
    
    reg [3:0]STATE;

    always @(posedge cecp_clk_i or posedge cecp_reset)begin
        if(cecp_reset)begin
            STATE<=3'b0;
            got_status<=16'h0000;
        end
        else begin
            cecp_rd_curr_config_o<=1'b0;
            cecp_set_config_o<=1'b0;
            cecp_rd_interface_o<=1'b0;
            cecp_set_addr_o<=1'b0;
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
            cecp_get_status_o<=1'b0;
            case(STATE)
                IDLE : begin
                    if(cecp_setup_done_i) begin    
                        STATE<=EXECUTE;
                    end
                end
                EXECUTE : begin
                    case(bmRequestType_i[6:5])
                        STANDARD : begin
                            case(bRequest_i)
                                `GET_STATUS : begin
                                    cecp_get_status_o<=1'b1;
                                    STATE<=SEND_DATA_IN;
                                end
                                `CLEAR_FEATURE : begin
                                    case(bmRequestType_i[4:0])
                                        5'b0 : begin //Device
                                            case(wValue_i)       //Feature Selectors
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
                                            case(wIndex_i[7:0])
                                                8'h01 : begin
                                                    cecp_ep1_out_clear_halt_o<=1'b1;
                                                    STATE<=SEND_STATUS_IN;
                                                end
                                                8'h81 : begin
                                                    cecp_ep1_in_clear_halt_o<=1'b1;
                                                    STATE<=SEND_STATUS_IN;
                                                end
                                                default : STATE<=STALL;
                                            endcase
                                        end
                                        default : STATE<=STALL;
                                    endcase
                                end 
                                `SET_FEATURE : begin
                                    case(bmRequestType_i[4:0])
                                        5'b0 : begin //Device
                                            case(wValue_i)       //Feature Selectors
                                                //Device_Remote_Wakeup
                                                16'h0001 : //STALL
                                                    STATE<=STALL;
                                                //Test_Mode
                                                16'h0002 : //STALL
                                                    STATE<=STALL;
                                                default : STATE<=STALL; 
                                            endcase
                                        end
                                        5'b1 : begin //Interface
                                            //No Feature selectors for STANDARD.
                                            //STALL
                                            STATE<=STALL;
                                        end
                                        5'b2 : begin //Endpoint
                                            case(wIndex_i[7:0])
                                                8'h01 : begin
                                                    cecp_ep1_out_halt_o<=1'b1;
                                                    STATE<=SEND_STATUS_IN;
                                                end
                                                8'h81 : begin
                                                    cecp_ep1_in_halt_o<=1'b1;
                                                    STATE<=SEND_STATUS_IN;
                                                end
                                                default : STATE<=STALL;
                                            endcase
                                        end
                                        default : STATE<=STALL;
                                    endcase
                                end
                                `SET_ADDRESS : begin
                                    cecp_set_addr_o<=1'b1;
                                    //After status stage, give the commit signal to the address manager
                                    STATE<=SEND_STATUS_IN;
                                end
                                `GET_DESCRIPTOR : begin
                                    case(wValue_i[15:8])
                                        `TYPE_DEVICE :begin
                                            if(wValue_i[7:0]==8'h00)begin
                                                cecp_addr_o<=`DEVICE_BASE;
                                                cecp_length_o<=(wLength_i < `DEVICE_LENGTH)?wLength_i:`DEVICE_LENGTH;
                                                STATE<=SEND_DATA_IN;
                                            end
                                        end
                                        `TYPE_CONFIGURATION : begin
                                            if(wValue_i[7:0]==8'h00)begin
                                                cecp_addr_o<=`CONFIGURATION_BASE;
                                                cecp_length_o<=(wLength_i < `CONFIGURATION_LENGTH)?wLength_i:`CONFIGURATION_LENGTH;
                                                STATE<=SEND_DATA_IN;
                                            end
                                        end
                                        `TYPE_STRING : begin
                                            case(wValue_i[7:0])
                                                8'h00 : begin
                                                    cecp_addr_o<=`STRING0_BASE;
                                                    cecp_length_o<=(wLength_i < `STRING0_LENGTH)?wLength_i:`STRING0_LENGTH;     
                                                    STATE<=SEND_DATA_IN;
                                                end
                                                8'h01 : begin
                                                    cecp_addr_o<=`STRING1_BASE;
                                                    cecp_length_o<=(wLength_i < `STRING1_LENGTH)?wLength_i:`STRING1_LENGTH;     
                                                    STATE<=SEND_DATA_IN;
                                                end
                                                8'h02 : begin
                                                    cecp_addr_o<=`STRING2_BASE;
                                                    cecp_length_o<=(wLength_i < `STRING2_LENGTH)?wLength_i:`STRING2_LENGTH;     
                                                    STATE<=SEND_DATA_IN;
                                                end
                                                8'h03 : begin
                                                    cecp_addr_o<=`STRING3_BASE;
                                                    cecp_length_o<=(wLength_i < `STRING3_LENGTH)?wLength_i:`STRING3_LENGTH;     
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
                                    if(wLength_i==16'h0001)begin
                                        cecp_rd_curr_config_o<=1'b1;
                                        STATE<=SEND_DATA_IN;
                                    end
                                end
                                `SET_CONFIGURATION : begin
                                    if(wValue_i[7:0]<=8'h01)begin
                                        cecp_set_config_o<=1'b1;
                                        cecp_new_config_o<=wValue_i[7:0];
                                        STATE<=SEND_STATUS_IN;
                                    end
                                    else //STALL
                                        STATE<=STALL;
                                end
                                `GET_INTERFACE : begin
                                    if(wIndex_i==16'h0000) begin
                                        cecp_interface_o<=8'h00;
                                        cecp_rd_interface_o<=1'b1;
                                        STATE<=SEND_DATA_IN;
                                    end
                                    else //STALL
                                        STATE<=STALL;
                                end
                                `SET_INTERFACE : begin
                                    if(wIndex_i==16'h0000) begin
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
                            case(bRequest_i)
                                `BULK_ONLY_RESET : begin
                                    if(wValue_i==16'h0000 && wLength_i==16'h0000)begin
                                        cecp_bot_reset_o<=1'b1;
                                        STATE<=SEND_STATUS_IN;
                                    end
                                    else
                                        STATE<=STALL;
                                end
                                `GET_MAX_LUN : begin  //Max LUN = Number of LUNs − 1
                                    if(wIndex_i==16'h0000 && wLength_i==16'h0001) begin
                                        cecp_max_lun_o<=8'h00;
                                        STATE<=SEND_DATA_IN;
                                    end
                                    else
                                        STATE<=STALL;
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
