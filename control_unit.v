`include "ALUControl.v"
`include "control_fsm.v"

module control_unit(
	input clk, rst,
    input [5:0] Opcode, Funct,
    /*----------Multiplexer Selects-----------*/
    output MemtoReg, RegDst, ALUSrcA,
    output[1:0] ALUSrcB, PCSrc,
    /*----------Register enables--------------*/
    output IRWrite, MemWrite, PCWrite, BEQ, BNE, RegWrite,
    /*----------ALU control------------------*/
  	output [3:0] ALU_Ctl,
  	
  	output [3:0] current_state
);

wire [1:0] ALUOp;

/////////// CONTROL FSM ///////////
control_fsm MIPS_control_fsm (
	.clk(clk),
	.rst(rst),
	.Opcode(Opcode),
	.MemtoReg(MemtoReg),
	.RegDst(RegDst),
	.ALUSrcA(ALUSrcA),
	.ALUSrcB(ALUSrcB),
	.PCSrc(PCSrc),
	.IRWrite(IRWrite),
	.MemWrite(MemWrite),
	.PCWrite(PCWrite),
	.BEQ(BEQ),
	.BNE(BNE),
	.RegWrite(RegWrite),
  	.ALUOp(ALUOp),
  	.current_state(current_state)
);

/////////// ALU DECODER ///////////
ALUControl MIPS_ALUControl (
	.ALUOp(ALUOp),
	.func_code(Funct),
	.ALU_Ctl(ALU_Ctl)
);

endmodule