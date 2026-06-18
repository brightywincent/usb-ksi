module crc_checker(
    input wire cc_clk_i,
    input wire cc_reset,
    input wire cc_sbit_i,
    input wire cc_sync_i,
    output reg [4:0]cc_reg
);
    
    reg cc_on;
    
    always@(posedge cc_clk_i or posedge cc_reset)begin
        if(cc_reset)begin
            cc_on<=1'b0;
            cc_reg<=5'b0;
        end
        else begin
            if(cc_sync_i | cc_on)begin
                cc_on<=1'b1;
                cc_reg[4]<=cc_reg[3];
                cc_reg[3]<=cc_reg[4]^cc_reg[2];           
                cc_reg[2]<=cc_reg[1];
                cc_reg[1]<=cc_reg[0];
                cc_reg[0]<=cc_reg[4]^cc_sbit_i;
            end
                            
                
        end
    end
endmodule