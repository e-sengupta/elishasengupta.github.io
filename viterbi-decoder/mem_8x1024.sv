module mem (
   input                  clk,
   input                  wr,     // write enable
   input         [9:0]    addr,   // 2^10=1024
   input         [7:0]    d_i,    // data input (8-bit)  
   output logic  [7:0]    d_o     // data output (8-bit)
);
 
   logic [7:0] mem [0:1023];      // 1024 x 8-bit memory array
   
   always @ (posedge clk) begin
      // Write synchronously to memory core if enabled
      // Read synchronously at all times (equiv. to DFF at mem data out)
      if(wr) begin
         mem[addr] <= d_i;
      end
      d_o <= mem[addr];
   end   	
endmodule