//Device description: set selector to 0 for Data_0, 1 for Data_1 and 2 for Data_2

module mux3to1
#(
	parameter WORD_LENGTH = 32
)
(
	// Input Ports
  input [1:0] sel,
  input [WORD_LENGTH-1 : 0] Data_0, Data_1, Data_2,
	
	// Output Ports
  output reg [WORD_LENGTH-1 : 0] Mux_Output

);

always @(*) begin
  case (sel)
  0: Mux_Output = Data_0;
  1: Mux_Output = Data_1;
  2: Mux_Output = Data_2;
  default: Mux_Output = 0;
  endcase
end

endmodule