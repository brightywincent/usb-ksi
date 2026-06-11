module suspend_detector(
    input wire susd_ref_clk_i,
    input wire susd_dplus_i,
    input wire susd_dminus_i,
    input wire susd_reset,
    output reg susd_suspend_state_o
);
    reg [17:0]susd_count;

    always@(posedge susd_ref_clk_i or posedge susd_reset)begin
        if(susd_reset)begin
            susd_suspend_state_o<=1'b0;
            susd_count<=18'b0;
        end
        else begin
          if({susd_dplus_i,susd_dminus_i}==2'b01)begin
            if(susd_count<18'd144_000)begin
                susd_count<=susd_count+1;
            end
            else begin
                susd_suspend_state_o<=1'b1;
                susd_count<=18'd144_000;
            end
          end
          else begin
            susd_count<=18'b0;
            susd_suspend_state_o<=1'b0;
          end
        end
    end

endmodule