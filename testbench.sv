
`include "interface.sv"

`include "test.sv"


module tbench_top;
  
  bit clk;
  bit reset;

  always #10 clk = ~clk;

  initial begin
    reset = 1;
    #5 reset =0;
  end
  
  
  //creatinng instance of interface, inorder to connect DUT and testcase
  intf i_intf(clk,reset);
  
  //Testcase instance, interface handle is passed to test as an argument
  test t1(i_intf);
  
  //DUT instance, interface signals are connected to the DUT ports
  MIPS_multicycle UUT (
	.clk(i_intf.clk),
    .rst(i_intf.rst),
    .extInst_en(1'b1),
    .extInst(i_intf.extInst),
    .current_state(i_intf.current_state),
    .to_reg_file(i_intf.regmem_data),//lw y R type
    .to_memdata(i_intf.datamem_data),
    .pc_current(i_intf.pc_current),
    .pc_next(i_intf.pc_next),
    .regf1(i_intf.regf1),
    .regf2(i_intf.regf2)
    );
  

  ////UUT.MIPS_data_memory.mem[];
  

  //enabling the wave dump
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule
















/*
////////////////////////////////////////////////////////////////////////
// TESTBENCH =>  TOP MODULE FOR MIPS multicycle OPERATION
////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns

module MIPS_multicycle_tb;

reg clk_tb, rst_tb, extInst_en_tb;
reg[31:0] extInst_tb;
integer i;

MIPS_multicycle UUT (
    .clk(clk_tb),
    .rst(rst_tb),
    .extInst_en(extInst_en_tb),
    .extInst(extInst_tb)
    );

initial begin

    clk_tb = 0;//initialize clock
    extInst_en_tb = 0;//Use internal instruction mode
    extInst_tb = 0;//External instruction
    rst_tb = 1;//activate reset
    #2;

    rst_tb = 0;//deactivate reset
    #1800;
  
  
  for (i=0; i <32; i=i+1) begin
    $display("------------------------------------------------------------------------------------");
    $display("PC=%d :: REG MEMORY=>%d :: DATA MEMORY=>%d", i, UUT.MIPS_register_file.reg_mem[i], UUT.MIPS_data_memory.mem[i]);
  end
  
    $finish();
end

always forever #1 clk_tb = ~clk_tb;

initial begin
  	$dumpvars(3, MIPS_multicycle_tb);
    $dumpfile("dump.vcd");
end

endmodule



*/