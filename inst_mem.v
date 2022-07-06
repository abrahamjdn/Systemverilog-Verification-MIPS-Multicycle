module inst_mem(

	input [31:0] address,
	output [31:0]	inst
	
);

  reg [31:0] Mem [0:255];
	
	initial begin
		$readmemb("instructions.txt", Mem);
	end
	
  assign inst = Mem[address];
	
endmodule