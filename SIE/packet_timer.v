module packet_timer #(
    parameter PACKET_TIMEOUT = 14'd10_000
)
(
    input wire pt_clk_i,
    input wire pt_reset,
    input wire pt_sync_i,
    input wire pt_eop_i,
    output reg pt_timeout_o
);

    reg [13:0]pt_count;
    reg pt_timer_on;

    always@(posedge pt_clk_i or posedge pt_reset)begin
        if(pt_reset)begin
            pt_count<=14'b0;
            pt_timeout_o<=1'b0;
            pt_timer_on<=1'b0;
        end
        else begin
            pt_timeout_o<=1'b0;
            if(pt_sync_i)begin
                pt_timer_on<=1'b1;
                pt_count<=14'b0;
            end
            else if(pt_eop_i)begin
                pt_timer_on<=1'b0;
                pt_count<=14'b0;
            end
            else begin
                if(pt_timer_on)begin
                    if(pt_count==PACKET_TIMEOUT-1)begin
                        pt_timeout_o<=1'b1;
                        pt_timer_on<=1'b0;
                        pt_count<=14'b0;
                    end
                    else
                        pt_count<=pt_count+1;
                end
            end
        end
    end

endmodule