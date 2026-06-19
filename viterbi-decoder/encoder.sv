// figure out what this encoder does -- differs a bit from Homework 7
module encoder                    // use this one
(  input             clk,
   input             rst,
   input             enable_i,
   input             d_in,
   output logic      valid_o,
   output      [1:0] d_out);
   
   logic         [2:0] cstate;
   logic         [2:0] nstate;
   logic         [1:0] d_out_reg;

   assign   d_out    =  (enable_i)? d_out_reg:2'b00;

   always_comb begin
      valid_o  =   enable_i;
      case (cstate)
		   3'b000: begin // State 0
         if (d_in == 1'b0) begin
           nstate = 3'b000; 
           d_out_reg = 2'b00;//d_out_reg[0] = d_in;   d_out_reg[1] = d_in ^ cstate[2] ^ cstate[1];
         end else begin // d_in == 1'b1
           nstate = 3'b100; // State 4
           d_out_reg = 2'b11; 
         end
       end
       3'b001: begin // State 1
         if (d_in == 1'b0) begin
           nstate = 3'b100; // State 4
           d_out_reg = 2'b00;
         end else begin 
           nstate = 3'b000; // State 0
           d_out_reg = 2'b11; 
         end
       end
       3'b010: begin // State 2
         if (d_in == 1'b0) begin
           nstate = 3'b101; // State 5
           d_out_reg = 2'b10; 
         end else begin 
           nstate = 3'b001; // State 1
           d_out_reg = 2'b01; 
         end
       end
       3'b011: begin // State 3
         if (d_in == 1'b0) begin
           nstate = 3'b001; // State 1
           d_out_reg = 2'b10; 
         end else begin 
           nstate = 3'b101; // State 5
           d_out_reg = 2'b01; 
         end
       end
       3'b100: begin // State 4
         if (d_in == 1'b0) begin
           nstate = 3'b010; // State 2
           d_out_reg = 2'b10; 
         end else begin 
           nstate = 3'b110; // State 6
           d_out_reg = 2'b01; 
         end
       end
       3'b101: begin // State 5
         if (d_in == 1'b0) begin
           nstate = 3'b110; // State 6
           d_out_reg = 2'b10; 
         end else begin 
           nstate = 3'b010; // State 2
           d_out_reg = 2'b01;
         end
       end
       3'b110: begin // State 6
         if (d_in == 1'b0) begin
           nstate = 3'b111; // State 7
           d_out_reg = 2'b00; 
         end else begin 
           nstate = 3'b011; // State 3
           d_out_reg = 2'b11; 
         end
       end
       3'b111: begin // State 7
         if (d_in == 1'b0) begin
           nstate = 3'b011; // State 3
           d_out_reg = 2'b00; 
         end else begin // d_in == 1'b1
           nstate = 3'b111; // State 7
           d_out_reg = 2'b11; // d_out_reg[1]=1, d_out_reg[0]=1
         end
       end
       default: begin 
           nstate = 3'bxxx;
           d_out_reg = 2'bxx;
       end
		
// fill in the guts

      endcase
   end								   

   always @ (posedge clk,negedge rst)   begin
//      $display("data in=%d state=%b%b%b data out=%b%b",d_in,reg_1,reg_2,reg_3,d_out_reg[1],d_out_reg[0]);
      if(!rst)
         cstate   <= 3'b000;
      else if(!enable_i)
         cstate   <= 3'b000;
      else
         cstate   <= nstate;
   end

endmodule
