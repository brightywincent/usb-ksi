module control_engine_ep0_dp(
    input wire cedp_clk_i,
    input wire cedp_reset,

    input wire cedp_get_status_i,  //control engine
    input wire cedp_set_addr_i,
    input wire cedp_get_descriptor_i,

    input wire [7:0]bmRequestType_i,  //ep0 rx buffer
    input wire [7:0]bRequest_i,
    input wire [15:0]wValue,
    input wire [15:0]wIndex_i,
    input wire [15:0]wLength_i,

    input wire cedp_setup_done_i,  //transaction engine 

    output reg [7:0]bmRequestType_o,  //control path
    output reg [7:0]bRequest_o,
    output reg [15:0]wValue_o,
    output reg [15:0]wIndex_o,
    output reg [15:0]wLength_o,

    output reg cedp_got_status_o  //ep0 tx buffer

    output reg cedp_ld_addr_o,  //Address manager
    output reg [7:0]cedp_addr_o,

    output reg [7:0]cedp_addr_base_o, //descriptor rom
    output reg cedp_length_o,

    output reg [7:0]cedp_max_lun_o

);
    reg [7:0]bmRequestType;
    reg [7:0]bRequest;
    reg [15:0]wValue;
    reg [15:0]wIndex;
    reg [15:0]wLength;
    always@(posedge cedp_clk_i or posedge cedp_reset)begin
        if(cedp_reset)begin

        end
        else begin
            bmRequestType_o<=bmRequestType;
            bRequest_o<=bRequest;
            wValue_o<=wValue;
            wIndex_o<=wIndex;
            wLength_o<=wLength;
            
            cedp_ld_addr_o<=1'b0;
            if(cedp_setup_done_i) begin
                bmRequestType<=bmRequestType_i;
                bRequest<=bRequest_i;
                wValue<=wValue;
                wIndex<=wIndex_i;
                wLength<=wLength_i;
            end
            else if(cedp_get_status_i)begin
                case(bmRequestType_i[4:0])
                    5'b0 : begin //Device
                        cedp_got_status_o<=16'h0000;
                    end
                    5'b1 : begin //Interface
                        cedp_got_status_o<=16'h0000;
                    end
                    5'b2 : begin //Endpoint
                        if(cedp_halt_i)
                            cedp_got_status_o<=16'h01;
                        else 
                            cedp_got_status_o<=16'h00;
                    end
                    default : cedp_got_status_o<=16'h0000;
                endcase
            end
            else if(cedp_set_addr_i) begin
                cedp_ld_addr_o<=1'b1;
                cedp_addr_o<=wValue[7:0];
            end
            else if(cedp_get_descriptor_i) begin
                case(wValue[15:8])
                    `TYPE_DEVICE :begin
                        if(wValue[7:0]==8'h00)begin
                            cedp_addr_base_o<=`DEVICE_BASE;
                            cedp_length_o<=(wLength_i < `DEVICE_LENGTH)?wLength_i:`DEVICE_LENGTH;
                        end
                    end
                    `TYPE_CONFIGURATION : begin
                        if(wValue[7:0]==8'h00)begin
                            cedp_addr_base_o<=`CONFIGURATION_BASE;
                            cedp_length_o<=(wLength_i < `CONFIGURATION_LENGTH)?wLength_i:`CONFIGURATION_LENGTH;
                        end
                    end
                    `TYPE_STRING : begin
                        case(wValue[7:0])
                            8'h00 : begin
                                cedp_addr_base_o<=`STRING0_BASE;
                                cedp_length_o<=(wLength_i < `STRING0_LENGTH)?wLength_i:`STRING0_LENGTH;     
                            end
                            8'h01 : begin
                                cedp_addr_base_o<=`STRING1_BASE;
                                cedp_length_o<=(wLength_i < `STRING1_LENGTH)?wLength_i:`STRING1_LENGTH;     
                            end
                            8'h02 : begin
                                cedp_addr_base_o<=`STRING2_BASE;
                                cedp_length_o<=(wLength_i < `STRING2_LENGTH)?wLength_i:`STRING2_LENGTH;     
                            end
                            8'h03 : begin
                                cedp_addr_base_o<=`STRING3_BASE;
                                cedp_length_o<=(wLength_i < `STRING3_LENGTH)?wLength_i:`STRING3_LENGTH;     
                            end
                        endcase
                    end
                endcase                
            end
            else if(cedp_get_interface_i) begin
                //cedp_curr_alt_o<=wValue[7:0];  //write such that it fetches curr alt setting in the descriptor rom
                cedp_rd_interface_o<=1'b1;
            end
            else if(cedp_set_interface_i) begin  //Should be revised

            end
            else if(cedp_send_mlun_i) begin
                cedp_max_lun_o<=8'h00; //should be revised 
            end
        end
    end

endmodule
