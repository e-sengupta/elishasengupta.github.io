module viterbi_tx_rx #(parameter N=4) (
    input     clk,
    input     rst,
    input     encoder_i,
    input     enable_encoder_i,
    output    decoder_o);

    wire  [1:0] encoder_o;

    int           error_counter,
                  bad_bit_ct,
                  word_ct;
    logic   [1:0] encoder_o_reg;
    logic         encoder_i_reg;
    logic         enable_decoder_in;
    logic         enable_encoder_i_reg;
    wire          valid_encoder_o;
    logic   [1:0] err_inj;

    always @ (posedge clk, negedge rst) 
        if(!rst) begin  
      $display("viterbi_tx_rx2.sv");
            error_counter        <= 'd0;
            encoder_o_reg        <= 'b0;        
            enable_decoder_in    <= 'b0;
            enable_encoder_i_reg <= 'b0;
            word_ct              <= 'b0;
        end
        else begin  
            enable_encoder_i_reg <= enable_encoder_i;  
            enable_decoder_in    <= valid_encoder_o; 
            error_counter <= $random;                                       
            word_ct              <= word_ct + 1;    
            encoder_i_reg <= encoder_i;
            if(error_counter[N-1:0]=='1)begin
                err_inj<='b0;
                
             if(word_ct<256) 
                 bad_bit_ct  <= bad_bit_ct;
                                        
             $display("error_counter,err_inj = %h %b %d %d",error_counter,err_inj,bad_bit_ct,word_ct);
              encoder_o_reg <= encoder_o^err_inj;
             end
             else begin
                 encoder_o_reg<={encoder_o[1],encoder_o[0]};
                  err_inj <= 2'b0;
              end
            end   
        
    encoder encoder1       (
        .clk,
        .rst,
        .enable_i(enable_encoder_i), 
        .d_in    (encoder_i),        
        .valid_o (valid_encoder_o),
        .d_out   (encoder_o)   );

    decoder decoder1       (
        .clk,
        .rst,
        .enable (enable_decoder_in),
        .d_in   (encoder_o_reg),
        .d_out  (decoder_o)   );

endmodule