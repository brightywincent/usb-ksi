module control_engine_ep0_dp(
    input wire cedp_clk_i,
    input wire cedp_reset,

    input wire cedp_get_status_i,  //control engine
    input wire cedp_set_addr_i,


    input wire [7:0]bmRequestType_i,  //ep0 rx buffer
    input wire [7:0]bRequest_i,
    input wire [15:0]wValue_i,
    input wire [15:0]wIndex_i,
    input wire [15:0]wLength_i,

    input wire cedp_setup_done_i,  //transaction engine 

    output reg [7:0]bmRequestType_o,  //control path
    output reg [7:0]bRequest_o,
    output reg [15:0]wValue_o,
    output reg [15:0]wIndex_o,
    output reg [15:0]wLength_o,

    output reg cedp_got_status_o  //ep0 tx buffer

    output reg cedp_ld_addr_0,  //Address manager
    output reg [7:0]cedp_addr_o,
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
            
            cedp_ld_addr_i<=1'b1;
            if(cedp_setup_done_i) begin
                bmRequestType<=bmRequestType_i;
                bRequest<=bRequest_i;
                wValue<=wValue_i;
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
                        if(cecp_halt_i)
                            cedp_got_status_o<=16'h01;
                        else 
                            cedp_got_status_o<=16'h00;
                    end
                endcase
            end
            else if(cedp_set_addr_i) begin
                cedp_ld_addr_i<=1'b1;
                cedp_addr_o<=wValue[7:0];
            end
        end
    end

endmodule
