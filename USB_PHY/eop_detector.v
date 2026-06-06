module eop_detector(
  input wire ed_clk_i,
  input wire ed_reset,
  input wire ed_dplus_i,
  input wire ed_dminus_i,
  output reg ed_eop_o
);

    localparam IDLE=2'b00;
    localparam SE0_1=2'b01;
    localparam SE0_2=2'b10;

    reg [1:0]STATE;

    always@(posedge ed_clk_i or posedge ed_reset)begin
        if(ed_reset)begin
            ed_eop_o<=1'b0;
            STATE<=IDLE;
        end
        else begin
            ed_eop_o<=1'b0;
            case(STATE) 
                IDLE: STATE<=({ed_dplus_i,ed_dminus_i}==2'b00)?SE0_1:IDLE; 
                SE0_1: STATE<=({ed_dplus_i,ed_dminus_i}==2'b00)?SE0_2:IDLE;
                SE0_2: begin
                    ed_eop_o<=({ed_dplus_i,ed_dminus_i}==2'b01)?1'b1:1'b0;
                    STATE<=IDLE;
                end
                default : begin
                    ed_eop_o<=1'b0;
                     STATE<=IDLE;
                end
            endcase
        end
    end
endmodule