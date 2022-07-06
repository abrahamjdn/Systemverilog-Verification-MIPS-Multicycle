module ALUControl (
	input [1:0] ALUOp, //from CU
	input [5:0] func_code,  // 5:0
	output reg [3:0] ALU_Ctl // to ALU 
);

	always @(ALUOp, func_code) begin
	if(ALUOp == 0)
		ALU_Ctl = 2;    //LW and SW use add
	else if(ALUOp == 1)
		ALU_Ctl = 6;		// branch if equal implemented by substract both inputs
	else
		case(func_code)
			//pag. 317
			32: ALU_Ctl = 2; //add
			34: ALU_Ctl = 6; //subtract		
			36: ALU_Ctl = 0; //AND	
			37: ALU_Ctl = 1; //OR				
			42: ALU_Ctl = 12; //slt
			default: ALU_Ctl = 4'hf; 
		endcase
	end
endmodule

/* fields R-type:
op
31-26
rs
25-21
rt
20-16
rd
15-11
sa
10-6
fn
5-0
*/
