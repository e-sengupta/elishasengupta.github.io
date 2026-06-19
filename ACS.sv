module ACS		                        // add-compare-select
(  input       path_0_valid,
   input       path_1_valid,
   input [1:0] path_0_bmc,	            // branch metric computation
   input [1:0] path_1_bmc,				
   input [7:0] path_0_pmc,				// path metric computation(before)
   input [7:0] path_1_pmc,

   output logic        selection,
   output logic        valid_o,
   output logic     [7:0] path_cost);  

   wire  [7:0] path_cost_0;			   // branch metric + path metric
   wire  [7:0] path_cost_1;

// Fill in the guts per ACS instructions
   assign path_cost_0 = path_0_pmc + path_0_bmc;
	assign path_cost_1 = path_1_pmc + path_1_bmc;
	
 /*  always_comb begin
        case ({path_1_valid, path_0_valid})
            2'b00: begin
                // both path are invalid
                valid_o   = 1'b0;
                selection = 1'b0;
                path_cost = 8'd0;
            end
            2'b01: begin
                // path1 is valid
                valid_o   = 1'b1;
                selection = 1'b0;   
                path_cost = path_cost_0; 
            end
            2'b10: begin
                // path 0 is valid
                valid_o   = 1'b1;
                selection = 1'b1;   
                path_cost = path_cost_1;
            end
            2'b11: begin
            // both are valid
            valid_o = 1'b1;
            if (path_cost_0 > path_cost_1) begin 
                selection = 1'b1;
                path_cost = path_cost_1;
            end else begin 
                selection = 1'b0;
                path_cost = path_cost_0;
            end
        end
            default: begin
                valid_o   = 1'b0;
                selection = 1'b0;
                path_cost = 8'd0;
            end
        endcase
    end
	 */
	 assign path_cost      =  (valid_o?(selection?path_cost_1:path_cost_0):8'd0);
	 assign valid_o=path_0_valid | path_1_valid;
	 
	/* always_comb begin
	    if(valid_o==0) path_cost=8'b0;
		 else if(valid_o==1 && selection==0)path_cost=path_cost_0;
		 else if(valid_o==1 && selection==1)path_cost=path_cost_1;	 
	 end
    */
	 always_comb begin
		 if (path_0_valid == 1'b0 && path_1_valid == 1'b1) selection = 1'b1;
		 else if (path_0_valid == 1'b1 && path_1_valid == 1'b0) selection = 1'b0;
		 else if (path_0_valid == 1'b1 && path_1_valid == 1'b1) begin
		  if (path_cost_0 > path_cost_1) selection = 1'b1;
		  else selection = 1'b0;
		 end
		 else selection=1'b0;
	 end
    
	 
endmodule
