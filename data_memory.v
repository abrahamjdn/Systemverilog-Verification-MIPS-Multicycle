module data_memory (

	input clk, rst,
  	input [31:0] address,
	input memWrite,
	input [31:0] writeData, 
	
	output [31:0] readData
	);
	
  reg [31:0] mem[0:255]; //32 bits memory with 256 entries

  always @(posedge rst) begin
    //$readmemb("data_mem.txt", mem);  
    for(int i=0;i<256;i++) mem[i]=i;
  end
	always @ (posedge clk) begin
	
      	if (memWrite) begin
          	mem[address[7:0]] = writeData;
      		$writememb("data_mem.txt", mem);
        end
	end
	
	
  assign readData = mem[address[7:0]];
	
endmodule