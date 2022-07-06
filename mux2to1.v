//Device description: set selector to 0 for Data_0 and 1 for Data_1

module mux2to1
#(
	parameter WORD_LENGTH = 32
)
(
	// Input Ports
  input sel,
  input [WORD_LENGTH-1 : 0] Data_0, Data_1,
	
	// Output Ports
  output [WORD_LENGTH-1 : 0] Mux_Output

);

  assign Mux_Output = (sel) ? Data_1: Data_0;

endmodule