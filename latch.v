module latch(clk, rst, en, in, out);

	input clk, rst, en;
	input [31:0] in;
	output reg [31:0] out;
	
  	always @(posedge clk,posedge rst) begin
		if (rst) 
		out <= 0;
		else if (en)
		out <= in;
	end
endmodule