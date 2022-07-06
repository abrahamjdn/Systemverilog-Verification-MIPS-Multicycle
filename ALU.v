module ALU (

	input [3:0] ALU_Ctl, //from ALU //book 317
	input [31:0] A,B,
	
	output reg [31:0] ALUOut,
	output Zero
);
	assign Zero = (ALUOut == 0);
	
	always @(ALU_Ctl, A, B) begin
		case (ALU_Ctl)
			0: ALUOut = A & B;
			1: ALUOut = A | B;
			2: ALUOut = A + B;
			6: ALUOut = A - B;
			12:ALUOut = A < B ? 1:0;
			default: ALUOut = 0;
		endcase
	end
endmodule