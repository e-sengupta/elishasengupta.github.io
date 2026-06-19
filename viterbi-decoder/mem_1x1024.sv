/*make the data path K bits wide for mem_Kx1024
   K=8 for module mem, K=1 for module mem_disp */ 
module mem_disp					(
   input                  clk,
   input                  wr,	 // write enable
   input         [9:0]    addr,//2^10=1024
   input                  d_i,		// data
   output logic           d_o);
 
   logic                  mem   [0:1023];

   always @ (posedge clk) begin
/*
   write synchronously to memory core if enabled
   read synchronously at all times (equiv. to DFF at mem data out)
*/ 
		if(wr)begin
			mem[addr] <= d_i;
		end
		d_o <= mem[addr];
   end   	
endmodule
