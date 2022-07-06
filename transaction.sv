/*
    Items declaration for transactions
*/
class transaction;
    rand bit [31:0] extInst;
  	randc bit [5:0] opcode;
    randc bit [5:0] funct;
    rand bit [4:0] rd;
    rand bit [4:0] rs;
    rand bit [4:0] rt;
    rand bit [15:0] imm;
    rand bit [4:0] shamt;
    rand bit [25:0] jta;
    bit [31:0] regmem_data;
  	bit [31:0] datamem_data;
    bit [31:0] pc_current;
  	bit [31:0] pc_next;
  	bit [31:0] regf1;
  	bit [31:0] regf2;
 	bit [3:0] current_state;

   //constraints
  constraint opcode_const {opcode inside{0, 2, 4, 5, 35, 43};} //r,jump,beq,bne,lw,sw  ***************
    constraint rd_const {rd inside {[2:25]};}
    constraint rs_const {rs inside {[2:25]};}
    constraint rt_const {rt inside {[2:25]};}
  	constraint imm_const {imm inside {[4:150]};}
  	constraint jta_const {jta inside {[4:150]};}
  	constraint shamt_const {shamt == 5'b00000;}
    constraint funct_type_r {
      (opcode == 0) -> funct inside {32,34,36,37,42}; //add,sub,and,or,slt
    }
    constraint type_func{
      (opcode == 0) -> extInst == {opcode, rs, rt, rd, shamt, funct};
      (opcode == 2) -> extInst == {opcode, jta};
      (opcode inside {4, 5, 35, 43}) -> extInst =={opcode, rs, rt, imm[15:0]};    
    }
     
      function void display(string name);
        $display("----------------");
        $display("%s", name);
        $display("----------------");
        $display("Instruction = %32b", extInst);          
        $display("----------------"); 
    endfunction

endclass 