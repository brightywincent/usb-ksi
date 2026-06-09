module resume_detector(
    input wire rumed_ref_clk_i,
    input wire rumed_reset,
    input wire rumed_suspend_state_i,
    input wire rumed_dplus_i,
    input wire rumed_dminus_i,
    output reg rumed_resume_o
);

    localparam SUSPEND=2'b00;
    localparam RESUMING=2'b01;
    
    reg [9:0]rumed_count;
    reg [1:0]STATE;

    always@(posedge rumed_ref_clk_i or posedge rumed_reset)begin
        if(rumed_reset)begin
            rumed_resume_o<=1'b0;
            rumed_count<=10'b0;
            STATE<=SUSPEND;
        end
        else begin
            case(STATE)
                
                SUSPEND : begin
                    rumed_count<=10'b0;
                    rumed_resume_o<=1'b0;
                    if(rumed_suspend_state_i)
                        STATE<=RESUMING;
                end

                RESUMING : begin
                    if({rumed_dplus_i,rumed_dminus_i}==2'b10)begin
                        if(rumed_count==10'd960)begin
                            rumed_resume_o<=1'b1;
                            STATE<=SUSPEND;
                        end
                        else
                            rumed_count<=rumed_count+1;
                    end
                    else
                        rumed_count<=10'b0;
                end
                default : STATE<=SUSPEND;
            endcase
        end
    end

endmodule