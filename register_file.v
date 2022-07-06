module register_file(
	input clk,rst,
	input regWrite,
	input [4:0] readReg1, readReg2, writeReg,
	input [31:0] writeData,
	output [31:0] readData1, readData2
	);
	
  reg [31:0] reg_mem [0:31]; //32 registers of 32 bits
  
/*
  initial begin
    $readmemb("regMem.txt",reg_mem);	
  end
*/
  always @(posedge rst) begin
    //$readmemb("regMem.txt",reg_mem);	
    for(int i=0;i<32;i++) reg_mem[i]=i; //32'H5555_5555;
  end
  always @ (posedge clk) begin               
    if(regWrite) begin
      reg_mem[writeReg] = writeData;
      $writememb("regMem.txt", reg_mem);
    end
  end  
  
  assign readData1 = reg_mem[readReg1];
  assign readData2 = reg_mem[readReg2];

endmodule