module branch_decoder(
  input beq, bne, pcwrite, zero,
  output ctrl
);
  
  assign ctrl = (bne&~zero) | (beq&zero) | (pcwrite);
  
endmodule