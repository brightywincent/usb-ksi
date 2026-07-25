module config_manager(
    input wire cm_clk_i,
    input wire cm_reset,
    input wire cm_ld_config_i,
    input wire [7:0]cm_new_config_i,
    output reg [7:0]cm_curr_config_o,
    output reg cm_configured_o
);

    always @(posedge cm_clk_i or cm_reset)begin
        if(cm_reset)begin
            cm_curr_config_o<=8'b0;
            cm_configured_o<=1'b0;
        end
        else begin
            if(cm_ld_config_i)begin
                cm_curr_config_o<=cm_new_config_i;
                cm_configured_o<=(cm_new_config_i!=8'b0);
            end
        end
    end

endmodule
