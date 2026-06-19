module tbu (
    input               clk,
    input               rst,
    input               enable,
    input               selection,
    input       [7:0]   d_in_0,
    input       [7:0]   d_in_1,
    output logic        d_o,
    output logic        wr_en
);

    logic       d_o_reg;
    logic       wr_en_reg;
    
    logic [2:0] pstate;
    logic [2:0] nstate;

    logic       selection_buf;

    always @(posedge clk) begin
        selection_buf <= selection;
        wr_en         <= wr_en_reg;
        d_o           <= d_o_reg;
    end
///reset p state to 0 
//exception:  rst = enable = selection_buf = 1, but selection = 0, then go to n_state
    always @(posedge clk, negedge rst) begin
        if (!rst) begin
            pstate <= 3'd0;
        end else if (enable && selection_buf && !selection) begin
            pstate <= nstate;
		  end else if (enable) begin
        pstate <= nstate;
        end
    end

    always_comb begin
            wr_en_reg = selection;
            //d_o_reg = selection ? d_in_1[pstate] : d_in_0[pstate];
            if(selection)d_o_reg=d_in_1[pstate];
				//else if(!selection) d_o_reg=d_in_0[pstate];
				else d_o_reg=0;
				
            case (pstate)
                3'd0: begin
                    if (selection_buf) begin
                        if (d_in_1[pstate] == 1'b0) nstate = 3'd0; else nstate = 3'd1;
                    end else begin
                        if (d_in_0[pstate] == 1'b0) nstate = 3'd0; else nstate = 3'd1;
                    end
                end
                3'd1: begin
                    if (selection_buf) begin
                        if (d_in_1[pstate] == 1'b0) nstate = 3'd3; else nstate = 3'd2;
                    end else begin
                        if (d_in_0[pstate] == 1'b0) nstate = 3'd3; else nstate = 3'd2;
                    end
                end
                3'd2: begin
                    if (selection_buf) begin
                        if (d_in_1[pstate] == 1'b0) nstate = 3'd4; else nstate = 3'd5;
                    end else begin
                        if (d_in_0[pstate] == 1'b0) nstate = 3'd4; else nstate = 3'd5;
                    end
                end
                3'd3: begin
                    if (selection_buf) begin
                        if (d_in_1[pstate] == 1'b0) nstate = 3'd7; else nstate = 3'd6;
                    end else begin
                        if (d_in_0[pstate] == 1'b0) nstate = 3'd7; else nstate = 3'd6;
                    end
                end
                3'd4: begin
                    if (selection_buf) begin
                        if (d_in_1[pstate] == 1'b0) nstate = 3'd1; else nstate = 3'd0;
                    end else begin
                        if (d_in_0[pstate] == 1'b0) nstate = 3'd1; else nstate = 3'd0;
                    end
                end
                3'd5: begin
                    if (selection_buf) begin
                        if (d_in_1[pstate] == 1'b0) nstate = 3'd2; else nstate = 3'd3;
                    end else begin
                        if (d_in_0[pstate] == 1'b0) nstate = 3'd2; else nstate = 3'd3;
                    end
                end
                3'd6: begin
                    if (selection_buf) begin
                        if (d_in_1[pstate] == 1'b0) nstate = 3'd5; else nstate = 3'd4;
                    end else begin
                        if (d_in_0[pstate] == 1'b0) nstate = 3'd5; else nstate = 3'd4;
                    end
                end
                3'd7: begin
                    if (selection_buf) begin
                        if (d_in_1[pstate] == 1'b0) nstate = 3'd6; else nstate = 3'd7;
                    end else begin
                        if (d_in_0[pstate] == 1'b0) nstate = 3'd6; else nstate = 3'd7;
                    end
                end
                default: begin
                    nstate = 3'd0;
                end
            endcase
    end

endmodule