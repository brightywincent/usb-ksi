module address_manager(
    input wire am_clk_i,
    input wire am_reset,
    input wire [6:0]am_new_addr_i,
    input wire am_ld_addr_i,
    input wire am_commit_addr_i,
    output reg [6:0]am_curr_addr_o,
    output reg am_new_addr_committed_o
);

    localparam LOAD = 1'b0;
    localparam WAIT = 1'b1;

reg [6:0]pending_addr;
reg STATE;

always @(posedge am_clk_i or posedge am_reset)begin
    if(am_reset)begin
        am_curr_addr_o<=7'b0;
        am_new_addr_committed_o<=1'b0;
        STATE<=1'b0;
    end
    else begin
        case(STATE)
            LOAD : begin
                if(am_ld_addr_i)begin
                    pending_addr<=am_new_addr_i;
                    am_new_addr_committed_o<=1'b0;
                    STATE<=WAIT;
                end
            end
            WAIT : begin
                if(am_commit_addr_i)begin
                    am_curr_addr_o<=pending_addr;
                    am_new_addr_committed_o<=1'b1;
                    STATE<=LOAD;
                end
                else
                    am_new_addr_committed_o<=1'b0;
            end
        endcase
    end
end

endmodule
