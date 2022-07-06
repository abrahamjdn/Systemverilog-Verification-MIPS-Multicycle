interface intf(input logic clk, rst);
    
  logic [31:0] extInst;
  logic [31:0] regmem_data;
  logic [31:0] datamem_data;
  logic [31:0] pc_current;
  logic [31:0] pc_next;
  logic [31:0] regf1;
  logic [31:0] regf2;
  logic [3:0]  current_state;
  logic valid;

    
endinterface
    