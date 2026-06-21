module crc16_checker(
    input wire cc16_clk_i,
    input wire cc16_reset,
    input wire cc16_sbit_i,
    input wire cc16_sync_i,
    output reg [15:0]cc16_reg
);
    
    reg cc16_on;
    
    always@(posedge cc16_clk_i or posedge cc16_reset)begin
        if(cc16_reset)begin
            cc16_on<=1'b0;
            cc16_reg<=16'b0;
        end
        else begin
            if(cc16_sync_i | cc16_on)begin
                cc16_on<=1'b1;
                cc16_reg[15]<=cc16_reg[14];
                cc16_reg[14]<=cc16_reg[13]^cc16_reg[15];
                cc16_reg[13]<=cc16_reg[12];
                cc16_reg[12]<=cc16_reg[11];
                cc16_reg[11]<=cc16_reg[10];
                cc16_reg[10]<=cc16_reg[9];
                cc16_reg[9]<=cc16_reg[8];
                cc16_reg[8]<=cc16_reg[7];
                cc16_reg[7]<=cc16_reg[6];
                cc16_reg[6]<=cc16_reg[5];
                cc16_reg[5]<=cc16_reg[4];
                cc16_reg[4]<=cc16_reg[3];
                cc16_reg[3]<=cc16_reg[2];
                cc16_reg[2]<=cc16_reg[1];
                cc16_reg[1]<=cc16_reg[0]^cc16_reg[15];
                cc16_reg[0]<=cc16_reg[15]^cc16_sbit_i;
            end
                            
                
        end
    end
endmodule