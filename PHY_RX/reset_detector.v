module reset_detector(
    input wire rd_ref_clk_i,
    input wire rd_dplus_i,
    input wire rd_dminus_i,
    input wire rd_reset,
    output reg rd_reset_state_o
);
    reg [18:0]rd_count;

    always@(posedge rd_ref_clk_i or posedge rd_reset)begin
        if(rd_reset)begin
            rd_reset_state_o<=1'b0;
            rd_count<=19'b0;
        end
        else begin
          if({rd_dplus_i,rd_dminus_i}==2'b00)begin
            if(rd_count<19'd480_000)begin
                rd_count<=rd_count+1;
            end
            else begin
                rd_reset_state_o<=1'b1;
                rd_count<=19'd480_000;
            end
          end
          else begin
            rd_count<=19'b0;
            rd_reset_state_o<=1'b0;
          end
        end
    end

endmodule